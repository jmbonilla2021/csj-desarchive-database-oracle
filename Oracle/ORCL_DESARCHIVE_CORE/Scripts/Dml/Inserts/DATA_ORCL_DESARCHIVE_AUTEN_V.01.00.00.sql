
PROMPT ****** INSERTANDO ESTADO_SECCIONAL ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_SECCIONAL (ID_ESTADO_SECCIONAL,NOMBRE) values (SEQ_ESTADO_SECCIONAL.NEXTVAL,'ACTIVO');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_SECCIONAL (ID_ESTADO_SECCIONAL,NOMBRE) values (SEQ_ESTADO_SECCIONAL.NEXTVAL,'INACTIVO');
COMMIT;

PROMPT ****** INSERTANDO ESTADO_USUARIO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_USUARIO (ID_ESTADO_USUARIO,NOMBRE) values (SEQ_ESUSU.NEXTVAL,'ACTIVO');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_USUARIO (ID_ESTADO_USUARIO,NOMBRE) values (SEQ_ESUSU.NEXTVAL,'INACTIVO');
COMMIT;

PROMPT ****** INSERTANDO ESTADO_ROL ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_ROL (ID_ESTADO_ROL,NOMBRE) values (SEQ_ESROL.NEXTVAL,'ACTIVO');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_ROL (ID_ESTADO_ROL,NOMBRE) values (SEQ_ESROL.NEXTVAL,'INACTIVO');
COMMIT;

PROMPT ****** INSERTANDO ESTADO_MENU ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_MENU (ID_ESTADO_MENU,NOMBRE) values (SEQ_MENU.NEXTVAL,'ACTIVO');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_MENU (ID_ESTADO_MENU,NOMBRE) values (SEQ_MENU.NEXTVAL,'INACTIVO');
COMMIT;

PROMPT ****** INSERTANDO ESTADO_GRUPO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_GRUPO (ID_ESTADO_GRUPO,NOMBRE) values (SEQ_ESTADO_GRUPO.NEXTVAL,'ACTIVO');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ESTADO_GRUPO (ID_ESTADO_GRUPO,NOMBRE) values (SEQ_ESTADO_GRUPO.NEXTVAL,'INACTIVO');
COMMIT;

PROMPT ****** INSERTANDO CARGO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'DESAROLLADOR JQQ','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'ANALISTA FUNCIONAL','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'LÍDER DESARROLLO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'CARGO DE ANALISTA','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'DIRECT0R','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'GERENTE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'CARGO DE TESTEO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'JEFE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'SUPERVISOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.CARGO (ID_CARGO,NOMBRE,ES_ACTIVO) values (SEQ_CARGO.NEXTVAL,'COORDINADORES DE TESTEO','1');
COMMIT;

PROMPT ****** INSERTANDO GRUPO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'PRUEBA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'PRUEBA2','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'MAGISTRADOS','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'RELATOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'MAGISTRADO PONENTE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'SECRETARIO AUXILIAR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'SECRETARIO GENERAL','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'MAGISTRADO DE SALA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'GRUPO DE PRUEBA 36','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'12345678901234567890123456789012345678901234567890','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'SECRETARIO SUPLENTE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'SECRETARIO AUXILIAR DOS','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'RELATOR SUPLENTE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'NUEVO GRUPO DE TESTEO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'MAGISTRADOS DE TESTEO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'MAGISTRADOS DE TESTEO 91','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'PRACTICANTE','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'ESTUDIANTES DE DERECHO','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'COORDINADOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'GRUPO DE COORDINADORES','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.GRUPO (ID_GRUPO,NOMBRE,ID_ESTADO_GRUPO) values (SEQ_GRUPO.NEXTVAL,'TODOS','1');
COMMIT;

PROMPT ****** INSERTANDO DEPARTAMENTO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'ATLANTICO','0001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'BOYACA','0001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'BOLIVAR','0001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'CUNDINAMARCA','0001','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'GUAJIRA','0001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'VALLE','0002','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'GUAINIA','0090','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'TOLIMA','123456789','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'ANTIOQUIA','116','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'VAUPES','009','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'VILLVAVO','116','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'META','001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'PASTO','890','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'GUAVIARE','006','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'SAN JOSE','116','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'CASANARE','116','0');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'SAN JOSE DEL GUAVIARE','212','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'CAUCA','001','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'MONTERIA','009','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (ID_DEPARTAMENTO,NOMBRE,CODIGO,ES_ACTIVO) values (SEQ_DEPARTAMENTO.NEXTVAL,'AAAA','116','0');
COMMIT;

