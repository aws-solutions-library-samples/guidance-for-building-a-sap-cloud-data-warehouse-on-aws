--otc
--**Contains definition for reporting materialized views

create schema IF NOT EXISTS archdm;

create materialized view archdm.sales_document_item_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.sales_order_item
where
    dm_is_current = '1' ;

create materialized view archdm.sales_document_header_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.sales_document_header
where
    dm_is_current = '1';

CREATE MATERIALIZED VIEW archdm.matr_master_latest DISTSTYLE ALL AUTO REFRESH YES AS
SELECT
    *
FROM
    dm_md.material_attr
;

create materialized view archdm.customer_master_latest diststyle all auto refresh yes AS
SELECT
    *
FROM
    dm_md.customer_attribute
;

create materialized view archdm.sales_delivery_header_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.sales_delivery_header
where
    dm_is_current = '1';

create materialized view archdm.delivery_item_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.delivery_item
where
    dm_is_current = '1';

Create materialized view archdm.billing_document_header_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.billing_document_header
where
    dm_is_current = '1' ;

create materialized view archdm.billing_document_item_latest
distkey
    (sd_document) auto refresh yes AS
SELECT
    *
FROM
    dm_otc.billing_document_item
where
    dm_is_current = '1' ;


--Refresh salesorders

CREATE MATERIALIZED VIEW archdm.salesorders
distkey
    (sd_document) AS
