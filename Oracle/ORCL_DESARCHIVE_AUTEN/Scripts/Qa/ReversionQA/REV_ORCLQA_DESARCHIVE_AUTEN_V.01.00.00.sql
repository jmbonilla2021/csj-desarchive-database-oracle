/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Script de reversion de desarchive
-- PARÁMETROS DE ENTRADA     :   
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/09/29
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
    WHERE  USERNAME = 'SCHQA_DESARCHIVE_AUTEN';
    
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
	DBMS_SERVICE.stop_service('ORCLQA_DESARCHIVE_AUTEN');
END;
/
BEGIN
	DBMS_SERVICE.delete_service('ORCLQA_DESARCHIVE_AUTEN');
END;
/

DROP ROLE ROLQA_DESARCHIVE_AUTEN;
DROP USER SCHQA_DESARCHIVE_AUTEN CASCADE;

DROP TABLESPACE ORCLQA_DESARCHIVE_AUTEN_DATA INCLUDING CONTENTS;
DROP TABLESPACE ORCLQA_DESARCHIVE_AUTEN_IDX  INCLUDING CONTENTS;