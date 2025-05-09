
CREATE DATABASE BaseDatosAttendifySencilla;
USE BaseDatosAttendifySencilla;

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

-- Insertar un horario general
INSERT INTO Horario (nombreHorario, horasMaxSemanales) VALUES 
('Horario General', 40);

-- Asociar días laborales con el horario
INSERT INTO Horario_DiaTrabajo (idHorario, idDia, horaEntrada, horaSalida, tiempoDescanso)
VALUES 
(1, 1, '09:00:00', '17:00:00', 60), -- Lunes
(1, 2, '09:00:00', '17:00:00', 60), -- Martes
(1, 3, '09:00:00', '17:00:00', 60), -- Miércoles
(1, 4, '09:00:00', '17:00:00', 60), -- Jueves
(1, 5, '09:00:00', '17:00:00', 60); -- Viernes

-- Insertar empleados
INSERT INTO Empleado (nombre, apellidos, dni, idHorario, telefono, email, puesto)
VALUES 
('Admin', 'Principal', '00000000A', 1, '600000000', 'admin@empresa.com', 'Gerente'),
('Usuario', 'Empleado', '00000001B', 1, '600000001', 'usuario@empresa.com', 'Operario');

-- Insertar usuarios
INSERT INTO Usuario (idEmpleado, username, password, rol)
VALUES 
(1, 'admin', 'admin', 'Administrador'),
(2, 'usuario', 'usuario', 'Empleado');

-- Insertar días festivos de ejemplo
INSERT INTO DiaFestivo (fecha, nombre)
VALUES 
('2025-01-01', 'Año Nuevo'),
('2025-12-25', 'Navidad');

-- Insertar vacaciones de ejemplo
INSERT INTO Vacaciones (idEmpleado, fechaInicio, fechaFin, descripcion)
VALUES 
(2, '2025-08-01', '2025-08-15', 'Vacaciones de verano');

-- Insertar registros de jornada
INSERT INTO Registro (idEmpleado, estado, fecha, horaEntrada, horaSalida, comentarios)
VALUES 
(2, 'Completado', '2025-05-06', '09:01:00', '17:02:00', 'Trabajo normal'),
(2, 'Pendiente', '2025-05-07', NULL, NULL, NULL);

