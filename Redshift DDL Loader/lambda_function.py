import boto3
import pyodata
import requests
import traceback
import re
import json
import os
from os import path
from botocore.exceptions import ClientError

redshift_client = boto3.client("redshift-data", region_name="us-east-1")

dedup_columns = [
    {"column_name": "counter", "type": "NUMERIC(5,0)"},
    {"column_name": "loadts", "type": "VARCHAR(20)"},

]

scd_columns = [
 {"column_name": "dm_record_start_date", "type": "TIMESTAMP"},
 {"column_name": "dm_record_end_date", "type": "TIMESTAMP"},
 {"column_name": "dm_is_current", "type": "VARCHAR(1)"}
]

# SAP Parameters
SAP_HOST=os.environ.get('SAP_HOST')
SAP_PORT=os.environ.get('SAP_PORT')
SAP_PROTO='https'
SAP_SERVICE_PATH='/sap/opu/odata/sap/'


# Redshift parameters
CLUSTER_IDENTIFIER=os.environ.get('RedshiftClusterID')
DBUSER=os.environ.get('DBUSER')
DATABASE=os.environ.get('DATABASE')

def get_secret():

    secret_name = os.environ.get('secret_name')
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        raise e

    secret = get_secret_value_response['SecretString']
    return secret
    

def getODataClient(sapservice):
    try:
        serviceuri = (
            SAP_PROTO
            + "://"
            + SAP_HOST
            + ":"
            + SAP_PORT
            + SAP_SERVICE_PATH
            + sapservice
        )

        print("service call:" + serviceuri)
        sapauth = SAP_SECRET
        session = requests.Session()
        session.auth = (sapauth["user"], sapauth["password"])
        response = session.head(serviceuri, headers={"x-csrf-token": "fetch"})
        token = response.headers.get("x-csrf-token", "")
        session.headers.update({"x-csrf-token": token})

        oDataClient = pyodata.Client(serviceuri, session)

        return oDataClient
    except Exception as e:
        traceback.print_exc()
        return e


def get_sap_columns_from_metadata(servicename: str):
    oDataclient = getODataClient(sapservice=servicename)
    for es in oDataclient.schema.entity_sets:
        if es.name.startswith("EntityOf"):
            properties = oDataclient.schema.entity_type(es.name).proprties()
            entityname = es.name

    results = []

    for prop in properties:
        label = re.sub(r"[^a-zA-Z0-9\s]", "", prop.label)
        results.append(
            {
                "entityName": entityname,
                "propertyName": prop.name,
                "label": re.sub(r"\s", "_", label),
                "type": prop.type_info.name,
                "maxLength": prop.max_length,
                "precision": prop.precision,
                "scale": prop.scale,
            }
        )
    return results


# Function to map JSON types to Redshift types
def map_json_type_to_redshift(json_type, max_length, precision, scale):
    # Mapping of Edm types to Redshift types
    if precision > 38:
        type_mapping = {
            "Edm.String": f"VARCHAR({max_length})",
            "Edm.Decimal": "FLOAT",
            "Edm.Boolean": "BOOLEAN",
            "Edm.Byte": f"VARBYTE({max_length})",
            "Edm.DateTime": "VARCHAR(20)",
            "Edm.Time": "VARCHAR(20)",
            "Edm.Double": "FLOAT",
            "Edm.Guid": f"VARCHAR({max_length})",
            "Edm.Int16": "FLOAT",
            "Edm.Int32": "INT8",
            "Edm.Int64": "FLOAT",
            "Edm.Single": "FLOAT",
            "Edm.Binary": f"VARCHAR({max_length})",
        }    
    else:
        type_mapping = {
            "Edm.String": f"VARCHAR({max_length})",
            "Edm.Decimal": f"NUMERIC({precision},{scale})",
            "Edm.Boolean": "BOOLEAN",
            "Edm.Byte": f"VARBYTE({max_length})",
            "Edm.DateTime": "VARCHAR(20)",
            "Edm.Time": "VARCHAR(20)",
            "Edm.Double": f"NUMERIC({precision},{scale})",
            "Edm.Guid": f"VARCHAR({max_length})",
            "Edm.Int16": f"NUMERIC({precision},{scale})",
            "Edm.Int32": "INT8",
            "Edm.Int64": f"NUMERIC({precision},{scale})",
            "Edm.Single": f"NUMERIC({precision},{scale})",
            "Edm.Binary": f"VARCHAR({max_length})",
        }
    # If the JSON type is not found in the mapping, default to VARCHAR
    return type_mapping.get(json_type, f"VARCHAR({max_length})")


