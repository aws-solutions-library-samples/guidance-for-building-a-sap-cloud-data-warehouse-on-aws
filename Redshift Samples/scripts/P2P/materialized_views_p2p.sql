--  Current view for SCD2 supplier invoices
create schema if not exists sap_fabric_p2p_adm;

CREATE MATERIALIZED VIEW sap_fabric_p2p_adm.supplier_invoices_latest DISTSTYLE ALL AUTO REFRESH YES AS
SELECT
    *
FROM
    sap_fabric_p2p_dm.supplier_invoices
where
    dm_is_current = '1';

--  Current view for SCD2 po items
CREATE MATERIALIZED VIEW sap_fabric_p2p_adm.po_items_latest DISTSTYLE ALL AUTO REFRESH YES AS
SELECT
    *
FROM
    sap_fabric_p2p_dm.po_items
where
    dm_is_current = '1';  


--MV for purchase order analysis
create MATERIALIZED view sap_fabric_p2p_adm.purch_order_analysis AS (
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
        po.fiyear_variant,
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
        sap_fabric_p2p_adm.po_items_latest po
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
                sap_fabric_p2p_adm.supplier_invoices_latest
            group by
                1,
                2 --order by 1, 2, 3, 4, 5
        ) inv on (po.purchasing_doc = inv.purchasing_doc)
        and (po.item = inv.item_ebelp)
        left outer join sap_fabric_p2p_dm.purchasing_organisation porg on (po.purchasing_org = porg.purchasing_org)
        left outer join sap_fabric_p2p_dm.material_text matxt on (po.material_matnr = matxt.description)
        left outer join sap_fabric_p2p_dm.material_group matgr on (po.material_group = matgr.material_group)
        left outer join sap_fabric_p2p_dm.vendor_attr suppl on (po.supplier = suppl.supplier)
        left outer join sap_fabric_p2p_dm.plant plant on (po.plant = plant.plant)
        left outer join sap_fabric_p2p_dm.storage_location stor on (
            po.plant = stor.plant
            and po.location = stor.location
        )
)
;