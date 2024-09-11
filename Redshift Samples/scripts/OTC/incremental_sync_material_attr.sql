CREATE OR REPLACE PROCEDURE public.incremental_sync_material_attr()
 LANGUAGE plpgsql
AS $$
DECLARE
        sql          VARCHAR(MAX) := '';
        staged_record_count BIGINT :=0;
BEGIN

     -- Truncate staging table

    EXECUTE 'TRUNCATE TABLE stg.MATR_ATTR;';

    EXECUTE 'COPY JOB RUN auto_copy_MATR_ATTR';
  
    -- Create staging table to store records from DM tables that match the current batch in the staging table

    EXECUTE 'drop table if exists temp_matr_master_match;';
    EXECUTE 'create temp table temp_matr_master_match(like dm.matr_master); ';




--Identify Material Number records from DM table that exist in the latest extract
-- We will expire these records in a later step

EXECUTE 'insert into temp_matr_master_match (
Client
,material_number
,Created_On
,object_creator_name
,Date_of_Last_Change
,Name_of_Person_Who_Changed_Object
,Maintenance_status_of_complete_material
,Maintenance_status
,Flag_Material_for_Deletion_at_Client_Level
,Material_type
,Industry_Sector
,material_group
,Old_material_number
,base_unit_of_measure
,Purchase_Order_Unit_of_Measure
,Document_number_without_document_management_system
,Document_type_without_Document_Management_system
,Document_version_without_Document_Management_system
,Page_format_of_document_without_Document_Management_system
,Document_change_number_without_document_management_system
,Page_number_of_document_without_Document_Management_system
,Number_of_sheets_without_Document_Management_system
,Production_or_inspection_memo
,Page_Format_of_Production_Memo
,Size_or_dimensions
,Basic_Material
,Industry_Standard_Description_such_as_ANSI_or_ISO
,Laboratory_or_design_office
,Purchasing_Value_Key
,item_gross_weight
,net_weight_of_the_item
,weight_unit
,item_volume
,volume_unit
,Container_requirements
,Storage_conditions
,Temperature_conditions_indicator
,Low_Level_Code
,Transportation_Group
,Hazardous_material_number
,division
,sold_to_party
,European_Article_Number_EAN_obsolete
,Number_of_GR_or_GI_slips_to_be_printed
,Procurement_rule
,Source_of_Supply
,Season_Category
,Label_type
,Label_form
,Disposal_type
,international_article_number_ean_upc
,Category_of_International_Article_Number_EAN
,Length
,Width
,Height
,Unit_of_Dimension_for_Length_or_Width_or_Height
,Product_hierarchy
,Stock_Transfer_Net_Change_Costing
,CAD_Indicator
,QM_in_Procurement_Is_Active
,Allowed_packaging_weight
,Unit_of_weight_allowed_packaging_weight
,Allowed_packaging_volume
,Volume_unit_allowed_packaging_volume
,Excess_Weight_Tolerance_for_Handling_unit
,Excess_Volume_Tolerance_of_the_Handling_Unit
,Variable_Purchase_Order_Unit_Active
,Revision_Level_Has_Been_Assigned_to_the_Material
,Configurable_Material
,Batch_Management_Requirement_Indicator
,Packaging_Material_Type
,Maximum_level_by_volume
,Stacking_factor
,Material_Group_Packaging_Materials
,Authorization_Group
,Valid_From_Date
,Deletion_date
,Season_Year
,Price_Band_Category
,Empties_Bill_of_Material
,External_Material_Group
,Cross_Plant_Configurable_Material
,Material_Category
,Material_co_product_Indicator	
,material_follow_up_material_Indicator	
,Pricing_Reference_Material
,Cross_Plant_Material_Status
,Cross_distribution_chain_material_status
,Date_from_which_the_cross_plant_material_status_is_valid
,Date_from_which_the_X_distr_chain_material_status_is_valid
,Tax_classification_of_the_material
,Catalog_Profile
,Minimum_Remaining_Shelf_Life
,Total_shelf_life
,Storage_percentage
,Content_unit
,Net_contents
,Comparison_price_unit
,IS_R_Labeling_material_grouping_deactivated
,Gross_contents
,Quantity_Conversion_Method
,Internal_object_number
,Environmentally_Relevant
,Product_allocation_determination_procedure
,Pricing_profile_for_variants
,Material_qualifies_for_discount_in_kind
,Manufacturer_Part_Number
,Manufacturer_number
,Number_of_firms_own_internal_inventory_managed_material
,Mfr_part_profile
,Units_of_measure_usage
,Rollout_in_a_Season
,Dangerous_Goods_Indicator_Profile
,Highly_Viscous_Indicator	
,In_Bulk_or_Liquid_Indicator
,Level_of_Explicitness_for_Serial_Number
,Packaging_Material_is_Closed_Packaging
,Approved_Batch_Record_Required
,Assign_effectivity_parameter_values_or__override_change_numbers
,Material_completion_level
,Period_Indicator_for_Shelf_Life_Expiration_Date
,Rounding_rule_for_calculation_of_SLED
,Product_composition_printed_on_packaging_Indicator
,General_item_category_group
,Generic_Material_with_Logistical_Variants
,Material_Is_Activated_for_CW
,Valuation_Unit_of_Measure
,Tolerance_Group_for_CWM
,Checkbox
,Base_Unit_of_Measure_cwm
,External_Long_Material_Number
,Material_Version_Number
,External_Material_Number_Plus_Version_for_Selection
,NATO_Stock_Number
,Internal_Charactieristic_Number_for_Color_Characteristics
,Internal_Char_Number_for_Characteristics_for_Main_Sizes
,Internal_Char_Number_for_Characteristics_for_Second_Sizes
,Characteristic_Value_for_Colors_of_Variants
,Characteristic_Value_for_Main_Sizes_of_Variants
,Characteristic_Value_for_Second_Size_for_Variants
,Characteristic_Value_for_Evaluation_Purposes
,Care_Codes_such_as_Washing_Code_Ironing_Code_etc
,Brand
,Fiber_Code_for_Textiles_Component_1
,Percentage_Share_of_Fiber_Component_1
,Fiber_Code_for_Textiles_Component_2
,Percentage_Share_of_Fiber_Component_2
,Fiber_Code_for_Textiles_Component_3
,Percentage_Share_of_Fiber_Component_3
,Fiber_Code_for_Textiles_Component_4
,Percentage_Share_of_Fiber_Component_4
,Fiber_Code_for_Textiles_Component_5
,Percentage_Share_of_Fiber_Component_5
,Material_group_hierarchy_level_1
,Material_group_hierarchy_level_2
,Material_group_hierarchy_level_3
,Material_group_hierarchy_level_4
,Fashion_Grade
,odq_change_mode
,odq_counter
,dm_record_start_date
,dm_record_end_date
,dm_is_current
) 

  select 
