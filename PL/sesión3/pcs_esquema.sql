/* Descargar el fichero script pcs_esquema del Campus Virtual.

Para crear el esquema de la BD pcs.

1. Desde la BD pcs utilizar el comando del psql  \i  y a continuación arrastrar el fichero descargado script pcs_esquema,
2. En el path del fichero cambiar las barras \ por barras / 
3. Pulsar la tecla ENTER para ejecutar este script.  

*/

/*Author: Cristian Augusto
University of Oviedo, Gijon 2021,
Databases Subject*/
\c template1;
drop database pcs;
create database pcs;
\c pcs;
/* Tabla de fabricantes, ira linkeada  a las otras*/
CREATE TABLE fabricante (id_fabricante VARCHAR(20) NOT NULL PRIMARY KEY,
direccion VARCHAR(80) NOT NULL,telf VARCHAR(15) NOT NULL, CIF VARCHAR (9));

/* Tabla de tipo de memoria, ira linkeada a memoria y gráfica*/
CREATE TABLE tipo_memoria (id_tipo_memoria VARCHAR(20) NOT NULL PRIMARY KEY, 
descripcion VARCHAR (100));
/* Tabla tipo_procesador, a la que van linkeadas tanto las tarjetas graficas como los procesadores*/
CREATE TABLE tipo_procesador(id_tipo_procesador VARCHAR(20) NOT NULL PRIMARY KEY, descripcion VARCHAR (100), 
t_litografia INTEGER NOT NULL);

/* Tabla de tipo de memoria, ira linkeada a memoria y gráfica, relaccion 1 a N tipo de memoria-memoria*/
CREATE TABLE memoria (id_memoria VARCHAR(20) NOT NULL PRIMARY KEY,
id_tipo_memoria VARCHAR(20) NOT NULL,id_fabricante VARCHAR(20) NOT NULL, capacidad INTEGER NOT NULL,velocidad INTEGER NOT NULL,
FOREIGN KEY (id_tipo_memoria) REFERENCES tipo_memoria (id_tipo_memoria), 
FOREIGN KEY (id_fabricante) REFERENCES fabricante (id_fabricante));

/* Tabla de tipo de tgrafica, ira linkeada a tipo_memoria, relaccion 1 a N tipo de memoria-memoria 
y fabricante-memoria (1 a N)*/
CREATE TABLE tgrafica (id_tarjeta_grafica VARCHAR(20) NOT NULL PRIMARY KEY,
id_tipo_memoria VARCHAR(20) NOT NULL,id_fabricante VARCHAR(20) NOT NULL,
FOREIGN KEY (id_tipo_memoria) REFERENCES tipo_memoria (id_tipo_memoria), 
FOREIGN KEY (id_fabricante) REFERENCES fabricante (id_fabricante),
capacidad INTEGER NOT NULL, descripcion VARCHAR(100));

/* Tabla de tipo de disco, ira linkeada fabricante-disco (1 a N)*/
CREATE TABLE disco (id_disco VARCHAR(20) NOT NULL PRIMARY KEY,
descripcion VARCHAR(100),
capacidad INTEGER NOT NULL,
id_fabricante VARCHAR(20) NOT NULL,
FOREIGN KEY (id_fabricante) REFERENCES fabricante (id_fabricante));

/* Tabla de tipo de disco, ira linkeada fabricante-disco (1 a N), un procesador tiene  una tipo_procesador, la cual tiene un tamaño (litografia)
y una descripcion*/
CREATE TABLE cpu (id_cpu VARCHAR(20) NOT NULL PRIMARY KEY,
descripcion VARCHAR(100),
id_fabricante VARCHAR(20) NOT NULL,
FOREIGN KEY (id_fabricante) REFERENCES fabricante (id_fabricante),
id_tipo_procesador VARCHAR(20) NOT NULL,
FOREIGN KEY (id_tipo_procesador) REFERENCES tipo_procesador (id_tipo_procesador));


CREATE TABLE pcs (pcid VARCHAR(20) NOT NULL PRIMARY KEY,
cpu VARCHAR(20) NOT NULL,disco VARCHAR(20),
tgrafica VARCHAR(20) ,memoria VARCHAR(20) NOT NULL,
precio DECIMAL(10, 2),
FOREIGN KEY (cpu) REFERENCES cpu (id_cpu),
FOREIGN KEY (disco) REFERENCES disco (id_disco),
FOREIGN KEY (tgrafica) REFERENCES tgrafica (id_tarjeta_grafica),
FOREIGN KEY (memoria) REFERENCES memoria (id_memoria));
