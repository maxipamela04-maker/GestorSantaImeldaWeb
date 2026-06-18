package com.santaimelda.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class SolicitudVacaciones {

    private int           idSolicitud;
    private int           idEmpleado;
    private LocalDate     fechaInicio;
    private LocalDate     fechaFin;
    private int           diasSolicitados;
    private String        motivo;
    private String        justificante;
    private String        estado;
    private String        comentarioJefa;
    private LocalDateTime fechaSolicitud;
    private LocalDateTime fechaResolucion;
    private String        nombreEmpleado;

    public SolicitudVacaciones() {}

    // ── Getters & Setters ──────────────────────────────────────────

    public int getIdSolicitud() { return idSolicitud; }
    public void setIdSolicitud(int idSolicitud) { this.idSolicitud = idSolicitud; }

    public int getIdEmpleado() { return idEmpleado; }
    public void setIdEmpleado(int idEmpleado) { this.idEmpleado = idEmpleado; }

    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }

    public LocalDate getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDate fechaFin) { this.fechaFin = fechaFin; }

    public int getDiasSolicitados() { return diasSolicitados; }
    public void setDiasSolicitados(int diasSolicitados) { this.diasSolicitados = diasSolicitados; }

    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }

    public String getJustificante() { return justificante; }
    public void setJustificante(String justificante) { this.justificante = justificante; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getComentarioJefa() { return comentarioJefa; }
    public void setComentarioJefa(String comentarioJefa) { this.comentarioJefa = comentarioJefa; }

    public LocalDateTime getFechaSolicitud() { return fechaSolicitud; }
    public void setFechaSolicitud(LocalDateTime fechaSolicitud) { this.fechaSolicitud = fechaSolicitud; }

    public LocalDateTime getFechaResolucion() { return fechaResolucion; }
    public void setFechaResolucion(LocalDateTime fechaResolucion) { this.fechaResolucion = fechaResolucion; }

    public String getNombreEmpleado() { return nombreEmpleado; }
    public void setNombreEmpleado(String nombreEmpleado) { this.nombreEmpleado = nombreEmpleado; }
}