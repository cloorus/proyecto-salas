|  | MQ Business intelligence Solutions SRLREQUERIMIENTOS DE PROYECTO |
| --- | --- |

Contenido

# Datos del Documento

| Versión de propuesta | 1.1 |
| --- | --- |
|  |  |
| Título del proyecto | Aplicación Móvil VITA Basic |
|  |  |
| Tipo de documento | Requerimientos de proyecto |
|  |  |
| Fecha |  |

| Historial de versiones |  |  |  |
| --- | --- | --- | --- |
| Versión | Autor | Descripción de versión | Fecha |
| 1.0 | Eduardo Orellana | Listado de requerimientos base |  |
| 1.1 | Jerson Quirós | Reorganización documental |  |
|  |  |  |  |
|  |  |  |  |

| Historial de revisiones |  |  |  |
| --- | --- | --- | --- |
| Aprobador | Versión | Firma | Fecha |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

| Historial de aprobaciones |  |  |  |
| --- | --- | --- | --- |
| Revisor | Versión | Firma | Fecha |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

# Acceso a la aplicación

## Generalidades

Este documento incluye ciertas funcionalidades comunes (como regresar a la pantalla anterior) que están descritas en el “Documento de Generalidades”. Las pantallas que se contemplan en este documento respetan esas reglas a excepción de la pantalla de inicio de sesión.

Las pantallas que cuenten con campos para ingresar información siguen las reglas definidas en el Documento de Generalidades: Identificación – Resaltado de Campos de Ingreso de Información.

## Accesos a la aplicación

### Epic: Inicio de sesión 

#### HU- 1: Iniciar sesión de usuarios con email y contraseña 

Como usuario, quiero iniciar sesión por medio de mi correo electrónico y una contraseña para poder acceder a la aplicación fácilmente.

Criterios de aceptación:

El sistema debe validar el formato del correo electrónico.

El sistema debe verificar que la contraseña cumpla con las reglas de seguridad.

El sistema debe recordar la contraseña para la facilidad de acceso a la aplicación.

Si las credenciales son correctas, el sistema debe redirigir al usuario a la pantalla principal de la aplicación.

Si las credenciales son incorrectas, el sistema debe mostrar un mensaje de error especifico.

El sistema no debe permitir sesiones múltiples, si un usuario inicia sesión el sistema debe cerrar la última sesión con la que ingresó a la aplicación.

El sistema debe mostrar la opción para redirigirse a la pantalla de restablecer contraseña.

El sistema debe mostrar la opción de para crear un usuario en caso de que todavía no se haya creado uno.

Requerimientos funcionales:

Validar correo electrónico:

El sistema debe verificar que el correo electrónico ingresado siga un formato válido (por ejemplo, . Debe contener un “@” y un dominio como “.com” o “.org”) antes de proceder a la autenticación.

Verificación de contraseña:

El sistema debe asegurarse de que la contraseña cumpla con las reglas de seguridad. Mínimo 8 caracteres, mínimo 2 números, mínimo 2 caracteres especiales, mínimo 1 mayúscula.

El sistema debe contar con una opción de mostrar contraseña.

Recordar contraseña:

El sistema debe guardar automáticamente la contraseña del usuario de manera segura en el dispositivo móvil una vez que se haya iniciado sesión correctamente, utilizando técnicas de encriptación para proteger la información almacenada.

Autenticación y redirección:

El sistema debe autenticar al usuario comparando las credenciales ingresadas con las almacenadas en la base de datos. Si son correctas, debe redirigir al usuario a la pantalla principal.

El sistema no debe cerrar la sesión por ningún motivo a meno de que el usuario cierre la sesión manualmente.

Manejo de errores:

Si las credenciales son incorrectas, el sistema debe mostrar un mensaje de error no específico(ambiguo), como “Correo electrónico o contraseña incorrectos”. Este mensaje no debe indicar si el correo electrónico está registrado o no, para mayor seguridad.

Manejo de sesiones múltiples:

El sistema debe verificar si el usuario ya tiene una sesión activa en otro dispositivo. Si es así, debe cerrar la sesión anterior antes de permitir el nuevo inicio de sesión y notificar al usuario que su sesión ha sido transferida.

Restablecimiento de contraseña:

El sistema debe mostrar un botón en la pantalla de inicio de sesión que, al seleccionarlo redirija al usuario a la pantalla de restablecer contraseña.

Creación de nueva cuenta:

El sistema debe proporcionar un botón en la pantalla de inicio de sesión que al seleccionarlo redirija al usuario a la pantalla de registro, donde pueda crear una nueva cuenta.

Requerimientos no funcionales:

Rendimiento:

El sistema debe procesar la autenticación y redirigir al usuario a la pantalla principal lo más rápido posible después de enviar las credenciales mostrando un splash entre el cambio de pantallas.

La aplicación debe ser capaz de manejar al menos 500 solicitudes de inicio de sesión simultáneamente sin una degradación perceptible del rendimiento.

Si ya el usuario está validado en la aplicación y la abre, el sistema debe mostrar la pantalla principal lo más rápido posible.

Seguridad:

Las contraseñas deben ser encriptadas con un algoritmo seguro antes de ser almacenadas o procesadas.

Las credenciales de usuario deben transmitirse de manera segura utilizando el protocolo HTTPS para evitar intercepciones de datos.

Usabilidad:

La pantalla de inicio de sesión debe ser intuitiva y fácil de usar, con un diseño claro y opciones bien etiquetadas para restablecer contraseñas, y crear nuevas cuentas.

Los mensajes de error deben ser comprensibles y deben guiar al usuario para resolver el problema sin revelar información sensible (por ejemplo, "Correo o contraseña incorrectos" en lugar de "Correo no registrado").

Compatibilidad:

La funcionalidad debe ser compatible con dispositivos que operen las últimas 3 versiones de iOS y Android 11 o superior.

La aplicación debe adaptarse y funcionar de manera eficiente en dispositivos móviles de diferentes resoluciones y tamaños de pantalla.

Escalabilidad:

El sistema debe ser capaz de escalar horizontalmente para soportar un aumento en el número de usuarios sin afectar significativamente el rendimiento.

Las soluciones de escalabilidad deben prever un crecimiento en la base de usuarios de al menos un 50% anual.

Confiabilidad:

La aplicación debe tener una disponibilidad del 99% durante el horario pico de uso.

Accesibilidad:

Los elementos interactivos deben tener un contraste adecuado para usuarios con dificultades visuales como por ejemplo los campos para ingresar datos deben de resaltarse cuando se utilizan.

### Epic: Creación de usuario 

#### HU-1: Crear usuario

Como usuario nuevo, quiero ingresar únicamente mis datos necesarios (nombre, teléfono, correo, dirección, país, idioma, contraseña) para la creación de mi cuenta de usuario en la aplicación, para que el proceso sea rápido y sin complicaciones.

Criterios de aceptación:

El sistema debe permitir que el usuario ingrese su nombre, teléfono, correo electrónico, dirección, país, idioma y contraseña.

El correo electrónico debe ser validado en tiempo real para asegurar que esté en el formato correcto.

Si el correo electrónico ya está en uso, el sistema debe mostrar un mensaje claro que indique al usuario que ese correo se encuentre en uso y que debe utilizar otro correo electrónico.

La contraseña debe cumplir con los estándares de seguridad definidos, de no ser así el sistema debe indicarlo.

El sistema debe mostrar los países de Hispanoamérica disponibles y los idiomas en los que la aplicación se puede visualizar.

Al seleccionar un país el sistema debe poner el código de teléfono del respectivo país en al campo de teléfono.

Una vez completado el registro, el sistema debe enviar un correo de confirmación para verificar la cuenta.

El usuario debe aceptar el contrato de licencia de la aplicación para poder crear la cuenta.

Requerimientos funcionales:

Ingreso de datos del usuario:

El sistema debe permitir que el usuario ingrese los datos necesarios: nombre, teléfono, correo electrónico y contraseña.

El sistema debe permitir que el usuario seleccione los datos necesarios: país e idioma.

Validación en tiempo real del correo electrónico.

El sistema debe verificar en tiempo real que el correo electrónico ingresado siga un formato válido (por ejemplo, debe contener “@” y un dominio como “.com” o “.org”).

Verificación de correo en uso:

Si el correo electrónico ya está registrado en el sistema, se debe mostrar un mensaje claro que indique que debe utilizar un correo electrónico diferente.

Validación de contraseña:

El sistema debe permitir que el usuario ingrese una contraseña en un campo de entrada y debe tener un segundo campo para que el usuario confirme la contraseña, asegurando que ambos campos coincidan.

La contraseña debe cumplir con los siguientes estándares de seguridad: tener mínimo 8 caracteres, mínimo 2 números, mínimo 2 caracteres especiales, mínimo 1 mayúscula.

Si la contraseña ingresada en el primer campo no cumple con las reglas de seguridad, el sistema debe mostrar mensajes que expliquen las correcciones necesarias (por ejemplo, "La contraseña debe tener al menos 8 caracteres y un carácter especial").

Si las contraseñas en ambos campos no coinciden, el sistema debe mostrar un mensaje de error en tiempo real, indicando que ambas contraseñas deben ser iguales.

El sistema debe tener una opción para mostrar la contraseña.

Selección de países de idioma:

Al seleccionar la opción de país, el sistema debe desplegar una lista de países de Hispanoamérica disponibles y permitir al usuario seleccionar su país.

Código de teléfono automático:

Al seleccionar un país, el sistema debe asignar automáticamente el código de teléfono correspondiente en el campo de teléfono.

Correo de confirmación:

Una vez completado el registro, el sistema debe enviar un correo electrónico de confirmación al usuario para informar que su cuenta se ha creado con éxito.

Aceptación del contrato de licencia:

El usuario debe aceptar el contrato de licencia de la aplicación antes de que pueda crear la cuenta. El sistema debe mostrar un botón para ver el contrato y permitir que el usuario lo acepte o rechace.

Requerimientos no funcionales:

Rendimiento:

El proceso de validación y creación de cuenta debe ser rápido, con un tiempo de respuesta de menos de 5 segundos para cada acción (por ejemplo, validación de correo, creación de cuenta).

Seguridad:

Los datos del usuario, en particular la contraseña, deben ser encriptados utilizando un algoritmo seguro antes de ser almacenados.

La aplicación debe proteger la transmisión de datos utilizando HTTPS.

El sistema debe incluir mecanismos para prevenir ataques, como inyecciones de datos y spam de registros.

Usabilidad:

La interfaz de creación de cuenta debe ser intuitiva y fácil de usar, con campos claramente etiquetados y validaciones en tiempo real que proporcionen retroalimentación inmediata.

Los mensajes de error deben ser claros y comprensibles, explicando lo que el usuario debe hacer para corregir el problema (por ejemplo, "El correo electrónico ingresado no es válido. Por favor, verifique los datos ingresados o utilice otro correo.").

Compatibilidad:

La funcionalidad debe ser compatible con dispositivos que operen las últimas 3 versiones de iOS y Android 11 o superior.

La aplicación debe funcionar correctamente en dispositivos con diferentes resoluciones y tamaños de pantalla.

Escalabilidad:

El sistema debe ser capaz de manejar un crecimiento en el número de registros simultáneos sin afectar el rendimiento.

Las soluciones de escalabilidad deben prever un crecimiento anual de la base de usuarios del 25%.

Privacidad y Cumplimiento:

El sistema debe cumplir con normativas de privacidad de datos, asegurando que la información personal del usuario se maneje de manera segura y no se comparta sin consentimiento.

Los datos sensibles (como la contraseña) deben estar encriptados tanto en tránsito como en reposo.

Internacionalización:

La aplicación debe soportar idiomas como inglés y español y adaptar la presentación del contenido en función del idioma y región seleccionados.

#### HU- 2: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de inicio de sesión) desde la pantalla de crear usuario

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Recuperación de contraseña 

#### HU- 1: Recuperar contraseña

Como usuario que ha olvidado su contraseña, quiero poder recuperar el acceso a mi cuenta ingresando mi correo electrónico para recibir un código de verificación, el cual usaré para establecer una nueva contraseña, para que pueda volver a acceder a la aplicación de manera segura.

Criterios de aceptación:

El usuario debe poder ingresar su correo electrónico en el formulario de recuperación de contraseña.

El sistema debe verificar si el correo electrónico está asociado a una cuenta y enviar un código de verificación si es válido.

El usuario debe poder ingresar el código de verificación y el sistema debe validar que sea correcto y no haya expirado.

El usuario debe poder establecer una nueva contraseña que cumpla con las políticas de seguridad.

El sistema debe mostrar el tiempo que le resta al código que se envió al correo.

Si el código es incorrecto o ha expirado, se debe mostrar un mensaje de error claro.

Si el correo electrónico no está registrado, se debe mostrar un mensaje adecuado sin revelar detalles de seguridad.

El usuario debe recibir una notificación de éxito una vez que la contraseña se haya restablecido correctamente.

