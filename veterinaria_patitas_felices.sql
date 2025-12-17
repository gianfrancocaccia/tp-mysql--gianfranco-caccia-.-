--Creacion base de datos--
CREATE DATABASE Veterinaria_patitas_felices;

USE Veterinaria_patitas_felices;

--Creacion tabla duenos--

CREATE TABLE duenos (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  telefono VARCHAR (20) NOT NULL,
  direccion VARCHAR(100)
  )

  --CREACION TABLA MASCOTAS--

 CREATE TABLE mascotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    fecha_nacimiento DATE,
    id_dueno INT,
    FOREIGN KEY (id_dueno) REFERENCES duenos(id)
);

  --CREACION TABLA VETERINARIOS--

  CREATE TABLE veterinarios (
    id INT AUTO_INCREMENT PRIMARY KEY ,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    matricula VARCHAR(20) NOT NULL UNIQUE,
    especialidad VARCHAR(50) NOT NULL
  );

  --CREACION TABLA HISTORIAL_CLINICO--

 CREATE TABLE historial_clinico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_mascota INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id),
    id_veterinario INT,
    FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id),
    fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(250) NOT NULL
);


  -- INSERTAR REGISTROS -- --3 DUENOS CON INFORMACION COMPLETA-- --3 MASCOTAS, CADA UNA ASOCIADA A UN DUENO-- --2 VETERINARIOS CON ESPECIALIDADES DISTINTAS-- --3 REGISTROS DE HISTORIAL CLINICO--

INSERT INTO duenos (nombre, apellido, telefono, direccion)
VALUES ('Carlos', 'Gomez', '011 3456 7890', 'Av. 9 de Julio 109'),
('Brian', 'Moreno', '011 9854 8856', 'Andes 6940'),
('Tomas', 'Martin', '011 8747 4747', 'La Plata 167');

INSERT INTO mascotas (nombre, especie, fecha_nacimiento, id_dueno)
VALUES ('Michi', 'Gato', '2020-05-10', 1),
('Firulais', 'Perro', '2017-02-03', 2),
('Lolo', 'Conejo', '2021-08-12', 3);

INSERT INTO veterinarios (nombre, apellido, matricula, especialidad)
VALUES('Camila', 'Gonzalez', 'MAT-123', 'Clinica General'),
('Camila','Castro','432', 'Cirugia');

INSERT INTO historial_clinico (id_mascota, id_veterinario, descripcion)
VALUES(1, 2, 'Consulta problema digestivo, heces.'),
(2, 1, 'Consulta nauseas, vomitos.'),
(3, 1, 'Consulta dermatitis, sangrado.');


--ACTUALIZAR REGISTROS-- --CAMBIAR DIRECCION DE UN DUENO (POR ID O NOMBRE)-- --ACTUALIZAR LA ESPECIALIDAD DE UN VETERINARIO (POR ID O MATRICULA)-- --EDITAR LA DESCRIPCION DE UN HISTORIAL CLINICO (POR ID)--


UPDATE duenos 
SET direccion = 'Nueva Direccion 123'
WHERE nombre = 'Carlos' AND apellido = 'Gomez';

UPDATE veterinarios
SET especialidad = 'Clinica General'
WHERE id = 2;

UPDATE historial_clinico 
SET descripcion = 'Consulta por problemas respiratorios'
WHERE id = 1;




--Eliminar registros-- --Eliminar una mascota (por ID o nombre) -- --Verificar que se eliminen automaticamente los registros del historial clinico asociados (ON DELETE CASCADE) --




--Borrado y recreado de fk-- --agregar on delete cascade--
ALTER TABLE historial_clinico
DROP FOREIGN KEY historial_clinico_ibfk_1;


ALTER TABLE historial_clinico
ADD CONSTRAINT fk_historial_mascota
FOREIGN KEY (id_mascota)
REFERENCES mascotas(id)
ON DELETE CASCADE;

--eliminando mascota por id--
DELETE FROM mascotas 
WHERE id = 1;



--JOIN SIMPLE MASCOTAS CON SUS DUENOS--

SELECT
m.nombre AS mascota, 
m.especie,
CONCAT(d.nombre,' ',d.apellido) AS dueno
FROM mascotas m 
JOIN duenos d ON m.id_dueno = d.id;


--JOIN MULTIPLE CON HISTORIAL -- 

SELECT
m.nombre AS mascota,
m.especie, 
CONCAT(d.nombre, ' ', d.apellido) AS dueno,
CONCAT(v.nombre, ' ', v.apellido) AS veterinario,
hc.fecha_registro,
hc.descripcion
FROM historial_clinico hc
JOIN mascotas m ON hc.id_mascota = m.id
JOIN duenos d ON m.id_dueno = d.id
JOIN veterinarios v ON hc.id_veterinario = v.id
ORDER BY hc.fecha_registro DESC;