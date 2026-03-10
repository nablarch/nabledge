# HTMLメール送信機能サンプル

## 実装済み

> **重要**: 本サンプルはキャンペーン通知のようなHTMLメールの一括送信には対応していない。以下に該当する場合は専用プロダクトの使用を推奨する:
> - キャンペーン通知・メールマガジンなど大量メールの一括送信
> - 開封率・クリックカウントの効果測定
> - メールアドレスからクライアント（フィーチャーフォン等）を判別して送信メールを切替
> - 絵文字・デコメールの使用
> - HTMLコンテンツ作成を顧客が行う場合（本サンプルは開発者によるコンテンツ作成が必要）

> **重要**: 一部のクライアントではHTMLメールが期待通りに表示されずユーザがメールを参照しない可能性がある。業務要件としてユーザ通知が重要なメールにはHTMLメールを使用しないこと。

> **重要**: **HTMLメールのレイアウト** — メールクライアントにより表示に差異があるため、HTMLメール標準を策定し顧客と合意すること。検討事項: テスト対象のメールクライアント・デバイス・OS、HTMLタグ・CSSプロパティの使用範囲、フォント・配色の使用範囲、コンテンツ横幅。
>
> **コンテンツ作成の留意点**:
> - `<head>`タグを無視するメールクライアントがあるため、スタイルをCSSファイルや`<style>`タグに切り出すことは**推奨されていない**
> - 極力シンプルなデザインにすること
> - メディアクエリをサポートしないメールクライアントがあるため、極力レスポンシブデザインは採用しないこと

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-html-mail)

