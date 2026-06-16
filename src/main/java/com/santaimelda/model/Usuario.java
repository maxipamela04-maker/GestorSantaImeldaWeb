package com.santaimelda.model;

public class Usuario {
    private int    idUsuario;
    private String username;
    private String passwordHash;
    private String rol;   // 'jefa' o 'empleado'
    private boolean activo;

    public Usuario() {}

    public Usuario(int idUsuario, String username, String passwordHash, String rol, boolean activo) {
        this.idUsuario     = idUsuario;
        this.username      = username;
        this.passwordHash  = passwordHash;
        this.rol           = rol;
        this.activo        = activo;
    }

    // ── Getters & Setters ──
    public int    getIdUsuario()      { return idUsuario; }
    public void   setIdUsuario(int v) { idUsuario = v; }

    public String getUsername()        { return username; }
    public void   setUsername(String v){ username = v; }

    public String getPasswordHash()        { return passwordHash; }
    public void   setPasswordHash(String v){ passwordHash = v; }

    public String getRol()        { return rol; }
    public void   setRol(String v){ rol = v; }

    public boolean isActivo()        { return activo; }
    public void    setActivo(boolean v){ activo = v; }
}