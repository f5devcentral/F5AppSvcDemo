Write-S3Object -BucketName $env:DemoBkt -File .\CFT\lab.yaml
Write-S3Object -BucketName $env:DemoBkt -File .\CFT\big-ip.yaml
Write-S3Object -BucketName $env:DemoBkt -File .\keys\id_rsa.pem
Write-S3Object -BucketName $env:DemoBkt -File .\keys\key.pub