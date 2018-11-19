## Swagger Editor
1. 立ち上げ
[参考](http://tokyo.supersoftware.co.jp/code/8592)
```
$ docker pull swaggerapi/swagger-editor
$ docker run -d -p 18081:8080 swaggerapi/swagger-editor
```
- 接続先
http://localhost:18081

- コマンドだと
```
sh <path-to-swagger>/start.sh
```

- rendering
接続先に接続後、`dev-ir-matcher-dev-swagger.yaml` をブラウザにドラッグする。
