CREATE OR REPLACE PROCEDURE public.sp_incremental_sync_material_text()
 LANGUAGE plpgsql
AS $$
DECLARE
        sql          VARCHAR(MAX) := '';
        staged_record_count BIGINT :=0;
BEGIN

     -- Truncate staging table

    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.material_text;';

    EXECUTE 'COPY JOB RUN auto_copy_material_text';

--Execute MERGE on primary key to update and overwrite new/updated records

EXECUTE 'MERGE INTO sap_fabric_p2p_dm.material_text
                USING sap_fabric_p2p_stg.material_text stg 
                on (sap_fabric_p2p_dm.material_text.material=stg.matnr)
WHEN MATCHED THEN UPDATE SET
language=stg.spras,
description=stg.txtmd,
odq_changemode=stg.odq_changemode,
odq_entitycntr=stg.odq_entitycntr

WHEN NOT MATCHED THEN
    INSERT (
        material,
language,
description,
odq_changemode,
odq_entitycntr
)
    VALUES (
stg.matnr,
stg.spras,
stg.txtmd,
stg.odq_changemode,
stg.odq_entitycntr
    );';

END
$$