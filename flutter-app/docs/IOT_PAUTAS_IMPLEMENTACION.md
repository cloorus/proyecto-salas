# Pautas de Implementación: Provisionamiento IoT (Wifi + Bluetooth)

Este documento describe la estrategia recomendada para implementar la funcionalidad de "Agregar Dispositivo Escaneando" que mencionas.

## 1. Selección de Tecnología: ¿Bluetooth (BLE) o SoftAP?

Para pasar las credenciales de Wifi al dispositivo, tienes dos caminos principales. 

**🔴 Opción A: SoftAP (Punto de Acceso)**
El dispositivo crea su propia red Wifi (ej. `BGnius_Setup`). El celular se desconecta de su internet y se conecta a esa red para pasar los datos.
*   **Pros:** Funciona en cualquier chip Wifi.
*   **Contras:** **Mala Experiencia de Usuario (UX)**. El usuario pierde internet durante el proceso. En Android modernos, el sistema operativo a veces rechaza la conexión porque "no tiene internet". Requiere muchos permisos delicados.

**🟢 Opción B: Bluetooth Low Energy (BLE) (Recomendada)**
El celular se conecta al dispositivo vía Bluetooth mientras mantiene su conexión a internet (4G/Wifi). Envía las credenciales Wifi por un canal BLE.
*   **Pros:** **Excelente UX**. Es rápido, transparente y el usuario nunca pierde conexión. Es el estándar moderno (usado por Google Home, Alexa, Tuya, etc.).
*   **Contras:** Requiere que tu hardware tenga Bluetooth.

---

## 2. Flujo Recomendado (Arquitectura BLE)

Asumiendo que usemos **BLE** (por ser la mejor opción profesional), este es el flujo ideal:

1.  **Modo Escucha:** El usuario presiona un botón físico en el Portón/Dispositivo. El LED parpadea. El dispositivo empieza a emitir (Advertising) por Bluetooth con un nombre como `BGN_SETUP_1234`.
2.  **Escaneo (App):** La App busca dispositivos cercanos que empiecen por `BGN_SETUP`.
3.  **Conexión (Handshake):**
    *   La App se conecta al dispositivo BLE.
    *   **Lectura de Info:** La App lee una "Característica BLE" que contiene el **Serial Number (Mac Address)** o ID único del dispositivo.
4.  **Selección de Red:**
    *   La App detecta la red Wifi actual del teléfono (o pide al usuario seleccionarla).
    *   El usuario ingresa la contraseña del Wifi.
5.  **Envío de Credenciales (Provisioning):**
    *   La App envía `SSID` y `Password` encriptados a una "Característica de Escritura BLE" del dispositivo.
6.  **Vinculación (Binding):**
    *   El dispositivo recibe los datos, apaga el Bluetooth y se conecta al Wifi.
    *   **Simultáneamente**, la App (que sigue con internet) llama a tu Backend: `POST /devices/bind { serial: "BGN...1234", userId: "..." }`.
7.  **Confirmación:**
    *   El dispositivo se conecta y reporta "Online" al servidor.
    *   La App verifica que el dispositivo ya aparece en la lista del usuario.

---

## 2.1 Estrategia Híbrida (Dual Mode) - **Opción Flexible**

Sí, es totalmente posible y recomendable soportar **ambos métodos**.
Muchos dispositivos comerciales (como enchufes inteligentes Tuya/SmartLife) emiten BLE y Wifi simultáneamente en modo configuración.

**¿Cómo funciona en la App?**
1.  **Prioridad BLE (Automático):** La App siempre intenta escanear por Bluetooth primero (es transparente para el usuario). Si encuentra el dispositivo, usa el flujo rápido.
2.  **Fallback AP (Manual):** Si el teléfono no tiene Bluetooth o falla el escaneo, se muestra un botón *"¿No aparece? Intentar modo manual"*.
    *   Esto lleva al usuario a conectarse manualmente a la red Wifi del dispositivo (ej. `BGN_SETUP`).
    *   Una vez conectado, la App envía las credenciales vía HTTP (REST API simple en el dispositivo, ej: `http://192.168.4.1/config`).

**Impacto en Firmware:**
El equipo de firmware debe programar el chip para que, al entrar en "Modo Setup", active **ambas antenas**:
*   Debe hacer **Advertising BLE**.
*   Debe levantar el **Access Point (AP)** Wifi.

Esto garantiza que ningún usuario se quede sin poder configurar, sin importar qué tan viejo sea su teléfono.

```yaml
dependencies:
  # Para manejar Bluetooth BLE
  flutter_blue_plus: ^1.30.0 
  
  # Para obtener el nombre del Wifi actual del teléfono (opcional, ayuda al usuario)
  network_info_plus: ^5.0.0
  
  # Para gestionar permisos (Ubicación, Bluetooth Scan/Connect son obligatorios desde Android 12)
  permission_handler: ^11.3.0
```

## 4. Prerrequisitos de Hardware

Esta implementación depende 100% de qué chip esté usando tu hardware.
*   **Si usas ESP32:** Es el escenario ideal. Espressif tiene un protocolo estándar llamado `ESP-IDF Provisioning`. Incluso hay una librería de Flutter específica (`flutter_esp_ble_prov`) que hace todo el trabajo sucio.
*   **Si usas otro chip:** Tendrás que programar un servicio GATT personalizado en el firmware del dispositivo con dos características:
    *   `WRITE_WIFI_CREDS`: Para recibir user/pass.
    *   `READ_STATUS`: Para reportar si se conectó exitosamente.

## 5. Recomendación Antes de Implementar

1.  **Validar Hardware:** Confirma con el equipo de firmware si el dispositivo tiene Bluetooth y si pueden exponer un servicio BLE para recibir strings.
2.  **Permisos:** Prepárate para manejar permisos en tiempo de ejecución. Android 12+ requiere `BLUETOOTH_SCAN` y `BLUETOOTH_CONNECT`. Android 11 e inferiores requieren `ACCESS_FINE_LOCATION` para usar Bluetooth.
3.  **Seguridad:** No envíes la contraseña del Wifi en texto plano si es posible. Un cifrado básico (AES) o un handshake simple evita que alguien "escuche" la contraseña del vecino.

---

### Resumen
Te sugiero empezar integrando `flutter_blue_plus` y crear una pantalla de "Escaneo de Cercanía". Si tu hardware lo soporta, el camino BLE es infinitamente superior al de crear una red Wifi temporal.
