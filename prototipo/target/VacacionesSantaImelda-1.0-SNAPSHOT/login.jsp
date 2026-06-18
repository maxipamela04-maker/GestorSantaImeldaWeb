<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Acceso al Sistema — Radiología Santa Imelda</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .login-footer {
      background: rgba(0,0,0,.25);
      color: rgba(255,255,255,.3);
      text-align: center;
      padding: 1rem;
      font-size: .75rem;
      border-top: 1px solid rgba(0,194,255,.1);
      position: relative;
      z-index: 1;
    }
    .login-footer span { color: rgba(0,194,255,.6); }
  </style>
</head>
<body class="login-page">

  <div class="login-waves">
    <div class="wave wave-1"></div>
    <div class="wave wave-2"></div>
    <div class="wave wave-3"></div>
    <div class="wave wave-4"></div>
  </div>
  <div class="login-glow"></div>

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

  <div class="login-body-inner">
    <div class="login-split">

      <div class="login-hero">
        <div class="login-badge">
          <div class="login-badge-dot"></div>
          Sistema activo
        </div>
        <h1>Control de<br>vacaciones<br><em> y permisos</em></h1>
        <p>Gestionar vacaciones no debería ser un trámite complicado. Haz que el descanso sea parte de tu cultura, no un dolor de cabeza administrativo. Tu equipo recargado, tu operación fluida.</p>
        <div class="login-stats">
          <div>
            <div class="login-stat-num">Art. 76</div>
            <div class="login-stat-label">LFT vigente</div>
          </div>
          <div>
            <div class="login-stat-num">100%</div>
            <div class="login-stat-label">Sin papel</div>
          </div>
          <div>
            <div class="login-stat-num">24/7</div>
            <div class="login-stat-label">Disponible</div>
          </div>
        </div>
      </div>

      <div class="login-card">
        <div class="login-card-header">
          <div class="login-card-icon">
            <svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
          </div>
          <h2>Acceso al sistema</h2>
          <p>Ingresa tus credenciales corporativas</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-danger">
            <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/></svg>
            <%= request.getAttribute("error") %>
          </div>
        <% } %>

        <form action="LoginServlet" method="post">
          <div class="form-group">
            <label class="form-label">Usuario corporativo</label>
            <div class="input-wrap">
              <svg class="input-icon" viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
              <input type="text" name="username" class="form-control"
                     placeholder="ej. jradiologol" required autocomplete="username">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label">Contraseña</label>
            <div class="input-wrap">
              <svg class="input-icon" viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
              <input type="password" name="password" class="form-control"
                     placeholder="••••••••" required autocomplete="current-password">
            </div>
          </div>
          <button type="submit" class="btn btn-cyan btn-block btn-lg" style="margin-top:.5rem">
            <svg viewBox="0 0 24 24" style="fill:white"><path d="M10 17v-3H3v-4h7V7l5 5-5 5zm9 2H12v-2h7V5h-7V3h7c1.1 0 2 .9 2 2v14c0 1.1-.9 2-2 2z"/></svg>
            Ingresar al sistema
          </button>
        </form>
      </div>

    </div>
  </div>

  <footer class="login-footer">
    &copy; 2026 <span>Radiología e Imagen Santa Imelda</span> — Todos los derechos reservados
  </footer>

</body>
</html>