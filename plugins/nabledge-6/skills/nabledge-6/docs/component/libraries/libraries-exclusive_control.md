# 排他制御

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/exclusive_control.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/BasicExclusiveControlManager.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/ExclusiveControlContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/exclusivecontrol/HttpExclusiveControlUtil.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/compositekey/CompositeKey.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/exclusivecontrol/ExclusiveControlUtil.html)

## 機能概要

> **重要**: この機能は**非推奨**。排他制御には [universal_dao](libraries-universal_dao.md) を使用すること。理由: (1) [universal_dao](libraries-universal_dao.md) の排他制御の方が簡易（:ref:`universal_dao_jpa_optimistic_lock`、:ref:`universal_dao_jpa_pessimistic_lock` を参照）。(2) 主キーが非文字列型（charやvarchar以外）の場合、DBによっては型不一致でSQL実行時例外が発生する。この機能は主キーの値をすべて `java.lang.String` で保持しており、PostgreSQLなど暗黙の型変換を行わないDBでこの問題が発生する。

テーブルにバージョン番号カラムを定義することで楽観的ロック/悲観的ロックを実現。このカラムが定義されたテーブルを**排他制御用テーブル**と呼ぶ。

同一の排他制御用テーブルを使用するため、楽観的ロックと悲観的ロックを並行使用しても同一データの同時更新を防止できる。たとえば、楽観的ロックを使用するウェブと、悲観的ロックを使用するバッチを並行稼働させても、データの整合性を保つことができる。

