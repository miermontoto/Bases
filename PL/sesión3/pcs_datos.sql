/* Descargar el fichero script pcs_datos del Campus Virtual.

Para insertar datos en la BD pcs. 

1. Desde la BD pcs utilizar el comando del psql  \i  y a continuación arrastrar el fichero descargado script pcs_datos,
2. En el path del fichero cambiar las barras \ por barras / 
3. Pulsar la tecla ENTER para ejecutar este script.  

*/


/*Author: Cristian Augusto

University of Oviedo, Gijon 2021,

Databases Subject*/

\c pcs;

DELETE FROM pcs;

DELETE FROM memoria;

DELETE FROM tgrafica;

DELETE FROM tipo_memoria;

DELETE FROM disco;

DELETE FROM cpu;

DELETE FROM tipo_procesador;

DELETE FROM fabricante;

 

 

/* damos de alta fabricantes,

Micron es fabricante de discos y de memorias,

samsung de discos y memorias, intel de procesadores Y discos

AMD procesadores y graficas

NVIDIA procesadores y graficas

Seagate discos duros

*/

 

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Samsung', 'Parque Empresarial Omega (Avda. de Barajas), 32 - Edif. C', '914143700','A59308114');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Intel', 'Pl. Pablo Ruiz Picasso, 1 - Torre Picasso.', '914329090','A28819381');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Micron', 'London Road Bracknell, Berkshire RG12 2AA REINO UNIDO', '800099443','G54397814');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('AMD', 'One AMD Place, P.O. Box 3453, Sunnyvale, California, 94088-3453', '56229410300','B86833571');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Nvidia', 'Pase Garcia i Faria 75, Barcelona', '34902848767','N0069374G');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Seagate', 'Paseo de la Castellana 5, Madrid', '80047324283','N8260479D');

INSERT INTO fabricante (id_fabricante, direccion, telf, CIF)

VALUES ('Kingston', 'Calle Santa Susana, 55 - LOC 11, Madrid', '881968083','B83437012');

 

 

/*Damos de alta las diferentes tipos de  memorias (para la RAM y para las gráficas ) */

INSERT INTO tipo_memoria (id_tipo_memoria, descripcion)

VALUES ('GDDR5', 'Memoria lanzada en 2008');

INSERT INTO tipo_memoria (id_tipo_memoria, descripcion)

VALUES ('GDDR6', 'Memoria lanzada en 2020');

INSERT INTO tipo_memoria (id_tipo_memoria, descripcion)

VALUES ('DDR3', 'Memoria lanzada en 2007');

INSERT INTO tipo_memoria (id_tipo_memoria, descripcion)

VALUES ('DDR4', 'Memoria lanzada en 2020');

 

/*Tipos de procesador */

 

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('SkyLake', 'Intel lanzados en 2015-Usan DDR3',14);

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('KabyLake', 'Intel lanzados en 2016-Usan DDR4',14);

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('CommetLake', 'Intel anzados en 2020-Usan DDR4',7);

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('Zen', 'AMD anzados en 2017-Usan DDR4',14);

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('Zen2', 'AMD anzados en 2019-Usan DDR4',7);

INSERT INTO tipo_procesador (id_tipo_procesador, descripcion,t_litografia)

VALUES ('Zen3', 'AMD anzados en 2020-Usan DDR4',7);

 

/*Memorias */

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('CrucialBSP8G', 'DDR4','Micron',8,3000);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('CrucialBSP16G', 'DDR4','Micron',16,3000);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('CrucialBSP32G', 'DDR4','Micron',32,3000);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('CrucialBSP64G', 'DDR4','Micron',64,3000);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('SamsungSODIM16', 'DDR4','Samsung',16,2400);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('SamsungSODIM32', 'DDR4','Samsung',32,2400);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('KingstonFury8G', 'DDR3','Kingston',8,1800);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('KingstonFury32G', 'DDR3','Kingston',32,1800);

INSERT INTO memoria (id_memoria, id_tipo_memoria,id_fabricante,capacidad,velocidad)

VALUES ('KingstonFury4G', 'DDR3','Kingston',4,1800);

 

 

/*Tarjetas Gráficas */

INSERT INTO tgrafica (id_tarjeta_grafica,id_tipo_memoria, id_fabricante, capacidad, descripcion)

VALUES ('R380X', 'GDDR5','AMD',4,'Tarjeta de 28nm lanzada en 2015');

INSERT INTO tgrafica (id_tarjeta_grafica,id_tipo_memoria, id_fabricante, capacidad, descripcion)

VALUES ('GTX970', 'GDDR5','Nvidia',4,'Tarjeta de 28nm lanzada en 2014');

INSERT INTO tgrafica (id_tarjeta_grafica,id_tipo_memoria, id_fabricante, capacidad, descripcion)

