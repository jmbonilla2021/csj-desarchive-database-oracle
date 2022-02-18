/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Script de reversion
-- PARÁMETROS DE ENTRADA     :   
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/10/14
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
     WHERE  USERNAME = 'SCH_ORCL_DIA_FESTIVO_PRE';
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
	DBMS_SERVICE.stop_service('ORCL_DIA_FESTIVO_PRE');
END;
/
BEGIN
	DBMS_SERVICE.delete_service('ORCL_DIA_FESTIVO_PRE');
END;
/


DROP ROLE ROL_DIA_FESTIVO_PRE;
DROP USER SCH_ORCL_DIA_FESTIVO_PRE CASCADE;

DROP TABLESPACE ORCL_DIA_FESTIVO_PRE_DATA INCLUDING CONTENTS;
DROP TABLESPACE ORCL_DIA_FESTIVO_PRE_IDX  INCLUDING CONTENTS;
