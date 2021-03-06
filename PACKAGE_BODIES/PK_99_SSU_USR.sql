--------------------------------------------------------
--  DDL for Package Body PK_99_SSU_USR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "PK_99_SSU_USR" AS 

-- Author       : Gbenga Cruz 
-- Description  : Cloud Application User Management 
-- Date         : January 18, 2017 
 
     --- Create App user 
     PROCEDURE PC_99_SSU_USR (p_usr IN v_99_ssu_usr%ROWTYPE, p_err_msg OUT v_99_ssu_log%ROWTYPE) AS 
 
             v_usr       v_99_ssu_usr%ROWTYPE; 
		     v_err       v_99_ssu_log%ROWTYPE; 
             v_sta       BOOLEAN;
             l_status    varchar2(30);
             v_usr_pwd   v_99_ssu_usr.usr_pwd%TYPE;

             CURSOR c_pwd_val IS SELECT prf_cd FROM v_99_ssu_pwd_prf WHERE ius_yn = '1';

             BEGIN 


             IF p_usr.r_k IS NULL THEN
                --- Validate User Id
                v_sta := PK_99_SSU_VAL.FN_99_SSU_USR_VAL(UPPER(p_usr.usr_id));


                IF v_sta = false  THEN

                 v_err.err_cd := '-20009';
                 --  pk_99_ssu_err.pc_99_ssu_err(v_err);
                 -- p_err_msg.err_msg := v_err.err_msg; 
                  raise_application_error(v_err.err_cd ,v_err.err_msg);
                 END IF;

           /*   --- Validate Password
             FOR i IN c_pwd_val LOOP

             v_sta := pk_99_ssu_val.fn_99_ssu_pwd_val(i.prf_cd,p_usr.usr_pwd);      

                IF v_sta = false THEN

                v_err.err_cd := i.prf_cd;
              --  pk_99_ssu_err.pc_99_ssu_err(v_err);       
                p_err_msg := v_err.err_msg; 
                raise_application_error(v_err.err_cd ,p_err_msg);

                END IF;

              END LOOP;
			  */
                 IF v_err.err_msg IS NULL THEN 

                 v_usr.ius_yn     := 1; 
                 v_usr.usr_id     := UPPER(p_usr.usr_id); 
                 v_usr.usr_pwd    := DBMS_RANDOM.string('x', 8); 
                 v_usr_pwd        := v_usr.usr_pwd;
			     v_usr.comp_key   := p_usr.comp_key; 
				 v_usr.usr_pwd    := apex_util.get_hash(apex_t_varchar2(v_usr.comp_key,v_usr.usr_id,v_usr.usr_pwd),null); 
				 v_usr.trn_vew    := p_usr.trn_vew;  
				 v_usr.trn_edt    := p_usr.trn_edt; 
                 v_usr.trn_apr    := p_usr.trn_apr; 
                 v_usr.fst_nm     := INITCAP(p_usr.fst_nm);  
	             v_usr.lst_nm     := INITCAP(p_usr.lst_nm); 
                 v_usr.usr_eml    := LOWER(p_usr.usr_eml); 
                 v_usr.usr_phn    := p_usr.usr_phn; 
                 v_usr.pwd_rst    := 1;
                 v_usr.flex_01    := p_usr.flex_01;


                 INSERT INTO t_99_ssu_usr(comp_key,usr_id,fst_nm,lst_nm,usr_eml,usr_phn,lst_log,ius_yn,trn_apr,trn_vew,trn_edt,usr_pwd,comp_sub,pwd_rst,flex_01) 
				              VALUES 
                             (v_usr.comp_key,v_usr.usr_id,v_usr.fst_nm,v_usr.lst_nm,v_usr.usr_eml,v_usr.usr_phn,v_usr.lst_log,v_usr.ius_yn,v_usr.trn_apr,v_usr.trn_vew,v_usr.trn_edt,v_usr.usr_pwd,v_usr.comp_sub,v_usr.pwd_rst,v_usr.flex_01 ); 


		       


       HM_email.send (
       p_email_addresses => v_usr.usr_eml,
       p_template_id     => 104491778632938544042972506405273020445,
       p_subject         => 'Aspire HCM User Authentication',
       p_body1_text      => 'Hi ' || v_usr.fst_nm ||', 
                             '||'<br/><br/>' || 'You have been given access to Aspire Human Capital Management, your Login details is below.'||'<br/><br/>',
       p_table_content   => '"Username": "'||v_usr.usr_id||'","Password": "'||v_usr_pwd ,
       p_body2_text      => 'Click on the link below to redirect to Aspire Human Capital Management Application'||'<br/><br/>',
       p_action_label    => 'Aspire Human Capital Management'||'<br/><br/>',
       p_action_link     => 'https://apex.oracle.com/pls/apex/f?p=118733:101',
       p_can_opt_out_yn  => 'N',
       p_status          => l_status );


                END IF;
            ELSE
                 v_usr.fst_nm     := INITCAP(p_usr.fst_nm);  
	             v_usr.lst_nm     := INITCAP(p_usr.lst_nm); 
                 v_usr.usr_eml    := LOWER(p_usr.usr_eml); 
                 v_usr.usr_phn    := p_usr.usr_phn; 
                 v_usr.ius_yn     := p_usr.ius_yn; 
                 v_usr.r_k        := p_usr.r_k; 
                 
                 UPDATE t_99_ssu_usr SET fst_nm = v_usr.fst_nm, lst_nm = v_usr.lst_nm, usr_eml = v_usr.usr_eml, usr_phn = v_usr.usr_phn, ius_yn = v_usr.ius_yn 
                 WHERE r_k  = v_usr.r_k;
              END IF;
              COMMIT; 
             EXCEPTION WHEN OTHERS THEN 
             ROLLBACK; 
		         pk_99_ssu_err.pc_99_ssu_err(v_err);       
             p_err_msg.err_msg := v_err.err_msg; 
             p_err_msg.err_cd := v_err.err_cd; 

     END PC_99_SSU_USR; 

     --- Password reset

     PROCEDURE PC_99_SSU_PWD (p_usr IN v_99_ssu_usr%ROWTYPE, p_err_msg OUT v_99_ssu_log%ROWTYPE) AS 

             v_usr           v_99_ssu_usr%ROWTYPE; 
		     v_err           v_99_ssu_log%ROWTYPE; 
             v_sta           BOOLEAN;
             l_status        varchar2(30);
             v_usr_eml        v_99_ssu_usr.usr_eml%TYPE;
             v_fst_nm         v_99_ssu_usr.fst_nm%TYPE;
             v_usr_pwd         v_99_ssu_usr.usr_pwd%TYPE;

             CURSOR c_pwd_val IS SELECT prf_cd FROM v_99_ssu_pwd_prf WHERE ius_yn = '1';
             CURSOR c_usr_val IS SELECT usr_eml, fst_nm FROM v_99_ssu_usr WHERE ius_yn = '1' AND UPPER(usr_id) = UPPER(p_usr.usr_id);

             BEGIN 

             OPEN c_usr_val;
             FETCH c_usr_val INTO v_usr_eml,v_fst_nm;
             CLOSE c_usr_val;

              --- Validate Password
              IF v_usr.pwd_rst = 0 THEN
              
             FOR i IN c_pwd_val LOOP

             v_sta := pk_99_ssu_val.fn_99_ssu_pwd_val(i.prf_cd,p_usr.usr_pwd);      

                IF v_sta = false THEN

                v_err.err_cd := i.prf_cd;
              --  pk_99_ssu_err.pc_99_ssu_err(v_err);       
              --   p_err_msg := v_err.err_msg; 
                raise_application_error(v_err.err_cd ,v_err.err_msg);

                END IF;

              END LOOP;
              
              END IF;

                 IF v_err.err_msg IS NULL THEN 

                 v_usr.pwd_rst  :=  p_usr.pwd_rst;

                       IF v_usr.pwd_rst = 1 THEN

                       v_usr.usr_pwd    := DBMS_RANDOM.string('x', 8); 
                       v_usr_pwd        := v_usr.usr_pwd;
                        ELSE 

                       v_usr.usr_pwd    := p_usr.usr_pwd;
                       v_usr_pwd        := v_usr.usr_pwd;
                       
                       END IF;

                 v_usr.usr_id       :=  UPPER(p_usr.usr_id); 
                 v_usr.comp_key     :=   p_usr.comp_key; --PK_99_SSU_ACC.FN_99_SSU_ACC_KEY; 
				 v_usr.usr_pwd      :=  apex_util.get_hash(apex_t_varchar2(v_usr.comp_key,v_usr.usr_id,v_usr.usr_pwd),null); 
				 v_usr.lst_pwd_rst  :=  systimestamp;


                 IF v_err.err_msg IS NULL THEN  
			     UPDATE t_99_ssu_usr SET usr_pwd = v_usr.usr_pwd, pwd_rst =  v_usr.pwd_rst ,  lst_pwd_rst = v_usr.lst_pwd_rst
				 WHERE usr_id = v_usr.usr_id;
                   

		        COMMIT; 


       HM_email.send (
       p_email_addresses => v_usr_eml,
       p_template_id     => 104491778632938544042972506405273020445,
       p_subject         => 'Aspire HCM User Authentication',
       p_body1_text      => 'Hi ' || v_fst_nm ||', 
                             '||'</br></br>' || 'Your password has been reset, your Login details is below.'||'<br/><br/>',
       p_table_content   => '"Username": "'||v_usr.usr_id||'","Password": "'|| v_usr_pwd,
       p_body2_text      => 'Click on the link below to redirect to Aspire Human Capital Management Application'||'<br/><br/>',
       p_action_label    => 'Aspire Human Capital Management'||'<br/><br/>',
       p_action_link     => 'http://192.168.30.191:8080/ords/f?p=1000:101',
       p_can_opt_out_yn  => 'N',
       p_status          => l_status );

                END IF;
                END IF;

             EXCEPTION WHEN OTHERS THEN 
             ROLLBACK; 
		         pk_99_ssu_err.pc_99_ssu_err(v_err);       
                 p_err_msg.err_msg := v_err.err_msg; 
                 p_err_msg.err_cd := v_err.err_cd; 

     END PC_99_SSU_PWD; 

	 --- User Roles Management
     PROCEDURE PC_99_SSU_USR_RLE (p_usr_rle IN v_99_ssu_usr_rle %ROWTYPE, p_err_msg OUT v_99_ssu_log.err_msg%TYPE) AS 

             v_usr_rle       v_99_ssu_usr_rle%ROWTYPE; 
		     v_err           v_99_ssu_log%ROWTYPE; 
             v_sta           BOOLEAN;
             v_acc_cd        v_99_ssu_usr_rle.acc_cd%TYPE;

             CURSOR  c_acc is SELECT comp_key from v_99_ssu_usr where usr_id = p_usr_rle.usr_cd;

             BEGIN 

             OPEN c_acc;
             FETCH c_acc INTO v_acc_cd;
             CLOSE c_acc;

             v_usr_rle.acc_cd := v_acc_cd;

			 v_usr_rle.role_cd := p_usr_rle.role_cd;
			 v_usr_rle.usr_cd := p_usr_rle.usr_cd;


			    -- DELETE FROM t_99_ssu_usr_rle WHERE usr_cd = v_usr_rle.usr_cd;
                IF v_err.err_msg IS NULL THEN  
                 INSERT INTO t_99_ssu_usr_rle(role_cd, usr_cd, acc_cd) VALUES (v_usr_rle.role_cd,v_usr_rle.usr_cd,v_usr_rle.acc_cd);
                END IF;
			     COMMIT;

             EXCEPTION WHEN OTHERS THEN 
             ROLLBACK; 

		         pk_99_ssu_err.pc_99_ssu_err(v_err);       
                 p_err_msg := v_err.err_msg; 

    END PC_99_SSU_USR_RLE; 

      PROCEDURE PC_99_SSU_USR_RLE_DEL (p_usr_rle IN v_99_ssu_usr_rle %ROWTYPE, p_err_msg OUT v_99_ssu_log.err_msg%TYPE) AS 

             v_usr_rle       v_99_ssu_usr_rle%ROWTYPE; 
		     v_err           v_99_ssu_log%ROWTYPE; 
             v_sta           BOOLEAN;
             v_acc_cd        v_99_ssu_usr_rle.acc_cd%TYPE;


             BEGIN 



			 v_usr_rle.usr_cd := p_usr_rle.usr_cd;
             
             IF v_err.err_msg IS NULL THEN  
			 DELETE FROM t_99_ssu_usr_rle WHERE usr_cd = v_usr_rle.usr_cd and acc_cd = v_usr_rle.acc_cd;
             END IF;

			     COMMIT;

             EXCEPTION WHEN OTHERS THEN 
             ROLLBACK; 

		         pk_99_ssu_err.pc_99_ssu_err(v_err);       
                 p_err_msg := v_err.err_msg; 

    END PC_99_SSU_USR_RLE_DEL;

END PK_99_SSU_USR;

/
