package com.santaimelda.dao;

import com.santaimelda.model.Usuario;
import java.security.MessageDigest;
import java.sql.*;

public class UsuarioDAO {

    /** Convierte texto a SHA-256 hex — se usa solo para registrar nuevos usuarios */
    public static String sha256(String texto) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(texto.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error al hashear contraseña", e);
        }
    }

    /** Valida el inicio de sesión.
     *  MySQL hace el SHA2 directamente para evitar diferencias de encoding. */
    public Usuario login(String username, String password) throws SQLException {
        // ✅ MySQL calcula el hash — elimina cualquier diferencia con Java
        String sql = "SELECT * FROM usuarios " +
                     "WHERE username = ? " +
                     "AND password_hash = SHA2(?, 256) " +
                     "AND activo = 1";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password); // se manda la contraseña en texto plano
                                       // MySQL aplica SHA2 internamente

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setIdUsuario(rs.getInt("id_usuario"));
                    u.setUsername(rs.getString("username"));
                    u.setRol(rs.getString("rol"));
                    u.setActivo(rs.getBoolean("activo"));
                    return u;
                }
            }
        }
        return null;
    }

    /** Inserta las credenciales de un nuevo usuario */
    public int registrar(String username, String password, String rol) throws SQLException {
        String sql = "INSERT INTO usuarios (username, password_hash, rol) VALUES (?, SHA2(?,256), ?)";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, username);
            ps.setString(2, password); // MySQL aplica SHA2
            ps.setString(3, rol);
            ps.executeUpdate();

            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    /** Verifica si el username ya existe */
    public boolean existeUsername(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuarios WHERE username = ?";

        try (Connection cn = DBConnection.getConnection();
             PreparedStatement ps = cn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
}