Luego de restablecer la contraseña el sistema debe redirigir al usuario a la pantalla de login para que ingrese las nuevas credenciales.

Requerimientos funcionales:

Recuperación de Cuenta:

El sistema debe permitir al usuario ingresar su correo electrónico en un formulario de recuperación.

El sistema debe verificar si el correo electrónico ingresado está asociado a una cuenta válida.

El sistema debe enviar un código de verificación al correo electrónico válido del usuario.

Validación del Código.

El sistema debe permitir al usuario ingresar el código de verificación recibido por correo.

El sistema debe validar que el código ingresado sea correcto y que no haya expirado.

Si el código ingresado es incorrecto o ha expirado, el sistema debe mostrar un mensaje de error claro.

Restablecimiento de Contraseña:

El sistema debe permitir al usuario establecer una nueva contraseña que cumpla con las políticas de seguridad.

Si la nueva contraseña no cumple con los estándares de seguridad, el sistema debe mostrar un mensaje explicativo sobre las correcciones necesarias.

Una vez que la contraseña se restablezca exitosamente, el sistema debe notificar al usuario.

Mensajes de Retroalimentación:

Si el correo electrónico ingresado no está registrado, el sistema debe mostrar un mensaje que indique que no se encontró una cuenta asociada, sin revelar detalles de seguridad.

El sistema debe mostrar al usuario el tiempo restante de validez del código de verificación enviado.

Requerimientos no funcionales:

Seguridad:

Los datos sensibles, como la contraseña y el código de verificación, deben ser encriptados utilizando algoritmos seguros.

La aplicación debe utilizar HTTPS para proteger la transmisión de datos entre el cliente y el servidor.

El sistema debe prevenir ataques como fuerza bruta, spam de solicitudes y acceso no autorizado.

Rendimiento:

El proceso de envío del código de verificación al correo debe tardar menos de 10 segundos.

El sistema debe procesar la validación del correo y del código en menos de 5 segundos en el 95% de los casos.

Usabilidad: 

Los mensajes de error y confirmación deben ser claros, comprensibles y proporcionar retroalimentación inmediata.

La interfaz del formulario debe ser intuitiva, con campos bien etiquetados y accesibles.

Compatibilidad:

La funcionalidad debe ser compatible con dispositivos que operen las últimas 3 versiones de iOS y Android 11 o superior.

El sistema debe adaptarse correctamente a pantallas de distintos tamaños y resoluciones.

Escalabilidad:

El sistema debe manejar múltiples solicitudes de recuperación de contraseña simultáneamente sin afectar el rendimiento.

#### HU- 2: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de inicio de sesión) desde la pantalla de recuperar contraseña.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Diagramas de Flujo – Inicio de sesión

Flujo 1: HU-1

### Diagramas de Flujo – Creación de usuario

Flujo 2: HU-1

### Diagramas de Flujo – Recuperación de contraseña

Flujo 3: HU-1

# Pantalla principal y manejo del dispositivo

## Generalidades

Este documento incluye ciertas funcionalidades comunes (como regresar a la pantalla anterior) que están descritas en el “Documento de Generalidades”. Las pantallas que se contemplan en este documento respetan esas reglas a excepción de la pantalla principal (visualización y gestión de dispositivo en pantalla principal).

Las pantallas que cuenten con campos para ingresar información siguen las reglas definidas en el Documento de Generalidades: Identificación – Resaltado de Campos de Ingreso de Información.

## Pantalla Principal y Manejo de Dispositivo

### Epic: Visualización y gestión de dispositivos en pantalla principal 

#### HU-1: Visualización de Dispositivos y navegación

Como usuario de la aplicación, quiero ver una lista de dispositivos, incluyendo la navegación entre grupos de dispositivos (si los hay), y al seleccionar uno, ser redirigido a la pantalla de "Manejo del dispositivo" para acceder a los controles específicos y gestionar sus características de manera efectiva.

Criterios de aceptación:

El sistema debe mostrar una lista de dispositivos que el usuario pueda desplazar hacia arriba o hacia abajo.

Si el usuario no tiene dispositivos, el sistema debe mostrar un mensaje indicando que la lista está vacía.

El sistema debe permitir la navegación entre las categorías de dispositivos y mostrar una etiqueta que indique el agrupamiento.

Al seleccionar un dispositivo, el sistema debe redirigir al usuario a la pantalla "Manejo del dispositivo" para gestionar las opciones específicas de ese dispositivo.

Requerimientos Funcionales

1. Visualización de Dispositivos

El sistema debe mostrar una lista desplazable de dispositivos asociados al usuario.

El sistema debe tener la opción de mostrar los dispositivos en cuadricula.

Si el usuario no tiene dispositivos, el sistema debe mostrar un mensaje que indique que la lista está vacía.

2. Navegación entre Grupos de Dispositivos

El sistema debe permitir que el usuario navegue entre las categorías o grupos de dispositivos, deslizando la barra donde estos se encuentran.

Al seleccionar un grupo el sistema debe mostrar los dispositivos que pertenecen a este.

3. Selección y Redirección

Al seleccionar un dispositivo de la lista, el sistema debe redirigir al usuario a la pantalla "Manejo del dispositivo."

Requerimientos No Funcionales

1. Rendimiento

La lista de dispositivos debe cargarse lo mas rápido posible en el 95% de los casos.

La navegación entre grupos debe ser inmediata al cambiar de grupo.

2. Usabilidad

La interfaz debe ser intuitiva y permitir un desplazamiento suave de la lista.

Los estados de los dispositivos deben representarse mediante etiquetas claras y visuales (por ejemplo, el dispositivo favorito y los dispositivos bloqueados deben identificarse si los hay).

3. Compatibilidad

La funcionalidad debe ser compatible con dispositivos que operen las ultimas 3 versiones de iOS y Android 11 o superior.

El sistema debe ajustarse correctamente a pantallas de diferentes tamaños y resoluciones.

4. Escalabilidad

El sistema debe ser capaz de manejar listas con hasta 100 dispositivos sin afectar el rendimiento.

5. Privacidad y Seguridad

La información de los dispositivos debe estar protegida y mostrarse únicamente al usuario autenticado correspondiente.

Las transacciones relacionadas con la visualización y selección de dispositivos deben realizarse mediante conexiones seguras (HTTPS).

#### HU-2: Dispositivo Favorito y Botón Flotante

Como usuario de la aplicación, quiero que el primer dispositivo de la lista sea el dispositivo favorito y tener sus controles disponibles en un botón flotante en la pantalla principal, para poder interactuar rápidamente con las funciones más importantes del dispositivo.

Criterios de Uso

El primer dispositivo en la lista de dispositivos debe ser automáticamente marcado como el favorito.

El botón flotante debe estar siempre visible en la pantalla principal, con las funciones principales del dispositivo favorito.

Al interactuar con el botón flotante, el sistema debe ejecutar de manera inmediata las acciones específicas del dispositivo favorito (por ejemplo, abrir, cerrar, detener).

Si el dispositivo favorito cambia de posición en la lista o deja de estar disponible, el botón flotante debe actualizarse automáticamente para reflejar el nuevo dispositivo favorito o deshabilitarse si no hay dispositivos disponibles.

Requerimientos Funcionales

1. Selección del Dispositivo Favorito:

El sistema debe marcar automáticamente como favorito al primer dispositivo que se agregó en la lista de dispositivos.

Si no hay dispositivos en la lista, el sistema no debe mostrar el botón flotante.

2. Visualización del Botón Flotante:

El sistema debe mostrar un botón flotante en la pantalla principal con las funciones principales del dispositivo favorito.

3. Interacción con el Botón Flotante:

El botón flotante debe permitir al usuario ejecutar funciones clave del dispositivo favorito, como abrir, cerrar, o activar.

4. Actualización Automática:

El sistema debe actualizar el contenido y las funciones del botón flotante en tiempo real si el dispositivo favorito cambia.

Requerimientos No Funcionales

1. Rendimiento:

Las acciones realizadas a través del botón flotante deben ejecutarse lo más rápido posible.

La actualización del botón flotante debe ser rápida al cambiar el dispositivo favorito.

2. Usabilidad:

El botón flotante debe ser accesible y claramente visible, sin obstruir otras funcionalidades de la pantalla principal.

El diseño debe ser intuitivo, utilizando íconos claros y fácilmente reconocibles para las acciones disponibles.

3. Compatibilidad:

La funcionalidad del botón flotante debe funcionar correctamente en dispositivos que operen con iOS 16 o superior y Android 11 o superior.

4. Seguridad:

El botón flotante debe mostrar únicamente las funciones autorizadas para el usuario autenticado, protegiendo el acceso no autorizado.

5. Escalabilidad:

El sistema debe permitir el manejo fluido del botón flotante.

6. Resiliencia:

Si el dispositivo favorito deja de estar disponible, el sistema debe deshabilitar el botón flotante o mostrar un mensaje adecuado sin interrumpir otras funciones de la aplicación.

#### HU-3: Navegación a pantalla de opciones

Como usuario de la aplicación, quiero tener un botón que me redirija a la pantalla de Opciones, donde pueda gestionar grupos, dispositivos, y configurar otras características, para mantener organizada y actualizada mi experiencia en la aplicación, además de tener una fácil accesibilidad a estas características.

Criterios de Uso

El sistema debe mostrar un botón claro y visible en la pantalla principal para acceder a la pantalla de Opciones.

El botón debe estar siempre disponible y accesible desde la pantalla principal sin interferir con otras funciones.

Al seleccionar el botón, el sistema debe redirigir al usuario a la pantalla de Opciones sin errores ni retrasos.

El botón debe incluir un ícono o texto que indique claramente que lleva a la pantalla de Opciones.

Requerimientos Funcionales

1. Visualización del Botón de Opciones:

El sistema debe mostrar un botón dedicado en la pantalla principal para acceder a la pantalla de Opciones.

2. Redirección a la Pantalla de Opciones:

Al interactuar con el botón, el sistema debe redirigir al usuario a la pantalla de Opciones, donde podrá gestionar grupos, dispositivos y otras configuraciones.

3. Indicadores Visuales:

El botón debe incluir un ícono representativo y texto que indique su funcionalidad, como una rueda dentada y la palabra "Opciones".

Requerimientos No Funcionales

1. Usabilidad:

El diseño del botón debe ser intuitivo, con un tamaño y posición que faciliten su interacción en dispositivos de diferentes tamaños.

Los indicadores visuales del botón deben ser reconocibles y comprensibles por todos los usuarios.

2. Rendimiento:

La redirección a la pantalla de Opciones debe realizarse inmediatamente.

3. Compatibilidad:

El botón debe funcionar correctamente en dispositivos que operen con iOS 16 o superior y Android 11 o superior.

4. Seguridad:

Solo los usuarios autenticados deben poder acceder a la pantalla de Opciones mediante este botón.

5. Escalabilidad:

La funcionalidad del botón debe mantenerse eficiente, independientemente del número de opciones o configuraciones disponibles en la pantalla de Opciones.

6. Resiliencia:

Si ocurre un error durante la redirección a la pantalla de Opciones, el sistema debe mostrar un mensaje claro y permitir al usuario reintentar la acción sin necesidad de reiniciar la aplicación.

#### HU- 4: Cerrar sesión 

Como usuario, quiero poder cerrar la sesión mediante un botón para regresar a la pantalla de inicio de sesión.

Criterios de aceptación:

El sistema debe mostrar un botón claro y visible en la pantalla principal para cerrar sesión.

El botón debe estar siempre disponible y accesible sin interferir con otras funciones de la pantalla.

Al seleccionar el botón, el sistema debe cerrar la sesión del usuario y redirigir a la pantalla de inicio de sesión sin errores ni retrasos.

El botón debe incluir un ícono o texto que indique claramente su funcionalidad, como "Cerrar sesión".

Requerimientos Funcionales

Visualización del Botón de Cerrar Sesión: 

El sistema debe mostrar un botón dedicado en la pantalla principal.

Cierre de Sesión: 

Al interactuar con el botón, el sistema debe invalidar la sesión del usuario y cerrar su sesión activa.

Redirección a la Pantalla de Inicio de Sesión: 

Una vez cerrada la sesión, el sistema debe redirigir al usuario automáticamente a la pantalla de inicio de sesión.

Manejo de Errores: 

Si ocurre un error al cerrar la sesión, el sistema debe mostrar un mensaje claro, como "No se pudo cerrar sesión. Inténtalo nuevamente".

Indicadores Visuales: 

El botón debe incluir un ícono representativo (por ejemplo, una puerta de salida) y texto que indique su funcionalidad, como "Cerrar sesión".

Requerimientos No Funcionales

Usabilidad: 

El botón debe ser intuitivo, con un tamaño y posición que faciliten su interacción en dispositivos de diferentes tamaños.

Los indicadores visuales deben ser reconocibles y comprensibles por todos los usuarios.

Rendimiento: 

El cierre de sesión y la redirección a la pantalla de inicio de sesión deben realizarse inmediatamente sin retrasos perceptibles.

