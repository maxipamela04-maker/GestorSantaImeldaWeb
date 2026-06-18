<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Error — Santa Imelda</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

  <header class="site-header">
    <div class="header-inner">
      <div class="header-brand">
        <div class="brand-icon">
          <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 2.38 1.19 4.47 3 5.74V17c0 .55.45 1 1 1h6c.55 0 1-.45 1-1v-2.26c1.81-1.27 3-3.36 3-5.74 0-3.87-3.13-7-7-7zm2 14H10v-1h4v1zm0-3H10v-1h4v1z"/></svg>
        </div>
        <div class="brand-text">
          <span class="brand-name">Radiología e Imagen Santa Imelda</span>
          <span class="brand-sub">Sistema de Vacaciones</span>
        </div>
      </div>
    </div>
  </header>

  <div class="page-wrap" style="display:flex;align-items:center;justify-content:center;padding:3rem 1rem">
    <div style="max-width:520px;width:100%;text-align:center">
      <div style="font-size:4rem;margin-bottom:1rem">&#x26A0;&#xFE0F;</div>
      <h2 style="font-size:1.5rem;font-weight:800;color:var(--navy);margin-bottom:.75rem">
        Ha ocurrido un error en el sistema
      </h2>
      <p style="color:var(--gray-600);margin-bottom:1.5rem">
        El servidor no pudo procesar tu solicitud en este momento.
      </p>
      <div class="alert alert-danger" style="text-align:left">
        <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
        <div>
          <strong>Detalle técnico:</strong><br>
          <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Error desconocido o sesión inválida." %>
        </div>
      </div>
      <a href="LoginServlet" class="btn btn-cyan btn-lg">Volver al inicio</a>
    </div>
  </div>

  <footer class="site-footer">
    &copy; 2026 <span>Radiología e Imagen Santa Imelda</span> &nbsp;&middot;&nbsp; Sistema de Gestión de Vacaciones
  </footer>

</body>
</html>
