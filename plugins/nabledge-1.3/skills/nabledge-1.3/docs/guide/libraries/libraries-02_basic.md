# メール送信処理のアプリケーション構造

**公式ドキュメント**: [メール送信処理のアプリケーション構造](http://www.oracle.com/technetwork/java/javamail/index.html)

## 概要

メール送信処理は常駐バッチを経由し、業務APの処理とは非同期に行う。

**理由**:
- 業務APのDBトランザクションにメール送信処理を含めることができる
- メールサーバー障害・ネットワーク障害時に業務APへの影響を与えない

フレームワークが提供するコンポーネント:
- **メール送信要求API**: メール送信要求データを受け付けてDBに格納
- **逐次メール送信バッチ**: DBに格納されたメール送信要求に基づきメールを送信

メール送信要求API呼び出し1回につきメール送信要求が1件作成され、1件につきメールが1通送信される。

逐次メール送信バッチはメール送信ライブラリとして [JavaMail API](http://www.oracle.com/technetwork/java/javamail/index.html) を使用する。

![メール送信処理の概要](../../../knowledge/guide/libraries/assets/libraries-02_basic/mail_overview.jpg)

<details>
<summary>keywords</summary>

メール送信処理, 非同期送信, 常駐バッチ, メール送信要求API, 逐次メール送信バッチ, JavaMail API

</details>

## メール送信のパターン

メール送信要求APIは以下2パターンをサポートする。

| No | パターン | 説明 |
|---|---|---|
| 1 | 定型メール送信 | DBに登録済みのテンプレートを元にメールを作成・送信。テンプレートのプレースホルダに業務APから指定した文字列を埋め込む。 |
| 2 | 非定型メール送信 | 任意の件名・本文でメールを作成・送信。 |

<details>
<summary>keywords</summary>

定型メール送信, 非定型メール送信, メールテンプレート, プレースホルダ

</details>

## テーブル定義

テーブル名・カラム名は任意に指定できる。DBの型はJavaの型に変換可能な型を選択する。

**メール送信要求**

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 件名 | java.lang.String | |
| 送信者メールアドレス | java.lang.String | |
| 返信先メールアドレス | java.lang.String | |
| 差戻し先メールアドレス | java.lang.String | |
| 文字セット | java.lang.String | |
| ステータス | java.lang.String | |
| 要求日時 | java.sql.Timestamp | |
| 送信日時 | java.sql.Timestamp | |
| 本文 | java.lang.String | |

**メール送信先**

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 送信先区分 | java.lang.String | |
| メールアドレス | java.lang.String | |

**メール添付ファイル**

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 添付ファイル名 | java.lang.String | |
| 添付ファイルContent-Type | java.lang.String | |
| 添付ファイル | byte[] | |

**メールテンプレート**

| 定義 | Javaの型 | 制約 |
|---|---|---|
| メールテンプレートID | java.lang.String | PK |
| 言語 | java.lang.String | PK |
| 件名 | java.lang.String | |
| 本文 | java.lang.String | |
| 文字セット | java.lang.String | |

<details>
<summary>keywords</summary>

メール送信要求, メール送信先, メール添付ファイル, メールテンプレート, テーブル定義, java.sql.Timestamp, byte[]

</details>