Compatibilidad: 

La funcionalidad debe operar correctamente en dispositivos con iOS 16 o superior y Android 11 o superior.

Seguridad: 

Al cerrar sesión, la información de la sesión debe invalidarse por completo para evitar accesos no autorizados.

No deben quedar datos temporales o caché sensibles en el sistema.

Escalabilidad: 

La funcionalidad del cierre de sesión debe mantenerse eficiente independientemente del número de usuarios concurrentes o la carga del sistema.

### Epic: Manejar y gestionar dispositivo

#### HU-1: Botón flotante con opciones del dispositivo principal 

Como usuario, quiero visualizar y acceder al botón flotante con las opciones del dispositivo seleccionado para manejar sus acciones directamente.

Criterios de aceptación: 

El botón flotante debe estar visible en la pantalla de manejo del dispositivo.

El botón flotante debe mostrar un menú con las opciones del dispositivo seleccionado.

Requerimientos Funcionales

Visualización del Botón Flotante:

El sistema debe mostrar un botón flotante siempre visible en la pantalla de manejo del dispositivo, con las opciones correspondientes al dispositivo seleccionado.

Selección de Opciones:

El botón flotante debe permitir al usuario seleccionar entre diferentes acciones del dispositivo seleccionado (por ejemplo, abrir, cerrar, detener).

El sistema debe realizar las acciones correspondientes de manera inmediata al seleccionar una opción.

Requerimientos No Funcionales

Usabilidad:

El diseño del botón flotante debe ser intuitivo, con un tamaño adecuado que no obstruya otras funciones de la pantalla.

Las opciones del botón flotante deben ser claramente visibles y fáciles de interactuar.

Rendimiento:

La interacción con el botón flotante debe realizarse lo más rápido posible.

Compatibilidad:

El botón flotante debe funcionar correctamente en dispositivos que operen con iOS 16 o superior y Android 11 o superior.

Seguridad:

El botón flotante debe garantizar que las opciones solo estén disponibles para usuarios autenticados y que tengan acceso a las funciones del dispositivo seleccionado.

Escalabilidad:

El sistema debe manejar correctamente un número de opciones en el botón flotante sin afectar el rendimiento de la interfaz de usuario.

#### HU-2: Etiqueta de estado del dispositivo

Como usuario, quiero visualizar una etiqueta que me muestre el estado actual del dispositivo para entender qué acción se está ejecutando.

Criterios de aceptación:

La etiqueta debe ser visible en la pantalla de opciones.

La etiqueta debe mostrar el estado actual del dispositivo en tiempo real (por ejemplo: "Abierto", "Cerrado", "En proceso", etc.).

El estado debe actualizarse dinámicamente si cambia mientras el usuario está en la pantalla.

Requerimientos Funcionales

Visualización de la Etiqueta de Estado: 

El sistema debe mostrar una etiqueta visible en la pantalla de opciones que indique el estado actual del dispositivo.

Actualización en Tiempo Real del Estado: 

La etiqueta debe actualizar el estado en tiempo real del dispositivo (por ejemplo: "Abierto", "Cerrado", "En proceso", etc.).

Claridad de Información: 

La etiqueta debe ser claramente legible, con un diseño que permita identificar el estado del dispositivo de manera inmediata.

Requerimientos No Funcionales

Usabilidad: 

La etiqueta debe tener un diseño claro, conciso y comprensible. 

Rendimiento: 

El tiempo de actualización del estado en la etiqueta debe ser acorde al estado físico del dispositivo.

Compatibilidad: 

La etiqueta de estado debe mostrarse correctamente en diferentes tamaños y resoluciones de pantalla en dispositivos con iOS 16 o superior y Android 11 o superior.

Accesibilidad: 

La etiqueta debe ser accesible para usuarios con discapacidad visual, usando texto claro y compatible con lectores de pantalla.

Escalabilidad: 

El sistema debe poder manejar el cambio de estado en múltiples dispositivos sin afectar la visualización de la etiqueta o el rendimiento de la aplicación.

#### HU-3: Botón de bloqueo del dispositivo

Como usuario, quiero bloquear el dispositivo para evitar que se realicen acciones sobre él, si tengo el permiso correspondiente.

Criterios de aceptación: 

El botón de bloqueo debe estar visible solo para usuarios con permiso para bloquear dispositivos.

Al activar el bloqueo, los demás botones de control (interruptor, lámpara, checkbox) deben deshabilitarse.

Si el dispositivo está bloqueado, debe mostrarse un indicador visual.

Requerimientos Funcionales

Visibilidad del Botón de Bloqueo: 

El sistema debe mostrar el botón de bloqueo solo a los usuarios que tengan permisos para bloquear el dispositivo.

Acción de Bloqueo del Dispositivo: 

Al activar el botón de bloqueo, el dispositivo debe quedar bloqueado, y el sistema debe deshabilitar todos los botones de control (como interruptores, lámparas, botones) relacionados con ese dispositivo y bloquearlo a los usuarios que tengan acceso a este.

Indicador Visual de Bloqueo: 

El sistema debe mostrar un indicador visual (por ejemplo, un icono o mensaje) que indique que el dispositivo está bloqueado. Este indicador debe ser claramente visible para el usuario.

Requerimientos No Funcionales

Usabilidad:

El botón de bloqueo debe ser fácilmente identificable y accesible, con un diseño claro que indique su funcionalidad.

El indicador visual de bloqueo debe ser destacable, utilizando colores o iconos fácilmente reconocibles para que el usuario sepa de inmediato si el dispositivo está bloqueado.

Seguridad:

Solo los usuarios con permisos adecuados podrán activar o desactivar el bloqueo del dispositivo, garantizando que el acceso a esta función esté restringido.

Rendimiento:

La acción de bloqueo y el deshabilitado de los botones deben ejecutarse de manera rápida, sin demoras perceptibles.

Compatibilidad:

El sistema debe funcionar correctamente en dispositivos con diferentes resoluciones y tamaños de pantalla, asegurando que el botón de bloqueo y el indicador visual se vean correctamente en cualquier dispositivo.

El botón debe funcionar correctamente en dispositivos con iOS 16 o superior y Android 11 o superior.

Resiliencia:

Si ocurre un error al intentar bloquear o desbloquear el dispositivo, el sistema debe mostrar un mensaje claro al usuario, indicando el motivo del error y cómo solucionarlo.

#### HU-4: Botón de interruptor (relé auxiliar)

Como usuario, quiero encender o apagar el relé auxiliar del dispositivo, si tengo permisos y la configuración lo permite.

Criterios de aceptación:

El botón debe estar visible solo para usuarios con permisos para controlar el relé auxiliar.

El botón debe estar habilitado solo si la configuración permite controlar el relé.

Al presionar el botón, el estado del relé debe cambiar (encendido/apagado).

Requerimientos Funcionales

Visibilidad del Botón del Relé Auxiliar:

El sistema debe mostrar el botón del relé auxiliar únicamente a los usuarios que tengan permisos para controlar esta función.

Habilitación del Botón Según Configuración:

El botón debe estar habilitado solo si la configuración del dispositivo permite el control del relé auxiliar.

Cambio de Estado del Relé:

Al presionar el botón, el sistema debe cambiar el estado del relé auxiliar entre encendido y apagado, reflejando la acción realizada.

Requerimientos No Funcionales

Usabilidad:

El botón debe ser fácilmente identificable y accesible, con un diseño claro que indique su funcionalidad (por ejemplo, iconos de "encendido" y "apagado").

El sistema debe proporcionar retroalimentación inmediata al usuario sobre el cambio de estado del relé auxiliar (“encendido” y “apagado”).

Seguridad:

Solo los usuarios con permisos adecuados podrán visualizar y utilizar el botón, garantizando que el acceso esté restringido.

Rendimiento:

El cambio de estado del relé auxiliar debe procesarse rápidamente, con un tiempo de respuesta casi inmediato.

Compatibilidad:

El sistema debe garantizar la correcta visibilidad y funcionalidad del botón en dispositivos con diferentes resoluciones y tamaños de pantalla.

Resiliencia:

Si ocurre un error al intentar cambiar el estado del relé auxiliar, el sistema debe mostrar un mensaje claro que explique el problema y proporcione orientación sobre cómo proceder.

#### HU-5: Botón de estado de lámpara

Como usuario, quiero encender o apagar la lámpara del dispositivo si tengo permisos para hacerlo.

Criterios de aceptación: 

El botón debe estar visible solo para usuarios con permisos para controlar la lámpara.

Al presionar el botón, el estado de la lámpara debe cambiar y reflejarse visualmente.

Requerimientos Funcionales

Visibilidad del Botón de la Lámpara:

El sistema debe mostrar el botón de la lámpara únicamente a los usuarios que tengan permisos para controlar esta función.

Cambio de Estado de la Lámpara:

Al presionar el botón, el sistema debe cambiar el estado de la lámpara entre encendida y apagada.

El cambio de estado debe reflejarse visualmente en la interfaz del usuario.

Requerimientos No Funcionales

Usabilidad:

El botón debe ser claramente identificable y accesible, con iconos o etiquetas que indiquen los estados de "encendida" y "apagada".

El sistema debe proporcionar retroalimentación visual inmediata al usuario sobre el cambio de estado de la lámpara.

Seguridad:

Solo los usuarios con permisos adecuados podrán visualizar y utilizar el botón, restringiendo su acceso.

Rendimiento:

El cambio de estado de la lámpara debe procesarse rápidamente, con un tiempo de respuesta casi inmediato.

Compatibilidad:

El sistema debe garantizar que el botón de la lámpara funcione correctamente en dispositivos con diferentes resoluciones y tamaños de pantalla.

Resiliencia:

Si ocurre un error al intentar cambiar el estado de la lámpara, el sistema debe mostrar un mensaje claro indicando el problema y los pasos para resolverlo.

#### HU-6: Botón de consultas

Como usuario con privilegios de administrador, quiero acceder a una opción para consultar registros del dispositivo.

Criterios de aceptación: 

El botón debe estar visible solo para usuarios con permisos de administrador.

Al presionar el botón, el usuario debe ser redirigido a la pantalla de consultas.

Si el usuario no tiene permisos de administrador, el botón debe estar oculto o inactivo.

Requerimientos Funcionales

Visibilidad del Botón de Consultas:

El sistema debe mostrar el botón de consultas únicamente a los usuarios con permisos de administrador.

Redirección a la Pantalla de Consultas:

Al presionar el botón, el sistema debe redirigir al usuario a la pantalla de consultas del dispositivo.

Gestión de Permisos:

Si el usuario no tiene permisos de administrador, el botón debe estar oculto o inactivo para evitar interacciones.

Requerimientos No Funcionales

Usabilidad:

El botón debe ser fácilmente identificable con un diseño claro que indique su función, como un icono representativo y una etiqueta que diga "Consultas".

Seguridad:

Solo los usuarios con permisos de administrador podrán acceder al botón y su funcionalidad, evitando accesos no autorizados.

Rendimiento:

La redirección a la pantalla de consultas debe inmediata.

Compatibilidad:

El botón y su funcionalidad deben funcionar correctamente en dispositivos con diferentes resoluciones, tamaños de pantalla y sistemas operativos iOS con las últimas tres versiones y superiores a Android 11.

Resiliencia:

Si ocurre un error al redirigir a la pantalla de consultas, el sistema debe mostrar un mensaje claro indicando el problema y las acciones recomendadas para solucionarlo.

#### HU-7: Checkbox para mantener el dispositivo abierto

Como usuario, quiero seleccionar una opción para mantener el dispositivo en estado abierto si tengo permisos para hacerlo.

Criterios de aceptación:

El checkbox debe estar visible solo para usuarios con permisos para mantener el dispositivo abierto.

Al seleccionarlo, el dispositivo debe permanecer en estado abierto hasta que se desmarque.

Si el usuario no tiene permisos, el checkbox debe estar deshabilitado u oculto.

Requerimientos Funcionales

Visibilidad del Checkbox:

El sistema debe mostrar el checkbox solo a los usuarios con permisos para mantener el dispositivo abierto.

Función de Estado Abierto:

Al seleccionar el checkbox, el sistema debe mantener el dispositivo en estado abierto hasta que se desmarque.

Gestión de Permisos:

Si el usuario no tiene permisos, el sistema debe deshabilitar o ocultar el checkbox.

Requerimientos No Funcionales

Usabilidad:

El checkbox debe estar claramente etiquetado y acompañado de un texto descriptivo que indique su función, como "Mantener abierto".

Seguridad:

Solo los usuarios autorizados podrán interactuar con el checkbox para evitar configuraciones no deseadas.

Rendimiento:

El cambio en el estado del dispositivo al seleccionar o desmarcar el checkbox debe reflejarse lo mas rápido posible.

Compatibilidad:

El checkbox y su funcionalidad deben operar correctamente en diferentes resoluciones de pantalla y sistemas operativos iOS con las últimas tres versiones y superiores a Android 11.

Resiliencia:

