-------------------------------------------------------------------------------------------------------------------
-- OBJETIVO:                   Asingar todos los indices del esquema al tablespace de indices
-- PARÁMETROS DE ENTRADA:	   
--                             OWNER          =	 SCH_ORCL_DESARCHIVE_AUTEN                         
--                             TABLESPACE_IDX =  ORCL_DESARCHIVE_AUTEN_IDX
-- PARÁMETROS DE SALIDA:       N/A
-- OBJETOS QUE LO REFERENCIAN  N/A
-- LIDER TÉCNICO:              Gabriel Duarte
-- FECHA:                      2021/09/27
-- REALIZADO POR:              INFORMATICA & TECNOLOGIA (GEDV - JAPC)
--	         Este componente fue realizado bajo la metodología de desarrollo de Informática & Tecnología 
--             y se encuentra Protegido por las leyes de derechos de autor.
-- FECHA MODIFICACIÓN:          
-- LIDER MODIFICACIÓN:          
-- REALIZADO POR:               
-- OBJETIVO MODIFICACIÓN:       
----------------------------------------------------------------------------------------------------------------------
DECLARE
  v_texto VARCHAR2(4000);
  CURSOR c_index
  IS 
    SELECT ('ALTER INDEX '||OWNER||'.'||INDEX_NAME||' REBUILD TABLESPACE &TABLESPACE_IDX')AS SENTENCIA
    FROM ALL_INDEXES WHERE OWNER = '&OWNER'; 
  r_index c_index%ROWTYPE;
BEGIN
  OPEN c_index;
  LOOP
  FETCH c_index INTO r_index;
  EXIT WHEN c_index%NOTFOUND;
    EXECUTE IMMEDIATE r_index.sentencia;
  END LOOP;
  CLOSE c_index;

EXCEPTION
  WHEN OTHERS THEN
    IF c_index%ISOPEN THEN CLOSE c_index; END IF;
    DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLCODE||'-'||SQLERRM);
END;