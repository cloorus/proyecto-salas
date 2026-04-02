# REQUERIMIENTOS DE PROYECTO - Aplicación Móvil del Instalador

**MQ BUSINESS INTELLIGENCE SOLUTIONS SRL**

## Datos del Documento

| Campo | Valor |
|-------|-------|
| Versión de propuesta | 1.1 |
| Título del proyecto | Aplicación Móvil del Instalador |
| Tipo de documento | Requerimientos de proyecto |
| Fecha | 6 de enero de 2025 |

### Historial de versiones

| Versión | Autor | Descripción de versión | Fecha |
|---------|-------|------------------------|-------|
| 1.0 | Eduardo Orellana | Listado de requerimientos base | 2/1/2025 |
| 1.1 | Jerson Quirós | Reorganización documental | 6/1/2025 |
| 1.2 | Eduardo Orellana | Revisión y actualización de requerimientos | 10/3/2025 |

---

## Introducción

### Alcance

En el contexto de la configuración de dispositivos VITA, surge la necesidad de una solución tecnológica que facilite y optimice este proceso. La aplicación móvil propuesta está diseñada para conectarse a dispositivos VITA vía Bluetooth, permitiendo configurar sus parámetros de manera eficiente e intuitiva sin la necesidad de hacerlo directamente en el dispositivo y con el uso mínimo de funciones que requieran de conexión a internet.

### Valor del producto

Este software tiene como objetivo principal resolver las siguientes necesidades:

- Ofrecer una interfaz fácil de usar que minimice la curva de aprendizaje y reduzca errores operativos
- Proporcionar acceso centralizado a funcionalidades clave como el asistente de instalación, configuración de parámetros, selección de dispositivos, activación, pruebas, bitácoras, manuales, configuraciones de red y foto celdas y aprendizaje de carreras
- Garantizar la conexión fluida con los dispositivos a través de tecnología Bluetooth, asegurando una experiencia estable y confiable
- Asegurar la seguridad en la instalación con un tiempo controlado en caso de inactividad durante la instalación
- Uso de wifi solo en funciones que lo requieren como por ejemplo el inicio de sesión, recuperar contraseña y guardar datos de configuración en la nube

#### Métricas clave

- Porcentaje de usuarios instaladores satisfechos, medido a través de encuestas y retroalimentación directa
- Reducción del tiempo promedio de configuración, comparado con los métodos actuales
- Tasa de configuraciones exitosas, que refleje la efectividad y fiabilidad de la aplicación
- Frecuencia de uso de la aplicación, indicando su utilidad en procesos recurrentes

Con este proyecto, no solo se busca superar los desafíos en la configuración de dispositivos VITA, sino también optimizar la experiencia del usuario instalador y contribuir significativamente a los objetivos estratégicos del negocio.

### Público objetivo

El público objetivo son los instaladores de dispositivos VITA, quienes requieren una herramienta tecnológica para facilitar y optimizar su trabajo mediante la tecnología bluetooth.

### Uso previsto

Los instaladores usarán la aplicación para realizar:

- Configuraciones rápidas y precisas de dispositivos
- Acceso a manuales técnicos y bitácoras
- Activación y prueba de dispositivos
- Configuraciones avanzadas como redes Wi-Fi y emparejamiento de foto celdas

### Descripción General

Desarrollar una aplicación móvil híbrida que permita a los usuarios instaladores configurar e instalar por completo dispositivos VITA de manera eficiente y segura, mediante una interfaz intuitiva y accesible que minimice errores operativos mediante su funcionalidad clave de asistente de instalación y garantice una conexión estable y confiable vía Bluetooth, optimizando así la experiencia de instalación. La aplicación debe contar con acceso a internet para las funciones que lo requieren, pero este no debe ser indispensable para el uso normal de la aplicación.

---

## Requerimientos generales

### Requerimientos funcionales

#### Autenticación y Seguridad

- Permitir a los usuarios iniciar sesión en la aplicación mediante credenciales validadas
- Proveer recuperación de contraseñas mediante la verificación por correo electrónico. En caso de que el usuario esté bloqueado en el servidor, no podrá recuperar la contraseña ni iniciar sesión
- Garantizar la gestión segura de sesiones y datos del usuario

#### Gestión de Dispositivos

