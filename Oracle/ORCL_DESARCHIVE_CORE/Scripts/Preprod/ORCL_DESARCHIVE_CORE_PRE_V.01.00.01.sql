/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : CREACION DEL MODELO RELACIONAL BD DESARCHIVE SITIO WEB MODULO DESARCHIVE.
-- PARÁMETROS DE ENTRADA     : LA EJECUCIÓN DEL SCRIPT SOLICITA LOS SIGUIENTES PARAMETROS
								SERVICIO        : ORCL_DESARCHIVE_CORE_PRE
								SIZE_TABLESPACE : DEVOPS -> 10
								                  19C    -> 1000
												  21C    -> 1000
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             : GABRIEL EDUARDO DUARTE             
-- FECHAHORA                 : 2021/11/30
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
	PROC_AUDITA_OBJETOS('DESARCHIVE SITIO WEB','ORCL_DESARCHIVE_CORE_PRE','CREACION BD',NULL,NULL);
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
    
    EXECUTE IMMEDIATE 'CREATE ROLE ROL_DESARCHIVE_CORE_PRE';
    PROC_AUDITA_OBJETOS(NULL,NULL,'CREA ROL OK.',NULL,NULL);
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE TRIGGER,CREATE PROCEDURE TO ROL_DESARCHIVE_CORE_PRE';
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
    EXECUTE IMMEDIATE 'GRANT ROL_DESARCHIVE_CORE_PRE TO '||V_USUARIO;
    PROC_AUDITA_OBJETOS(NULL,NULL,'OTORTANDO PERMISOS ROL, OK...',NULL,NULL);
    PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA CREACION OBJETOS BD ....',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR DURANTE INSTALACION BD',SQLCODE,SQLERRM);
END;
/

