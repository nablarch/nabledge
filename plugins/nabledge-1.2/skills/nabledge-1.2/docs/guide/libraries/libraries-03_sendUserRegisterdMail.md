# メール送信の実装方法

## 実装例

メール送信要求APIは2パターン:
- 定型メール送信: `nablarch.common.mail.MailRequester#requestToSend(TemplateMailContext ctx)`
- 非定型メール送信: `nablarch.common.mail.MailRequester#requestToSend(FreeTextMailContext ctx)`

## 定型メール送信

`TemplateMailContext` を使用。テンプレートIDと言語を指定し、プレースホルダの置換文字を設定する。

```java
TemplateMailContext tmctx = new TemplateMailContext();
tmctx.setFrom(SystemRepository.getString("defaultFromMailAddress"));
tmctx.addTo(user.getMailAddress());
tmctx.setTemplateId(USER_REGISTERD_MAIL_TEMPLATE_ID);
tmctx.setLang(USER_LANG);
tmctx.setReplaceKeyValue("kanjiName", user.getKanjiName());
tmctx.setReplaceKeyValue("loginId", systemAccount.getLoginId());
MailRequester mailRequester = MailUtil.getMailRequester();
mailRequester.requestToSend(tmctx);
```

## 非定型メール送信

`FreeTextMailContext` を使用。テンプレートを使用せず、件名と本文を直接指定する。

```java
FreeTextMailContext ctx = new FreeTextMailContext();
ctx.setFrom(from);
ctx.addTo("to@tis.co.jp");
ctx.addCc("cc@tis.co.jp");
ctx.addBcc("bcc@tis.co.jp");
ctx.setSubject("件名");
ctx.setMailBody("本文");
// 添付ファイルを設定する場合
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);
MailRequester requester = MailUtil.getMailRequester();
String requestId = requester.requestToSend(ctx);
```

<details>
<summary>keywords</summary>

TemplateMailContext, FreeTextMailContext, MailRequester, MailUtil, AttachedFile, SystemRepository, requestToSend, 定型メール送信, 非定型メール送信, メール送信実装例, 添付ファイル

</details>

## 送信要求データオブジェクトへの設定項目

## 定型メール送信 (TemplateMailContext) の設定項目

| 項目 | 設定メソッド | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO/CC/BCC合計1つ以上必須。複数指定可。上限数設定可能 |
| 送信先メールアドレス(CC) | addCc | 複数指定可 |
| 送信先メールアドレス(BCC) | addBcc | 複数指定可 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される |
| メールテンプレートID | setTemplateId | 必須 |
| メールテンプレートの言語 | setLang | 必須 |
| プレースホルダのキーと置換文字 | setReplaceKeyValue | 必要な場合のみ |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能 |

## 非定型メール送信 (FreeTextMailContext) の設定項目

| 項目 | 設定メソッド | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO/CC/BCC合計1つ以上必須。複数指定可。上限数設定可能 |
| 送信先メールアドレス(CC) | addCc | 複数指定可 |
| 送信先メールアドレス(BCC) | addBcc | 複数指定可 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される |
| 件名 | setSubject | 必須 |
| 本文 | setMailBody | 必須 |
| 文字セット | setCharset | 省略可。省略時はデフォルト値が適用される |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能 |

<details>
<summary>keywords</summary>

TemplateMailContext, FreeTextMailContext, setFrom, addTo, addCc, addBcc, setReplyTo, setReturnPath, setTemplateId, setLang, setReplaceKeyValue, addAttachedFile, setSubject, setMailBody, setCharset, 送信要求データオブジェクト, 必須項目, メールアドレス設定

</details>
