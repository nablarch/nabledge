# データベースを用いたパスワード認証機能サンプル

**公式ドキュメント**: [データベースを用いたパスワード認証機能サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/01/index.html)

## 提供パッケージ

**パッケージ**: `please.change.me.common.authentication`

<details>
<summary>keywords</summary>

please.change.me.common.authentication, PasswordAuthenticator, PasswordEncryptor, パッケージ, パスワード認証サンプル

</details>

## 概要

データベースに保存されたアカウント情報（ユーザIDとパスワード）を使用したユーザ認証のサンプル実装。ログイン処理を実行する業務処理の中で使用することを想定している。

> **注意**: 本機能では、ログイン処理を実行する業務処理は提供しない。Nablarch導入プロジェクトにて、要件に応じてログイン処理を作成すること。

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-password-authentication)

> **補足**: 導入プロジェクトでは要件を満たすよう本サンプル実装を修正して使用すること。

デフォルトでは [PBKDF2](https://www.ietf.org/rfc/rfc2898.txt) を使用してパスワードを暗号化する。各プロジェクトでストレッチング回数やソルトなどを設定する必要がある。

設定内容の詳細は `0101_PBKDF2PasswordEncryptor` を参照。

<details>
<summary>keywords</summary>

PBKDF2, パスワード暗号化, ユーザ認証, ストレッチング, 0101_PBKDF2PasswordEncryptor, アカウント情報

</details>

## 構成：クラス構成

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `PasswordAuthenticator` | ユーザを認証するインタフェース |
| `PasswordEncryptor` | パスワードを暗号化するインタフェース |

**PasswordAuthenticatorの実装クラス**:

| クラス名 | 概要 |
|---|---|
| `SystemAccountAuthenticator` | データベースに保存されたアカウント情報に対してパスワード認証するクラス |

**PasswordEncryptorの実装クラス**:

| クラス名 | 概要 |
|---|---|
| `PBKDF2PasswordEncryptor` | PBKDF2を使用してパスワードを暗号化するクラス |

**ユーティリティクラス**:

| クラス名 | 概要 |
|---|---|
| `AuthenticationUtil` | システムリポジトリからPasswordAuthenticatorおよびPasswordEncryptorを取得してユーザ認証・パスワード暗号化を行うユーティリティ |

**エンティティクラス**:

| クラス名 | 概要 |
|---|---|
| `SystemAccount` | ユーザのアカウント情報を保持するクラス。ユニバーサルDAOの検索結果を格納する |

> **補足**: エンティティクラスはgsp-dba-maven-plugin（DBA作業支援ツール）を使用して自動生成すること。本サンプルのエンティティクラスをそのまま使用せず、各プロジェクトで自動生成したものを使用すること。

**例外クラス**:

| クラス名 | 概要 |
|---|---|
| `AuthenticationException` | 認証失敗の基底例外クラス。認証方式に応じてサブクラスを作成する。ユーザへ提示するメッセージ作成に必要な情報を保持し、メッセージの作成は行わない |
| `AuthenticationFailedException` | アカウント情報の不一致による認証失敗時の例外。対象ユーザのユーザIDを保持する |
| `PasswordExpiredException` | 認証時にパスワード有効期限切れの場合の例外。ユーザID、パスワード有効期限、業務日付を保持する |
| `UserIdLockedException` | 認証時にユーザIDがロックされている場合の例外。ユーザIDとロックする認証失敗回数を保持する |

<details>
<summary>keywords</summary>

SystemAccountAuthenticator, PBKDF2PasswordEncryptor, AuthenticationUtil, SystemAccount, AuthenticationException, AuthenticationFailedException, PasswordExpiredException, UserIdLockedException, PasswordAuthenticator, PasswordEncryptor, クラス図, クラス構成, 例外クラス, インタフェース定義

</details>

## 構成：テーブル定義

本サンプルで使用しているアカウントテーブルの定義。本サンプルを導入プロジェクトに取り込む際は、プロジェクトのテーブル定義に従いSQLファイルおよびソースコードを修正すること。

**システムアカウント（SYSTEM_ACCOUNT）**:

| 論理名 | 物理名 | Javaの型 | 制約 |
|---|---|---|---|
| ユーザID | USER_ID | java.lang.Integer | 主キー |
| ログインID | LOGIN_ID | java.lang.String | |
| パスワード | USER_PASSWORD | java.lang.String | |
| ユーザIDロック | USER_ID_LOCKED | boolean | ロックしている場合はtrue |
| パスワード有効期限 | PASSWORD_EXPIRATION_DATE | java.util.Date | |
| 認証失敗回数 | FAILED_COUNT | java.lang.Short | |
| 有効日(From) | EFFECTIVE_DATE_FROM | java.util.Date | |
| 有効日(To) | EFFECTIVE_DATE_TO | java.util.Date | |
| 最終ログイン日時 | LAST_LOGIN_DATE_TIME | java.util.Date | |

> **補足**: 上記テーブル定義は本サンプルで必要な属性のみ。導入プロジェクトでは必要なユーザ属性の追加や関連テーブルの作成など要件に応じてテーブル設計すること。

<details>
<summary>keywords</summary>

SYSTEM_ACCOUNT, テーブル定義, USER_ID, LOGIN_ID, USER_PASSWORD, USER_ID_LOCKED, PASSWORD_EXPIRATION_DATE, FAILED_COUNT, LAST_LOGIN_DATE_TIME, システムアカウント

</details>

## 使用方法：概要

パスワード認証の特徴:
- 認証時にアカウント情報の有効日（From/To）をチェックする
- 認証時にパスワードの有効期限をチェックする
- 連続で指定回数認証に失敗するとユーザIDをロックする。指定回数内に認証成功すると失敗回数をリセットする
- 暗号化されたパスワード（デフォルトはPBKDF2）を使用して認証する
- 認証成功時のみシステム日時で最終ログイン日時を更新する

PasswordAuthenticatorおよびPasswordEncryptorはNablarchのシステムリポジトリから取得して使用する想定となっている。業務機能の各箇所でシステムリポジトリからコンポーネントを直接取得するべきではないため、本機能ではシステムリポジトリからのコンポーネント取得とパスワード認証・暗号化処理をラップした`AuthenticationUtil`を提供している。

プロジェクトで実装するログイン機能やユーザ登録機能などからは`AuthenticationUtil`を使用すること。

<details>
<summary>keywords</summary>

パスワード認証, 有効日チェック, パスワード有効期限, ユーザIDロック, 認証失敗回数, 最終ログイン日時, AuthenticationUtil, システムリポジトリ

</details>

## SystemAccountAuthenticatorの使用方法

**コンポーネント設定例**:

```xml
<component name="authenticator" class="please.change.me.common.authentication.SystemAccountAuthenticator">
  <!-- パスワードを暗号化するPasswordEncryptor -->
  <property name="passwordEncryptor" ref="passwordEncryptor" />
  <!-- データベースへのトランザクション制御を行うクラス -->
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="authenticator"/>
      <property name="connectionFactory" ref="connectionFactory"/>
      <property name="transactionFactory" ref="transactionFactory"/>
    </component>
  </property>
  <!-- ユーザIDをロックする認証失敗回数 -->
  <property name="failedCountToLock" value="5"/>
</component>
```

**プロパティ説明**:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| `passwordEncryptor` | ○ | | パスワード暗号化に使用するPasswordEncryptor。`0101_PBKDF2PasswordEncryptor` を参考に設定したコンポーネント名をrefに指定すること |
| `dbManager` | ○ | | データベーストランザクション制御用のSimpleDbTransactionManagerインスタンス |
| `failedCountToLock` | | 0 | ユーザIDをロックする認証失敗回数。0の場合はロック機能を使用しない |

> **重要**: SystemAccountAuthenticatorのトランザクション制御が個別アプリケーションに影響しないよう、個別アプリケーションとは別のトランザクションを使用すること。設定例のdbTransactionNameに指定した `"authenticator"` は個別アプリケーションでは使用しないこと。

<details>
<summary>keywords</summary>

SystemAccountAuthenticator, passwordEncryptor, dbManager, failedCountToLock, SimpleDbTransactionManager, コンポーネント設定, XML設定, authenticator

</details>

## AuthenticationUtilの使用方法

AuthenticationUtilでは以下のユーティリティメソッドを実装している。システムリポジトリからコンポーネントを取得する際のコンポーネント名は、SystemAccountAuthenticatorの設定で登録しているコンポーネント名と合わせる必要がある。設定例と異なるコンポーネント名で登録している場合はソースコードを修正すること。

**メソッド一覧**:

| メソッド | 説明 |
|---|---|
| `encryptPassword` | システムリポジトリから `passwordEncryptor` というコンポーネント名でPasswordEncryptorを取得し、`PasswordEncryptor#encrypt(String, String)` を呼び出す |
| `authenticate` | システムリポジトリから `authenticator` というコンポーネント名でPasswordAuthenticatorを取得し、`PasswordAuthenticator#authenticate(String, String)` を呼び出す |

**認証処理の実装例**:

```java
try {
    AuthenticationUtil.authenticate(userId, password);
} catch (AuthenticationFailedException e) {
    // 認証失敗
} catch (UserIdLockedException e) {
    // ユーザIDロック
} catch (PasswordExpiredException e) {
    // パスワード有効期限切れ
}
```

認証エラーを細かく処理する必要がない場合、基底例外クラスで捕捉可能:

```java
try {
    AuthenticationUtil.authenticate(userId, password);
} catch (AuthenticationException e) {
    // 例外処理
}
```

<details>
<summary>keywords</summary>

AuthenticationUtil, authenticate, encryptPassword, AuthenticationFailedException, UserIdLockedException, PasswordExpiredException, AuthenticationException, 使用例, 認証処理実装例

</details>
