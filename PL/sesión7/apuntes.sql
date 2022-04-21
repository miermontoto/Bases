/*markdown
# Sesión 7
## Teoría
### Triggers
#### Definición
Un trigger es una función que se ejecuta cuando se produce un evento en la base de datos.

 - Se ejecuta una sola vez, y se puede ejecutar antes o después de una acción.
 - Trabaja sobre una sola tabla.
 - Niveles:
    - **Nivel-sentencia:** el trigger es llamado una vez por cada operación, independientemente del número de filas que modifique.
    - **Nivel-fila:** el trigger es llamado una vez por cada fila que modifique.

#### Sintaxis
```sql
CREATE OR REPLACE TRIGGER [nombre] [AFTER|BEFORE] [INSERT|UPDATE|DELETE] ON [tabla]
    [FOR [EACH] [ROW|STATEMENT]]
    [WHEN (condición)]
    EXECUTE PROCEDURE [nombre_procedimiento] ([parametros])
```

#### Procedimientos asociados a triggers
 - Tiene que ser creado e instalado antes de la definición del trigger.
 - Puede ser usado por diferentes triggers y procedimientos.
 - Si varios triggers están asociados al mismo evento, se ejecutan en orden alfabético.
 - Pueden llamar a otro trigger, con un impacto en el rendimiento.

#### Variables especiales
 - **NEW**: contiene la nueva tupla para ser actualizada.
 - **OLD**: contiene la tupla antigua para ser actualizada.
 - **TG_<x>**: describe la condición que dispara la llamada al trigger:
    - **TG_WHEN** (varchar): Retorna `BEFORE` o `AFTER`.
    - **TG_LEVEL** (varchar): Retorna `STATEMENT` o `ROW`.
    - **TG_OP** (varchar): Retorna `INSERT`, `UPDATE` o `DELETE`.
    - **TG_TABLE** (varchar): Retorna el nombre de la tabla.

### Ejemplos
#### Ejemplo: Trigger a nivel-fila
```sql
create or replace function modifica_fecha() returns trigger as $$
begin
    new.fecha = current_date;
    return new;
end;
$$ language plpgsql;

create trigger tg_fecha_modificada 
before insert on clientes for each row
execute procedure modifica_fecha();
```

#### Ejemplo: Trigger a nivel-sentencia
```sql
create or replace function check_cliente() returns trigger as $$
begin
    if extract(dow from current_date) in (6,7) then
        raise notice 'No se pueden insertar clientes en fines de semana';
    end if;
    return null;
end;
$$ language plpgsql;

create or replace trigger tg_check_cliente
befor insert on clientes
for each statement
execute procedure check_cliente();
```
*/

/*markdown
## Práctica
### Ejercicio 1
*/

create or replace function presenta_insercion() returns trigger as
$$
begin
    if tg_op = 'INSERT' then
        raise notice 'Se ha realizado una insercion';
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
-- separador --
create or replace trigger tg_presenta_insercion
after insert on estudiante_grado_modulo
for each row execute procedure presenta_insercion();

-- insert into estudiante_grado_modulo values(4, 1, 8);
-- NOTICE:  Se ha realizado una insercion
-- INSERT 0 1

/*markdown
### Ejercicio 2
*/

-- Crear función similar a la del apartado anterior que tenga en cuenta el resto de operaciones.
create or replace function presenta_InsertDeleteUpdateOperacion() returns trigger as
$$
begin
    if tg_op = 'INSERT' then
        raise notice 'Se ha realizado una inserción.';
        return new;
    elsif tg_op = 'DELETE' then
        raise notice 'Se ha realizado una eliminación.';
        return old;
    elsif tg_op = 'UPDATE' then
        raise notice 'Se ha realizado una modificación.';
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
-- separador --
create or replace trigger tg_presenta_multi
after insert or update or delete on estudiante_grado_modulo
for each row execute procedure presenta_InsertDeleteUpdateOperacion();  

/*markdown
### Ejercicio 3
*/

-- Añadir dos columnas a la table ‘estudiante_grado_modulo’ llamdas ‘nota’ (int) y
-- ‘grado’ (varchar(10)), con un valor por defecto de 0 e ‘indefinido’ respectivamente.
alter table estudiante_grado_modulo add column nota int default 0;
alter table estudiante_grado_modulo add column grado varchar(10) default 'indefinido';

/*markdown
### Ejercicio 4
*/

-- Cada vez que se realiza una inserción, actualización o borrado en la tabla
-- ‘estudiante_grado_modulo’ se necesita registrar que dicha operación ha sido
-- ejecutada. Para tal fin, se creará una table denominada ‘operacion_notas_log’ que
-- deberá contener los siguientes campos: (REALIZAR POR LOS ESTUDIANTES).
-- 
-- Tabla:
-- operacion_notas_log
-- Atributo Tipo
-- operacion char(1)
-- hora timestamp
-- estudianteid int
-- moduloid int
-- nota int
drop table operacion_notas_log;
create table operacion_notas_log(
    operacion char(1),
    hora timestamp,
    estudianteid int,
    moduloid int,
    nota int
);

/*markdown
### Ejercicio 5
*/

create or replace function operacion_log() returns trigger as
$$
begin
    if tg_op = 'UPDATE' then
        insert into operacion_notas_log(operacion, hora, estudianteid, moduloid,
        nota) values ('U', now(), new.estudiante_id, new.modulo_id, new.nota);
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
-- separador --
create or replace trigger tg_operacion_log
after update on estudiante_grado_modulo
for each row execute procedure operacion_log();

