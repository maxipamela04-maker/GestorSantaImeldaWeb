package com.santaimelda.model;

import java.time.LocalDate;
import java.time.Period;

public class Empleado {

    private int       idEmpleado;
    private int       idUsuario;
    private String    nombre;
    private String    apellido;
    private String    puesto;
    private String    departamento;
    private LocalDate fechaIngreso;
    private String    email;
    private boolean   activo;
    private int       diasTomados;

    public Empleado() {}

    // ── Getters & Setters ──────────────────────────────────────────

    public int getIdEmpleado() { return idEmpleado; }
    public void setIdEmpleado(int idEmpleado) { this.idEmpleado = idEmpleado; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }

    public String getPuesto() { return puesto; }
    public void setPuesto(String puesto) { this.puesto = puesto; }

    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }

    public LocalDate getFechaIngreso() { return fechaIngreso; }
    public void setFechaIngreso(LocalDate fechaIngreso) { this.fechaIngreso = fechaIngreso; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public boolean isActivo() { return activo; }
    public void setActivo(boolean activo) { this.activo = activo; }

    public int getDiasTomados() { return diasTomados; }
    public void setDiasTomados(int diasTomados) { this.diasTomados = diasTomados; }

    // ── Métodos calculados (no van en la BD) ───────────────────────

    /** Años completos trabajados hasta hoy */
    public int getAniosTrabajados() {
        if (fechaIngreso == null) return 0;
        return Period.between(fechaIngreso, LocalDate.now()).getYears();
    }

    /** Días de vacaciones según LFT Art. 76 (reforma 2023) */
    public int getDiasVacacionesLFT() {
        int anios = getAniosTrabajados();
        if (anios < 1)  return 0;
        if (anios == 1) return 12;
        if (anios == 2) return 14;
        if (anios == 3) return 16;
        if (anios == 4) return 18;
        // 5 años en adelante: 20 días base + 2 por cada 5 años extra
        return 20 + ((anios - 5) / 5) * 2;
    }

    /** Días disponibles = LFT - tomados */
    public int getDiasDisponibles() {
        return getDiasVacacionesLFT() - diasTomados;
    }

    /** Nombre completo para mostrar en las JSPs */
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
}