distinct
Client
,material_number
,Created_On
,object_creator_name
,Date_of_Last_Change
,Name_of_Person_Who_Changed_Object
,Maintenance_status_of_complete_material
,Maintenance_status
,Flag_Material_for_Deletion_at_Client_Level
,Material_type
,Industry_Sector
,material_group
,Old_material_number
,base_unit_of_measure
,Purchase_Order_Unit_of_Measure
,Document_number_without_document_management_system
,Document_type_without_Document_Management_system
,Document_version_without_Document_Management_system
,Page_format_of_document_without_Document_Management_system
,Document_change_number_without_document_management_system
,Page_number_of_document_without_Document_Management_system
,Number_of_sheets_without_Document_Management_system
,Production_or_inspection_memo
,Page_Format_of_Production_Memo
,Size_or_dimensions
,Basic_Material
,Industry_Standard_Description_such_as_ANSI_or_ISO
,Laboratory_or_design_office
,Purchasing_Value_Key
,item_gross_weight
,net_weight_of_the_item
,weight_unit
,item_volume
,volume_unit
,Container_requirements
,Storage_conditions
,Temperature_conditions_indicator
,Low_Level_Code
,Transportation_Group
,Hazardous_material_number
,division
,sold_to_party
,European_Article_Number_EAN_obsolete
,Number_of_GR_or_GI_slips_to_be_printed
,Procurement_rule
,Source_of_Supply
,Season_Category
,Label_type
,Label_form
,Disposal_type
,international_article_number_ean_upc
,Category_of_International_Article_Number_EAN
,Length
,Width
,Height
,Unit_of_Dimension_for_Length_or_Width_or_Height
,Product_hierarchy
,Stock_Transfer_Net_Change_Costing
,CAD_Indicator
,QM_in_Procurement_Is_Active
,Allowed_packaging_weight
,Unit_of_weight_allowed_packaging_weight
,Allowed_packaging_volume
,Volume_unit_allowed_packaging_volume
,Excess_Weight_Tolerance_for_Handling_unit
,Excess_Volume_Tolerance_of_the_Handling_Unit
,Variable_Purchase_Order_Unit_Active
,Revision_Level_Has_Been_Assigned_to_the_Material
,Configurable_Material
,Batch_Management_Requirement_Indicator
,Packaging_Material_Type
,Maximum_level_by_volume
,Stacking_factor
,Material_Group_Packaging_Materials
,Authorization_Group
,Valid_From_Date
,Deletion_date
,Season_Year
,Price_Band_Category
,Empties_Bill_of_Material
,External_Material_Group
,Cross_Plant_Configurable_Material
,Material_Category
,Material_co_product_Indicator	
,material_follow_up_material_Indicator	
,Pricing_Reference_Material
,Cross_Plant_Material_Status
,Cross_distribution_chain_material_status
,Date_from_which_the_cross_plant_material_status_is_valid
,Date_from_which_the_X_distr_chain_material_status_is_valid
,Tax_classification_of_the_material
,Catalog_Profile
,Minimum_Remaining_Shelf_Life
,Total_shelf_life
,Storage_percentage
,Content_unit
,Net_contents
,Comparison_price_unit
,IS_R_Labeling_material_grouping_deactivated
,Gross_contents
,Quantity_Conversion_Method
,Internal_object_number
,Environmentally_Relevant
,Product_allocation_determination_procedure
,Pricing_profile_for_variants
,Material_qualifies_for_discount_in_kind
,Manufacturer_Part_Number
,Manufacturer_number
,Number_of_firms_own_internal_inventory_managed_material
,Mfr_part_profile
,Units_of_measure_usage
,Rollout_in_a_Season
,Dangerous_Goods_Indicator_Profile
,Highly_Viscous_Indicator	
,In_Bulk_or_Liquid_Indicator
,Level_of_Explicitness_for_Serial_Number
,Packaging_Material_is_Closed_Packaging
,Approved_Batch_Record_Required
,Assign_effectivity_parameter_values_or__override_change_numbers
,Material_completion_level
,Period_Indicator_for_Shelf_Life_Expiration_Date
,Rounding_rule_for_calculation_of_SLED
,Product_composition_printed_on_packaging_Indicator
,General_item_category_group
,Generic_Material_with_Logistical_Variants
,Material_Is_Activated_for_CW
,Valuation_Unit_of_Measure
,Tolerance_Group_for_CWM
,Checkbox
,Base_Unit_of_Measure_cwm
,External_Long_Material_Number
,Material_Version_Number
,External_Material_Number_Plus_Version_for_Selection
,NATO_Stock_Number
,Internal_Charactieristic_Number_for_Color_Characteristics
,Internal_Char_Number_for_Characteristics_for_Main_Sizes
,Internal_Char_Number_for_Characteristics_for_Second_Sizes
,Characteristic_Value_for_Colors_of_Variants
,Characteristic_Value_for_Main_Sizes_of_Variants
,Characteristic_Value_for_Second_Size_for_Variants
,Characteristic_Value_for_Evaluation_Purposes
,Care_Codes_such_as_Washing_Code_Ironing_Code_etc
,Brand
,Fiber_Code_for_Textiles_Component_1
,Percentage_Share_of_Fiber_Component_1
,Fiber_Code_for_Textiles_Component_2
,Percentage_Share_of_Fiber_Component_2
,Fiber_Code_for_Textiles_Component_3
,Percentage_Share_of_Fiber_Component_3
,Fiber_Code_for_Textiles_Component_4
,Percentage_Share_of_Fiber_Component_4
,Fiber_Code_for_Textiles_Component_5
,Percentage_Share_of_Fiber_Component_5
,Material_group_hierarchy_level_1
,Material_group_hierarchy_level_2
,Material_group_hierarchy_level_3
,Material_group_hierarchy_level_4
,Fashion_Grade
,odq_change_mode
,odq_counter
,dm_record_start_date
,dm_record_end_date
,dm_is_current
  from 
    dm.matr_master  matr_mas
  join
    stg.matr_attr  attr
    on matr_mas.material_number = attr.matnr   
  where 
    dm_is_current = ''1''
