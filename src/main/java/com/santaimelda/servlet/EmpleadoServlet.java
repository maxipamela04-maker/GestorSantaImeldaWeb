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

@WebServlet("/EmpleadoServlet")
public class EmpleadoServlet extends HttpServlet {

    // ── Verificar sesión válida de empleado ────────────────────────
    private Empleado getEmpleadoSesion(HttpServletRequest req,
                                        HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            resp.sendRedirect("LoginServlet");
            return null;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");

        if ("jefa".equals(u.getRol())) {
            resp.sendRedirect("JefaServlet");
            return null;
        }

        return (Empleado) session.getAttribute("empleado");
    }

    // ── GET: mostrar dashboard ─────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Empleado emp = getEmpleadoSesion(req, resp);
        if (emp == null) return;

        try {
            // Refrescar datos del empleado desde la BD
            EmpleadoDAO eDao = new EmpleadoDAO();
            emp = eDao.buscarPorId(emp.getIdEmpleado());
            req.getSession().setAttribute("empleado", emp);

            // Cargar sus solicitudes
            SolicitudDAO sDao = new SolicitudDAO();
            List<SolicitudVacaciones> solicitudes =
                    sDao.listarPorEmpleado(emp.getIdEmpleado());

            req.setAttribute("empleado", emp);
            req.setAttribute("solicitudes", solicitudes);
            req.getRequestDispatcher("/dashboard_empleado.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }

    // ── POST: enviar nueva solicitud de vacaciones ─────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Empleado emp = getEmpleadoSesion(req, resp);
        if (emp == null) return;

        try {
            // ✅ Nombres exactos que usa el formulario en dashboard_empleado.jsp
            String fechaInicioStr = req.getParameter("fecha_inicio");
            String fechaFinStr    = req.getParameter("fecha_fin");
            String motivo         = req.getParameter("motivo");
            String justif         = req.getParameter("justificante");

            // Protección contra nulls
            if (fechaInicioStr == null || fechaFinStr == null ||
                fechaInicioStr.isEmpty() || fechaFinStr.isEmpty()) {
                req.setAttribute("error", "Las fechas son obligatorias.");
                doGet(req, resp);
                return;
            }
            if (motivo == null) motivo = "";
            if (justif == null) justif = "";

            LocalDate inicio = LocalDate.parse(fechaInicioStr);
            LocalDate fin    = LocalDate.parse(fechaFinStr);

            if (fin.isBefore(inicio)) {
                req.setAttribute("error", "La fecha fin no puede ser antes que la fecha inicio.");
                doGet(req, resp);
                return;
            }

            // ✅ Leer días del formulario (campo dias_solicitados del JSP)
            String diasStr = req.getParameter("dias_solicitados");
            if (diasStr == null || diasStr.isEmpty()) {
                req.setAttribute("error", "El número de días es obligatorio.");
                doGet(req, resp);
                return;
            }
            int dias = Integer.parseInt(diasStr);

            if (dias <= 0) {
                req.setAttribute("error", "El número de días debe ser mayor a 0.");
                doGet(req, resp);
                return;
            }

            // Refrescar empleado para tener días disponibles actualizados
            EmpleadoDAO eDao = new EmpleadoDAO();
            emp = eDao.buscarPorId(emp.getIdEmpleado());

            if (dias > emp.getDiasDisponibles()) {
                req.setAttribute("error", "No tienes suficientes días disponibles. " +
                        "Disponibles: " + emp.getDiasDisponibles());
                doGet(req, resp);
                return;
            }

            SolicitudVacaciones sv = new SolicitudVacaciones();
            sv.setIdEmpleado(emp.getIdEmpleado());
            sv.setFechaInicio(inicio);
            sv.setFechaFin(fin);
            sv.setDiasSolicitados(dias);
            sv.setMotivo(motivo);
            sv.setJustificante(justif);

            new SolicitudDAO().insertar(sv);
            resp.sendRedirect("EmpleadoServlet?msg=Solicitud+enviada+correctamente");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}