<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.santaimelda.model.Empleado"%>
<%@page import="com.santaimelda.model.Usuario"%>

<%
Usuario u = (Usuario) session.getAttribute("usuario");


if (u == null || !"jefa".equals(u.getRol())) {
    response.sendRedirect("LoginServlet");
    return;
}

List<Empleado> empleados =
        (List<Empleado>) request.getAttribute("empleados");


%>

<!DOCTYPE html>

<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Administración de Empleados</title>


<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
      rel="stylesheet">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">


</head>

<body>

<!-- HEADER -->

<header class="site-header">


<div class="header-inner">

    <div class="header-brand">

        <div class="brand-icon">
            <svg viewBox="0 0 24 24">
                <path d="M12 2C8.13 2 5 5.13 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.87-3.13-7-7-7z"/>
            </svg>
        </div>

        <div class="brand-text">
            <span class="brand-name">
                Radiología e Imagen Santa Imelda
            </span>

            <span class="brand-sub">
                Panel Administrativo
            </span>
        </div>

    </div>

    <nav class="header-nav">

        <a href="JefaServlet?accion=dashboard"
           class="nav-pill">
            Inicio
        </a>

        <a href="JefaServlet?accion=empleados"
           class="nav-pill active">
            Empleados
        </a>

        <a href="JefaServlet?accion=solicitudes"
           class="nav-pill">
            Solicitudes
        </a>

        <div class="header-user" style="margin-left:.5rem">
            <div class="user-avatar">DH</div>
            <span class="user-name">Dra. Hilda</span>
        </div>

        <a href="LogoutServlet"
           class="nav-pill logout">
            Salir
        </a>

    </nav>

</div>


</header>

<!-- CONTENIDO -->

<div class="page-wrap">

```
<div class="container">

    <div class="page-header">

        <div>
            <div class="page-title">
                Administración de Empleados
            </div>

            <div class="page-subtitle">
                Registro y control de empleados
            </div>
        </div>

    </div>

    <!-- MENSAJES -->

    <% if(request.getParameter("msg") != null){ %>

        <div class="alert alert-success">
            <%= request.getParameter("msg") %>
        </div>

    <% } %>

    <% if(request.getAttribute("error") != null){ %>

        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>

    <% } %>

    <!-- FORMULARIO -->

    <div class="card">

        <div class="card-header">
            <span class="card-title">
                Registrar nuevo empleado
            </span>
        </div>

        <div style="padding:20px;">

            <form action="JefaServlet" method="post">

                <input type="hidden"
                       name="accion"
                       value="agregarEmpleado">

                <div class="form-grid">

                    <div class="form-grid">

    <input type="text"
           name="nombre"
           placeholder="Nombre"
           class="form-control"
           required>

    <input type="text"
           name="apellido"
           placeholder="Apellido"
           class="form-control"
           required>

    <select name="puesto"
            class="form-control"
            required>

        <option value="">
            Seleccione un puesto
        </option>

        <option value="Médico Radiólogo">
            Médico Radiólogo
        </option>

        <option value="Técnico Radiólogo">
            Técnico Radiólogo
        </option>

        <option value="Recepcionista">
            Recepcionista
        </option>

        <option value="Enfermera">
            Enfermera
        </option>

        <option value="Personal de Limpieza">
            Personal de Limpieza
        </option>

    </select>

    <input type="date"
           name="fechaIngreso"
           class="form-control"
           required>

                </div>

                <br>

                <button type="submit"
                        class="btn btn-cyan">
                    Guardar Empleado
                </button>

            </form>

        </div>

    </div>

    <br>

    <!-- TABLA -->

    <div class="card">

        <div class="card-header">
            <span class="card-title">
                Empleados Registrados
            </span>
        </div>

        <div class="table-wrap">

            <table>

                <thead>

                    <tr>
                        <th>Empleado</th>
                        <th>Puesto</th>
                        <th>Sucursal</th>
                        <th>Email</th>
                        <th>Ingreso</th>
                        <th>Días Disponibles</th>
                        <th>Acciones</th>
                    </tr>

                </thead>

                <tbody>

                <% if(empleados != null){ %>

                    <% for(Empleado e : empleados){ %>

                    <tr>

                        <td>
                            <strong>
                                <%= e.getNombreCompleto() %>
                            </strong>
                        </td>

                        <td><%= e.getPuesto() %></td>

                        <td><%= e.getDepartamento() %></td>

                        <td><%= e.getEmail() %></td>

                        <td><%= e.getFechaIngreso() %></td>

                        <td>
                            <%= e.getDiasDisponibles() %>
                        </td>

                        <td>

                            

                            <a href="JefaServlet?accion=eliminarEmpleado&id=<%=e.getIdEmpleado()%>"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('¿Dar de baja al empleado?')">
                                Baja
                            </a>

                        </td>

                    </tr>

                    <% } %>

                <% } %>

                </tbody>

            </table>

        </div>

    </div>

</div>

</div>
<!-- FOOTER -->
  <footer class="site-footer">
    &copy; 2026 <span>Radiología e Imagen Santa Imelda</span> &nbsp;&middot;&nbsp;
    Sistema de Gestión de Vacaciones &nbsp;&middot;&nbsp; Conforme a LFT Art. 76
  </footer>
</body>
</html>

    