- Mostrar una lista de dispositivos detectados por medio de bluetooth
- Facilitar la selección de un dispositivo para configurarlo, activarlo y realizar pruebas
- Permitir la conexión y configuración de dispositivos mediante tecnología Bluetooth Low Energy (BLE)
- Al seleccionar un dispositivo, la aplicación debe obtener los parámetros actuales de este

#### Asistente de Instalación

- Guiar al usuario paso a paso en la configuración de los dispositivos
- Mostrar parámetros actuales del dispositivo y permitir su modificación
- Proveer retroalimentación visual y textual durante el proceso de configuración

#### Configuración Avanzada

- Permitir la configuración personalizada de parámetros del dispositivo, evitando configuraciones completas si no son necesarias
- Gestionar configuraciones de redes Wi-Fi cercanas mediante detección automática, ingreso de credenciales y envío de datos al dispositivo
- Facilitar el aprendizaje de límites (carreras) y emparejamiento de foto celdas, mostrando animaciones representativas del proceso

#### Acceso a Recursos

- Proveer acceso a manuales de usuario en formato PDF, con opción de descarga
- Facilitar la consulta y descarga de bitácoras con registros históricos de actividades

#### Pruebas y Activación

- Ejecutar pruebas en dispositivos configurados, mostrando resultados en tiempo real
- Gestionar dispositivos activados y pendientes, permitiendo la activación directa
- Inyectar datos en el dispositivo vía bluetooth una vez estén todas las configuraciones listas

#### Actualización de Dispositivos

- Permitir la actualización del firmware de los dispositivos mediante Over-The-Air (OTA)
- Mostrar detalles del dispositivo, como nombre, versión actual, ciclos totales y estado

### Requisitos de interfaz

#### Requisitos de la interfaz de usuario

- Diseñar una interfaz adaptativa para pantallas de distintos tamaños y resoluciones
- Usar elementos visuales claros, como botones, checkboxes y toggles, para facilitar la interacción
- Proveer navegación intuitiva mediante, con un menú principal que centralice todas las funcionalidades

#### Requisitos de la interfaz de hardware

- Garantizar compatibilidad con dispositivos móviles Android (versión 11 o superior) e iOS (versión 16 o superior)
- Asegurar que la conexión con dispositivos VITA se realice mediante Bluetooth Low Energy (BLE)

#### Requisitos de la interfaz de software

- Backend desarrollado con Node.js y Firebase para la lógica de negocio y almacenamiento de datos
- Frontend basado en React Native para un desarrollo multiplataforma eficiente
- Integración de bibliotecas externas para funcionalidades como escaneo de redes Wi-Fi, visualización de PDF y animaciones

#### Requisitos de la interfaz de comunicación

- Uso de APIs REST para sincronización de datos, validación de credenciales y gestión de sesiones
- Comunicación en tiempo real mediante WebSocket para pruebas y actualización de estados del dispositivo

### Requerimientos no funcionales

#### Seguridad

- Utilizar Firebase Authentication para garantizar la autenticación segura de usuarios
- Implementar validaciones en todas las comunicaciones con dispositivos y servidores para proteger la información

#### Capacidad

- Soporte para almacenar y consultar datos como bitácoras, configuraciones y parámetros a nivel local y en Firebase Firestore

#### Compatibilidad

- Garantizar que todas las funcionalidades sean operativas en dispositivos móviles con distintas resoluciones de pantalla y sistemas operativos compatibles

#### Confiabilidad

- Implementar mecanismos de conexión bluetooth, sin importar si la aplicación tiene o no acceso a internet
- Asegurar que las configuraciones y actualizaciones se apliquen sin pérdida de datos vía bluetooth en el dispositivo

#### Escalabilidad

- Diseñar el sistema para soportar la inyección de múltiples configuraciones en un solo paquete

#### Mantenibilidad

- Facilitar la instalación de actualizaciones OTA sin necesidad de desinstalar la aplicación
- Documentar el código y la lógica de negocio para futuras mejoras

#### Facilidad de uso

- Proveer una interfaz intuitiva y accesible, minimizando la curva de aprendizaje de los usuarios

#### Otros requisitos no funcionales

- Asegurar tiempos de carga inicial inferiores a 5 segundos en condiciones de red estándar

---

## Segmentación

