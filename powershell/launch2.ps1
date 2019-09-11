# Script to Launch the CFT with paramters etc 
# First parameter
$p1 = new-object Amazon.CloudFormation.Model.Parameter
$p1.ParameterKey = "KeyName"
$p1.ParameterValue = "AAAWS"
$p2 = new-object Amazon.CloudFormation.Model.Parameter
$p2.ParameterKey = "S3Bucket"
$p2.ParameterValue = "https://s3-us-west-1.amazonaws.com/as3bkt"
$stack =  New-CFNStack -StackName Demo5 -Capability CAPABILITY_NAMED_IAM  -TemplateURL https://s3-us-west-1.amazonaws.com/as3bkt/Demo5.yaml -Parameters @( $p1, $p2 )