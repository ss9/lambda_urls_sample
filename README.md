# lambda_urls_sample
lambda urlsを利用したpythonスクリプトのサンプルです。

[AWS Lambda 関数 URL: Lambda 関数用の組み込み HTTPS エンドポイント](https://aws.amazon.com/jp/about-aws/whats-new/2022/04/aws-lambda-function-urls-built-in-https-endpoints/)



# 構成

## lambda_py

urlエンドポイントにリクエストされたときに動作するスクリプトです。
dockerによるコンテナにて作成しております。

## terraform

lambda urlsを構成するterraformです。

# 利用方法

## アプリケーション

pythonディレクトリに移動してください。
``` shell
$ cd lambda_py
```

buildします。

``` shell
$ docker build [--platform linux/arm64] -t lambda_urls_sample .
```

ローカルで確認します。

```shell
$ docker run -d -p 9000:8080 lambda_urls_sample
```

curlでアクセスして簡単な確認が可能です。(Lambda上で動作させることを前提に作成しています)

```
$ curl -X GET 'http://localhost:9000/2015-03-31/functions/function/invocations' -d '{"name": " your name"}'
"Hello no name from AWS Lambda using Python 3.8.13 (default, Apr 11 2022, 19:27:44) \n[GCC 7.3.1 20180712 (Red Hat 7.3.1-13)] ! \n query string is "
```

対象のECRにコンテナをpushします。
※ 事前にECRを作成しておいてください。

``` shell
# login ECR
$ aws ecr get-login-password --profile [your profile] | docker login --username AWS --password-stdin [AWS Account ID].dkr.ecr.ap-northeast-1.amazonaws.com
# tagged
$ docker tag [Container ID] [AWS Account ID].dkr.ecr.ap-northeast-1.amazonaws.com/lambda_urls_sample
# pushed
docker push [AWS Account ID].dkr.ecr.ap-northeast-1.amazonaws.com/lambda_urls_sample
```

## インフラストラクチャ

terraformでlambdaを実装します。
まずはterraform.tfvarsを作成して、それぞれ個人の内容を記載します。

sample

```terraform
aws_account                 = [AWS Account ID]
aws_region                  = "ap-northeast-1"
aws_profile                 = [your aws token]
image_uri                   = "[AWS Account ID].dkr.ecr.ap-northeast-1.amazonaws.com/lambda_urls_sample:latest"
lambda_arch                 = "arm64"
```

terraformのディレクトリに移動します。

```
$ cd terraform
```

terraformでinit,plan,apply処理を実施します。
AWSプロバイダーの4.10.0が必須となります。

```
$ terraform init
$ terraform plan
$ terraform apply --auto-approve
・・・
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

lambda_https_test_url = "[Output Lambda Function Url]"
```


## 確認
curlで確認

```
$ curl -X GET '[Output Lambda Function Url]?id=123456' -d '{"name": "your name"}'
Hello your name from AWS Lambda using Python 3.8.13 (default, Apr 11 2022, 19:27:44)
[GCC 7.3.1 20180712 (Red Hat 7.3.1-13)] !
 query string = id=123456
```

webブラウザで確認
```
[Output Lambda Function Url]?id=123456
```




