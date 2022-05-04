-- 1.
create table estandar(
    especificacion varchar(10),
    velocidad integer not null,
    primary key(especificacion)
);
--
insert into estandar values('GPRS', 50);
insert into estandar values('EDGE', 350);
insert into estandar values('HSPA', 21000);
insert into estandar values('LTE', 60000);
insert into estandar values('LTEA', 100000);
insert into estandar values('NR', 1000000);
--
create or replace function alo_sumo_21000() returns table(spec varchar(10)) as $$
begin
    return query
        select especificacion
        from estandar
        where(velocidad <= 21000);
end;
$$ language plpgsql;
-- 2.
create or replace function cambio_estandar() returns trigger as $$
begin
    raise notice 'Tabla bloqueada: operacion no realizada por falta de autorizacion.';
    return null;
end;
$$ language plpgsql;
--
create trigger cambio_estandar_trigger
before insert or update or delete on estandar
for each row execute procedure cambio_estandar();
-- 3.
create or replace function cambios_movil() returns trigger as $$
begin
    raise notice 'Operacion % realizada en la tabla "movil".', TG_OP;
    return null;
end;
$$ language plpgsql;
--
create trigger cambios_movil_trigger
after insert or update or delete on movil
for each statement execute procedure cambios_movil();
-- 4.
create or replace procedure numero_materiales_componentel(id integer) as $$
declare i integer default 0;
begin
    select count(*) into i
    from componentematerial as cm
    where id_componente = id
    group by (id_componente);

    raise notice 'El resultado es %.', i;
end;
$$ language plpgsql; 
-- 5.
create or replace function material_todos_origenes(x varchar(50)) returns table(id integer, nombre varchar(100)) as $$
begin
    return query
        select o.id, o.lugar
        from origen as o
        inner join materialorigen as mo on (mo.id_origen = o.id)
        inner join material as m on (mo.id_material = m.id)
        where lower(m.nombre) = lower(x)
        order by o.id desc;
    if not found then
        raise exception 'El material no existe en la base.';
    end if;
end;
$$ language plpgsql;
