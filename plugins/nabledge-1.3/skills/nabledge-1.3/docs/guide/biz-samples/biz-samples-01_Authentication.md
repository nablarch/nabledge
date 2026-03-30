# データベースを用いたパスワード認証機能サンプル

## 提供パッケージ

**パッケージ**: `please.change.me.common.authentication`

<details>
<summary>keywords</summary>

please.change.me.common.authentication, パスワード認証, 提供パッケージ

</details>

## 概要

Webアプリケーションにおけるユーザ認証（ユーザIDとパスワード）のサンプル実装。ログイン業務処理内で使用することを想定。

> **注意**: Nablarch導入プロジェクトでは要件を満たすよう本サンプル実装を修正して使用すること。

ログイン処理を実行する業務処理は本サンプルに含まれない。導入プロジェクトで要件に応じてログイン処理を作成すること。

<details>
<summary>keywords</summary>

パスワード認証, ユーザ認証, ログイン処理, Authenticator, PasswordEncryptor

</details>

## 構成

![クラス図](../../../knowledge/guide/biz-samples/assets/biz-samples-01_Authentication/Authentication_ClassDiagram.jpg)

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `Authenticator` | ユーザの認証を行うインタフェース |
| `PasswordEncryptor` | パスワードの暗号化を行うインタフェース |

**クラス**:

| クラス名 | 概要 |
|---|---|
| `PasswordAuthenticator` | DBのアカウント情報に対してパスワード認証を行う（`Authenticator`実装） |
| `Sha256PasswordEncryptor` | SHA256でパスワードを暗号化する（`PasswordEncryptor`実装） |
| `SystemAccount` | ユーザのアカウント情報を保持する |

**例外クラス**:

| クラス名 | 概要 |
|---|---|
| `AuthenticationException` | 認証失敗の基底例外。認証方式に応じてサブクラスを作成する。ユーザへのメッセージ作成に必要な情報を保持するが、メッセージ作成は行わない。 |
| `AuthenticationFailedException` | アカウント情報不一致による認証失敗。対象ユーザのユーザIDを保持。 |
| `PasswordExpiredException` | パスワード有効期限切れ。ユーザID、パスワード有効期限、チェックに使用した業務日付を保持。 |
| `UserIdLockedException` | ユーザIDロック状態での認証。ユーザIDとロック認証失敗回数を保持。 |

**テーブル: SYSTEM_ACCOUNT（システムアカウント）**

| 論理名 | 物理名 | 型 | 備考 |
|---|---|---|---|
| ユーザID | USER_ID | String | 主キー |
| パスワード | PASSWORD | String | |
| ユーザIDロック | USER_ID_LOCKED | String | "0"=未ロック, "1"=ロック |
| パスワード有効期限 | PASSWORD_EXPIRATION_DATE | String | yyyyMMdd形式。未指定="99991231" |
| 認証失敗回数 | FAILED_COUNT | int | |
| 有効日(From) | EFFECTIVE_DATE_FROM | String | yyyyMMdd形式。未指定="19000101" |
| 有効日(To) | EFFECTIVE_DATE_TO | String | yyyyMMdd形式。未指定="99991231" |
| 最終ログイン日時 | LAST_LOGIN_DATE_TIME | Timestamp | |

> **注意**: 上記テーブルには本サンプルで必要な属性のみ列挙。導入プロジェクトでは必要なユーザ属性を追加するか、本テーブルと1対1で紐づくユーザ情報テーブルを作成すること。導入時はSQLファイル及びソースコードを導入プロジェクトのテーブル定義に合わせて修正すること。

<details>
<summary>keywords</summary>

PasswordAuthenticator, Sha256PasswordEncryptor, SystemAccount, Authenticator, PasswordEncryptor, AuthenticationException, AuthenticationFailedException, PasswordExpiredException, UserIdLockedException, SYSTEM_ACCOUNT, USER_ID, PASSWORD, USER_ID_LOCKED, PASSWORD_EXPIRATION_DATE, FAILED_COUNT, EFFECTIVE_DATE_FROM, EFFECTIVE_DATE_TO, LAST_LOGIN_DATE_TIME, クラス図, テーブル定義, 例外クラス

</details>

## 使用方法

**パスワード認証の特徴**:
- 認証時にアカウント情報の有効日（From/To）をチェック
- 認証時にパスワードの有効期限をチェック
- 連続で指定回数認証に失敗するとユーザIDをロック。認証成功で失敗回数をリセット
- 暗号化されたパスワードで認証（デフォルトはSHA256）
- 認証成功時のみシステム日時で最終ログイン日時を更新

**クラス**: `please.change.me.common.authentication.PasswordAuthenticator`

**設定例（XML）**:
```xml
<component name="authenticator" class="please.change.me.common.authentication.PasswordAuthenticator">
  <property name="failedCountToLock" value="3"/>
  <property name="passwordEncryptor">
    <component class="please.change.me.common.authentication.Sha256PasswordEncryptor"/>
  </property>
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="authenticator"/>
      <property name="connectionFactory" ref="connectionFactory"/>
      <property name="transactionFactory" ref="transactionFactory"/>
    </component>
  </property>
  <property name="businessDateProvider" ref="businessDateProvider" />
  <property name="systemTimeProvider" ref="systemTimeProvider" />
</component>
<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider" />
<component name="systemTimeProvider" class="nablarch.core.date.BasicSystemTimeProvider" />
```

**プロパティ**:

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| failedCountToLock | | 0 | ユーザIDをロックする認証失敗回数。0の場合ロック機能無効 |
| passwordEncryptor | | Sha256PasswordEncryptor | パスワードの暗号化に使用するPasswordEncryptor |
| dbManager | ○ | | `nablarch.core.db.transaction.SimpleDbTransactionManager`のインスタンス |
| systemTimeProvider | ○ | | `nablarch.core.date.SystemTimeProvider`実装クラス。最終ログイン日時の更新に使用 |
| businessDateProvider | ○ | | `nablarch.core.date.BusinessDateProvider`実装クラス。有効日とパスワード有効期限チェックに使用 |

> **警告**: PasswordAuthenticatorのトランザクション制御が個別アプリケーション処理に影響しないよう、個別アプリケーションとは別のトランザクションを設定すること。`dbTransactionName`に"authenticator"を設定している場合、個別アプリケーションで同じ名前を使用しないこと。

**使用例（Java）**:
```java
String userId = ...;
String password = ...;

try {
    // PasswordAuthenticatorはSystemRepositoryから事前に取得すること
    authenticator.authenticate(userId, password);
} catch (AuthenticationFailedException e) {
    // 認証に失敗した場合の処理
} catch (UserIdLockedException e) {
    // ユーザIDがロックされていた場合の処理
} catch (PasswordExpiredException e) {
    // パスワードの有効期限が切れていた場合の処理
}
```

細かくエラーを分けない場合は基底例外クラス`AuthenticationException`でまとめてcatchできる。

<details>
<summary>keywords</summary>

PasswordAuthenticator, Sha256PasswordEncryptor, failedCountToLock, passwordEncryptor, dbManager, systemTimeProvider, businessDateProvider, BasicBusinessDateProvider, BasicSystemTimeProvider, AuthenticationException, AuthenticationFailedException, PasswordExpiredException, UserIdLockedException, SimpleDbTransactionManager, SystemRepository, パスワード認証設定, ユーザIDロック, 有効期限チェック, トランザクション設定

</details>
