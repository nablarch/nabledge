# 応答不要メッセージ受信処理

[ユーザ登録情報電文受信処理](../../guide/mom-messaging/mom-messaging-01-userRegisterMessageReceiveSpec.md#userregistermessagereceivespec) を例に、応答不要メッセージ受信処理の実装方法を説明する。

![userRegisterMessageReceive.png](../../../knowledge/assets/mom-messaging-03-mqDelayedReceive/userRegisterMessageReceive.png)

## アプリケーション開発者が実装する成果物

[応答不要型メッセージ受信処理のアプリケーション構造](../../guide/mom-messaging/mom-messaging-04-explanation-delayed-receive-02-basic.md#messagedelayedreceivedesign) からわかるように、電文を受信するアクションはNablarchの一部として提供される。
このため、アプリケーション開発者は電文を受信テーブルに登録するために必要となる下記成果物のみを作成すれ良い。

* 電文のレイアウトを定義したフォーマット定義ファイル
* 電文を登録するテーブル(一時テーブル)の定義
* データベースへ電文を登録する際に使用するFormクラス
* データベースへ電文を登録するためのINSERT文が記述されたSQLファイル

## フォーマット定義ファイル

電文の業務電文部がどのようなレイアウトで構成されているかを表すフォーマット定義ファイルを作成する。

フォーマット定義ファイルは、外部インタフェース設計書を入力元として、
フォーマット定義ファイル自動生成ツールにより生成する。

参考として、サンプルで使用しているフォーマット定義ファイルを以下に示す。

```bash
#-------------------------------------------------------------------------------
# ユーザ登録情報電文のレイアウト
#-------------------------------------------------------------------------------
text-encoding:    "MS932" # 文字列型フィールドの文字エンコーディング
record-length:    420     # 各レコードの長さ
file-type:        "Fixed" # 固定長

[userData] # レコード名称
1   loginId                     X(20)       # ログインID
21  kanjiName                   N(100)      # 漢字氏名
121 kanaName                    N(100)      # カナ氏名
221 ?filler1                    X(50)       # 空白領域
271 mailAddress                 X(100)      # メールアドレス
371 extensionNumberBuilding     X(2)        # 内線番号（ビル番号）
373 extensionNumberPersonal     X(4)        # 内線番号（個人番号）
377 mobilePhoneNumberAreaCode   X(3)        # 携帯番号（市外）
380 mobilePhoneNumberCityCode   X(4)        # 携帯電話番号(市内)
384 mobilePhoneNumberSbscrCode  X(4)        # 携帯電話番号(加入)
388 ?filler2                    X(33)       # 空白領域
```

## 一時テーブルの定義

受信した電文は、電文の種類毎に専用の一時テーブルに保存する。
このため、一時テーブルを下記ルールに従い定義すること。

* 主キーは、電文を一意に識別するためのIDを格納するカラムとすること
  このカラムに格納する値は、Nablarchフレームワークで採番を行う。
  桁数は、個々のプロジェクトで異なるため方式設計などに従いテーブル定義を行うこと。
* テーブルの属性情報には、受信した電文の各項目に対応するカラムを定義する
* 各プロジェクトの方式に合わせて共通項目（登録ユーザIDや登録日時など)を定義する

### 実際のテーブル定義の例

参考として、サンプルアプリケーションで電文を保存する一時テーブルを以下に示す。

* 主キー

| カラム論理名 | 定義 |
|---|---|
| 受信電文連番 | CHAR(10) |

* 属性項目(電文の項目に対応したカラム)

| カラム論理名 | 定義 |
|---|---|
| ログインID | VARCHAR2(20) |
| 漢字名称 | NVARCHAR2(100) |
| カナ名称 | NVARCHAR2(100) |
| メールアドレス | VARCHAR2(100) |
| 内線番号(ビル番号) | VARCHAR2(2) |
| 内線番号(個人番号) | VARCHAR2(4) |
| 携帯電話番号(市外) | VARCHAR2(3) |
| 携帯電話番号(市内) | VARCHAR2(4) |
| 携帯電話番号(加入) | VARCHAR2(4) |

* 共通項目

| カラム論理名 | 定義 |
|---|---|
| 登録ユーザID | CHAR(10) |
| 登録日時 | TIMESTAMP |
| 更新ユーザID | CHAR(10) |
| 更新日時 | TIMESTAMP |
| 登録リクエストID | CHAR(10) |
| 登録実行時ID | CHAR(29) |

## Formクラス

Formクラスは、一時テーブルに電文を登録する際に使用する。
これは、Nablarchフレームワークのデータベース機能で提供されるオブジェクトのフィールド値をデータベースへ保存する機能を使用するために必要となるクラスである。
データベース機能の詳細は、  [オブジェクトのフィールドの値の登録機能(オブジェクト(Form)編)](../../guide/web-application/web-application-01-DbAccessSpec-Example.md#db-object-save-samole) を参照すること。

**Formクラスは、下記ルールに準拠すること**

* クラス名は、受信電文のリクエストID + "Form"であること
* 「String, nablarch.fw.messaging.RequestMessage」の2つの引数を持つコンストラクタを定義すること

  それぞれのパラメータの意味は以下の通り。

  * String  -> 受信電文連番
  * nablarch.fw.messaging.RequestMessage -> 受信電文
* Formクラスの配置パッケージは、下記設定例のようにAsyncMessageReceiveActionSettingsのformClassPackageプロパティに設定されたパッケージ名とすること

  ※この設定値は、アーキテクトなどが設定するものであり個々の開発者が設定する必要はない。

  ```xml
  <!-- メッセージ受信アクション用の設定 -->
  <component name="asyncMessageReceiveActionSettings"
             class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
    <property name="formClassPackage" value="nablarch.sample.messaging.form" />
  </component>
  ```

参考として、サンプルで使用しているFormクラスを以下に示す。

```java
package nablarch.sample.messaging.form;

// 中略

/**
 * ユーザ情報登録電文をユーザ情報電文受信テーブルに保存するためのフォームクラス。
 *
 * @author hisaaki sioiri
 * @since 1.1
 */
public class RM11AC0201Form {

    /** 受信電文連番 */
    private String receivedMessageSequence;

    // フィールドの定義は省略

    /**
     * コンストラクタ。
     *
     * @param receivedMessageSequence 受信電文連番
     * @param message 受信電文
     */
    public RM11AC0201Form(String receivedMessageSequence, RequestMessage message) {
        // 受信電文連番をフィールドに設定する。
        this.receivedMessageSequence = receivedMessageSequence;

        // 電文に内容を各フィールドに設定する。
        // 電文のボディ部は、RequestMessage#getRecordOf(<レコード名>)で取得することが出来る。
        // レコード名は、フォーマット定義ファイルで設定したレコード名称を指定する。
        DataRecord data = message.getRecordOf("userData");
        loginId = data.getString("loginId");
        kanjiName = data.getString("kanjiName");
        kanaName = data.getString("kanaName");
        mailAddress = data.getString("mailAddress");
        extensionNumberBuilding = data.getString("extensionNumberBuilding");
        extensionNumberPersonal = data.getString("extensionNumberPersonal");
        mobilePhoneNumberAreaCode = data.getString("mobilePhoneNumberAreaCode");
        mobilePhoneNumberCityCode = data.getString("mobilePhoneNumberCityCode");
        mobilePhoneNumberSbscrCode = data.getString("mobilePhoneNumberSbscrCode");
    }
}
```

## SQLファイル

[一時テーブル](../../guide/mom-messaging/mom-messaging-03-mqDelayedReceive.md#message-save-table) に受信電文を保存するためのSQL文を記述したSQLファイルを用意する。

**SQLファイルは、下記ルールに準拠すること**

* SQLファイル名は、受信電文のリクエストID + ".sql"であること。
* SQL_IDは、「INSERT_MESSAGE」であること。
* SQLファイルの配置ディレクトリは、下記設定例のようにAsyncMessageReceiveActionSettingsのsqlFilePackageプロパティに設定されたディレクトリとすること。

  ※この設定値は、アーキテクトなどが設定するものであり個々の開発者が設定する必要はない。

```xml
<!-- メッセージ受信アクション用の設定 -->
<component name="asyncMessageReceiveActionSettings"
    class="nablarch.fw.messaging.action.AsyncMessageReceiveActionSettings">
  <!-- SQLファイルの配置ディレクトリ -->
  <property name="sqlFilePackage" value="nablarch.sample.messaging.sql" />
</component>
```

参考として、サンプルで使用しているSQLファイルを以下に示す。

```sql
--******************************************************************************
-- ユーザ情報メッセージをユーザ情報受信テーブルに登録するSQL
--******************************************************************************
INSERT_MESSAGE =
INSERT INTO USER_INFO_RECEIVE_MESSAGE (
    RECEIVED_MESSAGE_SEQUENCE,
    LOGIN_ID,
    KANJI_NAME,
    KANA_NAME,
    MAIL_ADDRESS,
    EXTENSION_NUMBER_BUILDING,
    EXTENSION_NUMBER_PERSONAL,
    MOBILE_PHONE_NUMBER_AREA_CODE,
    MOBILE_PHONE_NUMBER_CITY_CODE,
    MOBILE_PHONE_NUMBER_SBSCR_CODE,
    STATUS,
    INSERT_USER_ID,
    INSERT_DATE,
    INSERT_REQUEST_ID,
    INSERT_EXECUTION_ID,
    UPDATED_USER_ID,
    UPDATED_DATE
    )
    VALUES
    (
    :receivedMessageSequence,
    :loginId,
    :kanjiName,
    :kanaName,
    :mailAddress,
    :extensionNumberBuilding,
    :extensionNumberPersonal,
    :mobilePhoneNumberAreaCode,
    :mobilePhoneNumberCityCode,
    :mobilePhoneNumberSbscrCode,
    '0',
    :insertUserId,
    :insertDate,
    :insertRequestId,
    :updatedUserId,
    :updatedDate
    )
```
