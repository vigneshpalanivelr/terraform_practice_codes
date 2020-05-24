#!/usr/bin/python
'''
References:
1) JSON Role Policy : lambda_deployer_role : https://marcelog.github.io/articles/aws_lambda_start_stop_ec2_instance.html
2) Logging Hadler   : Re-Invent            : https://gist.github.com/niranjv/fb95e716151642e8ca553b0e38dd152e
3) Lambda Issue VPC : Can't connect to ISP : https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-internet
4) Date Time Ex     : Examples             : https://www.techatbloomberg.com/blog/work-dates-time-python/
5) Snapshot Ex      : Example Program      : https://gist.github.com/nirbhabbarat/047059f87138e04b2fe83bf678161fff
6) Snapshot Ex      : Example Program      : https://gist.github.com/kjoconnor/7344485
6) Snapshot Ex      : Example Program      : https://stackoverflow.com/questions/48124269/python-boto3-program-to-delete-old-snapshots-in-aws
'''
import os
import sys
import time
import json
import boto3
import datetime
import dateutil

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

'''Defining Global Variables'''
ss_in_24hrs     = []
ss_in_5days     = []
ss_recent       = []
ss_id_deleted   = []

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

def future_calculations(snapshot, tolerated_days):
    '''
    Function to calculate the future snapshot deletion dates and intimate accordingly
    
    Arguments:
        
    Returns:
        
    '''
    today_date      = datetime.datetime.now(datetime.timezone.utc).astimezone(dateutil.tz.gettz("Asia/Kolkata")).date()
    ss_created_date = snapshot['StartTime'].astimezone(gettz("Asia/Kolkata")).date()
    
    snapshot_id     = snapshot['SnapshotId']
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
    Function to cleanup the Ec2 snapshots older than X Days
    
    Arguments:
        event          (None) : No Events Required
        lambda_context (None) : No Context Required
    Returns:
        Deleting the snapshots ids reveived from he function describe_snapshots
    
    Calling Function:
        describe_snapshots (To get the list of filtered snapshots)
        json_serial       (to process output from describe_snapshots)
    '''
    
    '''Reading Environment Variables'''
    # logger.info('ENVIRONMENT VARIABLES')
    # logger.info(os.environ)
    region         = os.environ['region']
    tolerated_days = int(os.environ['tolerated_days'])
    logger.info('ENV - Region                : {}'.format(region))
    logger.info('ENV - Tolerated Days        : {}'.format(tolerated_days))
    

    '''Initializing all necessory variables'''
    print('\n')
    logger.info('Initializing boto3 client   :  EC2')
    logger.info('Initializing boto3 client   :  STS')
    ec2_client      = boto3.client('ec2', region_name=region)
    sts_client      = boto3.client('sts', region_name=region)
    
    logger.info('Describing all the EC2 Snapshots')
    ss_paginator    = ec2_client.get_paginator('describe_snapshots')
    ss_filters      = [{ 'Name': 'tag:Team', 'Values': ['terraform-services-india']}]
    account_id      = sts_client.get_caller_identity()["Account"]
    
    ss_page_iterator = ss_paginator.paginate(
        Filters          = ss_filters,
        OwnerIds         = [account_id], #'self'
        PaginationConfig = {'PageSize': 200}
    )
    
    logger.info('Calculating Snapshots age  ...')
    # print(ss_page_iterator)
    for page in ss_page_iterator:
        # print(json.dumps(page, indent=4, separators=(',', ': '), default=json_serial))
        for snapshot in page['Snapshots']:
            # print(json.dumps(snapshot, indent=4, separators=(',', ': '), default=json_serial))
            # ss_created_date = dateutil.parser.parse(str(snapshot['StartTime'].date())))
            
            action      = future_calculations(snapshot, tolerated_days)
            
            if action:
                snapshot_id = snapshot['SnapshotId']
                try:
                    dry_run = True
                    ec2_client.delete_snapshot(SnapshotId=snapshot_id, DryRun=dry_run)
                except Exception as Error_Msg:
                    dry_run = False
                    if 'DryRunOperation' in str(Error_Msg):
                        result = ec2_client.delete_snapshot(SnapshotId=snapshot_id, DryRun=dry_run)
                        if result['ResponseMetadata']['HTTPStatusCode'] == 200:
                            logger.info('Successfully Deleted SS    : {}'.format(snapshot_id))
                    elif 'InvalidSnapshot.InUse' in str(Error_Msg):
                        logger.warning('Snapshot In-Use skipping   : {}'.format(snapshot_id))
                        continue
                    else:
                        logger.error('Couldn"t Delete Snapshot   : {}'.format(snapshot_id))
                finally:
                    ss_id_deleted.append(snapshot_id)
    
    logger.info('Snapshot Report as Follows..\n')
    if ss_id_deleted:
        logger.info('Snapshots Deleted Now      : {}'.format(len(ss_id_deleted)))
    else:
        logger.info('Snapshots Breached         : None')
    
    if ss_in_24hrs:
        logger.info('Snapshots in Tolerated     : {}'.format(len(ss_in_24hrs)))
    else:
        logger.info('Snapshots in Tolerated     : None')
    
    if ss_in_5days:
        logger.info('Snapshots in Queue         : {}'.format(len(ss_in_5days)))
    else:
        logger.info('Snapshots in Queue         : None')
        
    if ss_recent:
        logger.info('Snapshots in Recent        : {}'.format(len(ss_recent)))
    else:
        logger.info('Snapshots in Recent        : None\n')
    
    logger.info('# End of EC2 Snapshots Clean-Up Activity')