# HTTP同期応答メッセージ送信処理

[ユーザ情報登録サービス](../../guide/http-messaging/http-messaging-01-userSendSyncMessageSpec.md) を例に、HTTP同期応答メッセージ送信処理の実装方法を説明する。

業務Actionの実装内容は、MOMによるメッセージング処理と同様の実装にて、HTTPメッセージングを実現できる。

![userSendSyncMessage.png](../../../knowledge/assets/http-messaging-03-userSendSyncMessageAction/userSendSyncMessage.png)

## アプリケーションプログラマが実装する成果物

アプリケーションプログラマが作成する成果物は以下のとおりである。

* 要求電文および応答電文のフォーマット定義ファイル
* 要求電文および応答電文に対応したFormクラス
* HTTP同期応答メッセージ送信処理を行うActionクラス
* 接続先の通信規約に沿った共通的なエラー処理を行うSyncMessagingEventHookクラス

## メッセージングプロバイダ定義ファイル

送信先の設定は、下記設定例のようにメッセージングプロバイダ定義により設定される。

```bash
#===============================================================================
# MessageSenderの個別設定
#===============================================================================

# RM11AC0202
messageSender.RM11AC0202.httpMethod=POST
messageSender.RM11AC0202.messageSenderClient=defaultMessageSenderClient
messageSender.RM11AC0202.uri=http://localhost:8888/msgaction/ss11AC/RM11AC0102
messageSender.RM11AC0202.httpMessageIdGeneratorComponentName=defaultHttpMessageIdGenerator
messageSender.RM11AC0202.syncMessagingEventHookNames=defaultSyncMessagingEventHook
```

## フォーマット定義ファイル

フォーマット定義ファイルの配置場所と拡張子は、下記設定例のように、FilePathSettingクラスのコンポーネント定義により設定される。
通常、この設定値はアーキテクトが設定するものでありアプリケーションプログラマが設定する必要はない。

```xml
<component name="filePathSetting"
         class="nablarch.core.util.FilePathSetting" autowireType="None">
   <property name="basePathSettings">
     <map>
       <!-- 実際のサンプルでは、以下のvalue属性の部分はプレースホルダになっているが、
                                  ここでは説明を分かりやすくするため、直接パスをvalue属性に記載する。-->
       <entry key="format" value="classpath:web/format" />
     </map>
   </property>
   <property name="fileExtensions">
     <map>
       <!-- 拡張子を設定する -->
       <entry key="format" value="fmt" />
     </map>
   </property>
</property>
```

フォーマット定義ファイルの名前は以下の命名規約に従うこと。

* 要求電文: リクエストID + “_SEND”
* 応答電文: リクエストID + “_RECEIVE”

参考として、サンプルで使用している要求電文と応答電文のフォーマット定義ファイルを以下に示す。

### 要求電文のフォーマット定義ファイル

ファイルパス： web/format/RM11AC0202_SEND.fmt

```bash
#-------------------------------------------------------------------------------
# ユーザ情報登録電文の業務データ部レイアウト定義
#-------------------------------------------------------------------------------
file-type:        "XML"   # XMLファイル
text-encoding:    "UTF-8" # 文字列型フィールドの文字エンコーディング

[request]                                           #リクエスト
1                    dataKbn                  X     #データ区分
2                    loginId                  X     #ログインID
3                    kanjiName                XN    #漢字氏名
4                    kanaName                 N     #カナ氏名
5                    mailAddress              X     #メールアドレス
6                    extensionNumberBuilding  X     #内線番号(ビル番号)
7                    extensionNumberPersonal  X     #内線番号(個人番号)
8                    mobilePhoneNumber[0..3]  OB    #携帯電話番号
9                    _nbctlhdr[0..1]          OB    #フレームワーク制御項目(自動追加)
[mobilePhoneNumber]                                 #携帯電話番号
1                    areaCode[0..1]           X     #携帯電話番号(市外)
2                    cityCode[0..1]           X     #携帯電話番号(市内)
3                    sbscrCode[0..1]          X     #携帯電話番号(加入)
[_nbctlhdr]                                         #フレームワーク制御項目(自動追加)
1                    userId[0..1]             X     #ユーザID
2                    resendFlag[0..1]         X9  0 #再送要求フラグ
```

