/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : CREACION DEL MODELO RELACIONAL BD DESARCHIVE SITIO WEB MODULO DESARCHIVE.
-- PARÁMETROS DE ENTRADA     : LA EJECUCIÓN DEL SCRIPT SOLICITA LOS SIGUIENTES PARAMETROS
								SERVICIO        : ORCL_DESARCHIVE_AUTEN_PRE
								SIZE_TABLESPACE : DEVOPS -> 10
								                  19C    -> 1000
												  21C    -> 1000
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             : GABRIEL EDUARDO DUARTE             
-- FECHAHORA                 : 2021/11/29
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           ESTE COMPONENTE FUE REALIZADO BAJO LA METODOLOGÍA DE DESARROLLO DE INFORMÁTICA & TECNOLOGÍA 
--                             Y SE ENCUENTRA PROTEGIDO POR LAS LEYES DE DERECHOS DE AUTOR.
-- FECHAHORA MODIFICACIÓN    : 
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : 
-- OBJETIVO MODIFICACIÓN     : 
--                             
-----------------------------------------------------------------------------------------------------------------------------
*/
DECLARE
   V_CREASERVICIO   VARCHAR2(4000);
   V_INICIASERVICIO VARCHAR2(4000);
   V_SERVICIO       VARCHAR2(500);
   V_SIZE_TBL       NUMBER;
   V_CREATABLESDATA VARCHAR2(4000);
   V_CREATABLESIDX  VARCHAR2(4000);
   V_RUTA           VARCHAR2(500);
   V_RUTA_DATA      VARCHAR2(500);
   V_RUTA_IDX       VARCHAR2(500);
   V_CREA_USUARIO   VARCHAR2(500);
   V_USUARIO        VARCHAR2(500);
   V_CREA_ROL       VARCHAR2(500);   
   
