CREATE OR REPLACE PROCEDURE public.sp_incrementalscd_sync_supplierinvoices()
 LANGUAGE plpgsql
AS $$
DECLARE
        sql          VARCHAR(MAX) := '';
        staged_record_count BIGINT :=0;
BEGIN

     -- Truncate staging table

    EXECUTE 'TRUNCATE TABLE sap_fabric_p2p_stg.lis_06_inv;';

    EXECUTE 'COPY JOB RUN auto_copy_supplier_invoices;';

    sql := 'SELECT COUNT(*) FROM sap_fabric_p2p_stg.lis_06_inv;';

    EXECUTE sql INTO staged_record_count;
    IF staged_record_count > 0 THEN
    -- When records found in the staging table
    -- Create staging table to store records from DM tables that match the current batch in the staging table
    EXECUTE 'drop table if exists temp_supplier_invoices_match;';
    EXECUTE 'create temp table temp_supplier_invoices_match(like sap_fabric_p2p_dm.supplier_invoices); ';

--Identify inv doc item records from DM table that exist in the latest extract stg table
-- We will expire these records in a later step

    EXECUTE 'insert into temp_supplier_invoices_match (
                document_number,
                item,
                fiscal_year,
                seq_no,
                sales_tax_portion_of_automatic_invoice_reduction_amount,
                automatic_invoice_reduction_amount_net,
                unplanned_delivery_costs,
                docheader_text,
                document_date_in_document,
                posting_date_in_the_document,
                company_code,
                sales_tax_portion_of_the_invoice_verification_difference,
                document_balance,
                iv_category,
                tax_in_supplier_error,
                supplier_error_exclusive_of_tax,
                invoicing_party,
                logical_system,
                tax_amount_accepted_manually,
                manually_accepted_net_difference_amount,
                log_payt_block,
                tax_code,
                inv_status,
                gross_invoice_amount_in_document_currency,
                reversed_by,
                year,
                currency,
                tax_amount_in_document_currency_with__sign,
                reference,
                invoice,
                pmnt_block,
                requisitioner,
                grir_account_clearing_value_in_local_currency,
                base_uom,
                order_currency,
                quantity_in_purchase_order_price_unit,
                quantity_invoiced_in_supplier_invoice_in_po_price_units,
                invoice_receipt_quantity_in_order_price_unit,
                po_price_unit,
                denominator_for_conv_of_order_price_unit_into_order_unit,
                numerator_for_conversion_of_order_price_unit_into_order_unit,
                goods_receipt_quantity_in_purchase_order_price_unit,
                quantity_ordered_against_this_purchase_requisition,
                order_unit,
                purchasing_doc,
                item_ebelp,
                purch_group,
                purchasing_org,
                final_invoice,
                currency_hwaer,
                acct_assgmt_cat,
                agreement,
                agreement_item,
                reference_doc,
                year_curperiod,
                ref_doc_item,
                supplier,
                material_group,
                material,
                base_unit,
                quantity,
                net_price_in_purchasing_document_in_document_currency,
                net_value_in_document_currency,
                no_quantity,
                price_unit,
                item_category,
                quantity_invoiced_in_supplier_invoice_in_po_order_units,
                invoice_amount_in_document_currency_of_supplier_invoice,
                invoice_value_in_foreign_currency,
                quantity_invoiced,
                returns_item,
                invoice_amount_in_foreign_currency,
                debitcredit,
                block_quality,
                blockreas_opq,
                blockreasqty,
                blockreasprc,
                manblockreasn,
                blkg_reas_amount,
                bl_reason_date,
                blockreasproj,
                subseq_drcr,
                short_text,
                denominator_for_conversion_to_base_units_of_measure,
                numerator_for_conversion_to_base_units_of_measure,
                quantity_of_goods_received,
                accepted_net_value_of_service_in_foreign_currency,
                goods_receipt,
                plant,
                gr_nonvaluated,
                value_of_goods_received_in_foreign_currency,
                amount_in_document_currency,
                asset,
                subnumber,
                clearing_value_on_grir_clearing_account_transac_currency,
                _order,
                fm_area,
                commitment_item,
                funds_center,
                functional_area,
                fund,
                business_area,
                account_type,
                co_area,
                cost_center,
                chart_of_accts,
                activity_type,
                network,
                profit_segment,
                profit_center,
                wbs_element,
                gl_account,
                activity,
                rec_type_extract,
                odq_changemode,
                odq_entitycntr,
                dm_record_start_date, 
                dm_record_end_date, 
                dm_is_current 
) 

