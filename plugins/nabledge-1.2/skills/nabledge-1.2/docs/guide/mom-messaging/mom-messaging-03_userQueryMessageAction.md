# 同期応答型メッセージ受信処理

## 電文受信時の処理

**クラス**: `MessagingAction`, `RequestMessage`, `ResponseMessage`, `ExecutionContext`, `ValidationContext`, `ValidationUtil`, `ApplicationException`

電文受信時の処理フロー:
1. 要求電文を精査しEntityへ変換する
2. Entityを使用して要求電文の内容をデータベースに登録する
3. 応答電文を作成し返却する

精査エラーとなった場合は、処理をロールバックしてエラー応答を送信する。

```java
public class RM11AC0101Action extends MessagingAction {
    @Override
    protected ResponseMessage onReceive(RequestMessage request, ExecutionContext context) {
        UserInfoTempEntity entity = validate(request.getParamMap());
        String userInfoId = registerRecord(entity);
        Map<String, Object> resultRecord = new HashMap<String, Object>();
        resultRecord.put("dataKbn",    "0");
        resultRecord.put("userInfoId", userInfoId);
        return request.reply()
                      .setStatusCodeHeader("200")
                      .addRecord(resultRecord);
    }

    private UserInfoTempEntity validate(Map<String, Object> userRecord) {
        ValidationContext<UserInfoTempEntity> validationContext =
            ValidationUtil.validateAndConvertRequest(
                UserInfoTempEntity.class, userRecord, "validateRegister");
        if (!validationContext.isValid()) {
            throw new ApplicationException(validationContext.getMessages());
        }
        return validationContext.createObject();
    }
}
```

<details>
<summary>keywords</summary>

MessagingAction, RequestMessage, ResponseMessage, ExecutionContext, ValidationContext, ValidationUtil, ApplicationException, UserInfoTempEntity, RM11AC0101Action, 同期応答型メッセージ受信, 電文受信処理, バリデーション, 応答電文作成, onReceive

</details>

## エラー時の処理

エラー種別ごとの終了コード・障害コード:

| No | 終了コード | 障害コード | 原因 |
|---|---|---|---|
| 1 | 200 | (空白) | 正常終了 |
| 2 | 400 | NR11AA4001 | 要求電文のデータレコード部項目精査エラー |
| 3 | 500 | NR11AA5001 | 要求電文のデータレコード部レイアウト不正 |
| 4 | 500 | NR11AA5000 | その他の意図しないエラーにより業務処理が失敗した場合 |

```java
@Override
protected ResponseMessage onError(Throwable e, RequestMessage request, ExecutionContext context) {
    String statusCode = "500";
    String failureCode = "NR11AC5000";
    // 要求電文のレイアウトが不正だった場合
    if (e instanceof InvalidDataFormatException) {
        statusCode = "500";
        failureCode = "NR11AC5001";
    }
    // 要求電文のデータレコード精査エラーが発生した場合
    if (e instanceof ApplicationException) {
        statusCode = "400";
        failureCode = "NR11AC4001";
    }
    Map<String, Object> resultRecord = new HashMap<String, Object>();
    resultRecord.put("dataKbn",    0);
    resultRecord.put("failureCode", failureCode);
    return request.reply()
                  .setStatusCodeHeader(statusCode)
                  .addRecord(resultRecord);
}
```

<details>
<summary>keywords</summary>

ResponseMessage, RequestMessage, ExecutionContext, InvalidDataFormatException, ApplicationException, onError, 終了コード, 障害コード, エラー応答電文, エラーハンドリング

</details>
