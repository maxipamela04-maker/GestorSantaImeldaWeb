package com.santaimelda.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Gestiona la conexión a MySQL mediante el patrón Singleton.
 */
public class DBConnection {

    private static final String URL  = 
        "jdbc:mysql://localhost:3306/vacaciones_santa_imelda" +
        "?useUnicode=true&characterEncoding=utf8" +
        "&useSSL=false&serverTimezone=America/Mexico_City";

    // Modifica root/root si tus credenciales locales de MySQL cambian
    private static final String USER = "root";   
    private static final String PASS = "luna030409";   

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
