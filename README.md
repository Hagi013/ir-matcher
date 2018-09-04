## Swagger Editor
- 立ち上げ
[参考](http://tokyo.supersoftware.co.jp/code/8592)
```
$ docker pull swaggerapi/swagger-editor
$ docker run -d -p 18081:8080 swaggerapi/swagger-editor
```
- 接続先
http://localhost:18081


## SAM
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

