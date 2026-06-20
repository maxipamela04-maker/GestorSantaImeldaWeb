
DROP DATABASE IF EXISTS vacaciones_santa_imelda;
CREATE DATABASE vacaciones_santa_imelda
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE vacaciones_santa_imelda;

-- ── Tabla usuarios ────────────────────────────────────────────
CREATE TABLE usuarios (
    id_usuario     INT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL,
    rol            ENUM('jefa','empleado') NOT NULL DEFAULT 'empleado',
    activo         TINYINT(1) NOT NULL DEFAULT 1,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ── Tabla empleados ───────────────────────────────────────────
CREATE TABLE empleados (
    id_empleado   INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario    INT NOT NULL UNIQUE,
    nombre        VARCHAR(100) NOT NULL,
    apellido      VARCHAR(100) NOT NULL,
    puesto        VARCHAR(100) NOT NULL,
    departamento  VARCHAR(100) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    email         VARCHAR(150) NOT NULL,
    activo        TINYINT(1) NOT NULL DEFAULT 1,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- ── Tabla solicitudes ─────────────────────────────────────────
CREATE TABLE solicitudes_vacaciones (
    id_solicitud     INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado      INT NOT NULL,
    fecha_inicio     DATE NOT NULL,
    fecha_fin        DATE NOT NULL,
    dias_solicitados INT NOT NULL,
    motivo           TEXT,
    justificante     VARCHAR(255),
    estado           ENUM('pendiente','aprobada','rechazada') DEFAULT 'pendiente',
    comentario_jefa  TEXT,
    fecha_solicitud  DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_resolucion DATETIME,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- ── Tabla dias_vacaciones ─────────────────────────────────────
CREATE TABLE dias_vacaciones (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado  INT NOT NULL UNIQUE,
    dias_tomados INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- ── Insertar usuarios ─────────────────────────────────────────
INSERT INTO usuarios (username, password_hash, rol) VALUES
('dra.hilda',   SHA2('Admin1234', 256), 'jefa'),
('jradiologol', SHA2('Emp1234',   256), 'empleado'),
('JesusRui',    SHA2('Emp12345',   256), 'empleado'),
('arecepcion',  SHA2('Emp1234',   256), 'empleado'),
('benfermera',  SHA2('Emp1234',   256), 'empleado'),
('climpiezam',  SHA2('Emp1234',   256), 'empleado'),
('dramirez',    SHA2('Emp1234',   256), 'empleado'),
('lsanchez',    SHA2('Emp1234',   256), 'empleado'),
('mlopez',      SHA2('Emp1234',   256), 'empleado'),
('pgarcia',     SHA2('Emp1234',   256), 'empleado'),
('rmorales',    SHA2('Emp1234',   256), 'empleado'),
('cvazquez',    SHA2('Emp1234',   256), 'empleado'),
('jgomez',      SHA2('Emp1234',   256), 'empleado'),
('ahernandez',  SHA2('Emp1234',   256), 'empleado'),
('nflores',     SHA2('Emp1234',   256), 'empleado');

-- ── Insertar empleados ────────────────────────────────────────
-- IMPORTANTE: id_usuario debe coincidir con el AUTO_INCREMENT de usuarios
-- dra.hilda = id 1, jradiologol = id 2, mtecnico = id 3 ... etc

INSERT INTO empleados (id_usuario, nombre, apellido, puesto, departamento, fecha_ingreso, email) VALUES
(2,  'Juan',      'Ramirez',  'Radiólogo Senior',        'Radiología',  '2018-03-15', 'jradiologol@santaimelda.com'),
(3,  'María',     'Técnico',    'Técnico Radiólogo',        'Radiología',  '2019-06-01', 'mtecnico@santaimelda.com'),
(4,  'Alejandra', 'Recepción',  'Recepcionista',            'Admisión',    '2020-01-10', 'arecepcion@santaimelda.com'),
(5,  'Beatriz',   'Enfermera',  'Enfermera',                'Enfermería',  '2017-09-20', 'benfermera@santaimelda.com'),
(6,  'Carlos',    'Limpieza',   'Personal de Limpieza',     'Servicios',   '2021-04-05', 'climpiezam@santaimelda.com'),
(7,  'Diana',     'Ramírez',    'Técnico Radiólogo',        'Radiología',  '2016-11-12', 'dramirez@santaimelda.com'),
(8,  'Luis',      'Sánchez',    'Radiólogo',                'Radiología',  '2022-02-28', 'lsanchez@santaimelda.com'),
(9,  'Marta',     'López',      'Recepcionista',            'Admisión',    '2015-07-14', 'mlopez@santaimelda.com'),
(10, 'Pedro',     'García',     'Técnico Radiólogo',        'Radiología',  '2020-08-03', 'pgarcia@santaimelda.com'),
(11, 'Rosa',      'Morales',    'Enfermera',                'Enfermería',  '2018-12-01', 'rmorales@santaimelda.com'),
(12, 'Carlos',    'Vázquez',    'Personal de Limpieza',     'Servicios',   '2023-01-15', 'cvazquez@santaimelda.com'),
(13, 'Jorge',     'Gómez',      'Radiólogo',                'Radiología',  '2014-05-22', 'jgomez@santaimelda.com'),
(14, 'Ana',       'Hernández',  'Técnico Radiólogo',        'Radiología',  '2019-10-30', 'ahernandez@santaimelda.com'),
(15, 'Nora',      'Flores',     'Recepcionista',            'Admisión',    '2021-03-18', 'nflores@santaimelda.com');

-- ── Inicializar días tomados ──────────────────────────────────
INSERT INTO dias_vacaciones (id_empleado, dias_tomados)
SELECT id_empleado, 0 FROM empleados;

-- ── Solicitudes de ejemplo ────────────────────────────────────
INSERT INTO solicitudes_vacaciones 
    (id_empleado, fecha_inicio, fecha_fin, dias_solicitados, motivo, estado) 
VALUES
(1, '2025-01-06', '2025-01-11', 6, 'Vacaciones anuales',  'aprobada'),
(2, '2025-02-10', '2025-02-15', 5, 'Descanso',            'aprobada'),
(3, '2025-03-03', '2025-03-07', 4, 'Asunto familiar',     'pendiente'),
(4, '2025-03-10', '2025-03-14', 5, 'Vacaciones',          'rechazada'),
(5, '2025-04-07', '2025-04-11', 5, 'Vacaciones anuales',  'aprobada'),
(1, '2025-06-02', '2025-06-06', 5, 'Descanso médico',     'pendiente');

-- ── Verificar que todo quedó bien ─────────────────────────────
SELECT u.username, u.rol, e.nombre, e.apellido, e.puesto
FROM usuarios u
LEFT JOIN empleados e ON u.id_usuario = e.id_usuario
ORDER BY u.id_usuario;
-- Ver hash guardado
SELECT username, password_hash FROM usuarios WHERE username = 'jradiologol';

-- Ver hash que debería generar Java
SELECT SHA2('Emp1234', 256) AS hash_esperado;
INSERT INTO empleados 
(id_usuario, nombre, apellido, puesto, departamento, fecha_ingreso, email) 
VALUES

(16, 'Ricardo',  'Martínez',  'Radiólogo',            'Radiología', '2017-08-10', 'rmartinez@santaimelda.com'),
(17, 'Patricia', 'Ruiz',      'Enfermera',            'Enfermería', '2018-04-25', 'pruiz@santaimelda.com'),
(18, 'Fernando', 'Castillo',  'Técnico Radiólogo',    'Radiología', '2020-09-14', 'fcastillo@santaimelda.com'),
(19, 'Gabriela', 'Torres',    'Recepcionista',        'Admisión',   '2022-06-01', 'gtorres@santaimelda.com'),
(20, 'Miguel',   'Navarro',   'Personal de Limpieza', 'Servicios',  '2021-11-08', 'mnavarro@santaimelda.com'),
(21, 'Sofía',    'Jiménez',   'Enfermera',            'Enfermería', '2016-02-17', 'sjimenez@santaimelda.com'),
(22, 'Héctor',   'Ortega',    'Radiólogo',            'Radiología', '2015-12-03', 'hortega@santaimelda.com'),
(23, 'Valeria',  'Cruz',      'Recepcionista',        'Admisión',   '2023-05-19', 'vcruz@santaimelda.com'),
(24, 'Arturo',   'Reyes',     'Técnico Radiólogo',    'Radiología', '2019-07-22', 'areyes@santaimelda.com'),
(25, 'Liliana',  'Mendoza',   'Personal de Limpieza', 'Servicios',  '2024-01-09', 'lmendoza@santaimelda.com');

select * from empleados;
INSERT INTO empleados
(id_usuario, nombre, apellido, puesto, departamento, fecha_ingreso, email)
VALUES
(17, 'Ricardo',  'Martínez',  'Médico Radiólogo',    'Radiología', '2017-08-10', 'rmartinez@santaimelda.com'),
(18, 'Patricia', 'Ruiz',      'Enfermera',           'Enfermería', '2018-04-25', 'pruiz@santaimelda.com'),
(19, 'Fernando', 'Castillo',  'Técnico Radiólogo',   'Radiología', '2020-09-14', 'fcastillo@santaimelda.com'),
(20, 'Gabriela', 'Torres',    'Recepcionista',       'Admisión',   '2022-06-01', 'gtorres@santaimelda.com'),
(21, 'Miguel',   'Navarro',   'Personal de Limpieza','Servicios',  '2021-11-08', 'mnavarro@santaimelda.com'),
(22, 'Sofía',    'Jiménez',   'Enfermera',           'Enfermería', '2016-02-17', 'sjimenez@santaimelda.com'),
(23, 'Héctor',   'Ortega',    'Médico Radiólogo',    'Radiología', '2015-12-03', 'hortega@santaimelda.com'),
(24, 'Valeria',  'Cruz',      'Recepcionista',       'Admisión',   '2023-05-19', 'vcruz@santaimelda.com'),
(25, 'Arturo',   'Reyes',     'Técnico Radiólogo',   'Radiología', '2019-07-22', 'areyes@santaimelda.com');
select * from usuarios;
INSERT INTO usuarios (username, password_hash, rol) VALUES
(