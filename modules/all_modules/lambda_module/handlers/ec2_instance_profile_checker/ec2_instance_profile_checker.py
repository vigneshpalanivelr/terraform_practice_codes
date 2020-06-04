#!/usr/bin/python
'''
References:
1) JSON Role Policy : lambda_deployer_role : https://marcelog.github.io/articles/aws_lambda_start_stop_ec2_instance.html
2) Logging Hadler   : Re-Invent            : https://gist.github.com/niranjv/fb95e716151642e8ca553b0e38dd152e
3) Lambda Issue VPC : Can't connect to ISP : https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-internet
4) Date Time Ex     : Examples             : https://www.techatbloomberg.com/blog/work-dates-time-python/
5) Snapshot Ex      : Example Program      : https://gist.github.com/nirbhabbarat/047059f87138e04b2fe83bf678161fff
6) Snapshot Ex      : Example Program      : https://gist.github.com/kjoconnor/7344485
7) Snapshot Ex      : Example Program      : https://stackoverflow.com/questions/48124269/python-boto3-program-to-delete-old-snapshots-in-aws
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
logger.info('ENV - Region               : {}'.format(region))

r53_client   = boto3.client('route53', region_name=region)
logger.info('Initializing boto3 client  : R53')

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

class ec2_instance_profile:
    def __init__(self, event):
        '''
        Function to create details about the required details

        Arguments:
            event (Dict) : event api object
        Returns:
            None
        FunctionCalls
            map_values   : To map operation occured
        '''
        res_element_type = self.map_values(event['detail']['eventName'])
        
        instance_arn     = event['detail']['responseElements'][res_element_type] \
                           ['iamInstanceProfileAssociation']['iamInstanceProfile']['arn']
        instance_id      = event['detail']['responseElements'][res_element_type] \
                           ['iamInstanceProfileAssociation']['instanceId']
        state            = event['detail']['responseElements'][res_element_type] \
                           ['iamInstanceProfileAssociation']['state']
        time             = datetime.datetime.strftime(dateutil.parser.parse(event['detail']['eventTime']),"%Y-%m-%d-%H:%M:%S-%Z")
        
        self.detail_dict = {
            instance_arn.split(':')[-2] : {
                instance_id : {
                    time : {
                        'Incident'  : event['detail']['eventName'],
                        'UserName'  : event['detail']['userIdentity']['type'],
                        'UserARN'   : event['detail']['userIdentity']['arn'],
                        'Profile'   : instance_arn.split('/')[-1],
                        'AccountNo' : instance_arn.split(':')[-2]
                    }
                }
            }
        }
        
    
    def map_values(self, key):
        '''
        Function to Map the list of actions happened and return mapped response API call

        Arguments:
            key (String)              : Key refres the action
        Returns:
            res_element_type (String) : Action response
        FunctionReturns:
            __init__
        '''
        switcher =  {
                'AssociateIamInstanceProfile'          : 'AssociateIamInstanceProfileResponse',
                'DisassociateIamInstanceProfile'       : 'DisassociateIamInstanceProfileResponse',
                'ReplaceIamInstanceProfileAssociation' : 'ReplaceIamInstanceProfileAssociationResponse'
                }
        if key in switcher:
            res_element_type = switcher.get(key)
            return res_element_type                        
    
def check_cloudtrail_events(event, lambda_context):
    '''
    Function to Map the list of actions happened and return mapped response API call

    Arguments:
        event          (Dict)     : Dict from CloudTrail API call
        lambda_context (None)
    FunctionCalls:
        json_serial          (Datetime) : To String
        ec2_instance_profile (Class)    : To Process the event
    '''
    logger.info('Event Received             : Successfully')
    # logger.info('Event Detail        : \n{}'.format(json.dumps(event['detail'], indent=4, separators=(',', ' : '), default=json_serial)))
    
    if 'errorCode' in event["detail"]:
        logger.error('## Un-Successfull API Call: {} ##'.format(event['detail']['errorCode']))
    else:
        logger.info('Successfull API Call       : Processing event')
        if event['detail']['eventName'] in ["AssociateIamInstanceProfile", "DisassociateIamInstanceProfile", "ReplaceIamInstanceProfileAssociation"]:
            logger.info('Found API Call Match       : {}'.format(event['detail']['eventName']))
            event_class_details = ec2_instance_profile(event)
            logger.info('Event Detail               : \n{}'.format(json.dumps(event_class_details.__dict__, indent=4, separators=(',', ' : '), default=json_serial)))
            logger.info('## Completed Event Processing ##')