<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.santaimelda.model.Empleado"%>
<%@page import="com.santaimelda.model.SolicitudVacaciones"%>
<%@page import="com.santaimelda.model.Usuario"%>
<%@page import="java.util.List"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuario");
    if (u == null || !"jefa".equals(u.getRol())) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    List<Empleado> empleados             = (List<Empleado>) request.getAttribute("empleados");
    List<SolicitudVacaciones> pendientes = (List<SolicitudVacaciones>) request.getAttribute("pendientes");
    List<SolicitudVacaciones> solicitudes= (List<SolicitudVacaciones>) request.getAttribute("solicitudes");
    int totalEmpleados  = empleados  != null ? empleados.size()  : 0;
    int totalPendientes = pendientes != null ? pendientes.size() : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Panel Administrativo — Santa Imelda</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

  <!-- HEADER -->
  <header class="site-header">
    <div class="header-inner">
      <div class="header-brand">
        <div class="brand-icon">
          <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.87-3.13-7-7-7zm2 14H10v-1h4v1zm0-3H10v-1h4v1z"/></svg>
        </div>
        <div class="brand-text">
          <span class="brand-name">Radiología e Imagen Santa Imelda</span>
          <span class="brand-sub">Panel Administrativo</span>
        </div>
      </div>
      <nav class="header-nav">
        <a href="JefaServlet?accion=dashboard"   class="nav-pill <%= solicitudes == null && pendientes != null ? "active" : "" %>">Inicio</a>
        <a href="JefaServlet?accion=empleados"   class="nav-pill">Empleados</a>
        <a href="JefaServlet?accion=solicitudes" class="nav-pill <%= solicitudes != null ? "active" : "" %>">Solicitudes</a>
        <div class="header-user" style="margin-left:.5rem">
          <div class="user-avatar">DH</div>
          <span class="user-name">Dra. Hilda</span>
        </div>
        <a href="LogoutServlet" class="nav-pill logout">Salir</a>
      </nav>
    </div>
  </header>

  <!-- CONTENIDO -->
  <div class="page-wrap">
    <div class="container">

      <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success">
          <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
          <%= request.getParameter("msg") %>
        </div>
      <% } %>

      <!-- ═══ VISTA DASHBOARD ═══ -->
      <% if (solicitudes == null) { %>

        <div class="page-header">
          <div>
            <div class="page-title">Panel de Control</div>
            <div class="page-subtitle">Vista general del sistema de vacaciones</div>
          </div>
          
        </div>

        <!-- KPIs -->
        <div class="kpi-grid">
          <div class="kpi-card kpi-navy">
            <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg></div>
            <div class="kpi-value"><%= totalEmpleados %></div>
            <div class="kpi-label">Empleados activos</div>
          </div>
          <div class="kpi-card kpi-orange">
            <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg></div>
            <div class="kpi-value"><%= totalPendientes %></div>
            <div class="kpi-label">Solicitudes pendientes</div>
          </div>
          <div class="kpi-card kpi-cyan">
            <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M19 3h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm2 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg></div>
            <div class="kpi-value">LFT</div>
            <div class="kpi-label">Art. 76 — Cálculo automático</div>
          </div>
        </div>

        <!-- Tabla empleados -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">
              <svg viewBox="0 0 24 24"><path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"/></svg>
              Empleados y días de vacaciones
            </span>
            <a href="JefaServlet?accion=solicitudes" class="btn btn-outline btn-sm">Ver solicitudes</a>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Empleado</th><th>Puesto</th><th>Departamento</th>
                  <th>Antigüedad</th><th>Días LFT</th><th>Tomados</th>
                  <th>Disponibles</th><th>Acciones</th>
                </tr>
              </thead>
              <tbody>
                <% if (empleados != null) for (Empleado e : empleados) { %>
                  <tr>
                    <td><strong><%= e.getNombreCompleto() %></strong></td>
                    <td><%= e.getPuesto() %></td>
                    <td><%= e.getDepartamento() %></td>
                    <td><%= e.getAniosTrabajados() %> año(s)</td>
                    <td><span class="badge" style="background:#E0F7FF;color:#0099CC"><%= e.getDiasVacacionesLFT() %> días</span></td>
                    <td><span class="badge" style="background:#FEF3C7;color:#92400E"><%= e.getDiasTomados() %> días</span></td>
                    <td>
                      <span class="badge <%= e.getDiasDisponibles() > 0 ? "badge-aprobada" : "badge-rechazada" %>">
                        <%= e.getDiasDisponibles() %> días
                      </span>
                    </td>
                    <td>
                     
                      <a href="JefaServlet?accion=eliminarEmpleado&id=<%= e.getIdEmpleado() %>"
                         class="btn btn-danger btn-sm"
                         onclick="return confirm('¿Desactivar a <%= e.getNombreCompleto() %>?')">Baja</a>
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Solicitudes pendientes -->
        <% if (pendientes != null && !pendientes.isEmpty()) { %>
        <div class="card" style="margin-top:1.5rem">
          <div class="card-header">
            <span class="card-title">
              <svg viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
              Solicitudes pendientes
            </span>
            <span class="badge badge-pendiente"><%= totalPendientes %> pendiente<%= totalPendientes != 1 ? "s" : "" %></span>
          </div>
          <div class="table-wrap">
            <table>
              <thead>
                <tr><th>Empleado</th><th>Desde</th><th>Hasta</th><th>Días</th><th>Motivo</th><th>Acción</th></tr>
              </thead>
              <tbody>
                <% for (SolicitudVacaciones s : pendientes) { %>
                  <tr>
                    <td><strong><%= s.getNombreEmpleado() %></strong></td>
                    <td><%= s.getFechaInicio() %></td>
                    <td><%= s.getFechaFin() %></td>
                    <td><%= s.getDiasSolicitados() %></td>
                    <td><%= s.getMotivo() != null ? s.getMotivo() : "—" %></td>
                    <td>
                      <button class="btn btn-cyan btn-sm"
                              onclick="abrirModal(<%= s.getIdSolicitud() %>,'<%= s.getNombreEmpleado() %>')">
                        Resolver
                      </button>
                    </td>
                  </tr>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>
        <% } %>

      <% } else { %>
      <!-- ═══ VISTA TODAS LAS SOLICITUDES ═══ -->

        <div class="page-header">
          <div>
            <div class="page-title">Todas las Solicitudes</div>
            <div class="page-subtitle">Historial completo del personal</div>
          </div>
          <a href="JefaServlet" class="btn btn-outline btn-sm">← Volver al dashboard</a>
        </div>

        <div class="card">
          <div class="table-wrap">
            <table>
              <thead>
                <tr><th>Empleado</th><th>Solicitado</th><th>Desde</th><th>Hasta</th>
                    <th>Días</th><th>Motivo</th><th>Estado</th><th>Comentario</th><th>Acción</th></tr>
              </thead>
              <tbody>
                <% if (solicitudes.isEmpty()) { %>
                  <tr><td colspan="9" style="text-align:center;color:var(--gray-400);padding:2rem">Sin solicitudes registradas.</td></tr>
                <% } else { for (SolicitudVacaciones s : solicitudes) { %>
                  <tr>
                    <td><strong><%= s.getNombreEmpleado() %></strong></td>
                    <td style="font-size:.8rem;color:var(--gray-400)">
                      <%= s.getFechaSolicitud() != null ? s.getFechaSolicitud().toLocalDate() : "—" %>
                    </td>
                    <td><%= s.getFechaInicio() %></td>
                    <td><%= s.getFechaFin() %></td>
                    <td><%= s.getDiasSolicitados() %></td>
                    <td style="max-width:160px;font-size:.85rem"><%= s.getMotivo() != null ? s.getMotivo() : "—" %></td>
                    <td><span class="badge badge-<%= s.getEstado() %>"><%= s.getEstado() %></span></td>
                    <td style="font-size:.8rem;color:var(--gray-600)">
                      <%= s.getComentarioJefa() != null && !s.getComentarioJefa().isEmpty() ? s.getComentarioJefa() : "—" %>
                    </td>
                    <td>
                      <% if ("pendiente".equals(s.getEstado())) { %>
                        <button class="btn btn-cyan btn-sm"
                                onclick="abrirModal(<%= s.getIdSolicitud() %>,'<%= s.getNombreEmpleado() %>')">
                          Resolver
                        </button>
                      <% } else { %>
                        <span style="font-size:.8rem;color:var(--gray-400)">Resuelta</span>
                      <% } %>
                    </td>
                  </tr>
                <% } } %>
              </tbody>
            </table>
          </div>
        </div>

      <% } %>

    </div>
  </div>

  <!-- FOOTER -->
  <footer class="site-footer">
    &copy; 2026 <span>Radiología e Imagen Santa Imelda</span> &nbsp;&middot;&nbsp;
    Panel Administrativo &nbsp;&middot;&nbsp; Conforme a LFT Art. 76
  </footer>

  <!-- MODAL RESOLVER -->
  <div id="modalOverlay" class="modal-overlay" style="display:none">
    <div class="modal-box">
      <div class="modal-head">
        <h3>Resolver solicitud de vacaciones</h3>
        <button class="modal-close" onclick="cerrarModal()">&#x2715;</button>
      </div>
      <form action="JefaServlet" method="post">
        <input type="hidden" name="accion" value="resolverSolicitud">
        <input type="hidden" name="idSolicitud" id="modalIdSolicitud">
        <div class="modal-body">
          <p id="modalNombre" style="font-weight:700;color:var(--navy);margin-bottom:1.25rem;font-size:1rem"></p>
          <div class="form-group">
            <label class="form-label">Decisión</label>
            <select name="estado" class="form-control no-icon" required>
              <option value="aprobada">&#x2705; Aprobar solicitud</option>
              <option value="rechazada">&#x274C; Rechazar solicitud</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">Comentario para el empleado</label>
            <textarea name="comentario" class="form-control" rows="3"
                      placeholder="Escribe una respuesta o justificación..."></textarea>
          </div>
        </div>
        <div class="modal-actions">
          <button type="button" class="btn btn-outline" onclick="cerrarModal()">Cancelar</button>
          <button type="submit" class="btn btn-cyan">Confirmar resolución</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function abrirModal(id, nombre) {
      document.getElementById('modalIdSolicitud').value = id;
      document.getElementById('modalNombre').textContent = 'Empleado: ' + nombre;
      document.getElementById('modalOverlay').style.display = 'flex';
    }
    function cerrarModal() {
      document.getElementById('modalOverlay').style.display = 'none';
    }
    document.getElementById('modalOverlay').addEventListener('click', function(e) {
      if (e.target === this) cerrarModal();
    });
  </script>

</body>
</html>