El tipo de segmentación apropiada para este desarrollo es por módulo tomando en cuenta su asociación estructural por funciones:

### 1. Login

**Descripción:** Permite al usuario ingresar sus credenciales para acceder a la aplicación o iniciar el proceso de recuperación de contraseña.

**Funcionalidades:**
- Ingreso de credenciales
- Validaciones
- Redirección en caso de éxito
- Enlace a recuperación de contraseña

### 2. Recuperar Contraseña

**Descripción:** Facilita el proceso de restablecimiento de contraseña mediante la verificación de correo electrónico.

**Funcionalidades:**
- Envío de código de verificación
- Validación de código
- Establecimiento de nueva contraseña

### 3. Seleccionar Dispositivo

**Descripción:** Muestra los dispositivos disponibles vía bluetooth, permitiendo al usuario seleccionar uno para ir a la pantalla principal o a la pantalla de activar dispositivo.

**Funcionalidades:**
- Listado de dispositivos
- Opciones de navegación según selección
- Obtener parámetros de dispositivo seleccionado

### 4. Menú Principal

**Descripción:** Actúa como la pantalla de inicio tras seleccionar un dispositivo, presentando botones de navegación hacia las principales funcionalidades de la app.

**Funcionalidades:**
- Redirección a pantallas clave
- Visualización intuitiva de opciones

### 5. Manuales de Usuario

**Descripción:** Proporciona acceso a manuales específicos para cada dispositivo disponible.

**Funcionalidades:**
- Selección de dispositivos
- Visualización de manual correspondiente

### 6. Pruebas

**Descripción:** Permite realizar pruebas del dispositivo instalado mediante botones y opciones específicas.

**Funcionalidades:**
- Ejecución de pruebas
- Visualización de resultados

### 7. Bitácoras

**Descripción:** Permite registrar actividades realizadas y acceder al historial.

**Funcionalidades:**
- Ingreso y almacenamiento de actividades
- Botón para ver historial

### 8. Historial de Bitácoras

**Descripción:** Presenta registros históricos de actividades, con opciones para ver detalles y descargar.

**Funcionalidades:**
- Visualización de historial (fecha, dispositivo)
- Descarga de registros

### 9. Activar Dispositivo

**Descripción:** Muestra dispositivos activados y pendientes, con la opción de activar los pendientes.

**Funcionalidades:**
- Gestión de estados (activados/pendientes)
- Botón de activación

### 10. Configurar Red

**Descripción:** Permite escanear redes Wi-Fi cercanas e ingresar los datos de red al seleccionarlas para inyectarlos en el dispositivo.

**Funcionalidades:**
- Escaneo de redes Wi-Fi cercanas
- Selección de red Wi-Fi deseada
- Ingreso de credenciales de la red seleccionada
- Envío de configuración al dispositivo vía Bluetooth

### 11. Aprender Carreras

**Descripción:** Permite establecer los límites de los dispositivos mostrando una animación de ejemplo en pantalla mediante un botón de "Aprender Carreras" inyectando esa información para que el dispositivo aprenda la información.

**Funcionalidades:**
- Visualización de una animación explicativa
- Botón para iniciar el proceso de aprendizaje de límites
- Retroalimentación visual o textual sobre el progreso del aprendizaje

### 12. Configurar Foto Celdas

**Descripción:** Permite emparejar las "foto celdas" de apertura con las de cierre mediante botones respectivos, cada una con su animación, y muestra botones con imágenes para probar aperturas.

**Funcionalidades:**
- Emparejamiento de foto celdas de apertura y cierre
- Animaciones representativas del proceso
- Botones con imágenes para pruebas de apertura y cierre

### 13. Seleccionar Parámetros

**Descripción:** Permite enviar parámetros al dispositivo de forma más personalizada, sin tener que configurar todos.

**Funcionalidades:**
- Selección de parámetros específicos a configurar
- Envío de configuraciones personalizadas al dispositivo

### 14. Asistente de Instalación

**Descripción:** Muestra los parámetros actuales del dispositivo si los hay y guía al usuario paso a paso para su configuración.

**Funcionalidades:**
- Visualización de parámetros actuales
- Botón para avanzar a la siguiente pantalla de configuración

### 15. Parámetros A

