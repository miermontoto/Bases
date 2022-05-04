/*markdown
# Sesión 6
## Teoría
### Funciones
*/

-- Función de ejemplo:
create or replace function getEstudianteId(nombreEstudiante text) returns int as $$
    declare
        estudianteId int;
    begin
        select estudiante_id into estudianteId from estudiante 
            where estudiante.estudiante_nombre = nombreEstudiante;
        return estudianteId;
    end;
$$ language plpgsql;

-- Se llama a la función de ejemplo:
select getEstudianteId('Juan');

-- Presentar el id de todos los estudiantes:
select estudiante_id from estudiante as est
where getEstudianteId(est.estudiante_nombre) > 0;

/*markdown
#### Funciones de tabla
*/

-- Ejemplo de función de tabla
create or replace function getProfesoresDepartamento(id int)
    returns table(profesorId int, profesorNombre varchar(30)) as $$
    begin 
    return query select profesor_id, profesor_nombre from profesor 
        where profesor.departamento_id = id;
end;
$$ language plpgsql;

-- Ejemplo de invocación de la función anterior
select getProfesoresDepartamento(2);

/*markdown
#### Parámetros y excepciones
*/

-- La misma función de tabla anterior pero con manejo de errores.
create or replace function getProfesoresDepartamentov2(id int)
    returns table(profesorId int, profesorNombre varchar(30)) as $$
    begin
    return query select profesor_id, profesor_nombre from profesor 
        where profesor.departamento_id = id;
    if not found
        then raise exception 'No hay ningún profesor en el departamento %.', id;
    end if;
end;
$$ language plpgsql;

select getProfesoresDepartamentov2(4);

/*markdown
#### Alias
*/

-- Misma función que en el ejemplo anterior pero declarando guardando el parámtro de entrada
-- en una variable local.
create or replace function getProfesoresDepartamentov3(id int)
    returns table(profesorId int, profesorNombre varchar(30)) as $$
    declare id_aux alias for id;
    begin
        return query select profesor_id, profesor_nombre from profesor 
            where profesor.departamento_id = id;
        if not found
            then raise exception 'No hay ningún profesor en el departamento %.', id_aux;
    end if;
end;
$$ language plpgsql;

select getProfesoresDepartamentov3(4);

/*markdown
#### Consultas con for
*/

-- Ejemplo de función con interación mediante for
create or replace function getNumeroProfesoresDepartamento(id int)
    returns int as $$
    declare r record; n int default 0;
    begin
        for r in
            select * from profesor as pro 
            where pro.departamento_id = id
        loop
            n = n + 1;
        end loop;
        return n;
    end;
$$ language plpgsql;

select getNumeroProfesoresDepartamento(1);

/*markdown
#### Función con for e if
*/

create or replace function getNumeroProfesoresDepartamentov2(id int)
    returns int as $$
    declare r record; n int default 0;
    begin
        for r in
            select * from profesor as pro
        loop
            if r.departamento_id = id then 
                n = n + 1;
            end if;
        end loop;
        return n;
    end;
$$ language plpgsql;

select getNumeroProfesoresDepartamentov2(1);

/*markdown
### Procedimientos
#### Ejemplo de procedimiento
*/

-- Procedimiento con el mismo objetivo que las funciones anteriores.
create or replace procedure getNumeroProfesoresDepartamentov3(id int, inout total_profesores int)
    as $$
    begin
        select count(*) into total_profesores from profesor as pro
        where pro.departamento_id = id;
    end;
$$ language plpgsql;

call getNumeroProfesoresDepartamentov3(1, 0);
call getNumeroProfesoresDepartamentov3(1, 27);
-- Ambos devuelven lo mismo porque la consulta sobreescribe el valor
-- del parámtro inout.

do $$ -- En psql devuelve: "NOTICE:  result = 9"
    declare result int;
    begin
        call getNumeroProfesoresDepartamentov3(1, result);
        raise notice 'result = %', result;
    end;
$$;

/*markdown
#### Procedimiento con while
*/

create or replace procedure getProfesoresDepartamento(id int, n int) as $$
    declare r record; i integer default 0;
    begin
        while i <> n loop
            i = i + 1;
            select * into r from profesor as pro
                where pro.departamento_id = id and pro.profesor_id = i;
            raise notice '(%, %, %)', r.profesor_id, r.profesor_nombre, r.profesor_apellidos;
        end loop;
    end;
$$ language plpgsql;

call getProfesoresDepartamento(1, 2);
-- En psql devuelve:
-- NOTICE:  (1, Jorge, Diez Pelaez)
-- NOTICE:  (2, Pedro, Hernandez Arauzo)

/*markdown
#### Procedimiento con for
*/

-- Funcionalmente idéntico al procedimiento anterior, pero reemplazando el while con for.
create or replace procedure getProfesoresDepartamentov2(id int, n int) as $$
    declare r record; i integer default 0;
    begin
        for i in 1..n loop
            select * into r from profesor as pro
                where pro.departamento_id = id and pro.profesor_id = i;
            raise notice '(%, %, %)', r.profesor_id, r.profesor_nombre, r.profesor_apellidos;
        end loop;
    end;
$$ language plpgsql;

call getProfesoresDepartamentov2(1, 2);
-- En psql devuelve lo mismo que el ejemplo anterior.

/*markdown
#### Procedimiento con array
*/

