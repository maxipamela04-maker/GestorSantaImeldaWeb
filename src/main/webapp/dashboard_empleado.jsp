<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.santaimelda.model.Empleado"%>
<%@page import="com.santaimelda.model.SolicitudVacaciones"%>
<%@page import="java.util.List"%>
<%
    Empleado emp = (Empleado) session.getAttribute("empleado");
    if (emp == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
    List<SolicitudVacaciones> solicitudes = (List<SolicitudVacaciones>) request.getAttribute("solicitudes");
    String iniciales = "";
    if (emp.getNombre()   != null && !emp.getNombre().isEmpty())   iniciales += emp.getNombre().charAt(0);
    if (emp.getApellido() != null && !emp.getApellido().isEmpty()) iniciales += emp.getApellido().charAt(0);
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Mi Panel — Santa Imelda</title>
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
          <span class="brand-sub">Portal del Empleado</span>
        </div>
      </div>
      <nav class="header-nav">
        <div class="header-user">
          <div class="user-avatar"><%= iniciales %></div>
          <span class="user-name"><%= emp.getNombreCompleto() %></span>
        </div>
        <a href="LogoutServlet" class="nav-pill logout">
          <svg style="width:13px;height:13px;fill:currentColor;vertical-align:middle;margin-right:3px" viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
          Salir
        </a>
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
      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
          <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
          <%= request.getAttribute("error") %>
        </div>
      <% } %>

      <!-- Perfil -->
      <div class="employee-profile">
        <div class="profile-avatar"><%= iniciales %></div>
        <div class="profile-info">
          <h2><%= emp.getNombreCompleto() %></h2>
          <p><%= emp.getPuesto() %> &nbsp;&middot;&nbsp; <%= emp.getDepartamento() %></p>
          <div class="profile-tags">
            <span class="profile-tag"><%= emp.getAniosTrabajados() %> año<%= emp.getAniosTrabajados() != 1 ? "s" : "" %> de antigüedad</span>
            <span class="profile-tag">Ingreso: <%= emp.getFechaIngreso() %></span>
            <span class="profile-tag"><%= emp.getEmail() %></span>
          </div>
        </div>
      </div>

      <!-- KPIs -->
      <div class="kpi-grid">
        <div class="kpi-card kpi-navy">
          <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div>
          <div class="kpi-value"><%= emp.getAniosTrabajados() %></div>
          <div class="kpi-label">Años trabajados</div>
        </div>
        <div class="kpi-card kpi-cyan">
          <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm0 16H5V8h14v11zM7 10h5v5H7z"/></svg></div>
          <div class="kpi-value"><%= emp.getDiasVacacionesLFT() %></div>
          <div class="kpi-label">Días por Ley (LFT)</div>
        </div>
        <div class="kpi-card kpi-orange">
          <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11z"/></svg></div>
          <div class="kpi-value"><%= emp.getDiasTomados() %></div>
          <div class="kpi-label">Días consumidos</div>
        </div>
        <div class="kpi-card kpi-green">
          <div class="kpi-icon"><svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg></div>
          <div class="kpi-value" style="color:<%= emp.getDiasDisponibles() > 0 ? "var(--success)" : "var(--danger)" %>">
            <%= emp.getDiasDisponibles() %>
          </div>
          <div class="kpi-label">Días disponibles</div>
        </div>
      </div>

      <!-- Grid principal -->
      <div class="two-col">

        <!-- Formulario solicitud -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">
              <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-7 3c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm7 13H5v-.23c0-.62.28-1.2.76-1.58C7.47 15.82 9.64 15 12 15s4.53.82 6.24 2.19c.48.38.76.97.76 1.58V19z"/></svg>
              Nueva solicitud de vacaciones
            </span>
          </div>
          <div class="card-body">
            <% if (emp.getDiasDisponibles() <= 0) { %>
              <div class="alert alert-warning">
                <svg viewBox="0 0 24 24"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>
                No tienes días disponibles este período.
              </div>
            <% } %>
            <form action="EmpleadoServlet" method="POST">
              <div class="two-col" style="gap:.75rem">
                <div class="form-group">
                  <label class="form-label">Fecha inicio</label>
                  <input type="date" name="fecha_inicio" class="form-control no-icon" required>
                </div>
                <div class="form-group">
                  <label class="form-label">Fecha fin</label>
                  <input type="date" name="fecha_fin" class="form-control no-icon" required>
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">Días laborables solicitados</label>
                <input type="number" name="dias_solicitados" class="form-control no-icon"
                       min="1" max="<%= emp.getDiasDisponibles() %>" placeholder="ej. 5" required>
              </div>
              <div class="form-group">
                <label class="form-label">Motivo / Comentarios</label>
                <textarea name="motivo" class="form-control" rows="3"
                          placeholder="Describe brevemente el motivo..."></textarea>
              </div>
              <div class="form-group">
                <label class="form-label">Justificante (folio o referencia)</label>
                <input type="text" name="justificante" class="form-control no-icon"
                       placeholder="Opcional — número de folio, etc.">
              </div>
              <button type="submit" class="btn btn-cyan btn-block"
                      <%= emp.getDiasDisponibles() <= 0 ? "disabled" : "" %>>
                <svg viewBox="0 0 24 24" style="fill:white"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg>
                Enviar solicitud a la Dra. Hilda
              </button>
            </form>
          </div>
        </div>

        <!-- Historial -->
        <div class="card">
          <div class="card-header">
            <span class="card-title">
              <svg viewBox="0 0 24 24"><path d="M13 3c-4.97 0-9 4.03-9 9H1l3.89 3.89.07.14L9 12H6c0-3.87 3.13-7 7-7s7 3.13 7 7-3.13 7-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42C8.27 19.99 10.51 21 13 21c4.97 0 9-4.03 9-9s-4.03-9-9-9zm-1 5v5l4.28 2.54.72-1.21-3.5-2.08V8H12z"/></svg>
              Mis solicitudes
            </span>
          </div>
          <% if (solicitudes == null || solicitudes.isEmpty()) { %>
            <div class="empty-state">
              <svg viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
              <p>No has enviado solicitudes aún.</p>
            </div>
          <% } else { %>
            <div class="table-wrap">
              <table>
                <thead>
                  <tr><th>Período</th><th>Días</th><th>Estado</th><th>Respuesta</th></tr>
                </thead>
                <tbody>
                  <% for (SolicitudVacaciones s : solicitudes) { %>
                    <tr>
                      <td>
                        <strong><%= s.getFechaInicio() %></strong><br>
                        <small style="color:var(--gray-400)">al <%= s.getFechaFin() %></small>
                      </td>
                      <td><strong><%= s.getDiasSolicitados() %></strong></td>
                      <td><span class="badge badge-<%= s.getEstado() %>"><%= s.getEstado() %></span></td>
                      <td style="font-size:.8rem;color:var(--gray-600)">
                        <%= s.getComentarioJefa() != null && !s.getComentarioJefa().isEmpty() ? s.getComentarioJefa() : "—" %>
                      </td>
                    </tr>
                  <% } %>
                </tbody>
              </table>
            </div>
          <% } %>
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