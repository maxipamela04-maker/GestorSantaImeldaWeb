package com.santaimelda.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Gestiona la conexión a MySQL.
 * Lee la configuración de variables de entorno (para la nube).
 * Si no existen, usa valores locales por defecto.
 */
public class DBConnection {

    private static String env(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isEmpty()) ? def : v;
    }

    private static final String HOST = env("DB_HOST", "localhost");
    private static final String PORT = env("DB_PORT", "3306");
    private static final String NAME = env("DB_NAME", "vacaciones_santa_imelda");
    private static final String USER = env("DB_USER", "root");
    private static final String PASS = env("DB_PASSWORD", "");
    // En la nube (Aiven) se requiere SSL: DB_SSL=true
    private static final boolean SSL = Boolean.parseBoolean(env("DB_SSL", "false"));

    private static final String URL =
        "jdbc:mysql://" + HOST + ":" + PORT + "/" + NAME +
        "?useUnicode=true&characterEncoding=utf8" +
        "&useSSL=" + SSL +
        (SSL ? "&requireSSL=true&verifyServerCertificate=false" : "") +
        "&allowPublicKeyRetrieval=true" +
        "&serverTimezone=America/Mexico_City";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    /** Retorna una conexión nueva. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