create or replace procedure getNombreDepartamentos(int []) as $$
    declare r record; i integer default 0;
    begin
        foreach i in array $1 loop
            select * into r from departamento as dep
                where dep.departamento_id = i;
            raise notice '(%, %)', r.departamento_id, r.departamento_nombre;
        end loop;
    end;
$$ language plpgsql;

call getNombreDepartamentos(array[1, 2]);
-- En psql devuelve:
-- NOTICE:  (1, Ciencias de la Computacion)
-- NOTICE:  (2, Matematicas)
--
-- Si se le da la vuelta al vector con el que se llama a la función,
-- el resultado del procedimiento se invierte, por lo que el orden importa.
--
-- Para ver todo el contenido de la tabla (en este caso), se puede hacer:
-- call getNombreDepartamentos(array[1, 2, 3, 4]);

/*markdown
## Prácticas
### Ejercicio 2
#### Ejercicio 2.1
*/

create or replace function getInfoGrados() 
    returns table(gradoNum smallint, gradoNombre varchar(30)) as $$
    begin
        return query
            select gra.numero_estudiantes, gra.grado_nombre
            from grado as gra 
            where numero_estudiantes = (select min(numero_estudiantes) from grado);
    end;
$$ language plpgsql;
select getInfoGrados();

/*markdown
#### Ejercicio 2.2
*/

create or replace function getAulas() returns table(nombre varchar(30), capacidad bigint) as $$
    begin
        return query
            select au.aula_nombre, count(*)
            from aula au, profesor pro, modulo_profesor_aula mta
            where au.aula_id=mta.aula_id and mta.profesor_id=pro.profesor_id
            group by(au.aula_id)
            having count(pro.profesor_id) >2;
    end;
$$ language plpgsql;
select getAulas();

/*markdown
#### Ejercicio 2.3
*/

create or replace function getGradoMinEstudiantes() returns table(gradoNombre varchar(30), gradoNum bigint) as $$
    begin
        return query
            select gra.grado_nombre, count(*) from grado gra inner join
            estudiante_grado_modulo using(grado_id) inner join modulo mod
            using(modulo_id) group by grado_id having (count(*)) <= all
            (select count(*) from grado gra inner join estudiante_grado_modulo using
            (grado_id) inner join modulo using(modulo_id) group by gra.grado_id);
    end;    
$$ language plpgsql;
select getGradoMinEstudiantes();

/*markdown
### Ejercicio 3
#### Ejercicio 3.1
*/

create or replace procedure getCapacidadTotalAula(inout numero_asientos int) as $$
    begin
        select sum(capacidad) into numero_asientos from aula;
    end;
$$ language plpgsql;
call getCapacidadTotalAula(0);

/*markdown
#### Ejercicio 3.2
*/

    -- Procedimiento que devuelva una lista con los nombres y apellidos de aquellos estudiantes
-- que estén cursando 'Ingeniería Quimica Industrial' y también aquellos que estén en erasmus.
create or replace procedure getEstudiantesIngenieriaIndustrial() as $$
    declare r record;
begin
    for r in
        select estudiante_nombre, estudiante_apellidos from estudiante est
        inner join estudiante_grado_modulo egm using(estudiante_id)
        inner join grado gra using(grado_id)
        where lower(gra.grado_nombre) = 'ingenieria quimica industrial'
        union
        select estudiante_nombre, estudiante_apellidos from estudiante est where
        est.erasmus=true
    loop
        raise notice '% %', r.estudiante_nombre, r.estudiante_apellidos;
    end loop;
end;
$$ language plpgsql;
call getEstudiantesIngenieriaIndustrial();
-- Resultado:
-- NOTICE: Sara Prendes Pardo
-- NOTICE: Juan Prieto Vazquez
-- NOTICE: Pedro Gancedo Alvarez
-- NOTICE: Maria Alvarez Gomez

/*markdown
#### Ejercicio 3.3
*/

-- Escribe un procedimiento denominado
-- getProfesoresComputacionNoAlgoritmia(n int) que presente el nombre y los
-- apellidos de los ‘n’ primeros profesores que pertenezcan al departamento ‘Ciencias
-- de la Computacion’, pero sin tener en cuenta aquellos que imparten el módulo de
-- ‘Algoritmia’.
create or replace procedure getProfesoresComputacionNoAlgoritmia(n int) as $$
    declare r record; i integer default 0;
    begin
        for i in 1..n loop
            select * into r from (
                select profesor_nombre, profesor_apellidos from profesor pro
                inner join departamento dep using(departamento_id)
                where dep.departamento_nombre= 'Ciencias de la Computacion'
                except
                select profesor_nombre, profesor_apellidos from profesor pro
                inner join modulo_profesor_aula mpa using(profesor_id)
                inner join modulo mod using(modulo_id)
                where lower(mod.modulo_nombre)='algoritmia') as t
                offset i-1 limit 1;
            raise notice '(%, %)', r.profesor_nombre, r.profesor_apellidos;
        end loop;
    end;
$$ language plpgsql;
call getProfesoresComputacionNoAlgoritmia(4);
-- Resultado:
-- NOTICE: (Jose, Garcia Fanjul)
-- NOTICE: (Pablo, Suarez-Otero Gonzalez)
-- NOTICE: (Maria Jose, Suarez Cabal)
-- NOTICE: (Cristian Augusto, Alonso)