SELECT
    sdh.cancel_ind,
    sdh.sd_document,
    sdh.quotationinquiry_is_valid_from,
    sdh.sales_doc_type,
    sdh.order_reason,
    sdh.date_until_which_bidquotation_is_binding_validto_date,
    sdh.company_code,
    sdh.record_created_on,
    sdh.billing_block,
    sdh.local_currency,
    sdh.soldto_party,
    sdh.exch_rate_type,
    sdh.customer_grp_1,
    sdh.customer_grp_2,
    sdh.customer_grp_3,
    sdh.customer_grp_4,
    sdh.customer_grp_5,
    sdh.delivery_block,
    sdh.sales_employee,
    sdh.stats_currency,
    sdh.document_cat,
    sdh.requested_delivery_date,
    sdh.sales_office,
    sdh.sales_group,
    sdh.sales_org,
    sdh.distr_channel,
    sdh.doc_currency,
    sdh.division,
    sdh.sales_doc_cat_ref,
    sdh.number_of_orders,
    sdh.fy_variant,
    sdh.odq_changemode,
    sdh.odq_entitycntr,
    sdi.rejection_sts,
    sdi.item,
    sdi.item_uvall,
    sdi.billing__item,
    sdi.pricing__item,
    sdi.delivery__item,
    sdi.rejectionreason,
    sdi.last_changed_on,
    sdi.order_probab,
    sdi.gross_weight_of_the_item,
    sdi.application_comp,
    sdi.transfer_process,
    sdi.batch,
    sdi.credit_data_exchange_rate_for_requested_delivery_date,
    sdi.eanupc,
    sdi.created_by,
    sdi.time,
    sdi.billing_block_faksp,
    sdi.unit_of_weight,
    sdi.cumulative_confirmed_quantity_in_sales_unit,
    sdi.cumulative_confirmed_quantity_in_base_unit,
    sdi.unit_of_measure,
    sdi.sales_deal,
    sdi.condition_pricing_unit,
    sdi.cumulative_order_quantity_in_sales_units,
    sdi.subtotal_1_from_pricing_procedure_for_price_element,
    sdi.subtotal_2_from_pricing_procedure_for_price_element,
    sdi.subtotal_3_from_pricing_procedure_for_price_element,
    sdi.subtotal_4_from_pricing_procedure_for_price_element,
    sdi.subtotal_5_from_pricing_procedure_for_price_element,
    sdi.subtotal_6_from_pricing_procedure_for_price_element,
    sdi.minimum_delivery_quantity_in_delivery_note_processing,
    sdi.location,
    sdi.cumulative_required_delivery_qty_all_dlvrelevschedlines,
    sdi.material_group,
    sdi.material,
    sdi.materialentered,
    sdi.base_unit,
    sdi.materialgroup_1,
    sdi.materialgroup_2,
    sdi.materialgroup_3,
    sdi.materialgroup_4,
    sdi.materialgroup_5,
    sdi.tax_amount_in_document_currency,
    sdi.net_price,
    sdi.net_value_of_the_document_item_in_document_currency,
    sdi.net_weight_of_the_item,
    sdi.unlpt_shiptopar,
    sdi.billto_party,
    sdi.payer,
    sdi.shipto_party,
    sdi.prod_hierarchy,
    sdi.fwd_agent,
    sdi.item_category,
    sdi.route,
    sdi.special_stock,
    sdi.statistics_date,
    sdi.exchange_rate_for_statistics_exchrate_at_time_of_creation,
    sdi.reasn,
    sdi.unlimited_tol,
    sdi.overdelivery_tolerance,
    sdi.denominator_divisor_for_conversion_of_sales_qty_into_sku,
    sdi.numerator_factor_for_conversion_of_sales_quantity_into_sku,
    sdi.factor_for_converting_sales_units_to_base_units_target_qty,
    sdi.factor_for_converting_sales_units_to_base_units_target_qty_umziz,
    sdi.underdelivery_tolerance,
    sdi.date_of_update_for_statistics_updating,
    sdi.reference_doc,
    sdi.reference_item,
    sdi.precdoccateg,
    sdi.volume_unit,
    sdi.volume_of_the_item,
    sdi.sales_unit,
    sdi.shipping_point,
    sdi.cost_in_document_currency,
    sdi.plant,
    sdi.target_qty_uom,
    sdi.target_quantity_in_sales_units,
    sdi.target_value_for_outline_agreement_in_document_currency,
    sdi.sales_district,
    sdi.date_on_which_services_are_rendered,
    sdi.billing_date,
    sdi.incoterms,
    sdi.incoterms_2,
    sdi.customer_group,
    sdi.accassmtgrpcust,
    sdi.exchange_rate_for_price_determination,
    sdi.translation_date,
    sdi.date_for_pricing_and_exchange_rate,
    sdi.promotion,
    sdi.catalog,
    sdi.doc_currency_waerk_vbak,
    sdi.division_spara,
    sdi.wbs_element,
    sdi.number_of_order_items,
    sdi.campaign_order_item,
    sdi.planning_in_apo,
    sdi.bw_net_price_referring_to_sales_quantity_for_order_item
FROM
    archdm.sales_document_header_latest sdh
    join archdm.sales_document_item_latest sdi on sdh.sd_document = sdi.sd_document; 

CREATE MATERIALIZED VIEW archdm.billingdocs
distkey
    (sd_document) AS
