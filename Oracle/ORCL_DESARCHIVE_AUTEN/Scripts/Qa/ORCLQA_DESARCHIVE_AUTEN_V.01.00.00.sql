/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Creacion del modelo relacional BD DESARCHIVE AUTENTICACION Modulo desarchive.
-- PARÁMETROS DE ENTRADA     : La ejecución del script solicita los siguientes parametros
								SERVICIO        : ORCLQA_DESARCHIVE_AUTEN
								SIZE_TABLESPACE : DEVOPS -> 10
								                  19C    -> 1000
												  21C    -> 1000
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             : Gabriel Eduardo Duarte             
-- FECHAHORA                 : 2021/11/29
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--                             y se encuentra Protegido por las leyes de derechos de autor.
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
	PROC_AUDITA_OBJETOS('DESARCHIVE','ORCLQA_DESARCHIVE_AUTEN','CREACION BD',NULL,NULL);
    V_SERVICIO := '&SERVICIO';
	V_SIZE_TBL := '&SIZE_TABLESPACE';
    --Creando servicio
    V_CREASERVICIO := 'BEGIN
                          DBMS_SERVICE.CREATE_SERVICE(
                            SERVICE_NAME => :SERVICIO,
                            NETWORK_NAME => :SERVICIO);
                        END;';
    EXECUTE IMMEDIATE V_CREASERVICIO USING V_SERVICIO;                    
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA SERVICIO '||V_SERVICIO||' OK.',NULL,NULL);

    --Iniciando servicio
    V_INICIASERVICIO := ' BEGIN
                           DBMS_SERVICE.START_SERVICE(SERVICE_NAME => :SERVICIO);
                        END;';
    EXECUTE IMMEDIATE V_INICIASERVICIO USING V_SERVICIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA SERVICIO '||V_SERVICIO||' OK.',NULL,NULL);
    
    EXECUTE IMMEDIATE 'CREATE ROLE ROLQA_DESARCHIVE_AUTEN';
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA ROL OK.',NULL,NULL);
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,CREATE PROCEDURE TO ROLQA_DESARCHIVE_AUTEN';
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORGA PERMISOS OK.',NULL,NULL);
    
    ---Obteniendo ruta de instalacion del motor
    SELECT SUBSTR(FILE_NAME,1,INSTR(FILE_NAME,'\',-1))
    INTO   V_RUTA
    FROM   DBA_DATA_FILES
    WHERE  ROWNUM = 1;

    ---Creando tablespacedata
    V_RUTA_DATA      := V_RUTA||V_SERVICIO||'_DATA.DBF';
    V_CREATABLESDATA := 'CREATE TABLESPACE '||V_SERVICIO||'_DATA DATAFILE '''||V_RUTA_DATA||''' SIZE '||V_SIZE_TBL||'m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED';
    EXECUTE IMMEDIATE V_CREATABLESDATA;
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA TABLESPACE DATA '||V_RUTA_DATA||' OK...',NULL,NULL);

    ---Creando tablespace idx
    V_RUTA_IDX      := V_RUTA||V_SERVICIO||'_IDX.DBF';
    V_CREATABLESIDX := 'CREATE TABLESPACE '||V_SERVICIO||'_IDX  DATAFILE '''||V_RUTA_IDX||''' SIZE '||V_SIZE_TBL||'m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED';
    EXECUTE IMMEDIATE V_CREATABLESIDX;
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA TABLESPACE IDX '||V_RUTA_IDX||' OK...',NULL,NULL);

    ---Creando usuario
    V_USUARIO := 'SCH_'||V_SERVICIO;
    V_CREA_USUARIO := '
                    CREATE USER '||V_USUARIO||' IDENTIFIED BY '||V_USUARIO||'
                    DEFAULT TABLESPACE '||V_SERVICIO||'_DATA
                    TEMPORARY TABLESPACE TEMP
                    QUOTA UNLIMITED ON '||V_SERVICIO||'_DATA';
    EXECUTE IMMEDIATE V_CREA_USUARIO;   
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA USUARIO '||V_USUARIO||' OK...',NULL,NULL);

    ---Otorgando permisos al usuario
    EXECUTE IMMEDIATE 'GRANT ROLQA_DESARCHIVE_AUTEN TO '||V_USUARIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORTANDO PERMISOS ROL, OK...',NULL,NULL);
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA CREACION OBJETOS BD ....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR DURANTE INSTALACION BD',SQLCODE,SQLERRM);
END;
/

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.APPS_INTERNAS (
    ID_APPS_INT NUMBER(19) NOT NULL,
    NOMBRE      NVARCHAR2(1000) NOT NULL,
    HOST        NVARCHAR2(1000) NOT NULL,
    PORT        NVARCHAR2(1000),
    USERNAME    NVARCHAR2(100) NOT NULL,
    PASSWORD    NVARCHAR2(100) NOT NULL,
    DETALLE     NVARCHAR2(1000),
    ES_ACTIVO   NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.APPS_INTERNAS ADD CONSTRAINT PK_API PRIMARY KEY ( ID_APPS_INT );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.CARGO (
    ID_CARGO  NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.CARGO ADD CONSTRAINT PK_CRG PRIMARY KEY ( ID_CARGO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.CREDENCIAL (
    ID_CREDENCIAL      NUMBER(19) NOT NULL,
    USUARIO            NVARCHAR2(100) NOT NULL,
    CONTRASENA         NVARCHAR2(100) NOT NULL,
    INTENTOS_INVALIDOS NUMBER(19) NOT NULL,
    FECHA_BLOQUEO      TIMESTAMP NOT NULL,
    ES_BLOQUEADO       NUMBER(1) NOT NULL,
    ID_USUARIO         NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCLQA_DESARCHIVE_AUTEN.IDX_CRD_IDUSUARIO ON
    SCH_ORCLQA_DESARCHIVE_AUTEN.CREDENCIAL (
        ID_USUARIO
    ASC );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.CREDENCIAL ADD CONSTRAINT PK_CRD PRIMARY KEY ( ID_CREDENCIAL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DEPARTAMENTO (
    ID_DEPARTAMENTO NUMBER(19) NOT NULL,
    CODIGO          NVARCHAR2(1000) NOT NULL,
    NOMBRE          NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO       NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCLQA_DESARCHIVE_AUTEN.IDX_CODIGO_DEP ON
    SCH_ORCLQA_DESARCHIVE_AUTEN.DEPARTAMENTO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DEPARTAMENTO ADD CONSTRAINT PK_DEP PRIMARY KEY ( ID_DEPARTAMENTO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO (
    ID_DETALLE_USUARIO NUMBER(19) NOT NULL,
    ID_USUARIO         NUMBER(19) NOT NULL,
    ID_CARGO           NUMBER(19) NOT NULL,
    ID_MUNICIPIO       NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCLQA_DESARCHIVE_AUTEN.IDX_USU_DTU ON
    SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO (
        ID_USUARIO
    ASC );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO ADD CONSTRAINT PK_DTU PRIMARY KEY ( ID_DETALLE_USUARIO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.GRUPO (
    ID_GRUPO  NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.GRUPO ADD CONSTRAINT PK_GRP PRIMARY KEY ( ID_GRUPO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU (
    ID_MENU       NUMBER(19) NOT NULL,
    NOMBRE        NVARCHAR2(1000) NOT NULL,
    ID_MENU_PADRE NUMBER(19) NOT NULL,
    URL           NVARCHAR2(1000),
    ES_ACTIVO     NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU ADD CONSTRAINT PK_MEN PRIMARY KEY ( ID_MENU );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU_X_ROL (
    ID_MENU            NUMBER(19) NOT NULL,
    ID_ROL             NUMBER(19) NOT NULL,
    ID_PERMISOSXMODULO NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU_X_ROL ADD CONSTRAINT PK_MXR PRIMARY KEY ( ID_MENU,
                                                                                       ID_ROL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO (
    ID_MUNICIPIO    NUMBER(19) NOT NULL,
    CODIGO          NVARCHAR2(1000) NOT NULL,
    NOMBRE          NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO       NUMBER(1) NOT NULL,
    ID_DEPARTAMENTO NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCLQA_DESARCHIVE_AUTEN.IDX_CODIGO_MUN ON
    SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO ADD CONSTRAINT PK_MUN PRIMARY KEY ( ID_MUNICIPIO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PARAMETRO (
    ID_PARAMETRO NUMBER(19) NOT NULL,
    NOMBRE_CLAVE NVARCHAR2(1000) NOT NULL,
    VALOR        NVARCHAR2(1000) NOT NULL,
    ID_PROCESO   NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PARAMETRO ADD CONSTRAINT PK_PRM PRIMARY KEY ( ID_PARAMETRO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOS_X_MODULO (
    ID_PERMISOSXMODULO NUMBER(19) NOT NULL,
    CONSULTAR          NUMBER(1) NOT NULL,
    CREAR              NUMBER(1) NOT NULL,
    EDITAR             NUMBER(1) NOT NULL,
    ES_ACTIVO          NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOS_X_MODULO ADD CONSTRAINT PK_PEM PRIMARY KEY ( ID_PERMISOSXMODULO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL (
    ID_PERMXMODXROL NUMBER(19) NOT NULL,
    ID_MENU         NUMBER(19) NOT NULL,
    ID_ROL          NUMBER(19) NOT NULL,
    CONSULTAR       NUMBER(1) NOT NULL,
    CREAR           NUMBER(1) NOT NULL,
    EDITAR          NUMBER(1) NOT NULL,
    HABILITADO      NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL ADD CONSTRAINT PK_PMR PRIMARY KEY ( ID_PERMXMODXROL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PROCESO (
    ID_PROCESO NUMBER(19) NOT NULL,
    CODIGO     NVARCHAR2(1000),
    NOMBRE     NVARCHAR2(1000),
    ES_ACTIVO  NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCH_ORCLQA_DESARCHIVE_AUTEN.IDX_CODIGO_PROCESO ON
    SCH_ORCLQA_DESARCHIVE_AUTEN.PROCESO (
        CODIGO
    ASC );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PROCESO ADD CONSTRAINT PK_PRC PRIMARY KEY ( ID_PROCESO );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROL (
    ID_ROL    NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROL ADD CONSTRAINT PK_ROL PRIMARY KEY ( ID_ROL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROLESXGRUPO (
    ID_ROL    NUMBER(19) NOT NULL,
    ID_GRUPO  NUMBER(19) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROLESXGRUPO ADD CONSTRAINT PK_RXG PRIMARY KEY ( ID_GRUPO,
                                                                                        ID_ROL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.SECCIONAL (
    ID_SECCIONAL NUMBER(19) NOT NULL,
    NOMBRE       NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO    NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.SECCIONAL ADD CONSTRAINT PK_SCN PRIMARY KEY ( ID_SECCIONAL );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION (
    ID_TIPO_IDENTIFICACION NUMBER(1) NOT NULL,
    NOMBRE                 NVARCHAR2(500) NOT NULL,
    ABREVIACION            NVARCHAR2(1000),
    ES_ACTIVO              NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ADD CONSTRAINT PK_TID PRIMARY KEY ( ID_TIPO_IDENTIFICACION );

CREATE TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO (
    ID_USUARIO             NUMBER(19) NOT NULL,
    NUMERO_IDENTIFICACION  NVARCHAR2(1000) NOT NULL,
    PRIMER_NOMBRE          NVARCHAR2(1000) NOT NULL,
    SEGUNDO_NOMBRE         NVARCHAR2(1000),
    PRIMER_APELLIDO        NVARCHAR2(1000) NOT NULL,
    SEGUNDO_APELLIDO       NVARCHAR2(1000),
    EMAIL                  NVARCHAR2(2000) NOT NULL,
    ES_ACTIVO              NUMBER(1) NOT NULL,
    ID_ROL                 NUMBER(19) NOT NULL,
    ID_TIPO_IDENTIFICACION NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO ADD CONSTRAINT PK_USU PRIMARY KEY ( ID_USUARIO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_CRG_DTU FOREIGN KEY ( ID_CARGO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.CARGO ( ID_CARGO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO
    ADD CONSTRAINT FK_DEP_MUN FOREIGN KEY ( ID_DEPARTAMENTO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.DEPARTAMENTO ( ID_DEPARTAMENTO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROLESXGRUPO
    ADD CONSTRAINT FK_GRP_RXG FOREIGN KEY ( ID_GRUPO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.GRUPO ( ID_GRUPO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU_X_ROL
    ADD CONSTRAINT FK_MEN_MXR FOREIGN KEY ( ID_MENU )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.MENU ( ID_MENU );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_MUN_DTU FOREIGN KEY ( ID_MUNICIPIO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO ( ID_MUNICIPIO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU_X_ROL
    ADD CONSTRAINT FK_PEM_ROL FOREIGN KEY ( ID_PERMISOSXMODULO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOS_X_MODULO ( ID_PERMISOSXMODULO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.PARAMETRO
    ADD CONSTRAINT FK_PRC_PRM FOREIGN KEY ( ID_PROCESO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.PROCESO ( ID_PROCESO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.MENU_X_ROL
    ADD CONSTRAINT FK_ROL_MXR FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.ROLESXGRUPO
    ADD CONSTRAINT FK_ROL_RXG FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO
    ADD CONSTRAINT FK_ROL_USU FOREIGN KEY ( ID_ROL )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO
    ADD CONSTRAINT FK_TID_USU FOREIGN KEY ( ID_TIPO_IDENTIFICACION )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ( ID_TIPO_IDENTIFICACION );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.CREDENCIAL
    ADD CONSTRAINT FK_USU_CRD FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO ( ID_USUARIO );

ALTER TABLE SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_USU_DTU FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO ( ID_USUARIO );

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_APPS_INTERNAS START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_APPS_INTERNAS BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.APPS_INTERNAS
    FOR EACH ROW
    WHEN ( NEW.ID_APPS_INT IS NULL )
BEGIN
    :NEW.ID_APPS_INT := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_APPS_INTERNAS.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_CARGO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_CARGO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.CARGO
    FOR EACH ROW
    WHEN ( NEW.ID_CARGO IS NULL )
BEGIN
    :NEW.ID_CARGO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_CARGO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_CREDENCIAL START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_CREDENCIAL BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.CREDENCIAL
    FOR EACH ROW
    WHEN ( NEW.ID_CREDENCIAL IS NULL )
BEGIN
    :NEW.ID_CREDENCIAL := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_CREDENCIAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_DEPARTAMENTO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_DEPARTAMENTO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.DEPARTAMENTO
    FOR EACH ROW
    WHEN ( NEW.ID_DEPARTAMENTO IS NULL )
BEGIN
    :NEW.ID_DEPARTAMENTO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_DEPARTAMENTO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_DETALLE_USUARIO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_DETALLE_USUARIO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.DETALLE_USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_DETALLE_USUARIO IS NULL )
BEGIN
    :NEW.ID_DETALLE_USUARIO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_DETALLE_USUARIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_GRUPO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_GRUPO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.GRUPO
    FOR EACH ROW
    WHEN ( NEW.ID_GRUPO IS NULL )
BEGIN
    :NEW.ID_GRUPO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_GRUPO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_MENU START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_MENU BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.MENU
    FOR EACH ROW
    WHEN ( NEW.ID_MENU IS NULL )
BEGIN
    :NEW.ID_MENU := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_MENU.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_MUNICIPIO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_MUNICIPIO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.MUNICIPIO
    FOR EACH ROW
    WHEN ( NEW.ID_MUNICIPIO IS NULL )
BEGIN
    :NEW.ID_MUNICIPIO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_MUNICIPIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PARAMETRO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_PARAMETRO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.PARAMETRO
    FOR EACH ROW
    WHEN ( NEW.ID_PARAMETRO IS NULL )
BEGIN
    :NEW.ID_PARAMETRO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PARAMETRO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_PERMISOSXMODULO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOS_X_MODULO
    FOR EACH ROW
    WHEN ( NEW.ID_PERMISOSXMODULO IS NULL )
BEGIN
    :NEW.ID_PERMISOSXMODULO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULOXROL START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_PERMISOSXMODULOXROL BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL
    FOR EACH ROW
    WHEN ( NEW.ID_PERMXMODXROL IS NULL )
BEGIN
    :NEW.ID_PERMXMODXROL := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULOXROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PROCESO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_PROCESO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.PROCESO
    FOR EACH ROW
    WHEN ( NEW.ID_PROCESO IS NULL )
BEGIN
    :NEW.ID_PROCESO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_PROCESO.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_ROL START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_ROL BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.ROL
    FOR EACH ROW
    WHEN ( NEW.ID_ROL IS NULL )
BEGIN
    :NEW.ID_ROL := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_ROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_SECCIONAL START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_SECCIONAL BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.SECCIONAL
    FOR EACH ROW
    WHEN ( NEW.ID_SECCIONAL IS NULL )
BEGIN
    :NEW.ID_SECCIONAL := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_SECCIONAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_TIPO_IDENTIFICACION START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_TIPO_IDENTIFICACION BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION
    FOR EACH ROW
    WHEN ( NEW.ID_TIPO_IDENTIFICACION IS NULL )
BEGIN
    :NEW.ID_TIPO_IDENTIFICACION := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_TIPO_IDENTIFICACION.NEXTVAL;
END;
/

CREATE SEQUENCE SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_USUARIO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCLQA_DESARCHIVE_AUTEN.TRG_USUARIO BEFORE
    INSERT ON SCH_ORCLQA_DESARCHIVE_AUTEN.USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_USUARIO IS NULL )
BEGIN
    :NEW.ID_USUARIO := SCH_ORCLQA_DESARCHIVE_AUTEN.SEQ_USUARIO.NEXTVAL;
END;
/

--- GENERACION DE PERMISOS 
DECLARE
  V_ROL  VARCHAR2(4000);
  CURSOR C_PERMISOS
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCH_ORCLQA_DESARCHIVE_AUTEN.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  R_PER C_PERMISOS%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA CREACION OBJETOS OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION PERMISOS OBJETOS....',NULL,NULL);
  V_ROL := 'ROLQA_DESARCHIVE_AUTEN';
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
  v_texto VARCHAR2(4000);
  v_idx   VARCHAR2(4000):= 'ORCLQA_DESARCHIVE_AUTEN_IDX';
  v_ow    VARCHAR2(4000):= 'SCH_ORCLQA_DESARCHIVE_AUTEN';
  CURSOR c_index(p_tbl_idx VARCHAR2,
                 p_tbl_ow  VARCHAR2)
  IS 
    SELECT ('ALTER INDEX '||OWNER||'.'||INDEX_NAME||' REBUILD TABLESPACE '||p_tbl_idx)AS SENTENCIA
    FROM ALL_INDEXES WHERE OWNER = v_ow; 
  r_index c_index%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION INDICES OBJETOS A TABLESPACE IDX....',NULL,NULL);
  OPEN c_index(v_idx,v_ow);
  LOOP
  FETCH c_index INTO r_index;
  EXIT WHEN c_index%NOTFOUND;
    EXECUTE IMMEDIATE r_index.sentencia;
  END LOOP;
  CLOSE c_index;
  EXECUTE IMMEDIATE 'ALTER USER '||v_ow||' QUOTA 1000M on '||v_idx||'';  -- ASIGNA LA CUOTA AL TABLESPACE DE INDICE
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA ASIGNACION INDICES OBJETOS A TABLESPACE IDX OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS('DESARCHIVE','ORCLQA_DESARCHIVE_AUTEN','FINALIZACION CREACION BD',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF c_index%ISOPEN THEN CLOSE c_index; END IF;
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR ASIGNANDO OBJ A TABLESPACES IDX....',SQLCODE,SQLERRM);
END;