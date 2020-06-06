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
region         = os.environ['region']
logger.info('ENV - Region               : {}'.format(region))

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

import time
import boto3
'''
https://aws.amazon.com/blogs/compute/parallel-processing-in-python-with-aws-lambda/
'''
class VolumesSequential(object):
    """Finds total volume size for all EC2 instances"""
    def __init__(self, region):
        self.ec2        = boto3.resource('ec2', region_name=region)
        self.ec2_client = boto3.client('ec2', region_name=region)

    def instance_volumes(self):
        """
        Finds total size of the EBS volumes attached
        to an EC2 instance
        """
        instance_total = 0
        instances      = self.ec2.instances.all()
        for instance in instances:
            for volume in instance.volumes.all():
                instance_total += volume.size
        return instance_total
    
    def all_volumes(self):
        """
        Finds total size of the EBS volumes attached
        to an EC2 instance
        """
        attached_size   = 0
        avilable_size   = 0
        other_size      = 0
        a_volume_count  = 0
        f_volume_count  = 0
        
        volumes       = self.ec2_client.describe_volumes()
        # print(json.dumps(volumes, indent=4, separators=(',', ': '), default=json_serial))
        
        for volume in volumes['Volumes']:
            if volume['Attachments']:
                attached_size  += volume['Size']
                a_volume_count += 1
            elif not volume['Attachments'] and volume['State'] == 'available':
                avilable_size += volume['Size']
                f_volume_count += 1
            else:
                other_size += volume['Size']
        
        return attached_size, avilable_size, other_size, a_volume_count, f_volume_count

    def total_size(self):
        """
        Lists all EC2 instances in the default region
        and sums result of instance_volumes
        """
        
        self.instance_volume                                    = self.instance_volumes()
        self.attached_size, self.avilable_size, self.other_size, self.a_volume_count, self.f_volume_count = self.all_volumes()
        

def volume_eni_checker(event, context):
    volumes = VolumesSequential(region)
    total = volumes.total_size()
    # print(json.dumps(volumes.__dict__, indent=4, separators=(',', ': '), default=json_serial))
    logger.info('Volumes Attached    Size & count : {}GB \t {}'.format(volumes.attached_size, volumes.a_volume_count))
    logger.info('Volumes Un-Attached Size & count : {}GB \t {}'.format(volumes.avilable_size, volumes.f_volume_count))