select distinct

document_number,
item,
fiscal_year,
seq_no,
sales_tax_portion_of_automatic_invoice_reduction_amount,
automatic_invoice_reduction_amount_net,
unplanned_delivery_costs,
docheader_text,
document_date_in_document,
posting_date_in_the_document,
company_code,
sales_tax_portion_of_the_invoice_verification_difference,
document_balance,
iv_category,
tax_in_supplier_error,
supplier_error_exclusive_of_tax,
invoicing_party,
logical_system,
tax_amount_accepted_manually,
manually_accepted_net_difference_amount,
log_payt_block,
tax_code,
inv_status,
gross_invoice_amount_in_document_currency,
reversed_by,
year,
currency,
tax_amount_in_document_currency_with__sign,
reference,
invoice,
pmnt_block,
requisitioner,
grir_account_clearing_value_in_local_currency,
base_uom,
order_currency,
quantity_in_purchase_order_price_unit,
quantity_invoiced_in_supplier_invoice_in_po_price_units,
invoice_receipt_quantity_in_order_price_unit,
po_price_unit,
denominator_for_conv_of_order_price_unit_into_order_unit,
numerator_for_conversion_of_order_price_unit_into_order_unit,
goods_receipt_quantity_in_purchase_order_price_unit,
quantity_ordered_against_this_purchase_requisition,
order_unit,
purchasing_doc,
item_ebelp,
purch_group,
purchasing_org,
final_invoice,
currency_hwaer,
acct_assgmt_cat,
agreement,
agreement_item,
reference_doc,
year_curperiod,
ref_doc_item,
supplier,
material_group,
material,
base_unit,
quantity,
net_price_in_purchasing_document_in_document_currency,
net_value_in_document_currency,
no_quantity,
price_unit,
item_category,
quantity_invoiced_in_supplier_invoice_in_po_order_units,
invoice_amount_in_document_currency_of_supplier_invoice,
invoice_value_in_foreign_currency,
quantity_invoiced,
returns_item,
invoice_amount_in_foreign_currency,
debitcredit,
block_quality,
blockreas_opq,
blockreasqty,
blockreasprc,
manblockreasn,
blkg_reas_amount,
bl_reason_date,
blockreasproj,
subseq_drcr,
short_text,
denominator_for_conversion_to_base_units_of_measure,
numerator_for_conversion_to_base_units_of_measure,
quantity_of_goods_received,
accepted_net_value_of_service_in_foreign_currency,
goods_receipt,
plant,
gr_nonvaluated,
value_of_goods_received_in_foreign_currency,
amount_in_document_currency,
asset,
subnumber,
clearing_value_on_grir_clearing_account_transac_currency,
_order,
fm_area,
commitment_item,
funds_center,
functional_area,
fund,
business_area,
account_type,
co_area,
cost_center,
chart_of_accts,
activity_type,
network,
profit_segment,
profit_center,
wbs_element,
gl_account,
activity,
rec_type_extract,
inv.odq_changemode,
inv.odq_entitycntr,
dm_record_start_date, 
dm_record_end_date,
dm_is_current
from 
    sap_fabric_p2p_dm.supplier_invoices inv
  join
    sap_fabric_p2p_stg.lis_06_inv  stg
    on  (inv.document_number = stg.belnr) and (inv.item = stg.buzei)   
  where 
    dm_is_current = ''1''