def generate_redshift_ddl_for_odata(servicename: str):
    sapcolumns = get_sap_columns_from_metadata(servicename=servicename)

    ddl = f"CREATE TABLE IF NOT EXISTS {table_name} (\n"
    column_names = {}  # Dictionary to track column names and their occurrence counts
    for column_data in sapcolumns:
        if staging == True:
            original_column_name = column_data["propertyName"].lower()
        else:
            if column_data["propertyName"].startswith("ODQ"):
                original_column_name = column_data["propertyName"].lower()
            else:
                original_column_name = column_data["label"].lower()
                if original_column_name.upper() in reserved_words:
                    original_column_name = f"_{original_column_name.lower()}"

        column_name = original_column_name
        # If the column name already exists, append an incremental counter
        if column_name in column_names:
            counter = column_names[column_name]
            column_name = (
                f"{original_column_name}_{column_data['propertyName'].lower()}"
            )
            column_names[original_column_name] += 1
        else:
            column_names[original_column_name] = 1
        json_type = column_data["type"]
        max_length = column_data.get("maxLength", None)
        precision = column_data.get("precision", None)
        scale = column_data.get("scale", None)
        redshift_type = map_json_type_to_redshift(
            json_type, max_length, precision, scale
        )
        ddl += f"{column_name} {redshift_type},\n"
    # Remove the last comma and newline, then add DISTSTYLE AUTO;

    if staging == True:
        if include_dedup == True:
            for dedup_column in dedup_columns:
                ddl += f"{dedup_column['column_name']} {dedup_column['type']},\n"
    else:
        if include_scd == True:
            for scd_column in scd_columns:
                ddl += f"{scd_column['column_name']} {scd_column['type']},\n"


    ddl = ddl.rstrip(",\n") + "\n) DISTSTYLE AUTO;"
    return ddl


def create_redshift_table(servicename: str):
    ddl_sql = generate_redshift_ddl_for_odata(servicename=servicename)
    print(ddl_sql)
    try:
        ddl_response = redshift_client.execute_statement(
            ClusterIdentifier=CLUSTER_IDENTIFIER,
            DbUser=DBUSER,
            Database=DATABASE,
            Sql=ddl_sql,
        )

        statement_id = ddl_response["Id"]

        while True:
            response_describe = redshift_client.describe_statement(Id=statement_id)
            status = response_describe["Status"]
            if status in ["FAILED", "FINISHED"]:
                break

        if status == "FAILED":
            print("Statement failed with error message:", response_describe["Error"])

    except Exception as e:
        print(f"Error creating Redshift table: {str(e)}")


def lambda_handler(event, context):
    global reserved_words
    global staging
    global reserved_words
    global staging
    global table_name
    global dbschema
    global include_scd
    global include_dedup
    global SAP_SECRET

    sap_creds=json.loads(get_secret())
    SAP_SECRET={
    'user': sap_creds['user'],
    'password': sap_creds['password']
    }
    
    bucket = os.environ.get('BucketConfig')
    object_key = "config.json"
    # Retrieve flow definition from S3
    s3 = boto3.client('s3')
    configs3 = s3.get_object(Bucket=bucket, Key=object_key)

    configdata = json.loads(configs3['Body'].read().decode('utf-8'))

    datasources = configdata["datasources"]
    reserved_words = configdata["redshiftreservedWords"]
    #staging = configdata["staging"]
    #dbschema = configdata['schema']

    #dbschema_stg = configdata['schema_stg']

    schemas = ['stg_otc', 'dm_otc', 'stg_p2p', 'dm_p2p', 'stg_r2r', 'dm_r2r', 'stg_md', 'dm_md']

    # Need to update the below
    for i in schemas:
        ddl_schema = f"CREATE SCHEMA IF NOT EXISTS {i}\n" 
        ddl_response = redshift_client.execute_statement(
                ClusterIdentifier=CLUSTER_IDENTIFIER,
                DbUser=DBUSER,
                Database=DATABASE,
                Sql=ddl_schema,
        )
    
    for source in datasources:

        #STG
        staging = True
        include_scd = source["include_scd"]
        include_dedup = source["include_dedup"]
        rs_schema = source["redshift_schema"]
        table_name = "stg_" + rs_schema + "." + source["stage_table_name"]
        create_redshift_table(servicename=source["service"])

        #DM
        staging = False
        include_scd = source["include_scd"]
        include_dedup = source["include_dedup"]
        rs_schema = source["redshift_schema"]
        table_name = "dm_" + rs_schema + "." + source["dm_table_name"]
        create_redshift_table(servicename=source["service"])
    
    print(f'RS DDL executed successfully!')
