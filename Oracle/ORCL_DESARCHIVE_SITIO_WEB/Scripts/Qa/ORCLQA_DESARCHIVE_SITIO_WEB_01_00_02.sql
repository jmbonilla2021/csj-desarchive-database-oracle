/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Creacion del modelo relacional BD DESARCHIVE SITIO WEB Modulo desarchive.
-- PARÁMETROS DE ENTRADA     : La ejecución del script solicita los siguientes parametros
								SERVICIO        : ORCLQA_DESARCHIVE_SWEB
								SIZE_TABLESPACE : DEVOPS -> 10
								                  19C    -> 1000
												  21C    -> 1000
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             : Gabriel Eduardo Duarte             
-- FECHAHORA                 : 2021/11/23
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
	PROC_AUDITA_OBJETOS('DESARCHIVE SITIO WEB QA','ORCLQA_DESARCHIVE_SWEB','CREACION BD',NULL,NULL);
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
    
    EXECUTE IMMEDIATE 'CREATE ROLE ROLQA_DESARCHIVE_SWEB';
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA ROL OK.',NULL,NULL);
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,CREATE PROCEDURE TO ROLQA_DESARCHIVE_SWEB';
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
    EXECUTE IMMEDIATE 'GRANT ROLQA_DESARCHIVE_SWEB TO '||V_USUARIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORTANDO PERMISOS ROL, OK...',NULL,NULL);
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA CREACION OBJETOS BD ....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR DURANTE INSTALACION BD',SQLCODE,SQLERRM);
END;
/

CREATE TABLE SCHQA_ORCL_DESARCHIVE_SWEB.ESTADO_SOLICITUD (
    ID_ESTADO_SOLICITUD NUMBER(19) NOT NULL,
    NOMBRE              NVARCHAR2(1000) NOT NULL,
    CODIGO              NVARCHAR2(1000) NOT NULL,
    ES_ACTIVO           NUMBER(1) NOT NULL
);

