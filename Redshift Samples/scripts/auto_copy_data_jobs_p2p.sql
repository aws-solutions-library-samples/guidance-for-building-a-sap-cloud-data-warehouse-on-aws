COPY stg_p2p.lis_02_itm
FROM 's3://acc-sap-corp-memory/target/po_items/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1'
JOB CREATE auto_copy_po_items AUTO OFF;

COPY stg_p2p.lis_06_inv
FROM 's3://acc-sap-corp-memory/source/supplier_invoices/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1'
JOB CREATE auto_copy_supplier_invoices AUTO OFF;