本機能は:ref:`メール送信機能<mail>`を使用してHTMLメールを送信するサンプル（導入プロジェクトで使用する際には、ソースコード(プロダクション、テストコード共に）をプロジェクトに取り込み、使用すること）。

実装済み機能:
- HTMLメール（代替テキストを含む）を送信できる
- 本文のプレースホルダー部分の文字列にHTMLエスケープを行う（通常のオンライン画面と同様のセキュリティ対策）

## 取り下げ

取り下げた要求（本サンプルでは提供しない）:

1. **メールクライアント毎の差異吸収** (CSSなどのスタイル差異、JavaScriptの使用可否を含む実装差異の吸収)
   - HTMLのデザインおよび対象クライアントの選定はPJにて対応するため、本サンプルでは提供しない

2. **HTMLメールへの画像埋めこみ**
   - 画像埋めこみはメール容量を増大させ、HTMLを拒否したユーザでも受信に時間がかかる
   - メールサーバへの負荷も増大する
   - コンシューマ向けWebサービスではURL形式の使用が多いため未提供

## メールの形式

本サンプルで送信可能なメール形式（RFC 2557に準拠したContent-Typeで送信）:

| メール形式 | 業務Actionが使用するコンテキストクラス | 添付ファイル | メール構造のパターン |
|---|---|---|---|
| TEXT | `TemplateMailContext` | 無し | 1 |
| TEXT | `TemplateMailContext` | 有り | 2 |
| HTML | `TemplateHtmlMailContext` | 無し | 3 |
| HTML | `TemplateHtmlMailContext` | 有り | 4 |

**メール構造パターン1** (TEXT、添付無し):
![メール構造パターン1](../../knowledge/about/about-nablarch/assets/about-nablarch-08/Mail_Pattern01.jpg)

**メール構造パターン2** (TEXT、添付有り):
![メール構造パターン2](../../knowledge/about/about-nablarch/assets/about-nablarch-08/Mail_Pattern02.jpg)

**メール構造パターン3** (HTML、添付無し):
![メール構造パターン3](../../knowledge/about/about-nablarch/assets/about-nablarch-08/Mail_Pattern03.jpg)

**メール構造パターン4** (HTML、添付有り):
![メール構造パターン4](../../knowledge/about/about-nablarch/assets/about-nablarch-08/Mail_Pattern04.jpg)

## クラス図

![HTMLメールクラス図](../../knowledge/about/about-nablarch/assets/about-nablarch-08/HtmlMail_ClassDiagram.png)

各クラスの責務:

| クラス名 | 概要 |
|---|---|
| `please.change.me.common.mail.html.HtmlMailRequester` | `MailRequester`を拡張したHTMLメール送信要求を受け付けるクラス |
| `please.change.me.common.mail.html.TemplateHtmlMailContext` | `TemplateMailContext`を拡張し、HTMLメールに必要な情報を保持するクラス。代替テキストを本文に変換することでHTMLメール用テンプレートを使用してプレーンテキスト形式のメールを送信する機能を実現する |
| `please.change.me.common.mail.html.HtmlMailTable` | HTMLメール用のテーブルにアクセスするクラス |
| `please.change.me.common.mail.html.HtmlMailSender` | `MailSender`を拡張したHTMLメールの送信をサポートするクラス。HTMLメール用の要求でない場合は親クラスに処理を委譲しプレーンテキスト形式のメールを送信する |
| `please.change.me.common.mail.html.HtmlMailContentCreator` | HTMLメール用のコンテンツを生成するクラス |

コンポーネント設定:

```xml
<component name="mailRequester" class="please.change.me.common.mail.html.HtmlMailRequester">
    <property name="mailRequestConfig" ref="mailRequestConfig" />
    <property name="mailRequestIdGenerator" ref="mailRequestIdGenerator" />
    <property name="mailRequestTable" ref="mailRequestTable" />
    <property name="mailRecipientTable" ref="mailRecipientTable" />
    <property name="mailAttachedFileTable" ref="mailAttachedFileTable" />
    <property name="mailTemplateTable" ref="mailTemplateTable" />
    <property name="htmlMailTable" ref="htmlMailTable" />
</component>

<component name="htmlMailTable" class="please.change.me.common.mail.html.HtmlMailTable" />
```

> **注意**: Nablarchアプリケーションフレームワークの標準メール送信機能ではスキーマ定義を設定ファイルで行うが、本ライブラリではソースコードを直接修正すれば良いため、設定ファイルでのスキーマ定義は不要。ただし、テーブルアクセスの機能（`HtmlMailTable`）はRequesterとSenderで共通のため、`htmlMailTable`コンポーネントの定義は必ず行うこと。

## データモデル

メール機能からの拡張テーブル（DDLはテスト資源に含まれる）。

**HTMLメール用代替テキストテンプレートテーブル** — HTML用定型メールの代替テキストを管理するメールテンプレートの関連テーブル:

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メールテンプレートID | `java.lang.String` | PK |
| 言語 | `java.lang.String` | PK |
| 代替テキスト | `java.lang.String` | HTMLメールを表示できないメーラーのためのテキスト |

**HTMLメール用代替テキストテーブル** — HTMLメール用の代替テキストを管理するメール送信要求の関連テーブル:

| 定義 | Javaの型 | 備考 |
|---|---|---|
| メール送信要求ID | `java.lang.String` | PK |
| 代替テキスト | `java.lang.String` | HTMLメールを表示できないメーラーのためのテキスト |

## HTMLメールの送信

実装は:ref:`メール送信機能<mail>`の定型メール送信と同様。業務アクションで使用するコンテキストクラスが `TemplateMailContext` の代わりに `TemplateHtmlMailContext` となる点のみが異なる。

## コンテンツの動的な切替

メール送信要求時に `TemplateHtmlMailContext` の `contentType` に **プレーンテキスト** を指定した場合、代替テキストを本文に差し替える。

| コンテキストクラス | 指定されたType | 本文への移送元 | Content-Type |
|---|---|---|---|
| `TemplateMailContext` | — | メールテンプレート.本文 | text/plain |
| `TemplateHtmlMailContext` | `text/plain` | 代替テキストテンプレート.代替テキスト | text/plain |
| `TemplateHtmlMailContext` | `text/html` | メールテンプレート.本文 | text/html |

```java
public HttpResponse doSendMail(HttpRequest req, ExecutionContext ctx) {
    MailSampleForm form = MailSampleForm.validate(req, "mail");
    TemplateHtmlMailContext mail = new TemplateHtmlMailContext();
    // このとき、ユーザがContentType.PLAINを選択していれば、代替テキストが本文に切り替わる。
    mail.setContentType(form.getType());
    // その他のプロパティを設定し、MailRequesterを呼び出す。
}
```

## 電子署名の併用

:ref:`電子署名の拡張サンプル<bouncycastle_mail_sample>`とHTMLメールサンプルを併用する場合:

- メール送信要求の登録処理は本サンプル（`HtmlMailRequester`）を使用する
- メール送信バッチは `HtmlMailContentCreator` を使用してHTMLメールのコンテンツを作成できるよう、電子署名の拡張サンプル（`SMIMESignedMailSender`）を拡張して使用する

```java
@Override
protected void addBodyContent(MimeMessage mimeMessage, MailRequestTable.MailRequest mailRequest,
        List<? extends MailAttachedFileTable.MailAttachedFile> attachedFiles, ExecutionContext context) throws MessagingException {

    String mailSendPatternId = context.getSessionScopedVar("mailSendPatternId");
    Map<String, CertificateWrapper> certificateChain = SystemRepository.get(CERTIFICATE_REPOSITORY_KEY);
    CertificateWrapper certificateWrapper = certificateChain.get(mailSendPatternId);

    try {
        SMIMESignedGenerator smimeSignedGenerator = new SMIMESignedGenerator();
        // ---中略---

        MimeBodyPart bodyPart;
        HtmlMailTable htmlTable = SystemRepository.get("htmlMailTable");
        SqlRow alternativeText = htmlTable.findAlternativeText(mailRequest.getMailRequestId());
        if (alternativeText != null) {
            bodyPart = new MimeBodyPart();
            bodyPart.setContent(HtmlMailContentCreator.create(mailRequest.getMailBody(), mailRequest.getCharset(),
                                                              alternativeText.getString("alternativeText"), attachedFiles));
            mimeMessage.setContent(smimeSignedGenerator.generate(bodyPart));
        } else {
            bodyPart = new MimeBodyPart();
            bodyPart.setText(mailRequest.getMailBody(), mailRequest.getCharset());
            // ---後略---
        }
    } catch (Exception e) {
        MailConfig mailConfig = SystemRepository.get("mailConfig");
        String mailRequestId = mailRequest.getMailRequestId();
        throw new TransactionAbnormalEnd(
                mailConfig.getAbnormalEndExitCode(), e,
                mailConfig.getSendFailureCode(), mailRequestId);
    }
}
```

## タグを埋めこむ

> **重要**: タグの埋めこみは以下の理由から提供時には実装しておらず、推奨もしていない:
> - HTMLメールのレイアウト確認が困難になる
> - セキュリティ対策もPJにて実施する必要がある
>
> 安易に使用せず、テンプレートを複数用意することで対応できないか検討すること（テンプレートの作成コストでセキュリティ上のリスクを補填できる点も考慮すること）。

本サンプルではHTMLエスケープを強制するため、動的にHTMLタグをテンプレートに埋めこむことはできない。動的に埋めこむ必要がある場合は、PJにて `TemplateHtmlMailContext` を修正し、`TemplateMailContext#setReplaceKeyValue` を呼び出すAPIを追加すること。

```java
// HTMLエスケープをせずにタグを埋めこむ。
public void setReplaceKeyRawValue(String key, String tag) {
    super.setReplaceKeyValue(key, tag);
}
```

> **補足**: HTMLメールのテストは通常のメールと同様:
> - HTMLテキストはメール送信要求のテーブルを検証する
> - 実際のメールクライアントでのレイアウト確認は送信バッチを使用してメールを送信して確認する