Si ocurre un error al cambiar el estado del dispositivo, el sistema debe mostrar un mensaje claro que indique el problema y los pasos a seguir para solucionarlo.

.

#### HU- 8: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla principal) desde la pantalla de manejo del dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Reportes

#### HU-1: Consultar reportes

Como usuario con permisos de administrador o dueño de un dispositivo, quiero poder ver y descargar los registros para llevar el control completo de las acciones que realiza el dispositivo.

Criterios de aceptación:

El acceso a la consulta de reportes debe estar disponible solo para usuarios con permisos de administrador o propietarios del dispositivo.

El sistema debe mostrar los registros en un formato legible y organizado, incluyendo información relevante como fecha, hora, acción realizada, y usuario que ejecutó la acción.

El usuario debe poder descargar los reportes en formato estándar (PDF).

Los registros mostrados deben actualizarse en tiempo real si se generan nuevas acciones mientras el usuario está viendo la pantalla.

Requerimientos Funcionales

Restricción de Acceso:

Solo usuarios con permisos de administrador o propietarios del dispositivo pueden acceder a la opción de consultar reportes.

Visualización de Registros:

Los reportes deben incluir la siguiente información mínima: 

Fecha y hora de la acción.

Acción realizada.

Usuario que realizó la acción.

Descarga de Reportes:

El sistema debe permitir que el usuario descargue los reportes en formato PDF mediante un botón.

Actualización en Tiempo Real:

La pantalla debe mostrar automáticamente nuevos registros si se generan mientras el usuario está consultando.

Manejo de Errores:

Si no hay registros disponibles, el sistema debe mostrar un mensaje claro indicando que no hay datos para mostrar.

En caso de falla al intentar descargar un reporte, el sistema debe mostrar un mensaje de error con opciones para reintentar o contactar soporte.

Requerimientos No Funcionales

Usabilidad:

La interfaz de consulta debe ser intuitiva y fácil de usar, con la opción clara para descargar los reportes.

Rendimiento:

El tiempo de carga de los registros no debe exceder los 5 segundos para un volumen promedio de datos.

Compatibilidad:

La funcionalidad debe ser compatible con diferentes dispositivos y resoluciones de pantalla y sistemas operativos iOS con las últimas tres versiones y superiores a Android 11.

Seguridad:

Los registros deben estar protegidos contra accesos no autorizados mediante autenticación y encriptación.

Escalabilidad:

El sistema debe manejar volúmenes crecientes de registros sin degradar el rendimiento.

#### HU-2: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de manejo del dispositivo) desde la pantalla de reportes.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Diagramas de Flujo - Visualización y gestión de dispositivos en pantalla principal

Flujo 1: HU-1

Flujo 2: HU-2

### Diagramas de Flujo - Manejar y gestionar dispositivo

Flujo 3: HU-1

Flujo 4: HU-2

Flujo 5: HU-3

Flujo 6: HU-4

Flujo 7: HU-5

Flujo 8: HU-6

Flujo 9: HU-7

### Diagramas de Flujo – Reportes

Flujo 10: HU-1

# Opciones y configuración

## Generalidades

Este documento incluye ciertas funcionalidades comunes (como regresar a la pantalla anterior) que están descritas en el “Documento de Generalidades”. Las pantallas que se contemplan en este documento respetan esas reglas.

Las pantallas que cuenten con campos para ingresar información siguen las reglas definidas en el Documento de Generalidades: Identificación – Resaltado de Campos de Ingreso de Información.

## Opciones y configuración

### Epic: Opciones y configuración

#### HU-1: Visualizar dispositivos y grupos.

Como usuario, quiero visualizar los dispositivos propios y de terceros y grupos disponibles en mi cuenta, ordenados por frecuencia de uso, para identificar fácilmente aquellos que utilizo más.

Criterios de aceptación:

Deben mostrarse todos los dispositivos y grupos asociados a la cuenta del usuario.

Los dispositivos deben estar ordenados por frecuencia de uso, de mayor a menor.

Los dispositivos propios deben estar claramente diferenciados de los dispositivos de terceros.

Requerimientos Funcionales

Carga de Dispositivos y Grupos:

El sistema debe cargar y mostrar todos los dispositivos y grupos vinculados a la cuenta del usuario.

Ordenación por Frecuencia de Uso:

El sistema debe calcular la frecuencia de uso de cada dispositivo y ordenarlos de mayor uso a menor uso.

Diferenciación Visual:

Los dispositivos propios deben estar marcados con letra negrita para diferenciarlos de los dispositivos de terceros.

Visualización de Grupos:

Los grupos deben mostrarse en una barra que contenga todos los grupos creados.

Requerimientos No Funcionales

Rendimiento:

El tiempo de carga para mostrar dispositivos y grupos debe ser lo más rápido posible.

Usabilidad:

La interfaz debe ser intuitiva y permitir al usuario identificar rápidamente los dispositivos más utilizados y diferenciar los propios de los de terceros.

Compatibilidad:

La funcionalidad debe estar disponible en dispositivos móviles adaptándose a diferentes resoluciones de pantalla y sistemas operativos iOS con las últimas tres versiones y superiores a Android 11.

Actualización Dinámica:

Si cambian los datos de uso de un dispositivo o se añaden nuevos dispositivos o grupos, la lista debe actualizarse automáticamente sin necesidad de recargar la página.

Seguridad:

Solo los usuarios autenticados deben poder acceder a la lista de dispositivos y grupos vinculados a su cuenta.

#### HU- 2: Acceder a edición de dispositivos y grupos

Como usuario, quiero acceder a la pantalla de edición de dispositivos propios y de terceros o grupos seleccionados para realizar cambios según sea necesario.

Criterios de aceptación:

Al seleccionar un dispositivo propio o de terceros, el sistema debe redirigir al usuario a la pantalla de edición de dispositivo.

Al seleccionar un grupo, el sistema debe redirigir al usuario a la pantalla de edición de grupos.

Requerimientos Funcionales

Redirección a Pantallas de Edición:

Al seleccionar un dispositivo propio o de terceros, el sistema debe redirigir al usuario a la pantalla de edición del dispositivo correspondiente.

Al seleccionar un grupo, el sistema debe redirigir al usuario a la pantalla de edición de grupos.

Disponibilidad de opciones:

Las opciones de editar grupos o dispositivos deben estar visibles y accesibles en cada uno de los dispositivos y grupos.

Requerimientos No Funcionales

Usabilidad:

Las opciones deben estar claramente etiquetadas para facilitar su identificación.

Deben ser lo suficientemente grandes y estar ubicados de manera intuitiva para evitar errores al pulsar.

Rendimiento:

La redirección debe completarse en menos de 1 segundo tras pulsar la opción.

Diseño:

Las opciones deben tener íconos y / o colores que representen claramente sus funciones para mejorar la experiencia del usuario.

#### HU- 3: Redirección desde botones inferiores

Como usuario, quiero acceder a la pantalla de agregar dispositivo, configuración o usuario desde los botones inferiores para gestionar mi cuenta y dispositivos.

Criterios de aceptación:

El botón de Agregar dispositivo debe redirigir al usuario a la pantalla Agregar Dispositivos.

El botón de Configuración debe redirigir al usuario a la pantalla Configuración.

El botón de Usuarios debe redirigir al usuario a la pantalla Usuarios.

Requerimientos Funcionales

Redirección desde Botones Inferiores:

El botón Agregar Dispositivo debe redirigir al usuario a la pantalla Agregar Dispositivos.

El botón Configuración debe redirigir al usuario a la pantalla Configuración.

El botón Usuarios debe redirigir al usuario a la pantalla Usuarios.

Disponibilidad de Botones:

Los botones deben estar visibles y accesibles en la parte inferior de la interfaz principal.

Requerimientos No Funcionales

Usabilidad:

Los botones deben estar claramente etiquetados y organizados para facilitar su identificación.

Deben ser lo suficientemente grandes y estar ubicados de manera intuitiva para evitar errores al pulsar.

Rendimiento:

La redirección debe completarse en menos de 1 segundo tras pulsar el botón.

Diseño:

Los botones deben tener íconos o colores que representen claramente sus funciones para mejorar la experiencia del usuario.

.

#### HU-4: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla principal) desde la pantalla de opciones.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Gestión de usuarios

#### HU- 1: Visualizar lista de usuarios registrados

Como usuario, quiero visualizar una lista de usuarios registrados que pueden o no tener acceso a algún dispositivo registrado junto con su tipo de acceso para gestionarlos adecuadamente.

Criterios de aceptación:

La lista debe mostrar los usuarios registrados que tienen o no acceso a algún dispositivo y su tipo de acceso (control remoto, Bluetooth, o usuario virtual) mediante un pequeño icono.

El usuario no debe verse a si mismo en la lista.

Cada usuario debe tener una opción para consultar los dispositivos a los que tiene acceso.

Requerimientos Funcionales

Visualización de Usuarios Registrados:

Mostrar una lista de todos los usuarios registrados en el sistema, excluyendo al usuario que visualiza la lista.

Indicar para cada usuario si tiene acceso a algún dispositivo registrado y su tipo de acceso (control remoto, Bluetooth, o usuario virtual) mediante un ícono distintivo.

Acceso Detallado por Usuario:

Proveer una opción para consultar los dispositivos a los que cada usuario tiene acceso.

Requerimientos No Funcionales

Usabilidad:

La lista debe ser fácil de navegar y buscar usuarios específicos.

Los íconos que indican el tipo de acceso deben ser intuitivos y claramente diferenciables.

Rendimiento:

La lista debe cargarse completamente lo más rápido posible, incluso con un número elevado de usuarios registrados.

Diseño:

El diseño debe ser limpio y permitir la visualización clara de la información relevante para cada usuario.

#### HU- 2: Consultar dispositivos asociados a un usuario

Como usuario, quiero consultar los dispositivos asociados en caso de que existan a un usuario registrado para conocer su acceso en caso de que cuente con uno.

Criterios de aceptación:

Al seleccionar un usuario, el sistema debe mostrar una lista de los dispositivos asociados a él.

Al seleccionar un dispositivo de la lista, el sistema debe redirigir a la pantalla de información del dispositivo correspondiente.

Requerimientos Funcionales

Consulta de Dispositivos Asociados a un Usuario:

Proveer una funcionalidad que permita mostrar una lista de dispositivos asociados al usuario seleccionado, si existen.

Acceso Detallado al Dispositivo:

Al seleccionar un dispositivo de la lista, redirigir al usuario a la pantalla de Información del Dispositivo como corresponde.

Requerimientos No Funcionales

Usabilidad:

La lista de dispositivos debe ser clara y fácil de navegar.

El sistema debe notificar si el usuario seleccionado no tiene dispositivos asociados.

Rendimiento:

La lista de dispositivos asociados debe cargarse rapidamente tras seleccionar al usuario.

Diseño:

La lista debe mostrar el nombre del dispositivo para facilitar su identificación.

#### HU- 3: Modificar o eliminar un usuario

Como usuario, quiero poder modificar el nombre o eliminar un usuario para actualizar información y / o gestionar los accesos.

Criterios de aceptación:

Al seleccionar un usuario registrado el sistema debe permitir modificar el nombre o eliminar al usuario y tener una opción para cancelar la acción.

Para eliminar un usuario primero debe desvincularse del dispositivo al que esté vinculado.

Requerimientos Funcionales

Edición de Nombre del Usuario:

Proveer una opción para modificar el nombre del usuario registrado al seleccionarlo.

Eliminación de un Usuario:

Permitir eliminar al usuario seleccionado, asegurándose de que primero se desvinculen todos los dispositivos asociados.

Cancelación de Acciones:

Incluir una opción para cancelar la acción de edición o eliminación del usuario.

Requerimientos No Funcionales

Validaciones:

Antes de eliminar un usuario, verificar si existen dispositivos asociados. Si los hay, mostrar un mensaje indicando que debe desvincularlos previamente.

Usabilidad:

El sistema debe mostrar un mensaje de confirmación antes de realizar la eliminación del usuario.

Rendimiento:

Las acciones de edición o eliminación deben completarse rapidamente después de confirmarlas.

Diseño:

El cuadro que se muestra al seleccionar un usuario debe mostrar de manera clara las opciones de edición, eliminación, y cancelación, con botones accesibles y diferenciados.

#### HU- 4: Vincular un usuario nuevo

Como usuario, quiero poder ingresar a la pantalla de Vincular usuario virtual para registrar un usuario invitado a en mi cuenta.

Criterios de aceptación:

Al presionar el botón “Vincular Usuario”, el sistema debe redirigir a la pantalla de vinculación de usuario virtual.

Requerimientos Funcionales

Acceso a la Pantalla de Vinculación:

Implementar un botón denominado “Vincular Usuario” en la interfaz de usuario.

Redirección:

Al presionar el botón “Vincular Usuario”, redirigir al usuario a la pantalla de vinculación de usuario virtual.

Requerimientos No Funcionales

Usabilidad:

