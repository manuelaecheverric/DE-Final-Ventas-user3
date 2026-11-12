# Respuestas conceptuales

## 1. ¿Por qué usar `_loaded_at` y no `fecha_venta` para este control?
Freshness debe medir si el pipeline entrega datos recientes, es decir, cuándo llegó la carga al almacén (`_loaded_at`). `fecha_venta` es la fecha del negocio: puede ser antigua de forma legítima (ventas tardías, reprocesos, días sin ventas) aunque la carga sea de hace minutos. En el examen las ventas siempre son del 10 al 12 de enero de 2026; si se usara `fecha_venta`, el control siempre diría "desactualizado". Con `_loaded_at` distingue correctamente los escenarios: 2 h (pasa), 18 h (advierte) y 30 h (falla).

## 2. ¿Por qué las pruebas de integridad no garantizan actualidad?
Las pruebas `unique`, `not_null` y de valores revisan el contenido de lo que ya está en la tabla, no cuándo llegó. Una carga de hace 30 horas puede ser perfectamente íntegra y pasar todas las pruebas. La actualidad depende del tiempo transcurrido respecto a "ahora", y eso solo lo mide `dbt source freshness` con `loaded_at_field` y sus umbrales. En el escenario desactualizado los datos son válidos, pero freshness falla y bloquea el build (`upstream_failed`), lo que conserva el resumen anterior.
