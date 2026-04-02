"""VITA firmware MQTT protocol constants and mappings."""

from typing import Dict, Any
from enum import Enum


# Session Commands
class SessionCommand(str, Enum):
    """Installer session management commands."""
    INIT_SESSION = "IS"          # Initialize session
    CLOSE_SESSION = "CS"         # Close session
    AMPLIFY_SESSION = "AS"       # Extend session time


# Parameter Commands
class ParameterCommand(str, Enum):
    """Parameter read/write commands."""
    GET_PARAMS = "GE"           # Get all parameters
    SET_PARAMS = "SE"           # Set parameters


# Device Control Commands
class ControlCommand(str, Enum):
    """Basic device control commands."""
    OPEN = "OPEN"               # Open gate/door
    CLOSE = "CLOSE"             # Close gate/door
    STOP = "stop"               # Stop movement
    OCS = "OCS"                 # Open-Close-Stop sequence
    PEDESTRIAN = "PEDESTRIAN"   # Pedestrian opening
    LAMP = "LAMP"               # Toggle lamp
    RELAY = "RELE"              # Toggle relay


# Learn Control Commands
class LearnCommand(str, Enum):
    """Learn control commands."""
    LEARN_TOTAL_OPEN = "Ct"     # Learn total open control
    LEARN_PEDESTRIAN = "CP"     # Learn pedestrian control
    LEARN_LAMP = "CL"           # Learn lamp control
    LEARN_RELAY_PCB = "Cr"      # Learn relay PCB control
    LEARN_BLOCK = "Cb"          # Learn block control
    LEARN_OPEN = "Ai"           # Learn open control
    LEARN_CLOSE = "AE"          # Learn close control
    LEARN_STOP = "AA"           # Learn stop control
    LEARN_KEEP_OPEN = "At"      # Learn keep open control
    LEARN_TRAVEL_LIMIT = "AL"   # Learn travel limit
    ADD_TRAVEL = "5r"           # Add travel distance
    SUBTRACT_TRAVEL = "rr"      # Subtract travel distance


# Photocell Commands
class PhotocellCommand(str, Enum):
    """Photocell management commands."""
    PAIR_OPEN = "PA"            # Pair photocell for opening
    PAIR_CLOSE = "AC"           # Pair photocell for closing
    TEST_CLOSE = "t1"           # Test close photocell
    TEST_OPEN = "t2"            # Test open photocell


# Advanced Option Commands
class AdvancedCommand(str, Enum):
    """Advanced configuration commands."""
    FACTORY_RESET = "CF"        # Factory configuration reset
    CLEAR_RF_CONTROLS = "bC"    # Clear all RF controls
    CLEAR_PCB_PARAMS = "bP"     # Clear PCB parameters
    RESET_ESP = "rE"            # Reset ESP32
    RESET_MAINTENANCE = "rC"    # Reset maintenance counter
    DELETE_WIFI = "DelWifi"     # Delete WiFi configuration
    LIMIT_SWITCH = "LC"         # Configure limit switches


# Motor Status Mapping
class MotorStatus(int, Enum):
    """Motor status values from firmware."""
    OPEN = 0                    # Gate is open
    OPENING = 1                 # Gate is opening
    CLOSED = 2                  # Gate is closed
    CLOSING = 3                 # Gate is closing
    STOPPED = 4                 # Motor stopped (undetermined position)
    PED_OPEN = 5               # Pedestrian open
    PED_OPENING = 6            # Pedestrian opening


# Motor Type Mapping
class MotorType(int, Enum):
    """Motor type values from firmware."""
    PISTON = 0                  # Piston motor
    RACK = 1                    # Rack motor
    CURTAIN = 2                 # Curtain motor
    BARRIER = 3                 # Barrier motor
    SLIDING_DOOR = 4            # Sliding door motor
    ELECTRONIC_DOOR = 5         # Electronic door motor
    OTHER = 6                   # Other type


# Current Type
class CurrentType(int, Enum):
    """Current type values."""
    AC = 0                      # AC current
    DC = 1                      # DC current


