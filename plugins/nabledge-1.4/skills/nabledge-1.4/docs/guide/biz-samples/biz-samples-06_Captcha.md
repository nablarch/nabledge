# CAPTCHA機能サンプル

## 提供パッケージ

本サンプルは、以下のパッケージで提供される。

**パッケージ**: `please.change.me.common.captcha`

<details>
<summary>keywords</summary>

please.change.me.common.captcha, 提供パッケージ, CAPTCHA

</details>

## 概要

CAPTCHA認証は応答者がコンピュータでないことを確認するための認証方式。本サンプルでは業務処理中に認証用画像を生成し、画像内の文字列をユーザに入力させて比較することで認証を行う。

> **重要**: Nablarchではセッションは原則ログイン後に生成されるため、一般的なCAPTCHAライブラリのセッション管理方式は使用できない。本サンプルではデータベース上の管理テーブルで識別キーとCAPTCHA文字列を管理する。

> **注意**: 管理テーブルはCAPTCHA情報生成のたびにレコードが蓄積されて肥大化するため、メンテナンスバッチの作成等を別途検討すること。

**使用ライブラリ**: [kaptcha](https://code.google.com/p/kaptcha/)

<details>
<summary>keywords</summary>

CAPTCHA認証, kaptcha, セッション管理, データベース管理テーブル, 識別キー管理, 認証方式

</details>

## 構成

## 処理フロー

**認証ページ表示時**
- 業務画面: CaptchaUtil#generateKeyで識別キーを取得
- 本サンプル: 識別キーを生成してDBにレコードを作成

**認証画像取得時**
- 業務画面: CaptchaGenerateActionへGETリクエストを発行。リクエストパラメータ名captchaKeyで識別キーを指定
- 本サンプル: 識別キーからCAPTCHA情報（画像および文字列）を生成してDBレコードを更新し、認証用画像を返却。識別キー不正時はHTTPステータス400＋空ボディを返却

> **重要**: リクエストパラメータ名captchaKeyは固定。変更する場合はソースコードを修正すること。

**認証アクション実行時**
- 業務画面: 入力文字列と識別キーをPOST。CaptchaUtil#authenticateで認証
- 本サンプル: 識別キーでDBからCAPTCHA情報を取得し、入力文字列と比較して結果を返却

## クラス構成

| クラス名 | 概要 |
|---|---|
| CaptchaGenerator | kaptchaを使用してCAPTCHA情報を生成 |
| CaptchaUtil | CaptchaGeneratorを使用してCAPTCHA情報生成および入力文字列との比較を行う |
| CaptchaGenerateAction | CAPTCHA情報を生成して返却するアクションクラス。識別キーでDBに保存 |
| Captcha | 生成したCAPTCHA情報を保持 |
| CaptchaDataManager | CAPTCHA情報のDB保存および読み込み |

## テーブル定義: CAPTCHA管理（CAPTCHA_MANAGE）

| 論理名 | 物理名 | Javaの型 | 制約 |
|---|---|---|---|
| 識別キー | CAPTCHA_KEY | java.lang.String | 主キー |
| CAPTCHA文字列 | CAPTCHA_TEXT | java.lang.String | |
| 生成日時 | GENERATE_DATE_TIME | java.sql.Timestamp | |

> **注意**: 本テーブルには必要な管理情報を追加するなど、要件を満たすようテーブル設計を行うこと。

<details>
<summary>keywords</summary>

CaptchaGenerator, CaptchaUtil, CaptchaGenerateAction, Captcha, CaptchaDataManager, CAPTCHA_MANAGE, CAPTCHA_KEY, CAPTCHA_TEXT, GENERATE_DATE_TIME, 処理フロー, クラス構成

</details>

## CaptchaUtilの使用方法

CaptchaUtilでは以下のユーティリティメソッドを実装している。

> **注意**: CaptchaUtilがリポジトリから取得するコンポーネント名はCaptchaGenerateActionの設定と一致させること。異なる場合はソースコードを修正すること。

| メソッド | 説明 |
|---|---|
| generateKey | 識別キーを生成してDBに保存し、識別キーを返却。識別キーの生成にはjava.util.UUID#randomUUIDを利用。重複する可能性は低く実用的に問題ないが、別の生成方法を利用したい場合はソースコードを修正すること。 |
| generateImage | captchaGeneratorコンポーネント名でCaptchaGeneratorを取得し、CAPTCHA情報を生成してDBに保存。CaptchaGenerateAction専用（業務アクションからは直接使用しない） |
| authenticate | 識別キーでDBからCAPTCHA情報を取得し、入力文字列と比較して結果を返却 |

<details>
<summary>keywords</summary>

generateKey, generateImage, authenticate, CaptchaUtil, UUID

</details>

## CaptchaGenerateActionの設定方法

```xml
<component name="captchaGenerator" class="please.change.me.common.captcha.CaptchaGenerator">
  <property name="imageType" value="jpg"/>
  <property name="configParameters">
    <map>
      <entry name="kaptcha.textproducer.char.string" value="abcdegfynmnpwx" />
      <entry name="kaptcha.textproducer.char.length" value="4" />
    </map>
  </property>
</component>

<component name="captchaGenerateAction" class="please.change.me.common.captcha.CaptchaGenerateAction"/>

<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.RequestHandlerEntry">
        <property name="requestPattern" value="/action/common/captcha/CaptchaGenerateAction/RW11ZZ0101"/>
        <property name="handler" ref="captchaGenerateAction"/>
      </component>
    </list>
  </property>
</component>
```

CaptchaGeneratorプロパティ:

| プロパティ名 | 説明 | デフォルト値 |
|---|---|---|
| imageType | 生成画像の形式。`javax.imageio.ImageIO#getWriterFormatNames()`で取得できる値を指定。wbmpは使用不可 | jpeg |
| configParameters | kaptchaへの設定値（Map形式）。設定可能な値は[kaptchaサイト](https://code.google.com/p/kaptcha/wiki/ConfigParameters)参照 | kaptchaデフォルト値 |

<details>
<summary>keywords</summary>

CaptchaGenerateAction, CaptchaGenerator, imageType, configParameters, captchaGenerator, webFrontController, RequestHandlerEntry

</details>

## ハンドラ配置の注意事項

CaptchaGenerateActionハンドラはHTTPレスポンスを返却するため後続ハンドラに処理を委譲しない。RequestHandlerEntryを使用してリクエストパターンを設定して使用すること。

/action配下にマッピングして1つのアクションとして動作させる場合、他のハンドラに追加設定が必要となる。

- **データベース接続管理・トランザクション制御ハンドラ**: CaptchaGenerateActionはDBに管理情報を保存するため、これらのハンドラより後に配置すること
- **Nablarchカスタムタグ制御ハンドラ**: hidden項目を含まないGETリクエストが改竄エラーと判定されるため、CustomTagConfigコンポーネントのnoHiddenEncryptionRequestIdsプロパティに本機能のリクエストIDを設定すること
- **開閉局制御ハンドラ**: リクエストテーブル上でリクエストIDとサービス稼動状態の設定を行うこと
- **認可制御ハンドラ**: 本機能はログイン前使用が想定されるため、認可チェックハンドラのignoreRequestIdsプロパティに本機能のリクエストIDを設定すること

<details>
<summary>keywords</summary>

noHiddenEncryptionRequestIds, ignoreRequestIds, データベース接続管理ハンドラ, トランザクション制御ハンドラ, Nablarchカスタムタグ制御ハンドラ, 開閉局制御ハンドラ, 認可制御ハンドラ, CustomTagConfig

</details>

## CAPTCHA識別キー取得方法

```java
public HttpResponse doRW11ZZ0103(HttpRequest request, ExecutionContext context) {
    String key = CaptchaUtil.generateKey();
    context.setRequestScopedVar("captchaKey", key);
    return new HttpResponse("/ss11ZZ/W11ZZ0103.jsp");
}
```

<details>
<summary>keywords</summary>

generateKey, captchaKey, 識別キー取得, CaptchaUtil

</details>

## CAPTCHA画像の取得方法

```jsp
<n:form>
  <n:img src="/action/CaptchaImg?captchaKey=${captchaKey}" alt=""/>
  <n:hidden name="${captchaKey}"></n:hidden>
  <field:text title="表示されている文字を入力" name="captchaValue"></field:text>
</n:form>
```

<details>
<summary>keywords</summary>

captchaKey, CaptchaGenerateAction, CAPTCHA画像取得, JSP, n:img, n:hidden

</details>

## 入力文字列判定方法

入力文字列の判定はサーバサイドのアクションクラスまたはフォームクラスのバリデーション処理から呼び出すことを想定している。

フォームクラスのバリデーション処理として実装した場合の例:

```java
@ValidateFor("captcha")
public static void validateForCaptcha(ValidationContext<W11ZZ01Form> context) {
    // 単項目精査
    ValidationUtil.validate(context, new String[]{"captchaKey", "captchaValue"});
    if (!context.isValid()) {
        return;
    }
    
    // CAPTCHA文字列判定
    W11ZZ01Form form = context.createObject();
    if (!CaptchaUtil.authenticate(form.getCaptchaKey(), form.getCaptchaVal())) {
        context.addResultMessage("captchaValue", "MSG90001");
    }
}
```

<details>
<summary>keywords</summary>

authenticate, CaptchaUtil, ValidateFor, ValidationContext, ValidationUtil, 入力文字列判定

</details>
