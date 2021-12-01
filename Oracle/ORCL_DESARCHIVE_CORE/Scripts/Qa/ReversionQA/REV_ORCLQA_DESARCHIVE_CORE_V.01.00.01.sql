/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Reversion del script ORCLQA_DESARCHIVE_CORE_V.01.00.01.sql
                               para el modulo de Reparto.
-- PARÁMETROS DE ENTRADA     : NA
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

PROMPT *** Borrado de tabla JUZGADO
PROMPT
DROP TABLE SCH_ORCLQA_DESARCHIVE_CORE.JUZGADO;
PROMPT
PROMPT *** Borrado de secuencia SEQ_JUZGADO
PROMPT
DROP SEQUENCE SCH_ORCLQA_DESARCHIVE_CORE.SEQ_JUZGADO;
PROMPT
PROMPT *** Borrado de tabla ESPECIALIDAD
PROMPT
DROP TABLE SCH_ORCLQA_DESARCHIVE_CORE.ESPECIALIDAD;
PROMPT
PROMPT *** Borrado de secuencia SEQ_ESPECIALIDAD
PROMPT
DROP SEQUENCE SCH_ORCLQA_DESARCHIVE_CORE.SEQ_ESPECIALIDAD;
PROMPT
PROMPT *** Borrado de tabla TIPO_PROCESO
PROMPT
DROP TABLE SCH_ORCLQA_DESARCHIVE_CORE.TIPO_PROCESO;
PROMPT
PROMPT *** Borrado de secuencia SEQ_TIPO_PROCESO
PROMPT
DROP SEQUENCE SCH_ORCLQA_DESARCHIVE_CORE.SEQ_TIPO_PROCESO;
PROMPT
PROMPT *** Borrado de tabla ANIO
PROMPT
DROP TABLE SCH_ORCLQA_DESARCHIVE_CORE.ANIO;
PROMPT
PROMPT *** Borrado de secuencia SEQ_ANIO
PROMPT
DROP SEQUENCE SCH_ORCLQA_DESARCHIVE_CORE.SEQ_ANIO;

