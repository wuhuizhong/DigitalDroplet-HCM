--------------------------------------------------------
--  Constraints for Table T_20_HM_JOB
--------------------------------------------------------

  ALTER TABLE "HCM"."T_20_HM_JOB" MODIFY ("R_K" NOT NULL ENABLE);
  ALTER TABLE "HCM"."T_20_HM_JOB" ADD CONSTRAINT "T_20_HM_JOB_PK" PRIMARY KEY ("R_K")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;