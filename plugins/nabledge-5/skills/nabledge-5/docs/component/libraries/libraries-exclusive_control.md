# 排他制御

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/exclusive_control.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/BasicExclusiveControlManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/ExclusiveControlContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/exclusivecontrol/HttpExclusiveControlUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/ExclusiveControlUtil.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/compositekey/CompositeKey.html)

## 機能概要

> **重要**: この機能は非推奨。排他制御には [universal_dao](libraries-universal_dao.md) を使用すること。理由: (1) [universal_dao](libraries-universal_dao.md) の排他制御の方が簡単に使用できる（:ref:`universal_dao_jpa_optimistic_lock`、:ref:`universal_dao_jpa_pessimistic_lock` 参照）(2) 主キーが非文字列型の場合、DBによっては型不一致でSQL実行時例外が発生する（例: PostgreSQLのように暗黙の型変換が行われないDB）

テーブルにバージョン番号カラムを定義することで楽観的ロック/悲観的ロックを実現する。バージョン番号カラムが定義されたテーブルを**排他制御用テーブル**と呼ぶ。

提供機能:
- [exclusive_control-optimistic_lock](#)
- [exclusive_control-optimistic_lock-bulk](#)
- [exclusive_control-pessimistic_lock](#)

楽観的ロックと悲観的ロックは同じ排他制御用テーブルを使用するため、並行使用しても同一データの同時更新を防げる。

排他制御用テーブルは、排他制御を行う単位ごとに定義し、**競合が許容される最大の単位で定義する**。単位を大きくすると競合可能性が高まり、楽観的ロックの場合は更新失敗、悲観的ロックの場合は処理遅延を招く。

> **補足**: 排他制御用テーブルの単位は業務的な観点で定義する（例: 売上処理と入金処理に関連するテーブルをまとめた単位）。テーブルの親子関係が明確な場合は親の単位で定義する。親子関係が明確でない場合は、どちらを親にするのが良いかを判断し、排他制御用テーブルを定義する。

> **重要**: 排他制御用テーブル設計後、更新順序を設計すること。データベースではレコードを更新すると行ロックがかかるため、更新順序を定めないとデッドロックが発生する可能性が非常に高くなる。

## 排他制御を使うために準備する

**設定**: `BasicExclusiveControlManager` をコンポーネント名 `exclusiveControlManager` で定義する。

```xml
<component name="exclusiveControlManager"
           class="nablarch.common.exclusivecontrol.BasicExclusiveControlManager">
    <property name="optimisticLockErrorMessageId" value="CUST0001" />
</component>
```

| プロパティ名 | 説明 |
|---|---|
| optimisticLockErrorMessageId | 楽観ロック排他エラー時のメッセージID |

**排他制御コンテキストクラスの作成**: `ExclusiveControlContext` を継承して排他制御用テーブルごとに作成する。コンストラクタで `setTableName`・`setVersionColumnName`・`setPrimaryKeyColumnNames`（Enumで主キー列定義）・`appendCondition`（主キー値設定）を呼び出す。

```sql
CREATE TABLE USERS (
    USER_ID CHAR(6) NOT NULL,
    VERSION NUMBER(10) NOT NULL,
    PRIMARY KEY (USER_ID)
)
```

```java
public class UsersExclusiveControl extends ExclusiveControlContext {
    private enum PK { USER_ID }
    public UsersExclusiveControl(String userId) {
        setTableName("USERS");
        setVersionColumnName("VERSION");
        setPrimaryKeyColumnNames(PK.values());
        appendCondition(PK.USER_ID, userId);
    }
}
```

<details>
<summary>keywords</summary>

楽観的ロック, 悲観的ロック, 排他制御, 排他制御用テーブル, バージョン番号カラム, 非推奨, デッドロック防止, 更新順序, 行ロック, 競合が許容される最大の単位, BasicExclusiveControlManager, ExclusiveControlContext, optimisticLockErrorMessageId, 排他制御の設定, バージョン番号管理

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-exclusivecontrol</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-exclusivecontrol-jdbc</artifactId>
</dependency>

<!-- 楽観的ロックを行う場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>
```

## 楽観的ロックを行う

`HttpExclusiveControlUtil` を使用する。入力→確認→完了の画面遷移での実装:

1. **入力画面初期表示**: `HttpExclusiveControlUtil.prepareVersion(context, new UsersExclusiveControl(userId))` でバージョン番号を取得しExecutionContextに設定する
2. **確認ボタン（入力→確認）**: `HttpExclusiveControlUtil.checkVersions(request, context)` でバージョン番号の更新チェック。バージョン変更時は `OptimisticLockException` がスローされる（`@OnError` で遷移先を指定）
3. **更新ボタン（確認→完了）**: `HttpExclusiveControlUtil.updateVersionsWithCheck(request)` でチェックと更新を同時実行

```java
@OnErrors({
    @OnError(type = ApplicationException.class, path = "/input.jsp"),
    @OnError(type = OptimisticLockException.class, path = "/error.jsp")
})
public HttpResponse confirm(HttpRequest request, ExecutionContext context) {
    HttpExclusiveControlUtil.checkVersions(request, context);
    // ...
}
```

> **重要**: `HttpExclusiveControlUtil.checkVersions` を呼び出さないと、画面間でバージョン番号が引き継がれない。

<details>
<summary>keywords</summary>

nablarch-common-exclusivecontrol, nablarch-common-exclusivecontrol-jdbc, nablarch-fw-web-tag, モジュール依存関係, Maven, HttpExclusiveControlUtil, OptimisticLockException, 楽観的ロック, @OnError, @OnErrors

</details>

## 一括更新で楽観的ロックを行う

## 一括更新で楽観的ロックを行う

選択されたレコードのみに楽観的ロックのチェックを行いたい場合、主キーが複合主キーかどうかで実装方法が異なる。

**バージョン番号の準備**: 両ケースとも、入力画面の初期表示時に `HttpExclusiveControlUtil#prepareVersions` を呼び出してバージョン番号を取得する（複合主キーの有無によらず実装は同様のため省略）。

**複合主キーでない場合**: リクエストパラメータ名を指定してチェック/更新対象を絞り込む。

```html
<!-- リクエストパラメータ "user.deactivate" でユーザの主キーを送る -->
<td><checkbox name="user.deactivate" value="user001" /></td>
```

```java
// チェックのみ
HttpExclusiveControlUtil.checkVersions(request, context, "user.deactivate");
// チェックと更新
HttpExclusiveControlUtil.updateVersionsWithCheck(request, "user.deactivate");
```

**複合主キーの場合**: 複合主キー用の `ExclusiveControlContext` 実装クラスを作成する。単一主キーの場合と同様に継承して作成するが、Enumに複数の主キー列を定義し、コンストラクタで各主キーの値を `appendCondition` で設定する。

```sql
-- 複合主キーが定義されたテーブル
CREATE TABLE USERS (
    USER_ID CHAR(6) NOT NULL,
    PK2     CHAR(6) NOT NULL,
    PK3     CHAR(6) NOT NULL,
    VERSION NUMBER(10) NOT NULL,
    PRIMARY KEY (USER_ID,PK2,PK3)
)
```

```java
// 排他制御用テーブルUSERSに対応したクラス
public class UsersExclusiveControl extends ExclusiveControlContext {
    // 排他制御用テーブルの主キーは列挙型で定義する
    private enum PK { USER_ID, PK2, PK3 }

    // 主キーの値をとるコンストラクタを定義し、親クラスのメソッドで必要な情報を設定する
    public UsersExclusiveControl(String userId, String pk2, String pk3) {
        setTableName("USERS");
        setVersionColumnName("VERSION");
        setPrimaryKeyColumnNames(PK.values());
        appendCondition(PK.USER_ID, userId);
        appendCondition(PK.PK2, pk2);
        appendCondition(PK.PK3, pk3);
    }
}
```

区切り文字（任意だが主キーの値にはなり得ない文字）で結合した文字列として主キーをリクエストパラメータに指定し、レコードごとにループして呼び出す。

```html
<!--
  複合主キーは区切り文字（任意、ただし主キーの値にはなり得ないこと）で
  結合した文字列をリクエストパラメータに指定する。
-->
<input type="checkbox" name="user.userCompositeKeys" value="user001,pk2001,pk3001" />
```

```java
// Formに区切り文字を考慮した主キー取り出し処理を実装
User[] deletedUsers = form.getDeletedUsers();

// チェックのみ
for (User deletedUser : deletedUsers) {
    HttpExclusiveControlUtil.checkVersion(
        request, context,
        new UsersExclusiveControl(deletedUser.getUserId(),
                                  deletedUser.getPk2(),
                                  deletedUser.getPk3()));
}
// チェックと更新
for (User deletedUser : deletedUsers) {
    HttpExclusiveControlUtil.updateVersionWithCheck(
        request, new ExclusiveUserCondition(deletedUser.getUserId(),
                                            deletedUser.getPk2(),
                                            deletedUser.getPk3()));
}
```

> **補足**: `CompositeKey` と複合主キー対応カスタムタグを使うと複合主キーをより簡単に扱える。詳細は :ref:`tag-composite_key` を参照。

<details>
<summary>keywords</summary>

HttpExclusiveControlUtil, prepareVersions, 一括更新排他制御, 複合主キー排他制御, CompositeKey

</details>

## 悲観的ロックを行う

## 悲観的ロックを行う

`ExclusiveControlUtil.updateVersion` を使用する。バージョン番号を更新することで、トランザクションのコミット/ロールバックまで対象行がロックされ、他のトランザクションの更新処理はロック解除まで待機する。

```java
ExclusiveControlUtil.updateVersion(new UsersExclusiveControl("U00001"));
```

> **重要**: バッチ処理では、(1) 前処理でロック対象の主キーのみ取得、(2) 本処理で1件ずつロック取得→データ取得→更新、の順で実装する。理由: (1) データ取得後〜更新前に他プロセスによる更新を防ぐため、(2) ロック時間を短くして並列処理への影響を最小化するため。

<details>
<summary>keywords</summary>

ExclusiveControlUtil, 悲観的ロック, バッチ悲観的ロック

</details>

## 拡張例

なし

<details>
<summary>keywords</summary>

拡張例, 排他制御カスタマイズ

</details>
