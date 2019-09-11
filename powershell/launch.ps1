# Script to Launch an CFT with paramters etc 
# Your AWS keypair name
$p1 = new-object Amazon.CloudFormation.Model.Parameter
$p1.ParameterKey = "KeyName"
$p1.ParameterValue = "AAAWS"
# Your S3 Bucket - needs the full https://xxxx url
$p2 = new-object Amazon.CloudFormation.Model.Parameter
$p2.ParameterKey = "S3Bucket"
$p2.ParameterValue = "https://s3-us-west-1.amazonaws.com/as3bkt"
# Source IP address range x.x.x.x/x for SSH access
$p3 = new-object Amazon.CloudFormation.Model.Parameter
$p3.ParameterKey = "ScrIP"
$p3.ParameterValue = "204.134.187.137/24"
# Source IP adderess range for app access
$p4 = new-object Amazon.CloudFormation.Model.Parameter
$p4.ParameterKey = "PubScrIP"
$p4.ParameterValue = "204.134.187.137/24"
# Admin password for BIG-IP
$p5 = new-object Amazon.CloudFormation.Model.Parameter
$p5.ParameterKey = "BigIpAdminPW"
$p5.ParameterValue = "cowdogfish"
# Call New-CFNStack with paramters 
$stack =  New-CFNStack -StackName MyF5Lab -DisableRollback $true -Capability CAPABILITY_NAMED_IAM  -TemplateURL https://s3-us-west-1.amazonaws.com/as3bkt/lab.yaml -Parameters @( $p1, $p2, $p5 )