# Development Setup

1. Have Docker installed on your system
2. pip install localstack
3. pip install awscli
4. pip install awscli-local
5. Have the localstack desktop client installed (optional)


## Resources
https://docs.localstack.cloud/user-guide/integrations/terraform/
https://docs.localstack.cloud/getting-started/quickstart/
https://docs.localstack.cloud/user-guide/integrations/aws-cli/



## Commands
```
localstack start
```

Deploy your infra using terraform as normal.


## Good to know
``
tflocal output
``

``
awslocal --region=eu-west-1  s3 ls <bucket_name>
``

``
awslocal --region=eu-west-1  lambda list-functions
``

``
awslocal --region=eu-west-1  s3 ls $(terraform output -raw lambda_bucket_name)
``

``
awslocal lambda invoke --region=eu-west-1 --function-name=$(terraform output -raw function_name) response.json
``

```
awslocal --region=eu-west-1  lambda get-function --function-name=<function_name>
```

## Lambda
Functions written for Python 3.11