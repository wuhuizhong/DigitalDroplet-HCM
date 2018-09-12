--------------------------------------------------------
--  DDL for Table T_99_SSU_PMV
--------------------------------------------------------

  CREATE TABLE "HCM"."T_99_SSU_PMV" 
   (	"R_K" NUMBER, 
	"V_N" VARCHAR2(250 BYTE), 
	"V_C" VARCHAR2(250 BYTE), 
	"V_L" VARCHAR2(250 BYTE), 
	"V_D" DATE, 
	"V_YN" VARCHAR2(1 BYTE), 
	"V_V" NUMBER, 
	"V_W" VARCHAR2(250 BYTE), 
	"V_CD" VARCHAR2(20 BYTE), 
	"V_X1" VARCHAR2(250 BYTE), 
	"V_X2" VARCHAR2(250 BYTE), 
	"V_X3" VARCHAR2(512 BYTE), 
	"ACC_CD" RAW(32)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;