# HTTP同期応答型メッセージ受信処理

## 電文受信時の処理

業務Actionの実装は、MOMによるメッセージング処理と同様の実装でHTTPメッセージングを実現できる。

**処理フロー**:
1. 要求電文を精査しEntityへ変換する
2. Entityを使用して要求電文の内容をデータベースに登録する
3. 応答電文を作成し返却する

**クラス**: `MessagingAction` を継承し、`onReceive(RequestMessage request, ExecutionContext context): ResponseMessage` をオーバーライドする。

```java
@Override
protected ResponseMessage onReceive(RequestMessage request,
                                    ExecutionContext context) {
    // 要求電文を精査しEntityに変換する
    RM11AC0102RequestForm reqForm = RM11AC0102RequestForm.validate(request.getParamMap(), "insert");
    UserInfoTempEntity entity = reqForm.getUserInfoTempEntity();

    // Entityをデータベースに登録する
    String userInfoId = registerRecord(entity);

    // 応答電文を作成して返却する
    RM11AC0102ResponseForm resForm = new RM11AC0102ResponseForm();
    resForm.setDataKbn("0");
    resForm.setUserInfoId(userInfoId);

    return request.reply()
                  .setStatusCodeHeader("200")
                  .addRecord(resForm);
}
```

<details>
<summary>keywords</summary>

MessagingAction, RequestMessage, ExecutionContext, ResponseMessage, RM11AC0102Action, RM11AC0102RequestForm, RM11AC0102ResponseForm, UserInfoTempEntity, onReceive, HTTP同期応答型メッセージ受信, 電文受信処理, MOMメッセージング

</details>

## エラー時の処理

`onError(Throwable e, RequestMessage request, ExecutionContext context): ResponseMessage` をオーバーライドして、例外の種類に応じた応答電文を返す。

**処理結果コード/障害コード仕様**:

| 終了コード | 障害コード | 原因 |
|---|---|---|
| 200 | (空白) | 正常終了 |
| 400 | NR11AC4001 | 要求電文のデータレコード部項目精査エラー |
| 500 | NR11AC5000 | その他の意図しないエラーにより業務処理が失敗した場合 |

> **注意**: 要求電文データレコード部レイアウト不正の場合、FWでエラー(ステータスコード400)となるため、本処理まで到達しない。

```java
@Override
protected ResponseMessage onError(Throwable e,
                                  RequestMessage request,
                                  ExecutionContext context) {
    String statusCode = "500";
    String failureCode = "NR11AC5000";

    // 要求電文のデータレコード精査エラーが発生した場合
    if (e instanceof ApplicationException) {
        statusCode = "400";
        failureCode = "NR11AC4001";
    }

    RM11AC0102ResponseForm resForm = new RM11AC0102ResponseForm();
    resForm.setDataKbn("0");
    resForm.setFailureCode(failureCode);

    return request.reply()
                  .setStatusCodeHeader(statusCode)
                  .addRecord(resForm);
}
```

<details>
<summary>keywords</summary>

ApplicationException, RM11AC0102ResponseForm, onError, Throwable, NR11AC4001, NR11AC5000, 障害コード, ステータスコード, エラー応答電文, MessagingAction

</details>
