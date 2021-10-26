/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Creacion del modelo relacional Autenticacion el cual contempla:
                               1. Creacion tablas
							   2. Llaves primarias
							   3. Llaves foraneas
							   4. Auticremento por tabla
                               para el modulo de Reparto.
-- PARÁMETROS DE ENTRADA     : 
                               La ejecución del script solicita los siguientes parametros:

								SERVICENAME :  ORCLQA_DESARCHIVE_AUTEN
								NETWORKNAME :  ORCLQA_DESARCHIVE_AUTEN

								19C: TABLESPACEDATA: C:\ORACLE19C\ORADATA\ORCL\ORCLQA_DESARCHIVE_AUTEN_DATA.DBF 
								19C: TABLESPACEIDX : C:\ORACLE19C\ORADATA\ORCL\ORCLQA_DESARCHIVE_AUTEN_IDX.DBF  
								
								DEVOPS: G:\APP\GDUARTE\PRODUCT\18.0.0\ORADATA\XE\ORCLQA_DESARCHIVE_AUTEN_DATA.DBF
								DEVOPS: G:\APP\GDUARTE\PRODUCT\18.0.0\ORADATA\XE\ORCLQA_DESARCHIVE_AUTEN_IDX.DBF	  
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/09/21
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--                             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHAHORA MODIFICACIÓN    : 2021/09/22 03:13 pm
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : Javier Augusto Paez CRUZ
-- OBJETIVO MODIFICACIÓN     : Direccionamiento de rutas de archivos datafile para oracle 19C
-----------------------------------------------------------------------------------------------------------------------------
*/
BEGIN
	DBMS_SERVICE.create_service(
		service_name => '&SERVICE_NAME',
		network_name => '&NETWORK_NAME'
	);
END;
/


BEGIN
	DBMS_SERVICE.START_SERVICE(
		service_name => '&SERVICE_NAME'
	);
END;
/

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

---Creando Rol 
CREATE ROLE ROLQA_DESARCHIVE_AUTEN;

---Otorgando permisos a los roles
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE TO ROLQA_DESARCHIVE_AUTEN;

---Creacion de tablespaces

CREATE TABLESPACE ORCLQA_DESARCHIVE_AUTEN_DATA DATAFILE '&TABLESPACEDATA' SIZE 1000m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED;
CREATE TABLESPACE ORCLQA_DESARCHIVE_AUTEN_IDX  DATAFILE '&TABLESPACEIDX'   SIZE 1000m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED;

--Creacion de usuarios
CREATE USER SCHQA_ORCL_DESARCHIVE_AUTEN IDENTIFIED BY "SCHQA_ORCL_DESARCHIVE_AUTEN"
DEFAULT TABLESPACE "ORCLQA_DESARCHIVE_AUTEN_DATA"
TEMPORARY TABLESPACE "TEMP"
QUOTA UNLIMITED ON "ORCLQA_DESARCHIVE_AUTEN_DATA";