El botón debe ser fácilmente identificable y estar ubicado en una sección accesible de la pantalla.

Rendimiento:

La redirección a la pantalla de vinculación debe realizarse rapidamente.

Diseño:

El botón debe tener un diseño coherente con la estética de la aplicación, utilizando colores y etiquetas claras.

#### HU- 5: Regresar a la pantalla anterior

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de opciones) desde la pantalla de usuarios.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Vincular usuario virtual

#### HU-1: Vincular usuario virtual

Como usuario, quiero poder vincular un usuario invitado a mi cuenta para poder darle acceso a mis dispositivos.

Criterios de aceptación:

El usuario invitado debe ser de existir en la plataforma.

El usuario debe poder agregar el correo del usuario invitado y agregarle una etiqueta.

Al presionar el botón de agregar, el sistema debe agregar al usuario invitado a la lista en la pantalla de usuarios identificando a este con la etiqueta asignada.

El sistema debe mostrar un mensaje de que el usuario invitado se ha agregado con éxito.

Requerimientos Funcionales

Verificación de Usuario Existente:

El sistema debe verificar que el usuario invitado exista en la plataforma antes de vincularlo a la cuenta.

Ingreso de Correo y Etiqueta:

El sistema debe permitir al usuario agregar el correo electrónico del usuario invitado y asignarle una etiqueta.

Agregar a la Lista de Usuarios:

Al presionar el botón de agregar, el sistema debe vincular al usuario invitado a la cuenta y mostrarlo en la lista de usuarios registrados en la pantalla de usuarios.

La etiqueta asignada es el nombre del usuario en la lista.

Confirmación del Agregado:

El sistema debe mostrar un mensaje de éxito confirmando que el usuario invitado ha sido agregado correctamente.

Requerimientos No Funcionales

Usabilidad:

El formulario de vinculación debe ser sencillo y rápido de completar, con validaciones claras para el correo electrónico.

El mensaje de confirmación debe ser visible y accesible para el usuario.

Rendimiento:

La operación de agregar al usuario invitado y actualizar la lista de usuarios debe ser completada lo más rápido posible.

Seguridad:

El correo electrónico del usuario invitado debe ser validado correctamente para evitar errores o intentos de vinculación a correos no registrados.

Diseño:

El diseño del formulario debe ser coherente con el diseño general de la aplicación, con campos claramente definidos para el correo y la etiqueta.

#### HU-2: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de usuarios) desde la pantalla de vincular usuario virtual.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Agregar dispositivo

#### HU- 1: Vincular dispositivo mediante red WiFi

Como usuario, quiero vincular un nuevo dispositivo mediante WiFi seleccionando la red a la que quiero que se conecte y seleccionando el dispositivo disponible para que este quede conectado a la nube y vinculado a mi cuenta.

Criterios de aceptación:

El botón “Escanear” debe lograr escanear las redes y los dispositivos disponibles.

El sistema debe permitir seleccionar la red WiFi. 

El sistema debe permitir seleccionar el dispositivo que se va a vincular.

El sistema debe permitir agregar el dispositivo mediante un botón.

Si el dispositivo ya está vinculado a otra cuenta, el sistema debe mostrar un mensaje indicando que no se puede vincular.

Requerimientos funcionales:

Escaneo de redes y dispositivos disponibles:

El sistema debe permitir que el usuario presione el botón “Escanear” para realizar una búsqueda de redes WiFi y dispositivos disponibles.

El sistema debe mostrar una lista de redes WiFi disponibles y dispositivos detectados en un tiempo razonable.

Selección de red WiFi:

El sistema debe permitir al usuario seleccionar una red WiFi de la lista de redes disponibles.

Al seleccionar una red, el sistema debe validar que la red esté accesible y disponible para conectar el dispositivo.

En caso de seleccionar una red WiFi no guardada en el teléfono del usuario, el sistema permite abrir una ventana donde se ingresarán los datos de la red para guardarlos.

Selección del dispositivo:

El sistema debe mostrar una lista de dispositivos disponibles que se pueden vincular a la red seleccionada.

El usuario debe poder seleccionar el dispositivo que desea vincular a su cuenta.

Vinculación del dispositivo:

El sistema debe permitir al usuario agregar el dispositivo seleccionado mediante un botón de vinculación.

El sistema debe vincular el dispositivo con la cuenta del usuario y asegurar que el dispositivo se conecte correctamente a la red WiFi seleccionada.

Verificación de dispositivo vinculado previamente:

Si el dispositivo ya está vinculado a otra cuenta, el sistema debe mostrar un mensaje de error indicando que no se puede vincular el dispositivo a la cuenta actual.

Requerimientos no funcionales:

Tiempo de respuesta del escaneo:

El sistema debe completar el escaneo de redes WiFi y dispositivos disponibles en un tiempo rápido para garantizar una experiencia de usuario fluida.

Conexión segura:

El sistema debe utilizar conexiones seguras (como HTTPS y WPA2 para redes WiFi) para proteger los datos transmitidos entre el dispositivo del usuario y la red.

Compatibilidad:

La funcionalidad debe ser compatible con diferentes tamaños de pantalla y resoluciones y sistemas operativos como los 3 últimos en caso de iOS y de Android 11 en adelante.

Interfaz de usuario intuitiva:

La interfaz debe ser clara y fácil de usar, con listas bien organizadas de redes WiFi y dispositivos disponibles, asegurando que los usuarios puedan realizar la vinculación sin confusión.

Manejo de errores y mensajes:

El sistema debe proporcionar mensajes claros y específicos en caso de errores, como problemas de red, dispositivos no disponibles, o dispositivos ya vinculados a otra cuenta, para guiar al usuario sobre los pasos necesarios para resolverlos.

Rendimiento:

Las consultas y actualizaciones realizadas en la base de datos en la nube durante el proceso de vinculación deben completarse en el menor tiempo posible.

Disponibilidad:

La plataforma en la nube que gestiona la información de los dispositivos debe garantizar una disponibilidad alta, asegurando que los usuarios puedan realizar el proceso de vinculación en cualquier momento del día.

#### HU- 2: Vincular dispositivo mediante número de serie

Como usuario, quiero vincular un nuevo dispositivo ingresando directamente su número de serie para agilizar el proceso de vinculación.

Criterios de aceptación:

El sistema debe permitir ingresar directamente el número de serie del dispositivo.

Si el número de serie es válido, el sistema debe enviar los datos necesarios a la nube para vincular el dispositivo.

Si el dispositivo ya está vinculado a otra cuenta, el sistema debe mostrar un mensaje indicando que no se puede vincular.

Requerimientos funcionales:

Ingreso del número de serie:

El sistema debe permitir al usuario ingresar el número de serie del dispositivo en un campo dedicado.

El campo de entrada debe validar que el número de serie tenga el formato correcto (código de 12 dígitos alfanumérico sin espacios ni caracteres especiales).

Validación del número de serie:

El sistema debe verificar si el número de serie ingresado es válido y corresponde a un dispositivo registrado en la nube.

Vinculación del dispositivo:

Si el número de serie es válido, el sistema debe enviar los datos necesarios a la nube para realizar la vinculación del dispositivo con la cuenta del usuario.

El sistema debe confirmar que la vinculación se haya realizado con éxito mostrando un mensaje al usuario.

Manejo de dispositivos ya vinculados:

Si el dispositivo ya está vinculado a otra cuenta, el sistema debe mostrar un mensaje de error indicando que ese dispositivo no se encuentra disponible para vincular.

Requerimientos no funcionales:

Validación del formato del número de serie:

El sistema debe realizar la validación del formato del número de serie (12 dígitos alfanuméricos) localmente para evitar solicitudes innecesarias al servidor.

Tiempo de respuesta:

El tiempo de validación y respuesta del sistema, incluyendo la conexión con la nube para verificar la disponibilidad del dispositivo, debe ser rápido en condiciones normales de red.

Mensajes de usuario:

Los mensajes de éxito o error deben ser claros y accesibles, utilizando un lenguaje comprensible para el usuario final, y deben incluir posibles acciones de corrección si aplica.

Seguridad de los datos:

Los datos del número de serie y la información de vinculación deben enviarse a la nube utilizando protocolos seguros como HTTPS.

Compatibilidad multiplataforma:

El sistema debe garantizar que la funcionalidad sea accesible y operativa en dispositivos móviles con sistemas operativos mayores a IOS16 y superiores a Android 11.

Escalabilidad:

La arquitectura del sistema debe soportar un incremento en la cantidad de solicitudes de validación y vinculación sin degradar el rendimiento.

Disponibilidad del servicio:

El servicio en la nube para validar y vincular dispositivos debe estar disponible al menos el 95% del tiempo, con un plan de contingencia para notificar al usuario en caso de mantenimiento o caída del servicio.

Diseño intuitivo:

El campo de ingreso del número de serie debe estar claramente identificado y ser fácil de localizar en la interfaz de usuario, además debe resaltarse cuando el usuario lo esté utilizando.

#### HU- 3: Regresar a la pantalla anterior

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de opciones) desde la pantalla de agregar dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Epic: Configuración y edición de datos personales

#### HU- 1: Visualizar y editar información de la cuenta

Como usuario con una cuenta, quiero poder observar y editar mi información personal de la aplicación (nombre, email, país, dirección, teléfono, idioma, contraseña) para tener mi información actualizada.

Criterios de aceptación:

Visualización de datos personales:

El usuario puede ver su información personal en el apartado "Datos".

El campo de email debe estar bloqueado y ser únicamente visible.

El usuario puede editar todos los campos del apartado "Datos", excepto el email

Cambio de contraseña:

El apartado "Cambiar contraseña" debe incluir:

Campo para "Contraseña actual" (obligatorio).

Campo para "Nueva contraseña" (obligatorio, debe cumplir criterios de seguridad).

Campo para "Repetir nueva contraseña" (obligatorio, debe coincidir con la nueva contraseña).

Botones funcionales:

El botón "Actualizar" debe guardar los cambios realizados en los apartados "Datos" y "Cambiar contraseña" si cumplen las validaciones.

El botón superior debe redirigir a la pantalla "Opciones".

Validaciones:

Todos los campos editables deben validar entradas antes de guardar.

Mostrar mensajes de error en caso de entradas inválidas o contraseñas no coincidentes.

Requerimientos funcionales:

Visualización de información personal:

El sistema debe mostrar la información personal del usuario en el apartado "Datos".

El campo de email debe estar bloqueado y ser únicamente visible.

Edición de datos personales:

El sistema debe permitir editar todos los campos del apartado "Datos" (nombre, país, dirección, teléfono, idioma), excepto el email.

Cambio de contraseña:

El apartado "Cambiar contraseña" debe incluir: 

Un campo obligatorio para la "Contraseña actual".

Un campo obligatorio para la "Nueva contraseña", que debe cumplir los criterios de seguridad de la aplicación.

Un campo obligatorio para "Repetir nueva contraseña", que debe coincidir con la nueva contraseña ingresada.

Botón "Actualizar":

El sistema debe permitir guardar los cambios realizados en los apartados "Datos" y "Cambiar contraseña" al presionar el botón "Actualizar", siempre que cumplan con las validaciones correspondientes.

Validaciones de entrada:

El sistema debe validar las entradas en todos los campos editables, mostrando mensajes de error en caso de entradas inválidas.

El sistema debe mostrar un mensaje de error si las contraseñas ingresadas en "Nueva contraseña" y "Repetir nueva contraseña" no coinciden.

Requerimientos no funcionales:

Tiempo de respuesta:

Los datos editados deben actualizarse rapidamente tras presionar el botón "Actualizar".

Seguridad:

Las contraseñas deben almacenarse de forma segura utilizando algoritmos de cifrado avanzados.

Las solicitudes de cambio de datos deben realizarse a través de conexiones seguras (HTTPS).

Interfaz de usuario:

La interfaz debe ser intuitiva, con campos claramente etiquetados y mensajes de error descriptivos.

Auditoría y registro:

El sistema debe registrar los cambios realizados en los datos personales para fines de auditoría y soporte técnico.

Consistencia de diseño:

Los elementos de la pantalla deben mantener una estética uniforme con el resto de la aplicación.

#### HU-2: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de opciones) desde la pantalla de configuración.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Gestión de grupos

#### HU-1: Gestionar grupos existentes

Como usuario, quiero gestionar los grupos (ver, crear, renombrar y eliminar), para organizar mis dispositivos de manera eficiente.

Criterios de Aceptación:

El usuario puede ver la lista de grupos disponibles en la sección "Grupos".

El usuario puede crear un nuevo grupo, asegurando que el nombre no esté vacío ni duplicado.

El usuario puede renombrar un grupo existente, con las mismas validaciones de nombre.

Existe un grupo llamado “TODOS” que se crea por defecto y este contiene a todos los dispositivos disponibles.

El usuario puede eliminar cualquier grupo excepto “TODOS”.

El grupo “TODOS” siempre está visible y no puede eliminarse ni renombrarse.

Requerimientos funcionales:

Visualización de grupos:

