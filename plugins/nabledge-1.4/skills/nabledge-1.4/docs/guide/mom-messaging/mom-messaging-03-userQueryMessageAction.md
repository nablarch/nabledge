# 同期応答型メッセージ受信処理

[ユーザ情報登録サービス](../../guide/mom-messaging/mom-messaging-01-userResisterMessageSpec.md) を例に、同期応答型メッセージ受信処理の実装方法を説明する。

![userRegisterMessage.png](../../../knowledge/assets/mom-messaging-03-userQueryMessageAction/userRegisterMessage.png)

## 電文受信時の処理

サンプルでは、電文受信時に以下の処理を行う。

① 要求電文を精査しEntityへ変換する。
② Entity使用して要求電文の内容をデータベースに登録する。
③ 応答電文を作成し返却する。

```java
public class RM11AC0101Action extends MessagingAction {

    /**
     * データ部に格納された登録ユーザレコードの項目精査を行った後、
     * データベースに登録する。
     *
     * 精査エラーとなった場合は、処理をロールバックしてエラー応答を送信する。
     *
     * @param request 要求電文オブジェクト
     * @param context 実行コンテキスト
     * @return 応答電文オブジェクト
     */
    @Override
    protected ResponseMessage onReceive(RequestMessage   request,
                                        ExecutionContext context) {

        // 【説明】要求電文を精査しEntityに変換する
        M11AC01Form form = M11AC01Form.validate(request.getParamMap(), "insert");
        UserInfoTempEntity entity = form.getUserInfoTempEntity();

        // 【説明】Entityをデータベースに登録する
        String userInfoId = registerRecord(entity);

        // 【説明】応答電文を作成する
        Map<String, Object> resultRecord = new HashMap<String, Object>();
        resultRecord.put("dataKbn",    "0");
        resultRecord.put("userInfoId", userInfoId);

        // 【説明】応答電文を返却する
        return request.reply()
                      .setStatusCodeHeader("200")
                      .addRecord(resultRecord);
    }
```

## エラー時の処理

エラー時の処理では、発生したエラーに応じて応答電文を作成し返却している。

```java
/**
 * 業務処理がエラー終了した場合に送信する応答電文の内容を設定する。
 * <p/>
 * <b>処理結果コード/障害コード仕様</b>
 * <pre>
 * ==== =============== =============== ==================================================
 * No   終了コード      障害コード      原因
 * ==== =============== =============== ==================================================
 * 1    200             (空白)          正常終了
 * 2    400             NR11AA4001      要求電文のデータレコード部項目精査エラー
 * 3    500             NR11AA5001      要求電文のデータレコード部レイアウト不正
 * 4    500             NR11AA5000      その他の意図しないエラーにより業務処理が失敗した場合。
 * ==== =============== =============== ===================================================
 * </pre>
 * @param e       発生した例外オブジェクト
 * @param request 要求電文オブジェクト
 * @param context 実行コンテキスト
 * @return 応答電文オブジェクト
 */
@Override
protected ResponseMessage onError(Throwable        e,
                                  RequestMessage   request,
                                  ExecutionContext context) {

    String statusCode = "500";
    String failureCode = "NR11AC5000";

    // 【説明】 要求電文のレイアウトが不正だった場合
    if (e instanceof InvalidDataFormatException) {
        statusCode = "500";
        failureCode = "NR11AC5001";
    }

    // 【説明】 要求電文のデータレコード精査エラーが発生した場合
    if (e instanceof ApplicationException) {
        statusCode = "400";
        failureCode = "NR11AC4001";
    }

    // 【説明】 応答電文（エラー）を作成する
    Map<String, Object> resultRecord = new HashMap<String, Object>();
    resultRecord.put("dataKbn",    0);
    resultRecord.put("failureCode", failureCode);

    // 【説明】 応答電文（エラー）を返却する
    return request.reply()
                  .setStatusCodeHeader(statusCode)
                  .addRecord(resultRecord);
}
```
