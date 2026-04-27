# HTTP同期応答型メッセージ受信処理

[ユーザ情報登録サービス](../../guide/http-messaging/http-messaging-01-userResisterMessageSpec.md) を例に、HTTP同期応答型メッセージ受信処理の実装方法を説明する。

業務Actionの実装内容は、MOMによるメッセージング処理と同様の実装にて、HTTPメッセージングを実現できる。

![userRegisterMessage.png](../../../knowledge/assets/http-messaging-03-userQueryMessageAction/userRegisterMessage.png)

## 電文受信時の処理

サンプルでは、電文受信時に以下の処理を行う。

① 要求電文を精査しEntityへ変換する。
② Entityを使用して要求電文の内容をデータベースに登録する。
③ 応答電文を作成し返却する。

```java
public class RM11AC0102Action extends MessagingAction {

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
        RM11AC0102RequestForm reqForm = RM11AC0102RequestForm.validate(request.getParamMap(), "insert");
        UserInfoTempEntity entity = reqForm.getUserInfoTempEntity();

        // 【説明】Entityをデータベースに登録する
        String userInfoId = registerRecord(entity);

        // 【説明】応答電文を作成する
        RM11AC0102ResponseForm resForm = new RM11AC0102ResponseForm();
        resForm.setDataKbn("0");
        resForm.setUserInfoId(userInfoId);

        // 【説明】応答電文を返却する
        return request.reply()
                      .setStatusCodeHeader("200")
                      .addRecord(resForm);
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
 * 2    400             NR11AC4001      要求電文のデータレコード部項目精査エラー
 * 3    500             NR11AC5000      その他の意図しないエラーにより業務処理が失敗した場合。
 * ==== =============== =============== ===================================================
 * 要求電文データレコード部レイアウト不正の場合、FWでエラー(ステータスコード400)となるため、本処理まで到達しない。
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

    // 【説明】 要求電文のデータレコード精査エラーが発生した場合
    if (e instanceof ApplicationException) {
        statusCode = "400";
        failureCode = "NR11AC4001";
    }

    // 【説明】 応答電文（エラー）を作成する
    RM11AC0102ResponseForm resForm = new RM11AC0102ResponseForm();
    resForm.setDataKbn("0");
    resForm.setFailureCode(failureCode);

    // 【説明】 応答電文（エラー）を返却する
    return request.reply()
                  .setStatusCodeHeader(statusCode)
                  .addRecord(resForm);
}
```
