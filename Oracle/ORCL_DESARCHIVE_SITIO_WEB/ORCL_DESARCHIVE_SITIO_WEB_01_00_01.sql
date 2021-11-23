/*
-------------------------------------------------------------------------------------------------------------------------------
-- OBJETIVO                  : Creacion de objeto para auditoria de instalacion
-- PARÁMETROS DE ENTRADA     : NA
-- PARÁMETROS DE SALIDA      : NA   
-- OBJETOS QUE LO REFERENCIAN: NA
-- LIDER TÉCNICO             :              
-- FECHAHORA                 : 2021/11/19
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
  V_EXISTE_OBJETO  NUMBER;
  V_CREA_TABLA     VARCHAR2(500);   
BEGIN
 DBMS_OUTPUT.PUT_LINE('--- CONSULTANDO SI TABLA DE AUDITORIA EXISTE ');
   BEGIN
      SELECT 1 EXISTE
      INTO   V_EXISTE_OBJETO
      FROM   ALL_TABLES AT
      WHERE  AT.TABLE_NAME = 'AUDITORIA_OBJETOS';
   EXCEPTION 
     WHEN NO_DATA_FOUND THEN
       V_EXISTE_OBJETO := 0;
   END;
   
   IF V_EXISTE_OBJETO =0 THEN
       DBMS_OUTPUT.PUT_LINE('--- CREANDO TABLA AUDITORIA OBJETOS ');
       V_CREA_TABLA := '
                 CREATE TABLE AUDITORIA_OBJETOS(
                 ID_AUDITORIA NUMBER(19),
				 PROYECTO     VARCHAR2(4000),
				 BD           VARCHAR2(4000),
                 OBJETO       VARCHAR2(4000),
                 MENSAJE      VARCHAR2(4000),
                 COD_ERROR    NUMBER,
                 ERROR        VARCHAR2(4000),
                 FECHA        DATE)';
       EXECUTE IMMEDIATE V_CREA_TABLA;
	   
       DBMS_OUTPUT.PUT_LINE('--- CREANDO SECUENCIA');
       EXECUTE IMMEDIATE 'CREATE SEQUENCE  SEQ_AUDITORIA_OBJETO  MINVALUE 1 INCREMENT BY 1 START WITH 101 CACHE 100 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL';
	   
       DBMS_OUTPUT.PUT_LINE('--- CREANDO TRIGGER TABLA AUDITORIA OBJETOS ');
	   EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER TRG_AUDITA_OBJETO BEFORE
	   INSERT ON AUDITORIA_OBJETOS
	   FOR EACH ROW
	   WHEN ( NEW.ID_AUDITORIA IS NULL )
	   BEGIN
	     :NEW.ID_AUDITORIA := SEQ_AUDITORIA_OBJETO.NEXTVAL;
	   END TRG_AUDITA_OBJETO;';
    END IF;
    
    
    DBMS_OUTPUT.PUT_LINE('--- OTORGANDO PERMISOS A LA TABLA');
    EXECUTE IMMEDIATE 'GRANT SELECT,INSERT,UPDATE,DELETE ON AUDITORIA_OBJETOS TO SYSTEM';
EXCEPTION
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('ERROR: '||SQLCODE||'-'||SQLERRM);
END;
/

---- Creacion de procedimiento
CREATE OR REPLACE PROCEDURE PROC_AUDITA_OBJETOS(V_MENSAJE   VARCHAR2,
                                                V_ERROR     VARCHAR2,
                                                V_MSJ_ERROR VARCHAR2)
IS
BEGIN
  INSERT INTO AUDITORIA_OBJETOS(MENSAJE, COD_ERROR , ERROR, FECHA)VALUES(V_MENSAJE,V_ERROR,V_MSJ_ERROR,SYSDATE);
  COMMIT;
END PROC_AUDITA_OBJETOS;
