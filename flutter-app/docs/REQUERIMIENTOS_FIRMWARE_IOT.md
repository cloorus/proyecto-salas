# Requerimientos Técnicos para el Equipo de Firmware (BLE Provisioning)

Para integrar exitosamente el flujo de "Agregar Dispositivo vía Escaneo Bluetooth", el firmware del dispositivo debe cumplir con los siguientes estándares de comunicación Bluetooth Low Energy (BLE).

## 1. Protocolo de Anuncio (Advertising)

El dispositivo debe ser "visible" para la App cuando está en modo configuración.

*   **Nombre del Dispositivo (Local Name):** Debe tener un prefijo consistente y único.
    *   *Ejemplo:* `BGN-SETUP-XXXX` (Donde XXXX son los últimos 4 dígitos de la MAC).
*   **Service UUID en Advertising:** El paquete de anuncio debe incluir el UUID del Servicio de Configuración (ver punto 2) para que la App pueda filtrar el escaneo rápidamente sin conectarse a dispositivos ajenos.

## 2. Estructura GATT (Servicios y Características)

Se requiere un **Servicio GATT Primario** dedicado exclusivamente al provisionamiento.

### Servicio de Configuración
**UUID Sugerido:** `0000FAB0-0000-1000-8000-00805F9B34FB` (O uno generado aleatoriamente propio).

Este servicio debe exponer al menos 3 Características (Characteristics):

#### A. Característica de Credenciales (Write Only)
*   **Propósito:** Recibir SSID y Password.
*   **Propiedades:** `Write` (con respuesta) o `WriteWithoutResponse`.
*   **Formato de Datos:** JSON string es lo más fácil de depurar, aunque consume más bytes.
    *   *Payload Ejemplo:* `{"s": "MiCasa_Wifi", "p": "clave123"}`
*   **UUID Sugerido:** `...-FAB1`

#### B. Característica de Estado (Notify / Read)
*   **Propósito:** Informar a la App el progreso de la conexión.
*   **Propiedades:** `Read`, `Notify` (Indispensable `Notify` para no hacer polling).
*   **Valores Enum (Uint8):**
    *   `0x00`: Esperando credenciales (Idle).
    *   `0x01`: Conectando a Wifi...
    *   `0x02`: Conectado a Wifi (Éxito local).
    *   `0x03`: Conectado a Servidor/Nube (Éxito total).
    *   `0x04`: Error Contraseña Incorrecta.
    *   `0x05`: Error Wifi no encontrado.
*   **UUID Sugerido:** `...-FAB2`

#### C. Característica de Identidad (Read Only)
*   **Propósito:** Que la App sepa qué dispositivo es antes de vincularlo.
*   **Propiedades:** `Read`.
*   **Datos:** JSON con Serial Number, MAC Address, Versión Firmware.
    *   *Payload:* `{"sn": "BGNVITA2024X", "mac": "AA:BB:CC...", "ver": "1.2.0"}`
*   **UUID Sugerido:** `...-FAB3`

## 3. Seguridad (Handshake)

No queremos que cualquier vecino configure el dispositivo.

*   **Recomendación:** Implementar un "Proof of Possession" (PoP).
    *   El dispositivo genera un PIN aleatorio de 4 dígitos (o usa uno impreso en la etiqueta QR).
    *   La App debe escribir ese PIN primero en una característica de Auth antes de permitir escribir las credenciales Wifi.

## 4. Timeout / Salida de Modo Escucha
*   Si el dispositivo no recibe configuración en X minutos (ej. 5 min), debe apagar el Bluetooth para ahorrar energía y seguridad.

---

### Resumen para el Correo al Equipo de Firmware:

> "Estimado equipo, para la App móvil necesitamos que el dispositivo exponga un servicio BLE con características separadas para escribir credenciales (SSID/Pass) y leer el estado de conexión (Éxito/Error).
>
> Por favor confirmen:
> 1. ¿Qué **Service UUID** usarán?
> 2. ¿Cuáles son los **Characteristic UUIDs** de escritura y lectura?
> 3. ¿El formato de datos será JSON o bytes puros (Raw)?
> 4. ¿El dispositivo soportará notificaciones (Notify) para avisarnos cuando se conecte al Wifi?"
