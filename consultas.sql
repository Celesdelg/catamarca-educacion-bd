CREATE OR REPLACE VIEW v_oferta_departamento AS
SELECT d.nombre AS departamento,
       COUNT(*) AS establecimientos,
       COUNT(*) FILTER (WHERE s.ambito = 'Rural') AS rurales,
       ROUND(100.0 * COUNT(*) FILTER (WHERE s.ambito = 'Rural') / COUNT(*), 1) AS pct_rural
  FROM establecimiento e
  JOIN departamento d USING (id_departamento)
  JOIN segmento s USING (id_segmento)
 GROUP BY d.nombre;

-- 1. Comunidades por departamento
SELECT d.nombre AS departamento, COUNT(*) AS comunidades
  FROM comunidad c
  JOIN departamento d USING (id_departamento)
 GROUP BY d.nombre
 ORDER BY comunidades DESC, d.nombre;

-- 2. Establecimientos rurales
SELECT SUM(rurales) AS rurales, SUM(establecimientos) AS total,
       ROUND(100.0 * SUM(rurales) / SUM(establecimientos), 1) AS pct_rural
  FROM v_oferta_departamento;

-- 3. Matrícula de primaria por departamento
SELECT d.nombre AS departamento, SUM(m.matricula) AS matricula
  FROM matricula_primaria m
  JOIN departamento d USING (id_departamento)
 GROUP BY d.nombre
 ORDER BY matricula DESC;

-- 4. Recursos, rural contra urbano
SELECT s.ambito,
       ROUND(100.0 * SUM(c.con_electricidad) / SUM(c.establecimientos), 1) AS electricidad,
       ROUND(100.0 * SUM(c.con_biblioteca) / SUM(c.establecimientos), 1) AS biblioteca,
       ROUND(100.0 * SUM(c.con_laboratorio_informatica) / SUM(c.establecimientos), 1) AS laboratorio
  FROM condicion_institucional c
  JOIN segmento s USING (id_segmento)
 GROUP BY s.ambito;

-- 5. Lengua por debajo del nivel básico
SELECT d.nombre AS departamento,
       ROUND(100.0 * SUM(l.estudiantes) FILTER (WHERE l.nivel = 'Por debajo del nivel básico')
             / SUM(l.estudiantes), 2) AS pct_debajo_basico
  FROM desempeno_lengua l
  JOIN departamento d USING (id_departamento)
 GROUP BY d.nombre
 ORDER BY pct_debajo_basico DESC;