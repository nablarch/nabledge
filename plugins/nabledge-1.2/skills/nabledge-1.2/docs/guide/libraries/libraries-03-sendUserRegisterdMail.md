# メール送信の実装方法

メール送信要求を表すデータオブジェクト(以下、送信要求データオブジェクト)に必要な項目を設定の上、
そのオブジェクトを引数にメール送信要求APIを呼び出す。
前述2パターンのAPIはそれぞれ以下の通り。

| No | パターン | API |
|---|---|---|
| 1 | 定型メール送信 | nablarch.common.mail.MailRequester#requestToSend(TemplateMailContext ctx) |
| 2 | 非定型メール送信 | nablarch.common.mail.MailRequester#requestToSend(FreeTextMailContext ctx) |

## 実装例

* 定型メール送信の実装例:

サンプルアプリケーションでは、この定型メール送信のパターンを使用している。
メールテンプレートテーブルには、予め以下のデータが設定されている。

| MAIL_TEMPLATE_ID | LANG | SUBJECT | CHARSET | MAIL_BODY |
|---|---|---|---|---|
| 1 | ja | {kanjiName}さんのユーザー登録が完了しました。 | iso-2022-jp | {kanjiName}さん  Nablarch Sampleアプリケーションへのユーザー登録が完了しました。  ログインID：{loginId}  下記URLからログインしてください。  [http://localhost:8999/action/ss11AB/W11AB01Action/RW11AB0101](http://localhost:8999/action/ss11AB/W11AB01Action/RW11AB0101) |

実装例を以下に示す。実装箇所は、ユーザー登録機能のアクションクラス(W11AC02Action.java)である。

```java
// 定型メール送信要求データオブジェクトを作成する。
TemplateMailContext tmctx = new TemplateMailContext();

// 送信元・送信先メールアドレスを設定する。
tmctx.setFrom(SystemRepository.getString("defaultFromMailAddress"));
tmctx.addTo(user.getMailAddress());

// 定型メールのテンプレートと言語を設定する。
tmctx.setTemplateId(USER_REGISTERD_MAIL_TEMPLATE_ID);
tmctx.setLang(USER_LANG);

// テンプレートのプレースホルダのキーと置換文字を設定する。
tmctx.setReplaceKeyValue("kanjiName", user.getKanjiName());
tmctx.setReplaceKeyValue("loginId", systemAccount.getLoginId());

// メール送信APIのインスタンスを取得する。
MailRequester mailRequester = MailUtil.getMailRequester();

// メール送信要求を行う。
mailRequester.requestToSend(tmctx);
```

* 非定型メール送信の実装例:

非定型メールの場合はテンプレートを使用せず、件名と本文を直接指定する。
実装例を以下に示す。

```java
// 非定型メール送信要求データオブジェクトを作成する。
FreeTextMailContext ctx = new FreeTextMailContext();
ctx.setFrom(from);
ctx.addTo("to@tis.co.jp");
ctx.addCc("cc@tis.co.jp");
ctx.addBcc("bcc@tis.co.jp");
ctx.setSubject("件名");
ctx.setMailBody("本文");

/*
 * 添付ファイルを設定する。
 *
 * 【説明】
 * ファイルを添付する場合は、
 * 添付ファイルのオブジェクトを作成し、設定する。
 * 添付ファイルは、添付ファイルを表すデータオブジェクト
 * nablarch.common.mail.AttachedFileにContent-Typeの指定とともに設定する。
 */
AttachedFile attachedFile = new AttachedFile("text/plain", new File("path/to/file"));
ctx.addAttachedFile(attachedFile);

// メール送信APIのインスタンスを取得する。
MailRequester requester = MailUtil.getMailRequester();
// メール送信要求を行う。
String requestId = requester.requestToSend(ctx);
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#注意事項) 参照)

## 送信要求データオブジェクトへの設定項目

各パターンにおける送信要求データオブジェクトへの設定項目は下表の通り。

* 定型メール送信時の送信要求データオブジェクト(nablarch.common.mail.TemplateMailContext)設定項目

  | 項目 | 設定メソッド名 | 説明 |
  |---|---|---|
  | 送信元メールアドレス(From) | setFrom | 必須 |
  | 送信先メールアドレス(TO) | addTo | * TO,CC,BCCあわせて1つ以上必須。   * それぞれ複数指定可。   * 上限数(To,CC,BCC合計)の設定が可能([1])。 |
  | 送信先メールアドレス(CC) | addCc |  |
  | 送信先メールアドレス(BCC) | addBcc |  |
  | 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。   省略時は予め設定されたデフォルト値が適用される([2])。 |
  | 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。   省略時は予め設定されたデフォルト値が適用される([2])。 |
  | メールテンプレートID | setTemplateId | 必須 |
  | メールテンプレートの言語 | setLang | 必須 |
  | メールテンプレートのプレースホルダのキーと置換文字 | setReplaceKeyValue | 必要な場合のみ。 |
  | 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能([3])。 |

* 非定型メール送信の送信要求データオブジェクト(nablarch.common.mail.FreeTextMailContext)設定項目

  | 項目 | 設定メソッド名 | 説明 |
  |---|---|---|
  | 送信元メールアドレス(From) | setFrom | 必須 |
  | 送信先メールアドレス(TO) | addTo | * TO,CC,BCCあわせて1つ以上必須。   * それぞれ複数指定可。   * 上限数(To,CC,BCC合計)の設定が可能([1])。 |
  | 送信先メールアドレス(CC) | addCc |  |
  | 送信先メールアドレス(BCC) | addBcc |  |
  | 返信先メールアドレス(Reply-To) | setReplyTo | 省略可。   省略時は予め設定されたデフォルト値が適用される([2])。 |
  | 差戻し先メールアドレス(Return-Path) | setReturnPath | 省略可。   省略時は予め設定されたデフォルト値が適用される([2])。 |
  | 件名 | setSubject | 必須 |
  | 本文 | setMailBody | 必須 |
  | 文字セット | setCharset | 省略可。   省略時は予め設定されたデフォルト値が適用される([2])。 |
  | 添付ファイル | addAttachedFile | 必要な場合のみ。複数可。合計サイズ上限設定可能([3])。 |

  上限数の設定方法は [フレームワーク解説書](../../../../fw/reference/core_library/mail.html) を参照。

  デフォルト値の設定方法は [フレームワーク解説書](../../../../fw/reference/core_library/mail.html) を参照。

  サイズ上限の設定方法は [フレームワーク解説書](../../../../fw/reference/core_library/mail.html) を参照。