### 応答電文のフォーマット定義ファイル

ファイルパス： web/format/RM11AC0202_RECEIVE.fmt

```bash
#-------------------------------------------------------------------------------
# ユーザ情報登録応答電文の業務データ部フォーマット定義
#-------------------------------------------------------------------------------
file-type:        "XML"   # XMLファイル
text-encoding:    "UTF-8" # 文字列型フィールドの文字エンコーディング

[response]                                     #レスポンス
1                failureCode[0..1]     X       #障害事由コード
2                userInfoId[0..1]      X       #問い合わせID
3                dataKbn               X       #データ区分
4                option[1..5]          OB      #オプション項目
5                _nbctlhdr[0..1]       OB      #フレームワーク制御項目(自動追加)
[option]                                       #オプション項目
1                contactAddress[0..1]  X       #連絡先アドレス
[_nbctlhdr]                                    #フレームワーク制御項目(自動追加)
1                statusCode            X9      #ステータスコード
```

## Formクラスの作成

自動生成されたFormBaseクラスを継承し、データレイアウトに対応したFormクラスを作成する。
Formクラスには、精査処理や子階層オブジェクトに対応するプロパティの追加を行う。

> **Note:**
> データ形式が階層型の場合、子階層オブジェクトに対応するプロパティはFormBaseに出力されない。
> Formクラスでプロパティを定義すること。

### Formの実装方法

開発者は、自動生成したFormBaseクラスを継承してFormクラスを作成する。

* 子階層のオブジェクトを持たないForm

```java
public class RM11AC0202OptionForm extends RM11AC0202OptionFormBase {

    // 精査処理、コンストラクタを追加

    /**
     * デフォルトコンストラクタ
     */
    public RM11AC0202OptionForm() {
    }

    /**
     * Mapを引数にとるコンストラクタ。
     * @param params 項目名をキーとし、項目値を値とするMap。
     */
    public RM11AC0202OptionForm(Map<String, Object> params) {
        super(params);
    }

    /**
     * メッセージ受信によるユーザ登録時に実施するバリデーション
     *
     * @param context バリデーションの実行に必要なコンテキスト
     */
    @ValidateFor("sendHttpUser")
    public static void validateForSend(
            ValidationContext<RM11AC0202OptionForm> context) {
        ValidationUtil.validate(context, new String[] {"contactAddress"});
    }
}
```

* 子階層のオブジェクトを持つForm

```java
public class RM11AC0202ResponseForm extends RM11AC0202ResponseFormBase {

    /**
     * シリアルバージョンID
     */
    private static final long serialVersionUID = 1L;

    // 子階層オブジェクトに対応するプロパティを追加。合わせてアクセッサなども追加。
    /**
     * オプション項目
     */
    private RM11AC0202OptionForm[] option;

    /**
     * オプション項目のサイズ
     */
    private Integer optionSize;

    /**
     * 検査対象フィールド
     */
    private static final String[] TARGET_FIELDS = new String[] { "dataKbn",
        "userInfoId", "failureCode", "option", "optionSize" };

    /**
     * コンストラクタ
     *
     * @param data データ
     */
    public RM11AC0202ResponseForm(Map<String, Object> data) {
        super(data);
        option = (RM11AC0202OptionForm[]) data.get("option");
    }

    // アクセッサおよび精査処理の追加は画面と同様なので省略
}
```

## HTTP同期応答メッセージ送信処理を行うActionクラス

サンプルでは、HTTP同期応答メッセージ送信時に以下の処理を行う。

① リクエストを精査しFormへ変換する。
② Formに要求電文のデータを設定する。
③ MessageSenderでメッセージを送信する。
④ 応答電文のSyncMessageオブジェクトからデータを取得する。

