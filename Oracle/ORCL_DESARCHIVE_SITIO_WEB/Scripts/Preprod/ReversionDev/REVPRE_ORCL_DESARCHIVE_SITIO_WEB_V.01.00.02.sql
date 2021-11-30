/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Script de reversion del script ORCLPRE_DESARCHIVE_SITIO_WEB_01_00_02.sql
-- PARÁMETROS DE ENTRADA     :   
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/11/29
-- REALIZADO POR             : INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	                           Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--                             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHAHORA MODIFICACIÓN    :
-- LIDER MODIFICACIÓN        : 
-- REALIZADO POR             : 
-- OBJETIVO MODIFICACIÓN     : 
-----------------------------------------------------------------------------------------------------------------------------
*/
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
DECLARE
   v_sesion VARCHAR2(4000);
   EXC_SESION EXCEPTION;
   CURSOR c_drop 
   IS
     SELECT ('ALTER SYSTEM KILL SESSION '||''''||VS.SID||','||VS.SERIAL#||'''')AS SESION_ACTIVA
     INTO   v_sesion
     FROM   V$SESSION VS
     WHERE  USERNAME = 'SCH_ORCLPRE_DESARCHIVE_SWEB';
  r_drop c_drop%ROWTYPE;
     
BEGIN
    OPEN c_drop;
    LOOP
       FETCH c_drop INTO r_drop;
       EXECUTE IMMEDIATE r_drop.sesion_activa;       
    EXIT WHEN c_drop%NOTFOUND;
    END LOOP;   
    CLOSE c_drop;
EXCEPTION 
  WHEN EXC_SESION THEN
     IF c_drop%ISOPEN THEN CLOSE c_drop; END IF;
     DBMS_OUTPUT.PUT_LINE('Sesion no activa, continua ejecucion scripts....');
  WHEN OTHERS THEN
     IF c_drop%ISOPEN THEN CLOSE c_drop; END IF;
     DBMS_OUTPUT.PUT_LINE('ERROR:'||SQLCODE||'-'||SQLERRM);
END;
/

BEGIN
	DBMS_SERVICE.stop_service('ORCLPRE_DESARCHIVE_SWEB');
END;
/
BEGIN
	DBMS_SERVICE.delete_service('ORCLPRE_DESARCHIVE_SWEB');
END;
/

DROP ROLE ROLPRE_DESARCHIVE_SWEB;
DROP USER SCH_ORCLPRE_DESARCHIVE_SWEB CASCADE;

DROP TABLESPACE ORCLPRE_DESARCHIVE_SWEB_DATA INCLUDING CONTENTS;
DROP TABLESPACE ORCLPRE_DESARCHIVE_SWEB_IDX  INCLUDING CONTENTS;