# PCB ID
class PCBId(int, Enum):
    """PCB identification values."""
    FAC500 = 0                  # FAC500 PCB


# Parameter Field Mappings
PARAMETER_FIELDS = {
    "dP": {
        "name": "Motor Direction",
        "type": "int",
        "range": "0-1",
        "description": "0=Right, 1=Left",
        "values": {0: "Right", 1: "Left"}
    },
    "P5": {
        "name": "Soft Stop",
        "type": "int", 
        "range": "0-10",
        "description": "Soft stop configuration, 0=disabled"
    },
    "LC": {
        "name": "Limit Switches",
        "type": "int",
        "range": "0-1", 
        "description": "0=NO (Normally Open), 1=NC (Normally Closed)",
        "values": {0: "NO", 1: "NC"}
    },
    "CA": {
        "name": "Auto Close",
        "type": "int",
        "range": "0-1",
        "description": "0=OFF, 1=ON",
        "values": {0: "OFF", 1: "ON"}
    },
    "tC": {
        "name": "Auto Close Time",
        "type": "int",
        "range": "0-9",
        "description": "0=10s, 1=20s, 2=30s, 3=1min, 4=1.5min, 5=2min, 6=2.5min, 7=3min, 8=3.5min, 9=4min",
        "values": {
            0: "10s", 1: "20s", 2: "30s", 3: "1min", 4: "1.5min",
            5: "2min", 6: "2.5min", 7: "3min", 8: "3.5min", 9: "4min"
        }
    },
    "AP": {
        "name": "Pedestrian Opening",
        "type": "int",
        "range": "1-5",
        "description": "1=0%, 2=25%, 3=50%, 4=75%, 5=100%",
        "values": {1: "0%", 2: "25%", 3: "50%", 4: "75%", 5: "100%"}
    },
    "FE": {
        "name": "Push Force",
        "type": "int",
        "range": "0-9",
        "description": "Motor push force adjustment"
    },
    "Co": {
        "name": "Condo Mode",
        "type": "int",
        "range": "0-1", 
        "description": "0=OFF, 1=ON (Only opens, no close with OCS)",
        "values": {0: "OFF", 1: "ON"}
    },
    "rA": {
        "name": "Auxiliary Relay Mode",
        "type": "int",
        "range": "0-2",
        "description": "Relay operation mode"
    },
    "CC": {
        "name": "Maintenance Limit",
        "type": "int",
        "range": "0-9",
        "description": "Cycles before maintenance alert"
    },
    "FF": {
        "name": "Photocell Close",
        "type": "int",
        "range": "0-1",
        "description": "0=OFF, 1=ON",
        "values": {0: "OFF", 1: "ON"}
    },
    "FL": {
        "name": "Lamp Mode",
        "type": "int",
        "range": "0-1",
        "description": "0=Fixed, 1=Flashing",
        "values": {0: "Fixed", 1: "Flashing"}
    },
    "LE": {
        "name": "Courtesy Light",
        "type": "int",
        "range": "0-5",
        "description": "Minutes light stays on after operation"
    },
    "bL": {
        "name": "Block",
        "type": "int",
        "range": "0-1",
        "description": "0=OFF, 1=ON (can only block when closed)",
        "values": {0: "OFF", 1: "ON"}
    },
    "tA": {
        "name": "Keep Open",
        "type": "int",
        "range": "0-1",
        "description": "0=OFF, 1=ON (can only activate when open)",
        "values": {0: "OFF", 1: "ON"}
    },
    "labelVita": {
        "name": "Device Label",
        "type": "string",
        "description": "Label set by installer"
    },
    "setWifi": {
        "name": "Save WiFi",
        "type": "int",
        "range": "0-1",
        "description": "0=Don't save, 1=Save WiFi credentials",
        "values": {0: "Don't save", 1: "Save"}
    },
    "ssid": {
        "name": "WiFi Network",
        "type": "string",
        "description": "WiFi network name"
    },
    "ssidPassword": {
        "name": "WiFi Password", 
        "type": "string",
        "description": "WiFi network password"
    }
}

