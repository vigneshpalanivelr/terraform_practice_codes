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
ss_in_24hrs     = []
ss_in_5days     = []
ss_recent       = []
ss_id_deleted   = []
rds_not_ours    = []
today_date      = datetime.datetime.now(datetime.timezone.utc).astimezone(gettz("Asia/Kolkata"))
logger.info('Today"s Date               : {}'.format(today_date))

'''Reading Environment Variables'''
# logger.info('ENVIRONMENT VARIABLES')
# logger.info(os.environ)
region         = os.environ['region']
tolerated_days = int(os.environ['tolerated_days'])
logger.info('ENV - Region               : {}'.format(region))
logger.info('ENV - Tolerated Days       : {}\n'.format(tolerated_days))

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

def delete_snapshots(snapshots):
    '''
    Function to calculate and delete SS
    
    Arguments:
        snapshot       (snapshot) : Snapshot object with details
        
    Returns:
        Deletion
    '''
    for snapshot in snapshots['DBSnapshots']:
        # print(json.dumps(snapshot, indent=4, separators=(',', ': '), default=json_serial))
        rds_instance = snapshot['DBInstanceIdentifier']
        rds_ss_id    = snapshot['DBSnapshotIdentifier']
        snapshot_arn = snapshot['DBSnapshotArn']
        
        if snapshot['Status'] == 'available':
            logger.info('Working on RDS Instance    :  {}'.format(rds_instance))
            
            tags = rds_client.list_tags_for_resource(ResourceName=snapshot_arn)["TagList"]
            # print(json.dumps(tags, indent=4, separators=(',', ': '), default=json_serial))
            Team, retention_value = None, -1
            
            for tag in tags:
                if tag['Key'] == 'Team' and tag['Value'] == 'terraform-services-india':
                    Team = True
                if tag['Key'] == 'BackupRetentionPolicy':
                    logger.info('Checking the SS Tags')
                    retention_value = tag['Value']
                else:
                    retention_value = tolerated_days
            
            if not Team or retention_value < 0:
                rds_not_ours.append(rds_instance)
            
            try:
                if Team and retention_value >=0 and delete_calculations(snapshot, retention_value, today_date):
                    if rds_client.delete_db_snapshot(DBSnapshotIdentifier = rds_ss_id):
                        ss_id_deleted.append(rds_ss_id)
                        logger.info('Successfully Deleted SS    : {}'.format(rds_ss_id))
            except Exception as Error_Msg:
                logger.error('Couldn"t Delete Snapshot   : {} : {}'.format(rds_ss_id, str(Error_Msg)))

def delete_calculations(snapshot, tolerated_days, today_date):
    '''
    Function to calculate the snapshot can be deleted or not
    
    Arguments:
        snapshot       (snapshot) : Snapshot object with details
        tolerated_days (int)      : tolerated_days that SSN to be deleted
        today_date     (date)     : Date Object
        
    Returns:
        delete (Boolean)          : With this SS can be decided to be deleted or not
    
    '''
    today_date      = today_date.date()
    ss_created_date = snapshot['InstanceCreateTime'].astimezone(gettz("Asia/Kolkata")).date()
    
    snapshot_id     = snapshot['DBSnapshotIdentifier']
    delete          = False
    
    days_old        = abs((ss_created_date - today_date).days)
    
    if days_old == tolerated_days:
        delete = True
    elif days_old == (tolerated_days - 1):
        ss_in_24hrs.append(snapshot_id)
    elif days_old >= (tolerated_days - 5) and days_old < (tolerated_days - 1):
        ss_in_5days.append(snapshot_id)
    else:
        ss_recent.append(snapshot_id)
    
    return delete
    
''' Main Function'''
def snapshots_cleanup(event, lambda_context):
    '''
    Function to cleanup the RDS snapshots older than X Days
    
    Arguments:
        event          (None) : No Events Required
        lambda_context (None) : No Context Required
    Returns:
        Iterating the Snapshots then calculate it and Delete it
    
    Calling Function:
        delete_calculations (Calculate that it can be deleted or not)
        delete_snapshots    (Based on the above Calculations, decided to delete the SS
        json_serial         (to process output from describe_snapshots)
    '''
    
    logger.info('Describing all the RDS Snapshots ...')
    snapshots       = rds_client.describe_db_snapshots(Filters=[{'Name': 'snapshot-type','Values': ['manual','awsbackup']}])
    delete_snapshots(snapshots)
    
    # print(json.dumps(snapshots, indent=4, separators=(',', ': '), default=json_serial))
    # print(json.dumps(snapshots.get('Marker', False), indent=4, separators=(',', ': '), default=json_serial))
    
    marker = snapshots.get('Marker', False)
    while marker:
        delete_snapshots(snapshots)
    
    logger.info('Snapshot Report as Follows...\n')
    logger.info('Snapshots Deleted Now      : {}'.format(len(ss_id_deleted)))
    logger.info('Snapshots in Tolerated     : {}'.format(len(ss_in_24hrs)))
    logger.info('Snapshots in Queue         : {}'.format(len(ss_in_5days)))
    logger.info('Snapshots in Recent        : {}'.format(len(ss_recent)))
    logger.info('Snapshots skipped          : {}'.format(len(rds_not_ours)))
    logger.info('# End of EC2 Snapshots Clean-Up Activity #')