```java
/**
 * ユーザ情報登録確認画面の「Httpメッセージ送信」イベントの処理を行う。
 *
 * @param req リクエストコンテキスト
 * @param ctx HTTPリクエストの処理に関連するサーバ側の情報
 * @return HTTPレスポンス
 */
@OnError(type = ApplicationException.class, path = "forward://RW11AC0201")
@OnDoubleSubmission(path = "forward://RW11AC0201")
public HttpResponse doRW11AC0206(HttpRequest req, ExecutionContext ctx) {

    // ①画面入力チェック、入力値の取得
    W11AC02Form input = validateForHttpSendUser(req);

    // ②要求電文の作成
    RM11AC0202RequestForm requestForm = getRequestForm(input);

    // ③要求電文の送信
    SyncMessage responseMessage
        = MessageSender.sendSync(new SyncMessage(
            "RM11AC0202").addDataRecord(requestForm));

    // レスポンスのMap取得
    Map<String, Object> resp = responseMessage.getDataRecord();
    // ④レスポンスの精査、Map→Form変換
    W11AC02ResponseForm respForm = W11AC02ResponseForm.validate(resp,
            "sendHttpUser");
    // 引き継ぎ項目を格納
    ctx.setRequestScopedVar("11AC_W11AC03", respForm);

    return new HttpResponse("/ss11AC/W11AC0203.jsp");
}
```

## メッセージ送信前後処理を行うクラス

サンプルでは、対向システムへ送信するデータは、アクション側で事前に精査が可能であり、
精査を通過したデータについては原則として処理が正常終了するものとしている。

したがって、対向システム側でエラーが発生した場合は一律システムエラーとして扱うものとしている。

【送信前】

* 処理なし。

【送信後】

* ステータスコード200以外の場合はシステムエラーを返却する。

【送信中にエラー発生】

* ハンドリングを行わずシステムエラー扱いとする。

```java
/**
 * メッセージ送信前に呼ばれる処理。
 *
 * @param settings メッセージ送信設定
 * @param requestMessage 送信対象メッセージ
 */
@Override
public void beforeSend(MessageSenderSettings settings, SyncMessage requestMessage) {
    //何もしない
    return;
}

/**
 * メッセージ送信後、レスポンスを受け取った後に呼ばれる処理。<br>
 * <p>
 * ステータスコードをチェックして、正常終了であるか、業務エラーであるかを判定します。
 * </p>
 * @param settings メッセージ送信設定
 * @param requestMessage リクエストメッセージ
 * @param responseMessage レスポンスメッセージ
 */
@Override
public void afterSend(MessageSenderSettings settings, SyncMessage requestMessage,
        SyncMessage responseMessage) {
    String statusCode = (String) responseMessage.getHeaderRecord().get(HttpMessagingClient.SYNCMESSAGE_STATUS_CODE);
    if (!"200".equals(statusCode)) {
        // ステータスコード200以外の場合はシステムエラーとして扱う。
        throw new HttpMessagingException();
    }
}

/**
 * メッセージ送信中のエラー発生時に呼ばれる処理。<br>
 * <p>
 * ステータスコードをチェックして、業務エラーであるか、システム例外であるかを判定します。
 * </p>
 *
 * @param e 発生した例外
 * @param hasNext 次に呼び出される{@link SyncMessagingEventHook}が存在する場合にtrue
 * @param settings メッセージ送信設定
 * @param requestMessage リクエストメッセージ
 * @param responseMessage レスポンスメッセージとして使用するオブジェクト。本オブジェクトは最終的に MessageSender#sendSync(SyncMessage)の戻り値として返却される。
 * @return trueの場合は処理継続。次の{@link SyncMessagingEventHook#onError(RuntimeException, MessageSenderSettings, SyncMessage)}を呼ぶ。<br />
 * 次がない場合は、MessageSender#sendSync(SyncMessage)の戻り値として、引数responseMessageの値を返す。<br />
 * falseの場合は、本メソッド終了後に引数eをthrowする
 */
@Override
public boolean onError(RuntimeException e,
        boolean hasNext, MessageSenderSettings settings, SyncMessage requestMessage, SyncMessage responseMessage) {

    //接続タイムアウト等、システム例外扱いとするためハンドリングを行わない。
    return false;

}
```