# Read-only Status Fields (from GE response)
STATUS_FIELDS = {
    "Cur_MotorStatus": {
        "name": "Motor Status",
        "type": "int",
        "description": "Current motor state",
        "values": {
            0: "Open", 1: "Opening", 2: "Closed", 3: "Closing",
            4: "Stopped", 5: "PedOpen", 6: "PedOpening"
        }
    },
    "current_Type": {
        "name": "Current Type",
        "type": "int",
        "description": "0=AC, 1=DC",
        "values": {0: "AC", 1: "DC"}
    },
    "motor_Type": {
        "name": "Motor Type",
        "type": "int", 
        "description": "Motor type",
        "values": {
            0: "piston", 1: "rack", 2: "curtain", 3: "barrier",
            4: "sliding_door", 5: "electronic_door", 6: "other"
        }
    },
    "IdPCB": {
        "name": "PCB ID",
        "type": "int",
        "description": "0=fac500",
        "values": {0: "fac500"}
    },
    "Maintenance_Count": {
        "name": "Total Maintenance",
        "type": "int",
        "description": "Total maintenance count (0-99)"
    },
    "Total_Cycles": {
        "name": "Total Cycles",
        "type": "int",
        "description": "Total operation cycles (0-9999999)"
    },
    "Par_MaintenanceLimit": {
        "name": "Maintenance Limit",
        "type": "int",
        "description": "Cycle limit for maintenance (0-9000)"
    },
    "Cycles_SinceMaintenance": {
        "name": "Cycles Since Maintenance",
        "type": "int",
        "description": "Cycles since last maintenance (0-9999)"
    },
    "Fc_OpenState": {
        "name": "Open Photocell State",
        "type": "int",
        "description": "0=free, 1=interrupted",
        "values": {0: "Free", 1: "Interrupted"}
    },
    "Fc_CloseState": {
        "name": "Close Photocell State", 
        "type": "int",
        "description": "0=free, 1=interrupted",
        "values": {0: "Free", 1: "Interrupted"}
    },
    "fc_Open_Battery": {
        "name": "Open Photocell Battery",
        "type": "int",
        "description": "Battery level 0-99%"
    },
    "fc_Close_Battery": {
        "name": "Close Photocell Battery",
        "type": "int", 
        "description": "Battery level 0-99%"
    },
    "Lamp_Status": {
        "name": "Lamp Status",
        "type": "int",
        "description": "0=off, 1=on",
        "values": {0: "Off", 1: "On"}
    },
    "Relay_Status": {
        "name": "Relay Status",
        "type": "int",
        "description": "0=off, 1=on", 
        "values": {0: "Off", 1: "On"}
    },
    "FV": {
        "name": "Firmware Version",
        "type": "string",
        "description": "Firmware version (YYYYMMDDHHmm)"
    }
}


def get_command_for_action(action: str) -> str:
    """Get MQTT AC command for action key.
    
    Args:
        action: Action key (OPEN, CLOSE, LAMP, etc.)
        
    Returns:
        str: MQTT AC command
    """
    command_map = {
        "OPEN": ControlCommand.OPEN,
        "CLOSE": ControlCommand.CLOSE,
        "STOP": ControlCommand.STOP,
        "OCS": ControlCommand.OCS,
        "PEDESTRIAN": ControlCommand.PEDESTRIAN,
        "LAMP": ControlCommand.LAMP,
        "RELAY": ControlCommand.RELAY,
    }
    return command_map.get(action, action)


def format_parameter_value(field: str, value: Any) -> str:
    """Format parameter value with human-readable description.
    
    Args:
        field: Parameter field name
        value: Parameter value
        
    Returns:
        str: Formatted value with description
    """
    field_info = PARAMETER_FIELDS.get(field) or STATUS_FIELDS.get(field)
    if not field_info:
        return str(value)
    
    if "values" in field_info and value in field_info["values"]:
        return f"{value} ({field_info['values'][value]})"
    
    return str(value)