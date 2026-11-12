-- Resumen diario de ventas: una fila por fecha_venta.
-- ingreso_total usa DECIMAL para no perder precision con decimales binarios.
select
    cast(fecha_venta as date)                                                as fecha_venta,
    count(*)                                                                  as numero_ventas,
    sum(cantidad)                                                             as unidades_vendidas,
    cast(sum(cantidad * cast(precio_unitario as decimal(12, 2))) as decimal(12, 2)) as ingreso_total
from {{ ref('stg_ventas') }}
group by cast(fecha_venta as date)
order by fecha_venta
