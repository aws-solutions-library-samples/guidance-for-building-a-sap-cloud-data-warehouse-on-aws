import json
import urllib.parse
import os
import boto3
s3 = boto3.client('s3')
def lambda_handler(event, context):
    source_bucket =  os.environ['S3_BUCKET']
    source_prefix = 'source/po_items/'
    archived_prefix = 'archived/po_items/'
    target_prefix = 'target/po_items/'
    paginator =  s3.get_paginator('list_objects_v2')
    pages = paginator.paginate(Bucket=source_bucket, Prefix = source_prefix )
    for page in pages:
        #print(page)
        for obj in page.get('Contents',[]):
            key = obj['Key']
            if not key.endswith('/'):
                key = urllib.parse.unquote_plus(key, encoding='utf-8')
                akey = key.replace(source_prefix,archived_prefix)
                tkey = key.replace(source_prefix,target_prefix)
                #print(key)    
                fnameparts =  key.rsplit("/",1) #getonly file name
                fname = fnameparts[-1]
                loadTs = fname[-19:]
                #print(fname)
                #print(loadTs)
                try:
                    response = s3.get_object(Bucket=source_bucket, Key=key)
                except Exception as e:
                    print(f"Error reading source file {key}: {e}")
                    continue
                #lines = response['Body'].read().decode('utf-8').splitlines()
                lines = response['Body'].read().splitlines()
                #print(lines)
                data_list = []
                counter = 1
                for line in lines:
                    data = json.loads(line)
                    data['counter'] = counter
                    data['loadts'] = loadTs
                    data_list.append(json.dumps(data))
                    counter += 1
                updated_json = '\n'.join(data_list)
                #last_modified = response['LastModified'].isoformat()
                try:
                    s3.put_object(Bucket=source_bucket, Key=tkey, Body=updated_json)
                    print(f"File {tkey} in bucket {source_bucket} updated successfully!")
                except Exception as e:
                    print(f"Error uploading {tkey} to destination: {e}")
                # move files from Source to Archived 
                try:
                    s3.copy_object(Bucket=source_bucket,CopySource={'Bucket': source_bucket, 'Key':key},Key=akey)
                    s3.delete_object(Bucket=source_bucket, Key=key)
                    print(f"File {key} moved to Archive {akey} successfully!")
                except Exception as e:
                    print(f"Error moving file {akey} to Archive: {e}")