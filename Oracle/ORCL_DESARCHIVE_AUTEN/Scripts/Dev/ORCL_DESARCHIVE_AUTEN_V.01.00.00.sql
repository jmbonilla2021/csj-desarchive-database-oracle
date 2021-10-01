/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Creacion del modelo relacional Autenticacion el cual contempla:
                               1. Creacion tablas
							   2. Llaves primarias
							   3. Llaves foraneas
							   4. Auticremento por tabla
                               para el modulo de Reparto.
-- PARÁMETROS DE ENTRADA     : La ejecución del script solicita los siguientes parametros:

								SERVICENAME :  ORCL_DESARCHIVE_AUTEN
								NETWORKNAME :  ORCL_DESARCHIVE_AUTEN

								19C: TABLESPACEDATA: C:\ORACLE19C\ORADATA\ORCL\ORCL_DESARCHIVE_AUTEN_DATA.DBF 
								19C: TABLESPACEIDX : C:\ORACLE19C\ORADATA\ORCL\ORCL_DESARCHIVE_AUTEN_IDX.DBF  
								
								DEVOPS: G:\APP\GDUARTE\PRODUCT\18.0.0\ORADATA\XE\ORCL_DESARCHIVE_AUTEN_DATA.DBF
								DEVOPS: G:\APP\GDUARTE\PRODUCT\18.0.0\ORADATA\XE\ORCL_DESARCHIVE_AUTEN_IDX.DBF	  
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
		service_name => '&SERVICENAME',
		network_name => '&NETWORKNAME'
	);
END;
/


BEGIN
	DBMS_SERVICE.START_SERVICE(
		service_name => '&SERVICENAME'
	);
END;
/

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

---Creando Rol 
CREATE ROLE ROL_DESARCHIVE_AUTEN;

---Otorgando permisos a los roles
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER, CREATE PROCEDURE TO ROL_DESARCHIVE_AUTEN;

---Creacion de tablespaces

CREATE TABLESPACE ORCL_DESARCHIVE_AUTEN_DATA DATAFILE '&TABLESPACEDATA' SIZE 10m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED;
CREATE TABLESPACE ORCL_DESARCHIVE_AUTEN_IDX  DATAFILE '&TABLESPACEIDX'  SIZE 10m AUTOEXTEND ON NEXT 10m MAXSIZE UNLIMITED;

--Creacion de usuarios
CREATE USER SCH_ORCL_DESARCHIVE_AUTEN IDENTIFIED BY "SCH_ORCL_DESARCHIVE_AUTEN"
DEFAULT TABLESPACE "ORCL_DESARCHIVE_AUTEN_DATA"
TEMPORARY TABLESPACE "TEMP"
QUOTA UNLIMITED ON "ORCL_DESARCHIVE_AUTEN_DATA";

