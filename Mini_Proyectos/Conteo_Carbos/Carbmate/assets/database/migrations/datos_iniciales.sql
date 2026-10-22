
-- MARCAS
INSERT INTO MARCA (id, nombre, creado_en)
VALUES
  (1, 'Lays', '2026-10-17T11:15:00'),
  (2, 'Best Protein', '2026-10-17T11:15:00'),
  (3, 'Gullón', '2026-10-17T11:15:00'),
  (4, 'Conaprole', '2026-10-17T11:15:00'),
  (5, 'Smams', '2026-10-17T11:15:00'),
  (6, 'Blue Patna', '2026-10-17T11:15:00'),
  (7, 'Nativo', '2026-10-17T11:15:00'),
  (8, 'Sargento García', '2026-10-17T11:15:00'),
  (9, 'Limay', '2026-10-17T11:15:00'),
  (10, 'Haas', '2026-10-17T11:15:00'),
  (11, 'Ramona', '2026-10-17T11:15:00'),
  (12, 'De Ley', '2026-10-17T11:15:00'),
  (13, 'Chef', '2026-10-17T11:15:00'),
  (14, 'Casa Gusto', '2026-10-21T00:00:00'),
  (15, 'Sano Sin Harina', '2026-10-21T00:00:00'),
  (16, 'ElgoVita', '2026-10-21T00:00:00'),
  (17, 'Schneck', '2026-10-22T00:00:00');

-- TAGS
INSERT INTO TAG (id, nombre, creado_en)
VALUES
  (1, 'Verdura', '2026-10-17T11:15:00'),
  (2, 'Congelado', '2026-10-17T11:15:00'),
  (3, 'Alfajor', '2026-10-17T11:15:00'),
  (4, 'Postre', '2026-10-17T11:15:00'),
  (5, 'Fruta', '2026-10-17T11:15:00'),
  (6, 'Fruto Seco', '2026-10-17T11:15:00'),
  (7, 'Cereal', '2026-10-17T11:15:00'),
  (8, 'Guarnicion', '2026-10-17T11:15:00'),
  (9, 'Preparado', '2026-10-17T11:15:00'),
  (10, 'Bebida', '2026-10-17T11:15:00'),
  (11, 'Restaurante', '2026-10-17T11:15:00'),
  (12, 'Harina', '2026-10-17T11:15:00'),
  (13, 'Pan', '2026-10-17T11:15:00'),
  (14, 'Snack', '2026-10-17T11:15:00'),
  (15, 'Galletita', '2026-10-17T11:15:00'),
  (16, 'Jugo', '2026-10-17T11:15:00'),
  (17, 'Barrita', '2026-10-17T11:15:00'),
  (18, 'Dulce', '2026-10-17T11:15:00'),
  (19, 'Legumbre', '2026-10-21T00:00:00'),
  (20, 'Lácteo', '2026-10-21T00:00:00'),
  (21, 'Aderezo', '2026-10-22T00:00:00');

-- MEDIDAS
INSERT INTO MEDIDA (id, nombre, creado_en)
VALUES
  (1, 'Cucharada', '2026-10-17T11:15:00'),
  (2, 'Plato', '2026-10-17T11:15:00'),
  (3, 'Rodaja', '2026-10-17T11:15:00'),
  (4, 'Unidad', '2026-10-17T11:15:00'),
  (5, 'Taza', '2026-10-17T11:15:00'),
  (6, 'Porción (1/8)', '2026-10-17T11:15:00'),
  (7, '100 g', '2026-10-17T11:15:00'),
  (8, '30 g', '2026-10-17T11:15:00');

