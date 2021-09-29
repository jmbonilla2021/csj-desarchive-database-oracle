/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Script de reversion para el ambiente QA depositos Judiciales
-- PARÁMETROS DE ENTRADA     : NA	  
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/09/24
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--                             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHAHORA MODIFICACIÓN    :
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : 
-- OBJETIVO MODIFICACIÓN     : 
-----------------------------------------------------------------------------------------------------------------------------
*/

DECLARE
   v_sesion VARCHAR2(4000);
   EXC_SESION EXCEPTION;
BEGIN
    SELECT ('ALTER SYSTEM KILL SESSION '||''''||VS.SID||','||VS.SERIAL#||'''')AS SESION_ACTIVA
    INTO   v_sesion
    FROM   V$SESSION VS
    WHERE  USERNAME = 'SCH_DESARCHIVE';
    
    IF v_sesion IS NULL THEN
       RAISE EXC_SESION;
    ELSE 
       EXECUTE IMMEDIATE v_sesion;
    END IF;
EXCEPTION 
  WHEN EXC_SESION THEN
     DBMS_OUTPUT.PUT_LINE('Sesion no activa, continua ejecucion scripts....');
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('ERROR:'||SQLCODE||'-'||SQLERRM);
END;
/

BEGIN
	DBMS_SERVICE.stop_service('ORCL_DESARCHIVE');
END;
/
BEGIN
	DBMS_SERVICE.delete_service('ORCL_DESARCHIVE');
END;
/

DROP ROLE ROL_DESARCHIVE;
DROP USER SCH_DESARCHIVE CASCADE;

DROP TABLESPACE ORCL_DESARCHIVE_DATA INCLUDING CONTENTS;
DROP TABLESPACE ORCL_DESARCHIVE_IDX INCLUDING CONTENTS;