El sistema debe mostrar la lista de grupos disponibles en la sección "Grupos".

El grupo "TODOS" debe estar siempre visible en la lista.

Creación de grupos:

El sistema debe permitir al usuario crear un nuevo grupo.

El nombre del grupo no debe estar vacío ni duplicarse con otro grupo existente.

Renombrar grupos:

El sistema debe permitir al usuario renombrar un grupo existente.

El nuevo nombre debe cumplir con las mismas validaciones de no estar vacío ni duplicarse con otro grupo.

Eliminar grupos:

El sistema debe permitir al usuario eliminar cualquier grupo, excepto el grupo "TODOS".

Restricciones del grupo "TODOS":

El grupo "TODOS" no puede ser eliminado ni renombrado.

Debe contener automáticamente todos los dispositivos disponibles, incluyendo aquellos que pertenezcan o no a otros grupos.

Requerimientos no funcionales:

Tiempo de respuesta:

La creación, eliminación, o renombramiento de un grupo debe reflejarse en la lista de grupos rapidamente.

Interfaz de usuario:

La interfaz debe ser intuitiva, con opciones claramente identificadas para ver, crear, renombrar y eliminar grupos.

Debe incluir mensajes de confirmación al eliminar grupos y de error si el nombre ingresado no cumple con las validaciones.

Consistencia de diseño:

El diseño de la sección "Grupos" debe ser consistente con el resto de la aplicación, respetando colores, tipografías, y estilo general.

Estabilidad:

El grupo "TODOS" debe estar protegido contra errores del sistema que puedan eliminarlo o modificarlo indebidamente.

#### HU-2: Administrar dispositivos agrupados

Como usuario, quiero administrar los dispositivos dentro de un grupo (ver, eliminar y agregar), para mantenerlos clasificados según mis necesidades.

Criterios de Aceptación:

Al seleccionar un grupo, se muestran los dispositivos que pertenecen a ese grupo en la sección “Dispositivos en Grupo X”.

El usuario puede eliminar un dispositivo del grupo seleccionado, este se moverá automáticamente al grupo “TODOS”.

El usuario puede agregar un dispositivo disponible al grupo seleccionado mediante un dropdown de selcción y un botón de agregar.

Requerimientos funcionales:

Visualización de dispositivos en grupo:

Al seleccionar un grupo, el sistema debe mostrar en la sección "Dispositivos en Grupo X" la lista de dispositivos pertenecientes a dicho grupo.

Eliminación de dispositivos de un grupo:

El sistema debe permitir al usuario eliminar un dispositivo del grupo seleccionado.

Agregar dispositivos a un grupo:

El sistema debe permitir al usuario agregar un dispositivo disponible al grupo seleccionado.

La interfaz debe incluir un dropdown que liste los dispositivos disponibles y un botón de agregar para confirmar la acción.

Requerimientos no funcionales:

Tiempo de respuesta:

Las acciones de visualizar, agregar o eliminar dispositivos deben reflejarse en la interfaz lo más rápido posible.

Seguridad:

Solo los dispositivos no agrupados deben aparecer como opciones en el dropdown para evitar duplicados.

Los datos de la lista de dispositivos deben estar protegidos contra accesos no autorizados.

Interfaz de usuario:

La lista "Dispositivos en Grupo X" debe ser clara y fácil de entender, con una presentación ordenada de los dispositivos.

La “X” debe mostrar el nombre del grupo.

El dropdown debe permitir búsquedas rápidas para facilitar la selección del dispositivo en listas extensas.

Consistencia de diseño:

La sección "Dispositivos en Grupo X" debe mantener el mismo estilo visual que el resto de la aplicación, respetando colores, tipografías y elementos de diseño.

Estabilidad:

El sistema debe asegurar que no se pierdan dispositivos durante las transferencias entre grupos, especialmente al mover dispositivos al grupo "TODOS".

Escalabilidad:

La funcionalidad debe manejar de manera eficiente una gran cantidad de dispositivos y grupos sin afectar el rendimiento de la aplicación.

.

#### HU-3: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de opciones) desde la pantalla de grupos.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Diagramas de Flujo - Opciones y configuración

Flujo 1: HU-1

Flujo 2: HU-2

Flujo 3: HU-3

### Diagramas de Flujo - Gestión de usuarios

Flujo 4: HU-1 y HU-2

Flujo 5: HU-3

Flujo 6: HU-4

### Diagramas de Flujo - Vincular usuario virtual

Flujo 7: HU-1

### Diagramas de Flujo - Agregar dispositivo

Flujo 8: HU-1

Flujo 9: HU-2

Flujo 10: HU-3

### Diagramas de Flujo - Configuración y edición de datos personales

Flujo 11: HU-1

### Diagramas de Flujo - Gestión de grupos

Flujo 12: HU-1

Flujo 13: HU-2

# Gestión de dispositivos

## Generalidades

Este documento incluye ciertas funcionalidades comunes (como regresar a la pantalla anterior y cuadro de información del dispositivo) que están descritas en el “Documento de Generalidades”. Las pantallas que se contemplan en este documento respetan esas reglas. La única excepción es la pantalla de información del dispositivo la cual no cuenta con el cuadro de información del dispositivo, por ende, solo cuenta con la opción de regresar a la pantalla anterior.

Las pantallas que cuenten con campos para ingresar información siguen las reglas definidas en el Documento de Generalidades: Identificación – Resaltado de Campos de Ingreso de Información.

## Gestión de dispositivos

### Epic: Edición de Dispositivos

#### HU- 1: Visualizar información del dispositivo

Como usuario, quiero visualizar información del dispositivo como modelo, número de serie, estado y detalle para confirmar su identidad.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Información – Cuadro de Información del Dispositivo.

#### HU- 2: Gestión del Nombre/Apodo y Desvinculación del Dispositivo

Como usuario, quiero editar el nombre/apodo del dispositivo o desvincularlo de mi cuenta, para personalizarlo o permitir que sea vinculado a otra cuenta.

Criterios de aceptación:

El usuario puede ver y editar el nombre/apodo del dispositivo.

Al desvincular el dispositivo, este queda disponible para ser vinculado a otra cuenta.

Al intentar desvincular, el sistema solicita confirmación del usuario.

Requerimientos funcionales:

Visualización y edición del nombre/apodo del dispositivo:

El sistema debe permitir al usuario visualizar el nombre/apodo actual del dispositivo.

El sistema debe permitir al usuario editar y guardar un nuevo nombre/apodo para el dispositivo.

Desvinculación del dispositivo:

El sistema debe permitir al usuario desvincular un dispositivo de su cuenta.

Al desvincular el dispositivo, este debe quedar disponible en la plataforma para ser vinculado a otra cuenta en caso de que se haya desvinculado de una cuenta de propietario.

Al desvincular el dispositivo desde una cuenta de usuario invitado, este simplemente pierde el acceso al dispositivo.

Confirmación de desvinculación:

Antes de completar la desvinculación, el sistema debe solicitar confirmación al usuario mediante un mensaje de advertencia con opciones claras de "Aceptar" y "Cancelar".

Requerimientos no funcionales:

Tiempo de respuesta:

Las acciones de editar el nombre/apodo o desvincular el dispositivo deben reflejarse en el menor tiempo posible.

Seguridad:

La acción de desvinculación debe estar protegida por autenticación activa (por ejemplo, ingresar la contraseña de cuenta para confirmar).

Interfaz de usuario:

El campo para editar el nombre/apodo debe ser intuitivo y mostrar validaciones en tiempo real (como longitud máxima y caracteres permitidos).

El mensaje de confirmación de desvinculación debe ser claro, indicando las implicaciones de la acción (por ejemplo, ya no podrá acceder al dispositivo de ninguna manera).

Consistencia de diseño:

Las pantallas y mensajes relacionados con la gestión del dispositivo deben mantener coherencia con el estilo de la aplicación, incluyendo colores, tipografía y elementos visuales.

#### HU- 3: Personalización de la Foto del Dispositivo

Como usuario, quiero cargar una foto desde mi galería para personalizar el dispositivo.

Criterios de aceptación:

El usuario puede seleccionar y cargar una imagen desde la galería.

La imagen seleccionada se aplica al dispositivo.

Requerimientos funcionales:

Selección de imagen desde la galería:

El sistema debe permitir al usuario abrir la galería de su dispositivo para seleccionar una imagen.

Carga de imagen al dispositivo:

El sistema debe cargar la imagen seleccionada y asociarla al dispositivo correspondiente de manera local.

Aplicación de la imagen:

Una vez cargada, la imagen seleccionada debe mostrarse como la foto personalizada del dispositivo en esa cuenta.

Requerimientos no funcionales:

Tiempo de carga:

El sistema debe procesar y aplicar la imagen de manera rápida con una conexión estándar.

Seguridad:

El sistema debe verificar que las imágenes cargadas no contengan datos maliciosos o inseguras antes de almacenarlas.

Interfaz de usuario:

La interfaz para seleccionar la imagen debe ser intuitiva y consistente con el diseño de la aplicación.

Si ocurre un error durante la carga, el sistema debe mostrar un mensaje claro indicando el problema y sugiriendo una acción correctiva.

Persistencia:

La foto personalizada debe guardarse de manera local en la aplicación.

Accesibilidad:

Los usuarios deben poder navegar y seleccionar una imagen mediante asistentes de accesibilidad en el dispositivo.

Mensajes claros:

El sistema debe notificar al usuario sobre el éxito o error de la carga de la imagen con mensajes específicos y amigables.

#### HU- 4: Gestión del Grupo al que Pertenece el Dispositivo

Como usuario, quiero acceder a la pantalla de grupos para asignar el dispositivo a un grupo.

Criterios de aceptación:

El usuario puede seleccionar la opción para redirigirse al apartado de grupos.

Requerimientos funcionales:

Acceso a la pantalla de grupos:

El sistema debe incluir una opción visible y funcional que permita al usuario acceder al apartado de grupos desde la pantalla del dispositivo.

Redirección al apartado de grupos:

Al seleccionar la opción correspondiente, el sistema debe redirigir al usuario a la pantalla Grupos.

Requerimientos no funcionales:

Tiempo de redirección:

El sistema debe realizar la redirección en el menor tiempo posible bajo condiciones estándar de red y rendimiento.

Interfaz de usuario:

La opción para acceder al apartado de grupos debe estar claramente identificada y alineada con el diseño general de la aplicación.

Compatibilidad:

La funcionalidad debe ser operativa en dispositivos móviles con sistemas operativos de Android 11 en adelante y iOS 16 en adelante.

Mensajes claros:

En caso de error al intentar acceder al apartado de grupos, el sistema debe mostrar un mensaje explicativo y ofrecer la opción de reintentar.

#### HU- 5: Visualización de Usuarios con Acceso al Dispositivo

Como usuario administrador, quiero poder ver cuántos usuarios tienen acceso al dispositivo, para conocer la cantidad de usuario a los que les he permitido el acceso.

Criterios de aceptación:

El sistema muestra cuantos usuarios tienen acceso al dispositivo.

Requerimientos funcionales:

Visualización de usuarios con acceso:

El sistema debe mostrar en la interfaz el número total de usuarios que tienen acceso al dispositivo.

Actualización:

Si se agrega o elimina un usuario con acceso, el sistema debe actualizar el contador automáticamente para reflejar el cambio.

Requerimientos no funcionales:

Rendimiento:

El sistema debe cargar y mostrar el número de usuarios con acceso al cargar la pantalla.

Interfaz de usuario:

La información sobre el número de usuarios con acceso debe ser claramente visible y presentada de manera intuitiva dentro de la pantalla del dispositivo.

Compatibilidad:

La funcionalidad debe operar correctamente en dispositivos con sistemas Android 11 o superior y iOS16 o superior y adaptarse a pantallas de diferentes tamaños.

Seguridad:

La información mostrada sobre usuarios con acceso debe ser visible únicamente para usuarios con permisos de administrador.

#### HU- 6: Asignación del Dispositivo como Favorito

Como usuario, quiero poder asignar el dispositivo como favorito, para diferenciarlo de mis dispositivos secundarios.

Criterios de aceptación:

El sistema muestra un checkbox para marcar al dispositivo como favorito.

Al ser asignado como favorito, el dispositivo nuevo le cae encima al anterior haciéndolo el nuevo favorito.

Si el dispositivo ya era favorito y se desmarca, el siguiente dispositivo en la lista de dispositivos queda como favorito ya que solo puede haber un favorito.

En caso de que solo haya un dispositivo no se puede desmarcar como favorito.

Requerimientos funcionales:

Checkbox para marcar como favorito:

El sistema debe mostrar un checkbox en la interfaz que permita al usuario marcar o desmarcar el dispositivo como favorito.

Actualización del estado de favorito:

Al marcar un dispositivo como favorito, el sistema debe actualizar su estado y desmarcar cualquier dispositivo que estuviera previamente como favorito.

Reasignación automática del favorito:

