CREATE DATABASE BaseDatosAttendifyCompleja;
USE BaseDatosAttendifyCompleja;

-- Tabla de días
CREATE TABLE Dia (
    idDia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(10) NOT NULL
);

-- Tabla de horarios
CREATE TABLE Horario (
    idHorario INT AUTO_INCREMENT PRIMARY KEY,
    nombreHorario VARCHAR(50) NOT NULL,
    horasMaxSemanales INT DEFAULT 40
);

-- Asociación Horario - Día
CREATE TABLE Horario_DiaTrabajo (
    idHorarioDiaTrabajo INT AUTO_INCREMENT PRIMARY KEY,
    idHorario INT NOT NULL,
    idDia INT NOT NULL,
    horaEntrada TIME NOT NULL,
    horaSalida TIME NOT NULL,
    tiempoDescanso INT DEFAULT 0,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (idHorario) REFERENCES Horario(idHorario) ON DELETE CASCADE,
    FOREIGN KEY (idDia) REFERENCES Dia(idDia) ON DELETE CASCADE
);

-- Tabla de empleados
CREATE TABLE Empleado (
    idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(10) UNIQUE NOT NULL,
    idHorario INT,
    telefono VARCHAR(15),
    email VARCHAR(100),
    puesto VARCHAR(50),
    FOREIGN KEY (idHorario) REFERENCES Horario(idHorario) ON DELETE SET NULL
);

-- Usuarios (login)
CREATE TABLE Usuario (
    idUsuario INT AUTO_INCREMENT PRIMARY KEY,
    idEmpleado INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('Administrador','Empleado') NOT NULL,
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado) ON DELETE CASCADE
);

-- Registros de jornada
CREATE TABLE Registro (
    idRegistro INT AUTO_INCREMENT PRIMARY KEY,
    idEmpleado INT NOT NULL,
    estado ENUM('Pendiente','Completado','Falta') DEFAULT 'Pendiente',
    fecha DATE NOT NULL,
    horaEntrada TIME,
    horaSalida TIME,
    comentarios VARCHAR(255),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado) ON DELETE CASCADE
);

-- Días festivos
CREATE TABLE DiaFestivo (
    idFestivo INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL
);

-- Vacaciones
CREATE TABLE Vacaciones (
    idVacaciones INT AUTO_INCREMENT PRIMARY KEY,
    idEmpleado INT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    descripcion VARCHAR(100),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado) ON DELETE CASCADE,
    CHECK (fechaInicio <= fechaFin)
);

-- Insertar días de la semana
INSERT INTO Dia (nombre) VALUES 
('Lunes'), ('Martes'), ('Miércoles'), ('Jueves'), ('Viernes'), ('Sábado'), ('Domingo');

-- Insertar 3 horarios diferentes
INSERT INTO Horario (nombreHorario, horasMaxSemanales) VALUES 
('Horario General', 40),
('Horario Media Jornada', 20),
('Horario Fin de Semana', 16);

-- Asociar días laborales con el horario general
INSERT INTO Horario_DiaTrabajo (idHorario, idDia, horaEntrada, horaSalida, tiempoDescanso)
VALUES 
-- Horario General (L-V jornada completa)
(1, 1, '09:00:00', '17:00:00', 60), -- Lunes
(1, 2, '09:00:00', '17:00:00', 60), -- Martes
(1, 3, '09:00:00', '17:00:00', 60), -- Miércoles
(1, 4, '09:00:00', '17:00:00', 60), -- Jueves
(1, 5, '09:00:00', '17:00:00', 60), -- Viernes

-- Horario Media Jornada (L-V mañanas)
(2, 1, '09:00:00', '13:00:00', 30),  -- Lunes
(2, 2, '09:00:00', '13:00:00', 30),  -- Martes
(2, 3, '09:00:00', '13:00:00', 30),  -- Miércoles
(2, 4, '09:00:00', '13:00:00', 30),  -- Jueves
(2, 5, '09:00:00', '13:00:00', 30),  -- Viernes

-- Horario Fin de Semana
(3, 6, '10:00:00', '18:00:00', 60), -- Sábado
(3, 7, '10:00:00', '18:00:00', 60); -- Domingo