実現できる機能:
- [exclusive_control-optimistic_lock](#)
- [exclusive_control-optimistic_lock-bulk](#)
- [exclusive_control-pessimistic_lock](#)

排他制御用テーブルは排他制御を行う単位ごとに定義し、競合が許容される最大の単位で定義する。単位を大きくすると競合可能性が高まり、更新失敗（楽観的ロック）や処理遅延（悲観的ロック）を招く。

> **補足**: 排他制御用テーブルの単位は業務的な観点（例：売上処理と入金処理に関連するテーブルをまとめた単位）やテーブルの親子関係（親の単位）で定義する。親子関係が明確でない場合は、どちらを親にするのが良いかを判断し、排他制御用テーブルを定義する。

> **重要**: 排他制御用テーブル設計後は更新順序を設計すること。更新順序を定めることでデッドロックを防止し、データ整合性を保証する。更新順序が未定義だとデッドロックが発生する可能性が非常に高い。

コンポーネント名 `exclusiveControlManager` で `BasicExclusiveControlManager` をコンポーネント定義に設定する。排他制御用テーブルごとに `ExclusiveControlContext` を継承したクラスを作成し、排他制御API呼び出しで使用する。

```xml
<component name="exclusiveControlManager"
           class="nablarch.common.exclusivecontrol.BasicExclusiveControlManager">
    <!-- 楽観ロックで排他エラーが発生した際に使用するメッセージID -->
    <property name="optimisticLockErrorMessageId" value="CUST0001" />
</component>
```

排他制御用テーブルごとに `ExclusiveControlContext` を継承したクラスを作成する。コンストラクタで `setTableName`、`setVersionColumnName`、`setPrimaryKeyColumnNames`、`appendCondition` を設定する。

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

排他制御, 楽観的ロック, 悲観的ロック, 排他制御用テーブル, 非推奨機能, exclusive_control-optimistic_lock, exclusive_control-pessimistic_lock, バージョン番号カラム, デッドロック防止, 更新順序, BasicExclusiveControlManager, ExclusiveControlContext, optimisticLockErrorMessageId, 排他制御セットアップ, exclusiveControlManager, setTableName, setVersionColumnName, setPrimaryKeyColumnNames, appendCondition

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

`HttpExclusiveControlUtil` を使用する。更新対象データ取得時にバージョン番号を取得し、更新時にバージョン番号が変更されていないかチェックすることで実現する。

入力→確認→完了がある更新機能を例に、楽観的ロックの実装例を示す。

| 画面操作 | API | 説明 |
|---|---|---|
| 入力画面の初期表示 | `HttpExclusiveControlUtil.prepareVersion(context, exclusiveControlContext)` | バージョン番号をExecutionContextに設定 |
| 確認ボタン（入力→確認） | `HttpExclusiveControlUtil.checkVersions(request, context)` | バージョン番号の更新チェック |
| 更新ボタン（確認→完了） | `HttpExclusiveControlUtil.updateVersionsWithCheck(request)` | バージョン番号チェックと更新 |

バージョン番号が更新されている場合は `OptimisticLockException` が送出されるため、`@OnErrors` / `@OnError` で遷移先を指定する。

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

nablarch-common-exclusivecontrol, nablarch-common-exclusivecontrol-jdbc, nablarch-fw-web-tag, モジュール設定, Maven依存関係, HttpExclusiveControlUtil, OptimisticLockException, ApplicationException, 楽観的ロック, prepareVersion, checkVersions, updateVersionsWithCheck, @OnError, @OnErrors

</details>

## 一括更新で楽観的ロックを行う

複数のレコードに対し特定のプロパティを一括更新するような処理で、選択されたレコードのみに楽観的ロックのチェックを行いたい場合に使用する。バージョン番号の準備には `HttpExclusiveControlUtil#prepareVersions` を呼び出す。

排他制御用テーブルの主キーが **複合主キーでない場合** と **複合主キーの場合** で実装方法が異なる。

**複合主キーでない場合**: チェック対象リクエストパラメータ名を指定して呼び出す。

```java
// チェックのみ
HttpExclusiveControlUtil.checkVersions(request, context, "user.deactivate");
// チェックと更新
HttpExclusiveControlUtil.updateVersionsWithCheck(request, "user.deactivate");
```

**複合主キーの場合**: リクエストパラメータで複合主キーを送る際は、区切り文字（**主キーの値にはなり得ない文字**）で結合した文字列を指定する。

```html
<input type="checkbox" name="user.userCompositeKeys" value="user001,pk2001,pk3001" />
<input type="checkbox" name="user.userCompositeKeys" value="user002,pk2002,pk3002" />
```

Form側では区切り文字を考慮してリクエストパラメータから主キーを取り出し、レコードごとに `checkVersion` / `updateVersionWithCheck` を呼び出す。

```java
// チェックのみ
User[] deletedUsers = form.getDeletedUsers();
for(User deletedUser : deletedUsers) {
    HttpExclusiveControlUtil.checkVersion(
        request, context,
        new UsersExclusiveControl(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
// チェックと更新
for(User deletedUser : deletedUsers) {
    HttpExclusiveControlUtil.updateVersionWithCheck(
        request, new ExclusiveUserCondition(deletedUser.getUserId(), deletedUser.getPk2(), deletedUser.getPk3()));
}
```

> **補足**: `CompositeKey` と複合主キー対応カスタムタグを使うと複合主キーをより簡単に扱える。詳細は :ref:`tag-composite_key` を参照。

<details>
<summary>keywords</summary>

HttpExclusiveControlUtil, CompositeKey, 一括更新排他制御, 複合主キー, prepareVersions, checkVersion, updateVersionWithCheck, checkVersions, updateVersionsWithCheck

</details>

## 悲観的ロックを行う

`ExclusiveControlUtil.updateVersion` で排他制御用テーブルのバージョン番号を更新し、トランザクションがコミット/ロールバックされるまで対象行をロックする。他のトランザクションはロック解除まで待機する。

```java
ExclusiveControlUtil.updateVersion(new UsersExclusiveControl("U00001"));
```

> **重要**: バッチ処理では、前処理でロック対象の主キーのみを取得し、本処理で1件ずつロックを取得してからデータ取得・更新すること。理由: (1) データ取得から更新の間に他プロセスによるデータ更新を防ぐ (2) ロック時間を短くし、並列処理への影響を最小化する。

<details>
<summary>keywords</summary>

ExclusiveControlUtil, 悲観的ロック, updateVersion, バージョン番号管理

</details>

## 拡張例

なし。

<details>
<summary>keywords</summary>

排他制御拡張, 拡張なし

</details>