;';
 
    sql := 'SELECT COUNT(*) FROM temp_matr_master_match;';
    
    EXECUTE sql INTO staged_record_count;
    RAISE INFO 'Matched records into temp_matr_master_match: %', staged_record_count;
    

	-- Delete records from target table that also exist in staging table (updated records)
    
    EXECUTE 'DELETE FROM dm.matr_master   
using temp_matr_master_match tmm
 WHERE dm.matr_master.material_number = tmm.material_number
 and dm.matr_master.dm_is_current =''1'';';
    


	-- Insert all records from staging table into target table

	EXECUTE 'INSERT INTO DM.matr_master
(Client
,material_number
,Created_On
,object_creator_name
,Date_of_Last_Change
,Name_of_Person_Who_Changed_Object
,Maintenance_status_of_complete_material
,Maintenance_status
,Flag_Material_for_Deletion_at_Client_Level
,Material_type
,Industry_Sector
,material_group
,Old_material_number
,base_unit_of_measure
,Purchase_Order_Unit_of_Measure
,Document_number_without_document_management_system
,Document_type_without_Document_Management_system
,Document_version_without_Document_Management_system
,Page_format_of_document_without_Document_Management_system
,Document_change_number_without_document_management_system
,Page_number_of_document_without_Document_Management_system
,Number_of_sheets_without_Document_Management_system
,Production_or_inspection_memo
,Page_Format_of_Production_Memo
,Size_or_dimensions
,Basic_Material
,Industry_Standard_Description_such_as_ANSI_or_ISO
,Laboratory_or_design_office
,Purchasing_Value_Key
,item_gross_weight
,net_weight_of_the_item
,weight_unit
,item_volume
,volume_unit
,Container_requirements
,Storage_conditions
,Temperature_conditions_indicator
,Low_Level_Code
,Transportation_Group
,Hazardous_material_number
,division
,sold_to_party
,European_Article_Number_EAN_obsolete
,Number_of_GR_or_GI_slips_to_be_printed
,Procurement_rule
,Source_of_Supply
,Season_Category
,Label_type
,Label_form
,Disposal_type
,international_article_number_ean_upc
,Category_of_International_Article_Number_EAN
,Length
,Width
,Height
,Unit_of_Dimension_for_Length_or_Width_or_Height
,Product_hierarchy
,Stock_Transfer_Net_Change_Costing
,CAD_Indicator
,QM_in_Procurement_Is_Active
,Allowed_packaging_weight
,Unit_of_weight_allowed_packaging_weight
,Allowed_packaging_volume
,Volume_unit_allowed_packaging_volume
,Excess_Weight_Tolerance_for_Handling_unit
,Excess_Volume_Tolerance_of_the_Handling_Unit
,Variable_Purchase_Order_Unit_Active
,Revision_Level_Has_Been_Assigned_to_the_Material
,Configurable_Material
,Batch_Management_Requirement_Indicator
,Packaging_Material_Type
,Maximum_level_by_volume
,Stacking_factor
,Material_Group_Packaging_Materials
,Authorization_Group
,Valid_From_Date
,Deletion_date
,Season_Year
,Price_Band_Category
,Empties_Bill_of_Material
,External_Material_Group
,Cross_Plant_Configurable_Material
,Material_Category
,Material_co_product_Indicator	
,material_follow_up_material_Indicator	
,Pricing_Reference_Material
,Cross_Plant_Material_Status
,Cross_distribution_chain_material_status
,Date_from_which_the_cross_plant_material_status_is_valid
,Date_from_which_the_X_distr_chain_material_status_is_valid
,Tax_classification_of_the_material
,Catalog_Profile
,Minimum_Remaining_Shelf_Life
,Total_shelf_life
,Storage_percentage
,Content_unit
,Net_contents
,Comparison_price_unit
,IS_R_Labeling_material_grouping_deactivated
,Gross_contents
,Quantity_Conversion_Method
,Internal_object_number
,Environmentally_Relevant
,Product_allocation_determination_procedure
,Pricing_profile_for_variants
,Material_qualifies_for_discount_in_kind
,Manufacturer_Part_Number
,Manufacturer_number
,Number_of_firms_own_internal_inventory_managed_material
,Mfr_part_profile
,Units_of_measure_usage
,Rollout_in_a_Season
,Dangerous_Goods_Indicator_Profile
,Highly_Viscous_Indicator	
,In_Bulk_or_Liquid_Indicator
,Level_of_Explicitness_for_Serial_Number
,Packaging_Material_is_Closed_Packaging
,Approved_Batch_Record_Required
,Assign_effectivity_parameter_values_or__override_change_numbers
,Material_completion_level
,Period_Indicator_for_Shelf_Life_Expiration_Date
,Rounding_rule_for_calculation_of_SLED
,Product_composition_printed_on_packaging_Indicator
,General_item_category_group
,Generic_Material_with_Logistical_Variants
,Material_Is_Activated_for_CW
,Valuation_Unit_of_Measure
,Tolerance_Group_for_CWM
,Checkbox
,Base_Unit_of_Measure_cwm
,External_Long_Material_Number
,Material_Version_Number
,External_Material_Number_Plus_Version_for_Selection
,NATO_Stock_Number
,Internal_Charactieristic_Number_for_Color_Characteristics
,Internal_Char_Number_for_Characteristics_for_Main_Sizes
,Internal_Char_Number_for_Characteristics_for_Second_Sizes
,Characteristic_Value_for_Colors_of_Variants
,Characteristic_Value_for_Main_Sizes_of_Variants
,Characteristic_Value_for_Second_Size_for_Variants
,Characteristic_Value_for_Evaluation_Purposes
,Care_Codes_such_as_Washing_Code_Ironing_Code_etc
,Brand
,Fiber_Code_for_Textiles_Component_1
,Percentage_Share_of_Fiber_Component_1
,Fiber_Code_for_Textiles_Component_2
,Percentage_Share_of_Fiber_Component_2
,Fiber_Code_for_Textiles_Component_3
,Percentage_Share_of_Fiber_Component_3
,Fiber_Code_for_Textiles_Component_4
,Percentage_Share_of_Fiber_Component_4
,Fiber_Code_for_Textiles_Component_5
,Percentage_Share_of_Fiber_Component_5
,Material_group_hierarchy_level_1
,Material_group_hierarchy_level_2
,Material_group_hierarchy_level_3
,Material_group_hierarchy_level_4
,Fashion_Grade
,odq_change_mode
,odq_counter
,dm_record_start_date
,dm_record_end_date
,dm_is_current)


