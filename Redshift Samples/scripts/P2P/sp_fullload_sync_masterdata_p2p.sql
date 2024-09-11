CREATE OR REPLACE PROCEDURE public.sp_fullload_sync_masterdata()
 LANGUAGE plpgsql
AS $$
DECLARE
--        sql          VARCHAR(MAX) := '';
--        staged_record_count BIGINT :=0;
BEGIN

     -- Truncate staging table

    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.pur_group_text;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.purch_org_text';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.plant;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.storage_location;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.matl_group_text;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.employee;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.company_code;';
    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.gl_account;';

    EXECUTE 'COPY JOB RUN auto_copy_purchasing_group';
    EXECUTE 'COPY JOB RUN auto_copy_purchasing_organisation';
    EXECUTE 'COPY JOB RUN auto_copy_plant';
    EXECUTE 'COPY JOB RUN auto_copy_storage_location';
    EXECUTE 'COPY JOB RUN auto_copy_material_group';
    EXECUTE 'COPY JOB RUN auto_copy_employee';
    EXECUTE 'COPY JOB RUN auto_copy_company_code';     
    EXECUTE 'COPY JOB RUN auto_copy_gl_account';   

-- Insert all records from staging table into target tables
INSERT INTO sap_fabric_p2p_dm.purchasing_group   
(
SELECT * FROM sap_fabric_p2p_stg.pur_group_text
);  

INSERT INTO sap_fabric_p2p_dm.purchasing_organisation   
(
SELECT * FROM sap_fabric_p2p_stg.purch_org_text
);  

INSERT INTO sap_fabric_p2p_dm.plant
(
SELECT * FROM sap_fabric_p2p_stg.plant
);

INSERT INTO sap_fabric_p2p_dm.storage_location   
(
SELECT * FROM sap_fabric_p2p_stg.storage_location
);  

INSERT INTO sap_fabric_p2p_dm.material_group
(
SELECT * FROM sap_fabric_p2p_stg.matl_group_text
);

INSERT INTO sap_fabric_p2p_dm.employee
(
SELECT * FROM sap_fabric_p2p_stg.employee
);

INSERT INTO sap_fabric_p2p_dm.company_code
(
SELECT * FROM sap_fabric_p2p_stg.company_code
);

INSERT INTO sap_fabric_p2p_dm.gl_account   
(
SELECT * FROM sap_fabric_p2p_stg.gl_account
);  

END
$$
