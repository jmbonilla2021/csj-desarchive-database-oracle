/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : CREACION DEL MODELO RELACIONAL BD DIA FESTIVO MODULO DIA FESTIVO.
-- PARÁMETROS DE ENTRADA     : LA EJECUCIÓN DEL SCRIPT SOLICITA LOS SIGUIENTES PARAMETROS
								SERVICIO        : ORCL_DIA_FESTIVO
								SIZE_TABLESPACE : DEVOPS -> 10
								                  19C    -> 1000
												  21C    -> 1000
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             : GABRIEL EDUARDO DUARTE             
-- FECHAHORA                 : 2022/02/17
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           ESTE COMPONENTE FUE REALIZADO BAJO LA METODOLOGÍA DE DESARROLLO DE INFORMÁTICA & TECNOLOGÍA 
--                             Y SE ENCUENTRA PROTEGIDO POR LAS LEYES DE DERECHOS DE AUTOR.
-- FECHAHORA MODIFICACIÓN    : 
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : JUAN MANUEL NUÑEZ BONILLA
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
	PROC_AUDITA_OBJETOS('CSJ','ORCL_DIA_FESTIVO','CREACION BD',NULL,NULL);
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
    
    EXECUTE IMMEDIATE 'CREATE ROLE ROL_ORCL_DIA_FESTIVO';
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA ROL OK.',NULL,NULL);
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,CREATE PROCEDURE TO ROL_ORCL_DIA_FESTIVO';
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
    EXECUTE IMMEDIATE 'GRANT ROL_ORCL_DIA_FESTIVO TO '||V_USUARIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORTANDO PERMISOS ROL, OK...',NULL,NULL);
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA CREACION OBJETOS BD ....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR DURANTE INSTALACION BD',SQLCODE,SQLERRM);
END;
/

CREATE TABLE SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO (
    ID_DIA_FESTIVO NUMBER(38) NOT NULL,
    ANIO           NUMBER(38) NOT NULL,
    MES            NUMBER(38) NOT NULL,
    DIA            NUMBER(38) NOT NULL,
    FECHA          DATE NOT NULL
);

COMMENT ON TABLE SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO IS
    'TABLA QUE ALMACENA LA INFORMACIÓN DE LOS DÍAS FESTIVOS EN EL CALENDARIO COLOMBIANO.';

COMMENT ON COLUMN SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO.ID_DIA_FESTIVO IS
    'CAMPO QUE ALMACENA EL IDENTIFICADOR ÚNICO DEL DÍA FESTIVO.';

COMMENT ON COLUMN SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO.ANIO IS
    'CAMPO QUE ALMACENA EL AÑO DEL DÍA FESTIVO.';

COMMENT ON COLUMN SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO.MES IS
    'CAMPO QUE ALMACENA EL MES DEL DÍA FESTIVO.';

COMMENT ON COLUMN SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO.DIA IS
    'CAMPO QUE ALMACENA EL DÍA FESTIVO DENTRO DEL MES Y AÑO CORRESPONDIENTE.';

COMMENT ON COLUMN SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO.FECHA IS
    'CAMPO QUE ALMACENA EL DÍA FESTIVO EN FORMATO FECHA.';

ALTER TABLE SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO ADD CONSTRAINT PK_DFE PRIMARY KEY ( ID_DIA_FESTIVO );

CREATE SEQUENCE SCH_ORCL_DIA_FESTIVO.SEQ_DIA_FESTIVO START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER SCH_ORCL_DIA_FESTIVO.TRG_DIA_FESTIVO BEFORE
    INSERT ON SCH_ORCL_DIA_FESTIVO.DIA_FESTIVO
    FOR EACH ROW
    WHEN ( NEW.ID_DIA_FESTIVO IS NULL )
BEGIN
    :NEW.ID_DIA_FESTIVO := SCH_ORCL_DIA_FESTIVO.SEQ_DIA_FESTIVO.NEXTVAL;
END;
/

--- GENERACION DE PERMISOS 
DECLARE
  V_ROL  VARCHAR2(4000);
  CURSOR C_PERMISOS
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCH_ORCL_DIA_FESTIVO.'||TABLE_NAME||' TO ' AS SENTENCIA
	FROM   ALL_TABLES
    WHERE  OWNER = 'SCH_ORCL_DIA_FESTIVO';
  R_PER C_PERMISOS%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA CREACION OBJETOS OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION PERMISOS OBJETOS....',NULL,NULL);
  V_ROL := 'ROL_ORCL_DIA_FESTIVO';
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
  V_IDX   VARCHAR2(4000):= 'ORCL_DIA_FESTIVO_IDX';
  V_OW    VARCHAR2(4000):= 'SCH_ORCL_DIA_FESTIVO';
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
  PROC_AUDITA_OBJETOS('CSJ','ORCL_DIA_FESTIVO','FINALIZACION CREACION BD',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF C_INDEX%ISOPEN THEN CLOSE C_INDEX; END IF;
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR ASIGNANDO OBJ A TABLESPACES IDX....',SQLCODE,SQLERRM);
END;