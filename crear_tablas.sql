CREATE TABLE departamento (
    id_departamento SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE segmento (
    id_segmento SERIAL PRIMARY KEY,
    sector VARCHAR(10) NOT NULL CHECK (sector IN ('Estatal', 'Privado')),
    ambito VARCHAR(10) NOT NULL CHECK (ambito IN ('Rural', 'Urbano')),
    UNIQUE (sector, ambito)
);

INSERT INTO departamento (nombre) VALUES
    ('Ambato'), ('Ancasti'), ('Andalgalá'), ('Antofagasta de la Sierra'),
    ('Belén'), ('Capayán'), ('Capital'), ('El Alto'),
    ('Fray Mamerto Esquiú'), ('La Paz'), ('Paclín'), ('Pomán'),
    ('Santa María'), ('Santa Rosa'), ('Tinogasta'), ('Valle Viejo'),
    ('Enmascarado');

INSERT INTO segmento (sector, ambito) VALUES
    ('Estatal', 'Rural'), ('Estatal', 'Urbano'),
    ('Privado', 'Rural'), ('Privado', 'Urbano');

CREATE TABLE comunidad (
    id_comunidad INTEGER PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    pueblo VARCHAR(40) NOT NULL,
    localidad VARCHAR(80),
    id_departamento INTEGER NOT NULL REFERENCES departamento (id_departamento)
);

CREATE TABLE establecimiento (
    cueanexo VARCHAR(12) PRIMARY KEY,
    nombre VARCHAR(200),
    id_departamento INTEGER NOT NULL REFERENCES departamento (id_departamento),
    id_segmento INTEGER NOT NULL REFERENCES segmento (id_segmento)
);

CREATE TABLE matricula_primaria (
    id_departamento INTEGER REFERENCES departamento (id_departamento),
    id_segmento INTEGER REFERENCES segmento (id_segmento),
    matricula INTEGER NOT NULL,
    PRIMARY KEY (id_departamento, id_segmento)
);

CREATE TABLE condicion_institucional (
    id_departamento INTEGER REFERENCES departamento (id_departamento),
    id_segmento INTEGER REFERENCES segmento (id_segmento),
    establecimientos INTEGER NOT NULL,
    con_electricidad INTEGER NOT NULL,
    con_internet_aulas INTEGER NOT NULL,
    con_biblioteca INTEGER NOT NULL,
    con_laboratorio_informatica INTEGER NOT NULL,
    con_gestion_escolar INTEGER NOT NULL,
    PRIMARY KEY (id_departamento, id_segmento)
);

CREATE TABLE desempeno_lengua (
    id_departamento INTEGER REFERENCES departamento (id_departamento),
    id_segmento INTEGER REFERENCES segmento (id_segmento),
    nivel VARCHAR(30) NOT NULL CHECK (nivel IN
        ('Por debajo del nivel básico', 'Básico', 'Satisfactorio', 'Avanzado')),
    estudiantes NUMERIC NOT NULL,
    PRIMARY KEY (id_departamento, id_segmento, nivel)
);

SELECT table_name
  FROM information_schema.tables
 WHERE table_schema = 'public'
 ORDER BY table_name;