-- PRODUCTOS
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (1, 'Fécula de mandioca', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (2, 'Papas Clásicas', 1, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (3, 'Papa gruesa', 1, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (4, 'Rodaja de pan', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (5, 'Tortuga', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (6, 'Masita S/A', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (7, 'Pizza de 30 cm', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (8, 'Empanada', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (9, 'Alfajor blanco arándanos S/A', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (10, 'Alfajor de maicena S/A grande', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (11, 'Alfajor negro salchichón S/A', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (12, 'Alfajor S/A', 7, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (13, 'Alfajor Avena', 8, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (14, 'Alfajor Yo-Yo', 8, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (15, 'Barrita Best Protein Salty Caramel', 2, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (16, 'Barrita Best Protein Cookies', 2, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (17, 'Galleta sándwich', 3, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (18, 'Jugo de manzana', 4, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (19, 'Galletas de chocolate (azules)', 5, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (20, 'Galletas María de arroz Chocolate', 6, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (21, 'Arroz blanco crudo', 13, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (22, 'Arroz con leche S/A', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (23, 'Combo doble con papas medianas', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (24, 'Budín de vainilla S/A', 5, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (25, 'Dulce de membrillo S/A', 9, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (26, 'Harina de almendras', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (27, 'Harina de coco', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (28, 'Maní con chocolate Haas', 10, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (29, 'Masita estándar S/A', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (30, 'Papa cruda', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (31, 'Papas fritas hechas', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (32, 'Papas en bastones congeladas', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (33, 'Poke ♥', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (34, 'Postre chocolate S/A', 11, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (35, 'Cebolla congelada', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (36, 'Morrón rojo congelado', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (37, 'Puerro congelado', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (38, 'Champiñones en lata', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (39, 'Porotos blancos cocidos', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (40, 'Tomates perita en lata', NULL, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (41, 'Salsa de tomate De Ley S/A', 12, '2026-10-17T11:15:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (42, 'Limonada con frutos rojos', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (43, 'Alfajor chocolate sin azúcar', 14, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (44, 'Arroz blanco cocido', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (45, 'Zapallito de tronco', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (46, 'Brócoli congelado', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (47, 'Papas a la cacerola', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (48, 'Pan felipe', 15, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (49, 'Pan de viena', 15, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (50, 'Galletitas de limón S/A', 16, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (51, 'Palta', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (52, 'Almendras', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (53, 'Arroz integral cocido', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (54, 'Arándanos', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (55, 'Avena cocida', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (56, 'Banana', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (57, 'Brócoli crudo', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (58, 'Cebolla cruda', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (59, 'Copos de avena crudos', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (60, 'Frutilla', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (61, 'Frambuesa', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (62, 'Porotos frutilla cocidos', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (63, 'Garbanzos cocidos', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (64, 'Kiwi', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (65, 'Leche de vaca', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (66, 'Lentejas cocidas', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (67, 'Mandarina', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (68, 'Manzana', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (69, 'Miel', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (70, 'Naranja', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (71, 'Nueces', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (72, 'Pasas de uva', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (73, 'Pera', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (74, 'Puré de papa', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (75, 'Quinoa cocida', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (76, 'Repollo blanco crudo', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (77, 'Tomate crudo', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (78, 'Uva', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (79, 'Zanahoria cruda', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (80, 'Zucchini', NULL, '2026-10-21T00:00:00');
INSERT INTO PRODUCTO (id, nombre, id_marca, creado_en)
VALUES (81, 'Mostaza', 17, '2026-10-22T00:00:00');

-- EQUIVALENCIAS
-- La fécula tiene peso conocido, pero carbohidratos desconocidos.
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 20, 18
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 1
  AND m.id = 1;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 90
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 1
  AND m.id = 7;

-- Papas Lays Clásicas: 1 g CHO por unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 1
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 2
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 40
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 9
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 35
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 13
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 28
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 14
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 40
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 11
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 20
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 10
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 20
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 12
  AND m.id = 4;

-- Papa Lays gruesa: 1,5 g CHO por unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 1.5
FROM PRODUCTO p
CROSS JOIN MEDIDA m
WHERE p.id = 3
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 10
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 4
  AND m.id = 3;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 20
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 5
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 8
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 6
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 30
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 7
  AND m.id = 6;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 15
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 8
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 17
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 15
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 21
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 16
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 9
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 17
  AND m.id = 4;

INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 25
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 18
  AND m.id = 4;

-- Smams: 65 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 65
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 19
  AND m.id = 7;

-- Smams: 19 g CHO / 30 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 30, 19
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 19
  AND m.id = 8;

-- Smams: 6 g CHO / unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 6
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 19
  AND m.id = 4;

-- Blue Patna: 73 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 73
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 20
  AND m.id = 7;

-- Blue Patna: 22 g CHO / 30 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 30, 22
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 20
  AND m.id = 8;

-- Blue Patna: 4.4 g CHO / unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 4.4
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 20
  AND m.id = 4;

-- Arroz blanco crudo: 78 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 78
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 21
  AND m.id = 7;

-- Arroz con leche S/A: 17 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 17
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 22
  AND m.id = 7;

-- Combo doble con papas medianas: 100 g CHO por unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 100
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 23
  AND m.id = 4;

-- Budín Smams de vainilla S/A: 70 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 70
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 24
  AND m.id = 7;

-- Dulce de membrillo Limay S/A: 19 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 19
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 25
  AND m.id = 7;

-- Harina de almendras: 10 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 10
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 26
  AND m.id = 7;

-- Harina de coco: 60 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 60
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 27
  AND m.id = 7;

-- Maní con chocolate Haas: 36 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 36
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 28
  AND m.id = 7;

-- Masita estándar S/A: 45 g CHO / 100 g, confianza baja
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 45, '1 - Bajo'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 29
  AND m.id = 7;

-- Papa cruda: 18 g CHO / 100 g, confianza baja
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 18, '1 - Bajo'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 30
  AND m.id = 7;

-- Papas fritas hechas: 36 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 36
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 31
  AND m.id = 7;

-- Papas en bastones congeladas: 23 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 23
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 32
  AND m.id = 7;

-- Poke: 60 g CHO por unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 60
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 33
  AND m.id = 4;

-- Postre chocolate Ramona S/A: 60 g CHO por unidad
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, NULL, 60
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 34
  AND m.id = 4;

-- Cebolla congelada: 5,8 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 5.8, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 35
  AND m.id = 7;

-- Morrón rojo congelado: 6,4 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 6.4, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 36
  AND m.id = 7;

-- Puerro congelado: 3 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 3, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 37
  AND m.id = 7;

-- Champiñones en lata: 4 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 4, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 38
  AND m.id = 7;

-- Porotos blancos cocidos: 25 g CHO / 100 g
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
SELECT p.id, m.id, 100, 25
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 39
  AND m.id = 7;

-- Tomates perita en lata: 4 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 4, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 40
  AND m.id = 7;

-- Salsa de tomate De Ley S/A: 5 g CHO / 100 g, confianza alta
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT p.id, m.id, 100, 5, '3 - Alto'
FROM PRODUCTO p, MEDIDA m
WHERE p.id = 41
  AND m.id = 7;

-- Completar confianza solo donde no fue especificada explícitamente.
UPDATE PRODUCTO_MEDIDA
SET confianza = CASE
  WHEN id_prod IN (2, 3) THEN '1 - Bajo'
  WHEN id_prod IN (SELECT id FROM PRODUCTO WHERE id_marca IS NOT NULL)
    THEN '3 - Alto'
  ELSE '2 - Medio'
END
WHERE confianza IS NULL
  AND id_prod <= 41;

-- Nuevas equivalencias agregadas el 2026-10-21.
-- Las bebidas se guardan contra 100 g usando el valor informado por 100 ml.
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
VALUES
  (42, 7, 100, 5),
  (43, 4, 60, 22),
  (44, 7, 100, 30),
  (45, 7, 100, 4),
  (46, 7, 100, 4),
  (47, 7, 100, 22),
  (48, 4, 50, 22),
  (49, 4, 25, 11),
  (50, 4, 15, 10);

-- Nuevos alimentos de la lista de la app: carbohidratos por 100 g.
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
VALUES
  (51, 7, 100, 9),
  (52, 7, 100, 22),
  (53, 7, 100, 23),
  (54, 7, 100, 14),
  (55, 7, 100, 12),
  (56, 7, 100, 21),
  (57, 7, 100, 7),
  (58, 7, 100, 9),
  (59, 7, 100, 60),
  (60, 7, 100, 8),
  (61, 7, 100, 13),
  (62, 7, 100, 23),
  (63, 7, 100, 27),
  (64, 7, 100, 15),
  (65, 7, 100, 5),
  (66, 7, 100, 20),
  (67, 7, 100, 12),
  (68, 7, 100, 11),
  (69, 7, 100, 82),
  (70, 7, 100, 12),
  (71, 7, 100, 14),
  (72, 7, 100, 79),
  (73, 7, 100, 15),
  (74, 7, 100, 15),
  (75, 7, 100, 21),
  (76, 7, 100, 6),
  (77, 7, 100, 4),
  (78, 7, 100, 18),
  (79, 7, 100, 10),
  (80, 7, 100, 3);

-- Mostaza Schneck: 1,6 g CHO en una cucharada de 12 g.
-- La derivación posterior calcula 13,333... g CHO cada 100 g.
INSERT INTO PRODUCTO_MEDIDA (id_prod, id_med, grs_prod, grs_cho)
VALUES (81, 1, 12, 1.6);

-- Derivar CHO por 100 g cuando hay una única equivalencia fuente con peso.
-- Se conserva su confianza y no se reemplazan
-- valores de 100 g que ya estén declarados explícitamente.
INSERT INTO PRODUCTO_MEDIDA
  (id_prod, id_med, grs_prod, grs_cho, confianza)
SELECT origen.id_prod,
       medida_100g.id,
       100,
       origen.grs_cho * 100.0 / origen.grs_prod,
       origen.confianza
FROM PRODUCTO_MEDIDA AS origen
JOIN MEDIDA AS medida_100g
  ON medida_100g.nombre = '100 g'
  AND medida_100g.eliminado_en IS NULL
WHERE origen.id_med <> medida_100g.id
  AND origen.grs_prod > 0
  AND origen.grs_cho IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM PRODUCTO_MEDIDA AS existente
    WHERE existente.id_prod = origen.id_prod
      AND existente.id_med = medida_100g.id
  )
  AND (
    SELECT COUNT(*)
    FROM PRODUCTO_MEDIDA AS alternativa
    WHERE alternativa.id_prod = origen.id_prod
      AND alternativa.id_med <> medida_100g.id
      AND alternativa.grs_prod > 0
      AND alternativa.grs_cho IS NOT NULL
  ) = 1;

-- Verdura
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (30, 1),
  (32, 1),
  (35, 1),
  (36, 1),
  (37, 1),
  (38, 1),
  (39, 1),
  (40, 1);

-- Congelado
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (32, 2),
  (35, 2),
  (36, 2),
  (37, 2);

-- Combo: restaurante y preparado
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (23, 9),
  (23, 11);

-- Pan
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (4, 13),
  (5, 13);

-- Alfajores
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (9, 3),
  (10, 3),
  (11, 3),
  (12, 3),
  (13, 3),
  (14, 3);

-- Postres
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (24, 4),
  (34, 4);

-- Harina: fécula y harinas de almendra y coco
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (1, 12),
  (26, 12),
  (27, 12);

-- Cereal
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (21, 7);

-- Guarnición
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (31, 8);

-- Snack
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (2, 14),
  (3, 14);

-- Galletitas
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (17, 15),
  (19, 15),
  (20, 15);

-- Jugo
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (18, 16);

-- Arroz con leche: postre
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (22, 4);

-- Preparados de restaurante
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (7, 9),
  (7, 11),
  (8, 9),
  (8, 11),
  (33, 9);

-- Barritas Best Protein
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (15, 17),
  (16, 17);

-- Dulce de membrillo
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (25, 18);

-- Nuevos alimentos: tags acordados.
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (42, 10),
  (43, 3),
  (44, 7),
  (44, 8),
  (45, 1),
  (46, 1),
  (46, 2),
  (47, 8),
  (47, 9),
  (48, 13),
  (49, 13),
  (50, 15);

-- Nuevos alimentos de la lista de la app.
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (51, 5),
  (52, 6),
  (53, 7),
  (53, 8),
  (54, 5),
  (55, 7),
  (56, 5),
  (57, 1),
  (58, 1),
  (59, 7),
  (60, 5),
  (61, 5),
  (39, 19),
  (62, 19),
  (63, 19),
  (64, 5),
  (65, 20),
  (66, 19),
  (67, 5),
  (68, 5),
  (69, 18),
  (70, 5),
  (71, 6),
  (72, 5),
  (73, 5),
  (74, 8),
  (74, 9),
  (75, 7),
  (76, 1),
  (77, 1),
  (78, 5),
  (79, 1),
  (80, 1),
  (22, 20);

-- Aderezo
INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES
  (41, 21),
  (81, 21);