CREATE TABLE sch_orcl_desarchive_core_pre.anio (
    id_anio   NUMBER(38) NOT NULL,
    codigo    NVARCHAR2(2000) NOT NULL,
    es_activo NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.anio IS
    'Tabla que almacena la información de los años de los Procesos.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.anio.id_anio IS
    'Campo que almacena el identificador único del año.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.anio.codigo IS
    'Campo que almacena el código único por cada año.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.anio.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del año.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_anio ON
    sch_orcl_desarchive_core_pre.anio (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.anio ADD CONSTRAINT pk_ani PRIMARY KEY ( id_anio );

CREATE TABLE sch_orcl_desarchive_core_pre.bodega (
    id_bodega      NUMBER(38) NOT NULL,
    identificacion NVARCHAR2(1000) NOT NULL,
    nombre         NVARCHAR2(1000) NOT NULL,
    telefono       NVARCHAR2(500) NOT NULL,
    direccion      NVARCHAR2(1000) NOT NULL,
    es_activo      NUMBER(1) NOT NULL,
    id_municipio   NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.bodega IS
    'Tabla que almacena la información de las Bodegas.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.id_bodega IS
    'Campo que almacena el identificador único de Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.identificacion IS
    'Campo que almacena la identificación de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.nombre IS
    'Campo que almacena el nombre de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.telefono IS
    'Campo que almacena el teléfono de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.direccion IS
    'Campo que almacena la dirección de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.bodega.id_municipio IS
    'Campo que almacena el identificador del Municipio donde se encuentra ubicada la Bodega.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_identificacion ON
    sch_orcl_desarchive_core_pre.bodega (
        identificacion
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.bodega ADD CONSTRAINT pk_bdg PRIMARY KEY ( id_bodega );

CREATE TABLE sch_orcl_desarchive_core_pre.detalle_paquete (
    id_detalle     NUMBER(38) NOT NULL,
    anio_paquete   NVARCHAR2(2000),
    numero_paquete NVARCHAR2(2000),
    id_proceso     NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.detalle_paquete IS
    'Tabla que almacena la información de los Detalles de los Paquetes, referentes a los procesos que se van a desarchivar.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.detalle_paquete.id_detalle IS
    'Campo que almacena el identificador único del Detalle de Paquete.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.detalle_paquete.anio_paquete IS
    'Campo que almacena el año del Paquete.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.detalle_paquete.numero_paquete IS
    'Campo que almacena el número del Paquete.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.detalle_paquete.id_proceso IS
    'Campo que almacena el identificador del Proceso al cual pertenece el Paquete.';

ALTER TABLE sch_orcl_desarchive_core_pre.detalle_paquete ADD CONSTRAINT pk_dpq PRIMARY KEY ( id_detalle );

CREATE TABLE sch_orcl_desarchive_core_pre.esp_x_tipo_proceso (
    id_tipo_proceso      NUMBER(38) NOT NULL,
    id_especialidad      NUMBER(38) NOT NULL,
    requiere_pago        NUMBER(1),
    es_visible_sitio_web NUMBER(1)
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.esp_x_tipo_proceso IS
    'Tabla que almacena la información de las Especialidades por Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.esp_x_tipo_proceso.id_tipo_proceso IS
    'Campo que almacena el identificador único del Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.esp_x_tipo_proceso.id_especialidad IS
    'Campo que almacena el identificador único de la Especialidad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.esp_x_tipo_proceso.requiere_pago IS
    'Campo que almacena si requiere pago o no.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.esp_x_tipo_proceso.es_visible_sitio_web IS
    'Campo que almacena si es visible en el sitio web.';

ALTER TABLE sch_orcl_desarchive_core_pre.esp_x_tipo_proceso ADD CONSTRAINT pk_ext PRIMARY KEY ( id_tipo_proceso,
                                                                                                id_especialidad );

CREATE TABLE sch_orcl_desarchive_core_pre.especialidad (
    id_especialidad NUMBER(38) NOT NULL,
    codigo          NVARCHAR2(2000) NOT NULL,
    nombre          NVARCHAR2(30) NOT NULL,
    es_activo       NUMBER(1) NOT NULL,
    id_jurisdiccion NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.especialidad IS
    'Tabla que almacena la información de las Especialidades.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.especialidad.id_especialidad IS
    'Campo que almacena el identificador único de la Especialidad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.especialidad.codigo IS
    'Campo que almacena el código único de la Especialidad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.especialidad.nombre IS
    'Campo que almacena el nombre de la Especialidad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.especialidad.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO de la Especialidad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.especialidad.id_jurisdiccion IS
    'Campo que almacena el identificador de la Jurisdicción al cual pertenece la Especialidad.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_especialidad ON
    sch_orcl_desarchive_core_pre.especialidad (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.especialidad ADD CONSTRAINT pk_esp PRIMARY KEY ( id_especialidad );

CREATE TABLE sch_orcl_desarchive_core_pre.estado_novedad (
    id_estado_novedad NUMBER(38) NOT NULL,
    codigo            NVARCHAR2(1000) NOT NULL,
    nombre            NVARCHAR2(1000) NOT NULL,
    es_activo         NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.estado_novedad IS
    'Tabla que almacena la información de los Estados de las Novedades.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_novedad.id_estado_novedad IS
    'Campo que almacena el identificador único del Estado de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_novedad.codigo IS
    'Campo que almacena el código del Estado de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_novedad.nombre IS
    'Campo que almacena el nombre del Estado de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_novedad.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Estado de la Novedad.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_estado_novedad ON
    sch_orcl_desarchive_core_pre.estado_novedad (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.estado_novedad ADD CONSTRAINT pk_eno PRIMARY KEY ( id_estado_novedad );

CREATE TABLE sch_orcl_desarchive_core_pre.estado_solicitud (
    id_estado_solicitud NUMBER(38) NOT NULL,
    codigo              NVARCHAR2(1000) NOT NULL,
    nombre              NVARCHAR2(1000) NOT NULL,
    es_activo           NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.estado_solicitud IS
    'Tabla que almacena la información de los Estados de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_solicitud.id_estado_solicitud IS
    'Campo que almacena el identificador único del Estado de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_solicitud.codigo IS
    'Campo que almacena el código único del Estado de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_solicitud.nombre IS
    'Campo que almacena el nombre del Estado de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.estado_solicitud.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Estado de la Solicitud.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_estado_solicitud ON
    sch_orcl_desarchive_core_pre.estado_solicitud (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.estado_solicitud ADD CONSTRAINT pk_ess PRIMARY KEY ( id_estado_solicitud );

CREATE TABLE sch_orcl_desarchive_core_pre.historico_tarifa (
    id_historico_tarifa NUMBER(38) NOT NULL,
    nombre              NVARCHAR2(2000),
    codigo              NVARCHAR2(1000),
    valor               NUMBER(19, 4),
    fecha_actualizacion DATE,
    id_tarifa           NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.historico_tarifa IS
    'Tabla que almacena el histórico de las tarifas aplicadas en el desarchive de los procesos.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.id_historico_tarifa IS
    'Campo que almacena el identificador único del histórico de tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.nombre IS
    'Campo que almacena el nombre de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.codigo IS
    'Campo que almacena el código de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.valor IS
    'Campo que almacena el valor de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.fecha_actualizacion IS
    'Campo que almacena la fecha de actualización de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.historico_tarifa.id_tarifa IS
    'Campo que almacena el identificador de la tarifa.';

ALTER TABLE sch_orcl_desarchive_core_pre.historico_tarifa ADD CONSTRAINT pk_htf PRIMARY KEY ( id_historico_tarifa );

CREATE TABLE sch_orcl_desarchive_core_pre.jurisdiccion (
    id_jurisdiccion NUMBER(38) NOT NULL,
    codigo          NVARCHAR2(2000) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    es_activo       NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.jurisdiccion IS
    'Tabla que almacena la información de las Jurisdicciones.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion.id_jurisdiccion IS
    'Campo que almacena el identificador único de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion.codigo IS
    'Campo que almacena el código único por cada Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion.nombre IS
    'Campo que almacena el nombre de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO de la Jurisdicción.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_jdc_codigo ON
    sch_orcl_desarchive_core_pre.jurisdiccion (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.jurisdiccion ADD CONSTRAINT pk_jdc PRIMARY KEY ( id_jurisdiccion );

CREATE TABLE sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega (
    id_bodega       NUMBER(38) NOT NULL,
    id_jurisdiccion NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega IS
    'Tabla que almacena la información de las Jurisdicciones por Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega.id_bodega IS
    'Campo que almacena el identificador de Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega.id_jurisdiccion IS
    'Campo que almacena el identificador de la Jurisdicción.';

ALTER TABLE sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega ADD CONSTRAINT pk_jxb PRIMARY KEY ( id_bodega,
                                                                                                     id_jurisdiccion );

CREATE TABLE sch_orcl_desarchive_core_pre.juzgado (
    id_juzgado      NUMBER(38) NOT NULL,
    codigo          NVARCHAR2(2000) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    es_activo       NUMBER(1) NOT NULL,
    id_municipio    NUMBER(38) NOT NULL,
    id_especialidad NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.juzgado IS
    'Tabla que almacena la información de las Jurisdicciones.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.id_juzgado IS
    'Campo que almacena el identificador único de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.codigo IS
    'Campo que almacena el código único de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.nombre IS
    'Campo que almacena el nombre de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO de la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.id_municipio IS
    'Campo que almacena el identificador del Municipio al cual pertenece la Jurisdicción.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.juzgado.id_especialidad IS
    'Campo que almacena el identificador de la Especialidad al cual pertenece la Jurisdicción.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_juzgado ON
    sch_orcl_desarchive_core_pre.juzgado (
        codigo
    ASC,
        id_especialidad
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.juzgado ADD CONSTRAINT pk_juz PRIMARY KEY ( id_juzgado );

CREATE TABLE sch_orcl_desarchive_core_pre.novedad (
    id_novedad                 NUMBER(38) NOT NULL,
    codigo_tipo_identificacion NVARCHAR2(1000) NOT NULL,
    numero_identificacion      NVARCHAR2(1000) NOT NULL,
    fecha_inicio               DATE NOT NULL,
    fecha_fin                  DATE NOT NULL,
    observacion                NVARCHAR2(2000),
    id_tipo_novedad            NUMBER(38) NOT NULL,
    id_estado_novedad          NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.novedad IS
    'Tabla que almacena la información de las Novedades.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.id_novedad IS
    'Campo que almacena el identificador único de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.codigo_tipo_identificacion IS
    'Campo que almacena el código del Tipo de Identificación de la persona persona involucrada en la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.numero_identificacion IS
    'Campo que almacena el código el Número de Identificación de la persona involucrada en la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.fecha_inicio IS
    'Campo que almacena la fecha de inicio de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.fecha_fin IS
    'Campo que almacena la fecha de finalización de la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.observacion IS
    'Campo que almacena las observaciones referentes a la Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.id_tipo_novedad IS
    'Campo que almacena el identificador del Tipo de Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.novedad.id_estado_novedad IS
    'Campo que almacena el identificador del Estado de la Novedad.';

ALTER TABLE sch_orcl_desarchive_core_pre.novedad
    ADD CONSTRAINT pk_nov PRIMARY KEY ( id_novedad,
                                        codigo_tipo_identificacion,
                                        numero_identificacion );

CREATE TABLE sch_orcl_desarchive_core_pre.parametro (
    id_parametro     NUMBER(38) NOT NULL,
    nombre_clave     NVARCHAR2(1000) NOT NULL,
    valor            NVARCHAR2(1000) NOT NULL,
    id_procedimiento NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.parametro IS
    'Tabla que almacena la información de los Parámetros utilizados en la aplicación.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.parametro.id_parametro IS
    'Campo que almacena el identificador único del Parámetro.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.parametro.nombre_clave IS
    'Campo que almacena el nombre cleve del Parámetro.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.parametro.valor IS
    'Campo que almacena el valor del Parámetro.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.parametro.id_procedimiento IS
    'Campo que almacena el identificador del Procedimiento al cual pertenece el Parámetro.';

ALTER TABLE sch_orcl_desarchive_core_pre.parametro ADD CONSTRAINT pk_prm PRIMARY KEY ( id_parametro );

CREATE TABLE sch_orcl_desarchive_core_pre.procedimiento (
    id_procedimiento NUMBER(38) NOT NULL,
    codigo           NVARCHAR2(1000) NOT NULL,
    nombre           NVARCHAR2(1000) NOT NULL,
    es_activo        NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.procedimiento IS
    'Tabla que almacena la información de los Procedimientos o Sistemas que tienen Parámetros para su funcionamiento.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.procedimiento.id_procedimiento IS
    'Campo que almacena el identificador único de Procedimiento.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.procedimiento.codigo IS
    'Campo que almacena el código único por cada Procedimiento.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.procedimiento.nombre IS
    'Campo que almacena el nombre del Procedimiento.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.procedimiento.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Procedimento.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_proceso ON
    sch_orcl_desarchive_core_pre.procedimiento (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.procedimiento ADD CONSTRAINT pk_prc PRIMARY KEY ( id_procedimiento );

CREATE TABLE sch_orcl_desarchive_core_pre.proceso (
    id_proceso          NUMBER(38) NOT NULL,
    numero_proceso      NUMBER(38) NOT NULL,
    numero_proceso_jud  NUMBER(38),
    observaciones       NVARCHAR2(2000),
    codigo_anio_proceso NVARCHAR2(2000) NOT NULL,
    id_solicitud        NUMBER(38) NOT NULL,
    id_municipio        NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.proceso IS
    'Tabla que almacena la información de los Procesos a desarchivar.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.id_proceso IS
    'Campo que almacena el identificador único del Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.numero_proceso IS
    'Campo que almacena el número de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.numero_proceso_jud IS
    'Campo que almacena el Número de Proceso Judicial (CUI).';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.observaciones IS
    'Campo que almacena las observaciones referentes al Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.codigo_anio_proceso IS
    'Campo que almacena el código del año del Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.id_solicitud IS
    'Campo que almacena el identificador de la solicitud al cual pertenece el proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.proceso.id_municipio IS
    'Campo que almacena el identificador del municipio al cual pertenece el proceso.';

ALTER TABLE sch_orcl_desarchive_core_pre.proceso ADD CONSTRAINT pk_pro PRIMARY KEY ( id_proceso );

CREATE TABLE sch_orcl_desarchive_core_pre.solicitud_des (
    id_solicitud_des         NUMBER(38) NOT NULL,
    numero_identificacion    NVARCHAR2(1000) NOT NULL,
    primer_nombre            NVARCHAR2(1000) NOT NULL,
    segundo_nombre           NVARCHAR2(1000),
    primer_apellido          NVARCHAR2(1000) NOT NULL,
    segundo_apellido         NVARCHAR2(1000),
    nombres_apellidos        NVARCHAR2(2000) NOT NULL,
    telefono                 NVARCHAR2(1000) NOT NULL,
    correo_notificacion      NVARCHAR2(1000) NOT NULL,
    codigo_tipo_proceso      NVARCHAR2(2000) NOT NULL,
    codigo_juzgado           NVARCHAR2(2000) NOT NULL,
    codigo_especialidad      NVARCHAR2(2000) NOT NULL,
    codigo_tipo_documento    NVARCHAR2(2000) NOT NULL,
    fecha_radicado_solicitud DATE,
    id_estado_solicitud      NUMBER(38) NOT NULL,
    id_tipo_solicitud        NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.solicitud_des IS
    'Tabla que almacena la información de las Solicitudes de desarchive, realizadas por los usuarios';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.id_solicitud_des IS
    'Campo que almacena el identificador único de la Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.numero_identificacion IS
    'Campo que almacena el número de identificación del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.primer_nombre IS
    'Campo que almacena el primer nombre del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.segundo_nombre IS
    'Campo que almacena el segundo nombre del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.primer_apellido IS
    'Campo que almacena el primer apellido del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.segundo_apellido IS
    'Campo que almacena el segundo apellido del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.nombres_apellidos IS
    'Campo que almacena el nombre completo del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.telefono IS
    'Campo que almacena el teléfono del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.correo_notificacion IS
    'Campo que almacena el correo electrónico del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.codigo_tipo_proceso IS
    'Campo que almacena el código del Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.codigo_juzgado IS
    'Campo que almacena el código del Juzgado al cual pertenece el Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.codigo_especialidad IS
    'Campo que almacena el código de la especialidad al cual pertenece el Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.codigo_tipo_documento IS
    'Campo que almacena el código del tipo de documento del usuario quien realiza la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.fecha_radicado_solicitud IS
    'Campo que almacena la fecha de radicación de la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.id_estado_solicitud IS
    'Campo que almacena el identificador del estado la solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.solicitud_des.id_tipo_solicitud IS
    'Campo que almacena el identificador del tipo de  la solicitud.';

ALTER TABLE sch_orcl_desarchive_core_pre.solicitud_des ADD CONSTRAINT pk_slc PRIMARY KEY ( id_solicitud_des );

CREATE TABLE sch_orcl_desarchive_core_pre.sujeto_juridica (
    id_sujeto_juridica NUMBER(38) NOT NULL,
    razon_social       NVARCHAR2(1000) NOT NULL,
    id_sujeto_procesal NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.sujeto_juridica IS
    'Tabla que almacena la información de los Sujetos Procesales - Personas Jurídicas.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_juridica.id_sujeto_juridica IS
    'Campo que almacena el identificador único del Sujeto Procesal - Persona Jurídica.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_juridica.razon_social IS
    'Campo que almacena la razón social del Sujeto Procesal - Persona Jurídica.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_juridica.id_sujeto_procesal IS
    'Campo que almacena el identificador del Sujeto Procesal.';

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_juridica ADD CONSTRAINT pk_sju PRIMARY KEY ( id_sujeto_juridica );

CREATE TABLE sch_orcl_desarchive_core_pre.sujeto_natural (
    id_sujeto_natural  NUMBER(38) NOT NULL,
    primer_nombre      NVARCHAR2(1000) NOT NULL,
    segundo_nombre     NVARCHAR2(1000),
    primer_apellido    NVARCHAR2(1000) NOT NULL,
    segundo_apellido   NVARCHAR2(1000),
    nombre_apellidos   NVARCHAR2(2000) NOT NULL,
    id_sujeto_procesal NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.sujeto_natural IS
    'Tabla que almacena la información de los Sujetos Procesales - Personas Naturales.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.id_sujeto_natural IS
    'Campo que almacena el identificador único del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.primer_nombre IS
    'Campo que almacena el primer nombre del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.segundo_nombre IS
    'Campo que almacena el segundo nombre del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.primer_apellido IS
    'Campo que almacena el primer apellido del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.segundo_apellido IS
    'Campo que almacena el segundo apellido del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.nombre_apellidos IS
    'Campo que almacena el nombre completo del Sujeto Procesal - Persona Natural.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_natural.id_sujeto_procesal IS
    'Campo que almacena el identificador del Sujeto Procesal.';

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_natural ADD CONSTRAINT pk_sna PRIMARY KEY ( id_sujeto_natural );

CREATE TABLE sch_orcl_desarchive_core_pre.sujeto_procesal (
    id_sujeto_procesal       NUMBER(38) NOT NULL,
    codigo_tipo_suj_procesal NVARCHAR2(2000) NOT NULL,
    tipo_persona             NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.sujeto_procesal IS
    'Tabla que almacena la información de los Sujetos Procesales.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_procesal.id_sujeto_procesal IS
    'Campo que almacena el identificador único del Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_procesal.codigo_tipo_suj_procesal IS
    'Campo que almacena el código del Tipo de Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_procesal.tipo_persona IS
    'Campo que almacena el Tipo de Persona.';

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_procesal ADD CONSTRAINT pk_sjp PRIMARY KEY ( id_sujeto_procesal );

CREATE TABLE sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso (
    id_sujeto_procesal NUMBER(38) NOT NULL,
    id_proceso         NUMBER(38) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso IS
    'Tabla que almacena la información de los Sujetos Procesales por Porceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso.id_sujeto_procesal IS
    'Campo que almacena el identificador del Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso.id_proceso IS
    'Campo que almacena el identificador del Proceso.';

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso ADD CONSTRAINT pk_spp PRIMARY KEY ( id_sujeto_procesal,
                                                                                                       id_proceso );

CREATE TABLE sch_orcl_desarchive_core_pre.tarifa (
    id_tarifa           NUMBER(38) NOT NULL,
    nombre              NVARCHAR2(2000) NOT NULL,
    codigo              NVARCHAR2(1000) NOT NULL,
    valor               NUMBER(19, 4) NOT NULL,
    fecha_actualizacion DATE NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.tarifa IS
    'Tabla que almacena la información de las tarifas.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tarifa.id_tarifa IS
    'Campo que almacena el identificador único de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tarifa.nombre IS
    'Campo que almacena el nombre de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tarifa.codigo IS
    'Campo que almacena el código único de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tarifa.valor IS
    'Campo que almacena el valor de la tarifa.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tarifa.fecha_actualizacion IS
    'Campo que almacena la fecha de actualización de la tarifa.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_tarifa ON
    sch_orcl_desarchive_core_pre.tarifa (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.tarifa ADD CONSTRAINT pk_tra PRIMARY KEY ( id_tarifa );

CREATE TABLE sch_orcl_desarchive_core_pre.tipo_novedad (
    id_tipo_novedad NUMBER(38) NOT NULL,
    codigo          NVARCHAR2(1000) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    es_activo       NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.tipo_novedad IS
    'Tabla que almacena la información de los Tipo de Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_novedad.id_tipo_novedad IS
    'Campo que almacena el identificador único del Tipo de Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_novedad.codigo IS
    'Campo que almacena el código del Tipo de Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_novedad.nombre IS
    'Campo que almacena el nombre del Tipo de Novedad.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_novedad.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Tipo de Novedad.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_tipo_novedad ON
    sch_orcl_desarchive_core_pre.tipo_novedad (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.tipo_novedad ADD CONSTRAINT pk_tnv PRIMARY KEY ( id_tipo_novedad );

CREATE TABLE sch_orcl_desarchive_core_pre.tipo_proceso (
    id_tipo_proceso NUMBER(38) NOT NULL,
    codigo          NVARCHAR2(1000) NOT NULL,
    nombre          NVARCHAR2(1000) NOT NULL,
    es_activo       NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.tipo_proceso IS
    'Tabla que almacena la información de los Tipos de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_proceso.id_tipo_proceso IS
    'Campo que almacena el identificador único del Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_proceso.codigo IS
    'Campo que almacena el código único del Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_proceso.nombre IS
    'Campo que almacena el nombre único del Tipo de Proceso.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_proceso.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Tipo de Proceso.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_tipo_proc ON
    sch_orcl_desarchive_core_pre.tipo_proceso (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.tipo_proceso ADD CONSTRAINT pk_tpp PRIMARY KEY ( id_tipo_proceso );

CREATE TABLE sch_orcl_desarchive_core_pre.tipo_solicitud (
    id_tipo_solicitud NUMBER(38) NOT NULL,
    codigo            NVARCHAR2(1000) NOT NULL,
    nombre            NVARCHAR2(1000) NOT NULL,
    es_activo         NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.tipo_solicitud IS
    'Tabla que almacena la información de los Tipo de Solicitudes de desarchive de procesos, realizadas por los usuarios.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_solicitud.id_tipo_solicitud IS
    'Campo que almacena el identificador único del Tipo de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_solicitud.codigo IS
    'Campo que almacena el código único por cada Tipo de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_solicitud.nombre IS
    'Campo que almacena el nombre del Tipo de Solicitud.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_solicitud.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Tipo de Solicitud.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_tipo_solicitud ON
    sch_orcl_desarchive_core_pre.tipo_solicitud (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.tipo_solicitud ADD CONSTRAINT pk_tso PRIMARY KEY ( id_tipo_solicitud );

CREATE TABLE sch_orcl_desarchive_core_pre.tipo_sujeto_procesal (
    id_tipo_sujeto_procesal NUMBER(38) NOT NULL,
    codigo                  NVARCHAR2(1000) NOT NULL,
    nombre                  NVARCHAR2(1000) NOT NULL,
    es_activo               NUMBER(1) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.tipo_sujeto_procesal IS
    'Tabla que almacena la información de los Tipo de Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_sujeto_procesal.id_tipo_sujeto_procesal IS
    'Campo que almacena el identificador único del Tipo de Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_sujeto_procesal.codigo IS
    'Campo que almacena el código único por cada Tipo de Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_sujeto_procesal.nombre IS
    'Campo que almacena el nombre del Tipo de Sujeto Procesal.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.tipo_sujeto_procesal.es_activo IS
    'Campo que almacena el estado ACTIVO o INACTIVO del Tipo de Sujeto Procesal.';

CREATE UNIQUE INDEX sch_orcl_desarchive_core_pre.idx_codigo_tp_sprocesal ON
    sch_orcl_desarchive_core_pre.tipo_sujeto_procesal (
        codigo
    ASC );

ALTER TABLE sch_orcl_desarchive_core_pre.tipo_sujeto_procesal ADD CONSTRAINT pk_tsp PRIMARY KEY ( id_tipo_sujeto_procesal );

CREATE TABLE sch_orcl_desarchive_core_pre.usuario_por_bodega (
    id_bodega                  NUMBER(38) NOT NULL,
    codigo_tipo_identificacion NVARCHAR2(1000) NOT NULL,
    numero_identificacion      NVARCHAR2(1000) NOT NULL
);

COMMENT ON TABLE sch_orcl_desarchive_core_pre.usuario_por_bodega IS
    'Tabla que almacena la información de los Usuarios por Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.usuario_por_bodega.id_bodega IS
    'Campo que almacena el identificador único de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.usuario_por_bodega.codigo_tipo_identificacion IS
    'Campo que almacena el tipo de identificación del usuario de la Bodega.';

COMMENT ON COLUMN sch_orcl_desarchive_core_pre.usuario_por_bodega.numero_identificacion IS
    'Campo que almacena el número de identificación del usuario de la Bodega.';

ALTER TABLE sch_orcl_desarchive_core_pre.usuario_por_bodega
    ADD CONSTRAINT pk_usu PRIMARY KEY ( id_bodega,
                                        codigo_tipo_identificacion,
                                        numero_identificacion );

ALTER TABLE sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega
    ADD CONSTRAINT fk_bdg_jxb FOREIGN KEY ( id_bodega )
        REFERENCES sch_orcl_desarchive_core_pre.bodega ( id_bodega );

ALTER TABLE sch_orcl_desarchive_core_pre.novedad
    ADD CONSTRAINT fk_eno_nov FOREIGN KEY ( id_estado_novedad )
        REFERENCES sch_orcl_desarchive_core_pre.estado_novedad ( id_estado_novedad );

ALTER TABLE sch_orcl_desarchive_core_pre.esp_x_tipo_proceso
    ADD CONSTRAINT fk_esp_ext FOREIGN KEY ( id_especialidad )
        REFERENCES sch_orcl_desarchive_core_pre.especialidad ( id_especialidad );

ALTER TABLE sch_orcl_desarchive_core_pre.juzgado
    ADD CONSTRAINT fk_esp_juz FOREIGN KEY ( id_especialidad )
        REFERENCES sch_orcl_desarchive_core_pre.especialidad ( id_especialidad );

ALTER TABLE sch_orcl_desarchive_core_pre.solicitud_des
    ADD CONSTRAINT fk_ess_slc FOREIGN KEY ( id_estado_solicitud )
        REFERENCES sch_orcl_desarchive_core_pre.estado_solicitud ( id_estado_solicitud );

ALTER TABLE sch_orcl_desarchive_core_pre.especialidad
    ADD CONSTRAINT fk_jdc_esp FOREIGN KEY ( id_jurisdiccion )
        REFERENCES sch_orcl_desarchive_core_pre.jurisdiccion ( id_jurisdiccion );

ALTER TABLE sch_orcl_desarchive_core_pre.jurisdiccion_por_bodega
    ADD CONSTRAINT fk_jdc_jxb FOREIGN KEY ( id_jurisdiccion )
        REFERENCES sch_orcl_desarchive_core_pre.jurisdiccion ( id_jurisdiccion );

ALTER TABLE sch_orcl_desarchive_core_pre.parametro
    ADD CONSTRAINT fk_prc_prm FOREIGN KEY ( id_procedimiento )
        REFERENCES sch_orcl_desarchive_core_pre.procedimiento ( id_procedimiento );

ALTER TABLE sch_orcl_desarchive_core_pre.detalle_paquete
    ADD CONSTRAINT fk_pro_dpq FOREIGN KEY ( id_proceso )
        REFERENCES sch_orcl_desarchive_core_pre.proceso ( id_proceso );

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso
    ADD CONSTRAINT fk_pro_spp FOREIGN KEY ( id_proceso )
        REFERENCES sch_orcl_desarchive_core_pre.proceso ( id_proceso );

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_juridica
    ADD CONSTRAINT fk_sjp_sju FOREIGN KEY ( id_sujeto_procesal )
        REFERENCES sch_orcl_desarchive_core_pre.sujeto_procesal ( id_sujeto_procesal );

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_natural
    ADD CONSTRAINT fk_sjp_sna FOREIGN KEY ( id_sujeto_procesal )
        REFERENCES sch_orcl_desarchive_core_pre.sujeto_procesal ( id_sujeto_procesal );

ALTER TABLE sch_orcl_desarchive_core_pre.sujeto_procesal_x_proceso
    ADD CONSTRAINT fk_sjp_spp FOREIGN KEY ( id_sujeto_procesal )
        REFERENCES sch_orcl_desarchive_core_pre.sujeto_procesal ( id_sujeto_procesal );

ALTER TABLE sch_orcl_desarchive_core_pre.proceso
    ADD CONSTRAINT fk_slc_pro FOREIGN KEY ( id_solicitud )
        REFERENCES sch_orcl_desarchive_core_pre.solicitud_des ( id_solicitud_des );

ALTER TABLE sch_orcl_desarchive_core_pre.novedad
    ADD CONSTRAINT fk_tnv_nov FOREIGN KEY ( id_tipo_novedad )
        REFERENCES sch_orcl_desarchive_core_pre.tipo_novedad ( id_tipo_novedad );

ALTER TABLE sch_orcl_desarchive_core_pre.esp_x_tipo_proceso
    ADD CONSTRAINT fk_tpp_ext FOREIGN KEY ( id_tipo_proceso )
        REFERENCES sch_orcl_desarchive_core_pre.tipo_proceso ( id_tipo_proceso );

ALTER TABLE sch_orcl_desarchive_core_pre.historico_tarifa
    ADD CONSTRAINT fk_tra_htf FOREIGN KEY ( id_tarifa )
        REFERENCES sch_orcl_desarchive_core_pre.tarifa ( id_tarifa );

ALTER TABLE sch_orcl_desarchive_core_pre.solicitud_des
    ADD CONSTRAINT fk_tso_slc FOREIGN KEY ( id_tipo_solicitud )
        REFERENCES sch_orcl_desarchive_core_pre.tipo_solicitud ( id_tipo_solicitud );

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_anio START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_anio BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.anio
    FOR EACH ROW
    WHEN ( new.id_anio IS NULL )
BEGIN
    :new.id_anio := sch_orcl_desarchive_core_pre.seq_anio.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_bodega START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_bodega BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.bodega
    FOR EACH ROW
    WHEN ( new.id_bodega IS NULL )
BEGIN
    :new.id_bodega := sch_orcl_desarchive_core_pre.seq_bodega.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_detalle_paquete START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_detalle_paquete BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.detalle_paquete
    FOR EACH ROW
    WHEN ( new.id_detalle IS NULL )
BEGIN
    :new.id_detalle := sch_orcl_desarchive_core_pre.seq_detalle_paquete.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_especialidad START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_especialidad BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.especialidad
    FOR EACH ROW
    WHEN ( new.id_especialidad IS NULL )
BEGIN
    :new.id_especialidad := sch_orcl_desarchive_core_pre.seq_especialidad.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_estado_novedad START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_estado_novedad BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.estado_novedad
    FOR EACH ROW
    WHEN ( new.id_estado_novedad IS NULL )
BEGIN
    :new.id_estado_novedad := sch_orcl_desarchive_core_pre.seq_estado_novedad.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_estado_solicitud START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_estado_solicitud BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.estado_solicitud
    FOR EACH ROW
    WHEN ( new.id_estado_solicitud IS NULL )
BEGIN
    :new.id_estado_solicitud := sch_orcl_desarchive_core_pre.seq_estado_solicitud.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_historico_tarifa START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_historico_tarifa BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.historico_tarifa
    FOR EACH ROW
    WHEN ( new.id_historico_tarifa IS NULL )
BEGIN
    :new.id_historico_tarifa := sch_orcl_desarchive_core_pre.seq_historico_tarifa.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_jurisdiccion START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_jurisdiccion BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.jurisdiccion
    FOR EACH ROW
    WHEN ( new.id_jurisdiccion IS NULL )
BEGIN
    :new.id_jurisdiccion := sch_orcl_desarchive_core_pre.seq_jurisdiccion.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_juzgado START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_juzgado BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.juzgado
    FOR EACH ROW
    WHEN ( new.id_juzgado IS NULL )
BEGIN
    :new.id_juzgado := sch_orcl_desarchive_core_pre.seq_juzgado.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_novedad START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_novedad BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.novedad
    FOR EACH ROW
    WHEN ( new.id_novedad IS NULL )
BEGIN
    :new.id_novedad := sch_orcl_desarchive_core_pre.seq_novedad.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_parametro START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_parametro BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.parametro
    FOR EACH ROW
    WHEN ( new.id_parametro IS NULL )
BEGIN
    :new.id_parametro := sch_orcl_desarchive_core_pre.seq_parametro.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_procedimiento START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_procedimiento BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.procedimiento
    FOR EACH ROW
    WHEN ( new.id_procedimiento IS NULL )
BEGIN
    :new.id_procedimiento := sch_orcl_desarchive_core_pre.seq_procedimiento.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_proceso START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_proceso BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.proceso
    FOR EACH ROW
    WHEN ( new.id_proceso IS NULL )
BEGIN
    :new.id_proceso := sch_orcl_desarchive_core_pre.seq_proceso.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_solicitud_des START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_solicitud_des BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.solicitud_des
    FOR EACH ROW
    WHEN ( new.id_solicitud_des IS NULL )
BEGIN
    :new.id_solicitud_des := sch_orcl_desarchive_core_pre.seq_solicitud_des.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_sujeto_juridica START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_sujeto_juridica BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.sujeto_juridica
    FOR EACH ROW
    WHEN ( new.id_sujeto_juridica IS NULL )
BEGIN
    :new.id_sujeto_juridica := sch_orcl_desarchive_core_pre.seq_sujeto_juridica.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_sujeto_natural START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_sujeto_natural BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.sujeto_natural
    FOR EACH ROW
    WHEN ( new.id_sujeto_natural IS NULL )
BEGIN
    :new.id_sujeto_natural := sch_orcl_desarchive_core_pre.seq_sujeto_natural.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_sujeto_procesal START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_sujeto_procesal BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.sujeto_procesal
    FOR EACH ROW
    WHEN ( new.id_sujeto_procesal IS NULL )
BEGIN
    :new.id_sujeto_procesal := sch_orcl_desarchive_core_pre.seq_sujeto_procesal.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_tarifa START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg__tarifa BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.tarifa
    FOR EACH ROW
    WHEN ( new.id_tarifa IS NULL )
BEGIN
    :new.id_tarifa := sch_orcl_desarchive_core_pre.seq_tarifa.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_tipo_novedad START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_tipo_novedad BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.tipo_novedad
    FOR EACH ROW
    WHEN ( new.id_tipo_novedad IS NULL )
BEGIN
    :new.id_tipo_novedad := sch_orcl_desarchive_core_pre.seq_tipo_novedad.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_tipo_proceso START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_tipo_proceso BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.tipo_proceso
    FOR EACH ROW
    WHEN ( new.id_tipo_proceso IS NULL )
BEGIN
    :new.id_tipo_proceso := sch_orcl_desarchive_core_pre.seq_tipo_proceso.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_tipo_solicitud START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_tipo_solicitud BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.tipo_solicitud
    FOR EACH ROW
    WHEN ( new.id_tipo_solicitud IS NULL )
BEGIN
    :new.id_tipo_solicitud := sch_orcl_desarchive_core_pre.seq_tipo_solicitud.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_tipo_sujeto_procesal START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_tipo_sujeto_procesal BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.tipo_sujeto_procesal
    FOR EACH ROW
    WHEN ( new.id_tipo_sujeto_procesal IS NULL )
BEGIN
    :new.id_tipo_sujeto_procesal := sch_orcl_desarchive_core_pre.seq_tipo_sujeto_procesal.nextval;
END;
/

CREATE SEQUENCE sch_orcl_desarchive_core_pre.seq_usuario_por_bodega START WITH 1 CACHE 20 ORDER;

CREATE OR REPLACE TRIGGER sch_orcl_desarchive_core_pre.trg_usuario_por_bodega BEFORE
    INSERT ON sch_orcl_desarchive_core_pre.usuario_por_bodega
    FOR EACH ROW
    WHEN ( new.id_bodega IS NULL )
BEGIN
    :new.id_bodega := sch_orcl_desarchive_core_pre.seq_usuario_por_bodega.nextval;
END;
/

--- GENERACION DE PERMISOS 
DECLARE
  V_ROL  VARCHAR2(4000);
  CURSOR C_PERMISOS
  IS 
    SELECT 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCH_ORCL_DESARCHIVE_CORE_PRE.'||TABLE_NAME||' TO ' AS SENTENCIA
    FROM   USER_TABLES;
  R_PER C_PERMISOS%ROWTYPE;
BEGIN
  PROC_AUDITA_OBJETOS(NULL,NULL,'FINALIZA CREACION OBJETOS OK....',NULL,NULL);
  PROC_AUDITA_OBJETOS(NULL,NULL,'INICIA ASIGNACION PERMISOS OBJETOS....',NULL,NULL);
  V_ROL := 'ROL_DESARCHIVE_CORE_PRE';
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
  V_IDX   VARCHAR2(4000):= 'ORCL_DESARCHIVE_CORE_PRE_IDX';
  V_OW    VARCHAR2(4000):= 'SCH_ORCL_DESARCHIVE_CORE_PRE';
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
  PROC_AUDITA_OBJETOS('DESARCHIVE SITIO WEB','ORCL_DESARCHIVE_CORE_PRE','FINALIZACION CREACION BD',NULL,NULL);
EXCEPTION
  WHEN OTHERS THEN
    IF C_INDEX%ISOPEN THEN CLOSE C_INDEX; END IF;
    PROC_AUDITA_OBJETOS(NULL,NULL,'ERROR ASIGNANDO OBJ A TABLESPACES IDX....',SQLCODE,SQLERRM);
END;