**Descripción:** Permite seleccionar diferentes parámetros por medio de checkboxes y cuenta con un botón para ir a la siguiente pantalla de parámetros.

**Funcionalidades:**
- Selección de parámetros mediante checkboxes
- Botón para avanzar a la siguiente pantalla

### 16. Parámetros B

**Descripción:** Muestra opciones para activar o desactivar según sea necesario en el dispositivo y cuenta con un botón para ir a la siguiente pantalla.

**Funcionalidades:**
- Activación/desactivación de opciones mediante toggles
- Botón para avanzar a la siguiente pantalla

### 17. Parámetros C

**Descripción:** Muestra opciones para activar o desactivar según sea necesario en el dispositivo y cuenta con un botón para ir a la siguiente pantalla.

**Funcionalidades:**
- Activación/desactivación de opciones mediante toggles
- Botón para avanzar a la siguiente pantalla

### 18. Parámetros D

**Descripción:** Permite configurar diferentes opciones con las que cuenta el dispositivo y cuenta con un botón para actualizar todos los parámetros.

**Funcionalidades:**
- Configuración de opciones avanzadas
- Botón para actualizar todos los parámetros configurados e inyectarlos en el dispositivo

### 19. Actualizar Dispositivo

**Descripción:** Permite ver detalles del dispositivo, resetear ciclos y actualizarlo vía OTA.

**Funcionalidades:**
- Visualización de detalles como nombre, versión actual, ciclos totales/actuales, fecha de activación y estado
- Botón para reiniciar ciclos
- Botón para actualizar el firmware del dispositivo vía OTA

---

## Detalles de implementación

### Tecnologías de desarrollo sugeridas

| Módulo | Backend | Frontend | Comunicación |
|--------|---------|----------|--------------|
| Login | Firebase Authentication | React Native con integración de formularios | API REST para validar credenciales y gestionar sesiones |
| Recuperar Contraseña | Firebase Authentication y Cloud Functions | React Native con manejo de formularios dinámicos | API REST para gestionar verificación de código y actualización de contraseñas |
| Seleccionar Dispositivo | Node.js | React Native BLE PLX | Bluetooth Low Energy (BLE) para escaneo y detección de dispositivos |
| Menú Principal | - | React Native con React Navigation para gestión de rutas | - |
| Manuales de Usuario | Firebase Storage | React Native con integración de visores PDF y opciones de descarga para almacenamiento local | API REST para obtener el manual correspondiente |
| Pruebas | Node.js | React Native con diseño modular para acciones en tiempo real | Bluetooth Low Energy (BLE) |
| Bitácoras | Firebase Firestore / Almacenamiento local para luego subirlo a la nube | React Native con formularios y tablas dinámicas | API REST para guardar las bitácoras y base de datos local para cuando no haya internet |
| Historial de Bitácoras | SQLite / MMKV (react-native-mmkv) | React Native con bibliotecas como File System | - |
| Activar Dispositivo | Node.js | React Native con hooks para manejo de estados en tiempo real | Bluetooth Low Energy (BLE) para inyección de datos al dispositivo |
| Configurar Red | Node.js | React Native con integración de bibliotecas para escaneo de redes | Bluetooth Low Energy (BLE) para inyección de datos al dispositivo |
| Aprender Carreras | Node.js | React Native con integración para animaciones | Bluetooth Low Energy (BLE) para enviar comandos al dispositivo |
| Configurar Foto Celdas | Node.js | React Native con animaciones SVG o Lottie | Bluetooth Low Energy (BLE) para enviar configuraciones |
| Seleccionar Parámetros | Node.js | React Native con formularios dinámicos gestionados con Formik y validaciones con Yup | Bluetooth Low Energy (BLE) para transferencia de parámetros |
| Asistente de Instalación | Node.js | React Native con React Navigation | Bluetooth Low Energy (BLE) para sincronización en tiempo real |
| Parámetros A | Node.js | React Native con gestión de estados | - |
| Parámetros B | Node.js | React Native con componentes Switch para toggles | - |
| Parámetros C | Node.js | React Native con componentes Switch para toggles | - |
| Parámetros D | Node.js | React Native con formularios dinámicos y validaciones automáticas | Bluetooth Low Energy (BLE) para sincronizar parámetros |

---

## Recursos Necesarios

### Matriz RACI de Proyecto

