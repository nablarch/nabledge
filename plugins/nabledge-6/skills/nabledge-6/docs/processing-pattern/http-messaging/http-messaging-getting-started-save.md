# 登録機能の作成

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/http_messaging/getting_started/save/index.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/action/MessagingAction.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/RequestMessage.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/dao/UniversalDao.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/messaging/ResponseMessage.html)

## 登録を行う

## フォーマットファイルの作成

HTTPメッセージングのリクエストは [data_format](../../component/libraries/libraries-data_format.md) で解析する。フォーマットファイル名は「リクエストID + `_RECEIVE`」形式にする。

```bash
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

[bean_validation](../../component/libraries/libraries-bean_validation.md) アノテーションをフィールドに設定する。

```java
public class ProjectForm {
    @Required
    @Domain("projectName")
    private String projectName;
    public String getProjectName() { return projectName; }
    public void setProjectName(String projectName) { this.projectName = projectName; }
}
```

## 業務アクションの作成

`MessagingAction` を継承し、`MessagingAction#onReceive` に受信時処理を実装する。

リクエストボディの値は [data_format](../../component/libraries/libraries-data_format.md) で解析済みの状態で `RequestMessage` が保持しており、`getParamMap` メソッドで取得する。

[bean_validation](../../component/libraries/libraries-bean_validation.md) でバリデーション後、`UniversalDao` でDBに登録する。処理結果のレスポンスコードを `ResponseMessage` に設定して返却する。

```java
public class ProjectSaveAction extends MessagingAction {
    @Override
    protected ResponseMessage onReceive(RequestMessage requestMessage,
                                        ExecutionContext executionContext) {
        ProjectForm form = BeanUtil.createAndCopy(ProjectForm.class, requestMessage.getParamMap());
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

> **補足**: 業務例外が送出された場合は、[http_messaging_error_handler](../../component/handlers/handlers-http_messaging_error_handler.md) の処理によってレスポンスコード「400」が設定される。

<details>
<summary>keywords</summary>

MessagingAction, RequestMessage, ResponseMessage, UniversalDao, ProjectForm, ProjectSaveAction, Project, BeanUtil, ValidatorUtil, ExecutionContext, HttpResponse, @Required, @Domain, HTTPメッセージング登録処理, フォーマットファイル作成, bean_validation, データベース登録, レスポンスコード設定

</details>

## 動作確認手順

## 動作確認手順

### 1. 事前にDBの状態を確認

H2のコンソールから下記SQLを実行し、レコードが存在しないことを確認する。

```sql
SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
```

### 2. プロジェクト情報の登録

任意のRESTクライアントを使用して、以下のリクエストを送信する。

| 項目 | 値 |
|------|----|
| URL | `http://localhost:9080/ProjectSaveAction` |
| HTTPメソッド | POST |
| Content-Type | `application/json` |
| X-Message-Id | `1` |

リクエストボディ（JSON形式）:

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

### 3. 動作確認

H2のコンソールから下記SQLを実行し、レコードが1件取得できることを確認する。

```sql
SELECT * FROM PROJECT WHERE PROJECT_NAME = 'プロジェクト９９９';
```

<details>
<summary>keywords</summary>

X-Message-Id, Content-Type, POST, ProjectSaveAction, HTTPメッセージング動作確認, リクエストヘッダ, リクエストボディ

</details>