SELECT 
DISTINCT
MANDT,
matnr,
ERSDA,
ernam,
LAEDA,
AENAM,
VPSTA,
PSTAT,
LVORM,
MTART,
MBRSH,
matkl,
BISMT,
meins,
BSTME,
ZEINR,
ZEIAR,
ZEIVR,
ZEIFO,
AESZN,
BLATT,
BLANZ,
FERTH,
FORMT,
GROES,
WRKST,
NORMT,
LABOR,
EKWSL,
brgew,
ntgew,
gewei,
volum,
voleh,
BEHVO,
RAUBE,
TEMPB,
DISST,
TRAGR,
STOFF,
spart,
kunnr,
EANNR,
WESCH,
BWVOR,
BWSCL,
SAISO,
ETIAR,
ETIFO,
ENTAR,
ean11,
NUMTP,
LAENG,
BREIT,
HOEHE,
MEABM,
PRDHA,
AEKLK,
CADKZ,
QMPUR,
ERGEW,
ERGEI,
ERVOL,
ERVOE,
GEWTO,
VOLTO,
VABME,
KZREV,
KZKFG,
XCHPF,
VHART,
FUELG,
STFAK,
MAGRV,
BEGRU,
DATAB,
LIQDT,
SAISJ,
PLGTP,
MLGUT,
EXTWG,
SATNR,
ATTYP,
KZKUP,
KZNFM,
PMATA,
MSTAE,
MSTAV,
MSTDE,
MSTDV,
TAKLV,
RBNRM,
MHDRZ,
MHDHB,
MHDLP,
INHME,
INHAL,
VPREH,
ETIAG,
INHBR,
CMETH,
CUOBF,
KZUMW,
KOSCH,
SPROF,
NRFHG,
MFRPN,
MFRNR,
BMATN,
MPROF,
KZWSM,
SAITY,
PROFL,
IHIVI,
ILOOS,
SERLV,
KZGVH,
XGCHP,
KZEFF,
COMPL,
IPRKZ,
RDMHD,
PRZUS,
MTPOS_MARA,
BFLME,
CWM_XCWMAT,
CWM_VALUM,
CWM_TOLGR,
CWM_TARA,
CWM_TARUM,
MATNR_EXT,
MATNR_VERS,
MATNR_SEL,
NSNID,
COLOR_ATINN,
SIZE1_ATINN,
SIZE2_ATINN,
COLOR,
SIZE1,
SIZE2,
FREE_CHAR,
CARE_CODE,
BRAND_ID,
FIBER_CODE1,
FIBER_PART1,
FIBER_CODE2,
FIBER_PART2,
FIBER_CODE3,
FIBER_PART3,
FIBER_CODE4,
FIBER_PART4,
FIBER_CODE5,
FIBER_PART5,
RPA_WGH1,
RPA_WGH2,
RPA_WGH3,
RPA_WGH4,
FASHGRD,
odq_changemode,
odq_entitycntr,
current_timestamp,
''9999-12-31''::DATE,
''1''
FROM stg.MATR_ATTR;';

  -- Insert Old records with expiry dates
    EXECUTE 'insert into dm.matr_master (