| Tarea/Actividad | Responsable (R) | Aprobador (A) | Consultado (C) | Informado (I) |
|-----------------|-----------------|---------------|----------------|---------------|
| Levantamiento de casos de uso y requerimientos | Analista de Sistemas | Gestor de Proyecto | Gestor de Proyecto, QA/Tester | Todo el equipo |
| Desarrollo de pantallas frontend | Desarrollador Frontend | Gestor de Proyecto | Diseñador UI/UX | QA/Tester |
| Desarrollo de funcionalidades backend | Desarrollador Backend | Gestor de Proyecto | Desarrolladores Frontend | QA/Tester |
| Integración de frontend y backend | Desarrolladores | Gestor de Proyecto | QA/Tester | Diseñador UI/UX |
| Configuración de Bluetooth y comunicación | Desarrollador Backend | Gestor de Proyecto | QA/Tester | Diseñador UI/UX |
| Pruebas funcionales de cada módulo | QA/Tester | Gestor de Proyecto | Desarrolladores | Diseñador UI/UX |
| Pruebas de integración y sistema | QA/Tester | Gestor de Proyecto | Desarrolladores | Diseñador UI/UX |
| Pruebas de usabilidad | QA/Tester | Gestor de Proyecto | Diseñador UI/UX | Desarrolladores |
| Documentación técnica y del usuario | Desarrolladores | Gestor de Proyecto | QA/Tester | Diseñador UI/UX |
| Gestión del cronograma y recursos | Gestor de Proyecto | Gestor de Proyecto | Todo el equipo | Todo el equipo |
| Entrega y despliegue final | Gestor de Proyecto | Gestor de Proyecto | QA/Tester, Desarrolladores | Diseñador UI/UX |

**Personal requerido:**
- Desarrolladores móviles: 2 (uno especializado en backend y otro en frontend) o bien 2 desarrolladores fullstack
- QA/Tester: 1
- Gestor de Proyecto: 1

### Herramientas y Tecnologías de Gestión

#### Framework de Desarrollo

**Flutter o React Native:** Se utilizará uno de estos frameworks para el desarrollo de la aplicación móvil híbrida. Ambas opciones permiten un desarrollo multiplataforma eficiente, asegurando compatibilidad tanto con Android como con iOS. La elección final dependerá de las preferencias del equipo y de los requisitos técnicos del proyecto.

#### Servicios en la Nube

**Firebase:**
- **Autenticación:** Gestionará el inicio de sesión, recuperación de contraseñas y autenticación segura de usuarios instaladores
- **Firestore:** Para el almacenamiento de datos como instaladores, configuraciones de dispositivos, bitácoras y parámetros de instalación

**SQLite:**
- **Backend:** Para almacenar dispositivos vinculados y configuraciones
- **Comunicación:** Para mantener sincronización sin conexión a internet

#### Herramientas de Diseño

**Figma:**
- Será utilizada para crear prototipos interactivos y diseños de la interfaz de usuario (UI)
- Facilitación de iteraciones rápidas en el diseño gracias a su capacidad de colaboración en tiempo real
- Almacenamiento centralizado de componentes visuales y guías de estilo para mantener consistencia en el diseño

#### Plataforma de Gestión de Proyectos

**Jira:**
- Seguimiento de tareas y asignación de responsabilidades usando una metodología ágil Scrum
- Gestión de sprints y prioridades, permitiendo monitoreo del progreso del proyecto en tiempo real
- Reportes automatizados para análisis de productividad y cumplimiento de hitos del proyecto

---

## Cronograma Estimado

### Tiempos Totales por Módulo

