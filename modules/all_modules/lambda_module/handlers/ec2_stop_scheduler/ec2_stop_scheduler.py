#!/usr/bin/python
'''
References:
1) JSON Role Policy : lambda_deployer_role : https://marcelog.github.io/articles/aws_lambda_start_stop_ec2_instance.html
2) Logging Hadler   : Re-Invent            : https://gist.github.com/niranjv/fb95e716151642e8ca553b0e38dd152e
3) Lambda Issue VPC : Can't connect to ISP : https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-internet
'''
import os
import sys
import time
import json
import boto3
import datetime

'''importing custom modules'''
'''Jupyter Notebook - Log file'''
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

today_date      = datetime.datetime.now(datetime.timezone.utc).astimezone(gettz("Asia/Kolkata"))
logger.info('Today"s Date                : {}'.format(today_date))

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

def describe_instance(ec2_client, filter):
    '''
    Function to Describe the EC2 instance and Filter instances based on the filter condition passed
    
    Arguments:
        ec2_client (ec2 client) : EC2 Client object
        filter     (List)       : List of dictionary with Filter values
    Returns:
        List of Instance IDs
    '''
    describe_instances    = ec2_client.describe_instances(Filters= filter)
    instance_id_list      = [instance['InstanceId'] for reservations in describe_instances['Reservations'] for instance in reservations['Instances']]
    # logger.info(instance_id_list)
    return instance_id_list

''' Main Function'''
def stop_instance(event, lambda_context):
    '''
    Function to Stop the Ec2 Instances
    
    Arguments:
        event          (None) : No Events Required
        lambda_context (None) : No Context Required
    Actions:
        Stopping the instances received from describe_instance function
    
    Calling Function:
        describe_instance (To get the list of filtered instances)
        json_serial       (to process output from describe_instance)
    '''
    
    '''Reading Environment Variables'''
    # logger.info('ENVIRONMENT VARIABLES')
    # logger.info(os.environ)
    region = os.environ['region']
    logger.info('ENV - Region                  : {}'.format(region))

    '''Initializing all necessory variables'''
    print('\n')
    logger.info('Initializing boto3 client     : EC2')
    ec2_client                = boto3.client('ec2', region_name=region)
    
    ec2_stop_instances_waiter = ec2_client.get_waiter('instance_stopped')
    filter_running_instance   = [{ 'Name'   : 'instance-state-name', 'Values' : ['pending','running']},
                                 { 'Name'   : 'tag:Scheduled',       'Values' : ['True']}]
    filter_stopped_instance   = [{ 'Name'   : 'instance-state-name', 'Values' : ['stopped']}]
    
    logger.info('Fetching Running EC2 instance Details')
    instance_id_list = describe_instance(ec2_client, filter_running_instance)
    
    if instance_id_list:
        try: 
            logger.info('Stopping Instance(s)          : {} ...'.format(instance_id_list))
            stop_trigger   = ec2_client.stop_instances(InstanceIds = instance_id_list)
            if stop_trigger['ResponseMetadata']['HTTPStatusCode'] == 200:
                logger.info(json.dumps(stop_trigger['StoppingInstances'], indent=4, separators=(',', ': '), default=json_serial))
            ec2_stop_instances_waiter.wait(Filters=filter_stopped_instance)
            logger.info('Stopped Instance(s)           : {}'.format(instance_id_list))
            logger.info('# Lambda Function status      : Completed #\n\n')
        except Exception as Error:
            logger.error('%s' %Error)
            logger.error('Failure in Stopping Instance : {} !!!'.format(instance_id_list))
            logger.error('# Lambda Function status     : Failed #\n\n')
    else:
        logger.warning('No instance is in Running State')
        logger.warning('# Lambda Function status   : None #\n\n')
    
    logger.info('# End of EC2 Stop Activity #')