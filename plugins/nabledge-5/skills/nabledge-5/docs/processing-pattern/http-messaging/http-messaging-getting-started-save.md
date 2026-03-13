# 登録機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/getting_started/save/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html)

## 登録を行う

## リクエスト仕様

HTTPメッセージングによる登録機能を呼び出す際のリクエスト仕様:

- **URL**: `http://localhost:9080/ProjectSaveAction`
- **HTTPメソッド**: POST
- **HTTPヘッダ**:
  - `Content-Type: application/json`
  - `X-Message-Id: 1`
- **リクエストボディ**:
```json
{
    "projectName": "プロジェクト９９９",
    "projectType": "development",
    "projectClass": "ss",
    "projectManager": "山田",
    "projectLeader": "田中",
    "clientId": 10,
    "projectStartDate": "20160101",
    "projectEndDate": "20161231",
    "note": "備考９９９",
    "sales": 10000,
    "costOfGoodsSold": 20000,
    "sga": 30000,
    "allocationOfCorpExpenses": 40000
}
```

## フォーマットファイルの作成

HTTPメッセージングでは、リクエストされたHTTPメッセージを [data_format](../../component/libraries/libraries-data_format.md) を使用して解析する。

フォーマットファイルの名称は「リクエストID + `_RECEIVE`」形式にする。フォーマットファイルの記述方法は :ref:`data_format-definition` を参照。

**フォーマットファイル例** (`ProjectSaveAction_RECEIVE.fmt`):
```
file-type:        "JSON"
text-encoding:    "UTF-8"

[project]
1  projectName                       N
2  projectType                       N
3  projectClass                      N
4  projectStartDate[0..1]            N
5  projectEndDate[0..1]              N
6  clientId                          X9
7  projectManager[0..1]              N
8  projectLeader[0..1]               N
9  note[0..1]                        N
10 sales[0..1]                       X9
11 costOfGoodsSold[0..1]             X9
12 sga[0..1]                         X9
13 allocationOfCorpExpenses[0..1]    X9
14 userId[0..1]                      X9
```

## フォームの作成

[bean_validation](../../component/libraries/libraries-bean_validation.md) を用いてバリデーションを行うため、バリデーション用のアノテーションを設定する。

```java
public class ProjectForm {
    @Required
    @Domain("projectName")
    private String projectName;
    // getter/setter省略
}
```

## 業務アクションの作成

- `MessagingAction` を継承し、業務メソッドを作成する。
- `MessagingAction#onReceive` にリクエスト受信時の処理を実装する。
- リクエストボディの値は [data_format](../../component/libraries/libraries-data_format.md) で解析された状態で `RequestMessage` オブジェクトが保持している。`getParamMap` メソッドで取得する。
- [bean_validation](../../component/libraries/libraries-bean_validation.md) でリクエスト値のバリデーションを行う。
- `UniversalDao` でプロジェクトをDBに登録する。
- 処理結果を表すレスポンスコードを `ResponseMessage` に設定して返却する。

> **補足**: 業務例外が送出された場合は、[http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md) の処理によってレスポンスコード「400」が設定される。

```java
public class ProjectSaveAction extends MessagingAction {
    @Override
    protected ResponseMessage onReceive(RequestMessage requestMessage,
                                        ExecutionContext executionContext) {
        ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class,
                requestMessage.getParamMap());
        ValidatorUtil.validate(form);
        UniversalDao.insert(BeanUtil.createAndCopy(Project.class, form));
        requestMessage.setFormatterOfReply(createFormatter());
        Map<String, String> map = new HashMap<>();
        map.put("statusCode", String.valueOf(HttpResponse.Status.CREATED.getStatusCode()));
        return requestMessage.reply()
               .setStatusCodeHeader(String.valueOf(HttpResponse.Status.CREATED.getStatusCode()))
               .addRecord("data", map);
    }
}
```

<details>
<summary>keywords</summary>

MessagingAction, RequestMessage, UniversalDao, ResponseMessage, @Required, @Domain, HTTPメッセージング登録処理, フォーマットファイル作成, バリデーション, DB登録, onReceive, getParamMap, BeanUtil, ValidatorUtil, HttpResponse, ExecutionContext, Project

</details>