;';

    sql := 'SELECT COUNT(*) FROM temp_supplier_invoices_match;';
    
    EXECUTE sql INTO staged_record_count;
    RAISE INFO 'Matched records into temp_supplier_invoices_match: %', staged_record_count;

    EXECUTE 'DELETE FROM sap_fabric_p2p_dm.supplier_invoices  
    using temp_supplier_invoices_match tinv
    WHERE   (sap_fabric_p2p_dm.supplier_invoices.document_number = tinv.document_number) and 
            (sap_fabric_p2p_dm.supplier_invoices.item = tinv.item) and 
            (sap_fabric_p2p_dm.supplier_invoices.dm_is_current =''1'');';

-- Insert all records from staging table into target table

EXECUTE 'insert into sap_fabric_p2p_dm.supplier_invoices
(
document_number,
item,
fiscal_year,
seq_no,
sales_tax_portion_of_automatic_invoice_reduction_amount,
automatic_invoice_reduction_amount_net,
unplanned_delivery_costs,
docheader_text,
document_date_in_document,
posting_date_in_the_document,
company_code,
sales_tax_portion_of_the_invoice_verification_difference,
document_balance,
iv_category,
tax_in_supplier_error,
supplier_error_exclusive_of_tax,
invoicing_party,
logical_system,
tax_amount_accepted_manually,
manually_accepted_net_difference_amount,
log_payt_block,
tax_code,
inv_status,
gross_invoice_amount_in_document_currency,
reversed_by,
year,
currency,
tax_amount_in_document_currency_with__sign,
reference,
invoice,
pmnt_block,
requisitioner,
grir_account_clearing_value_in_local_currency,
base_uom,
order_currency,
quantity_in_purchase_order_price_unit,
quantity_invoiced_in_supplier_invoice_in_po_price_units,
invoice_receipt_quantity_in_order_price_unit,
po_price_unit,
denominator_for_conv_of_order_price_unit_into_order_unit,
numerator_for_conversion_of_order_price_unit_into_order_unit,
goods_receipt_quantity_in_purchase_order_price_unit,
quantity_ordered_against_this_purchase_requisition,
order_unit,
purchasing_doc,
item_ebelp,
purch_group,
purchasing_org,
final_invoice,
currency_hwaer,
acct_assgmt_cat,
agreement,
agreement_item,
reference_doc,
year_curperiod,
ref_doc_item,
supplier,
material_group,
material,
base_unit,
quantity,
net_price_in_purchasing_document_in_document_currency,
net_value_in_document_currency,
no_quantity,
price_unit,
item_category,
quantity_invoiced_in_supplier_invoice_in_po_order_units,
invoice_amount_in_document_currency_of_supplier_invoice,
invoice_value_in_foreign_currency,
quantity_invoiced,
returns_item,
invoice_amount_in_foreign_currency,
debitcredit,
block_quality,
blockreas_opq,
blockreasqty,
blockreasprc,
manblockreasn,
blkg_reas_amount,
bl_reason_date,
blockreasproj,
subseq_drcr,
short_text,
denominator_for_conversion_to_base_units_of_measure,
numerator_for_conversion_to_base_units_of_measure,
quantity_of_goods_received,
accepted_net_value_of_service_in_foreign_currency,
goods_receipt,
plant,
gr_nonvaluated,
value_of_goods_received_in_foreign_currency,
amount_in_document_currency,
asset,
subnumber,
clearing_value_on_grir_clearing_account_transac_currency,
_order,
fm_area,
commitment_item,
funds_center,
functional_area,
fund,
business_area,
account_type,
co_area,
cost_center,
chart_of_accts,
activity_type,
network,
profit_segment,
profit_center,
wbs_element,
gl_account,
activity,
rec_type_extract,
odq_changemode,
odq_entitycntr,
dm_record_start_date, 
dm_record_end_date,
dm_is_current
) 

with inv_items_latest as (select v.*,row_number() over (partition by belnr,buzei order by budat ) as inv_item_rank  
                            from sap_fabric_p2p_stg.lis_06_inv v  
                            where rocancel <> ''X'')

