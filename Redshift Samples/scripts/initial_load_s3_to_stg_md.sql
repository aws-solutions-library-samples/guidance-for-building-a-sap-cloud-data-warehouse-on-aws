COPY stg_md.purch_org_text
FROM 's3://acc-sap-corp-memory/source/purchasing_organisation/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.pur_group_text
FROM 's3://acc-sap-corp-memory/source/purchasing_group/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.plant
FROM 's3://acc-sap-corp-memory/source/plant/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.plant_attr
FROM 's3://acc-sap-corp-memory/source/plant_attr/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.storage_location
FROM 's3://acc-sap-corp-memory/source/storage_location/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.material_attr
FROM 's3://acc-sap-corp-memory/source/material_attr/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.material_text
FROM 's3://acc-sap-corp-memory/source/material_text/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
ENCODING AS UTF8
region 'us-east-1';


COPY stg_md.matl_group_text
FROM 's3://acc-sap-corp-memory/source/material_group/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.vendor_attr
FROM 's3://acc-sap-corp-memory/source/vendor_attr/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.vendor_text
FROM 's3://acc-sap-corp-memory/source/vendor_text/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.employee
FROM 's3://acc-sap-corp-memory/source/employee/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.company_code
FROM 's3://acc-sap-corp-memory/source/company_code/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.cost_center
FROM 's3://acc-sap-corp-memory/source/cost_center/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.profit_center
FROM 's3://acc-sap-corp-memory/source/profit_center/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.gl_account
FROM 's3://acc-sap-corp-memory/source/gl_account/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.matl_grp_1_text
FROM 's3://acc-sap-corp-memory/source/material_group_1/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.matl_grp_2_text
FROM 's3://acc-sap-corp-memory/source/material_group_2/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.matl_grp_3_text
FROM 's3://acc-sap-corp-memory/source/material_group_3/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';


COPY stg_md.matl_grp_4_text
FROM 's3://acc-sap-corp-memory/source/material_group_4/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.matl_grp_5_text
FROM 's3://acc-sap-corp-memory/source/material_group_5/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.customer_attr
FROM 's3://acc-sap-corp-memory/source/customer_attribute/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.customer_text
FROM 's3://acc-sap-corp-memory/source/customer_text/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.cust_grp1_text
FROM 's3://acc-sap-corp-memory/source/customer_group_1/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.cust_grp2_text
FROM 's3://acc-sap-corp-memory/source/customer_group_2/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.cust_grp3_text
FROM 's3://acc-sap-corp-memory/source/customer_group_3/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.cust_grp4_text
FROM 's3://acc-sap-corp-memory/source/customer_group_4/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.cust_grp5_text
FROM 's3://acc-sap-corp-memory/source/customer_group_5/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.wbs_elemt_text
FROM 's3://acc-sap-corp-memory/source/wbs_element/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.salesorg_text
FROM 's3://acc-sap-corp-memory/source/sales_organization/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.distr_chan_text
FROM 's3://acc-sap-corp-memory/source/distribution_channel/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.division_text
FROM 's3://acc-sap-corp-memory/source/division_text/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.doc_type_text
FROM 's3://acc-sap-corp-memory/source/sales_document_type/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';

COPY stg_md.item_categ_text
FROM 's3://acc-sap-corp-memory/source/sales_document_item_category/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';