Select
    bdh.sd_document,
    bdh.company_code,
    bdh.sales_district,
    bdh.record_created_on,
    bdh.billing_type,
    bdh.billing_date,
    bdh.billingcategory,
    bdh.local_currency,
    bdh.customer_group,
    bdh.soldto_party,
    bdh.payer,
    bdh.exchange_rate_for_postings_to_financial_accounting,
    bdh.exch_rate_type,
    bdh.sales_employee,
    bdh.stats_currency,
    bdh.document_cat,
    bdh.sales_org,
    bdh.distr_channel,
    bdh.doc_currency,
    bdh.noof_billing_docs,
    bdh.fy_variant,
    bdh.odq_changemode,
    bdh.odq_entitycntr, 
    bdi.cancel_ind,
    bdi.last_changed_on,
    bdi.promotion,
    bdi.sales_document,  
    bdi.item_aupos,
    bdi.rebate_basis_1,
    bdi.vol_rebate_grp,
    bdi.gross_weight,
    bdi.gross_value_of_the_billing_item_in_document_currency,
    bdi.application_comp,
    bdi.transfer_process,
    bdi.batch,
    bdi.eanupc,
    bdi.billing_rule,
    bdi.date_on_which_services_are_rendered,
    bdi.actual_invoiced_quantity,
    bdi.billing_quantity_in_stock_keeping_unit,
    bdi.unit_of_weight,
    bdi.sales_deal,
    bdi.co_area,
    bdi.cost_center,
    bdi.exchange_rate_for_price_determination,
    bdi.translation_date,
    bdi.customer_grp_1,
    bdi.customer_grp_2,
    bdi.customer_grp_3,
    bdi.customer_grp_4,
    bdi.customer_grp_5,
    bdi.subtotal_1_from_pricing_procedure_for_price_element,
    bdi.subtotal_2_from_pricing_procedure_for_price_element,
    bdi.subtotal_3_from_pricing_procedure_for_price_element,
    bdi.subtotal_4_from_pricing_procedure_for_price_element,
    bdi.subtotal_5_from_pricing_procedure_for_price_element,
    bdi.subtotal_6_from_pricing_procedure_for_price_element,
    bdi.location,
    bdi.required_quantity_for_matmanagement_in_stockkeeping_units,
    bdi.material_group,
    bdi.material,
    bdi.materialentered,
    bdi.base_unit,
    bdi.materialgroup_1,
    bdi.materialgroup_2,
    bdi.materialgroup_3,
    bdi.materialgroup_4,
    bdi.materialgroup_5,
    bdi.tax_amount_in_document_currency,
    bdi.net_value_of_billing_item_in_document_currency,
    bdi.net_weight,
    bdi.billto_party,
    bdi.shipto_party,
    bdi.item_type,
    bdi.prod_hierarchy,
    bdi.commission_grp,
    bdi.date_for_pricing_and_exchange_rate,
    bdi.item_category,
    bdi.amount_eligible_for_cash_discount_in_document_currency,
    bdi.scale_quantity_in_base_unit_of_measure,
    bdi.division,
    bdi.division_spart,
    bdi.statistics_date,
    bdi.exchange_rate_for_statistics_exchrate_at_time_of_creation,
    bdi.denominator_divisor_for_conversion_of_sales_qty_into_sku,
    bdi.numerator_factor_for_conversion_of_sales_quantity_into_sku,
    bdi.date_of_update_for_statistics_updating,
    bdi.reference_doc,
    bdi.reference_item,
    bdi.sales_office,
    bdi.sales_group,
    bdi.volume_unit,
    bdi.volume,
    bdi.sales_unit,
    bdi.shipping_point,
    bdi.cost_in_document_currency,
    bdi.plant,
    bdi.wbs_element,
    bdi.number_of_billing_items,
    bdi.campaign_order_item
from
    archdm.billing_document_header_latest bdh
    join archdm.billing_document_item_latest bdi on bdh.sd_document = bdi.sd_document;


