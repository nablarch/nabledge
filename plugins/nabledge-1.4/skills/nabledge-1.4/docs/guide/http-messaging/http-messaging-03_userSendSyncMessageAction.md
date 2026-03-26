# HTTP同期応答メッセージ送信処理

## 

業務ActionをMOMによるメッセージング処理と同様の実装でHTTPメッセージングを実現できる。

![HTTP同期応答メッセージ送信処理フロー](../../../knowledge/guide/http-messaging/assets/http-messaging-03_userSendSyncMessageAction/userSendSyncMessage.png)

<details>
<summary>keywords</summary>

HTTP同期応答メッセージ送信, HTTPメッセージング実装, MOMメッセージング, 業務Action

</details>

## アプリケーションプログラマが実装する成果物

アプリケーションプログラマが作成する成果物:

1. 要求電文および応答電文のフォーマット定義ファイル
2. 要求電文および応答電文に対応したFormクラス
3. HTTP同期応答メッセージ送信処理を行うActionクラス
4. 接続先の通信規約に沿った共通的なエラー処理を行うSyncMessagingEventHookクラス

<details>
<summary>keywords</summary>

フォーマット定義ファイル, Formクラス, Actionクラス, SyncMessagingEventHook, アプリケーションプログラマ成果物

</details>

## メッセージングプロバイダ定義ファイル

送信先の設定はメッセージングプロバイダ定義により設定される。

```bash
messageSender.RM11AC0202.httpMethod=POST
messageSender.RM11AC0202.messageSenderClient=defaultMessageSenderClient
messageSender.RM11AC0202.uri=http://localhost:8888/msgaction/ss11AC/RM11AC0102
messageSender.RM11AC0202.httpMessageIdGeneratorComponentName=defaultHttpMessageIdGenerator
messageSender.RM11AC0202.syncMessagingEventHookNames=defaultSyncMessagingEventHook
```

<details>
<summary>keywords</summary>

MessageSender設定, httpMethod, messageSenderClient, syncMessagingEventHookNames, uri, httpMessageIdGeneratorComponentName

</details>

## フォーマット定義ファイル

フォーマット定義ファイルの配置場所と拡張子はFilePathSettingのコンポーネント定義で設定される（通常はアーキテクトが設定）。

```xml
<component name="filePathSetting" class="nablarch.core.util.FilePathSetting" autowireType="None">
  <property name="basePathSettings">
    <map>
      <entry key="format" value="classpath:web/format" />
    </map>
  </property>
  <property name="fileExtensions">
    <map>
      <entry key="format" value="fmt" />
    </map>
  </property>
</property>
```

**命名規約**:
- 要求電文: リクエストID + `_SEND` (例: `RM11AC0202_SEND.fmt`)
- 応答電文: リクエストID + `_RECEIVE` (例: `RM11AC0202_RECEIVE.fmt`)

<details>
<summary>keywords</summary>

FilePathSetting, フォーマット定義ファイル命名規約, SEND電文, RECEIVE電文, フォーマット定義ファイル配置, fileExtensions, basePathSettings

</details>

## 要求電文のフォーマット定義ファイル

ファイルパス: `web/format/RM11AC0202_SEND.fmt`

```
file-type:        "XML"
text-encoding:    "UTF-8"

[request]
1  dataKbn                  X
2  loginId                  X
3  kanjiName                XN
4  kanaName                 N
5  mailAddress              X
6  extensionNumberBuilding  X
7  extensionNumberPersonal  X
8  mobilePhoneNumber[0..3]  OB
9  _nbctlhdr[0..1]          OB
[mobilePhoneNumber]
1  areaCode[0..1]   X
2  cityCode[0..1]   X
3  sbscrCode[0..1]  X
[_nbctlhdr]
1  userId[0..1]     X
2  resendFlag[0..1] X9  0
```

<details>
<summary>keywords</summary>

RM11AC0202_SEND.fmt, XML形式, UTF-8, request, mobilePhoneNumber, _nbctlhdr, resendFlag, dataKbn, loginId, kanjiName

</details>

## 応答電文のフォーマット定義ファイル

ファイルパス: `web/format/RM11AC0202_RECEIVE.fmt`

```
file-type:        "XML"
text-encoding:    "UTF-8"

[response]
1  failureCode[0..1]    X
2  userInfoId[0..1]     X
3  dataKbn              X
4  option[1..5]         OB
5  _nbctlhdr[0..1]      OB
[option]
1  contactAddress[0..1] X
[_nbctlhdr]
1  statusCode X9
```

<details>
<summary>keywords</summary>

RM11AC0202_RECEIVE.fmt, XML形式, UTF-8, response, option, statusCode, failureCode, userInfoId

