/*markdown
# Práctica 9
## Teoría
### Dominio
El dominio es un tipo de dato al que se le puede atribuir restricciones opcionales sobre el conjunto de valores que se le podrían asignar.
```sql
-- Ejemplo de dominio para direcciones de correo electrónico.
create domain domainEmail as text
check(
    value ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
);
-- Ejemplo de dominio para códigos postales
create domain domainPostCode as text
check(
    value ~ '^[0-9]{5}$'
);
```
### Restricciones
- #### Restricciones de columna
    Un valor en una cierta columna debe satisfacer una expresión, y se especifica después del tipo de dato.
    ```sql
    -- Ejemplo
    create table productos(
        precio numeric constraint precio_positivo check (precio > 0)
    );
    ```
- #### Restricciones de tabla
    Se hacen varias restricciones de columna sobre una misma tabla.
    ```sql
    -- Ejemplo
    create table productos(
        precio numeric constraint precio_positivo check (precio > 0),
        cantidad numeric constraint cantidad_positiva check (cantidad > 0),
        constraint cantidad_precio_positivo check (cantidad * precio > 0) -- EJEMPLO!
    );
    ```
- #### default
- #### not null
- #### null
- #### unique
- #### primary key
  Equivalente a 'unique not null'.
  *Puede haber más de una clave primaria, es decir, que la clave primaria de la tabla sea la concatenación de ambas.*
- #### foreign key
  Representa la integridad referencial entre dos tablas.
- #### on update cascade / on delete cascade
## Práctica
### Ejercicio 1.
*/

-- Crear los dominios email y postcode en la base de datos, denominados
-- dominio_email y dominio_postcode respectivamente, de acuerdo a las
-- especificaciones proporcionadas.
create domain dominio_email as text check(
    value ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$'
);
-- br
create domain dominio_postcode as text check(
    value ~ '^[0-9]{5}$'
);

/*markdown
### Ejercicio 2.
*/

-- Añadir dos columnas a la tabla ‘fabricante’ denominadas email y postcode cuyos
-- tipos de datos serán dominio_email y dominio_postcode respectivamente.
alter table fabricante add column email dominio_email;
alter table fabricante add column postcode dominio_postcode;

/*markdown
### Ejercicio 3.
*/

-- Actualiza la información en la tabla ‘fabricante’ de acuerdo a los datos de la
-- siguiente tabla.
-- fabricante |  email | postcode
-- Kingston | customerservice@kingston.eu | 92200
-- Digi-key | spainsupport@digikey.com | 44640
-- Intel | intelsupport@intel.com | 55232
-- AMD | amdcustomer@amd.com | 35467
-- Tesla | teslasupport@tesla.com | 39472
update fabricante set email = 'customerservice@kingston.eu', postcode = '92200' where fabricante.nombre = 'Kingston';
update fabricante set email = 'spainsupport@digikey.com', postcode = '44640' where fabricante.nombre = 'Digi-key';
update fabricante set email = 'intelsupport@intel.com', postcode = '55232' where fabricante.nombre = 'Intel';
update fabricante set email = 'amdcustomer@amd.com', postcode = '35467' where fabricante.nombre = 'AMD';
update fabricante set email = 'teslasupport@tesla.com', postcode = '39472' where fabricante.nombre = 'Tesla';

/*markdown
### Ejercicio 4.
*/

-- Crea un nuevo dominio que represente el número de años de garantía para un pc
-- denominado dominio_anios_garantia. El valor deberá de ser mayor que 0 y menor
-- o igual que 3. Luego, añade una nueva columna a la tabla ‘pc’ denominada
-- ‘garantia’ de tipo ‘dominio_anios_garantia’ con un valor por defecto de 2.
create domain dominio_anios_garantia as integer check(
    value > 0 and value <= 3
);
alter table pc add column garantia dominio_anios_garantia default 2;

/*markdown
### Ejercicio 7
#### Ejercicio 7.4
*/

-- Presenta la capacidad y el precio de aquellos discos con un precio mayor o igual
-- que la media de todos los precios.
create or replace function getInfoPreciosDiscos() returns table(capacidad character varying(30), precio numeric(10, 2)) as $$
begin
    return query 
        select d.capacidad, d.precio 
        from disco as d 
        where d.precio >= (select avg(d2.precio) from disco as d2);
end;
$$ language plpgsql;
--
select getInfoPreciosDiscos();

/*markdown
#### Ejercicio 7.5
*/

-- Presenta el nombre de todos aquellos fabricantes que realicen más de un tipo
-- de disco.
create or replace function getInfoFabricante() returns table(nombre character varying(100)) as $$
begin
    return query 
        select f.nombre from fabricante as f
        inner join disco using (id_fabricante)
        group by f.nombre
        having count(distinct id_disco) > 1;
end;
$$ language plpgsql;
--
select getInfoFabricante();

/*markdown
#### Ejercicio 7.6
*/

-- Presenta toda la inormación de aquellos pc’s que tengan la tarjeta gráfica más
-- barata.
create or replace function getInfoPcs() returns table(
    id_tarjeta_grafica integer, id_pc integer, id_cpu integer, id_disco integer, 
    id_memoria integer, garantia dominio_anios_garantia,
    descripcion character varying(100), precio numeric(10, 2),
    id_fabricante integer, id_tipo_memoria integer
    ) as $$
begin
    return query
        select * from pc
        natural join tarjeta_grafica as tg
        where tg.precio = (select min(tg2.precio) from tarjeta_grafica as tg2);
end;
$$ language plpgsql;
--
select getInfoPcs();

/*markdown

*/

/*markdown
### Ejercicio 8
*/

-- Crea un trigger denominado ‘presenta_info_pc’, donde cada vez que se realice una
-- operación de insert (‘INSERT’), delete (‘DELETE’) o update (‘UPDATE’) en la
-- tabla ‘pc’, se presente un mensaje. Realiza una operación de cada uno de los tipos
-- mencionados en la tabla ‘pc’, con el fin de verificar que el mensaje se realiza.
create or replace function presenta_info_pc() returns trigger as
$$
begin
    if tg_op = 'UPDATE' then
        raise notice 'Se ha actualizado un registro de la tabla pc';
        return new;
    elsif tg_op = 'DELETE' then
        raise notice 'Se ha eliminado un registro de la tabla pc';
        return old;
    else
        raise notice 'Se ha insertado un registro en la tabla pc';
        return new;
    end if;
end;
$$ language plpgsql;
-- div
create or replace trigger presenta_info_pc 
after insert or delete or update on pc
for each row execute procedure presenta_info_pc(); 
-- test
insert into pc values(8, 500, 600, 300, 700, 1);
update pc set id_disco = 602 where id_pc = 8;
delete from pc where id_pc = 8;

/*markdown
### Ejercicio 5
*/

-- Presentar el nombre y el país de aquellos proveedores que suministren todas las
-- memorias. (división)
select distinct nombre, pais
from proveedor as p
where not exists(
    (
        select id_memoria
        from memoria
    ) except (
        select id_memoria
        from memoria as m
        inner join proveedor_memoria as pm using (id_memoria)
        where pm.id_proveedor = p.id_proveedor
    )
);