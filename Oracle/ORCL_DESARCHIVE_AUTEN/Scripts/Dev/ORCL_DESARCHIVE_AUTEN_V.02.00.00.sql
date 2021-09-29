-------------------------------------------------------------------------------------------------------------------
-- OBJETIVO:                   - Ajustar la tabla USUARIO agregando los campos:
--                               NUMERO_IDENTIFICACION 
--                               EMAIL
--                               ID_TIPO_IDENTIFICACION
--                             - Se crea la tabla TIPO_IDENTIFICACION
--                             - Se crea la relacion entre la tabla TIPO_IDENTIFICACION y USUARIO.
-- PARÁMETROS DE ENTRADA:	  : N/A 
-- PARÁMETROS DE SALIDA       : N/A
-- OBJETOS QUE LO REFERENCIAN : N/A
-- LIDER TÉCNICO              : Gabriel Duarte
-- FECHA                      : 2021/09/29
-- REALIZADO POR              : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	         Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHA MODIFICACIÓN:          
-- LIDER MODIFICACIÓN:          
-- REALIZADO POR:               
-- OBJETIVO MODIFICACIÓN:       
----------------------------------------------------------------------------------------------------------------------
ALTER TABLE SCH_DESARCHIVE_AUTEN.USUARIO ADD NUMERO_IDENTIFICACION NVARCHAR2(1000)NOT NULL;
ALTER TABLE SCH_DESARCHIVE_AUTEN.USUARIO ADD EMAIL NVARCHAR2(1000)NOT NULL;
ALTER TABLE SCH_DESARCHIVE_AUTEN.USUARIO ADD ID_TIPO_IDENTIFICACION NUMBER(19)NOT NULL;


CREATE TABLE SCH_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION (
    ID_TIPO_IDENTIFICACION NUMBER(1) NOT NULL,
    NOMBRE                 NVARCHAR2(500)NOT NULL,
    ES_ACTIVO              NUMBER(1)NOT NULL
);
/
ALTER TABLE SCH_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ADD CONSTRAINT PK_TID PRIMARY KEY ( ID_TIPO_IDENTIFICACION );

CREATE SEQUENCE SCH_DESARCHIVE_AUTEN.SEQ_TIPO_IDENTIFICACION START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER SCH_DESARCHIVE_AUTEN.TRG_TIPO_IDENTIFICACION BEFORE
    INSERT ON SCH_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION
    FOR EACH ROW
    WHEN ( NEW.ID_TIPO_IDENTIFICACION IS NULL )
BEGIN
    :NEW.ID_TIPO_IDENTIFICACION := SEQ_TIPO_IDENTIFICACION.NEXTVAL;
END;
/

ALTER TABLE SCH_DESARCHIVE_AUTEN.USUARIO
    ADD CONSTRAINT FK_TID_USU FOREIGN KEY ( ID_TIPO_IDENTIFICACION )
        REFERENCES SCH_DESARCHIVE_AUTEN.TIPO_IDENTIFICACION ( ID_TIPO_IDENTIFICACION );
