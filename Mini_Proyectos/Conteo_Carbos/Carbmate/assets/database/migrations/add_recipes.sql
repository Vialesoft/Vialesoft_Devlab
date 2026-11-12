CREATE TABLE RECETA (
    id        INTEGER PRIMARY KEY,
    nombre    TEXT NOT NULL CHECK (length(trim(nombre)) > 0),
    instrucciones TEXT,
    nota      TEXT,
    creado_en TEXT NOT NULL
);

CREATE TABLE RECETA_INGREDIENTE (
    id          INTEGER PRIMARY KEY,
    id_receta   INTEGER NOT NULL,
    id_prod     INTEGER NOT NULL,
    id_med      INTEGER NOT NULL,
    cantidad    REAL NOT NULL CHECK (cantidad > 0),
    es_gramos   INTEGER NOT NULL DEFAULT 0 CHECK (es_gramos IN (0, 1)),
    orden       INTEGER NOT NULL,

    FOREIGN KEY (id_receta)
        REFERENCES RECETA(id)
        ON DELETE CASCADE,

    FOREIGN KEY (id_prod)
        REFERENCES PRODUCTO(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (id_prod, id_med)
        REFERENCES PRODUCTO_MEDIDA(id_prod, id_med)
        ON DELETE RESTRICT
);

CREATE INDEX idx_receta_ingrediente_receta
    ON RECETA_INGREDIENTE(id_receta, orden);

CREATE INDEX idx_receta_ingrediente_producto
    ON RECETA_INGREDIENTE(id_prod);
