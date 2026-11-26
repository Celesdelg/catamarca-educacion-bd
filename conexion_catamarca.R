library(DBI)
library(ggplot2)

con <- dbConnect(
  RPostgres::Postgres(),
  dbname   = "catamarca",
  host     = "localhost",
  port     = 5432,
  user     = "postgres",
  password = rstudioapi::askForPassword("Contraseña de postgres")
)

dbListTables(con)

# 1. Establecimientos rurales por departamento (usa la vista)
oferta <- dbGetQuery(con, "SELECT * FROM v_oferta_departamento ORDER BY pct_rural DESC")
print(oferta)

g1 <- ggplot(oferta, aes(x = reorder(departamento, pct_rural), y = pct_rural)) +
  geom_col() +
  coord_flip() +
  labs(title = "Establecimientos rurales por departamento. Catamarca, 2024",
       x = NULL, y = "% de establecimientos rurales")
ggsave("grafico_rural.png", g1, width = 9, height = 6, dpi = 150)

# 2. Recursos de los establecimientos, rural contra urbano
recursos <- dbGetQuery(con, "
  SELECT s.ambito,
         ROUND(100.0 * SUM(c.con_electricidad) / SUM(c.establecimientos), 1) AS electricidad,
         ROUND(100.0 * SUM(c.con_biblioteca) / SUM(c.establecimientos), 1) AS biblioteca,
         ROUND(100.0 * SUM(c.con_laboratorio_informatica) / SUM(c.establecimientos), 1) AS laboratorio
    FROM condicion_institucional c
    JOIN segmento s USING (id_segmento)
   GROUP BY s.ambito")
print(recursos)

recursos_largo <- data.frame(
  ambito  = rep(recursos$ambito, times = 3),
  recurso = rep(c("Electricidad", "Biblioteca", "Laboratorio de informática"),
                each = nrow(recursos)),
  pct     = c(recursos$electricidad, recursos$biblioteca, recursos$laboratorio)
)

g2 <- ggplot(recursos_largo, aes(x = recurso, y = pct, fill = ambito)) +
  geom_col(position = "dodge") +
  labs(title = "Establecimientos con cada recurso, según ámbito. Catamarca, 2024",
       x = NULL, y = "% de establecimientos", fill = "Ámbito")
ggsave("grafico_recursos.png", g2, width = 9, height = 6, dpi = 150)

dbDisconnect(con)