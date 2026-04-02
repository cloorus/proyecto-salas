"""MQTT client for VITA device communication."""

import json
import asyncio
from typing import Optional, Dict, Any, Callable
from contextlib import asynccontextmanager
import aiomqtt

from .config import settings
from .redis import cache_set, cache_get

# Global MQTT client
mqtt_client: Optional[aiomqtt.Client] = None
message_handlers: Dict[str, Callable] = {}


class VitaMQTTClient:
    """VITA MQTT client wrapper."""
    
    def __init__(self):
        self.client = None
        self.is_connected = False
        
    async def connect(self) -> None:
        """Connect to MQTT broker."""
        try:
            self.client = aiomqtt.Client(
                hostname=settings.MQTT_BROKER,
                port=settings.MQTT_PORT,
                username=settings.MQTT_USER,
                password=settings.MQTT_PASS,
                keepalive=60,
                clean_session=True,
            )
            await self.client.__aenter__()
            self.is_connected = True
            
            # Subscribe to all device response topics
            await self.client.subscribe("vita/+/response")
            await self.client.subscribe("vita/+/heartbeat")
            
        except Exception as e:
            print(f"Failed to connect to MQTT broker: {e}")
            raise
    
    async def disconnect(self) -> None:
        """Disconnect from MQTT broker."""
        if self.client and self.is_connected:
            try:
                await self.client.__aexit__(None, None, None)
                self.is_connected = False
            except Exception as e:
                print(f"Error disconnecting from MQTT: {e}")
    
    async def publish_command(self, device_serial: str, command: Dict[str, Any]) -> None:
        """Publish command to device.
        
        Args:
            device_serial: Device serial number
            command: Command payload
        """
        if not self.client or not self.is_connected:
            raise RuntimeError("MQTT client not connected")
        
        topic = f"vita/{device_serial}/command"
        payload = json.dumps(command)
        
        await self.client.publish(topic, payload)
        print(f"Published to {topic}: {payload}")
    
    async def listen_for_responses(self) -> None:
        """Listen for device responses and heartbeats."""
        if not self.client or not self.is_connected:
            return
            
        try:
            async for message in self.client.messages:
                await self._handle_message(message)
        except Exception as e:
            print(f"Error listening for MQTT messages: {e}")
    
    async def _handle_message(self, message: aiomqtt.Message) -> None:
        """Handle incoming MQTT message.
        
        Args:
            message: MQTT message
        """
        try:
            topic_parts = message.topic.value.split("/")
            if len(topic_parts) != 3 or topic_parts[0] != "vita":
                return
            
            device_serial = topic_parts[1]
            message_type = topic_parts[2]  # response or heartbeat
            
            payload = json.loads(message.payload.decode())
            
            if message_type == "response":
                await self._handle_device_response(device_serial, payload)
            elif message_type == "heartbeat":
                await self._handle_device_heartbeat(device_serial, payload)
                
        except Exception as e:
            print(f"Error handling MQTT message: {e}")
    
    async def _handle_device_response(self, device_serial: str, payload: Dict[str, Any]) -> None:
        """Handle device response message.
        
        Args:
            device_serial: Device serial number
            payload: Response payload
        """
        # Store response in cache for API to retrieve
        cache_key = f"device:{device_serial}:last_response"
        await cache_set(cache_key, payload, expire=300)  # 5 minutes
        
        # Update device state if this is a GE response
        if payload.get("AC") == "GE":
            cache_key = f"device:{device_serial}:state"
            state = {
                "motor_status": payload.get("Cur_MotorStatus"),
                "lamp_status": payload.get("Lamp_Status"),
                "relay_status": payload.get("Relay_Status"),
                "is_online": True,
                "last_heartbeat": asyncio.get_event_loop().time(),
            }
            await cache_set(cache_key, state, expire=3600)  # 1 hour
        
        print(f"Device {device_serial} response: {payload}")
    
    async def _handle_device_heartbeat(self, device_serial: str, payload: Dict[str, Any]) -> None:
        """Handle device heartbeat message.
        
        Args:
            device_serial: Device serial number
            payload: Heartbeat payload
        """
        # Update device online status
        cache_key = f"device:{device_serial}:state"
        current_state = await cache_get(cache_key) or {}
        current_state.update({
            "is_online": True,
            "last_heartbeat": asyncio.get_event_loop().time(),
        })
        await cache_set(cache_key, current_state, expire=3600)  # 1 hour
        
        print(f"Device {device_serial} heartbeat")


# Global client instance
vita_mqtt: Optional[VitaMQTTClient] = None


async def init_mqtt() -> None:
    """Initialize MQTT client."""
    global vita_mqtt
    vita_mqtt = VitaMQTTClient()
    await vita_mqtt.connect()


async def close_mqtt() -> None:
    """Close MQTT client."""
    global vita_mqtt
    if vita_mqtt:
        await vita_mqtt.disconnect()
        vita_mqtt = None


async def get_mqtt_client() -> VitaMQTTClient:
    """Get MQTT client instance.
    
    Returns:
        VitaMQTTClient: MQTT client instance
        
    Raises:
        RuntimeError: If MQTT client is not initialized
    """
    global vita_mqtt
    if not vita_mqtt:
        raise RuntimeError("MQTT client not initialized. Call init_mqtt() first.")
    return vita_mqtt


async def publish_device_command(device_serial: str, ac_command: str, **params) -> None:
    """Publish command to VITA device.
    
    Args:
        device_serial: Device serial number
        ac_command: AC command (OPEN, CLOSE, etc.)
        **params: Additional command parameters
    """
    client = await get_mqtt_client()
    
    command = {
        "AC": ac_command,
        **params
    }
    
    await client.publish_command(device_serial, command)