</details>

## Formクラスの作成

自動生成されたFormBaseクラスを継承し、データレイアウトに対応したFormクラスを作成する。Formクラスには、精査処理や子階層オブジェクトに対応するプロパティの追加を行う。

> **注意**: データ形式が階層型の場合、子階層オブジェクトに対応するプロパティはFormBaseに出力されない。Formクラスでプロパティを定義すること。

<details>
<summary>keywords</summary>

FormBase継承, 子階層オブジェクト, 自動生成FormBase, 精査処理, プロパティ追加

</details>

## Formの実装方法

開発者は、自動生成したFormBaseクラスを継承してFormクラスを作成する。

**子階層オブジェクトを持たないForm**:
```java
public class RM11AC0202OptionForm extends RM11AC0202OptionFormBase {
    public RM11AC0202OptionForm() {}

    public RM11AC0202OptionForm(Map<String, Object> params) {
        super(params);
    }

    @ValidateFor("sendHttpUser")
    public static void validateForSend(
            ValidationContext<RM11AC0202OptionForm> context) {
        ValidationUtil.validate(context, new String[] {"contactAddress"});
    }
}
```

**子階層オブジェクトを持つForm**:
```java
public class RM11AC0202ResponseForm extends RM11AC0202ResponseFormBase {
    private static final long serialVersionUID = 1L;
    private RM11AC0202OptionForm[] option;
    private Integer optionSize;

    public RM11AC0202ResponseForm(Map<String, Object> data) {
        super(data);
        option = (RM11AC0202OptionForm[]) data.get("option");
    }
}
```

<details>
<summary>keywords</summary>

RM11AC0202OptionForm, RM11AC0202ResponseForm, RM11AC0202OptionFormBase, RM11AC0202ResponseFormBase, ValidationContext, ValidationUtil, @ValidateFor, validateForSend

</details>

## HTTP同期応答メッセージ送信処理を行うActionクラス

**処理フロー**:
1. リクエストを精査しFormへ変換
2. Formに要求電文のデータを設定
3. MessageSenderでメッセージを送信
4. 応答電文のSyncMessageオブジェクトからデータを取得

```java
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(path = "forward://RW11AC0201")
public HttpResponse doRW11AC0206(HttpRequest req, ExecutionContext ctx) {
    W11AC02Form input = validateForHttpSendUser(req);
    RM11AC0202RequestForm requestForm = getRequestForm(input);
    SyncMessage responseMessage = MessageSender.sendSync(
        new SyncMessage("RM11AC0202").addDataRecord(requestForm));
    Map<String, Object> resp = responseMessage.getDataRecord();
    W11AC02ResponseForm respForm = W11AC02ResponseForm.validate(resp, "sendHttpUser");
    ctx.setRequestScopedVar("11AC_W11AC03", respForm);
    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

<details>
<summary>keywords</summary>

doRW11AC0206, MessageSender.sendSync, SyncMessage, W11AC02Form, @OnError, @OnDoubleSubmission, ApplicationException, W11AC02ResponseForm, RM11AC0202RequestForm

</details>

## メッセージ送信前後処理を行うクラス

対向システム側のエラーは一律システムエラーとして扱う。

- **送信前**: 処理なし
- **送信後**: ステータスコード200以外の場合はHttpMessagingExceptionをスローしシステムエラーとする
- **送信中エラー (`onError`)**: `true`を返した場合は処理継続（次のSyncMessagingEventHookを呼ぶ。次がない場合はMessageSender#sendSyncの戻り値として引数responseMessageの値を返す）。`false`を返した場合はメソッド終了後に引数eをthrowする。サンプルでは接続タイムアウト等のシステム例外扱いとするためハンドリングせずfalseを返す。

```java
@Override
public void beforeSend(MessageSenderSettings settings, SyncMessage requestMessage) {
    // 何もしない
}

@Override
public void afterSend(MessageSenderSettings settings, SyncMessage requestMessage,
        SyncMessage responseMessage) {
    String statusCode = (String) responseMessage.getHeaderRecord()
        .get(HttpMessagingClient.SYNCMESSAGE_STATUS_CODE);
    if (!"200".equals(statusCode)) {
        throw new HttpMessagingException();
    }
}

@Override
public boolean onError(RuntimeException e, boolean hasNext,
        MessageSenderSettings settings, SyncMessage requestMessage,
        SyncMessage responseMessage) {
    return false;
}
```

<details>
<summary>keywords</summary>

SyncMessagingEventHook, beforeSend, afterSend, onError, ステータスコードチェック, HttpMessagingException, HttpMessagingClient.SYNCMESSAGE_STATUS_CODE, MessageSenderSettings

</details>