VALUES ('GTX3080', 'GDDR6','Nvidia',10,'Tarjeta de 8nm lanzada en 2020');

INSERT INTO tgrafica (id_tarjeta_grafica,id_tipo_memoria, id_fabricante, capacidad, descripcion)

VALUES ('RTX2070', 'GDDR6','Nvidia',8,'Tarjeta de 12nm lanzada en 2019');

INSERT INTO tgrafica (id_tarjeta_grafica,id_tipo_memoria, id_fabricante, capacidad, descripcion)

VALUES ('6900XT', 'GDDR6','AMD',16,'Tarjeta de 7nm lanzada en 2020');

 

/*Discos Duros*/

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('HDBarracuda2TB', 'HDD 7200RPM',2000,'Seagate');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('SSD860Evo240G', 'SSD SATA 500MB/S',240,'Samsung');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('SSD960Evo1TB', 'SSD M2 NVME',1000,'Samsung');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('A400513G', 'SSD SATA 500MB/S',512,'Kingston');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('S7512G', 'SSD M2 NVME',512,'Intel');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('MX500512G', 'SSD SATA 500MB/S',500,'Micron');

INSERT INTO disco (id_disco,descripcion,capacidad,id_fabricante)

VALUES ('P12TB', 'SSD M2 NVME',2000,'Micron');

 

/*Procesadores*/

 

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('I76700', 'Procesador Intel familia Skylake','Intel','SkyLake');

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('I57600K','Procesador Intel para Overclocking', 'Intel','KabyLake');

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('I77700K','Procesador Intel para Overclocking', 'Intel','KabyLake');

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('I710700','Procesador Intel para Overclocking', 'Intel','CommetLake');

 

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('Ryzen1700', 'Ryzen 14nm','AMD','Zen');

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('Ryzen2700x', 'Ryzen 12nm','AMD','Zen2');

INSERT INTO cpu (id_cpu,descripcion,id_fabricante,id_tipo_procesador)

VALUES ('Ryzen3700x', 'Ryzen 7nm','AMD','Zen3');

 

/*PCs

INFO INTERESANTE: Crucial=Micron

 

Gráficas disponibles: R380X GTX970 GTX3080 RTX2070 6900XT

Discos disponibles:  HDBarracuda2TB SSD860Evo240G SSD960Evo1TB A400513G S7512G MX500512G P12TB

Memoria disponible: DDR4:CrucialBSP8G CrucialBSP16G CrucialBSP32G CrucialBSP64G

                    SamsungSODIM16 SamsungSODIM32 DDR3:KingstonFury8G KingstonFury32G KingstonFury4G

Procesadores disponibles: I76700 I57600K I77700K I710700 Ryzen1700 Ryzen2700x Ryzen3700x

 

Preguntas posibles:

Cuantos ordenadores tienen procesador y grafica fabricados por AMD?

Lista los ordenadores que tengan el almacenamiento (memorias y disco duro) fabricados por Micron

Agrupa los ordenadores por el fabricante del procesador y muestra su precio promedio

Cuantos ordenadores hay que tengan al menos 16 GB de memoria y 250gb de disco duro?

Lista los ordenadores junto con su memoria,procesador,grafica y disco duro, el fabricante de los mismos y su precio

Muestra el fabricante del procesador más caro.

Se desea saber que memorias estan en desuso, lista aquellas que no use ningun ordenador

Muestra aquellos ordenadores cuyo procesador y disco duro esta fabricado por intel

*/ 

 

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0001','I76700','HDBarracuda2TB','GTX970','KingstonFury32G',500);

 

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0002','Ryzen3700x','P12TB','GTX3080','CrucialBSP64G',2500);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0003','Ryzen3700x','MX500512G','6900XT','CrucialBSP16G',1900);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0004','Ryzen3700x','MX500512G','R380X','CrucialBSP32G',900);

INSERT INTO pcs (pcid,cpu,disco,memoria,precio)

VALUES ('pc0005','I76700','SSD860Evo240G','KingstonFury8G',1100);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0006','I77700K','S7512G','6900XT','SamsungSODIM32',1300);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0007','Ryzen2700x','A400513G','6900XT','CrucialBSP16G',1500);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0008','Ryzen1700','HDBarracuda2TB','R380X','CrucialBSP16G',400);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0009','I710700','A400513G','RTX2070','CrucialBSP32G',1600);

INSERT INTO pcs (pcid,cpu,disco,tgrafica,memoria,precio)

VALUES ('pc0010','Ryzen3700x','SSD960Evo1TB','GTX3080','CrucialBSP64G',2600);

INSERT INTO pcs (pcid,cpu,disco,memoria,precio)

VALUES ('pc0011','I710700','SSD960Evo1TB','CrucialBSP64G',2000);
