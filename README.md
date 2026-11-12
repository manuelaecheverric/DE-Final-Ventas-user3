# Examen final Ingeniería de Datos: Ventas (Airflow + dbt + DuckDB)

Solución del punto 2 ([enunciado](https://github.com/smm-0216/DE-Final-Ventas)). Autora: Manuela Echeverri Castrillón. Trabajo realizado con apoyo de IA (Claude); el chat se comparte con el docente.

## Archivos modificados
- `dbt/models/ventas_diarias.sql`: una fila por `fecha_venta` con `numero_ventas`, `unidades_vendidas` e `ingreso_total` (DECIMAL(12,2)).
- `dbt/models/sources.yml`: `loaded_at_field: _loaded_at`; freshness a nivel de tabla con `warn_after` 12 h y `error_after` 24 h (sin `--warn-error`).
- `airflow/dags/examen_ventas.py`: nueva tarea `verificar_frescura` (`run_dbt(["source", "freshness"])`) antes de `construir_resumen`, con la regla por defecto `all_success`.

## Resultado del resumen
| fecha_venta | numero_ventas | unidades_vendidas | ingreso_total |
|---|---:|---:|---:|
| 2026-01-10 | 2 | 3 | 46.00 |
| 2026-01-11 | 3 | 6 | 51.25 |
| 2026-01-12 | 1 | 4 | 12.40 |

## Pasos
1. `bash scripts/examen.sh scenario actualizada` → `bash scripts/examen.sh dbt build` (todas las pruebas en verde) → Trigger DAG: `verificar_frescura` y `construir_resumen` en `success` (capturas `evidencias/actualizada_*`).
2. Consulta del resumen (`evidencias/resumen_antes_desactualizada.txt`) → `bash scripts/examen.sh scenario desactualizada` → Trigger DAG: `verificar_frescura` en `failed` y `construir_resumen` en `upstream_failed`, sin `INICIO dbt` del build (capturas `evidencias/desactualizada_*` y log de freshness).
3. Consulta del resumen después (`evidencias/resumen_despues_desactualizada.txt`): se conservan las mismas filas; bloquear no borra el resumen anterior.

Respuestas conceptuales en `respuestas.md`.