/*markdown
#### Ejercicio 5.1
*/

-- Ejemplos de actualizaciones de la tabla ‘estudiante_grado_modulo’:
update estudiante_grado_modulo set nota = 1 where estudiante_id = 1 and modulo_id = 1;
update estudiante_grado_modulo set nota = 2 where estudiante_id = 4 and modulo_id = 8;
update estudiante_grado_modulo set nota = 7 where estudiante_id = 6 and modulo_id = 1;
update estudiante_grado_modulo set nota = 8 where estudiante_id = 3 and modulo_id = 2;
-- Mostrar tabla ‘operacion_notas_log’:
select * from operacion_notas_log;

/*markdown
### Ejercicio 7
*/

-- Crear un trigger similar al anterior que atienda a todas las modificaciones en
-- en la tabla ‘estudiante_grado_modulo’.
create or replace function operacion_log_multi() returns trigger as
$$
begin
    if tg_op = 'UPDATE' then
        insert into operacion_notas_log(operacion, hora, estudianteid, moduloid,
        nota) values ('U', now(), new.estudiante_id, new.modulo_id, new.nota);
        return new;
    elsif tg_op = 'DELETE' then
        insert into operacion_notas_log(operacion, hora, estudianteid, moduloid,
        nota) values ('D', now(), old.estudiante_id, old.modulo_id, old.nota);
        return old;
    elsif tg_op = 'INSERT' then
        insert into operacion_notas_log(operacion, hora, estudianteid, moduloid,
        nota) values ('I', now(), new.estudiante_id, new.modulo_id, new.nota);
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
-- separador --
create or replace trigger tg_operacion_log_multi
after update or delete or insert on estudiante_grado_modulo
for each row execute procedure operacion_log_multi();

-- Modificar la tabla 'estudiante_grado_modulo' con datos aleatorios para comprobar que funcione:
insert into estudiante_grado_modulo values(2, 2, 4);
delete from estudiante_grado_modulo where estudiante_id=2 and
modulo_id=4;
-- Mostrar tabla 'operacion_notas_log':
select * from operacion_notas_log;

/*markdown
### Ejercicio 8
*/

-- Borrar la tabla 'operacion_notas_log' y el trigger 'tg_operacion_log_multi':
drop table operacion_notas_log;
drop trigger tg_operacion_log_multi on estudiante_grado_modulo;

/*markdown
### Ejercicio 9
*/

-- Crear una tabla denominada ‘operacion_calificacion_log’ similar a la del apartado 4,
-- pero añadiendo el atributo ‘calificacion’.
create table operacion_calificacion_log(
    operacion char(1),
    hora timestamp,
    estudianteid int,
    moduloid int,
    calificacion varchar(10)
);

/*markdown
### Ejercicio 10
*/

-- Crear un trigger similar al del ejercicio 5, pero antes de que la nota sea insertada o actualizada,
-- se deberá calcular la calificación no numérica de acuerdo al siguiente baremo:
-- <4: Pobre, 4-5: No buena, 5-7: Buena, 7-9: Muy buena, 10: Excelente.
create or replace function calificacion_log_connota() returns trigger as
$$
begin
    if tg_op = 'UPDATE' then
        if new.nota < 4 then
            insert into operacion_calificacion_log(operacion, hora, estudianteid, moduloid,
            calificacion) values ('U', now(), new.estudiante_id, new.modulo_id, 'Pobre');
        elsif new.nota >= 4 and new.nota < 5 then
            insert into operacion_calificacion_log(operacion, hora, estudianteid, moduloid,
            calificacion) values ('U', now(), new.estudiante_id, new.modulo_id, 'No buena');
        elsif new.nota >= 5 and new.nota < 7 then
            insert into operacion_calificacion_log(operacion, hora, estudianteid, moduloid,
            calificacion) values ('U', now(), new.estudiante_id, new.modulo_id, 'Buena');
        elsif new.nota >= 7 and new.nota < 9 then
            insert into operacion_calificacion_log(operacion, hora, estudianteid, moduloid,
            calificacion) values ('U', now(), new.estudiante_id, new.modulo_id, 'Muy buena');
        elsif new.nota >= 9 and new.nota <= 10 then
            insert into operacion_calificacion_log(operacion, hora, estudianteid, moduloid,
            calificacion) values ('U', now(), new.estudiante_id, new.modulo_id, 'Excelente');
        end if;
        return new;
    end if;
    return null;
end;
$$ language plpgsql;
-- separador --
create or replace trigger tg_calificacion_log_connota
before update on estudiante_grado_modulo
for each row execute procedure calificacion_log_connota();

-- Ejemplos de actualizaciones de la tabla ‘estudiante_grado_modulo’:
update estudiante_grado_modulo set nota = 1 where estudiante_id = 1 and modulo_id = 1;
update estudiante_grado_modulo set nota = 2 where estudiante_id = 4 and modulo_id = 8;
update estudiante_grado_modulo set nota = 7 where estudiante_id = 6 and modulo_id = 1;
update estudiante_grado_modulo set nota = 8 where estudiante_id = 3 and modulo_id = 2;
-- Mostrar tabla ‘operacion_notas_log’:
select * from operacion_calificacion_log;