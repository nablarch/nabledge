# 同期応答型メッセージ受信処理

## 電文受信時の処理

**クラス**: `MessagingAction`（継承クラス例: `RM11AC0101Action`）

`onReceive` メソッドで電文受信時の処理を実装する。

処理フロー:
1. 要求電文を精査しEntityへ変換する（`M11AC01Form.validate` を使用）
2. Entityを使用してデータベースに登録する
3. 応答電文を作成し返却する

![ユーザ登録メッセージ処理フロー](../../../knowledge/guide/mom-messaging/assets/mom-messaging-03_userQueryMessageAction/userRegisterMessage.png)

```java
public class RM11AC0101Action extends MessagingAction {
    @Override
    protected ResponseMessage onReceive(RequestMessage request, ExecutionContext context) {
        M11AC01Form form = M11AC01Form.validate(request.getParamMap(), "insert");
        UserInfoTempEntity entity = form.getUserInfoTempEntity();
        String userInfoId = registerRecord(entity);

        Map<String, Object> resultRecord = new HashMap<String, Object>();
        resultRecord.put("dataKbn",    "0");
        resultRecord.put("userInfoId", userInfoId);

        return request.reply()
                      .setStatusCodeHeader("200")
                      .addRecord(resultRecord);
    }
}
```

<details>
<summary>keywords</summary>

MessagingAction, RequestMessage, ExecutionContext, ResponseMessage, M11AC01Form, UserInfoTempEntity, onReceive, 同期応答型メッセージ受信, 電文受信処理, 応答電文作成, Entityへの変換

</details>

## エラー時の処理

`onError` メソッドでエラー時の応答電文を作成・返却する。例外の種別によってステータスコードと障害コードを切り替える。

| No | 終了コード | 障害コード | 原因 |
|---|---|---|---|
| 1 | 200 | （空白） | 正常終了 |
| 2 | 400 | NR11AA4001 | 要求電文のデータレコード部項目精査エラー |
| 3 | 500 | NR11AA5001 | 要求電文のデータレコード部レイアウト不正 |
| 4 | 500 | NR11AA5000 | その他の意図しないエラー |

例外処理の分岐:
- `InvalidDataFormatException` → ステータスコード `500`、障害コード `NR11AC5001`
- `ApplicationException` → ステータスコード `400`、障害コード `NR11AC4001`
- その他 → ステータスコード `500`、障害コード `NR11AC5000`

```java
@Override
protected ResponseMessage onError(Throwable e, RequestMessage request, ExecutionContext context) {
    String statusCode = "500";
    String failureCode = "NR11AC5000";

    if (e instanceof InvalidDataFormatException) {
        statusCode = "500";
        failureCode = "NR11AC5001";
    }
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

InvalidDataFormatException, ApplicationException, onError, エラー応答, ステータスコード, 障害コード, 例外ハンドリング, MessagingAction

</details>
