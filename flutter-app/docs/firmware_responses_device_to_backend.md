### Seccion
# Nota: Estos acrónimos no existen en el menú del Vita
# Iniciar sección
# idVita: Es el id del VITA
# result: ok, Error = Puede ser que el idInstaller no coincide
```json
{
  "AC":"IS",
  "idVita":"234r8j$%^hfhjasdf",
  "result": "OK"                // OK, Error (Si el tiempo de sincronización del instalador, no inicio o se terminó)
}
```
# Cerrar sección
```json
{
  "AC":"CS",
  "idVita":"234r8j$%^hfhjasdf",
  "result": "OK"                // OK, Error (Si el tiempo de trabajo del instalador se terminó)
}
```
# Ampliar tiempo de sección
```json
{
  "AC":"AS",
  "idVita":"234r8j$%^hfhjasdf",
  "result": "OK"                // OK, Error (Si el tiempo de trabajo del instalador se terminó)
}
```
### Fin comando seccion
# Responder parámetros del Vita
```json
{
  //Parametros
  "AC":"GE",
  "dP": 1,  // Motor Derecho/Izquierdo (dirección puerta) | 0 = Derecha, 1 = Izquierda
  "P5": 5,  // Configuración de paro suave | Rango: 0–10 | Cero es desacticado, al activarlo damos un valor fijo dependiendo del tipo de motor.
  "LC": 1,  // Límites de carrera NO/NC | 0 = NO, 1 = NC
  "CA": 1,  // Cierre Automático | 0 = OFF, 1 = ON
  "tC": 3,  // Tiempo de Cierre Automático | Rango: 0–9 | Lista de valores: 0=10 segundos, 1=20s, 2=30s, 3=1.0 minutos, 4=1.3m, 5=2.0m, 6=2.3m, 7=3.0m, 8=3.3m, 9=4.0m
  "AP": 3,  // Ajuste de Apertura Peatonal | Rango: 1–5 | Lista de valores: 1=0%, 2=25%, 3=50%, 4=75%, 5=100%
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
  "labalVIta": "Enrique Vecino", // Se la pone el instalador al VITA, solo el instalador puede verla **** 20-2-26
  // Estado del motor
  "Cur_MotorStatus":2, //0 = Open, 1 = Opening, 2 = Closed, 3 = Closing, 4 = Undetermined (Stopped), 5 = Pedestrian Open, 6 = Pedestrian Opening
  // Wifi
  "ssid":"",
  // Ciclos del motor
  "Maintenance_Count": 0,       //These are the total maintenance that the engine has received 0-99
  "Total_Cycles":0,             //These are the total engine cycles. 0-n exemple 9 999 9999
  "Par_MaintenanceLimit":0,     // It is the number of cycles that must be waited to perform maintenance 0-9000
  "Cycles_SinceMaintenance":0,  //It is the cycle counter since the last maintenance, to indicate if one is required 0-9999
  // Tipo de motor
  "current_Type":0,             //0 = AC (Corriente alterna), 1 = DC (corriente directa)
  "motor_Type":1,               //0 = piston, 1= rack, 2= curtain, 3= barrier, 4= sliding_door, 5= electronic_door, 6= other
  "IdPCB":0,                    //0= fac500
  // Estado de las foto celdas
  "Fc_OpenState":0,             //0= no interruption, 1 = with interruption
  "Fc_CloseState":0,            //0= no interruption, 1 = with interruption
  "fc_Open_Battery": 85,        //0-99 nivel de bateria de la foto celda de apertura
  "fc_Close_Battery": 90,       //0-99 nivel de bateria de la foto celda de cierre
  // Estado Lampara
  "Lamp_Status": 0,             //0 = apagado, 1 = encendido
  // Estado Lampara
  "Relay_Status": 0,            //0 = apagado, 1 = encendido
  // Versión del firmware del vita
  "FV": "202511070925",         // Es la vercion del codigo del VITA, año, dia, mes, hora, minutos
  "idVita":"234r8j$%^hfhjasdf",
  "result": "OK"                // OK, Error 
}
```

