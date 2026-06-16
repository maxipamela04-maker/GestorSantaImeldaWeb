package com.santaimelda.dao;

import com.santaimelda.model.Empleado;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class EmpleadoDAO {

    // ── Método auxiliar (mapeo de fila → objeto) ───────────────────
    private Empleado mapRow(ResultSet rs) throws Exception {
        Empleado emp = new Empleado();
        emp.setIdEmpleado(rs.getInt("id_empleado"));
        emp.setIdUsuario(rs.getInt("id_usuario"));
        emp.setNombre(rs.getString("nombre"));
        emp.setApellido(rs.getString("apellido"));
        emp.setPuesto(rs.getString("puesto"));
        emp.setDepartamento(rs.getString("departamento"));

        Date fechaSql = rs.getDate("fecha_ingreso");
        if (fechaSql != null) emp.setFechaIngreso(fechaSql.toLocalDate());

        emp.setEmail(rs.getString("email"));
        emp.setActivo(rs.getBoolean("activo"));

        // dias_tomados viene del JOIN con dias_vacaciones
        try { emp.setDiasTomados(rs.getInt("dias_tomados")); } catch (Exception ignored) {}

        return emp;
    }

    // ── Buscar por id_usuario (para el login) ──────────────────────
    public Empleado buscarPorIdUsuario(int idUsuario) throws Exception {
        String sql = "SELECT e.*, COALESCE(dv.dias_tomados, 0) AS dias_tomados " +
                     "FROM empleados e " +
                     "LEFT JOIN dias_vacaciones dv ON e.id_empleado = dv.id_empleado " +
                     "WHERE e.id_usuario = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ── Buscar por id_empleado ─────────────────────────────────────
    public Empleado buscarPorId(int idEmpleado) throws Exception {
        String sql = "SELECT e.*, COALESCE(dv.dias_tomados, 0) AS dias_tomados " +
                     "FROM empleados e " +
                     "LEFT JOIN dias_vacaciones dv ON e.id_empleado = dv.id_empleado " +
                     "WHERE e.id_empleado = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEmpleado);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    // ── Listar todos los empleados activos ─────────────────────────
    public List<Empleado> listarTodos() throws Exception {
        List<Empleado> lista = new ArrayList<>();
        String sql = "SELECT e.*, COALESCE(dv.dias_tomados, 0) AS dias_tomados " +
                     "FROM empleados e " +
                     "LEFT JOIN dias_vacaciones dv ON e.id_empleado = dv.id_empleado " +
                     "WHERE e.activo = 1 " +
                     "ORDER BY e.apellido";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) lista.add(mapRow(rs));
        }
        return lista;
    }

    // ── Insertar nuevo empleado ────────────────────────────────────
    public void insertar(Empleado e) throws Exception {
        String sql = "INSERT INTO empleados " +
                     "(id_usuario, nombre, apellido, puesto, departamento, fecha_ingreso, email) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, e.getIdUsuario());
            ps.setString(2, e.getNombre());
            ps.setString(3, e.getApellido());
            ps.setString(4, e.getPuesto());
            ps.setString(5, e.getDepartamento());
            ps.setDate(6, Date.valueOf(e.getFechaIngreso()));
            ps.setString(7, e.getEmail());
            ps.executeUpdate();

            // Inicializar días_vacaciones en 0
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) {
                    int newId = gk.getInt(1);
                    String ins = "INSERT INTO dias_vacaciones (id_empleado, dias_tomados) VALUES (?, 0)";
                    try (PreparedStatement ps2 = con.prepareStatement(ins)) {
                        ps2.setInt(1, newId);
                        ps2.executeUpdate();
                    }
                }
            }
        }
    }

    // ── Actualizar empleado ────────────────────────────────────────
    public void actualizar(Empleado e) throws Exception {
        String sql = "UPDATE empleados SET nombre=?, apellido=?, puesto=?, " +
                     "departamento=?, fecha_ingreso=?, email=? " +
                     "WHERE id_empleado=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, e.getNombre());
            ps.setString(2, e.getApellido());
            ps.setString(3, e.getPuesto());
            ps.setString(4, e.getDepartamento());
            ps.setDate(5, Date.valueOf(e.getFechaIngreso()));
            ps.setString(6, e.getEmail());
            ps.setInt(7, e.getIdEmpleado());
            ps.executeUpdate();
        }
    }

    // ── Desactivar empleado (borrado lógico) ───────────────────────
    public void desactivar(int idEmpleado) throws Exception {
        String sql = "UPDATE empleados SET activo = 0 WHERE id_empleado = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idEmpleado);
            ps.executeUpdate();
        }
    }
}