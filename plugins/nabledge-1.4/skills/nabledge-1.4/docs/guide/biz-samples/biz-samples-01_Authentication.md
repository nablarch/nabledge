# データベースを用いたパスワード認証機能サンプル

## 提供パッケージ

**パッケージ**: `please.change.me.common.authentication`

<details>
<summary>keywords</summary>

please.change.me.common.authentication, パスワード認証, パッケージ

</details>

## 概要

WebアプリケーションのユーザID/パスワード認証機能のサンプル実装。ログイン処理を実行する業務処理の中で使用することを想定。

> **注意**: Nablarch導入プロジェクトでは、要件を満たすよう本サンプル実装を修正して使用すること。

> **重要**: 本機能では、ログイン処理を実行する業務処理は提供しない。Nablarch導入プロジェクトにて、要件に応じてログイン処理を作成すること。

デフォルトでは[PBKDF2](http://www.ietf.org/rfc/rfc2898.txt)を使用してパスワードを暗号化する。各プロジェクトでパスワード暗号化のストレッチング回数やソルトなどを設定する必要がある。詳細は `01/0101_PBKDF2PasswordEncryptor` を参照。

<details>
<summary>keywords</summary>

PBKDF2, パスワード暗号化, パスワード認証, ストレッチング, ソルト

</details>

## 構成（クラス・インタフェース）

## インタフェース

| インタフェース名 | 概要 |
|---|---|
| `Authenticator` | ユーザの認証を行うインタフェース |
| `PasswordEncryptor` | パスワードの暗号化を行うインタフェース |

## クラス

| クラス名 | 概要 |
|---|---|
| `PasswordAuthenticator` | データベースに保存されたアカウント情報に対してパスワード認証を行うクラス |
| `PBKDF2PasswordEncryptor` | PBKDF2を使用してパスワードの暗号化を行うクラス |
| `AuthenticationUtil` | リポジトリからAuthenticatorおよびPasswordEncryptorを取得して、ユーザ認証およびパスワード暗号化を行うユーティリティ |
| `SystemAccount` | ユーザのアカウント情報を保持するクラス |

## 例外クラス

| クラス名 | 概要 |
|---|---|
| `AuthenticationException` | 認証処理に関する例外の基底クラス。認証方式に応じて本クラスを継承した例外クラスを作成する。本クラス及びサブクラスでは、ユーザへ提示するメッセージの作成に必要な情報を保持するが、メッセージの作成は行わない |
| `AuthenticationFailedException` | アカウント情報の不一致により認証に失敗した場合に発生する例外。対象ユーザのユーザIDを保持する |
| `PasswordExpiredException` | パスワードの有効期限が切れている場合に発生する例外。ユーザID・パスワード有効期限・チェックに使用した業務日付を保持する |
| `UserIdLockedException` | ユーザIDがロックされている場合に発生する例外。ユーザIDとロックする認証失敗回数を保持する |

<details>
<summary>keywords</summary>

PasswordAuthenticator, PBKDF2PasswordEncryptor, AuthenticationUtil, AuthenticationException, AuthenticationFailedException, PasswordExpiredException, UserIdLockedException, Authenticator, PasswordEncryptor, SystemAccount, クラス構成

</details>

## テーブル定義

本サンプルで使用しているアカウントテーブル（SYSTEM_ACCOUNT）の定義を示す。本サンプルを導入プロジェクトに取り込む際には、導入プロジェクトのテーブル定義に従いSQLファイルおよびソースコードを修正すること。

**システムアカウント(SYSTEM_ACCOUNT)**

| 論理名 | 物理名 | Javaの型 | 制約 |
|---|---|---|---|
| ユーザID | USER_ID | java.lang.String | 主キー |
| パスワード | PASSWORD | java.lang.String | |
| ユーザIDロック | USER_ID_LOCKED | java.lang.String | ロックなし="0"、ロックあり="1" |
| パスワード有効期限 | PASSWORD_EXPIRATION_DATE | java.lang.String | 書式yyyyMMdd、未指定時"99991231" |
| 認証失敗回数 | FAILED_COUNT | int | |
| 有効日(From) | EFFECTIVE_DATE_FROM | java.lang.String | 書式yyyyMMdd、未指定時"19000101" |
| 有効日(To) | EFFECTIVE_DATE_TO | java.lang.String | 書式yyyyMMdd、未指定時"99991231" |
| 最終ログイン日時 | LAST_LOGIN_DATE_TIME | java.sql.Timestamp | |

> **注意**: 導入プロジェクトでは、必要なユーザ属性をこのテーブルに追加したり、1対1で紐づくユーザ情報テーブルなどを作成して要件を満たすテーブル設計を行うこと。

<details>
<summary>keywords</summary>

SYSTEM_ACCOUNT, テーブル定義, USER_ID, PASSWORD, USER_ID_LOCKED, PASSWORD_EXPIRATION_DATE, FAILED_COUNT, EFFECTIVE_DATE_FROM, EFFECTIVE_DATE_TO, LAST_LOGIN_DATE_TIME, アカウント情報

</details>

## 使用方法（概要）

パスワード認証の特徴:
- 認証時にアカウント情報の有効日（From/To）をチェックする
- 認証時にパスワードの有効期限をチェックする
- 連続で指定回数認証に失敗するとユーザIDにロックをかける。指定回数に達するまでに認証に成功すると失敗回数をリセットする
- 暗号化されたパスワードを使用して認証。デフォルトでPBKDF2を使用
- 認証成功時のみシステム日時で最終ログイン日時を更新する

業務機能（ログイン機能、ユーザ登録機能など）からは `AuthenticationUtil` を使用すること。

<details>
<summary>keywords</summary>

AuthenticationUtil, パスワード認証, ユーザIDロック, パスワード有効期限, 認証失敗回数

</details>

## PasswordAuthenticatorの使用方法

PasswordAuthenticatorの設定例:

```xml
<component name="authenticator" class="please.change.me.common.authentication.PasswordAuthenticator">
  <property name="failedCountToLock" value="3"/>
  <property name="passwordEncryptor" ref="passwordEncryptor" />
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="authenticator"/>
      <property name="connectionFactory" ref="connectionFactory"/>
      <property name="transactionFactory" ref="transactionFactory"/>
    </component>
  </property>
  <property name="systemTimeProvider" ref="systemTimeProvider" />
  <property name="businessDateProvider" ref="businessDateProvider" />
</component>
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider" />
```

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| failedCountToLock | | 0 | ユーザIDをロックする認証失敗回数。0の場合はロック機能を使用しない |
| passwordEncryptor | ○ | | パスワード暗号化に使用するPasswordEncryptor。`01/0101_PBKDF2PasswordEncryptor` を参考に設定したコンポーネント名をrefに指定 |
| dbManager | ○ | | データベースへのトランザクション制御を行うSimpleDbTransactionManager。`nablarch.core.db.transaction.SimpleDbTransactionManager`クラスのインスタンスを指定する |
| systemTimeProvider | ○ | | システム日時の取得に使用するSystemTimeProvider（`nablarch.core.date.SystemTimeProvider`インタフェースを実装したクラス）。最終ログイン日時の更新に使用 |
| businessDateProvider | ○ | | 業務日付の取得に使用するBusinessDateProvider（`nablarch.core.date.BusinessDateProvider`インタフェースを実装したクラス）。有効日（From/To）とパスワード有効期限チェックに使用 |

> **警告**: PasswordAuthenticatorのトランザクション制御が個別アプリケーションの処理に影響を与えないように、個別アプリケーションとは別のトランザクションを使用するように設定すること。設定例では`dbTransactionName`に"authenticator"を指定しているので、個別アプリケーションでは同じ名前を使用しないこと。

<details>
<summary>keywords</summary>

PasswordAuthenticator, failedCountToLock, passwordEncryptor, dbManager, systemTimeProvider, businessDateProvider, SimpleDbTransactionManager, SystemTimeProvider, BusinessDateProvider, BasicSystemTimeProvider, BasicBusinessDateProvider

</details>

## AuthenticationUtilの使用方法

AuthenticationUtilのメソッド:

| メソッド | 説明 |
|---|---|
| encryptPassword | コンポーネント名`passwordEncryptor`でPasswordEncryptorを取得し、`PasswordEncryptor#encrypt(String, String)`を呼び出す |
| authenticate | コンポーネント名`authenticator`でAuthenticatorを取得し、`Authenticator#authenticate(String, String)`を呼び出す |

> **注意**: リポジトリからコンポーネントを取得する際のコンポーネント名は、PasswordAuthenticatorの設定で登録しているコンポーネント名と合わせる必要がある。設定例と異なるコンポーネント名で登録している場合はソースコードを修正すること。

## 使用例

```java
String userId = ...;
String password = ...;

try {
    AuthenticationUtil.authenticate(userId, password);
} catch (AuthenticationFailedException e) {
    // 認証に失敗した場合の処理
} catch (UserIdLockedException e) {
    // ユーザIDがロックされていた場合の処理
} catch (PasswordExpiredException e) {
    // パスワードの有効期限が切れていた場合の処理
}
```

認証エラーを細かく分ける必要がない場合は上位例外クラスでキャッチ可能:

```java
try {
    AuthenticationUtil.authenticate(userId, password);
} catch (AuthenticationException e) {
    // 例外の処理
}
```

<details>
<summary>keywords</summary>

AuthenticationUtil, encryptPassword, authenticate, AuthenticationException, AuthenticationFailedException, PasswordExpiredException, UserIdLockedException

</details>