CREATE MATERIALIZED VIEW archdm.invoicedocs distkey(sd_document)  AS 
select
sdh.sd_document,
sdh.unloading_point,
sdh.total_weight,
sdh.company_code,
sdh.sales_district,
sdh.record_created_on,
sdh.billing_block,
sdh.unit_of_weight,
sdh.incoterms,
sdh.incoterms_2,
sdh.customer_group,
sdh.soldto_party,
sdh.shipto_party,
sdh.delivery_type,
sdh.delivery_date,
sdh.supplier,
sdh.delivery_block,
sdh.loading_point,
sdh.net_weight,
sdh.billto_party,
sdh.payer,
sdh.fwd_agent,
sdh.sales_employee,
sdh.route,
sdh.document_cat,
sdh.sales_org,
sdh.volume_unit,
sdh.volume,
sdh.shipping_point,
sdh.planned_goods_movement_date,
sdh.actual_goods_movement_date,
sdh.no_of_deliveries,
sdh.extraction_bw_number_of_packages_per_delivery,
sdh.fy_variant,
sdh.bw_extraction_le_actual_gi_delay__gi_date_for_delivery,
di.confirmation,
di.picking_status,
di.item,
di.goods_mvmnt_sts,
di.last_changed_on,
di.promotion,
di.gross_weight,
di.application_comp,
di.transfer_process,
di.batch,
di.eanupc,
di.created_by,
di.time,
di.billing_block_faksp,
di.business_area,
di.picking_id,
di.customer_grp_1,
di.customer_grp_2,
di.customer_grp_3,
di.customer_grp_4,
di.customer_grp_5,
di.consumption,
di.actual_quantity_delivered_in_sales_units,
di.actual_quantity_delivered_in_stockkeeping_units,
di.warehouse_no,
di.location,
di.storage_bin,
di.storage_type,
di.material_group,
di.material,
di.materialentered,
di.base_unit,
di.materialgroup_1,
di.materialgroup_2,
di.materialgroup_3,
di.materialgroup_4,
di.materialgroup_5,
di.item_type,
di.prod_hierarchy,
di.item_category,
di.statistics_date,
di.denominator_divisor_for_conversion_of_sales_qty_into_sku,
di.numerator_factor_for_conversion_of_sales_quantity_into_sku,
di.fixed_shipping_processing_time_in_days__setup_time,
di.variable_shipping_processing_time_in_days,
di.date_of_update_for_statistics_updating,
di.reference_doc,
di.reference_item,
di.document_cat_vgtyp,
di.sales_office,
di.sales_group,
di.sales_unit,
di.distr_channel,
di.plant,
di.number_of_delivery_items,
di.division,
di.wbs_element,
di.campaign_order_item
from
        archdm.sales_delivery_header_latest sdh
        join archdm.delivery_item_latest di on sdh.sd_document = di.sd_document;


--p2p update schemas
CREATE MATERIALIZED VIEW archdm.supplier_invoices_latest DISTSTYLE ALL AUTO REFRESH YES AS
SELECT
    *
FROM
    dm_p2p.supplier_invoices
where
    dm_is_current = '1';

--  Current view for SCD2 po items
CREATE MATERIALIZED VIEW archdm.po_items_latest DISTSTYLE ALL AUTO REFRESH YES AS
SELECT
    *
FROM
    dm_p2p.po_items
where
    dm_is_current = '1';  


