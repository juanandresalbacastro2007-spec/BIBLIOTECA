-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-03-2026 a las 16:23:08
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `biblioteca_juan`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_contacto_socio` (IN `numero` INT, IN `nueva_direccion` VARCHAR(255), IN `nuevo_telefono` VARCHAR(10))   BEGIN
    UPDATE socio 
    SET direccion = nueva_direccion, 
        telefono = nuevo_telefono
    WHERE numero = numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_datos_socio` (IN `p_numero` INT, IN `p_direccion` VARCHAR(255), IN `p_telefono` VARCHAR(10))   BEGIN
    UPDATE socio
    SET 
        Direccion = p_direccion,
        Telefono = p_telefono
    WHERE Numero = p_numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_libro_por_nombre` (IN `nombreLibro` VARCHAR(255))   BEGIN
    SELECT *
    FROM libro
    WHERE Titulo LIKE CONCAT('%', nombreLibro, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eliminar_libro` (IN `p_isbn` BIGINT)   BEGIN
    IF EXISTS (SELECT 1 FROM prestamo WHERE copiaISBN = p_isbn)
       OR EXISTS (SELECT 1 FROM tipoautores WHERE copiaISBN = p_isbn) THEN
       
        SELECT 'No se puede eliminar, tiene dependencias' AS mensaje;
        
    ELSE
        DELETE FROM libro WHERE isbn = p_isbn;
        SELECT 'Libro eliminado correctamente' AS mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_listaAutores` ()   SELECT aut_codigo, aut_apellido
FROM tbl_autor
ORDER BY aut_apellido DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tipoAutor` (`variable` VARCHAR(20))   SELECT aut_apellido AS 'Autor', tipoAutor
FROM tbl_autor
INNER JOIN tbl_tipoautores
ON aut_codigo = copiaAutor
WHERE tipoAutor = variable$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_libros_en_prestamo` ()   BEGIN
    SELECT 
        l.isbn,
        l.Titulo,
        p.fechaPrestamo,
        p.fechaDevolucion,
        s.Numero AS NumeroSocio,
        s.Nombre,
        s.Apellido
    FROM prestamo p
    INNER JOIN libro l 
        ON p.copiaISBN = l.isbn
    INNER JOIN socio s 
        ON p.copiaNumero = s.Numero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `listar_socios_y_prestamos` ()   BEGIN
    SELECT 
        s.numero,
        s.nombre,
        s.apellido,
        p.id,
        p.fechaPrestamo,
        p.copiaISBN
    FROM socio s
    LEFT JOIN prestamo p 
        ON s.numero = p.copiaNumero;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `contar_socios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM socio;

    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `contar_total_socios` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total 
    FROM socio;

    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `dias_en_prestamo` (`p_isbn` BIGINT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE dias INT;

    SELECT DATEDIFF(
            IFNULL(fechaDevolucion, CURDATE()),
            fechaPrestamo
           )
    INTO dias
    FROM prestamo
    WHERE copiaISBN = p_isbn
    LIMIT 1;

    RETURN dias;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `apellido_telefono`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `apellido_telefono` (
`Apellido` varchar(45)
,`Telefono` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_autor`
--

CREATE TABLE `audi_autor` (
  `audi_id` int(11) NOT NULL,
  `autor_codigo` bigint(20) DEFAULT NULL,
  `audi_apellido` varchar(45) DEFAULT NULL,
  `audi_nacimiento` date DEFAULT NULL,
  `audi_muerte` date DEFAULT NULL,
  `fecha_modificacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_autor`
--

INSERT INTO `audi_autor` (`audi_id`, `autor_codigo`, `audi_apellido`, `audi_nacimiento`, `audi_muerte`, `fecha_modificacion`) VALUES
(1, 999, 'Autor Temporal', '1990-01-01', NULL, '2026-03-09 09:26:45'),
(2, 999, 'pedro montria', '1990-01-01', NULL, '2026-03-09 09:29:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_libro`
--

CREATE TABLE `audi_libro` (
  `audi_isbn` bigint(20) NOT NULL,
  `audi_genero` varchar(20) DEFAULT NULL,
  `audi_titulo` varchar(255) DEFAULT NULL,
  `audi_diasPrestamo` tinyint(4) DEFAULT NULL,
  `audi_numeroPaginas` int(11) DEFAULT NULL,
  `fecha_registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_libro`
--

INSERT INTO `audi_libro` (`audi_isbn`, `audi_genero`, `audi_titulo`, `audi_diasPrestamo`, `audi_numeroPaginas`, `fecha_registro`) VALUES
(2147483647, 'Fantasía', 'Las Crónicas de SQL', 15, 350, '2026-03-05 09:53:58'),
(2718281828, 'novela', 'las cronicas del santi ', 2, 387, '2026-03-05 10:23:50'),
(5555555555, 'ELIMINADO', 'La Última Llave del Destino', NULL, NULL, '2026-03-05 10:41:38');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `audi_socio`
--

CREATE TABLE `audi_socio` (
  `id_audi` int(10) NOT NULL,
  `Numero_audi` int(11) DEFAULT NULL,
  `Nombre_anterior` varchar(45) DEFAULT NULL,
  `Apellido_anterior` varchar(45) DEFAULT NULL,
  `Direccion_anterior` varchar(255) DEFAULT NULL,
  `Telefono_anterior` varchar(10) DEFAULT NULL,
  `Nombre_nuevo` varchar(45) DEFAULT NULL,
  `Apellido_nuevo` varchar(45) DEFAULT NULL,
  `Direccion_nuevo` varchar(255) DEFAULT NULL,
  `Telefono_nuevo` varchar(10) DEFAULT NULL,
  `audi_fechaModificacion` datetime DEFAULT NULL,
  `audi_usuario` varchar(10) DEFAULT NULL,
  `audi_accion` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `audi_socio`
--

INSERT INTO `audi_socio` (`id_audi`, `Numero_audi`, `Nombre_anterior`, `Apellido_anterior`, `Direccion_anterior`, `Telefono_anterior`, `Nombre_nuevo`, `Apellido_nuevo`, `Direccion_nuevo`, `Telefono_nuevo`, `audi_fechaModificacion`, `audi_usuario`, `audi_accion`) VALUES
(1, 14, 'cristiano', 'ronaldo', 'medio oriente avenida ', '3001234569', 'cristiano', 'ronaldo', 'medio oriente avenida', '3001234569', '2026-03-05 08:00:02', 'root@local', 'Actualización'),
(2, 14, 'cristiano', 'ronaldo', 'medio oriente avenida', '3001234569', 'cristiano', 'ronaldo', 'medio oriente avenida al nassr', '3001234569', '2026-03-05 08:01:14', 'root@local', 'Actualización');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autor`
--

CREATE TABLE `autor` (
  `Codigo` int(11) NOT NULL,
  `Apellido` varchar(45) NOT NULL,
  `Nacimiento` date NOT NULL,
  `Muerte` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `autor`
--

INSERT INTO `autor` (`Codigo`, `Apellido`, `Nacimiento`, `Muerte`) VALUES
(98, 'García pedri', '1974-12-21', '2018-07-21'),
(123, 'Taylor', '1980-04-15', NULL),
(234, 'Medina', '1977-06-21', '2005-09-12'),
(345, 'Wilson', '1975-08-29', NULL),
(432, 'Miller', '1981-10-26', NULL),
(456, 'García', '1978-09-27', '2021-12-09'),
(567, 'Davis', '1983-03-04', '2010-03-28'),
(678, 'Silva', '1986-02-02', NULL),
(765, 'López', '1976-07-08', '2018-02-16'),
(777, 'vasquez', '1980-04-17', '1910-03-28'),
(789, 'Rodríguez', '1985-12-10', NULL),
(890, 'Brown', '1982-11-17', NULL),
(901, 'Soto', '1979-05-13', '2015-11-05');

--
-- Disparadores `autor`
--
DELIMITER $$
CREATE TRIGGER `audi_actualizar_autor` BEFORE UPDATE ON `autor` FOR EACH ROW BEGIN
    INSERT INTO audi_autor (
        autor_codigo,        
        audi_apellido,       
        audi_nacimiento,     
        audi_muerte,         
        fecha_modificacion   
    )
    VALUES (
        NEW.Codigo,          
        NEW.Apellido,        
        NEW.Nacimiento,     
        NEW.Muerte,          
        NOW()
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `audi_eliminar_autor` AFTER DELETE ON `autor` FOR EACH ROW BEGIN
    INSERT INTO audi_autor (
        autor_codigo,
        audi_apellido,
        audi_nacimiento,
        audi_muerte,
        fecha_modificacion
    )
    VALUES (
        OLD.Codigo,
        OLD.Apellido,
        OLD.Nacimiento,
        OLD.Muerte,    -- Aquí ya NO hay coma porque el siguiente es el último valor
        NOW()          -- Último valor, sin coma al final
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `Isbn` bigint(20) NOT NULL,
  `Titulo` varchar(255) NOT NULL,
  `Genero` varchar(20) NOT NULL,
  `NumeroPaginas` int(11) NOT NULL,
  `DiasPrestamo` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `libro`
--

INSERT INTO `libro` (`Isbn`, `Titulo`, `Genero`, `NumeroPaginas`, `DiasPrestamo`) VALUES
(1234567890, 'El Sueño de los Susurros', 'novela', 275, 7),
(1357924680, 'El Jardín de las Mariposas Perdidas', 'novela', 536, 7),
(2468135790, 'La Melodía de la Oscuridad', 'romance', 189, 7),
(2718281828, 'las cronicas del santi ', 'novela', 387, 2),
(3141592653, 'El Secreto de las Estrellas Olvidadas', 'Misterio', 203, 7),
(7777777777, 'El Misterio de la Luna Plateada', 'Misterio', 422, 7),
(8642097531, 'El Reloj de Arena Infinito', 'novela', 321, 7),
(8888888888, 'La Ciudad de los Susurros', 'Misterio', 274, 1),
(9517530862, 'Las Crónicas del Eco Silencioso', 'fantasía', 448, 7),
(9876543210, 'El Laberinto de los Recuerdos', 'cuento', 412, 7),
(9998887776, 'Las Crónicas de SQL', 'Fantasía', 350, 15),
(9999999999, 'El Enigma de los Espejos Rotos', 'romance', 156, 7);

--
-- Disparadores `libro`
--
DELIMITER $$
CREATE TRIGGER `DELETE_libro` AFTER DELETE ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (
        audi_isbn, 
        audi_titulo, 
        fecha_registro,
        audi_genero 
    ) 
    VALUES (
        OLD.Isbn,     
        OLD.Titulo, 
        NOW(),
        'ELIMINADO' 
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auditoria_li` AFTER INSERT ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (
        isbn,
        titulo,
        genero,
        paginas,
        diasPrestamo,
        audi_fecha,
        audi_usuario,
        audi_accion
    )
    VALUES (
        NEW.isbn,
        NEW.titulo,
        NEW.genero,
        NEW.numeroPaginas, -
        NEW.diasPrestamo,
        NOW(),
        USER(),
        'Insert'
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertar_nuevo_libro` AFTER INSERT ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (
        audi_isbn,
        audi_genero,
        audi_titulo,
        audi_diasPrestamo,
        audi_numeroPaginas,
        fecha_registro 
    )
    VALUES (
        NEW.Isbn,            
        NEW.Genero,          
        NEW.Titulo,          
        NEW.DiasPrestamo,    
        NEW.NumeroPaginas,   
        NOW()                   
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_libros` BEFORE UPDATE ON `libro` FOR EACH ROW BEGIN
    INSERT INTO audi_libro (
        audi_isbn,        
        audi_genero,
        audi_titulo,
        audi_diasPrestamo,
        audi_numeroPaginas,
        fecha_registro
    )
    VALUES (
        NEW.Isbn,         
        NEW.Genero,
        NEW.Titulo,
        NEW.DiasPrestamo,
        NEW.NumeroPaginas,
        NOW()
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestamo`
--

CREATE TABLE `prestamo` (
  `id` varchar(20) NOT NULL,
  `fechaPrestamo` date NOT NULL,
  `fechaDevolucion` date NOT NULL,
  `copiaNumero` int(11) DEFAULT NULL,
  `copiaISBN` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `prestamo`
--

INSERT INTO `prestamo` (`id`, `fechaPrestamo`, `fechaDevolucion`, `copiaNumero`, `copiaISBN`) VALUES
('pres1', '2023-01-15', '2023-01-20', 1, 1234567890),
('pres2', '2023-02-03', '2023-02-04', 2, 9999999999),
('pres3', '2023-04-09', '2023-04-11', 6, 2718281828),
('pres7', '2023-10-24', '2023-10-27', 3, 1357924680),
('pres8', '2023-11-11', '2023-11-12', 4, 9999999999);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `Numero` int(11) NOT NULL,
  `Nombre` varchar(45) NOT NULL,
  `Apellido` varchar(45) NOT NULL,
  `Direccion` varchar(255) NOT NULL,
  `Telefono` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`Numero`, `Nombre`, `Apellido`, `Direccion`, `Telefono`) VALUES
(1, 'Ana', 'Ruiz', 'Calle 10 #25-30', '3001234567'),
(2, 'Andrés Felipe', 'Galindo Luna', 'Avenida del Sol 456, Pueblo Nuevo, Madrid', '2123456789'),
(3, 'Juan', 'González', 'Calle Principal 789, Villa Flores, Valencia', '2012345678'),
(4, 'María', 'Rodríguez', 'Carrera del Río 321, El Pueblo, Sevilla', '3012345678'),
(5, 'Pedro', 'Martínez', 'Calle del Bosque 654, Los Pinos, Málaga', '1234567812'),
(6, 'Ana', 'López', 'Avenida Central 987, Villa Hermosa, Bilbao', '6123456781'),
(7, 'Carlos', 'Sánchez', 'Calle de la Luna 234, El Prado, Alicante', '1123456781'),
(8, 'Laura', 'Ramírez', 'Carrera del Mar 567, Playa Azul, Palma de Mallorca', '1312345678'),
(9, 'Luis', 'Hernández', 'Avenida de la Montaña 890, Monte Verde, Granada', '6101234567'),
(10, 'Andrea', 'García', 'Calle del Sol 432, La Colina, Zaragoza', '1112345678'),
(11, 'Alejandro', 'Torres', 'Carrera del Oeste 765, Ciudad Nueva, Murcia', '4951234567'),
(12, 'Sofia', 'Morales', 'Avenida del Mar 098, Costa Brava, Gijón', '5512345678'),
(13, 'juan', 'almanza', 'calle 22 avenida esperanza', '9123456788'),
(14, 'cristiano', 'ronaldo', 'medio oriente avenida al nassr', '3001234569');

--
-- Disparadores `socio`
--
DELIMITER $$
CREATE TRIGGER `socios_before_update` BEFORE UPDATE ON `socio` FOR EACH ROW INSERT INTO audi_socio(
    Numero_audi,
    Nombre_anterior,
    Apellido_anterior,
    Direccion_anterior,
    Telefono_anterior,
    Nombre_nuevo,
    Apellido_nuevo,
   	Direccion_nuevo,
    Telefono_nuevo,
    audi_fechaModificacion,
    audi_usuario,
    audi_accion)
VALUES(
    new.numero,
    old.nombre,
    old.apellido,
    old.direccion,
    old.telefono,
    new.nombre,
    new.apellido,
    new.direccion,
    new.telefono,
    NOW(),
    CURRENT_USER(),
    'Actualización')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `socioscon_retraso`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `socioscon_retraso` (
`Nombre` varchar(45)
,`Titulo` varchar(255)
,`fechaDevolucion` date
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoautores`
--

CREATE TABLE `tipoautores` (
  `copiaISBN` bigint(20) NOT NULL,
  `copiaAutor` int(11) NOT NULL,
  `tipoAutor` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipoautores`
--

INSERT INTO `tipoautores` (`copiaISBN`, `copiaAutor`, `tipoAutor`) VALUES
(1234567890, 123, 'Autor'),
(1234567890, 456, 'Coautor'),
(1234567890, 890, 'Autor'),
(1357924680, 123, 'Traductor'),
(2468135790, 234, 'Autor'),
(2718281828, 789, 'Traductor'),
(3141592653, 901, 'Autor'),
(7777777777, 765, 'Autor'),
(8642097531, 345, 'Autor'),
(8888888888, 234, 'Autor'),
(8888888888, 345, 'Coautor'),
(9517530862, 432, 'Autor'),
(9876543210, 567, 'Autor'),
(9999999999, 98, 'Autor');

-- --------------------------------------------------------

--
-- Estructura para la vista `apellido_telefono`
--
DROP TABLE IF EXISTS `apellido_telefono`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `apellido_telefono`  AS SELECT `socio`.`Apellido` AS `Apellido`, `socio`.`Telefono` AS `Telefono` FROM `socio` ORDER BY `socio`.`Apellido` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `socioscon_retraso`
--
DROP TABLE IF EXISTS `socioscon_retraso`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `socioscon_retraso`  AS SELECT `s`.`Nombre` AS `Nombre`, `l`.`Titulo` AS `Titulo`, `p`.`fechaDevolucion` AS `fechaDevolucion` FROM ((`prestamo` `p` join `socio` `s`) join `libro` `l`) WHERE `p`.`copiaNumero` = `s`.`Numero` AND `p`.`copiaISBN` = `l`.`Isbn` AND `p`.`fechaDevolucion` < curdate() ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  ADD PRIMARY KEY (`audi_id`);

--
-- Indices de la tabla `audi_libro`
--
ALTER TABLE `audi_libro`
  ADD PRIMARY KEY (`audi_isbn`);

--
-- Indices de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  ADD PRIMARY KEY (`id_audi`);

--
-- Indices de la tabla `autor`
--
ALTER TABLE `autor`
  ADD PRIMARY KEY (`Codigo`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`Isbn`),
  ADD KEY `libros_pretados` (`Titulo`,`DiasPrestamo`);

--
-- Indices de la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `copiaNumero` (`copiaNumero`),
  ADD KEY `prestamo_ibfk_2` (`copiaISBN`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`Numero`);

--
-- Indices de la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD PRIMARY KEY (`copiaISBN`,`copiaAutor`),
  ADD KEY `copiaAutor` (`copiaAutor`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `audi_autor`
--
ALTER TABLE `audi_autor`
  MODIFY `audi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `audi_socio`
--
ALTER TABLE `audi_socio`
  MODIFY `id_audi` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `prestamo`
--
ALTER TABLE `prestamo`
  ADD CONSTRAINT `prestamo_ibfk_1` FOREIGN KEY (`copiaNumero`) REFERENCES `socio` (`Numero`),
  ADD CONSTRAINT `prestamo_ibfk_2` FOREIGN KEY (`copiaISBN`) REFERENCES `libro` (`Isbn`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tipoautores`
--
ALTER TABLE `tipoautores`
  ADD CONSTRAINT `fk_libro_autores` FOREIGN KEY (`copiaISBN`) REFERENCES `libro` (`Isbn`) ON DELETE CASCADE,
  ADD CONSTRAINT `tipoautores_ibfk_2` FOREIGN KEY (`copiaAutor`) REFERENCES `autor` (`Codigo`);

DELIMITER $$
--
-- Eventos
--
CREATE DEFINER=`root`@`localhost` EVENT `anual_eliminar_prestamos` ON SCHEDULE EVERY 1 YEAR STARTS '2026-03-09 09:40:57' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    DELETE FROM prestamo
    WHERE fechaDevolucion <= NOW() - INTERVAL 1 YEAR;
    
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