| Módulo | Duración (Min - Max) en Semanas | Comentarios |
|--------|--------------------------------|-------------|
| Levantamiento de Casos de Uso y Requerimientos | 2.0 a 3 semanas | Incluye recopilación de información, revisiones y aceptaciones |
| Login | 1.5 a 2 semanas | Incluye testeo y seguridad |
| Recuperar Contraseña | 0.7 a 1.5 semanas | Incluye validación y flujo completo |
| Seleccionar Dispositivo | 0.8 a 1.15 semanas | Incluye navegación condicional |
| Menú Principal | 0.7 a 1 semana | Botones de navegación configurados |
| Manuales de Usuario | 0.8 a 1.15 semanas | Carga y visualización de documentos |
| Pruebas | 0.8 a 1 semana | Ejecución de pruebas y visualización |
| Bitácoras | 0.8 a 1 semana | Registro de actividades e historial |
| Historial de Bitácoras | 0.8 a 1.15 semanas | Descarga y detalles de registros |
| Activar Dispositivo | 0.8 a 1.15 semanas | Gestión de activación de dispositivos |
| Configurar Red | 1.0 a 1.2 semanas | Detección de redes cercanas |
| Aprender Carreras | 1.0 a 1.2 semanas | Simulación de la prueba que se ejecuta |
| Configurar Foto Celdas | 1.0 a 1.2 semanas | Animaciones de simulación |
| Seleccionar Parámetros | 1.0 a 1.5 semanas | Acceso a parámetros específicos |
| Asistente de Instalación | 1.0 a 1.5 semanas | Carga de parámetros previos en dispositivo si los hay |
| Parámetros A | 1.5 a 2 semanas | Visualización de los parámetros configurables |
| Parámetros B | 1.5 a 2 semanas | Visualización de los parámetros configurables |
| Parámetros C | 1.5 a 2 semanas | Visualización de los parámetros configurables |
| Parámetros D | 1.5 a 2 semanas | Visualización de los parámetros configurables |
| Actualizar Dispositivo | 1.0 a 1.5 semanas | Inyección de datos al dispositivo |

**Tiempo total estimado:** 22.4 a 32.45 semanas

---

## Detalle de tiempos por actividad

### Levantamiento de Casos de Uso y Requerimientos Funcionales y no Funcionales (120 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Recopilar información y levantar casos de uso | Analista de Sistemas | 40 |
| Revisión y aceptación de casos de uso | Analista de Sistemas y Gestor de Proyecto | 20 |
| Levantar requerimientos funcionales y no funcionales | Analista de Sistemas | 40 |
| Revisión y aceptación de requerimientos | Analista de Sistemas y Gestor de Proyecto | 20 |

### Login (80 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Desarrollo de formulario de login | Frontend | 8 |
| Implementación de validaciones | Frontend | 8 |
| Implementación de API REST para login | Backend | 24 |
| Integración de Firebase Authentication | Backend | 20 |
| Pruebas unitarias de validaciones | QA | 10 |
| Pruebas funcionales de login | QA | 10 |

### Recuperar contraseña (40 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Desarrollo de formulario de recuperación | Frontend | 6 |
| Implementación de lógica de verificación | Backend | 8 |
| Implementación de API REST para restablecer contraseña | Backend | 10 |
| Integración de Firebase Authentication | Backend | 10 |
| Pruebas unitarias de recuperación de cuenta | QA | 4 |
| Pruebas funcionales de recuperar contraseña | QA | 2 |

### Seleccionar Dispositivo (46 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de listado de dispositivos | Frontend | 8 |
| Lógica para detectar dispositivos | Backend | 10 |
| Lógica para traer los parámetros actuales del dispositivo seleccionado | Backend | 10 |
| Pruebas unitarias de selección de dispositivo | QA | 12 |
| Pruebas de integración de dispositivo | QA | 6 |

### Menú Principal (32 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de navegación y configuración de rutas con React Navigation | Frontend | 8 |
| Desarrollo de la lógica de navegación | Frontend | 8 |
| Pruebas unitarias del menú | QA | 8 |
| Pruebas de integración del menú | QA | 8 |

### Manuales de Usuario (42 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de visor PDF | Frontend | 8 |
| Integración con la API REST para traer lista de manuales y guardarlos de manera local | Backend | 8 |
| Integración con Firebase Storage y programación de almacenamiento local | Backend | 12 |
| Pruebas unitarias de visor PDF | QA | 8 |
| Pruebas de integración de visor PDF | QA | 6 |

### Pruebas (60 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de visualización de pruebas | Frontend | 20 |
| Integración de BLE para pruebas | Backend | 20 |
| Pruebas unitarias de pruebas | QA | 10 |
| Pruebas funcionales de pruebas | QA | 10 |

### Bitácoras (44 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de formulario de actividades | Frontend | 12 |
| Integración de Firebase Firestore y almacenamiento local | Backend | 12 |
| Pruebas unitarias de registro de actividad | QA | 12 |
| Pruebas funcionales de bitácoras | QA | 8 |