Si un dispositivo marcado como favorito es desmarcado, el sistema debe asignar automáticamente el estado de favorito al siguiente dispositivo en la lista.

Restricción de desmarcado:

Si solo hay un dispositivo en la lista, el sistema debe bloquear la posibilidad de desmarcarlo como favorito.

Requerimientos no funcionales:

Rendimiento:

La actualización del estado de favorito debe reflejarse en la interfaz del usuario rapidamente tras realizar la acción.

Interfaz de usuario:

El checkbox debe ser claramente visible y su estado (marcado o desmarcado) debe ser fácilmente identificable para el usuario.

Persistencia:

El estado de favorito debe ser almacenado en el sistema y mantenerse incluso después de cerrar y reabrir la aplicación.

Compatibilidad:

La funcionalidad debe ser operativa en dispositivos con sistemas Android 11 o posterior y iOS16 o posterior, y debe adaptarse correctamente a diferentes tamaños de pantalla.

Integridad de datos:

El sistema debe garantizar que solo un dispositivo puede estar marcado como favorito en cualquier momento.

#### HU- 7: Redirección a otras Pantallas

Como usuario administrador, quiero acceder a pantallas relacionadas (Usuarios con Acceso, Información del Dispositivo, Contacto Técnico) desde botones específicos para gestionar mejor mi dispositivo.

Criterios de aceptación:

Al seleccionar el botón "Ver Usuarios con Acceso", el sistema redirige a la pantalla Usuarios con Accesos.

Al seleccionar el botón "Información de Dispositivo", el sistema redirige a la pantalla Información del Dispositivo.

Al seleccionar la opción "Técnico Asignado", el sistema redirige a la pantalla "Contacto Técnico".

Requerimientos funcionales:

Redirección a la pantalla "Usuarios con Acceso":

El sistema debe redirigir al usuario a la pantalla "Usuarios con Acceso" al seleccionar el botón "Ver Usuarios con Acceso".

Redirección a la pantalla "Información del Dispositivo":

Al seleccionar el botón "Información de Dispositivo", el sistema debe redirigir al usuario a la pantalla correspondiente para visualizar la información detallada del dispositivo.

Redirección a la pantalla "Contacto Técnico":

El sistema debe redirigir al usuario a la pantalla "Contacto Técnico" al seleccionar la opción "Técnico Asignado".

Requerimientos no funcionales:

Rendimiento:

La redirección a las pantallas relacionadas debe completarse rapidamente tras la selección del botón correspondiente.

Interfaz de usuario:

Los botones deben ser claramente visibles, etiquetados correctamente, y colocados en una posición intuitiva para facilitar su uso.

Seguridad:

Solo usuarios autorizados con permisos de administrador deben poder acceder a las pantallas relacionadas según sus permisos.

Navegabilidad:

Cada pantalla a la que se redirija debe incluir una opción para regresar a la pantalla anterior.

#### HU- 8: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de opciones) desde la pantalla de editar dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Contacto Técnico

#### HU- 1: Visualizar información del dispositivo

Como usuario, quiero visualizar información del dispositivo como modelo, número de serie, estado y detalle para confirmar su identidad.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Información – Cuadro de Información del Dispositivo.

#### HU- 2: Gestión de Datos del Técnico

Como usuario, quiero visualizar, agregar y editar los datos del técnico (nombre, correo, país, teléfono y notas), para mantener la información actualizada.

Criterios de aceptación:

El usuario puede ver los datos actuales del técnico si ya están registrados.

Los campos permiten agregar o modificar información según sea necesario.

Los datos deben validarse (por ejemplo, formato de correo correcto, el país debe seleccionarse, si lo campos son numérico no deben aceptar letras y viceversa).

Requerimientos funcionales:

Visualización de datos del técnico:

El sistema debe permitir al usuario visualizar los datos actuales del técnico registrados en los campos correspondientes si lo hay.

Edición de datos del técnico:

Los campos deben permitir modificar los datos actuales del técnico registrados en nombre, correo, país, teléfono y notas.

Ingreso de datos del técnico:

El sistema debe permitir agregar los datos del técnico en los campos correspondientes si no hay información registrada previamente.

Validación de datos:

El sistema debe validar los datos ingresados en tiempo real: 

El formato del correo debe ser correcto (contener “@” y “.com o .org”).

El campo "País" debe seleccionarse de una lista predefinida.

Los campos numéricos como "Teléfono" no deben aceptar letras ni caracteres especiales.

Los campos alfabéticos como "Nombre" no deben aceptar números ni caracteres especiales.

Requerimientos no funcionales:

Rendimiento:

La validación de los datos debe completarse rapidamente después de la entrada del usuario.

Interfaz de usuario:

Los campos deben estar claramente etiquetados y organizados de manera lógica para facilitar el ingreso y edición de datos.

Cuando un campo se utilice este debe resaltarse de los demás.

Compatibilidad:

La funcionalidad debe ser compatible con dispositivos con sistema operativo Android 11 o superior iOS16 o superior, y adaptarse correctamente a pantallas de diferentes tamaños.

Seguridad:

Los datos del técnico deben protegerse mediante el uso de canales de comunicación cifrados y permisos de acceso adecuados.

Navegabilidad:

La pantalla debe incluir opciones claras para guardar los cambios realizados y regresar al menú o pantalla principal.

#### HU- 3: Eliminación y Guardado de Datos del Técnico

Como usuario, quiero poder guardar los datos del técnico o eliminarlo si es necesario, para gestionar la asignación del técnico al dispositivo.

Criterios de aceptación:

Al presionar el botón "Guardar," los datos ingresados o editados se guardan correctamente.

Al presionar "Eliminar Técnico," se elimina al técnico asignado (si lo hay) y el sistema solicita confirmación antes de proceder.

Requerimientos funcionales:

Guardar datos del técnico:

El sistema debe permitir guardar los datos ingresados o editados del técnico al presionar el botón "Guardar".

Los datos deben almacenarse correctamente en el sistema y reflejarse en la interfaz.

Eliminar técnico asignado:

El sistema debe permitir eliminar al técnico actualmente asignado al dispositivo al presionar el botón "Eliminar Técnico".

Antes de proceder con la eliminación, el sistema debe mostrar un mensaje de confirmación al usuario.

Si se confirma la eliminación, el técnico debe ser eliminado de la base de datos y la información correspondiente debe ser actualizada en la interfaz.

Requerimientos no funcionales:

Rendimiento:

El sistema debe completar el proceso de guardar o eliminar datos rapidamente tras la interacción del usuario.

Interfaz de usuario:

El botón "Guardar" y "Eliminar Técnico" deben estar claramente identificados y accesibles en la pantalla.

El mensaje de confirmación para eliminar al técnico debe ser claro, legible y contener opciones de "Aceptar" y "Cancelar".

Seguridad:

Los cambios en los datos del técnico deben realizarse mediante canales seguros y encriptados.

El sistema debe requerir permisos adecuados para permitir guardar o eliminar técnicos.

Compatibilidad:

La funcionalidad debe estar disponible y funcionar correctamente en dispositivos con sistemas operativos Android 11 o superior y iOS16 o superior.

Integridad de datos:

El sistema debe asegurarse de que los datos del técnico no se corrompan durante el proceso de guardado o eliminación.

El sistema debe impedir acciones simultáneas conflictivas, como intentar guardar y eliminar al técnico al mismo tiempo.

#### HU- 4: Contactar mantenimiento

Como usuario, quiero un botón para contactar al equipo de mantenimiento por WhatsApp en caso de averías o problemas.

Criterios de aceptación:

El botón debe abrir WhatsApp con un mensaje predefinido para contactar al equipo de mantenimiento.

El mensaje debe incluir detalles clave (como el nombre del dispositivo o estado actual).

Requerimientos funcionales:

Botón para contactar mantenimiento:

El sistema debe incluir un botón visible y accesible en la pantalla que permita al usuario contactar al equipo de mantenimiento.

Abrir WhatsApp:

Al presionar el botón, el sistema debe abrir la aplicación WhatsApp en el dispositivo del usuario.

El sistema debe cargar un mensaje predefinido en el chat.

Detalles en el mensaje:

El mensaje predefinido debe incluir automáticamente: 

Nombre del dispositivo.

Estado actual del dispositivo (defectuoso, mantenimiento).

El mensaje debe ser claro y estar listo para ser enviado por el usuario

Requerimientos no funcionales:

Rendimiento:

El sistema debe abrir WhatsApp y cargar el mensaje predefinido tras presionar el botón.

Compatibilidad:

La funcionalidad debe ser compatible con las versiones actuales y más recientes de WhatsApp.

Debe funcionar correctamente en dispositivos con Android 11 o superior y iOS16 o superior.

Interfaz de usuario:

El botón debe ser claramente identificado con un ícono y texto relacionado con WhatsApp y mantenimiento.

Estabilidad:

Si WhatsApp no está instalado en el dispositivo, el sistema debe mostrar un mensaje de error claro indicando la necesidad de instalar la aplicación.

#### HU- 5: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de editar dispositivos) desde la pantalla de contacto técnico.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Epic: Información del Dispositivo

#### HU- 1: Visualización de la Información General del Dispositivo

Como usuario, quiero visualizar la información detallada del dispositivo (número de serie, nombre, versión actual, ciclos totales, fecha de activación y estado), para conocer su estado actual.

Criterios de aceptación:

El número de serie, nombre, versión actual, ciclos totales, fecha de activación y estado del dispositivo son visibles en la pantalla.

El estado muestra si el dispositivo está conectado y la señal en porcentaje.

Los datos son actualizados en tiempo real si cambian.

Requerimientos funcionales:

Visualización de información del dispositivo:

El sistema debe mostrar la siguiente información del dispositivo al usuario: 

Modelo del dispositivo.

Número de serie.

Estado del dispositivo (En línea, inactivo).

Detalles (nombre con el cual se registró el dispositivo).

Actualización de información:

Si el usuario cambia el dispositivo escaneado o ingresa un nuevo número de serie, la pantalla debe actualizar automáticamente la información correspondiente al nuevo dispositivo luego de haberlo vinculado.

Acceso condicional:

La pantalla debe estar disponible con la información solo después de que el usuario haya escaneado un dispositivo o ingresado manualmente un número de serie válido.

Interacción con la nube:

El sistema debe consultar la información del dispositivo en tiempo real desde la base de datos en la nube para asegurar que los datos mostrados sean precisos y actualizados.

Requerimientos no funcionales:

Tiempo de respuesta:

La información del dispositivo debe cargarse y mostrarse al usuario en no más de 10 segundos después de haber agregado el dispositivo.

Disponibilidad del servicio:

El servicio en la nube que proporciona la información del dispositivo debe tener una disponibilidad de al menos el 95% del tiempo.

Diseño intuitivo:

La pantalla debe tener un diseño claro y accesible, con los datos del dispositivo organizados de forma legible y fácil de entender para el usuario en la parte superior de la pantalla.

Compatibilidad multiplataforma:

El sistema debe garantizar que la funcionalidad sea accesible y operativa en dispositivos móviles con sistemas operativos mayores a IOS16 y superiores a Android 11.

#### HU- 2: Acceso a la Pantalla "Parámetros del Dispositivo"

Como usuario, quiero acceder a la pantalla "Parámetros del Dispositivo" desde la pantalla "Información del Dispositivo” mediante un botón para gestionar configuraciones específicas del dispositivo.

Criterios de aceptación:

El botón ubicado en el título de la sección "Dispositivo" redirige correctamente a la pantalla "Parámetros del Dispositivo."

Requerimientos funcionales:

Botón de acceso a "Parámetros del Dispositivo":

El sistema debe incluir un botón visible en el título de la sección "Dispositivo" dentro de la pantalla "Información del Dispositivo."

Redirección a la pantalla de "Parámetros del Dispositivo":

Al presionar el botón, el sistema debe redirigir al usuario a la pantalla "Parámetros del Dispositivo."

Confirmación de acceso:

Una vez en la pantalla "Parámetros del Dispositivo," el usuario debe poder visualizar y gestionar las configuraciones específicas del dispositivo.

Requerimientos no funcionales:

Rendimiento:

La redirección debe realizarse rapidamente desde que el usuario presiona el botón.

Interfaz de usuario:

El botón debe estar claramente identificado, con texto o un ícono intuitivo que indique la funcionalidad de acceder a "Parámetros del Dispositivo."

Compatibilidad:

La funcionalidad debe ser compatible con diferentes tamaños de pantalla y dispositivos móviles y sistemas operativos Android 11 o superior y iOS16 o superior.

Estabilidad:

El sistema debe manejar adecuadamente cualquier error que impida la redirección, mostrando un mensaje claro al usuario en caso de problemas técnicos.

#### HU- 3: Actualizar Dispositivo

Como usuario administrador, quiero un botón para actualizar el dispositivo mediante la descarga de un archivo binario encriptado, para mantener el dispositivo actualizado con la última versión.

Criterios de aceptación:

Al presionar el botón "Actualizar Dispositivo":

