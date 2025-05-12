
-- This functionality will be moved to Step Functions eventually
CREATE OR REPLACE PROCEDURE public.incremental_sync_master_tables()
 LANGUAGE plpgsql
AS $$
BEGIN
  CALL public.incremental_sync_material_attr();
  CALL public.incremental_sync_customer_attr();
  call public.incremental_sync_vendor_attr();
  call public.incremental_sync_material_text();
END
$$;
CREATE OR REPLACE PROCEDURE public.incremental_sync_transaction_tables()
 LANGUAGE plpgsql
AS $$
BEGIN
  call public.incremental_sync_poitems() ;
  call public.incremental_sync_supplierinvoices() ;
  call public.incremental_sync_billing_document_header() ;
  call public.incremental_sync_billing_document_item() ;
  call public.incremental_sync_delivery_item() ;
  call public.incremental_sync_finance_line_items() ;
  call public.incremental_sync_sales_delivery_header() ;
  call public.incremental_sync_sales_document_header() ;
  call public.incremental_sync_sales_document_item() ;
END
$$;




