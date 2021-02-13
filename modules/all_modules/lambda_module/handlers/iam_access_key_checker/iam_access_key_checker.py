#!/usr/bin/python
'''
References:
1) JSON Role Policy : lambda_deployer_role : https://marcelog.github.io/articles/aws_lambda_start_stop_ec2_instance.html
2) Logging Hadler   : Re-Invent            : https://gist.github.com/niranjv/fb95e716151642e8ca553b0e38dd152e
3) Lambda Issue VPC : Can't connect to ISP : https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-internet
4) Date Time Ex     : Examples             : https://www.techatbloomberg.com/blog/work-dates-time-python/

'''
import os
import sys
import time
import json
import boto3
import datetime
import dateutil
from dateutil.tz import gettz

'''importing custom modules'''
'''Setting Up Lambda logger'''
sys.path.append(os.path.dirname(os.path.realpath(__file__)) + '/pySetenv/variables/' )
sys.path.append(os.path.dirname(os.path.realpath(__file__)) + '/pySetenv/packages/'  )

import lambda_logger
from customEmail import Email
logger = lambda_logger.setup_lambda_logger()

'''Jupyter Notebook - Log file'''
# sys.path.append(os.path.dirname('C:\\Users\\Vignesh_Palanivel\\Google Drive\\Jupyter Notebooks\\pySetenv\\'))
# print (sys.path)

# import logger
# execLogger  = 'rti-upload-download' + time.strftime('-%Y-%m-%d-%Hh-%Mm-%Ss-%Z') + '.log'
# logger      = logger.setupLogger('Stop Instances Logger', execLogger)
'''Jupyter Notebook - Stream'''
# logger = logging.getLogger()
# logger.setLevel(logging.INFO)
# logging.basicConfig(format='[%(asctime)s] - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S %Z')

'''Defining Global Variables'''
today_date      = datetime.datetime.now(datetime.timezone.utc).astimezone(gettz("Asia/Kolkata"))
logger.info('Today"s Date               : {}'.format(today_date))

'''Reading Environment Variables'''
# logger.info('ENVIRONMENT VARIABLES')
# logger.info(os.environ)
region        = os.environ['region']
graceDays     = int(os.environ['graceDays'])
maxDays       = int(os.environ['maxDays'])
warnDays      = maxDays - graceDays
deActDays     = maxDays + graceDays

logger.info('ENV - Region               : {}'.format(region))
logger.info('ENV - Grace Days           : {}'.format(graceDays))
logger.info('ENV - Warning Days         : {}'.format(warnDays))
logger.info('ENV - Maximum Days         : {}'.format(maxDays))
logger.info('ENV - De-Activation Days   : {}'.format(deActDays))

logger.info('Initializing boto3 client  : IAM')
logger.info('Initializing boto3 client  : STS')
iam_client = boto3.client('iam', region_name=region)
sts_client = boto3.client('sts', region_name=region)

account_id  = sts_client.get_caller_identity()["Account"]
dtFormat    = "%Y-%m-%d"

def json_serial(dt_object):
    '''
    Function to convert the datatime object to string object(ios format)
    
    Arguments:
        dt_object (dataetime) : Datetime object 
    Returns:
        iso format datetime(String)
    '''
    if isinstance(dt_object, (datetime.date, datetime.datetime)):
        return dt_object.isoformat()

def send_comms(complaint_value, userName, keyID, account_id, html_file):
    email     = Email(to='vignesh.palanivelr@gmail.com', subject=complaint_value + '  from AWS-Lambda')
    variables = {'username': userName, 'accesskey': keyID, 'account_id' : account_id}
    email.html(html_file, variables)
    email.send()

def tag_user(complaint_value, userName, keyID, html_file=None):
    iam_client.tag_user( UserName=userName, Tags=[{ 'Key': 'KeyComplaint', 'Value': complaint_value }])
    if complaint_value != 'ACCESS-KEY-COMPLAINT':
        send_comms(complaint_value, userName, keyID, account_id, html_file)

def complaience_check(days, userName, accessKeyID):
    if days <= warnDays:
        tag_user('ACCESS-KEY-COMPLAINT', userName, accessKeyID)
    elif days > warnDays and days <= maxDays:
        tag_user('ACCESS-KEY-WARNING', userName, accessKeyID, 'accesskey_warning.html')
    elif days > maxDays  and days <= deActDays:
        tag_user('ACCESS-KEY-WARNING', userName, accessKeyID, 'accesskey_warning.html')
    elif days > deActDays:
        tag_user('ACCESS-KEY-NON-COMPLAINT', userName, accessKeyID, 'accesskey_non_complaience.html')

def check_access_key(event, context):
    users = iam_client.list_users()
    for user in users['Users']:
        accessKeyDate = iam_client.list_access_keys(UserName=user["UserName"])['AccessKeyMetadata'][0]['CreateDate'].strftime(dtFormat)
        accessKeyID   = iam_client.list_access_keys(UserName=user["UserName"])['AccessKeyMetadata'][0]["AccessKeyId"]
        currentDate   = time.strftime(dtFormat, time.gmtime())
        dayDiff       = datetime.datetime.strptime(currentDate, dtFormat) - datetime.datetime.strptime(accessKeyDate, dtFormat)
        complaience_check(dayDiff.days, user['UserName'], accessKeyID)