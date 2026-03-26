# メール送信処理のアプリケーション構造

**公式ドキュメント**: [メール送信処理のアプリケーション構造](http://www.oracle.com/technetwork/java/javamail/index.html)

## 概要

メール送信処理は常駐バッチ経由で非同期に行う方式を採用。業務アプリのDBトランザクションにメール送信処理を含められ、メールサーバー障害時も業務処理への影響を防げる。

フレームワークが提供するもの:
- **メール送信要求API**: メール送信の要求データ（メール送信要求）を受け付けてDBに格納する
- **逐次メール送信バッチ**: DBのメール送信要求に基づいてメールを送信する常駐バッチ（[JavaMail API](http://www.oracle.com/technetwork/java/javamail/index.html) を使用）

API呼び出し1回につきメール送信要求が1件作成され、1件につきメール1通が送信される。

処理フロー:
1. 業務アプリケーションがメール送信要求APIを呼び出す
2. メール送信要求がDBに格納される
3. 逐次メール送信バッチがDBからメール送信要求を取得してメールサーバーへ送信する

<details>
<summary>keywords</summary>

メール送信処理, 非同期メール送信, メール送信要求API, 逐次メール送信バッチ, JavaMail API, 常駐バッチ

</details>

## メール送信のパターン

| No | パターン | 説明 |
|---|---|---|
| 1 | 定型メール送信 | DBに登録されたテンプレートを元にメールを作成・送信する。テンプレートの可変部分にプレースホルダを用意し、メール送信要求API呼び出し時に各プレースホルダを業務アプリ指定の文字列に置換する。 |
| 2 | 非定型メール送信 | 任意の件名・本文でメールを作成・送信する。 |

<details>
<summary>keywords</summary>

定型メール送信, 非定型メール送信, メールテンプレート, プレースホルダ, メール送信パターン

</details>

## テーブル定義

テーブル名・カラム名は任意に指定可能。DBの型はJavaの型に変換可能な型を選択する。

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

メール送信要求, メール送信先, メール添付ファイル, メールテンプレート, テーブル定義, java.sql.Timestamp

</details>
