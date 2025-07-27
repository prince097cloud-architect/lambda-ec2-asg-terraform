import boto3
import os

def lambda_handler(event, context):
    client = boto3.client('autoscaling')
    asg_name = os.environ['ASG_NAME']
    desired_capacity = int(os.environ['DESIRED_CAPACITY'])

    client.set_desired_capacity(
        AutoScalingGroupName=asg_name,
        DesiredCapacity=desired_capacity,
        HonorCooldown=False
    )
    return f"Set {asg_name} desired capacity to {desired_capacity}"
