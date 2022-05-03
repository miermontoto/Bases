/*markdown
### Exercise 1
*/

-- Design a function name ‘getfirstinvention’, which display the name of the first invention, the
-- year of the invention, its description, and the name of the person who did it.
create or replace function getfirstinvention() returns table(
        inventionName character varying(50), year integer, 
            description character varying(100), inventorName character varying(50)
    ) 
as $$
begin
    return query
        select t.invention_name, t.invention_year, t.description, p.inventor_name
        from inventioninventor as tp
        inner join invention as t using (id_invention)
        inner join inventor as p using (id_inventor)
        order by t.invention_year asc
        limit 1;
end;
$$ language plpgsql;

-- Write the call to the function to get the result below
select getfirstinvention();

/*markdown
### Exercise 2
*/

-- 2. Design a function name ‘getinventorscentre’, which displays the name of those inventors who
-- studied in a specific centre given as a parameter, and also their occupation. Moreover, it has
-- to be taken into account that if the name of the centre provided does not exist in the database
-- an error has to come up.
create or replace function getinventorscentre(centreName character varying(100)) returns table(
        inventorName character varying(50), occupation character varying(50)
    ) as $$
begin
    if not exists (select * from workplace where lower(workplace_name) = lower(centreName)) then
        raise exception 'The centre name provided does not exist in the database';
    end if;
    return query
        select p.inventor_name, p.occupation
        from inventorworkplace as pw
        inner join inventor as p using (id_inventor)
        inner join workplace as w using (id_workplace)
        where lower(centreName) = lower(w.workplace_name);
end;
$$ language plpgsql;

-- Write the call to the function to get the result below.
-- The example result is incorrect, 'MIT' does not exist in the provided database and
-- as such the function should raise an exception. The inventors in the example are
-- asigned to other workplaces.
select getinventorscentre('University of Pennsylvania');

/*markdown
### Exercise 3
*/

-- 3. Design a procedure to display the name of those inventions created between an interval of
-- years [year1, year2], provided as parameters, the year of the invention, and the name of the
-- inventors.
create or replace procedure getinventionsbetweenyears(y1 integer, y2 integer) as $$
declare r record;
begin
    for r in 
        select t.invention_name, t.invention_year, p.inventor_name
        from inventioninventor as tp
        inner join invention as t using (id_invention)
        inner join inventor as p using (id_inventor)
        where t.invention_year between y1 and y2
    loop
        raise notice '% % %', r.invention_name, r.invention_year, r.inventor_name;
    end loop;
end;
$$ language plpgsql;

-- Write call to the procedure to display the information required.
call getinventionsbetweenyears(1980, 2000);

/*markdown
### Exercise 4
*/

-- Every time an insert, update or delete operations are performed on the table ‘inventor’, it is
-- required their registration. For this purpose, a table name ‘operation_inventor_log’ has to be
-- created with the following fields:
--
-- operation char(1)
-- stamp timestamp
-- inventor_name varchar(50)
-- occupation varchar(100)
create table operation_inventor_log(
    operation char(1),
    stamp timestamp,
    inventor_name varchar(50),
    occupation varchar(100)
);

/*markdown
### Exercise 5
*/

-- Create a trigger that every time an inventor is created, updated or deleted, a message has to
-- come up.
create or replace function operation_inventor_log_trigger() returns trigger as $$
begin
    if (TG_OP = 'INSERT') then
        insert into operation_inventor_log values ('I', now(), new.inventor_name, new.occupation);
        raise notice '% % %', 'Inserted', new.inventor_name, new.occupation;
    elsif (TG_OP = 'UPDATE') then
        insert into operation_inventor_log values ('U', now(), new.inventor_name, new.occupation);
        raise notice '% % %', 'Updated', new.inventor_name, new.occupation;
    elsif (TG_OP = 'DELETE') then
        insert into operation_inventor_log values ('D', now(), old.inventor_name, old.occupation);
        raise notice '% % %', 'Deleted', old.inventor_name, old.occupation;
    end if;
    return null;
end;
$$ language plpgsql;
--
create or replace trigger operation_inventor_log_trigger
after insert or update or delete on inventor
for each row execute procedure operation_inventor_log_trigger();

/*markdown
### Exercise 6
*/

-- 1. Insert data
insert into inventor values (207, 'Tim Berners Lee', 'London', 1955, 'Computer Science scientist');
-- 2. Modify data
update inventor set inventor_name = 'Timothy Berners-Lee' where id_inventor = 207;
-- 3. Delete data
delete from inventor where id_inventor = 207;
--
select * from operation_inventor_log;

/*markdown
### Ejercicio 7
*/

-- Display the information of all those inventors where all their inventions have an invention
-- year higher than 1945. (division)
select distinct *
from inventor as p
where not exists (
    select id_invention
    from inventioninventor as tp
    inner join invention as t using (id_invention)
    where t.invention_year < 1945 and p.id_inventor = tp.id_inventor
);