---Otorgando permisos a usuarios
GRANT ROLQA_DESARCHIVE_AUTEN TO SCHQA_ORCL_DESARCHIVE_AUTEN;

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.APPS_INTERNAS (
    ID_APPS_INT NUMBER(19) NOT NULL,
    NOMBRE      NVARCHAR2(1000) NOT NULL,
    HOST        NVARCHAR2(1000) NOT NULL,
    PORT        NVARCHAR2(1000),
    USERNAME    NVARCHAR2(100) NOT NULL,
    PASSWORD    NVARCHAR2(100) NOT NULL,
    DETALLE     NVARCHAR2(1000),
    ES_ACTIVO   NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.APPS_INTERNAS ADD CONSTRAINT PK_API PRIMARY KEY ( ID_APPS_INT );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.CARGO (
    ID_CARGO  NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.CARGO ADD CONSTRAINT PK_CRG PRIMARY KEY ( ID_CARGO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.CREDENCIAL (
    ID_CREDENCIAL      NUMBER(19) NOT NULL,
    USUARIO            NVARCHAR2(100) NOT NULL,
    CONTRASENA         NVARCHAR2(100) NOT NULL,
    INTENTOS_INVALIDOS NUMBER(19) NOT NULL,
    ID_USUARIO         NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCHQA_ORCL_DESARCHIVE_AUTEN.IDX_CRD_IDUSUARIO ON
    SCHQA_ORCL_DESARCHIVE_AUTEN.CREDENCIAL (
        ID_USUARIO
    ASC );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.CREDENCIAL ADD CONSTRAINT PK_CRD PRIMARY KEY ( ID_CREDENCIAL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (
    ID_DEPARTAMENTO NUMBER(19) NOT NULL,
    CODIGO          NVARCHAR2(1000) NOT NULL,
    NOMBRE          NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO       NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCHQA_ORCL_DESARCHIVE_AUTEN.IDX_CODIGO_DEP ON
    SCHQA_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO (
        ID_DEPARTAMENTO
    ASC,
        CODIGO
    ASC );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO ADD CONSTRAINT PK_DEP PRIMARY KEY ( ID_DEPARTAMENTO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO (
    ID_DETALLE_USUARIO NUMBER(19) NOT NULL,
    ID_USUARIO         NUMBER(19) NOT NULL,
    ID_CARGO           NUMBER(19) NOT NULL,
    ID_MUNICIPIO       NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCHQA_ORCL_DESARCHIVE_AUTEN.IDX_USU_DTU ON
    SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO (
        ID_USUARIO
    ASC );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO ADD CONSTRAINT PK_DTU PRIMARY KEY ( ID_DETALLE_USUARIO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.GRUPO (
    ID_GRUPO  NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.GRUPO ADD CONSTRAINT PK_GRP PRIMARY KEY ( ID_GRUPO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU (
    ID_MENU            NUMBER(19) NOT NULL,
    NOMBRE             NVARCHAR2(1000) NOT NULL,
    ID_MENU_PADRE      NUMBER(19) NOT NULL,
    URL                NVARCHAR2(1000),
    ES_ACTIVO          NUMBER(1) NOT NULL,
    ID_PERMISOSXMODULO NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU ADD CONSTRAINT PK_MEN PRIMARY KEY ( ID_MENU );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU_X_ROL (
    ID_MENU            NUMBER(19) NOT NULL,
    ID_ROL             NUMBER(19) NOT NULL,
    ID_PERMISOSXMODULO NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU_X_ROL ADD CONSTRAINT PK_MXR PRIMARY KEY ( ID_MENU,
                                                                                     ID_ROL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (
    ID_MUNICIPIO    NUMBER(19) NOT NULL,
    CODIGO          NVARCHAR2(1000) NOT NULL,
    NOMBRE          NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO       NUMBER(1) NOT NULL,
    ID_DEPARTAMENTO NUMBER(19) NOT NULL
);

CREATE UNIQUE INDEX SCHQA_ORCL_DESARCHIVE_AUTEN.IDX_CODIGO_MUN ON
    SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO (
        ID_MUNICIPIO
    ASC,
        CODIGO
    ASC );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO ADD CONSTRAINT PK_MUN PRIMARY KEY ( ID_MUNICIPIO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOS_X_MODULO (
    ID_PERMISOSXMODULO NUMBER(19) NOT NULL,
    CONSULTAR          NUMBER(1) NOT NULL,
    CREAR              NUMBER(1) NOT NULL,
    EDITAR             NUMBER(1) NOT NULL,
    ES_ACTIVO          NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOS_X_MODULO ADD CONSTRAINT PK_PEM PRIMARY KEY ( ID_PERMISOSXMODULO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL (
    ID_PERMXMODXROL NUMBER(19) NOT NULL,
    ID_MENU         NUMBER(19) NOT NULL,
    ID_ROL          NUMBER(19) NOT NULL,
    CONSULTAR       NUMBER(1) NOT NULL,
    CREAR           NUMBER(1) NOT NULL,
    EDITAR          NUMBER(1) NOT NULL,
    HABILITADO      NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL ADD CONSTRAINT PK_PMR PRIMARY KEY ( ID_PERMXMODXROL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROL (
    ID_ROL    NUMBER(19) NOT NULL,
    NOMBRE    NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROL ADD CONSTRAINT PK_ROL PRIMARY KEY ( ID_ROL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROLESXGRUPO (
    ID_ROL    NUMBER(19) NOT NULL,
    ID_GRUPO  NUMBER(19) NOT NULL,
    ES_ACTIVO NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROLESXGRUPO ADD CONSTRAINT PK_RXG PRIMARY KEY ( ID_GRUPO,
                                                                                      ID_ROL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.SECCIONAL (
    ID_SECCIONAL NUMBER(19) NOT NULL,
    NOMBRE       NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO    NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.SECCIONAL ADD CONSTRAINT PK_SCN PRIMARY KEY ( ID_SECCIONAL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION (
    ID_TIPO_IDENTIFICACION NUMBER(1) NOT NULL,
    NOMBRE                 NVARCHAR2(500) NOT NULL,
    ABREVIACION            NVARCHAR2(1000),
    ES_ACTIVO              NUMBER(1) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ADD CONSTRAINT PK_TID PRIMARY KEY ( ID_TIPO_IDENTIFICACION );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO (
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

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO ADD CONSTRAINT PK_USU PRIMARY KEY ( ID_USUARIO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_CRG_DTU FOREIGN KEY ( ID_CARGO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.CARGO ( ID_CARGO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO
    ADD CONSTRAINT FK_DEP_MUN FOREIGN KEY ( ID_DEPARTAMENTO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO ( ID_DEPARTAMENTO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROLESXGRUPO
    ADD CONSTRAINT FK_GRP_RXG FOREIGN KEY ( ID_GRUPO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.GRUPO ( ID_GRUPO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU_X_ROL
    ADD CONSTRAINT FK_MEN_MXR FOREIGN KEY ( ID_MENU )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.MENU ( ID_MENU );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_MUN_DTU FOREIGN KEY ( ID_MUNICIPIO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO ( ID_MUNICIPIO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU
    ADD CONSTRAINT FK_PEM_MEN FOREIGN KEY ( ID_PERMISOSXMODULO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOS_X_MODULO ( ID_PERMISOSXMODULO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.MENU_X_ROL
    ADD CONSTRAINT FK_ROL_MXR FOREIGN KEY ( ID_ROL )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.ROLESXGRUPO
    ADD CONSTRAINT FK_ROL_RXG FOREIGN KEY ( ID_ROL )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO
    ADD CONSTRAINT FK_ROL_USU FOREIGN KEY ( ID_ROL )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.ROL ( ID_ROL );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO
    ADD CONSTRAINT FK_TID_USU FOREIGN KEY ( ID_TIPO_IDENTIFICACION )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ( ID_TIPO_IDENTIFICACION );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.CREDENCIAL
    ADD CONSTRAINT FK_USU_CRD FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO ( ID_USUARIO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO
    ADD CONSTRAINT FK_USU_DTU FOREIGN KEY ( ID_USUARIO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO ( ID_USUARIO );

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_APPS_INTERNAS START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_APPS_INTERNAS BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.APPS_INTERNAS
    FOR EACH ROW
    WHEN ( NEW.ID_APPS_INT IS NULL )
BEGIN
    :NEW.ID_APPS_INT := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_APPS_INTERNAS.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_CARGO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_CARGO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.CARGO
    FOR EACH ROW
    WHEN ( NEW.ID_CARGO IS NULL )
BEGIN
    :NEW.ID_CARGO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_CARGO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_CREDENCIAL START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_CREDENCIAL BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.CREDENCIAL
    FOR EACH ROW
    WHEN ( NEW.ID_CREDENCIAL IS NULL )
BEGIN
    :NEW.ID_CREDENCIAL := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_CREDENCIAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_DEPARTAMENTO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_DEPARTAMENTO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.DEPARTAMENTO
    FOR EACH ROW
    WHEN ( NEW.ID_DEPARTAMENTO IS NULL )
BEGIN
    :NEW.ID_DEPARTAMENTO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_DEPARTAMENTO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_DETALLE_USUARIO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_DETALLE_USUARIO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.DETALLE_USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_DETALLE_USUARIO IS NULL )
BEGIN
    :NEW.ID_DETALLE_USUARIO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_DETALLE_USUARIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_GRUPO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_GRUPO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.GRUPO
    FOR EACH ROW
    WHEN ( NEW.ID_GRUPO IS NULL )
BEGIN
    :NEW.ID_GRUPO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_GRUPO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_MENU START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_MENU BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.MENU
    FOR EACH ROW
    WHEN ( NEW.ID_MENU IS NULL )
BEGIN
    :NEW.ID_MENU := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_MENU.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_MUNICIPIO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_MUNICIPIO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.MUNICIPIO
    FOR EACH ROW
    WHEN ( NEW.ID_MUNICIPIO IS NULL )
BEGIN
    :NEW.ID_MUNICIPIO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_MUNICIPIO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_PERMISOSXMODULO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOS_X_MODULO
    FOR EACH ROW
    WHEN ( NEW.ID_PERMISOSXMODULO IS NULL )
BEGIN
    :NEW.ID_PERMISOSXMODULO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULOXROL START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_PERMISOSXMODULOXROL BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.PERMISOSXMODULOXROL
    FOR EACH ROW
    WHEN ( NEW.ID_PERMXMODXROL IS NULL )
BEGIN
    :NEW.ID_PERMXMODXROL := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_PERMISOSXMODULOXROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_ROL START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_ROL BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.ROL
    FOR EACH ROW
    WHEN ( NEW.ID_ROL IS NULL )
BEGIN
    :NEW.ID_ROL := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_ROL.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_SECCIONAL START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_SECCIONAL BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.SECCIONAL
    FOR EACH ROW
    WHEN ( NEW.ID_SECCIONAL IS NULL )
BEGIN
    :NEW.ID_SECCIONAL := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_SECCIONAL.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_TIPO_IDENTIFICACION START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_TIPO_IDENTIFICACION BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION
    FOR EACH ROW
    WHEN ( NEW.ID_TIPO_IDENTIFICACION IS NULL )
BEGIN
    :NEW.ID_TIPO_IDENTIFICACION := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_TIPO_IDENTIFICACION.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_USUARIO START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_AUTEN.TRG_USUARIO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_AUTEN.USUARIO
    FOR EACH ROW
    WHEN ( NEW.ID_USUARIO IS NULL )
BEGIN
    :NEW.ID_USUARIO := SCHQA_ORCL_DESARCHIVE_AUTEN.SEQ_USUARIO.NEXTVAL;
END;
/




--- Generacion de permisos
DECLARE
  v_rol  VARCHAR2(4000);
  CURSOR c_permisos
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCHQA_ORCL_DESARCHIVE_AUTEN.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  r_per c_permisos%ROWTYPE;
BEGIN
  v_rol := 'ROLQA_DESARCHIVE_AUTEN';
  
  OPEN c_permisos;
  LOOP
    FETCH c_permisos INTO r_per;
    EXIT WHEN c_permisos%NOTFOUND;
      EXECUTE IMMEDIATE r_per.SENTENCIA||v_rol;
  END LOOP;
  CLOSE c_permisos;
EXCEPTION
  WHEN OTHERS THEN
    IF c_permisos%ISOPEN THEN CLOSE c_permisos; END IF;
END;