---Otorgando permisos a usuarios
GRANT ROL_DESARCHIVE_AUTEN TO SCH_ORCL_DESARCHIVE_AUTEN;

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.cargo (
    id_cargo  NUMBER(19) NOT NULL,
    nombre    NVARCHAR2(1000) NOT NULL,
	es_activo NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.cargo ADD CONSTRAINT pk_crg PRIMARY KEY ( id_cargo );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.credencial (
    id_credencial      NUMBER(19) NOT NULL,
    usuario            NVARCHAR2(100) NOT NULL,
    contrasena         NVARCHAR2(100) NOT NULL,
    intentos_invalidos NUMBER(19) NOT NULL,
    id_usuario         NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.credencial ADD CONSTRAINT pk_crd PRIMARY KEY ( id_credencial );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.departamento (
    id_departamento NUMBER(19) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    codigo          NVARCHAR2(1000) NOT NULL,
    es_activo       NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.departamento ADD CONSTRAINT pk_dep PRIMARY KEY ( id_departamento );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.dependencia (
    id_dependencia       NUMBER(19) NOT NULL,
    codigo               NVARCHAR2(1000) NOT NULL,
    nombre               NVARCHAR2(1000) NOT NULL,
    numero_cuenta        NVARCHAR2(1000),
    es_despacho_judicial NUMBER(1) NOT NULL,
    id_seccional         NUMBER(19) NOT NULL,
    id_municipio         NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.dependencia ADD CONSTRAINT pk_dpn PRIMARY KEY ( id_dependencia );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.detalle_usuario (
    id_detalle_usuario NUMBER(19) NOT NULL,
    id_usuario         NUMBER(19) NOT NULL,
    id_cargo           NUMBER(19) NOT NULL,
    id_dependencia     NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.detalle_usuario ADD CONSTRAINT pk_dtu PRIMARY KEY ( id_detalle_usuario );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_grupo (
    id_estado_grupo NUMBER(19) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_grupo ADD CONSTRAINT pk_egr PRIMARY KEY ( id_estado_grupo );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_menu (
    id_estado_menu NUMBER(19) NOT NULL,
    nombre         NVARCHAR2(1000) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_menu ADD CONSTRAINT pk_esm PRIMARY KEY ( id_estado_menu );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_rol (
    id_estado_rol NUMBER(19) NOT NULL,
    nombre        NVARCHAR2(1000) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_rol ADD CONSTRAINT pk_esr PRIMARY KEY ( id_estado_rol );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_seccional (
    id_estado_seccional NUMBER(19) NOT NULL,
    nombre              NVARCHAR2(1000) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_seccional ADD CONSTRAINT pk_ess PRIMARY KEY ( id_estado_seccional );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_usuario (
    id_estado_usuario NUMBER(19) NOT NULL,
    nombre            NVARCHAR2(1000) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.estado_usuario ADD CONSTRAINT pk_eus PRIMARY KEY ( id_estado_usuario );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.grupo (
    id_grupo        NUMBER(19) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    id_estado_grupo NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.grupo ADD CONSTRAINT pk_grp PRIMARY KEY ( id_grupo );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.menu (
    id_menu        NUMBER(19) NOT NULL,
    nombre         NVARCHAR2(1000) NOT NULL,
    id_menu_padre  NUMBER(19) NOT NULL,
    id_estado_menu NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menu ADD CONSTRAINT pk_men PRIMARY KEY ( id_menu );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrol (
    id_menu     NUMBER(19) NOT NULL,
    id_rol      NUMBER(19) NOT NULL,
    ver_menu    NUMBER(1) NOT NULL,
    ver         NUMBER(1) NOT NULL,
    inhabilitar NUMBER(1) NOT NULL,
    crear       NUMBER(1) NOT NULL,
    editar      NUMBER(1) NOT NULL,
    eliminar    NUMBER(1) NOT NULL,
    es_activo   NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrol ADD CONSTRAINT pk_mnr PRIMARY KEY ( id_menu,
                                                                                id_rol );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrolxgrupo (
    id_menu   NUMBER(19) NOT NULL,
    id_rol    NUMBER(19) NOT NULL,
    id_grupo  NUMBER(19) NOT NULL,
    es_activo NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrolxgrupo
    ADD CONSTRAINT pk_mrg PRIMARY KEY ( id_rol,
                                        id_menu,
                                        id_grupo );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.municipio (
    id_municipio    NUMBER(19) NOT NULL,
    codigo          NVARCHAR2(1000) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    id_departamento NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.municipio ADD CONSTRAINT pk_mun PRIMARY KEY ( id_municipio );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.rol (
    id_rol        NUMBER(19) NOT NULL,
    nombre        NVARCHAR2(1000) NOT NULL,
    id_estado_rol NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.rol ADD CONSTRAINT pk_rol PRIMARY KEY ( id_rol );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.rolesxgrupo (
    id_rol    NUMBER(19) NOT NULL,
    id_grupo  NUMBER(19) NOT NULL,
    es_activo NUMBER(1) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.rolesxgrupo ADD CONSTRAINT pk_rxg PRIMARY KEY ( id_grupo,
                                                                                  id_rol );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.seccional (
    id_seccional        NUMBER(19) NOT NULL,
    nombre              NVARCHAR2(1000) NOT NULL,
    id_estado_seccional NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.seccional ADD CONSTRAINT pk_scn PRIMARY KEY ( id_seccional );

CREATE TABLE SCH_ORCL_DESARCHIVE_AUTEN.usuario (
    id_usuario        NUMBER(19) NOT NULL,
    primer_nombre     NVARCHAR2(1000) NOT NULL,
    segundo_nombre    NVARCHAR2(1000) NOT NULL,
    primer_apellido   NVARCHAR2(1000) NOT NULL,
    segundo_apellido  NVARCHAR2(1000) NOT NULL,
    id_rol            NUMBER(19) NOT NULL,
    id_estado_usuario NUMBER(19) NOT NULL
);

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.usuario ADD CONSTRAINT pk_usu PRIMARY KEY ( id_usuario );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.detalle_usuario
    ADD CONSTRAINT fk_crg_dtu FOREIGN KEY ( id_cargo )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.cargo ( id_cargo );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.dependencia
    ADD CONSTRAINT fk_dep_dpn FOREIGN KEY ( id_municipio )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.departamento ( id_departamento );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.municipio
    ADD CONSTRAINT fk_dep_mun FOREIGN KEY ( id_departamento )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.departamento ( id_departamento );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.detalle_usuario
    ADD CONSTRAINT fk_dpn_dtu FOREIGN KEY ( id_dependencia )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.dependencia ( id_dependencia );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.usuario
    ADD CONSTRAINT fk_dtu_usu FOREIGN KEY ( id_usuario )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.detalle_usuario ( id_detalle_usuario );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.grupo
    ADD CONSTRAINT fk_egr_grp FOREIGN KEY ( id_estado_grupo )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.estado_grupo ( id_estado_grupo );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menu
    ADD CONSTRAINT fk_esm_men FOREIGN KEY ( id_estado_menu )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.estado_menu ( id_estado_menu );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.rol
    ADD CONSTRAINT fk_esr_rol FOREIGN KEY ( id_estado_rol )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.estado_rol ( id_estado_rol );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.seccional
    ADD CONSTRAINT fk_ess_scn FOREIGN KEY ( id_estado_seccional )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.estado_seccional ( id_estado_seccional );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.usuario
    ADD CONSTRAINT fk_eus_usu FOREIGN KEY ( id_estado_usuario )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.estado_usuario ( id_estado_usuario );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrolxgrupo
    ADD CONSTRAINT fk_grp_mrg FOREIGN KEY ( id_grupo )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.grupo ( id_grupo );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.rolesxgrupo
    ADD CONSTRAINT fk_grp_rxg FOREIGN KEY ( id_grupo )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.grupo ( id_grupo );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrol
    ADD CONSTRAINT fk_men_mnr FOREIGN KEY ( id_menu )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.menu ( id_menu );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrolxgrupo
    ADD CONSTRAINT fk_men_mrg FOREIGN KEY ( id_menu )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.menu ( id_menu );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.dependencia
    ADD CONSTRAINT fk_mun_dep FOREIGN KEY ( id_municipio )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.municipio ( id_municipio );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrol
    ADD CONSTRAINT fk_rol_mnr FOREIGN KEY ( id_rol )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.rol ( id_rol );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.menusxrolxgrupo
    ADD CONSTRAINT fk_rol_mrg FOREIGN KEY ( id_rol )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.rol ( id_rol );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.rolesxgrupo
    ADD CONSTRAINT fk_rol_rxg FOREIGN KEY ( id_rol )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.rol ( id_rol );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.usuario
    ADD CONSTRAINT fk_rol_usu FOREIGN KEY ( id_rol )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.rol ( id_rol );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.dependencia
    ADD CONSTRAINT fk_scn_dpn FOREIGN KEY ( id_seccional )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.seccional ( id_seccional );

ALTER TABLE SCH_ORCL_DESARCHIVE_AUTEN.credencial
    ADD CONSTRAINT fk_usu_crd FOREIGN KEY ( id_usuario )
        REFERENCES SCH_ORCL_DESARCHIVE_AUTEN.usuario ( id_usuario );

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_cargo START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_cargo BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.cargo
    FOR EACH ROW
    WHEN ( new.id_cargo IS NULL )
BEGIN
    :new.id_cargo := SCH_ORCL_DESARCHIVE_AUTEN.seq_cargo.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_cred START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_credencial BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.credencial
    FOR EACH ROW
    WHEN ( new.id_credencial IS NULL )
BEGIN
    :new.id_credencial := SCH_ORCL_DESARCHIVE_AUTEN.seq_cred.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_departamento START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_departamento BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.departamento
    FOR EACH ROW
    WHEN ( new.id_departamento IS NULL )
BEGIN
    :new.id_departamento := SCH_ORCL_DESARCHIVE_AUTEN.seq_departamento.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_dependencia START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_dependencia BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.dependencia
    FOR EACH ROW
    WHEN ( new.id_dependencia IS NULL )
BEGIN
    :new.id_dependencia := SCH_ORCL_DESARCHIVE_AUTEN.seq_dependencia.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_grupo START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_estado_grupo BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.estado_grupo
    FOR EACH ROW
    WHEN ( new.id_estado_grupo IS NULL )
BEGIN
    :new.id_estado_grupo := SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_grupo.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_menu START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_estado_menu BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.estado_menu
    FOR EACH ROW
    WHEN ( new.id_estado_menu IS NULL )
BEGIN
    :new.id_estado_menu := SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_menu.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_esrol START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_estado_rol BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.estado_rol
    FOR EACH ROW
    WHEN ( new.id_estado_rol IS NULL )
BEGIN
    :new.id_estado_rol := SCH_ORCL_DESARCHIVE_AUTEN.seq_esrol.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_seccional START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_estado_seccional BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.estado_seccional
    FOR EACH ROW
    WHEN ( new.id_estado_seccional IS NULL )
BEGIN
    :new.id_estado_seccional := SCH_ORCL_DESARCHIVE_AUTEN.seq_estado_seccional.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_esusu START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_estado_usuario BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.estado_usuario
    FOR EACH ROW
    WHEN ( new.id_estado_usuario IS NULL )
BEGIN
    :new.id_estado_usuario := SCH_ORCL_DESARCHIVE_AUTEN.seq_esusu.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_grupo START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_grupo BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.grupo
    FOR EACH ROW
    WHEN ( new.id_grupo IS NULL )
BEGIN
    :new.id_grupo := SCH_ORCL_DESARCHIVE_AUTEN.seq_grupo.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_menu START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_menu BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.menu
    FOR EACH ROW
    WHEN ( new.id_menu IS NULL )
BEGIN
    :new.id_menu := SCH_ORCL_DESARCHIVE_AUTEN.seq_menu.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_municipio START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_municipio BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.municipio
    FOR EACH ROW
    WHEN ( new.id_municipio IS NULL )
BEGIN
    :new.id_municipio := SCH_ORCL_DESARCHIVE_AUTEN.seq_municipio.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_rol START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_rol BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.rol
    FOR EACH ROW
    WHEN ( new.id_rol IS NULL )
BEGIN
    :new.id_rol := SCH_ORCL_DESARCHIVE_AUTEN.seq_rol.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_seccional START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_seccional BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.seccional
    FOR EACH ROW
    WHEN ( new.id_seccional IS NULL )
BEGIN
    :new.id_seccional := SCH_ORCL_DESARCHIVE_AUTEN.seq_seccional.nextval;
END;
/

CREATE SEQUENCE SCH_ORCL_DESARCHIVE_AUTEN.seq_usuario START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DESARCHIVE_AUTEN.trg_usuario BEFORE
    INSERT ON SCH_ORCL_DESARCHIVE_AUTEN.usuario
    FOR EACH ROW
    WHEN ( new.id_usuario IS NULL )
BEGIN
    :new.id_usuario := SCH_ORCL_DESARCHIVE_AUTEN.seq_usuario.nextval;
END;
/

--- Generacion de permisos
DECLARE
  v_rol  VARCHAR2(4000);
  CURSOR c_permisos
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCH_ORCL_DESARCHIVE_AUTEN.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  r_per c_permisos%ROWTYPE;
BEGIN
  v_rol := 'ROL_DESARCHIVE_AUTEN';
  
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