SELECT 
belnr,
buzei,
gjahr,
cobl_nr,
arkuemw,
arkuen,
beznk,
bktxt,
bldat,
budat,
bukrs,
diffmw,
diffn,
ivtyp,
lieffmw,
lieffn,
lifnr,
logsys,
makzmw,
makzn,
mrm_zlspr,
mwskz_bnk,
rbstat,
rmwwr,
stblg,
stjah,
waers,
wmwst1,
xblnr,
xrech,
zlspr,
afnam,
arewr,
basme,
bewae,
bpmng,
bprbm,
bprem,
bprme,
bpumn,
bpumz,
bpwem,
bsmng,
bstme,
ebeln,
ebelp,
ekgrp,
ekorg,
erekz,
hwaer,
knttp,
konnr,
ktpnr,
lfbnr,
lfgja,
lfpos,
lifnr2,
matkl,
matnr,
meins,
menge,
netpr,
netwr,
noquantity,
peinh,
pstyp,
rbmng,
rbwwr,
refwr,
remng,
retpo,
rewwr,
shkzg,
spgrc,
spgrg,
spgrm,
spgrp,
spgrq,
spgrs,
spgrt,
spgrv,
tbtkz,
txz01,
umren,
umrez,
wemng,
wenwr,
wepos,
werks,
weunb,
wewwr,
wrbtr,
anln1,
anln2,
areww,
aufnr,
fikrs,
fipos,
fistl,
fkber,
geber,
gsber,
koart,
kokrs,
kostl,
ktopl,
lstar,
nplnr,
paobjnr,
prctr,
ps_psp_pnr,
saknr,
vornr,
rocancel,
odq_changemode,
odq_entitycntr,
CURRENT_TIMESTAMP,
CASE WHEN (inv_item_rank > 1 ) THEN current_timestamp else ''9999-12-31''::DATE  END, 
CASE WHEN (inv_item_rank > 1 ) THEN ''0'' ELSE ''1'' END
FROM
inv_items_latest;';

-- Insert Old records with expiry dates
    EXECUTE 'insert into sap_fabric_p2p_dm.supplier_invoices (
document_number,
item,
fiscal_year,
seq_no,
sales_tax_portion_of_automatic_invoice_reduction_amount,
automatic_invoice_reduction_amount_net,
unplanned_delivery_costs,
docheader_text,
document_date_in_document,
posting_date_in_the_document,
company_code,
sales_tax_portion_of_the_invoice_verification_difference,
document_balance,
iv_category,
tax_in_supplier_error,
supplier_error_exclusive_of_tax,
invoicing_party,
logical_system,
tax_amount_accepted_manually,
manually_accepted_net_difference_amount,
log_payt_block,
tax_code,
inv_status,
gross_invoice_amount_in_document_currency,
reversed_by,
year,
currency,
tax_amount_in_document_currency_with__sign,
reference,
invoice,
pmnt_block,
requisitioner,
grir_account_clearing_value_in_local_currency,
base_uom,
order_currency,
quantity_in_purchase_order_price_unit,
quantity_invoiced_in_supplier_invoice_in_po_price_units,
invoice_receipt_quantity_in_order_price_unit,
po_price_unit,
denominator_for_conv_of_order_price_unit_into_order_unit,
numerator_for_conversion_of_order_price_unit_into_order_unit,
goods_receipt_quantity_in_purchase_order_price_unit,
quantity_ordered_against_this_purchase_requisition,
order_unit,
purchasing_doc,
item_ebelp,
purch_group,
purchasing_org,
final_invoice,
currency_hwaer,
acct_assgmt_cat,
agreement,
agreement_item,
reference_doc,
year_curperiod,
ref_doc_item,
supplier,
material_group,
material,
base_unit,
quantity,
net_price_in_purchasing_document_in_document_currency,
net_value_in_document_currency,
no_quantity,
price_unit,
item_category,
quantity_invoiced_in_supplier_invoice_in_po_order_units,
invoice_amount_in_document_currency_of_supplier_invoice,
invoice_value_in_foreign_currency,
quantity_invoiced,
returns_item,
invoice_amount_in_foreign_currency,
debitcredit,
block_quality,
blockreas_opq,
blockreasqty,
blockreasprc,
manblockreasn,
blkg_reas_amount,
bl_reason_date,
blockreasproj,
subseq_drcr,
short_text,
denominator_for_conversion_to_base_units_of_measure,
numerator_for_conversion_to_base_units_of_measure,
quantity_of_goods_received,
accepted_net_value_of_service_in_foreign_currency,
goods_receipt,
plant,
gr_nonvaluated,
value_of_goods_received_in_foreign_currency,
amount_in_document_currency,
asset,
subnumber,
clearing_value_on_grir_clearing_account_transac_currency,
_order,
fm_area,
commitment_item,
funds_center,
functional_area,
fund,
business_area,
account_type,
co_area,
cost_center,
chart_of_accts,
activity_type,
network,
profit_segment,
profit_center,
wbs_element,
gl_account,
activity,
rec_type_extract,
odq_changemode,
odq_entitycntr,
dm_record_start_date,
dm_record_end_date,
dm_is_current
) 
   
