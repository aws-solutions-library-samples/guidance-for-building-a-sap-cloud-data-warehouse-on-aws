COPY stg_otc.lis_11_vahdr
FROM 's3://acc-sap-corp-memory/source/sales_order_header/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_otc.lis_11_vaitm
FROM 's3://acc-sap-corp-memory/source/sales_order_item/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_otc.lis_12_vchdr
FROM 's3://acc-sap-corp-memory/source/delivery_header/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_otc.lis_12_vcitm
FROM 's3://acc-sap-corp-memory/source/delivery_item/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_otc.lis_13_vdhdr
FROM 's3://acc-sap-corp-memory/source/billing_document_header/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_otc.lis_13_vditm
FROM 's3://acc-sap-corp-memory/source/billing_document_item/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';
