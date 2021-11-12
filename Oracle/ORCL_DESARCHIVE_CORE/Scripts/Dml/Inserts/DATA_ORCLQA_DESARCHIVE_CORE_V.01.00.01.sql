/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Script de insercion de las tablas del Modelo de acuerdo a los objetos creados en el script
--                             ORCLQA_DESARCHIVE_CORE_V.01.00.01.sql               
--                               
-- PARÁMETROS DE ENTRADA     : N/A
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/11/10
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--                             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHAHORA MODIFICACIÓN    : 
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : 
-- OBJETIVO MODIFICACIÓN     : 
-----------------------------------------------------------------------------------------------------------------------------
*/

INSERT INTO SCHQA_ORCL_DESARCHIVE_CORE.TIPO_PROCESO(ID_TIPO_PROCESO,CODIGO,NOMBRE,ES_ACTIVO)VALUES(SCHQA_ORCL_DESARCHIVE_CORE.SEQ_TIPO_PROCESO.NEXTVAL,'T001','TUTELA',1);
INSERT INTO SCHQA_ORCL_DESARCHIVE_CORE.TIPO_PROCESO(ID_TIPO_PROCESO,CODIGO,NOMBRE,ES_ACTIVO)VALUES(SCHQA_ORCL_DESARCHIVE_CORE.SEQ_TIPO_PROCESO.NEXTVAL,'T002','PROCESO',1);
COMMIT;