El sistema inicia la descarga de un archivo binario encriptado desde el servidor.

Se muestra un mensaje indicando el inicio de la descarga y el progreso.

El archivo descargado se valida para confirmar su integridad y autenticidad.

Si la validación del archivo es exitosa:

La actualización se realiza vía OTA

Si ocurre un error durante la descarga, validación o inyección:

El sistema muestra un mensaje de error indicando la causa y sugiere posibles acciones correctivas.

La función solo está disponible si el dispositivo está conectado y tiene señal suficiente.

Requerimientos funcionales:

Botón para actualizar el dispositivo:

El sistema debe incluir un botón visible y funcional llamado "Actualizar Dispositivo."

Descarga del archivo binario encriptado:

Al presionar el botón, el sistema debe iniciar la descarga del archivo binario encriptado desde el servidor.

El sistema debe mostrar un mensaje indicando el inicio de la descarga y el progreso en tiempo real.

Validación del archivo descargado:

El sistema debe validar el archivo para garantizar su integridad y autenticidad antes de continuar con la actualización.

El sistema debe verificar que el archivo es el correcto para el tipo de dispositivo.

Realización de la actualización vía OTA:

Si la validación es exitosa, el sistema debe realizar la actualización del dispositivo vía OTA, manteniendo la conexión estable durante el proceso.

Manejo de errores:

En caso de errores durante la descarga, validación o inyección, el sistema debe mostrar un mensaje claro indicando la causa del error y sugerir acciones correctivas (por ejemplo, verificar la conexión o intentar nuevamente).

Disponibilidad de la función:

El botón "Actualizar Dispositivo" solo debe estar habilitado si el dispositivo está conectado y tiene señal suficiente para realizar la operación.

Requerimientos no funcionales:

Rendimiento:

La descarga del archivo debe completarse en un tiempo razonable dependiendo del tamaño del archivo y la velocidad de la red.

Seguridad:

El archivo binario debe estar encriptado para evitar manipulaciones.

Interfaz de usuario:

El progreso de la descarga debe mostrarse de manera clara, utilizando una barra de progreso o porcentaje.

Los mensajes de éxito o error deben ser comprensibles y proporcionar información útil al usuario.

Compatibilidad:

La funcionalidad debe ser compatible con diferentes dispositivos y sistemas operativos como Android 11 o superior y iOS16 o superior.

Confiabilidad:

El sistema debe manejar interrupciones de red durante la descarga, permitiendo reintentar sin reiniciar todo el proceso.

#### HU- 4: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de editar dispositivos) desde la pantalla de información del dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Epic: Parámetros del Dispositivo

#### HU- 1: Visualizar información del dispositivo

Como usuario, quiero visualizar información del dispositivo como modelo, número de serie, estado y detalle para confirmar su identidad.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Información – Cuadro de Información del Dispositivo.

#### HU- 2: Configurar de Parámetros del Dispositivo

Como usuario administrador, quiero configurar y actualizar los parámetros del dispositivo y las notificaciones para personalizar su comportamiento y asegurar que los cambios se apliquen correctamente.

Criterios de aceptación:

Todas las opciones de configuración son visibles y editables solo para usuarios con permisos de administrador.

Al presionar el botón "Actualizar Parámetros," los cambios configurados son validados y guardados.

Si ocurre un error el sistema muestra un mensaje y no aplica los cambios.

Requerimientos funcionales:

Visibilidad y acceso:

Solo los usuarios con permisos de administrador pueden visualizar y editar los parámetros del dispositivo.

Opciones de configuración:

El sistema debe mostrar todas las opciones disponibles para configurar los parámetros del dispositivo y las notificaciones.

Actualización de parámetros:

Al presionar el botón "Actualizar Parámetros," el sistema debe:

Validar los valores configurados.

Guardar los cambios correctamente si todas las validaciones son exitosas.

Manejo de errores:

Si ocurre un error durante la validación o el guardado, el sistema debe mostrar un mensaje claro indicando la causa del error.

Los cambios no deben aplicarse si hay errores en la configuración.

Requerimientos no funcionales:

Seguridad:

Restringir el acceso a la funcionalidad únicamente a usuarios con permisos de administrador.

Implementar medidas de autenticación para verificar los permisos antes de permitir cambios.

Interfaz de usuario:

Diseñar una interfaz clara y organizada que permita a los administradores identificar y modificar fácilmente los parámetros del dispositivo.

Proveer mensajes de error comprensibles en caso de fallas en la validación o en el guardado de los cambios.

Confiabilidad:

Asegurar que los cambios realizados sean aplicados correctamente y persistentemente una vez guardados.

Prevenir inconsistencias en los parámetros en caso de fallos en la red o el sistema durante el guardado.

Rendimiento:

Validar y guardar los parámetros de manera rápida, asegurando una experiencia fluida para el usuario.

#### HU- 3: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de información del dispositivo) desde la pantalla de parámetros del dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Diagramas de Flujo – Edición de Dispositivos

Flujo 1: HU-1 y HU-2

Flujo 2: HU-3

Flujo 3: HU-4

Flujo 4: HU-5

Flujo 5: HU-6

Flujo 6: HU-7

### Diagramas de Flujo – Contacto Técnico

Flujo 7: HU-1 y HU-2

Flujo 8: HU-3

Flujo 9: HU-4

### Diagramas de Flujo – Información del Dispositivo

Flujo 10: HU-1

Flujo 11: HU-2

Flujo 12: HU-3

### Diagramas de Flujo – Parámetros del Dispositivo

Flujo 13: HU-1

# Accesos, roles y permisos

## Generalidades

Este documento incluye ciertas funcionalidades comunes (como regresar a la pantalla anterior y cuadro de información del dispositivo) que están descritas en el “Documento de Generalidades”. Las pantallas que se contemplan en este documento respetan esas reglas.

## Accesos, Roles y Permisos

### Epic: Accesos de Usuarios a Dispositivos

#### HU- 1: Vincular / desvincular usuario a dispositivo

Como usuario con permisos de administrador de un dispositivo, quiero gestionar los accesos de usuarios vinculados al dispositivo para que puedan acceder al dispositivo desde sus cuentas propias.

Criterios de aceptación:

En la lista "Mis usuarios del dispositivo":

Se visualizan los usuarios con acceso al dispositivo.

El primer usuario de la lista está identificado como administrador y no puede ser eliminado.

Si se elimina un usuario (que no sea el administrador), este pasa a la lista "Usuarios disponibles."

En la lista "Usuarios disponibles":

Se visualizan los usuarios vinculados con la cuenta del usuario logueado, pero que no han sido asignados al dispositivo.

El usuario puede marcar uno o más usuarios para asignarlos al dispositivo.

Al presionar el botón "Vincular usuario a dispositivo":

Los usuarios seleccionados se mueven a la lista "Mis usuarios del dispositivo."

Ambas listas se actualizan automáticamente tras cualquier cambio

Requerimientos funcionales:

Gestión de usuarios con acceso:

En la lista "Mis usuarios del dispositivo":

Mostrar todos los usuarios con acceso al dispositivo.

Mostrar una opción en cada usuario para eliminarlo.

Mostrar una opción en cada usuario para ir a la pantalla de asignar roles.

Identificar claramente al primer usuario como administrador, asegurando que no pueda ser eliminado.

Permitir eliminar usuarios (excepto el administrador), moviéndolos automáticamente a la lista "Usuarios disponibles."

Gestión de usuarios disponibles:

En la lista "Usuarios disponibles":

Mostrar los usuarios asociados a la cuenta del usuario logueado pero que no tienen acceso al dispositivo.

 Permitir seleccionar uno o más usuarios de esta lista para vincularlos al dispositivo.

Proveer un botón "Vincular usuario a dispositivo" que:

Agregue los usuarios seleccionados a la lista "Mis usuarios del dispositivo." 

Actualice ambas listas automáticamente tras realizar el cambio.

Requerimientos no funcionales:

Seguridad:

Verificar que solo los usuarios con permisos de administrador puedan gestionar las listas y realizar cambios.

Restringir la eliminación del administrador del dispositivo de manera programática.

Interfaz de usuario:

Diseñar listas claras y organizadas para diferenciar "Mis usuarios del dispositivo" y "Usuarios disponibles."

Incluir controles de selección fáciles de usar para asignar usuarios desde la lista "Usuarios disponibles."

Mostrar mensajes de confirmación al realizar acciones como eliminar o asignar usuarios.

Mostrar botones de interacción con los usuarios de la lista.

Los usuarios con privilegios no pueden ver a los administradores.

Confiabilidad:

Asegurar que las listas se actualicen automáticamente y en tiempo real después de cualquier cambio.

Manejar correctamente errores de red o fallas en la sincronización para evitar inconsistencias.

Rendimiento:

Optimizar la actualización de listas para que los cambios se reflejen de manera inmediata, independientemente del tamaño de las listas.

#### HU- 2: Visualizar información del dispositivo

Como usuario, quiero visualizar información del dispositivo como modelo, número de serie, estado y detalle para confirmar su identidad.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Información – Cuadro de Información del Dispositivo.

#### HU- 3: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de editar dispositivo) desde la pantalla de usuarios con accesos.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior.

### Epic: Roles y Permisos

#### HU-1: Visualizar información del dispositivo

Como usuario, quiero visualizar información del dispositivo como modelo, número de serie, estado y detalle para confirmar su identidad.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Información – Cuadro de Información del Dispositivo

#### HU-2: Asignar / quitar roles y permisos al usuario seleccionado

Como usuario con permisos de administrador de un dispositivo, quiero gestionar los roles y los permisos de usuarios vinculados al dispositivo para que estos puedan realizar diferentes acciones sobre el dispositivo desde sus cuentas propias.

Criterios de Aceptación:

Visualización del usuario seleccionado:

El sistema muestra la etiqueta del usuario seleccionado en una ubicación visible.

El sistema muestra el correo electrónico del usuario seleccionado abajo de la etiqueta.

Visualización de roles y permisos:

El sistema presenta un cuadro con los diferentes roles y permisos existentes para asignar al usuario.

El cuadro de roles y permisos debe ser claro y permitir al administrador visualizar fácilmente las opciones disponibles.

Selección de roles y permisos:

El administrador puede seleccionar los roles y permisos que desea asignar al usuario, usando casillas de verificación (checkbox).

Asignación de roles y permisos:

Al presionar el botón "Asignar Roles", el sistema debe asignar los roles y permisos seleccionados al usuario seleccionado.

El sistema debe mostrar un mensaje de éxito si los roles y permisos se asignan correctamente.

Manejo de errores en la asignación:

Si ocurre un error durante la asignación de roles y permisos (por ejemplo, por problemas de conexión o comunicación), el sistema debe mostrar un mensaje de error indicando la causa del problema.

Requerimientos Funcionales:

Accesibilidad de datos del usuario:

El sistema debe recuperar y mostrar la etiqueta y correo electrónico del usuario seleccionado.

Gestión de roles y permisos:

El sistema debe proporcionar un cuadro con los roles y permisos existentes en el sistema.

El sistema debe permitir al administrador seleccionar múltiples roles y permisos para asignar al usuario.

Interacción del administrador:

El sistema debe permitir al administrador marcar los roles y permisos con los que quiere que cuente el usuario seleccionado. La interacción debe ser sencilla y accesible (usando checkboxes).

Asignación de roles y permisos:

El sistema debe tener un botón "Asignar Roles" que ejecute el proceso de asignación de los roles y permisos seleccionados al usuario.

Notificación de éxito o error:

El sistema debe notificar al administrador si los roles y permisos fueron asignados correctamente.

El sistema debe mostrar un mensaje claro y detallado si ocurre algún error en el proceso de asignación.

Requerimientos No Funcionales:

Seguridad:

Solo los usuarios con permisos de administrador deben poder acceder y realizar modificaciones sobre los roles y permisos de otros usuarios.

Interfaz de usuario:

La interfaz debe ser clara, fácil de usar y accesible para el administrador, mostrando los roles y permisos de forma comprensible.

Los cuadros de selección deben ser intuitivos para que el administrador pueda asignar roles y permisos de manera eficiente.

Rendimiento:

El proceso de asignación de roles y permisos debe ser rápido y eficiente.

El sistema debe manejar la asignación de roles sin causar retrasos perceptibles para el administrador.

Manejo de errores:

El sistema debe manejar errores de manera adecuada, mostrando mensajes claros si no se pueden asignar roles y permisos y sugiriendo posibles acciones correctivas.

#### HU- 3: Regresar a la pantalla anterior 

Como usuario, quiero poder regresar a la pantalla anterior (pantalla de usuarios con accesos) desde la pantalla de roles de usuario en dispositivo.

Criterios de aceptación:

Esta funcionalidad sigue las reglas definidas en el Documento de Generalidades: Navegación – Regresar a la Pantalla Anterior

### Diagramas de Flujo - Accesos de Usuarios a Dispositivos

Flujo 1: HU-1

### Diagramas de Flujo - Roles y Permisos

Flujo 2: HU-1
