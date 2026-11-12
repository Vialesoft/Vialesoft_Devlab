CREATE TABLE LAPICERA_INSULINA (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo TEXT NOT NULL CHECK (tipo IN ('toujeo', 'novorapid')),
    dias_vida_util INTEGER NOT NULL CHECK (dias_vida_util > 0),
    abierta_el TEXT NOT NULL,
    creada_en TEXT NOT NULL
);