-- Insertar 12 empleados (10 nuevos + 2 originales)
INSERT INTO Empleado (nombre, apellidos, dni, idHorario, telefono, email, puesto)
VALUES 
-- Empleados originales
('Admin', 'Principal', '00000000A', 1, '600000000', 'admin@empresa.com', 'Gerente'),
('Usuario', 'Empleado', '00000001B', 1, '600000001', 'usuario@empresa.com', 'Operario'),

-- Nuevos empleados
('María', 'García López', '12345678C', 1, '611222333', 'maria.garcia@empresa.com', 'Administrativa'),
('Carlos', 'Rodríguez Martín', '23456789D', 1, '622333444', 'carlos.rodriguez@empresa.com', 'Técnico'),
('Laura', 'Fernández Ruiz', '34567890E', 2, '633444555', 'laura.fernandez@empresa.com', 'Recepcionista'),
('Javier', 'Martínez Gómez', '45678901F', 1, '644555666', 'javier.martinez@empresa.com', 'Desarrollador'),
('Ana', 'López Sánchez', '56789012G', 2, '655666777', 'ana.lopez@empresa.com', 'Diseñadora'),
('Miguel', 'Sánchez García', '67890123H', 1, '666777888', 'miguel.sanchez@empresa.com', 'Analista'),
('Elena', 'Gómez Torres', '78901234I', 1, '677888999', 'elena.gomez@empresa.com', 'Recursos Humanos'),
('David', 'Torres Vargas', '89012345J', 3, '688999000', 'david.torres@empresa.com', 'Seguridad'),
('Patricia', 'Navarro Ramos', '90123456K', 2, '699000111', 'patricia.navarro@empresa.com', 'Atención al Cliente'),
('Roberto', 'Jiménez Ortiz', '01234567L', 3, '600111222', 'roberto.jimenez@empresa.com', 'Mantenimiento');

-- Insertar 12 usuarios (10 nuevos + 2 originales)
INSERT INTO Usuario (idEmpleado, username, password, rol)
VALUES 
-- Usuarios originales
(1, 'admin', 'admin', 'Administrador'),
(2, 'usuario', 'usuario', 'Empleado'),

-- Nuevos usuarios
(3, 'mgarcia', 'password123', 'Empleado'),
(4, 'crodriguez', 'password123', 'Empleado'),
(5, 'lfernandez', 'password123', 'Empleado'),
(6, 'jmartinez', 'password123', 'Administrador'),
(7, 'alopez', 'password123', 'Empleado'),
(8, 'msanchez', 'password123', 'Administrador'),
(9, 'egomez', 'password123', 'Empleado'),
(10, 'dtorres', 'password123', 'Empleado'),
(11, 'pnavarro', 'password123', 'Empleado'),
(12, 'rjimenez', 'password123', 'Empleado');

-- Insertar 7 días festivos (5 nuevos + 2 originales)
INSERT INTO DiaFestivo (fecha, nombre)
VALUES 
-- Festivos originales
('2025-01-01', 'Año Nuevo'),
('2025-12-25', 'Navidad'),

-- Nuevos festivos
('2025-01-06', 'Día de Reyes'),
('2025-04-18', 'Viernes Santo'),
('2025-05-01', 'Día del Trabajo'),
('2025-10-12', 'Fiesta Nacional'),
('2025-12-06', 'Día de la Constitución');

-- Insertar 6 períodos de vacaciones (5 nuevos + 1 original)
INSERT INTO Vacaciones (idEmpleado, fechaInicio, fechaFin, descripcion)
VALUES 
-- Vacaciones originales
(2, '2025-08-01', '2025-08-15', 'Vacaciones de verano'),

-- Nuevas vacaciones
(3, '2025-04-07', '2025-04-14', 'Semana Santa'),
(4, '2025-07-01', '2025-07-15', 'Vacaciones de verano'),
(5, '2025-12-22', '2025-12-31', 'Navidad'),
(8, '2025-06-15', '2025-06-30', 'Vacaciones de verano'),
(6, '2025-04-28', '2025-04-28', 'Vacaciones de Javier'),
(10, '2025-09-01', '2025-09-14', 'Vacaciones de septiembre');

-- Insertar múltiples registros de jornada para probar los informes
-- Se añaden registros para los últimos 2 meses (Abril y Mayo 2025)

