DROP DATABASE biblioteca;

CREATE DATABASE biblioteca;

\c biblioteca

CREATE TABLE socio (
    rut VARCHAR (15) PRIMARY KEY,
    nombre_socio VARCHAR (20),
    apellido_socio VARCHAR(20),
    direccion_socio VARCHAR (20),
    telefono INT
);

CREATE TABLE libro (
    isbn VARCHAR (18) PRIMARY KEY,
    titulo VARCHAR (30),
    paginas INT,
    dias_prestamo INT
);

CREATE TABLE autor (
    codigo SERIAL PRIMARY KEY,
    nombre_autor VARCHAR(30),
    apellido_autor VARCHAR(30),
    nacimiento INT,
    deceso INT
);

CREATE TABLE cargo (
    id SERIAL PRIMARY KEY,
    tipo_autor VARCHAR (10)
);

CREATE TABLE autor_libro (
    isbn_libro VARCHAR(18),
    cod_autor INT, 
    id_cargo INT,
    FOREIGN KEY (id_cargo) REFERENCES cargo(id),
    FOREIGN KEY (cod_autor) REFERENCES autor(codigo),
    FOREIGN KEY (isbn_libro) REFERENCES libro(isbn)
);

CREATE TABLE prestamo (
    rut_socio VARCHAR(15), 
    libro_isbn VARCHAR(18),
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY (rut_socio) REFERENCES socio(rut),
    FOREIGN KEY (libro_isbn) REFERENCES libro(isbn)
);

\copy socio FROM 'socio.csv' csv header;
\copy libro FROM 'libro.csv' csv header;
\copy autor FROM 'autor.csv' NULL AS 'null' csv header;
\copy cargo FROM 'cargo.csv' csv header;
\copy autor_libro FROM 'autor_libro.csv' csv header;
\copy prestamo FROM 'prestamo.csv' csv header;



SELECT * FROM socio;
SELECT * FROM libro;
SELECT * FROM autor;
SELECT * FROM cargo;
SELECT * FROM autor_libro;
SELECT * FROM prestamo;


--a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT * FROM libro WHERE paginas < 300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970.
SELECT * FROM autor WHERE nacimiento > 1970;
--c. ¿Cuál es el libro más solicitado?
SELECT count(prestamo.libro_isbn), libro.titulo FROM prestamo INNER JOIN libro ON prestamo.libro_isbn = libro.isbn
GROUP BY libro.titulo LIMIT 1;
--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto
-- debería pagar cada usuario que entregue el préstamo después de 7 días
SELECT prestamo.rut_socio, (((prestamo.fecha_devolucion - prestamo.fecha_prestamo)-7)*100) AS multa FROM prestamo 
WHERE (prestamo.fecha_devolucion - prestamo.fecha_prestamo) > 7;