SELECT distinct 
document_number,
item,
fiscal_year,
seq_no,
sales_tax_portion_of_automatic_invoice_reduction_amount,
automatic_invoice_reduction_amount_net,
unplanned_delivery_costs,
docheader_text,
document_date_in_document,
posting_date_in_the_document,
company_code,
sales_tax_portion_of_the_invoice_verification_difference,
document_balance,
iv_category,
tax_in_supplier_error,
supplier_error_exclusive_of_tax,
invoicing_party,
logical_system,
tax_amount_accepted_manually,
manually_accepted_net_difference_amount,
log_payt_block,
tax_code,
inv_status,
gross_invoice_amount_in_document_currency,
reversed_by,
year,
currency,
tax_amount_in_document_currency_with__sign,
reference,
invoice,
pmnt_block,
requisitioner,
grir_account_clearing_value_in_local_currency,
base_uom,
order_currency,
quantity_in_purchase_order_price_unit,
quantity_invoiced_in_supplier_invoice_in_po_price_units,
invoice_receipt_quantity_in_order_price_unit,
po_price_unit,
denominator_for_conv_of_order_price_unit_into_order_unit,
numerator_for_conversion_of_order_price_unit_into_order_unit,
goods_receipt_quantity_in_purchase_order_price_unit,
quantity_ordered_against_this_purchase_requisition,
order_unit,
purchasing_doc,
item_ebelp,
purch_group,
purchasing_org,
final_invoice,
currency_hwaer,
acct_assgmt_cat,
agreement,
agreement_item,
reference_doc,
year_curperiod,
ref_doc_item,
supplier,
material_group,
material,
base_unit,
quantity,
net_price_in_purchasing_document_in_document_currency,
net_value_in_document_currency,
no_quantity,
price_unit,
item_category,
quantity_invoiced_in_supplier_invoice_in_po_order_units,
invoice_amount_in_document_currency_of_supplier_invoice,
invoice_value_in_foreign_currency,
quantity_invoiced,
returns_item,
invoice_amount_in_foreign_currency,
debitcredit,
block_quality,
blockreas_opq,
blockreasqty,
blockreasprc,
manblockreasn,
blkg_reas_amount,
bl_reason_date,
blockreasproj,
subseq_drcr,
short_text,
denominator_for_conversion_to_base_units_of_measure,
numerator_for_conversion_to_base_units_of_measure,
quantity_of_goods_received,
accepted_net_value_of_service_in_foreign_currency,
goods_receipt,
plant,
gr_nonvaluated,
value_of_goods_received_in_foreign_currency,
amount_in_document_currency,
asset,
subnumber,
clearing_value_on_grir_clearing_account_transac_currency,
_order,
fm_area,
commitment_item,
funds_center,
functional_area,
fund,
business_area,
account_type,
co_area,
cost_center,
chart_of_accts,
activity_type,
network,
profit_segment,
profit_center,
wbs_element,
gl_account,
activity,
rec_type_extract,
odq_changemode,
odq_entitycntr,
dm_record_start_date,
current_timestamp,
''0'' 
FROM
    temp_supplier_invoices_match;';

ELSE
   RAISE INFO 'No data found in staging table.';

END IF; 

-- Refresh dm.billing_document_item_latest MV. This MV will be used to list the latest version of the billing_document_items

EXECUTE 'refresh materialized view sap_fabric_p2p_adm.supplier_invoices_latest;';
END
$$