-- Registros para Abril 2025 (del 1 al 30 de Abril)
-- Empleado 2 (Usuario Empleado)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(2, 'Completado', '2025-04-01', '08:55:00', '17:05:00', 'Día normal'),
(2, 'Completado', '2025-04-02', '09:03:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-03', '08:59:00', '17:02:00', 'Día normal'),
(2, 'Completado', '2025-04-04', '09:10:00', '17:00:00', 'Llegada con retraso'),
(2, 'Falta', '2025-04-07', NULL, NULL, 'Enfermedad'),
(2, 'Falta', '2025-04-08', NULL, NULL, 'Enfermedad'),
(2, 'Completado', '2025-04-09', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-10', '09:05:00', '17:10:00', 'Día normal'),
(2, 'Completado', '2025-04-11', '09:00:00', '16:30:00', 'Salida anticipada autorizada'),
(2, 'Completado', '2025-04-14', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-15', '08:50:00', '17:05:00', 'Día normal'),
(2, 'Completado', '2025-04-16', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-17', '09:07:00', '17:07:00', 'Día normal'),
(2, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(2, 'Completado', '2025-04-21', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-22', '09:05:00', '17:05:00', 'Día normal'),
(2, 'Completado', '2025-04-23', '09:00:00', '17:15:00', 'Horas extra'),
(2, 'Completado', '2025-04-24', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-25', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-28', '09:15:00', '17:15:00', 'Llegada con retraso'),
(2, 'Completado', '2025-04-29', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-04-30', '09:00:00', '17:30:00', 'Horas extra');

-- Empleado 3 (María García)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(3, 'Completado', '2025-04-01', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-02', '09:05:00', '17:05:00', 'Día normal'),
(3, 'Completado', '2025-04-03', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-04', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-07', '09:07:00', '17:07:00', 'Día normal'),
(3, 'Completado', '2025-04-08', '09:03:00', '17:03:00', 'Día normal'),
(3, 'Completado', '2025-04-09', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-10', '08:55:00', '17:05:00', 'Día normal'),
(3, 'Completado', '2025-04-11', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-14', '09:15:00', '17:15:00', 'Llegada con retraso'),
(3, 'Completado', '2025-04-15', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-16', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-17', '09:05:00', '17:05:00', 'Día normal'),
(3, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(3, 'Completado', '2025-04-21', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-22', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-04-23', '09:10:00', '17:10:00', 'Llegada con retraso'),
(3, 'Completado', '2025-04-24', '09:00:00', '17:30:00', 'Horas extra'),
(3, 'Completado', '2025-04-25', '09:00:00', '17:00:00', 'Día normal');

-- Empleado 4 (Carlos Rodríguez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(4, 'Completado', '2025-04-01', '09:05:00', '17:05:00', 'Día normal'),
(4, 'Completado', '2025-04-02', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-03', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-04', '09:00:00', '17:15:00', 'Horas extra'),
(4, 'Falta', '2025-04-07', NULL, NULL, 'Permiso personal'),
(4, 'Completado', '2025-04-08', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-09', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-10', '09:10:00', '17:10:00', 'Llegada con retraso'),
(4, 'Completado', '2025-04-11', '09:05:00', '17:05:00', 'Día normal'),
(4, 'Completado', '2025-04-14', '09:00:00', '17:20:00', 'Horas extra'),
(4, 'Completado', '2025-04-15', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-16', '08:55:00', '17:05:00', 'Día normal'),
(4, 'Completado', '2025-04-17', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(4, 'Completado', '2025-04-21', '09:20:00', '17:20:00', 'Llegada con retraso'),
(4, 'Completado', '2025-04-22', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-23', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-24', '09:05:00', '17:05:00', 'Día normal'),
(4, 'Completado', '2025-04-25', '09:00:00', '17:15:00', 'Horas extra'),
(4, 'Completado', '2025-04-28', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-29', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-04-30', '09:10:00', '17:10:00', 'Llegada con retraso');

-- Empleado 5 (Laura Fernández - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(5, 'Completado', '2025-04-01', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-02', '09:05:00', '13:05:00', 'Día normal'),
(5, 'Completado', '2025-04-03', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-04', '09:10:00', '13:10:00', 'Llegada con retraso'),
(5, 'Completado', '2025-04-07', '09:00:00', '13:30:00', 'Horas extra'),
(5, 'Completado', '2025-04-08', '08:50:00', '13:00:00', 'Día normal'),
(5, 'Falta', '2025-04-09', NULL, NULL, 'Enfermedad'),
(5, 'Falta', '2025-04-10', NULL, NULL, 'Enfermedad'),
(5, 'Completado', '2025-04-11', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-14', '09:05:00', '13:05:00', 'Día normal'),
(5, 'Completado', '2025-04-15', '09:00:00', '13:20:00', 'Horas extra'),
(5, 'Completado', '2025-04-16', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-17', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(5, 'Completado', '2025-04-21', '09:15:00', '13:15:00', 'Llegada con retraso'),
(5, 'Completado', '2025-04-22', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-23', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-24', '09:05:00', '13:05:00', 'Día normal'),
(5, 'Completado', '2025-04-25', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-28', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-04-29', '09:10:00', '13:10:00', 'Llegada con retraso'),
(5, 'Completado', '2025-04-30', '09:00:00', '13:30:00', 'Horas extra');

-- Empleado 10 (David Torres - Horario Fin de Semana)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(10, 'Completado', '2025-04-05', '10:00:00', '18:00:00', 'Día normal'),
(10, 'Completado', '2025-04-06', '10:05:00', '18:05:00', 'Día normal'),
(10, 'Completado', '2025-04-12', '10:00:00', '18:00:00', 'Día normal'),
(10, 'Completado', '2025-04-13', '10:10:00', '18:10:00', 'Llegada con retraso'),
(10, 'Completado', '2025-04-19', '10:00:00', '18:30:00', 'Horas extra'),
(10, 'Completado', '2025-04-20', '10:00:00', '18:00:00', 'Día normal'),
(10, 'Completado', '2025-04-26', '10:05:00', '18:05:00', 'Día normal'),
(10, 'Completado', '2025-04-27', '10:00:00', '18:00:00', 'Día normal');

-- Registros para Mayo 2025 (hasta el 9 de Mayo - fecha actual simulada)
-- Empleado 2 (Usuario Empleado)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(2, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(2, 'Completado', '2025-05-02', '09:00:00', '17:00:00', 'Día normal'),
(2, 'Completado', '2025-05-05', '08:55:00', '17:05:00', 'Día normal'),
(2, 'Completado', '2025-05-06', '09:01:00', '17:02:00', 'Trabajo normal'),
(2, 'Pendiente', '2025-05-07', NULL, NULL, NULL),
(2, 'Completado', '2025-05-08', '09:05:00', '17:05:00', 'Día normal'),
(2, 'Pendiente', '2025-05-09', '09:00:00', NULL, 'En curso');

-- Empleado 3 (María García)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(3, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(3, 'Completado', '2025-05-02', '09:05:00', '17:05:00', 'Día normal'),
(3, 'Completado', '2025-05-05', '09:00:00', '17:15:00', 'Horas extra'),
(3, 'Completado', '2025-05-06', '09:10:00', '17:10:00', 'Llegada con retraso'),
(3, 'Completado', '2025-05-07', '09:00:00', '17:00:00', 'Día normal'),
(3, 'Completado', '2025-05-08', '09:00:00', '17:30:00', 'Horas extra'),
(3, 'Pendiente', '2025-05-09', '09:05:00', NULL, 'En curso');

-- Empleado 4 (Carlos Rodríguez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(4, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(4, 'Completado', '2025-05-02', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Completado', '2025-05-05', '09:05:00', '17:05:00', 'Día normal'),
(4, 'Completado', '2025-05-06', '09:00:00', '17:20:00', 'Horas extra'),
(4, 'Completado', '2025-05-07', '09:15:00', '17:15:00', 'Llegada con retraso'),
(4, 'Completado', '2025-05-08', '09:00:00', '17:00:00', 'Día normal'),
(4, 'Pendiente', '2025-05-09', '09:10:00', NULL, 'En curso');

-- Empleado 5 (Laura Fernández - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(5, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(5, 'Completado', '2025-05-02', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-05-05', '09:10:00', '13:10:00', 'Llegada con retraso'),
(5, 'Completado', '2025-05-06', '09:00:00', '13:30:00', 'Horas extra'),
(5, 'Completado', '2025-05-07', '09:00:00', '13:00:00', 'Día normal'),
(5, 'Completado', '2025-05-08', '09:05:00', '13:05:00', 'Día normal'),
(5, 'Pendiente', '2025-05-09', '09:00:00', NULL, 'En curso');

-- Empleado 10 (David Torres - Horario Fin de Semana)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(10, 'Completado', '2025-05-03', '10:10:00', '18:10:00', 'Llegada con retraso'),
(10, 'Completado', '2025-05-04', '10:00:00', '18:20:00', 'Horas extra');

-- Más registros para otros empleados en Mayo 2025
-- Empleado 6 (Javier Martínez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(6, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(6, 'Completado', '2025-05-02', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-05-05', '08:50:00', '17:10:00', 'Día normal'),
(6, 'Completado', '2025-05-06', '09:05:00', '17:05:00', 'Día normal'),
(6, 'Completado', '2025-05-07', '09:00:00', '17:20:00', 'Horas extra'),
(6, 'Completado', '2025-05-08', '09:10:00', '17:10:00', 'Llegada con retraso'),
(6, 'Completado', '2025-04-19', '09:00:00', '17:20:00', 'Cubrir Baja'),
(6, 'Pendiente', '2025-05-09', '09:00:00', NULL, 'En curso');

-- Empleado 7 (Ana López - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(7, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(7, 'Completado', '2025-05-02', '09:10:00', '13:10:00', 'Llegada con retraso'),
(7, 'Completado', '2025-05-05', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-05-06', '09:00:00', '13:15:00', 'Horas extra'),
(7, 'Completado', '2025-05-07', '09:05:00', '13:05:00', 'Día normal'),
(7, 'Completado', '2025-05-08', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Pendiente', '2025-05-09', '09:05:00', NULL, 'En curso');

-- Empleado 8 (Miguel Sánchez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(8, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(8, 'Completado', '2025-05-02', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-05-05', '08:55:00', '17:30:00', 'Horas extra'),
(8, 'Completado', '2025-05-06', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-05-07', '09:10:00', '17:10:00', 'Llegada con retraso'),
(8, 'Falta', '2025-05-08', NULL, NULL, 'Permiso personal'),
(8, 'Pendiente', '2025-05-09', '09:05:00', NULL, 'En curso');

-- Empleado 9 (Elena Gómez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(9, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(9, 'Completado', '2025-05-02', '09:05:00', '17:05:00', 'Día normal'),
(9, 'Completado', '2025-05-05', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-05-06', '09:15:00', '17:15:00', 'Llegada con retraso'),
(9, 'Completado', '2025-05-07', '09:00:00', '17:20:00', 'Horas extra'),
(9, 'Completado', '2025-05-08', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Pendiente', '2025-05-09', '09:00:00', NULL, 'En curso');

-- Empleado 11 (Patricia Navarro - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(11, 'Falta', '2025-05-01', NULL, NULL, 'Festivo: Día del Trabajo'),
(11, 'Completado', '2025-05-02', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-05-05', '09:10:00', '13:10:00', 'Llegada con retraso'),
(11, 'Completado', '2025-05-06', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-05-07', '09:05:00', '13:05:00', 'Día normal'),
(11, 'Completado', '2025-05-08', '09:00:00', '13:30:00', 'Horas extra'),
(11, 'Pendiente', '2025-05-09', '09:00:00', NULL, 'En curso');

-- Empleado 12 (Roberto Jiménez - Horario Fin de Semana)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(12, 'Completado', '2025-05-03', '10:00:00', '18:00:00', 'Día normal'),
(12, 'Completado', '2025-05-04', '10:05:00', '18:05:00', 'Día normal');

-- Ahora vamos a añadir registros históricos para abril para los demás empleados que faltaban

-- Empleado 6 (Javier Martínez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(6, 'Completado', '2025-04-01', '09:00:00', '17:10:00', 'Horas extra'),
(6, 'Completado', '2025-04-02', '09:05:00', '17:05:00', 'Día normal'),
(6, 'Completado', '2025-04-03', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-04', '09:15:00', '17:15:00', 'Llegada con retraso'),
(6, 'Completado', '2025-04-07', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-08', '08:50:00', '17:10:00', 'Día normal'),
(6, 'Completado', '2025-04-09', '09:00:00', '17:20:00', 'Horas extra'),
(6, 'Completado', '2025-04-10', '09:05:00', '17:05:00', 'Día normal'),
(6, 'Completado', '2025-04-11', '09:00:00', '16:30:00', 'Salida anticipada autorizada'),
(6, 'Completado', '2025-04-14', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-15', '09:10:00', '17:10:00', 'Llegada con retraso'),
(6, 'Completado', '2025-04-16', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-17', '09:00:00', '17:30:00', 'Horas extra'),
(6, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(6, 'Completado', '2025-04-21', '09:05:00', '17:05:00', 'Día normal'),
(6, 'Completado', '2025-04-22', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-23', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-24', '09:15:00', '17:15:00', 'Llegada con retraso'),
(6, 'Completado', '2025-04-25', '09:00:00', '17:20:00', 'Horas extra'),
(6, 'Completado', '2025-04-28', '09:00:00', '17:00:00', 'Día normal'),
(6, 'Completado', '2025-04-29', '09:05:00', '17:05:00', 'Día normal'),
(6, 'Completado', '2025-04-30', '09:00:00', '17:10:00', 'Horas extra');

-- Empleado 7 (Ana López - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(7, 'Completado', '2025-04-01', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-02', '09:10:00', '13:10:00', 'Llegada con retraso'),
(7, 'Completado', '2025-04-03', '09:00:00', '13:20:00', 'Horas extra'),
(7, 'Completado', '2025-04-04', '09:05:00', '13:05:00', 'Día normal'),
(7, 'Completado', '2025-04-07', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-08', '09:00:00', '13:15:00', 'Horas extra'),
(7, 'Completado', '2025-04-09', '09:10:00', '13:10:00', 'Llegada con retraso'),
(7, 'Completado', '2025-04-10', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-11', '09:05:00', '13:05:00', 'Día normal'),
(7, 'Falta', '2025-04-14', NULL, NULL, 'Enfermedad'),
(7, 'Falta', '2025-04-15', NULL, NULL, 'Enfermedad'),
(7, 'Completado', '2025-04-16', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-17', '09:00:00', '13:30:00', 'Horas extra'),
(7, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(7, 'Completado', '2025-04-21', '09:10:00', '13:10:00', 'Llegada con retraso'),
(7, 'Completado', '2025-04-22', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-23', '09:05:00', '13:05:00', 'Día normal'),
(7, 'Completado', '2025-04-24', '09:00:00', '13:20:00', 'Horas extra'),
(7, 'Completado', '2025-04-25', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-28', '09:15:00', '13:15:00', 'Llegada con retraso'),
(7, 'Completado', '2025-04-29', '09:00:00', '13:00:00', 'Día normal'),
(7, 'Completado', '2025-04-30', '09:00:00', '13:10:00', 'Horas extra');

-- Empleado 8 (Miguel Sánchez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(8, 'Completado', '2025-04-01', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-02', '09:05:00', '17:25:00', 'Horas extra'),
(8, 'Completado', '2025-04-03', '09:10:00', '17:10:00', 'Llegada con retraso'),
(8, 'Completado', '2025-04-04', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-07', '09:00:00', '17:15:00', 'Horas extra'),
(8, 'Completado', '2025-04-08', '09:05:00', '17:05:00', 'Día normal'),
(8, 'Completado', '2025-04-09', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-10', '08:50:00', '17:10:00', 'Día normal'),
(8, 'Completado', '2025-04-11', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-14', '09:15:00', '17:15:00', 'Llegada con retraso'),
(8, 'Completado', '2025-04-15', '09:00:00', '17:30:00', 'Horas extra'),
(8, 'Completado', '2025-04-16', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-17', '09:05:00', '17:05:00', 'Día normal'),
(8, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(8, 'Completado', '2025-04-21', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Falta', '2025-04-22', NULL, NULL, 'Permiso personal'),
(8, 'Falta', '2025-04-23', NULL, NULL, 'Permiso personal'),
(8, 'Completado', '2025-04-24', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-25', '09:10:00', '17:10:00', 'Llegada con retraso'),
(8, 'Completado', '2025-04-28', '09:00:00', '17:20:00', 'Horas extra'),
(8, 'Completado', '2025-04-29', '09:00:00', '17:00:00', 'Día normal'),
(8, 'Completado', '2025-04-30', '09:05:00', '17:05:00', 'Día normal');

-- Empleado 9 (Elena Gómez)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(9, 'Completado', '2025-04-01', '09:10:00', '17:10:00', 'Llegada con retraso'),
(9, 'Completado', '2025-04-02', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-03', '09:00:00', '17:30:00', 'Horas extra'),
(9, 'Completado', '2025-04-04', '09:05:00', '17:05:00', 'Día normal'),
(9, 'Completado', '2025-04-07', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-08', '09:15:00', '17:15:00', 'Llegada con retraso'),
(9, 'Completado', '2025-04-09', '09:00:00', '17:20:00', 'Horas extra'),
(9, 'Completado', '2025-04-10', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-11', '09:05:00', '17:05:00', 'Día normal'),
(9, 'Completado', '2025-04-14', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-15', '09:00:00', '17:30:00', 'Horas extra'),
(9, 'Completado', '2025-04-16', '09:10:00', '17:10:00', 'Llegada con retraso'),
(9, 'Completado', '2025-04-17', '09:05:00', '17:05:00', 'Día normal'),
(9, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(9, 'Completado', '2025-04-21', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-22', '09:00:00', '17:15:00', 'Horas extra'),
(9, 'Completado', '2025-04-23', '09:05:00', '17:05:00', 'Día normal'),
(9, 'Completado', '2025-04-24', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-25', '09:15:00', '17:15:00', 'Llegada con retraso'),
(9, 'Completado', '2025-04-28', '09:00:00', '17:30:00', 'Horas extra'),
(9, 'Completado', '2025-04-29', '09:00:00', '17:00:00', 'Día normal'),
(9, 'Completado', '2025-04-30', '09:05:00', '17:05:00', 'Día normal');

-- Empleado 11 (Patricia Navarro - Media Jornada)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(11, 'Completado', '2025-04-01', '09:05:00', '13:05:00', 'Día normal'),
(11, 'Completado', '2025-04-02', '09:00:00', '13:20:00', 'Horas extra'),
(11, 'Completado', '2025-04-03', '09:10:00', '13:10:00', 'Llegada con retraso'),
(11, 'Completado', '2025-04-04', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-07', '09:05:00', '13:05:00', 'Día normal'),
(11, 'Completado', '2025-04-08', '09:00:00', '13:15:00', 'Horas extra'),
(11, 'Completado', '2025-04-09', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-10', '09:15:00', '13:15:00', 'Llegada con retraso'),
(11, 'Completado', '2025-04-11', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-14', '09:00:00', '13:20:00', 'Horas extra'),
(11, 'Completado', '2025-04-15', '09:05:00', '13:05:00', 'Día normal'),
(11, 'Completado', '2025-04-16', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-17', '09:10:00', '13:10:00', 'Llegada con retraso'),
(11, 'Falta', '2025-04-18', NULL, NULL, 'Festivo: Viernes Santo'),
(11, 'Completado', '2025-04-21', '09:00:00', '13:30:00', 'Horas extra'),
(11, 'Completado', '2025-04-22', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-23', '09:05:00', '13:05:00', 'Día normal'),
(11, 'Completado', '2025-04-24', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-25', '09:15:00', '13:15:00', 'Llegada con retraso'),
(11, 'Completado', '2025-04-28', '09:00:00', '13:00:00', 'Día normal'),
(11, 'Completado', '2025-04-29', '09:00:00', '13:25:00', 'Horas extra'),
(11, 'Completado', '2025-04-30', '09:05:00', '13:05:00', 'Día normal');

-- Empleado 12 (Roberto Jiménez - Horario Fin de Semana)
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES
(12, 'Completado', '2025-04-05', '10:10:00', '18:10:00', 'Llegada con retraso'),
(12, 'Completado', '2025-04-06', '10:00:00', '18:30:00', 'Horas extra'),
(12, 'Completado', '2025-04-12', '10:00:00', '18:00:00', 'Día normal'),
(12, 'Completado', '2025-04-13', '10:05:00', '18:05:00', 'Día normal'),
(12, 'Completado', '2025-04-19', '10:15:00', '18:15:00', 'Llegada con retraso'),
(12, 'Completado', '2025-04-20', '10:00:00', '18:20:00', 'Horas extra'),
(12, 'Completado', '2025-04-26', '10:00:00', '18:00:00', 'Día normal'),
(12, 'Completado', '2025-04-27', '10:05:00', '18:05:00', 'Día normal');