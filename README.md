# Sistema de Gestión de vacaciones y permisos - Radiología e Imagen Santa Imelda

##  Descripción General
Este proyecto consiste en el desarrollo de una plataforma web centralizada diseñada específicamente para la clínica de **Radiología e Imagen Santa Imelda**.Su objetivo principal es resolver las ineficiencias del proceso actual de administración de vacaciones y permisos (basado en papeles y archivos de Excel locales), automatizando de manera segura el registro, validación y aprobación de permisos y vacaciones para optimizar la organización de turnos del personal y evitar retrasos operativos.

---

##  Mapa de Navegación del Prototipo
El flujo interactivo de la maqueta simula los casos de uso descritos en la toma de requerimientos. Puedes navegar las pantallas clave a través de los siguientes archivos en la carpeta `/prototipo`:

1. **Pantalla de Acceso (`/prototipo/login.html` o `login.jsp`)**: 
   * Formulario de ingreso que valida las credenciales de los usuarios.Dependiendo del rol del usuario, permite acceder a las distintas interfaces (la del administrador que aprueba o rechaza y la del trabajador que solicita el permiso o vacaciones)
   * los usuarios y contraseñas que estan dados de alta son estos: este es para el area administrativa "dra.hilda" contraseña:Admin1234 y este para el area del trabajador "jradiologol" contraseña:Emp1234
2. **Dashboard del Empleado (`/prototipo/dashboard_empleado.html`)**:
   * Panel principal dirigido a radiólogos, técnicos, enfermeros, medicos y personal de limpieza. Permite visualizar sus días de vacaciones disponibles y el estado de sus solicitudes.
3. **Formulario de Solicitud (`/prototipo/solicitud.html`)**:
   * Interfaz interactiva donde el colaborador registra y valida las fechas deseadas para su permiso o periodo vacacional antes de enviarlo al sistema.
4. **Dashboard de la Jefa de Clínica (`/prototipo/dashboard_jefa.html`)**:
   * Panel de control exclusivo para la **Dra.Hilda**.Permite revisar en un solo lugar el historial, aprobar o rechazar solicitudes pendientes y monitorear la organización interna.
5. **Lista de Colaboradores (`/prototipo/lista_empleados.html`)**:
   * Módulo administrativo para la gestión, registro y control de roles de la plantilla de personal (médicos, técnicos, recepción, limpieza, etc.).

---

## Cobertura de Requerimientos (Must-Have)
Cada requerimiento identificado en la entrevista ha sido mapeado e implementado visualmente en la maqueta interactiva:

| ID Requerimiento | Descripción del Requerimiento | Pantalla del Prototipo (Archivo) | Elemento Clave Evaluado |
| :--- | :--- | :--- | :--- |
| **RF-01** | **Gestión de roles y accesos:** Controlar niveles de acceso dependiendo del tipo de usuario (Jefa de clínica frente a colaboradores). | `login.jsp` / `login.html` | Campos de credenciales y redirección basada en privilegios[cite: 78, 80]. |
| **RF-02** | **Registro de colaboradores:** Mantener el control de datos e información básica del personal de la clínica. | `lista_empleados.jsp` | Tabla interactiva con la lista del personal administrativo, técnico y de apoyo[cite: 36, 39]. |
| **RF-03** | **Solicitud de permisos:** Permitir a los colaboradores capturar incidencias de forma digital. | `dashboard_empleado.jsp` | Botón y formulario para la captura de permisos con validación automática[cite: 65, 74]. |
| **RF-04** | **Control de vacaciones:** Seguimiento preciso de periodos vacacionales evitando registros duplicados o erróneos. | `dashboard_empleado.jsp` | Vista de días disponibles y registros históricos del colaborador[cite: 62]. |
| **RF-05** | **Aprobación de solicitudes:** Módulo centralizado para la autorización o rechazo inmediato de peticiones. | `dashboard_jefa.jsp` | Listado de peticiones pendientes con acciones rápidas de Aprobado/Rechazado[cite: 49, 76]. |
| **RF-06** | **Generación de reportes:** Visualizar la información consolidada en un solo lugar para evitar retrasos en la toma de decisiones. | `dashboard_jefa.jsp` | Sección de analíticas operativas y exportación de estados del personal[cite: 62, 77]. |

---

##  Estructura del Repositorio
El repositorio público está organizado de manera rigurosa siguiendo las carpetas solicitadas para el ciclo de desarrollo:

 **`./prototipo`**: Contiene la maqueta web interactiva y navegable (archivos HTML/CSS y componentes de vista `.jsp` adaptados para NetBeans).
 **`./documentacion`**: Archivos de especificación técnica, matriz de trazabilidad y requerimientos detallados basados en la entrevista clínica.
 **`./diagramas`**: Modelado integral de procesos de negocio y arquitectura de software:
  * **Diagrama AS-IS**: Modelado del proceso manual ineficiente basado en papel y Excel.
  * **Diagrama TO-BE**: Rediseño del proceso optimizado y automatizado mediante el nuevo sistema web.
  * **Modelo Entidad-Relación (ER)**: Estructura lógica de la base de datos (Entidades mapeadas: `Empleado`, `Usuario`, `SolicitudVacaciones`).
 **`./minutas`**: Registro detallado de la primera sesión de toma de requerimientos de 75 minutos realizada con la Dra.

---

## 👥 Equipo de Desarrollo — "Los Descoordinados"
* **Maxim Pamela Rosales Esteves** - Facilitador del proyecto, Diseño Arquitectónico y Desarrollo Java Backend[cite: 15].
* [cite_start]**Omar Jetzael Ortiz Montoya** - Analista de Requerimientos, Notas y Modelado de Procesos (AS-IS / TO-BE)[cite: 16].
