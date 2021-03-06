# 環境構築
## SAM
1. Verify Python Version is 2.7 or 3.6.
```
python --version

```

2. Verify Pip is installed
```
pip --version

```

3. sam-cliのインストール
```
pip install --user aws-sam-cli
```

4. Adjust your PATH to include Python scripts installed under User's directory.(.zshrcに記載など行う)
```
# Find your Python User Base path (where Python --user will install packages/scripts)
$ USER_BASE_PATH=$(python -m site --user-base)

# Update your preferred shell configuration
## Standard bash --> ~/.bash_profile
## ZSH           --> ~/.zshrc
$ export PATH=$PATH:$USER_BASE_PATH/bin

```

5. Restart or Open up a new terminal and verify that the installation worked:
```
# Restart current shell
$ exec "$SHELL"
$ sam --version
```
   

### サンプルアプリケーションの作り方
```
sam init --runtime nodejs
```


#### Local development

**Invoking function locally through local API Gateway**

```bash
sam local start-api
```

If the previous command ran successfully you should now be able to hit the following local endpoint to invoke your function `http://localhost:3000/hello`

**SAM CLI** is used to emulate both Lambda and API Gateway locally and uses our `template.yaml` to understand how to bootstrap this environment (runtime, where the source code is, etc.) - The following excerpt is what the CLI will read in order to initialize an API and its routes:

```yaml
...
Events:
    HelloWorld:
        Type: Api # More info about API Event Source: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#api
        Properties:
            Path: /hello
            Method: get
```

### Packaging and deployment

AWS Lambda NodeJS runtime requires a flat folder with all dependencies including the application. SAM will use `CodeUri` property to know where to look up for both application and dependencies:

```yaml
...
    FirstFunction:
        Type: AWS::Serverless::Function
        Properties:
            CodeUri: hello_world/
            ...
```

Firstly, we need a `S3 bucket` where we can upload our Lambda functions packaged as ZIP before we deploy anything - If you don't have a S3 bucket to store code artifacts then this is a good time to create one:

```bash
aws s3 mb s3://BUCKET_NAME
```

Next, run the following command to package our Lambda function to S3:

```bash
sam package \
    --template-file template.yaml \
    --output-template-file packaged.yaml \
    --s3-bucket REPLACE_THIS_WITH_YOUR_S3_BUCKET_NAME
```

Next, the following command will create a Cloudformation Stack and deploy your SAM resources.

```bash
sam deploy \
    --template-file packaged.yaml \
    --stack-name sam-app \
    --capabilities CAPABILITY_IAM
```

> **See [Serverless Application Model (SAM) HOWTO Guide](https://github.com/awslabs/serverless-application-model/blob/master/HOWTO.md) for more details in how to get started.**

After deployment is complete you can run the following command to retrieve the API Gateway Endpoint URL:

```bash
aws cloudformation describe-stacks \
    --stack-name sam-app \
    --query 'Stacks[].Outputs'
``` 

### Testing

We use `jest` for testing our code and it is already added in `package.json` under `scripts`, so that we can simply run the following command to run our tests:

```bash
cd hello_world
npm run test
```

## Appendix

### AWS CLI commands

AWS CLI commands to package, deploy and describe outputs defined within the cloudformation stack:

```bash
sam package \
    --template-file template.yaml \
    --output-template-file packaged.yaml \
    --s3-bucket REPLACE_THIS_WITH_YOUR_S3_BUCKET_NAME

sam deploy \
    --template-file packaged.yaml \
    --stack-name sam-app \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides MyParameterSample=MySampleValue

aws cloudformation describe-stacks \
    --stack-name sam-app --query 'Stacks[].Outputs'
```

**NOTE**: Alternatively this could be part of package.json scripts section.

### Bringing to the next level

Here are a few ideas that you can use to get more acquainted as to how this overall process works:

* Create an additional API resource (e.g. /hello/{proxy+}) and return the name requested through this new path
* Update unit test to capture that
* Package & Deploy

Next, you can use the following resources to know more about beyond hello world samples and how others structure their Serverless applications:

* [AWS Serverless Application Repository](https://aws.amazon.com/serverless/serverlessrepo/)


### ローカルテスト
- API GWのEvents作成
```bash
sam local generate-event apigateway aws-proxy > ./test/events/api_test.json
```

- Lambdaのローカル起動
```bash
sam local invoke InvestorFunction --event ./test/events/api_test.json
```

- APIGWのローカル起動
```bash
sam local start-api
```

## Dynamo Local([参考](http://blog.serverworks.co.jp/tech/2018/08/29/dynamodb-local-dokcer/))
1. イメージをダウンロードしてバックグラウンドで実行
```bash
docker run -d -p 8000:8000 amazon/dynamodb-local
```
2. CLIで接続を確認する
```bash
aws --endpoint-url http://localhost:8000 dynamodb  create-table --table-name LaunchList --attribute-definitions AttributeName=Name,AttributeType=S --key-schema AttributeName=Name,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

```
3. テーブルのリストを確認
```bash
aws --endpoint-url http://localhost:8000 dynamodb list-tables
```