CREATE UNIQUE INDEX SCHQA_ORCL_DESARCHIVE_SWEB.IDX_CODIGO_ESTADO_SOLICITUD ON
    SCHQA_ORCL_DESARCHIVE_SWEB.ESTADO_SOLICITUD (
        CODIGO
    ASC );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.ESTADO_SOLICITUD ADD CONSTRAINT PK_ESS PRIMARY KEY ( ID_ESTADO_SOLICITUD );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_SWEB.PROCESO (
    ID_PROCESO          NUMBER(19) NOT NULL,
    NUMERO_PROCESO      NUMBER(19) NOT NULL,
    INFORMACION_PAQUETE NVARCHAR2(1000) NOT NULL,
    OBSERVACIONES       NVARCHAR2(2000) NOT NULL,
    ID_ANIO_PROCESO     NUMBER(19) NOT NULL,
    ID_SOLICITUD        NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.PROCESO ADD CONSTRAINT PK_PRO PRIMARY KEY ( ID_PROCESO );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SOLICITUD (
    ID_SOLICITUD        NUMBER NOT NULL,
    NOMBRES_APELLIDOS   NVARCHAR2(1000) NOT NULL,
    NUMERO_DOCUMENTO    NVARCHAR2(1000) NOT NULL,
    NUMERO_CELULAR      NVARCHAR2(1000) NOT NULL,
    CORREO_NOTIFICACION NVARCHAR2(1000) NOT NULL,
    FECHA_CREA          DATE NOT NULL,
    USUARIO_CREA        NVARCHAR2(1000),
    ID_TIPO_DOCUMENTO   NUMBER(19) NOT NULL,
    ID_TIPO_PROCESO     NUMBER(19) NOT NULL,
    ID_JUZGADO          NUMBER(19) NOT NULL,
    ID_ESPECIALIDAD     NUMBER(19) NOT NULL,
    ID_ESTADO_SOLICITUD NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SOLICITUD ADD CONSTRAINT PK_SLC PRIMARY KEY ( ID_SOLICITUD );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL (
    ID_SUJETO_PROCESAL      NUMBER(19) NOT NULL,
    NOMBRES_APELLIDOS       NVARCHAR2(1000) NOT NULL,
    ID_TIPO_SUJETO_PROCESAL NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL ADD CONSTRAINT PK_SJP PRIMARY KEY ( ID_SUJETO_PROCESAL );

CREATE TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL_X_PROCESO (
    ID_SUJETO_PROCESAL NUMBER(19) NOT NULL,
    ID_PROCESO         NUMBER(19) NOT NULL
);

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL_X_PROCESO ADD CONSTRAINT PK_SPP PRIMARY KEY ( ID_SUJETO_PROCESAL,
                                                                                                   ID_PROCESO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SOLICITUD
    ADD CONSTRAINT FK_ESS_SLC FOREIGN KEY ( ID_ESTADO_SOLICITUD )
        REFERENCES SCHQA_ORCL_DESARCHIVE_SWEB.ESTADO_SOLICITUD ( ID_ESTADO_SOLICITUD );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL_X_PROCESO
    ADD CONSTRAINT FK_PRO_SPP FOREIGN KEY ( ID_PROCESO )
        REFERENCES SCHQA_ORCL_DESARCHIVE_SWEB.PROCESO ( ID_PROCESO );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL_X_PROCESO
    ADD CONSTRAINT FK_SJP_SPP FOREIGN KEY ( ID_SUJETO_PROCESAL )
        REFERENCES SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL ( ID_SUJETO_PROCESAL );

ALTER TABLE SCHQA_ORCL_DESARCHIVE_SWEB.PROCESO
    ADD CONSTRAINT FK_SLC_PRO FOREIGN KEY ( ID_SOLICITUD )
        REFERENCES SCHQA_ORCL_DESARCHIVE_SWEB.SOLICITUD ( ID_SOLICITUD );

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_ESTADO_SOLICITUD START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_SWEB.TRG_ESTADO_SOLICITUD BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_SWEB.ESTADO_SOLICITUD
    FOR EACH ROW
    WHEN ( NEW.ID_ESTADO_SOLICITUD IS NULL )
BEGIN
    :NEW.ID_ESTADO_SOLICITUD := SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_ESTADO_SOLICITUD.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_PROCESO START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_SWEB.TRG_PROCESO BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_SWEB.PROCESO
    FOR EACH ROW
    WHEN ( NEW.ID_PROCESO IS NULL )
BEGIN
    :NEW.ID_PROCESO := SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_PROCESO.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_SOLICITUD START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_SWEB.TRG_SOLICITUD BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_SWEB.SOLICITUD
    FOR EACH ROW
    WHEN ( NEW.ID_SOLICITUD IS NULL )
BEGIN
    :NEW.ID_SOLICITUD := SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_SOLICITUD.NEXTVAL;
END;
/

CREATE SEQUENCE SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_SUJETO_PROCESAL START WITH 1 CACHE 100 ORDER;

CREATE OR REPLACE TRIGGER SCHQA_ORCL_DESARCHIVE_SWEB.TRG_SUJETO_PROCESAL BEFORE
    INSERT ON SCHQA_ORCL_DESARCHIVE_SWEB.SUJETO_PROCESAL
    FOR EACH ROW
    WHEN ( NEW.ID_SUJETO_PROCESAL IS NULL )
BEGIN
    :NEW.ID_SUJETO_PROCESAL := SCHQA_ORCL_DESARCHIVE_SWEB.SEQ_SUJETO_PROCESAL.NEXTVAL;
END;
/

--- GENERACION DE PERMISOS 
DECLARE
  V_ROL  VARCHAR2(4000);
  CURSOR C_PERMISOS
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCHQA_ORCL_DESARCHIVE_SWEB.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  R_PER C_PERMISOS%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA CREACION OBJETOS OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION PERMISOS OBJETOS....',NULL,NULL);
  V_ROL := 'ROLQA_DESARCHIVE_SWEB';
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
  v_idx   VARCHAR2(4000):= 'ORCLQA_DESARCHIVE_SWEB_IDX';
  v_ow    VARCHAR2(4000):= 'SCHQA_ORCL_DESARCHIVE_SWEB';
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
  PROC_AUDITA_OBJETOS('DESARCHIVE SITIO WEB QA','ORCLQA_DESARCHIVE_SWEB','FINALIZACION CREACION BD',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF c_index%ISOPEN THEN CLOSE c_index; END IF;
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR ASIGNANDO OBJ A TABLESPACES IDX....',SQLCODE,SQLERRM);
END;