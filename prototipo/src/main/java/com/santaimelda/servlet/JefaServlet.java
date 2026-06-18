package com.santaimelda.servlet;

import com.santaimelda.dao.EmpleadoDAO;
import com.santaimelda.dao.SolicitudDAO;
import com.santaimelda.model.Empleado;
import com.santaimelda.model.SolicitudVacaciones;
import com.santaimelda.model.Usuario;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/JefaServlet")
public class JefaServlet extends HttpServlet {

    // ── Verificar que sea jefa ─────────────────────────────────────
    private boolean checkJefa(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("usuario") == null) {
            resp.sendRedirect("LoginServlet");
            return false;
        }
        Usuario u = (Usuario) s.getAttribute("usuario");
        if (!"jefa".equals(u.getRol())) {
            resp.sendRedirect("LoginServlet");
            return false;
        }
        return true;
    }

    // ── GET: cargar panel según acción ─────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkJefa(req, resp)) return;

        String accion = req.getParameter("accion");
        if (accion == null) accion = "dashboard";

        try {
            SolicitudDAO sDao   = new SolicitudDAO();
            EmpleadoDAO  eDao   = new EmpleadoDAO();

            switch (accion) {

                case "dashboard": {
                    List<SolicitudVacaciones> pendientes = sDao.listarPendientes();
                    List<Empleado>            empleados  = eDao.listarTodos();
                    req.setAttribute("pendientes", pendientes);
                    req.setAttribute("empleados",  empleados);
                    req.getRequestDispatcher("/dashboard_jefa.jsp").forward(req, resp);
                    break;
                }

                case "solicitudes": {
                    List<SolicitudVacaciones> todas = sDao.listarTodas();
                    req.setAttribute("solicitudes", todas);
                    req.getRequestDispatcher("/dashboard_jefa.jsp").forward(req, resp);
                    break;
                }

                case "empleados": {
                    List<Empleado> empleados = eDao.listarTodos();
                    req.setAttribute("empleados", empleados);
                    req.getRequestDispatcher("/lista_empleados.jsp").forward(req, resp);
                    break;
                }

                case "editarEmpleado": {
                    int     id  = Integer.parseInt(req.getParameter("id"));
                    Empleado e  = eDao.buscarPorId(id);
                    req.setAttribute("empleado", e);
                    req.getRequestDispatcher("/form_empleado.jsp").forward(req, resp);
                    break;
                }

                case "eliminarEmpleado": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    eDao.desactivar(id);
                    resp.sendRedirect("JefaServlet?accion=empleados&msg=Empleado+desactivado");
                    break;
                }

                default:
                    resp.sendRedirect("JefaServlet");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/dashboard_jefa.jsp").forward(req, resp);
        }
    }

    // ── POST: procesar acciones ────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!checkJefa(req, resp)) return;

        req.setCharacterEncoding("UTF-8");
        String accion = req.getParameter("accion");
        if (accion == null) accion = "";

        try {
            SolicitudDAO sDao = new SolicitudDAO();
            EmpleadoDAO  eDao = new EmpleadoDAO();

            switch (accion) {

                // ── Aprobar o rechazar solicitud ──────────────────
                case "resolverSolicitud": {
                    int    idSolicitud = Integer.parseInt(req.getParameter("idSolicitud"));
                    String estado      = req.getParameter("estado");      // "aprobada" | "rechazada"
                    String comentario  = req.getParameter("comentario");
                    if (comentario == null) comentario = "";

                    sDao.resolver(idSolicitud, estado, comentario);
                    resp.sendRedirect("JefaServlet?accion=solicitudes&msg=Solicitud+resuelta");
                    break;
                }

                // ── Agregar nuevo empleado ────────────────────────
                case "agregarEmpleado": {
                    
    com.santaimelda.dao.UsuarioDAO uDao =
            new com.santaimelda.dao.UsuarioDAO();

    String nombre = req.getParameter("nombre");
    String apellido = req.getParameter("apellido");
    String puesto = req.getParameter("puesto");

    // Generar username automáticamente
    String username =
            nombre.toLowerCase().replace(" ", "") +
            apellido.toLowerCase().replace(" ", "");

    // Contraseña por defecto
    String password = "Emp1234";

    // Departamento automático según puesto
    String departamento;

    if (puesto.equals("Médico Radiólogo")) {
        departamento = "Radiología";
    } else if (puesto.equals("Técnico Radiólogo")) {
        departamento = "Radiología";
    } else if (puesto.equals("Recepcionista")) {
        departamento = "Admisión";
    } else if (puesto.equals("Enfermera")) {
        departamento = "Enfermería";
    } else {
        departamento = "Servicios";
    }

    // Correo automático
    String email = username + "@santaimelda.com";

    // Si ya existe el usuario
    if (uDao.existeUsername(username)) {

        req.setAttribute("error",
                "Ya existe un empleado con el usuario: "
                + username);

        List<Empleado> empleados = eDao.listarTodos();
        req.setAttribute("empleados", empleados);

        req.getRequestDispatcher("/lista_empleados.jsp")
           .forward(req, resp);
        return;
    }

    int idUsuario =
            uDao.registrar(username, password, "empleado");

    Empleado emp = new Empleado();

    emp.setIdUsuario(idUsuario);
    emp.setNombre(nombre);
    emp.setApellido(apellido);
    emp.setPuesto(puesto);
    emp.setDepartamento(departamento);
    emp.setFechaIngreso(
            LocalDate.parse(
                    req.getParameter("fechaIngreso")
            )
    );
    emp.setEmail(email);

    eDao.insertar(emp);

    resp.sendRedirect(
            "JefaServlet?accion=empleados&msg=Empleado+agregado"
    );

    break;
}

                // ── Actualizar empleado existente ─────────────────
                case "actualizarEmpleado": {
                    Empleado emp = new Empleado();
                    emp.setIdEmpleado(Integer.parseInt(req.getParameter("idEmpleado")));
                    emp.setNombre(req.getParameter("nombre"));
                    emp.setApellido(req.getParameter("apellido"));
                    emp.setPuesto(req.getParameter("puesto"));
                    emp.setDepartamento(req.getParameter("departamento"));
                    emp.setFechaIngreso(LocalDate.parse(req.getParameter("fechaIngreso")));
                    emp.setEmail(req.getParameter("email"));
                    eDao.actualizar(emp);

                    resp.sendRedirect("JefaServlet?accion=empleados&msg=Empleado+actualizado");
                    break;
                }

                default:
                    resp.sendRedirect("JefaServlet");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/dashboard_jefa.jsp").forward(req, resp);
        }
    }
}