### Historial de Bitácoras (38 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de vista de historial | Frontend | 8 |
| Almacenar bitácoras para luego subirlas a la nube | Backend | 12 |
| Pruebas unitarias de historial | QA | 10 |
| Pruebas de integración de historial | QA | 8 |

### Activar Dispositivo (46 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de botón de activación | Frontend | 8 |
| Integración con BLE para activación y almacenamiento local | Backend | 16 |
| Pruebas unitarias de activación | QA | 12 |
| Pruebas funcionales de activación | QA | 10 |

### Configurar Red (54 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de escaneo de redes Wi-Fi | Frontend | 10 |
| Configuración de selección de red Wi-Fi | Frontend | 10 |
| Implementación de comunicación Bluetooth para inyectar los datos | Backend | 16 |
| Pruebas unitarias de escaneo de redes | QA | 10 |
| Pruebas de integración de escaneo Wi-Fi | QA | 8 |

### Aprender Carreras (68 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de animación explicativa | Frontend | 12 |
| Desarrollo del botón para enviar la instrucción de iniciar aprendizaje | Frontend | 4 |
| Lógica de retroalimentación visual o textual | Frontend | 8 |
| Desarrollo de lógica BLE para procesar límites | Backend | 24 |
| Pruebas unitarias de animación y retroalimentación | QA | 10 |
| Pruebas de integración de aprendizaje de límites | QA | 10 |

### Configurar Foto Celdas (60 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de emparejamiento de foto celdas | Frontend | 12 |
| Desarrollo de animaciones para foto celdas | Frontend | 12 |
| Desarrollo de botones de prueba de apertura | Frontend | 8 |
| Lógica para inyectar configuraciones en las foto celdas | Backend | 8 |
| Pruebas unitarias de emparejamiento y animaciones | QA | 10 |
| Pruebas de integración de emparejamiento | QA | 10 |

### Seleccionar Parámetros (50 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de selección de parámetros | Frontend | 8 |
| Desarrollo de formularios dinámicos | Frontend | 10 |
| Lógica de persistencia de parámetros | Backend | 12 |
| Pruebas unitarias de selección de parámetros | QA | 10 |
| Pruebas de integración de parámetros | QA | 10 |

### Asistente de Instalación (40 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de visualización de parámetros | Frontend | 6 |
| Desarrollo del flujo del asistente | Frontend | 2 |
| Lógica para sincronización de parámetros y persistencia | Backend | 12 |
| Pruebas unitarias del asistente de instalación | QA | 8 |
| Pruebas de integración del asistente | QA | 12 |

### Parámetros A (44 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de selección de parámetros A | Frontend | 10 |
| Lógica de almacenamiento de parámetros (persistencia de datos entre pantallas) | Backend | 16 |
| Pruebas unitarias de parámetros A | QA | 8 |
| Pruebas de integración de parámetros A | QA | 10 |

### Parámetros B (38 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de opciones de activación/desactivación | Frontend | 8 |
| Lógica de activación/desactivación de parámetros | Backend | 12 |
| Pruebas unitarias de activación/desactivación | QA | 10 |
| Pruebas de integración de activación/desactivación | QA | 8 |

### Parámetros C (38 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de opciones de activación/desactivación | Frontend | 8 |
| Lógica de activación/desactivación de parámetros | Backend | 12 |
| Pruebas unitarias de activación/desactivación | QA | 10 |
| Pruebas de integración de activación/desactivación | QA | 8 |

### Parámetros D (48 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de opciones avanzadas | Frontend | 8 |
| Lógica para actualizar parámetros del dispositivo mediante inyección vía BLE | Backend | 20 |
| Pruebas unitarias de configuración avanzada | QA | 12 |
| Pruebas de integración de configuración avanzada | QA | 8 |

### Actualizar Dispositivo (46 horas)

| Actividades | Responsable | Duración (horas) |
|-------------|-------------|------------------|
| Implementación de visualización de detalles del dispositivo | Frontend | 8 |
| Lógica para resetear ciclos y actualizar firmware | Backend | 20 |
| Pruebas unitarias de actualización de dispositivo | QA | 10 |
| Pruebas de integración de actualización de dispositivo | QA | 8 |
