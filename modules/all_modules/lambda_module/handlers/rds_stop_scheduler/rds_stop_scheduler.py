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
8) RDS Stopping     : Example Program      : https://dev.to/ajkerrigan/fetch-a-bunch-of-aws-resource-tags-without-being-throttled-4hhc
'''
import os
import sys
import time
import json
import boto3
import datetime
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
rds_not_ours    = []
rds_stop_error  = []
rds_stopped     = []
stopped_already = []
rds_other_state = []
today_date      = datetime.datetime.now(datetime.timezone.utc).astimezone(gettz("Asia/Kolkata"))
logger.info('Today"s Date               : {}'.format(today_date))

'''Reading Environment Variables'''
# logger.info('ENVIRONMENT VARIABLES')
# logger.info(os.environ)
region         = os.environ['region']
logger.info('ENV - Region               : {}'.format(region))

logger.info('Initializing boto3 client  : RDS')
rds_client      = boto3.client('rds', region_name=region)

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

''' Main Function'''
def stop_instance(event, lambda_context):
    '''
    Function to cleanup the Ec2 snapshots older than X Days
    
    Arguments:
        event          (None) : No Events Required
        lambda_context (None) : No Context Required
    Returns:
        Stopping the RDS Instances with Team tag
    
    Calling Function:
        json_serial       (to process output from describe_snapshots)
    '''
    
    logger.info('Describing all the RDS Instances ...')
    rds_instance_iterator = rds_client.get_paginator('describe_db_instances')
    
    # instances = {instance['DBInstanceArn']: instance for page in rds_instance_iterator.paginate() for instance in page['DBInstances']}
    logger.info('Iterating through each Instance  ...')
    for page in rds_instance_iterator.paginate():
        for instance in page['DBInstances']:
            instance_id = instance['DBInstanceIdentifier']
            # print(json.dumps(instance, indent=4, separators=(',', ': '), default=json_serial))
            try:
                if not rds_client.list_tags_for_resource(ResourceName=instance['DBInstanceArn'])['TagList']:
                    rds_not_ours.append(instance_id)
                for i in rds_client.list_tags_for_resource(ResourceName=instance['DBInstanceArn'])['TagList']:
                    if instance['DBInstanceStatus'] == 'stopped':
                        stopped_already.append(instance_id)
                    elif instance['DBInstanceStatus'] not in ['stopped','available']:
                        rds_other_state.append(instance_id)
                    elif instance['DBInstanceStatus'] == 'available':
                        if i['Key'] == 'Team' and i['Value'] == 'terraform-services-india':
                            rds_client.stop_db_instance(DBInstanceIdentifier=instance_id)
                            rds_stopped.append(instance_id)
                            logger.info('Stopped the Instance             : {}'.format(instance_id))
                        else:
                            rds_not_ours.append(instance_id)
            except Exception as Error_Msg:
                logger.error('Couldn"t Stop the Instance       : {} with {}'.format(instance_id, str(Error_Msg)))
                rds_stop_error.append(instance_id)
    
    logger.info('RDS Instance Stop Report as Follows...\n')
    logger.info('Instances Stopped Now            : {}'.format(len(rds_stopped)))
    logger.info('Instances Already in Stop state  : {}'.format(len(stopped_already)))
    logger.info('Instances in Other state         : {}'.format(len(rds_other_state)))
    logger.info('Instances ignored                : {}'.format(len(rds_not_ours)))
    logger.error('Error in Stopping Instances     : {}\n'.format(len(rds_stop_error)))
    logger.info('# End of End of RDS Stop Instances Activity #')