Client
,material_number
,Created_On
,object_creator_name
,Date_of_Last_Change
,Name_of_Person_Who_Changed_Object
,Maintenance_status_of_complete_material
,Maintenance_status
,Flag_Material_for_Deletion_at_Client_Level
,Material_type
,Industry_Sector
,material_group
,Old_material_number
,base_unit_of_measure
,Purchase_Order_Unit_of_Measure
,Document_number_without_document_management_system
,Document_type_without_Document_Management_system
,Document_version_without_Document_Management_system
,Page_format_of_document_without_Document_Management_system
,Document_change_number_without_document_management_system
,Page_number_of_document_without_Document_Management_system
,Number_of_sheets_without_Document_Management_system
,Production_or_inspection_memo
,Page_Format_of_Production_Memo
,Size_or_dimensions
,Basic_Material
,Industry_Standard_Description_such_as_ANSI_or_ISO
,Laboratory_or_design_office
,Purchasing_Value_Key
,item_gross_weight
,net_weight_of_the_item
,weight_unit
,item_volume
,volume_unit
,Container_requirements
,Storage_conditions
,Temperature_conditions_indicator
,Low_Level_Code
,Transportation_Group
,Hazardous_material_number
,division
,sold_to_party
,European_Article_Number_EAN_obsolete
,Number_of_GR_or_GI_slips_to_be_printed
,Procurement_rule
,Source_of_Supply
,Season_Category
,Label_type
,Label_form
,Disposal_type
,international_article_number_ean_upc
,Category_of_International_Article_Number_EAN
,Length
,Width
,Height
,Unit_of_Dimension_for_Length_or_Width_or_Height
,Product_hierarchy
,Stock_Transfer_Net_Change_Costing
,CAD_Indicator
,QM_in_Procurement_Is_Active
,Allowed_packaging_weight
,Unit_of_weight_allowed_packaging_weight
,Allowed_packaging_volume
,Volume_unit_allowed_packaging_volume
,Excess_Weight_Tolerance_for_Handling_unit
,Excess_Volume_Tolerance_of_the_Handling_Unit
,Variable_Purchase_Order_Unit_Active
,Revision_Level_Has_Been_Assigned_to_the_Material
,Configurable_Material
,Batch_Management_Requirement_Indicator
,Packaging_Material_Type
,Maximum_level_by_volume
,Stacking_factor
,Material_Group_Packaging_Materials
,Authorization_Group
,Valid_From_Date
,Deletion_date
,Season_Year
,Price_Band_Category
,Empties_Bill_of_Material
,External_Material_Group
,Cross_Plant_Configurable_Material
,Material_Category
,Material_co_product_Indicator	
,material_follow_up_material_Indicator	
,Pricing_Reference_Material
,Cross_Plant_Material_Status
,Cross_distribution_chain_material_status
,Date_from_which_the_cross_plant_material_status_is_valid
,Date_from_which_the_X_distr_chain_material_status_is_valid
,Tax_classification_of_the_material
,Catalog_Profile
,Minimum_Remaining_Shelf_Life
,Total_shelf_life
,Storage_percentage
,Content_unit
,Net_contents
,Comparison_price_unit
,IS_R_Labeling_material_grouping_deactivated
,Gross_contents
,Quantity_Conversion_Method
,Internal_object_number
,Environmentally_Relevant
,Product_allocation_determination_procedure
,Pricing_profile_for_variants
,Material_qualifies_for_discount_in_kind
,Manufacturer_Part_Number
,Manufacturer_number
,Number_of_firms_own_internal_inventory_managed_material
,Mfr_part_profile
,Units_of_measure_usage
,Rollout_in_a_Season
,Dangerous_Goods_Indicator_Profile
,Highly_Viscous_Indicator	
,In_Bulk_or_Liquid_Indicator
,Level_of_Explicitness_for_Serial_Number
,Packaging_Material_is_Closed_Packaging
,Approved_Batch_Record_Required
,Assign_effectivity_parameter_values_or__override_change_numbers
,Material_completion_level
,Period_Indicator_for_Shelf_Life_Expiration_Date
,Rounding_rule_for_calculation_of_SLED
,Product_composition_printed_on_packaging_Indicator
,General_item_category_group
,Generic_Material_with_Logistical_Variants
,Material_Is_Activated_for_CW
,Valuation_Unit_of_Measure
,Tolerance_Group_for_CWM
,Checkbox
,Base_Unit_of_Measure_cwm
,External_Long_Material_Number
,Material_Version_Number
,External_Material_Number_Plus_Version_for_Selection
,NATO_Stock_Number
,Internal_Charactieristic_Number_for_Color_Characteristics
,Internal_Char_Number_for_Characteristics_for_Main_Sizes
,Internal_Char_Number_for_Characteristics_for_Second_Sizes
,Characteristic_Value_for_Colors_of_Variants
,Characteristic_Value_for_Main_Sizes_of_Variants
,Characteristic_Value_for_Second_Size_for_Variants
,Characteristic_Value_for_Evaluation_Purposes
,Care_Codes_such_as_Washing_Code_Ironing_Code_etc
,Brand
,Fiber_Code_for_Textiles_Component_1
,Percentage_Share_of_Fiber_Component_1
,Fiber_Code_for_Textiles_Component_2
,Percentage_Share_of_Fiber_Component_2
,Fiber_Code_for_Textiles_Component_3
,Percentage_Share_of_Fiber_Component_3
,Fiber_Code_for_Textiles_Component_4
,Percentage_Share_of_Fiber_Component_4
,Fiber_Code_for_Textiles_Component_5
,Percentage_Share_of_Fiber_Component_5
,Material_group_hierarchy_level_1
,Material_group_hierarchy_level_2
,Material_group_hierarchy_level_3
,Material_group_hierarchy_level_4
,Fashion_Grade
,odq_change_mode
,odq_counter
,dm_record_start_date
,dm_record_end_date
,dm_is_current
) 

   
SELECT 
distinct 
Client
,material_number
,Created_On
,object_creator_name
,Date_of_Last_Change
,Name_of_Person_Who_Changed_Object
,Maintenance_status_of_complete_material
,Maintenance_status
,Flag_Material_for_Deletion_at_Client_Level
,Material_type
,Industry_Sector
,material_group
,Old_material_number
,base_unit_of_measure
,Purchase_Order_Unit_of_Measure
,Document_number_without_document_management_system
,Document_type_without_Document_Management_system
,Document_version_without_Document_Management_system
,Page_format_of_document_without_Document_Management_system
,Document_change_number_without_document_management_system
,Page_number_of_document_without_Document_Management_system
,Number_of_sheets_without_Document_Management_system
,Production_or_inspection_memo
,Page_Format_of_Production_Memo
,Size_or_dimensions
,Basic_Material
,Industry_Standard_Description_such_as_ANSI_or_ISO
,Laboratory_or_design_office
,Purchasing_Value_Key
,item_gross_weight
,net_weight_of_the_item
,weight_unit
,item_volume
,volume_unit
,Container_requirements
,Storage_conditions
,Temperature_conditions_indicator
,Low_Level_Code
,Transportation_Group
,Hazardous_material_number
,division
,sold_to_party
,European_Article_Number_EAN_obsolete
,Number_of_GR_or_GI_slips_to_be_printed
,Procurement_rule
,Source_of_Supply
,Season_Category
,Label_type
,Label_form
,Disposal_type
,international_article_number_ean_upc
,Category_of_International_Article_Number_EAN
,Length
,Width
,Height
,Unit_of_Dimension_for_Length_or_Width_or_Height
,Product_hierarchy
,Stock_Transfer_Net_Change_Costing
,CAD_Indicator
,QM_in_Procurement_Is_Active
,Allowed_packaging_weight
,Unit_of_weight_allowed_packaging_weight
,Allowed_packaging_volume
,Volume_unit_allowed_packaging_volume
,Excess_Weight_Tolerance_for_Handling_unit
,Excess_Volume_Tolerance_of_the_Handling_Unit
,Variable_Purchase_Order_Unit_Active
,Revision_Level_Has_Been_Assigned_to_the_Material
,Configurable_Material
,Batch_Management_Requirement_Indicator
,Packaging_Material_Type
,Maximum_level_by_volume
,Stacking_factor
,Material_Group_Packaging_Materials
,Authorization_Group
,Valid_From_Date
,Deletion_date
,Season_Year
,Price_Band_Category
,Empties_Bill_of_Material
,External_Material_Group
,Cross_Plant_Configurable_Material
,Material_Category
,Material_co_product_Indicator	
,material_follow_up_material_Indicator	
,Pricing_Reference_Material
,Cross_Plant_Material_Status
,Cross_distribution_chain_material_status
,Date_from_which_the_cross_plant_material_status_is_valid
,Date_from_which_the_X_distr_chain_material_status_is_valid
,Tax_classification_of_the_material
,Catalog_Profile
,Minimum_Remaining_Shelf_Life
,Total_shelf_life
,Storage_percentage
,Content_unit
,Net_contents
,Comparison_price_unit
,IS_R_Labeling_material_grouping_deactivated
,Gross_contents
,Quantity_Conversion_Method
,Internal_object_number
,Environmentally_Relevant
,Product_allocation_determination_procedure
,Pricing_profile_for_variants
,Material_qualifies_for_discount_in_kind
,Manufacturer_Part_Number
,Manufacturer_number
,Number_of_firms_own_internal_inventory_managed_material
,Mfr_part_profile
,Units_of_measure_usage
,Rollout_in_a_Season
,Dangerous_Goods_Indicator_Profile
,Highly_Viscous_Indicator	
,In_Bulk_or_Liquid_Indicator
,Level_of_Explicitness_for_Serial_Number
,Packaging_Material_is_Closed_Packaging
,Approved_Batch_Record_Required
,Assign_effectivity_parameter_values_or__override_change_numbers
,Material_completion_level
,Period_Indicator_for_Shelf_Life_Expiration_Date
,Rounding_rule_for_calculation_of_SLED
,Product_composition_printed_on_packaging_Indicator
,General_item_category_group
,Generic_Material_with_Logistical_Variants
,Material_Is_Activated_for_CW
,Valuation_Unit_of_Measure
,Tolerance_Group_for_CWM
,Checkbox
,Base_Unit_of_Measure_cwm
,External_Long_Material_Number
,Material_Version_Number
,External_Material_Number_Plus_Version_for_Selection
,NATO_Stock_Number
,Internal_Charactieristic_Number_for_Color_Characteristics
,Internal_Char_Number_for_Characteristics_for_Main_Sizes
,Internal_Char_Number_for_Characteristics_for_Second_Sizes
,Characteristic_Value_for_Colors_of_Variants
,Characteristic_Value_for_Main_Sizes_of_Variants
,Characteristic_Value_for_Second_Size_for_Variants
,Characteristic_Value_for_Evaluation_Purposes
,Care_Codes_such_as_Washing_Code_Ironing_Code_etc
,Brand
,Fiber_Code_for_Textiles_Component_1
,Percentage_Share_of_Fiber_Component_1
,Fiber_Code_for_Textiles_Component_2
,Percentage_Share_of_Fiber_Component_2
,Fiber_Code_for_Textiles_Component_3
,Percentage_Share_of_Fiber_Component_3
,Fiber_Code_for_Textiles_Component_4
,Percentage_Share_of_Fiber_Component_4
,Fiber_Code_for_Textiles_Component_5
,Percentage_Share_of_Fiber_Component_5
,Material_group_hierarchy_level_1
,Material_group_hierarchy_level_2
,Material_group_hierarchy_level_3
,Material_group_hierarchy_level_4
,Fashion_Grade
,odq_change_mode
,odq_counter
,dm_record_start_date 
,current_timestamp 
,0 
FROM
       temp_matr_master_match  tmm ;';

-- Refresh dm.sales_document_item_latest MV. This MV will be used to list the latest version of the sales_document_items

EXECUTE 'refresh materialized view archdm.matr_master_latest;';
END
$$