PROMPT ****** INSERTANDO MUNICIPIO ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'0001','BOGOTA','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'BOGO','BOGOTÁ','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'0876','GUATEQUE','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'0004','VILLETE','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'9019','AUXILIAR DE BARANDA','5');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'1262','GRUPO DE TESTEO','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'0013','ZIPAQUIRA','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'700090','MANTA','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'21221','TIBIRITA','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'9121','CAJICA','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'098133','MACHETA','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'76634','VILLA PINZO','4');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (ID_MUNICIPIO,CODIGO,NOMBRE,ID_DEPARTAMENTO) values (SEQ_MUNICIPIO.NEXTVAL,'763464','PALOMINO','5');
COMMIT;

PROMPT ****** INSERTANDO SECCIONAL ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL BOGOTA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL BOYACA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL CARTAGENA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL VALLE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL CUNDINAMARCA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL  PUTUMAYO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL AMAZONAS','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL PASTO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL MEDELLIN','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL DEL SUR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCCIONAL DE NORTE','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL TOLIMA','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL DE NORTE','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL DE ANTIOQUIA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL DE PRUEBA DE TESTEO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.SECCIONAL (ID_SECCIONAL,NOMBRE,ID_ESTADO_SECCIONAL) values (SEQ_SECCIONAL.NEXTVAL,'SECCIONAL DE JUEVES DE TESTEO','2');
COMMIT;

PROMPT ****** INSERTANDO DEPENDENCIA ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPENDENCIA (ID_DEPENDENCIA,CODIGO,NOMBRE,ES_DESPACHO_JUDICIAL,ID_SECCIONAL,ID_MUNICIPIO,NUMERO_CUENTA) values (SEQ_DEPENDENCIA.NEXTVAL,'98878','RECURSOS HUMANOSS','0','2','3','877779');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPENDENCIA (ID_DEPENDENCIA,CODIGO,NOMBRE,ES_DESPACHO_JUDICIAL,ID_SECCIONAL,ID_MUNICIPIO,NUMERO_CUENTA) values (SEQ_DEPENDENCIA.NEXTVAL,'8766','RECURSOS HUMANOS','1','6','3','89765');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPENDENCIA (ID_DEPENDENCIA,CODIGO,NOMBRE,ES_DESPACHO_JUDICIAL,ID_SECCIONAL,ID_MUNICIPIO,NUMERO_CUENTA) values (SEQ_DEPENDENCIA.NEXTVAL,'1216','DEPENDENCIA FAMILIAR','1','6','2','1222112');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPENDENCIA (ID_DEPENDENCIA,CODIGO,NOMBRE,ES_DESPACHO_JUDICIAL,ID_SECCIONAL,ID_MUNICIPIO,NUMERO_CUENTA) values (SEQ_DEPENDENCIA.NEXTVAL,'123226','DEPENDENCIAS 91','0','11','3','1212');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.DEPENDENCIA (ID_DEPENDENCIA,CODIGO,NOMBRE,ES_DESPACHO_JUDICIAL,ID_SECCIONAL,ID_MUNICIPIO,NUMERO_CUENTA) values (SEQ_DEPENDENCIA.NEXTVAL,'1213123','DEPENDENCIA','0','11','2','2323123');
COMMIT;

PROMPT ****** INSERTANDO ROL ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ADMIN','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'SUPERDOS','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'SUSTANCIADOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'CAPACITADOR MAYOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ESCRITOR','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'SECRETARIO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'SECRETARIO PRINCIPAL','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ROL SUPERNUMERARIO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ROL SECRETARIO UNO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ROL SECRETARIO DOS','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'ROL SECRETARIO TRES','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'AAAA','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'12345678901235456789012345678901234567890123456789','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'RELATOR MAYOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'RELATOR MENOR','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'RELATOR BACK UP','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'COORDINADOR DE SALA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'CORRDINADOR DE DESPACHO','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'SUPERVISOR DE SALA','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.ROL (ID_ROL,NOMBRE,ID_ESTADO_ROL) values (SEQ_ROL.NEXTVAL,'AUXILIAR','1');
COMMIT;

PROMPT ****** INSERTANDO MENU ..........
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'MENU ARCHIVO','1','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'SALIR','1','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'COPIAR','5','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'IMPRIMIR','1','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'EDITAR','0','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'RESPALDO BASE DE DATOS','4','1');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'BANDEJA DE ENTRADA','0','2');
Insert into SCH_ORCL_DESARCHIVE_AUTEN.MENU (ID_MENU,NOMBRE,ID_MENU_PADRE,ID_ESTADO_MENU) values (SEQ_MENU.NEXTVAL,'MENU DE IMPRESION','1','1');
COMMIT;