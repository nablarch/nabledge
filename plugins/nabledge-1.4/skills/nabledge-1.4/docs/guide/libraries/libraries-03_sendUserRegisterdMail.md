# メール送信の実装方法

## 実装例

メール送信要求データオブジェクトに必要な項目を設定し、`nablarch.common.mail.MailRequester#requestToSend()` を呼び出す。

| No | パターン | API |
|---|---|---|
| 1 | 定型メール送信 | `nablarch.common.mail.MailRequester#requestToSend(TemplateMailContext ctx)` |
| 2 | 非定型メール送信 | `nablarch.common.mail.MailRequester#requestToSend(FreeTextMailContext ctx)` |

## 定型メール送信の実装例

メールテンプレートテーブルのデータ例（プレースホルダ `{kanjiName}`、`{loginId}` を使用）:

| MAIL_TEMPLATE_ID | LANG | SUBJECT | CHARSET | MAIL_BODY |
|---|---|---|---|---|
| 1 | ja | {kanjiName}さんのユーザー登録が完了しました。 | iso-2022-jp | {kanjiName}さん\nNablarch Sampleアプリケーションへのユーザー登録が完了しました。\nログインID：{loginId}\n下記URLからログインしてください。\nhttp://localhost:8999/action/ss11AB/W11AB01Action/RW11AB0101 |

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

## 非定型メール送信の実装例

テンプレートを使用せず、件名・本文を直接指定する。添付ファイルも設定可能。

```java
FreeTextMailContext ctx = new FreeTextMailContext();
ctx.setFrom(from);
ctx.addTo("to@tis.co.jp");
ctx.addCc("cc@tis.co.jp");
ctx.addBcc("bcc@tis.co.jp");
ctx.setSubject("件名");
ctx.setMailBody("本文");
// 添付ファイルを設定する場合: nablarch.common.mail.AttachedFile にContent-Typeとファイルを指定
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);
MailRequester requester = MailUtil.getMailRequester();
String requestId = requester.requestToSend(ctx);
```

<details>
<summary>keywords</summary>

MailRequester, TemplateMailContext, FreeTextMailContext, AttachedFile, MailUtil, SystemRepository, 定型メール送信, 非定型メール送信, メール送信要求, 添付ファイル, requestToSend

</details>

## 送信要求データオブジェクトへの設定項目

## 定型メール送信: `nablarch.common.mail.TemplateMailContext` 設定項目

| 項目 | 設定メソッド名 | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO/CC/BCCあわせて1つ以上必須。それぞれ複数指定可。上限数(To/CC/BCC合計)の設定が可能 |
| 送信先メールアドレス(CC) | addCc | 〃 |
| 送信先メールアドレス(BCC) | addBcc | 〃 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される |
| メールテンプレートID | setTemplateId | 必須 |
| メールテンプレートの言語 | setLang | 必須 |
| メールテンプレートのプレースホルダのキーと置換文字 | setReplaceKeyValue | 必要な場合のみ |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能 |

## 非定型メール送信: `nablarch.common.mail.FreeTextMailContext` 設定項目

| 項目 | 設定メソッド名 | 説明 |
|---|---|---|
| 送信元メールアドレス(From) | setFrom | 必須 |
| 送信先メールアドレス(TO) | addTo | TO/CC/BCCあわせて1つ以上必須。それぞれ複数指定可。上限数(To/CC/BCC合計)の設定が可能 |
| 送信先メールアドレス(CC) | addCc | 〃 |
| 送信先メールアドレス(BCC) | addBcc | 〃 |
| 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。省略時はデフォルト値が適用される |
| 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。省略時はデフォルト値が適用される |
| 件名 | setSubject | 必須 |
| 本文 | setMailBody | 必須 |
| 文字セット | setCharset | 省略可。省略時はデフォルト値が適用される |
| 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能 |

<details>
<summary>keywords</summary>

TemplateMailContext, FreeTextMailContext, setFrom, addTo, addCc, addBcc, setReplyTo, setReturnPath, setTemplateId, setLang, setReplaceKeyValue, addAttachedFile, setSubject, setMailBody, setCharset, メール送信設定項目, プレースホルダ置換, 送信先メールアドレス

</details>