--MV for purchase order analysis
create MATERIALIZED view archdm.purch_order_analysis AS (
    select
        po.purchasing_doc,
        --EBELN
        po.item,
        -- EBELP
        po.purchasing_org,
        --EKORG
        porg.description as purchasing_org_description,
        po.purch_group,
        --EKGRP
        po.doc_category,
        --BSTYP
        po.document_type,
        --BSART
        po.item_category,
        --PSTYP
        po.short_text,
        --TXZ01
        po.plant,
        --WERKS
        plant.name_1 as plant_name,
        po.location as storage_location,
        --LGORT
        stor.description as storage_location_description,
        po.material_matnr,
        --MATNR
        --matxt.description as material_description,
        po.material_group,
        --MATKL
        matgr.matl_grp_desc,
        po.supplier,
        --LIFNR
        --suppl.name as supplier_name,
        po.goods_supplier_pwlif,
        --PWLIF
        po.invoicing_party_prest,
        --PREST
        po.requisitioner,
        --AFNAM
        cast(po.purchasing_document_date as date),
        --BEDAT
        po.posting_date_of_goods_received_or_invoice_receipt_for_order,
        --BUDAT
        cast(po.date_on_which_the_purchasing_document_was_entered as date),
        --SYDAT
 --       po.time as time_,
        --UZEIT
        po.fy_variant,
        --PERIV
        po.status,
        --STATU
        po.purchase_order_quantity,
        --MENGE
        po.net_price,
        --NETPR
        po.net_order_value_in_order_currency,
        --NETWR
        po.price_unit,
        --PEINH
        po.counter_for_quantity_interval,
        --NOPOS,
        po.local_currency,
        --HWAER
        po.order_currency,
        --WAERS
        po.order_unit,
        --MEINS
        po.base_unit,
        --LMEIN
        po.cancel_ind,
        inv.quantity as invoice_quantity,
        inv.amount_in_document_currency as invoice_amount
    from
        archdm.po_items_latest po
        left outer join (
            select
                purchasing_doc,
                item_ebelp,
                --debitcredit,
                sum(
                    CASE debitcredit
                    when 'H' then (-1 * quantity)
                    else quantity END
                ) as quantity,
                sum(
                    CASE debitcredit
                    when 'H' then (-1 * amount_in_document_currency)
                    else amount_in_document_currency END
                ) as amount_in_document_currency
            from
                archdm.supplier_invoices_latest
            group by
                1,
                2 --order by 1, 2, 3, 4, 5
        ) inv on (po.purchasing_doc = inv.purchasing_doc)
        and (po.item = inv.item_ebelp)
        left outer join dm_md.purchasing_organization porg on (po.purchasing_org = porg.purchasing_org)
        left outer join dm_md.material_text matxt on (po.material_matnr = matxt.description)
        left outer join dm_md.material_group matgr on (po.material_group = matgr.material_group)
        left outer join dm_md.vendor_attr suppl on (po.supplier = suppl.supplier)
        left outer join dm_md.plant plant on (po.plant = plant.plant)
        left outer join dm_md.storage_location stor on ( po.plant = stor.plant
            and po.location = stor.location
        )
)
;

--r2r
create materialized view archdm.finance_line_items_latest
distkey
    (document_number) auto refresh yes AS
SELECT
    *
FROM
    dm_r2r.finance_line_items
where
    dm_is_current = '1' ;

create MATERIALIZED VIEW archdm.gl_line_items AS
(
    select 
           gl.clearing_date,
           gl.document_number,
           gl.item,
           gl.posting_date_in_the_document,
           gl.document_type,
           gl.document_date_in_document,
           gl.document_status,
           gl.company_code,
           gl.purchasing_doc,
           gl.fiscal_year,
           gl.yearmonth, 
           gl.account_type,
           gl.cost_center, 
           cost_center.short_description,
           gl.account, 
           gla.short_text as glaccount_name,
           gl.profit_center,
           pc.short_description as profit_center_desc,
           gl.text,
           gl.debitcredit,
           gl.special_gl_ind,
           gl.sales_document, 
           gl.billing_doc, 
           gl.amount_in_dc,
           gl.currency,
           gl.pymt_meth,
           gl.general_ledger_amt,
           gl.gl_acct,
           gl.amount_in_lc,
           gl.co_area, 
           gl.cost_element,
           gl.customer, 
           customer_text.name as customer_name,
           gl.supplier,
           gl.credit_amt_in_lc,
           gl.debit_amt_in_lc
    from
        dm_r2r.finance_line_items gl
        left outer join  (select "language", co_area, short_description, cost_center, validto_date
                            from dm_md.cost_center
                            where "language" = 'EN' and validto_date = '99991231') cost_center 
                            on (cost_center.cost_center = gl.cost_center and cost_center.co_area = gl.co_area)
        left outer join dm_md.customer_text on customer_text.customer = gl.customer
        left outer join (select "language", chart_of_accts, short_text, gl_account
                            from dm_md.gl_account
                            where "language" = 'EN') gla 
                            on (gla.chart_of_accts = gl.chart_of_accts and gla.gl_account = gl.account)
        left outer join (select "language", co_area, valid_to_date, short_description, profit_center
                            from dm_md.profit_center
                            where valid_to_date = '99991231' and "language" = 'EN') pc
                            on (pc.profit_center = gl.profit_center and pc.co_area = gl.co_area)
); 
