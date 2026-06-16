package com.santaimelda.dao;

import com.santaimelda.model.SolicitudVacaciones;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SolicitudDAO {

    // ── INSERTAR ────────────────────────────────────────────────────────────
    public void insertar(SolicitudVacaciones sol) throws Exception {
        String sql = "INSERT INTO solicitudes_vacaciones "
                   + "(id_empleado, fecha_inicio, fecha_fin, dias_solicitados, motivo, justificante) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, sol.getIdEmpleado());

            // ✅ Conversión correcta: LocalDate → java.sql.Date
            ps.setDate(2, Date.valueOf(sol.getFechaInicio()));
            ps.setDate(3, Date.valueOf(sol.getFechaFin()));

            ps.setInt(4, sol.getDiasSolicitados());
            ps.setString(5, sol.getMotivo());
            ps.setString(6, sol.getJustificante());

            ps.executeUpdate();
        }
    }

    // ── LISTAR POR EMPLEADO ─────────────────────────────────────────────────
    public List<SolicitudVacaciones> listarPorEmpleado(int idEmpleado) throws Exception {
        List<SolicitudVacaciones> lista = new ArrayList<>();
        String sql = "SELECT * FROM solicitudes_vacaciones "
                   + "WHERE id_empleado = ? ORDER BY id_solicitud DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idEmpleado);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SolicitudVacaciones sol = new SolicitudVacaciones();
                    sol.setIdSolicitud(rs.getInt("id_solicitud"));
                    sol.setIdEmpleado(rs.getInt("id_empleado"));

                    // ✅ Conversión correcta: java.sql.Date → LocalDate
                    Date sqlFechaIni = rs.getDate("fecha_inicio");
                    Date sqlFechaFin = rs.getDate("fecha_fin");
                    if (sqlFechaIni != null) sol.setFechaInicio(sqlFechaIni.toLocalDate());
                    if (sqlFechaFin != null) sol.setFechaFin(sqlFechaFin.toLocalDate());

                    sol.setDiasSolicitados(rs.getInt("dias_solicitados"));
                    sol.setMotivo(rs.getString("motivo"));
                    sol.setJustificante(rs.getString("justificante"));
                    sol.setEstado(rs.getString("estado"));
                    sol.setComentarioJefa(rs.getString("comentario_jefa"));

                    Timestamp ts = rs.getTimestamp("fecha_solicitud");
                    if (ts != null) sol.setFechaSolicitud(ts.toLocalDateTime());

                    lista.add(sol);
                }
            }
        }
        return lista;
    }

    // ── LISTAR TODAS (vista jefa) ────────────────────────────────────────────
    public List<SolicitudVacaciones> listarTodas() throws Exception {
        List<SolicitudVacaciones> lista = new ArrayList<>();
        String sql = "SELECT sv.*, CONCAT(e.nombre,' ',e.apellido) AS nombre_empleado "
                   + "FROM solicitudes_vacaciones sv "
                   + "JOIN empleados e ON sv.id_empleado = e.id_empleado "
                   + "ORDER BY sv.fecha_solicitud DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudVacaciones sol = new SolicitudVacaciones();
                sol.setIdSolicitud(rs.getInt("id_solicitud"));
                sol.setIdEmpleado(rs.getInt("id_empleado"));
                sol.setNombreEmpleado(rs.getString("nombre_empleado"));

                Date sqlFechaIni = rs.getDate("fecha_inicio");
                Date sqlFechaFin = rs.getDate("fecha_fin");
                if (sqlFechaIni != null) sol.setFechaInicio(sqlFechaIni.toLocalDate());
                if (sqlFechaFin != null) sol.setFechaFin(sqlFechaFin.toLocalDate());

                sol.setDiasSolicitados(rs.getInt("dias_solicitados"));
                sol.setMotivo(rs.getString("motivo"));
                sol.setJustificante(rs.getString("justificante"));
                sol.setEstado(rs.getString("estado"));
                sol.setComentarioJefa(rs.getString("comentario_jefa"));

                Timestamp ts = rs.getTimestamp("fecha_solicitud");
                if (ts != null) sol.setFechaSolicitud(ts.toLocalDateTime());

                lista.add(sol);
            }
        }
        return lista;
    }

    // ── LISTAR PENDIENTES ────────────────────────────────────────────────────
    public List<SolicitudVacaciones> listarPendientes() throws Exception {
        List<SolicitudVacaciones> lista = new ArrayList<>();
        String sql = "SELECT sv.*, CONCAT(e.nombre,' ',e.apellido) AS nombre_empleado "
                   + "FROM solicitudes_vacaciones sv "
                   + "JOIN empleados e ON sv.id_empleado = e.id_empleado "
                   + "WHERE sv.estado = 'pendiente' "
                   + "ORDER BY sv.fecha_solicitud ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SolicitudVacaciones sol = new SolicitudVacaciones();
                sol.setIdSolicitud(rs.getInt("id_solicitud"));
                sol.setIdEmpleado(rs.getInt("id_empleado"));
                sol.setNombreEmpleado(rs.getString("nombre_empleado"));

                Date sqlFechaIni = rs.getDate("fecha_inicio");
                Date sqlFechaFin = rs.getDate("fecha_fin");
                if (sqlFechaIni != null) sol.setFechaInicio(sqlFechaIni.toLocalDate());
                if (sqlFechaFin != null) sol.setFechaFin(sqlFechaFin.toLocalDate());

                sol.setDiasSolicitados(rs.getInt("dias_solicitados"));
                sol.setMotivo(rs.getString("motivo"));
                sol.setEstado(rs.getString("estado"));

                lista.add(sol);
            }
        }
        return lista;
    }

    // ── RESOLVER (aprobar / rechazar) ────────────────────────────────────────
    public void resolver(int idSolicitud, String estado, String comentario) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                // 1. Actualizar estado
                String sql1 = "UPDATE solicitudes_vacaciones "
                            + "SET estado = ?, comentario_jefa = ?, fecha_resolucion = NOW() "
                            + "WHERE id_solicitud = ?";
                try (PreparedStatement ps = con.prepareStatement(sql1)) {
                    ps.setString(1, estado);
                    ps.setString(2, comentario);
                    ps.setInt(3, idSolicitud);
                    ps.executeUpdate();
                }

                // 2. Si aprobada → sumar días tomados
                if ("aprobada".equals(estado)) {
                    String sql2 = "UPDATE dias_vacaciones dv "
                                + "JOIN solicitudes_vacaciones sv ON dv.id_empleado = sv.id_empleado "
                                + "SET dv.dias_tomados = dv.dias_tomados + sv.dias_solicitados "
                                + "WHERE sv.id_solicitud = ?";
                    try (PreparedStatement ps = con.prepareStatement(sql2)) {
                        ps.setInt(1, idSolicitud);
                        ps.executeUpdate();
                    }
                }

                con.commit();

            } catch (SQLException ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }
}