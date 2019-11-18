import boto3
import os

options = {}
options['schema'] = os.environ['schema'] 
options['csv'] = os.environ['csv'] 
options['output'] = os.environ['output'] 
options['datasource'] = os.environ['datasource']
options['logs'] = os.environ['logs'] 

print(options)

hyper_filename = options['output'] + '/' + options['datasource'] + '.hyper'

AWS_PUBLIC_KEY = {PUBLIC_KEY}
AWS_SECRET_KEY = {SECRET_KEY}

region = 'us-east-1'
bucket='{Bucket}' # put your s3 bucket name here
                            
s3_client = boto3.client('s3', aws_access_key_id=AWS_PUBLIC_KEY, aws_secret_access_key=AWS_SECRET_KEY)

file_path = './' + options['datasource'] + '.hyper'
s3_client.download_file(bucket, hyper_filename, file_path)

command = 'tabcmd publish \"{fileFullName}\" --replace --name \"{datasourceName}\" --project \"IronSwan\" --server {server} --site {SITE} --no-cookie --no-certcheck --username {ser} --password {Password}'

command_new_datasource = 'tabcmd publish \"{fileFullName}\" --name \"{datasourceName}\" --project \"IronSwan\" --server {server} --site {SITE} --no-cookie --no-certcheck --username {ser} --password {Password}'

command = command + ' || ' + command_new_datasource

command = command.format(fileFullName=file_path, datasourceName=options['datasource'])

os.system(command)