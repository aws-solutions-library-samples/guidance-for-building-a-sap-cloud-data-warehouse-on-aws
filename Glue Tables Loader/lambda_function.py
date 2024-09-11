import boto3
import pyodata
import requests
import traceback
import re
import json
import os
from os import path
from botocore.exceptions import ClientError

glue_client = boto3.client("glue", region_name="us-east-1")


# SAP Parameters
SAP_HOST=os.environ.get('SAP_HOST')
SAP_PORT=os.environ.get('SAP_PORT')
SAP_PROTO='https'
SAP_SERVICE_PATH='/sap/opu/odata/sap/'

# Define the table metadata
database_name = os.environ['db_name']
table_input_format = 'org.apache.hadoop.mapred.TextInputFormat'
table_output_format = 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
table_serde_info = {
    'SerializationLibrary': 'org.openx.data.jsonserde.JsonSerDe'
}

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
def map_json_type_to_glue(json_type):
    # Mapping of Edm types to Redshift types
    type_mapping = {
        "Edm.String": "string",
        "Edm.Decimal": "double",
        "Edm.Boolean": "boolean",
        "Edm.Byte": "byte",
        "Edm.DateTime": "string",
        "Edm.Time": "string",
        "Edm.Double": "double",
        "Edm.Guid": "string",
        "Edm.Int16": "double",
        "Edm.Int32": "double",
        "Edm.Int64": "double",
        "Edm.Single": "double",
        "Edm.Binary": "double",
    }
    # If the JSON type is not found in the mapping, default to VARCHAR
    return type_mapping.get(json_type, "string")

def generate_table_columns(servicename):
    sapcolumns = get_sap_columns_from_metadata(servicename=servicename)
    #table_name = 'your_table_name'

    table_columns= []
#    table_columns= [
#    {'Name': 'column1', 'Type': 'string',  'Comment': 'string'},
#    {'Name': 'column2', 'Type': 'int'},
#    {'Name': 'column3', 'Type': 'double'},
#    ]

    column_names = {}  # Dictionary to track column names and their occurrence counts
    for column_data in sapcolumns:
        original_column_name = column_data["propertyName"].lower()
        if column_data["propertyName"].startswith("ODQ"):
            original_column_name = column_data["propertyName"].lower()

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
        glue_type = map_json_type_to_glue(json_type)
        description = column_data["label"]

        table_dict = {
        'Name': f"{column_name}",
        'Type': f"{glue_type}",
        'Comment': f"{description}",
        }

        table_columns.append(table_dict)
       
        #table_columns += "{'Name' : '" + column_name + "' , 'Type': '" + glue_type + "', 'Comment': '" + description + "'}, \n"
    #table_columns = table_columns.rstrip(",\n") + ",]\n)"
    #table_columns += "] \n"
    return table_columns
    

def create_glue_table(servicename):
    table_details = generate_table_columns(servicename=servicename)
    table_input={
    'Name': table_name,
    'Description': table_name,
    'StorageDescriptor': {
        'Columns': table_details,
        'Location': table_location,
        'InputFormat': table_input_format,
        'OutputFormat': table_output_format,
        'SerdeInfo': table_serde_info,
    },
    'Parameters': {
        'classification': 'JSON',
    },
    }
    print(table_details)

    try:
        table_response = glue_client.create_table(
            DatabaseName=database_name,
            TableInput={
                'Name': table_name,
                'Description': table_name,
                'StorageDescriptor': {
                    'Columns': table_details,
                    'Location': table_location,
                    'InputFormat': table_input_format,
                    'OutputFormat': table_output_format,
                    'SerdeInfo': table_serde_info,
                },
                'Parameters': {
                    'classification': 'JSON',
                },
            }
        )
    except Exception as e:
        print(f"Error creating Glue table: {str(e)}")


def lambda_handler(event, context):
    global reserved_words
    global table_name
    global table_location
    global SAP_SECRET

    sap_creds=json.loads(get_secret())
    SAP_SECRET={
    'user': sap_creds['user'],
    'password': sap_creds['password']
    }

    bucket = os.environ.get('BucketConfig')
    object_key = "config_glue.json"
    # Retrieve flow definition from S3
    s3 = boto3.client('s3')
    configs3 = s3.get_object(Bucket=bucket, Key=object_key)

    configdata = json.loads(configs3['Body'].read().decode('utf-8'))

    datasources = configdata["datasources"]
    reserved_words = configdata["redshiftreservedWords"]

    # Need to update the below


    for source in datasources:

        table_name = source["table_name"]
        table_location = source["s3_path"]
        create_glue_table(servicename=source["service"])

    
    print(f'Glue DDL executed successfully!')
