COPY stg_r2r.fi_gl_14
FROM 's3://acc-sap-corp-memory/source/finance_line_items/'
iam_role 'arn:aws:iam::701476028725:role/Redshift-role-701476028725'
DATEFORMAT AS 'auto'
json 'auto ignorecase'
region 'us-east-1';
