# メール送信処理のアプリケーション構造

## 概要

メール送信処理は常駐バッチ（逐次メール送信バッチ）を経由し、業務アプリケーションとは非同期で行う。

**理由**:
- 業務アプリケーションのDBトランザクションにメール送信処理を含めることができる
- メールサーバー/ネットワーク障害時でも業務アプリの処理への影響を与えない

**構成要素**:
- **メール送信要求API**: メール送信要求データをDBに格納するAPI。呼び出し毎に1つのメール送信要求が作成され、1要求につき1通のメールが送信される
- **逐次メール送信バッチ**: DB上のメール送信要求に基づいてメールを送信する常駐バッチ。メール送信ライブラリとして[JavaMail API](http://www.oracle.com/technetwork/java/javamail/index.html)を使用

<details>
<summary>keywords</summary>

メール送信処理, 非同期, 常駐バッチ, 逐次メール送信バッチ, メール送信要求API, JavaMail API

</details>

## メール送信のパターン

メール送信要求APIは以下の2パターンをサポートする。

| No | パターン | 説明 |
|---|---|---|
| 1 | 定型メール送信 | DBに登録済みテンプレートからメールを作成。テンプレートのプレースホルダを指定文字列に置換 |
| 2 | 非定型メール送信 | 任意の件名・本文でメールを作成 |

<details>
<summary>keywords</summary>

定型メール送信, 非定型メール送信, テンプレート, プレースホルダ, メール送信パターン

</details>

## テーブル定義

メール送信で使用するテーブル。テーブル名・カラム名は任意に指定可能。DBの型はJavaの型に変換可能な型を選択する。

### メール送信要求

| カラム | Javaの型 | 制約 |
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

### メール送信先

| カラム | Javaの型 | 制約 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 送信先区分 | java.lang.String | |
| メールアドレス | java.lang.String | |

### メール添付ファイル

| カラム | Javaの型 | 制約 |
|---|---|---|
| メール送信要求ID | java.lang.String | PK |
| 連番 | int | PK |
| 添付ファイル名 | java.lang.String | |
| 添付ファイルContent-Type | java.lang.String | |
| 添付ファイル | byte[] | |

### メールテンプレート

| カラム | Javaの型 | 制約 |
|---|---|---|
| メールテンプレートID | java.lang.String | PK |
| 言語 | java.lang.String | PK |
| 件名 | java.lang.String | |
| 本文 | java.lang.String | |
| 文字セット | java.lang.String | |

<details>
<summary>keywords</summary>

メール送信要求, メール送信先, メール添付ファイル, メールテンプレート, テーブル定義, java.lang.String, java.sql.Timestamp

</details>
