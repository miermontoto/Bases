-- 2. Presenta el nombre de aquellos componentes que contengan 'magnesio' o 'galio' en orden descendente.
select c.nombre
from componentematerial as cm
inner join componente as c on (c.id = cm.id_componente)
inner join material as m on (m.id = cm.id_material)
where lower(m.nombre) in ('magnesio', 'galio')
order by m.nombre desc;

-- 3. Presenta el nombre de aquellos componentes con al menos dos materiales cuya primera letra empiece por ‘n’.
select c.nombre, count(*) as numero_materiales
from componentematerial as cm
inner join componente as c on (c.id = cm.id_componente)
inner join material as m on (m.id = cm.id_material)
where lower(m.nombre) like 'n%'
group by c.nombre
having count(m.nombre) >= 2;

-- 4. Presenta el nombre de aquellos materiales con origen desconocido.
(
    select nombre from material
) except (
    select m.nombre from materialorigen as mo 
    inner join material as m on (m.id = mo.id_material)
);

-- 5. Presenta aquellos materiales que provengan de dos lugares y aquellos que vengan de 'Rusia' (UNION).
(
    select m1.id, m1.nombre
    from materialorigen as mo1
    inner join material as m1 on (m1.id = mo1.id_material)
    inner join origen as o1 on (o1.id = mo1.id_origen)
    where lower(o1.lugar) = 'rusia'
) union (
    select m2.id, m2.nombre
    from materialorigen as mo2
    inner join material as m2 on (m2.id = mo2.id_material)
    inner join origen as o2 on (o2.id = mo2.id_origen)
    group by m2.id
    having count(*) = 2
);

-- 6. Presenta el nombre de todos aquellos componentes que contengan 'niquel' (WHERE NOT EXISTS)
select distinct nombre
from componente
where not exists(
    (
        select c1.id
        from componentematerial as cm1
        inner join componente as c1 on (c1.id = cm1.id_componente)
        inner join material as m1 on (m1.id = cm1.id_componente) 
    ) except (
        select c2.id
        from componentematerial as cm2
        inner join componente as c2 on (c2.id = cm2.id_componente)
        inner join material as m2 on (m2.id = cm2.id_componente)
        where lower(m2.nombre) = 'niquel'
    )
);
