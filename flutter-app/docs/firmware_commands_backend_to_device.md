### Seccion
# Nota: Estos acrónimos no existen en el menú del Vita
# Iniciar sección
# idInstaller: Es el id del instalador, me lo tiene que enviar para iniciar seccion y validar todos los comandos
```json
{
  "AC":"IS",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Cerrar sección
```json
{
  "AC":"CS",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Ampliar tiempo de sección
```json
{
  "AC":"AS",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
### Fin comando seccion
# Consultar parámetros del Vita
```json
{
  "AC":"GE",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```

# Nota: Estos acrónimos existen en el menú del Vita
### Aprender controles

# Aprende Control para Apertura total (Abrir, cerrar, parar)
```json
{
  "AC":"Ct",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Apertura Peatonal
```json
{
  "AC":"CP",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Lámpara
```json
{
  "AC":"CL",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Relé en PCB
```json
{
  "AC":"Cr",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Bloqueo de funciones
```json
{
  "AC":"Cb",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Abrir
```json
{
  "AC":"Ai",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Cerrar
```json
{
  "AC":"AE",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Parar
```json
{
  "AC":"AA",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Aprende Control para Mantener Abierto
```json
{
  "AC":"At",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```

## 19-2-2026

# Aprender Límite de Carrera
```json
{
  "AC":"AL",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Sumar Recorrido
```json
{
  "AC":"5r",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Restar Recorrido
```json
{
  "AC":"rr",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```

## Foto Celdas

# Emparejar Periférico PC Apertura
```json
{
  "AC":"PA",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Emparejar Periférico PC Cierre
```json
{
  "AC":"AC",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```

## Opciones Avanzadas

# Configuración de Fábrica TODO
```json
{
  "AC":"CF",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Borrado Total de controles RF
```json
{
  "AC":"bC",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Borrar parámetros de la PCB
```json
{
  "AC":"bP",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Reinicio parámetros VITA (ESP32)
```json
{
  "AC":"rE",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Resetear contador de mantenimientos
```json
{
  "AC":"rC",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Test Foto Celda Cierre
```json
{
  "AC":"t1",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Test Foto Celda Apertura
```json
{
  "AC":"t2",
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
## 1. Comandos (Backend → Dispositivo)

| Campo               | Tipo   | Requerido       | Descripción                                                                                                                                             |
| ----------------    | ------ | -------------   | -------------------------------------------------------------------------|
| `command`           | String | ✅ Obligatorio | Acción específica dentro del tipo de comando, como `open`, `close`, `Courtesy_Light`                                                                               |

- `command`: Son los comandos que realizan una acción física en el motor, por ejemplo: Mover el portón o accionar la lámpara o relé.
| Command              | Tipo   | Value | Descripción                                    |
| -------------------- | ------ | ----- | ---------------------------------------------- |
| `OPEN`               | void | —     | Envía orden de abrir.                            |
| `CLOSE`              | void | —     | Envía orden de cerrar.                           |
| `stop`               | void | —     | Envía orden de parar.                            |
| `OCS`                | void | —     | Realiza la secuencia **Open–Close–Stop**.        |
| Depende del estado del motor, si está cerrado habré, si está abriendo o cerrando, para, si está abierto cierra. Nota: En modo condominio: Solo habré.|
| `PEDESTRIAN`         | void | —     | Envía orden de apertura peatonal.              |
| `RELE`               | void | —     | Invierte el estado del relé.                   |
| `LAMP`               | void | —     | Invierte el estado de la lámpara.              |

```json
{
  "AC": "OPEN",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# 20-2-26
# Eliminar red WIFI
```json
{
  "AC": "DelWifi",
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
# Limites de carrera
```json
{
  "AC": "LC", // Límites de carrera | 0 = NO (Normalmente abierto), 1 = NC (Normalmente Cerrado)
  "value":1,
  "idInstaller":"234r8j$%^hfhjasdf"
}
```
### Parámetros lista
# Nota: Este acrónimo no existen en el menú del Vita "SE"
```json
{
  //Parametros
  "AC":"SE", // Indica que va a guardar la siguiente lista de parametros
  "dP": 1,  // Motor Derecho/Izquierdo (dirección puerta) | 0 = Derecha, 1 = Izquierda
  "P5": 5,  // Configuración de paro suave | Rango: 0–10
  "LC": 1,  // Límites de carrera NO/NC | 0 = NO (Normalmente abierto), 1 = NC (Normalmente Cerrado)
  "CA": 1,  // Cierre Automático | 0 = OFF, 1 = ON
  "tC": 3,  // Tiempo de Cierre Automático | Rango: 0–9
  "AP": 3,  // Ajuste de Apertura Peatonal | Rango: 1–5
  "FE": 5,  // Ajuste de Fuerza de Empuje | Rango: 0–9
  "Co": 0,  // Modo Condominio | 0 = OFF, 1 = ON
  "rA": 1,  // Modo Relé Auxiliar | 0–2 
  "CC": 5,  // Límite de mantenimientos  | Rango: 0–9
  // Foto celdas
  "FF": 1,  // Cierre por Fotoceldas | 0 = OFF, 1 = ON
  // Opciones Lámpara
  "FL": 0,  // Modo en Funcionamiento | 0: Fija en funcionamiento, 1: Destellante en funcionamiento
  "LE": 3,  // Luz de cortesía (tiempo lámpara encendida) | 0 a 5 minutos, luego de funcionamiento del motor
  // Opciones Avanzadas
  "bL": 0,   // Bloqueo | 0 = OFF, 1 = ON, solo se puede bloquear en cerrado
  "tA": 0,    // Mantener abierto | 0 = OFF, 1 = ON, solo se puede activar en abierto
   // Etiqueta del VITA
  "labelVIta": "Enrique Vecino", // Se la pone el instalador al VITA, solo el instalador puede verla **** 20-2-26
  // Wifi
  "setWifi": 1,// Me indica si debo grabar los parametros del wifi ****** 20-2-26
  "ssid":"",
  "ssidPassword":"",
  // Contraseñá vita para hacer cambios
  "idInstaller":"234r8j$%^hfhjasdf"
}

```