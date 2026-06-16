package com.santaimelda.servlet;

import com.santaimelda.dao.EmpleadoDAO;
import com.santaimelda.dao.UsuarioDAO;
import com.santaimelda.model.Empleado;
import com.santaimelda.model.Usuario;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            UsuarioDAO uDao = new UsuarioDAO();
            Usuario usuario = uDao.login(username, password);

            if (usuario == null) {
                req.setAttribute("error", "Usuario o contraseña incorrectos.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("usuario", usuario);

            // Redirecciones relativas y limpias para evitar el error 404
            if ("jefa".equals(usuario.getRol())) {
                resp.sendRedirect("JefaServlet");
            } else {
                EmpleadoDAO eDao = new EmpleadoDAO();
                Empleado emp = eDao.buscarPorIdUsuario(usuario.getIdUsuario());
                session.setAttribute("empleado", emp);
                resp.sendRedirect("EmpleadoServlet");
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error de sistema: " + e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}