BEGIN
    DELETE FROM AUDITORIA_OBJETOS;COMMIT;
	PROC_AUDITA_OBJETOS('DESARCHIVE','ORCL_DESARCHIVE_AUTEN_PRE','CREACION BD',NULL,NULL);
    V_SERVICIO := '&SERVICIO';
	V_SIZE_TBL := '&SIZE_TABLESPACE';
    --CREANDO SERVICIO
    V_CREASERVICIO := 'BEGIN
                          DBMS_SERVICE.CREATE_SERVICE(
                            SERVICE_NAME => :SERVICIO,
                            NETWORK_NAME => :SERVICIO);
                        END;';
    EXECUTE IMMEDIATE V_CREASERVICIO USING V_SERVICIO;                    
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA SERVICIO '||V_SERVICIO||' OK.',NULL,NULL);

    --INICIANDO SERVICIO
    V_INICIASERVICIO := ' BEGIN
                           DBMS_SERVICE.START_SERVICE(SERVICE_NAME => :SERVICIO);
                        END;';
    EXECUTE IMMEDIATE V_INICIASERVICIO USING V_SERVICIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA SERVICIO '||V_SERVICIO||' OK.',NULL,NULL);
    
    EXECUTE IMMEDIATE 'CREATE ROLE ROL_DESARCHIVE_AUTEN_PRE';
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA ROL OK.',NULL,NULL);
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,CREATE PROCEDURE TO ROL_DESARCHIVE_AUTEN_PRE';
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORGA PERMISOS OK.',NULL,NULL);
    
    ---OBTENIENDO RUTA DE INSTALACION DEL MOTOR
    SELECT SUBSTR(FILE_NAME,1,INSTR(FILE_NAME,'\',-1))
    INTO   V_RUTA
    FROM   DBA_DATA_FILES
    WHERE  ROWNUM = 1;

    ---CREANDO TABLESPACEDATA
    V_RUTA_DATA      := V_RUTA||V_SERVICIO||'_DATA.DBF';
    V_CREATABLESDATA := 'CREATE TABLESPACE '||V_SERVICIO||'_DATA DATAFILE '''||V_RUTA_DATA||''' SIZE '||V_SIZE_TBL||'M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED';
    EXECUTE IMMEDIATE V_CREATABLESDATA;
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA TABLESPACE DATA '||V_RUTA_DATA||' OK...',NULL,NULL);

    ---CREANDO TABLESPACE IDX
    V_RUTA_IDX      := V_RUTA||V_SERVICIO||'_IDX.DBF';
    V_CREATABLESIDX := 'CREATE TABLESPACE '||V_SERVICIO||'_IDX  DATAFILE '''||V_RUTA_IDX||''' SIZE '||V_SIZE_TBL||'M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED';
    EXECUTE IMMEDIATE V_CREATABLESIDX;
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA TABLESPACE IDX '||V_RUTA_IDX||' OK...',NULL,NULL);

    ---CREANDO USUARIO
    V_USUARIO := 'SCH_'||V_SERVICIO;
    V_CREA_USUARIO := '
                    CREATE USER '||V_USUARIO||' IDENTIFIED BY '||V_USUARIO||'
                    DEFAULT TABLESPACE '||V_SERVICIO||'_DATA
                    TEMPORARY TABLESPACE TEMP
                    QUOTA UNLIMITED ON '||V_SERVICIO||'_DATA';
    EXECUTE IMMEDIATE V_CREA_USUARIO;   
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA USUARIO '||V_USUARIO||' OK...',NULL,NULL);

    ---OTORGANDO PERMISOS AL USUARIO
    EXECUTE IMMEDIATE 'GRANT ROL_DESARCHIVE_AUTEN_PRE TO '||V_USUARIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORTANDO PERMISOS ROL, OK...',NULL,NULL);
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA CREACION OBJETOS BD ....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR DURANTE INSTALACION BD',SQLCODE,SQLERRM);
END;
/

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.APPS_INTERNAS (
    ID_APPS_INT NUMBER(38) NOT NULL,
    NOMBRE      NVARCHAR2(1000) NOT NULL,
    HOST        NVARCHAR2(1000) NOT NULL,
    PORT        NVARCHAR2(1000),
    USERNAME    NVARCHAR2(100) NOT NULL,
    PASSWORD    NVARCHAR2(100) NOT NULL,
    DETALLE     NVARCHAR2(1000),
    ES_ACTIVO   NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.APPS_INTERNAS ADD CONSTRAINT PK_API PRIMARY KEY ( ID_APPS_INT );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.CARGO (
    ID_CARGO  NUMBER(38) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.CARGO ADD CONSTRAINT PK_CRG PRIMARY KEY ( ID_CARGO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.CREDENCIAL (
    ID_CREDENCIAL      NUMBER(38) NOT NULL,
    USUARIO            NVARCHAR2(100) NOT NULL,
    CONTRASENA         NVARCHAR2(100) NOT NULL,
    INTENTOS_INVALIDOS NUMBER(38) NOT NULL,
    FECHA_BLOQUEO      DATE,
    ES_BLOQUEADO       NUMBER(1) NOT NULL,
    ID_USUARIO         NUMBER(38) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCL_DESARCHIVE_AUTEN_PRE.IDX_CRD_IDUSUARIO ON
    SCH_ORCL_DESARCHIVE_AUTEN_PRE.CREDENCIAL (
        ID_USUARIO
    ASC );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.CREDENCIAL ADD CONSTRAINT PK_CRD PRIMARY KEY ( ID_CREDENCIAL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DEPARTAMENTO (
    ID_DEPARTAMENTO NUMBER(38) NOT NULL,
    CODIGO          NVARCHAR2(1000) NOT NULL,
    NOMBRE          NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO       NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCL_DESARCHIVE_AUTEN_PRE.IDX_CODIGO_DEP ON
    SCH_ORCL_DESARCHIVE_AUTEN_PRE.DEPARTAMENTO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DEPARTAMENTO ADD CONSTRAINT PK_DEP PRIMARY KEY ( ID_DEPARTAMENTO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO (
    ID_DETALLE_USUARIO NUMBER(38) NOT NULL,
    ID_USUARIO         NUMBER(38) NOT NULL,
    ID_CARGO           NUMBER(38) NOT NULL,
    ID_MUNICIPIO       NUMBER(38) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCL_DESARCHIVE_AUTEN_PRE.IDX_USU_DTU ON
    SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO (
        ID_USUARIO
    ASC );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO ADD CONSTRAINT PK_DTU PRIMARY KEY ( ID_DETALLE_USUARIO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.GRUPO (
    ID_GRUPO  NUMBER(38) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.GRUPO ADD CONSTRAINT PK_GRP PRIMARY KEY ( ID_GRUPO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU (
    ID_MENU       NUMBER(38) NOT NULL,
    NOMBRE        NVARCHAR2(1000) NOT NULL,
    ID_MENU_PADRE NUMBER(38) NOT NULL,
    URL           NVARCHAR2(1000),
    ES_ACTIVO     NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU ADD CONSTRAINT PK_MEN PRIMARY KEY ( ID_MENU );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU_X_ROL (
    ID_MENU            NUMBER(38) NOT NULL,
    ID_ROL             NUMBER(38) NOT NULL,
    ID_PERMISOSXMODULO NUMBER(38) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU_X_ROL ADD CONSTRAINT PK_MXR PRIMARY KEY ( ID_MENU,
                                                                                         ID_ROL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO (
    ID_MUNICIPIO         NUMBER(38) NOT NULL,
    CODIGO               NVARCHAR2(1000) NOT NULL,
    NOMBRE               NVARCHAR2(1000) NOT NULL,
    ES_VISIBLE_SITIO_WEB NUMBER(1) NOT NULL,
    ES_ACTIVO            NUMBER(1) NOT NULL,
    ID_DEPARTAMENTO      NUMBER(38) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCL_DESARCHIVE_AUTEN_PRE.IDX_CODIGO_MUN ON
    SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO ADD CONSTRAINT PK_MUN PRIMARY KEY ( ID_MUNICIPIO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PARAMETRO (
    ID_PARAMETRO NUMBER(38) NOT NULL,
    NOMBRE_CLAVE NVARCHAR2(1000) NOT NULL,
    VALOR        NVARCHAR2(1000) NOT NULL,
    ID_PROCESO   NUMBER(38) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PARAMETRO ADD CONSTRAINT PK_PRM PRIMARY KEY ( ID_PARAMETRO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOS_X_MODULO (
    ID_PERMISOSXMODULO NUMBER(38) NOT NULL,
    CONSULTAR          NUMBER(1) NOT NULL,
    CREAR              NUMBER(1) NOT NULL,
    EDITAR             NUMBER(1) NOT NULL,
    ES_ACTIVO          NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOS_X_MODULO ADD CONSTRAINT PK_PEM PRIMARY KEY ( ID_PERMISOSXMODULO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOSXMODULOXROL (
    ID_PERMXMODXROL NUMBER(38) NOT NULL,
    ID_MENU         NUMBER(38) NOT NULL,
    ID_ROL          NUMBER(38) NOT NULL,
    CONSULTAR       NUMBER(1) NOT NULL,
    CREAR           NUMBER(1) NOT NULL,
    EDITAR          NUMBER(1) NOT NULL,
    HABILITADO      NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOSXMODULOXROL ADD CONSTRAINT PK_PMR PRIMARY KEY ( ID_PERMXMODXROL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PROCESO (
    ID_PROCESO NUMBER(38) NOT NULL,
    CODIGO     NVARCHAR2(1000),
    NOMBRE     NVARCHAR2(1000),
    ES_ACTIVO  NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCL_DESARCHIVE_AUTEN_PRE.IDX_CODIGO_PROCESO ON
    SCH_ORCL_DESARCHIVE_AUTEN_PRE.PROCESO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PROCESO ADD CONSTRAINT PK_PRC PRIMARY KEY ( ID_PROCESO );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL (
    ID_ROL    NUMBER(38) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL ADD CONSTRAINT PK_ROL PRIMARY KEY ( ID_ROL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROLESXGRUPO (
    ID_ROL    NUMBER(38) NOT NULL,
    ID_GRUPO  NUMBER(38) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROLESXGRUPO ADD CONSTRAINT PK_RXG PRIMARY KEY ( ID_GRUPO,
                                                                                          ID_ROL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SECCIONAL (
    ID_SECCIONAL NUMBER(38) NOT NULL,
    NOMBRE       NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO    NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SECCIONAL ADD CONSTRAINT PK_SCN PRIMARY KEY ( ID_SECCIONAL );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.TIPO_IDENTIFICACION (
    ID_TIPO_IDENTIFICACION NUMBER(38) NOT NULL,
    NOMBRE                 NVARCHAR2(500) NOT NULL,
    ABREVIACION            NVARCHAR2(1000),
    ES_ACTIVO              NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.TIPO_IDENTIFICACION ADD CONSTRAINT PK_TID PRIMARY KEY ( ID_TIPO_IDENTIFICACION );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO (
    ID_USUARIO             NUMBER(38) NOT NULL,
    NUMERO_IDENTIFICACION  NVARCHAR2(1000) NOT NULL,
    PRIMER_NOMBRE          NVARCHAR2(1000) NOT NULL,
    SEGUNDO_NOMBRE         NVARCHAR2(1000),
    PRIMER_APELLIDO        NVARCHAR2(1000) NOT NULL,
    SEGUNDO_APELLIDO       NVARCHAR2(1000),
    EMAIL                  NVARCHAR2(2000) NOT NULL,
    ES_ACTIVO              NUMBER(1) NOT NULL,
    ID_ROL                 NUMBER(38) NOT NULL,
    ID_TIPO_IDENTIFICACION NUMBER(38) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO ADD CONSTRAINT PK_USU PRIMARY KEY ( ID_USUARIO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO
    ADD CONSTRAINT FK_CRG_DTU FOREIGN KEY ( ID_CARGO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.CARGO ( ID_CARGO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO
    ADD CONSTRAINT FK_DEP_MUN FOREIGN KEY ( ID_DEPARTAMENTO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.DEPARTAMENTO ( ID_DEPARTAMENTO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROLESXGRUPO
    ADD CONSTRAINT FK_GRP_RXG FOREIGN KEY ( ID_GRUPO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.GRUPO ( ID_GRUPO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU_X_ROL
    ADD CONSTRAINT FK_MEN_MXR FOREIGN KEY ( ID_MENU )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU ( ID_MENU );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO
    ADD CONSTRAINT FK_MUN_DTU FOREIGN KEY ( ID_MUNICIPIO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO ( ID_MUNICIPIO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU_X_ROL
    ADD CONSTRAINT FK_PEM_ROL FOREIGN KEY ( ID_PERMISOSXMODULO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOS_X_MODULO ( ID_PERMISOSXMODULO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.PARAMETRO
    ADD CONSTRAINT FK_PRC_PRM FOREIGN KEY ( ID_PROCESO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.PROCESO ( ID_PROCESO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU_X_ROL
    ADD CONSTRAINT FK_ROL_MXR FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL ( ID_ROL );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROLESXGRUPO
    ADD CONSTRAINT FK_ROL_RXG FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL ( ID_ROL );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO
    ADD CONSTRAINT FK_ROL_USU FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL ( ID_ROL );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO
    ADD CONSTRAINT FK_TID_USU FOREIGN KEY ( ID_TIPO_IDENTIFICACION )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.TIPO_IDENTIFICACION ( ID_TIPO_IDENTIFICACION );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.CREDENCIAL
    ADD CONSTRAINT FK_USU_CRD FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO ( ID_USUARIO );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO
    ADD CONSTRAINT FK_USU_DTU FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO ( ID_USUARIO );

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_APPS_INTERNAS START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_APPS_INTERNAS BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.APPS_INTERNAS
    FOR EACH ROW
    WHEN ( NEW.ID_APPS_INT IS NULL )
BEGIN
    :NEW.ID_APPS_INT := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_APPS_INTERNAS.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_CARGO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_CARGO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.CARGO
    FOR EACH ROW
    WHEN ( NEW.ID_CARGO IS NULL )
BEGIN
    :NEW.ID_CARGO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_CARGO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_CREDENCIAL START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_CREDENCIAL BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.CREDENCIAL
    FOR EACH ROW
    WHEN ( NEW.ID_CREDENCIAL IS NULL )
BEGIN
    :NEW.ID_CREDENCIAL := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_CREDENCIAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_DEPARTAMENTO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_DEPARTAMENTO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.DEPARTAMENTO
    FOR EACH ROW
    WHEN ( NEW.ID_DEPARTAMENTO IS NULL )
BEGIN
    :NEW.ID_DEPARTAMENTO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_DEPARTAMENTO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_DETALLE_USUARIO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_DETALLE_USUARIO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.DETALLE_USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_DETALLE_USUARIO IS NULL )
BEGIN
    :NEW.ID_DETALLE_USUARIO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_DETALLE_USUARIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_GRUPO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_GRUPO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.GRUPO
    FOR EACH ROW
    WHEN ( NEW.ID_GRUPO IS NULL )
BEGIN
    :NEW.ID_GRUPO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_GRUPO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_MENU START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_MENU BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.MENU
    FOR EACH ROW
    WHEN ( NEW.ID_MENU IS NULL )
BEGIN
    :NEW.ID_MENU := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_MENU.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_MUNICIPIO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_MUNICIPIO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.MUNICIPIO
    FOR EACH ROW
    WHEN ( NEW.ID_MUNICIPIO IS NULL )
BEGIN
    :NEW.ID_MUNICIPIO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_MUNICIPIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PARAMETRO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_PARAMETRO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.PARAMETRO
    FOR EACH ROW
    WHEN ( NEW.ID_PARAMETRO IS NULL )
BEGIN
    :NEW.ID_PARAMETRO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PARAMETRO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PERMISOSXMODULO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_PERMISOSXMODULO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOS_X_MODULO
    FOR EACH ROW
    WHEN ( NEW.ID_PERMISOSXMODULO IS NULL )
BEGIN
    :NEW.ID_PERMISOSXMODULO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PERMISOSXMODULO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PERMISOSXMODULOXROL START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_PERMISOSXMODULOXROL BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.PERMISOSXMODULOXROL
    FOR EACH ROW
    WHEN ( NEW.ID_PERMXMODXROL IS NULL )
BEGIN
    :NEW.ID_PERMXMODXROL := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PERMISOSXMODULOXROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PROCESO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_PROCESO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.PROCESO
    FOR EACH ROW
    WHEN ( NEW.ID_PROCESO IS NULL )
BEGIN
    :NEW.ID_PROCESO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_PROCESO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_ROL START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_ROL BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.ROL
    FOR EACH ROW
    WHEN ( NEW.ID_ROL IS NULL )
BEGIN
    :NEW.ID_ROL := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_ROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_SECCIONAL START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_SECCIONAL BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.SECCIONAL
    FOR EACH ROW
    WHEN ( NEW.ID_SECCIONAL IS NULL )
BEGIN
    :NEW.ID_SECCIONAL := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_SECCIONAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_TIPO_IDENTIFICACION START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_TIPO_IDENTIFICACION BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.TIPO_IDENTIFICACION
    FOR EACH ROW
    WHEN ( NEW.ID_TIPO_IDENTIFICACION IS NULL )
BEGIN
    :NEW.ID_TIPO_IDENTIFICACION := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_TIPO_IDENTIFICACION.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_USUARIO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN_PRE.TRG_USUARIO BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_USUARIO IS NULL )
BEGIN
    :NEW.ID_USUARIO := SCH_ORCL_DESARCHIVE_AUTEN_PRE.SEQ_USUARIO.NEXTVAL;
END;
/

--- GENERACION DE PERMISOS 
DECLARE
  V_ROL  VARCHAR2(4000);
  CURSOR C_PERMISOS
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCH_ORCL_DESARCHIVE_AUTEN_PRE.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  R_PER C_PERMISOS%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA CREACION OBJETOS OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION PERMISOS OBJETOS....',NULL,NULL);
  V_ROL := 'ROL_DESARCHIVE_AUTEN_PRE';
  OPEN C_PERMISOS;
  LOOP
    FETCH C_PERMISOS INTO R_PER;
    EXIT WHEN C_PERMISOS%NOTFOUND;
      EXECUTE IMMEDIATE R_PER.SENTENCIA||V_ROL;
  END LOOP;
  CLOSE C_PERMISOS;
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA ASIGNACION PERMISOS OBJETOS OK....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF C_PERMISOS%ISOPEN THEN CLOSE C_PERMISOS; END IF;
	PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR GENERANDO PERMISOS....',SQLCODE,SQLERRM);
END;
/
DECLARE
  V_TEXTO VARCHAR2(4000);
  V_IDX   VARCHAR2(4000):= 'ORCL_DESARCHIVE_AUTEN_PRE_IDX';
  V_OW    VARCHAR2(4000):= 'SCH_ORCL_DESARCHIVE_AUTEN_PRE';
  CURSOR C_INDEX(P_TBL_IDX VARCHAR2,
                 P_TBL_OW  VARCHAR2)
  IS 
    SELECT ('ALTER INDEX '||OWNER||'.'||INDEX_NAME||' REBUILD TABLESPACE '||P_TBL_IDX)AS SENTENCIA
    FROM ALL_INDEXES WHERE OWNER = V_OW; 
  R_INDEX C_INDEX%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION INDICES OBJETOS A TABLESPACE IDX....',NULL,NULL);
  OPEN C_INDEX(V_IDX,V_OW);
  LOOP
  FETCH C_INDEX INTO R_INDEX;
  EXIT WHEN C_INDEX%NOTFOUND;
    EXECUTE IMMEDIATE R_INDEX.SENTENCIA;
  END LOOP;
  CLOSE C_INDEX;
  EXECUTE IMMEDIATE 'ALTER USER '||V_OW||' QUOTA 1000M ON '||V_IDX||'';  -- ASIGNA LA CUOTA AL TABLESPACE DE INDICE
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA ASIGNACION INDICES OBJETOS A TABLESPACE IDX OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS('DESARCHIVE','ORCL_DESARCHIVE_AUTEN_PRE','FINALIZACION CREACION BD',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF C_INDEX%ISOPEN THEN CLOSE C_INDEX; END IF;
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR ASIGNANDO OBJ A TABLESPACES IDX....',SQLCODE,SQLERRM);
END;