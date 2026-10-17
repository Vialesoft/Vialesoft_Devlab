CREATE TABLE MARCA (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT NOT NULL
                 CHECK (length(trim(nombre)) > 0),
    creado_en    TEXT NOT NULL,
    eliminado_en TEXT
);

CREATE TABLE PRODUCTO (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT NOT NULL
                 CHECK (length(trim(nombre)) > 0),
    id_marca     INTEGER,
    creado_en    TEXT NOT NULL,
    eliminado_en TEXT,

    FOREIGN KEY (id_marca)
        REFERENCES MARCA(id)
        ON DELETE RESTRICT
);

CREATE TABLE MEDIDA (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT NOT NULL
                 CHECK (length(trim(nombre)) > 0),
    nota         TEXT,
    creado_en    TEXT NOT NULL,
    eliminado_en TEXT
);

CREATE TABLE TAG (
    id           INTEGER PRIMARY KEY,
    nombre       TEXT NOT NULL
                 CHECK (length(trim(nombre)) > 0),
    creado_en    TEXT NOT NULL,
    eliminado_en TEXT
);

CREATE TABLE PRODUCTO_MEDIDA (
    id_prod   INTEGER NOT NULL,
    id_med    INTEGER NOT NULL,
    grs_cho   REAL
              CHECK (grs_cho IS NULL OR grs_cho >= 0),
    grs_prod REAL
              CHECK (grs_prod IS NULL OR grs_prod >= 0),
    confianza TEXT
              CHECK (
                  confianza IS NULL OR
                  confianza IN (
                      '1 - Bajo',
                      '2 - Medio',
                      '3 - Alto'
                  )
              ),
    fuente    TEXT,
    nota      TEXT,

    PRIMARY KEY (id_prod, id_med),

    FOREIGN KEY (id_prod)
        REFERENCES PRODUCTO(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (id_med)
        REFERENCES MEDIDA(id)
        ON DELETE RESTRICT
);

CREATE TABLE PRODUCTO_TAG (
    id_prod INTEGER NOT NULL,
    id_tag  INTEGER NOT NULL,

    PRIMARY KEY (id_prod, id_tag),

    FOREIGN KEY (id_prod)
        REFERENCES PRODUCTO(id)
        ON DELETE RESTRICT,

    FOREIGN KEY (id_tag)
        REFERENCES TAG(id)
        ON DELETE RESTRICT
);

CREATE INDEX idx_producto_nombre_activo
    ON PRODUCTO(nombre)
    WHERE eliminado_en IS NULL;

CREATE INDEX idx_producto_marca
    ON PRODUCTO(id_marca);

CREATE INDEX idx_medida_nombre_activa
    ON MEDIDA(nombre)
    WHERE eliminado_en IS NULL;

CREATE INDEX idx_tag_nombre_activo
    ON TAG(nombre)
    WHERE eliminado_en IS NULL;

CREATE INDEX idx_producto_medida_medida
    ON PRODUCTO_MEDIDA(id_med);

CREATE INDEX idx_producto_tag_tag
    ON PRODUCTO_TAG(id_tag);

