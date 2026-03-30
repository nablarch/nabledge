# メール送信の実装方法

## 実装例

メール送信は `nablarch.common.mail.MailRequester#requestToSend()` で行う。送信要求データオブジェクトを引数に渡す。

| No | パターン | API |
|---|---|---|
| 1 | 定型メール送信 | `nablarch.common.mail.MailRequester#requestToSend(TemplateMailContext ctx)` |
| 2 | 非定型メール送信 | `nablarch.common.mail.MailRequester#requestToSend(FreeTextMailContext ctx)` |

**定型メール送信の実装例** (`nablarch.common.mail.TemplateMailContext` 使用):

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

**非定型メール送信の実装例** (`nablarch.common.mail.FreeTextMailContext` 使用): テンプレートを使わず、件名・本文を直接指定する。

```java
FreeTextMailContext ctx = new FreeTextMailContext();
ctx.setFrom(from);
ctx.addTo("to@tis.co.jp");
ctx.addCc("cc@tis.co.jp");
ctx.addBcc("bcc@tis.co.jp");
ctx.setSubject("件名");
ctx.setMailBody("本文");
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);
MailRequester requester = MailUtil.getMailRequester();
String requestId = requester.requestToSend(ctx);
```

添付ファイルは `nablarch.common.mail.AttachedFile` にContent-Typeの指定とともに設定する。

<details>
<summary>keywords</summary>

MailRequester, TemplateMailContext, FreeTextMailContext, AttachedFile, MailUtil, requestToSend, 定型メール送信, 非定型メール送信, メール送信要求, 添付ファイル

</details>

## 送信要求データオブジェクトへの設定項目

**定型メール送信の送信要求データオブジェクト** (`nablarch.common.mail.TemplateMailContext`) 設定項目:

| 項目 | 設定メソッド名 | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO,CC,BCCあわせて1つ以上必須。複数指定可。上限数(To,CC,BCC合計)の設定が可能。 |
| 送信先メールアドレス(CC) | addCc | 複数指定可 |
| 送信先メールアドレス(BCC) | addBcc | 複数指定可 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される。 |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される。 |
| メールテンプレートID | setTemplateId | 必須 |
| メールテンプレートの言語 | setLang | 必須 |
| メールテンプレートのプレースホルダのキーと置換文字 | setReplaceKeyValue | 必要な場合のみ |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能。 |

**非定型メール送信の送信要求データオブジェクト** (`nablarch.common.mail.FreeTextMailContext`) 設定項目:

| 項目 | 設定メソッド名 | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO,CC,BCCあわせて1つ以上必須。複数指定可。上限数(To,CC,BCC合計)の設定が可能。 |
| 送信先メールアドレス(CC) | addCc | 複数指定可 |
| 送信先メールアドレス(BCC) | addBcc | 複数指定可 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される。 |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される。 |
| 件名 | setSubject | 必須 |
| 本文 | setMailBody | 必須 |
| 文字セット | setCharset | 省略可。省略時はデフォルト値が適用される。 |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能。 |

<details>
<summary>keywords</summary>

TemplateMailContext, FreeTextMailContext, setFrom, addTo, addCc, addBcc, setReplyTo, setReturnPath, setTemplateId, setLang, setReplaceKeyValue, addAttachedFile, setSubject, setMailBody, setCharset, 送信要求データオブジェクト, メール送信設定項目

</details>
