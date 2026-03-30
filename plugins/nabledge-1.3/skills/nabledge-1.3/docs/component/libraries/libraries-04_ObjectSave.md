# オブジェクトのフィールドの値のデータベースへの登録機能(オブジェクトのフィールド値を使用した検索機能)

## 

SQL文のバインド変数には「?」ではなく、名前付きの変数名を記述する必要がある。

```sql
-- JDBC標準機能の場合
INSERT INTO USER_MTR
VALUES (?, ?, ?, ?)

-- 本機能を使用した場合
INSERT INTO USER_MTR
VALUES (:userId, :userName, :userNameKana, :tel)

-- 部分一致検索の「%」を使用した場合
SELECT USER_NAME
  FROM USER_MTR
 WHERE USER_NAME LIKE :userName%

-- 可変条件を定義できる。
SELECT USER_NAME
  FROM USER_MTR
 WHERE $if(userName) {USER_NAME LIKE :userName%}
```

## a) SqlParameterParserFactory 実装クラス

**クラス**: `nablarch.core.db.statement.BasicSqlParameterParserFactory`
- `BasicSqlParameterParser` を生成する `SqlParameterParserFactory` の基本実装。

## b) SqlParameterParser 実装クラス

**クラス**: `nablarch.core.db.statement.BasicSqlParameterParser`

名前付きバインド変数はコロン(`:`)で始まり、英数字・アンダースコア(`_`)・パーセント(`%`)で構成。

**LIKE検索パターン**:
- 前方一致: バインド変数名末尾に`%` 例: `:userName%`
- 後方一致: バインド変数名先頭に`%` 例: `:%userName`
- 部分一致: バインド変数名前後に`%` 例: `:%userName%`

> **警告**: 後方・部分一致検索はインデックスが使用されずテーブルフルスキャンとなり、極端な性能劣化が発生する。顧客要件で回避不可能な場合のみ、顧客と合意の上で使用すること。

Nablarch拡張構文（JDBC標準SQLに変換）。デフォルトでは下記の拡張構文を変換する:
- 可変条件構文
- 可変IN構文
- 可変ORDER BY構文

## c) SqlConvertor 実装クラス

**クラス**: `nablarch.core.db.statement.sqlconvertor.SqlConvertorSupport`
- SQL変換クラスのサポートクラス。バインド変数に対応するフィールドの値取得機能を提供。

**クラス**: `nablarch.core.db.statement.sqlconvertor.VariableConditionSyntaxConvertor`

可変条件構文 `$if(フィールド名) {SQL条件}` をJDBC実行用SQLに変換する。

- フィールド値がnull・空文字列以外（配列はサイズ1以上）の場合: `(0 = 1 OR (条件))` → 条件が有効
- フィールド値がnull・空文字列（配列はサイズ0）の場合: `(0 = 0 OR (条件))` → 条件が無効

> **警告**: `$if`構文が使用できるのはWHERE句のみ。`$if`のネストは不可。SELECT句での使用や`$if`のネストは不正なSQL文が生成されSQL実行時エラーとなる。

```java
// 使用例
String sql = "SELECT USER_ID FROM USER_MTR WHERE "
    + "$if (userName) {USER_NAME = :user_name} "
    + "AND $if (userKbn) {USER_KBN IN ('1', '2')}";

// NG: SELECT句での$if使用
"SELECT $if (user) {:user} FROM USER_MTR"

// NG: $ifのネスト
"SELECT USER_ID FROM USER_MTR WHERE $if (user) {USER = :user $if(userId) {USER_ID = :userId}}"
```

**クラス**: `nablarch.core.db.statement.sqlconvertor.VariableInSyntaxConvertor`

IN句の条件を動的生成する。バインド変数名の末尾を`[]`で終わらせること。対応フィールドのデータ型は配列またはCollectionであること。

> **警告**: IN句拡張構文では検索条件オブジェクトにMapインタフェース実装クラスを指定できない。Mapは値の型情報がないため、IN句構築時に配列/Collectionであることのチェックが確実に行えないため。

> **警告**: IN句のバインド変数に対応する配列（Collection）がnullや要素数0になる可能性がある場合は、必ず可変条件と組み合わせて使用すること。可変条件なしでサイズ0/nullを設定すると条件が`IN (null)`となり想定データが取得できない。

> **警告**: IN句用のバインド変数（`[]`終わり）をIN句以外の箇所に指定しないこと。IN句以外に指定すると不正なSQL文が生成されSQL実行時エラーとなる。不正例: `USER_ID = :userId[]` → `USER_ID = ?, ?`

> **注意**: IN句の条件数はデータベースベンダーによって上限がある。各アプリケーションでこの上限を超えないよう設計すること。

```java
public class UserSearchCondition {
    private List userKbn;  // 配列またはCollectionで宣言
}
String sql = "SELECT USER_ID FROM USER_MTR WHERE "
    + "$if (userKbn) {USER_KBN IN (:userKbn[])}";
// ['1','2']のList → (0 = 1 OR (USER_KBN IN (?, ?)))
// サイズ0のList → (0 = 0 OR (USER_KBN IN (?))) ※nullが設定される
```

**SQL解析制約**:
- リテラル部分に名前付きバインド変数と同じ形式の文字列が記述されていてもバインド変数として扱わない。
- リテラル文字はシングルクォート(`'`)で囲われている。
- リテラル文字のエスケープ文字はシングルクォート(`'`)である。
- SQL文にコメントが存在しない。

> **警告**: 本クラスではSQL文の妥当性のチェックは行わない。不正な構文のSQL文があった場合、SQL実行時に例外が発生する。

**クラス**: `nablarch.core.db.statement.sqlconvertor.VariableOrderBySyntaxConvertor`

可変ORDER BY構文 `$sort(フィールド名) {(ソートID ケース本体)...}` をORDER BY句に変換する。

- ソートIDに半角スペース使用不可。ケース本体には半角スペース使用可。
- デフォルトケースにはソートIDに`default`を指定。
- フィールド値と一致するソートIDのケース本体をORDER BY句に使用。
- 一致するケースなし＋デフォルトあり → デフォルトのケース本体を使用。
- 一致するケースなし＋デフォルトなし → 可変ORDER BY構文を削除したSQL文を返す。

> **警告**: SQL文の妥当性チェックは行わない。不正な構文のSQL文があった場合、SQL実行時に例外が発生する。

```java
String sql = "SELECT USER_ID, USER_NAME FROM USER_MTR WHERE USER_NAME = :user_name "
    + "$sort(sortId) {(1 USER_ID ASC) (2 USER_ID DESC) (3 USER_NAME ASC) (4 USER_NAME DESC) (default USER_ID)}";
// sortId=null → ORDER BY USER_ID (デフォルト使用)
// sortId="1"  → ORDER BY USER_ID ASC
// sortId="5"  → ORDER BY USER_ID (デフォルト使用)
```

## d) AutoPropertyHandler 実装クラス

**クラス**: `nablarch.core.db.statement.autoproperty.FieldAnnotationHandlerSupport`
- フィールドのアノテーション情報を元に値を設定するクラスのサポートクラス。

**クラス**: `nablarch.core.db.statement.autoproperty.CurrentDateTimeAnnotationHandler`

`@CurrentDateTime` アノテーションが設定されたフィールドにシステム日時を設定する。

| フィールドのデータ型 | 設定方法 |
|---|---|
| `java.sql.Date` | システム日時を`java.sql.Date`に変換して設定 |
| `Timestamp` | システム日時を`java.sql.Timestamp`に変換して設定 |
| `Time` | システム日時を`java.sql.Time`に変換して設定 |
| `String`, `Integer`, `Long` | `CurrentDateTime`の`format`プロパティの値で`SimpleDateFormat`を使用してフォーマット。`format`未指定時は設定ファイルのデフォルトフォーマットを使用 |

> **注意**: システム日時はシステム日時機能を使用して取得する。

**クラス**: `nablarch.core.db.statement.autoproperty.UserIdAnnotationHandler`

`@UserId` アノテーションが設定されたフィールドにユーザIDを設定する。ユーザIDはThreadContextから取得する。

> **注意**: ThreadContextに設定されるユーザIDについてはThreadContextの設定を参照。

**クラス**: `nablarch.core.db.statement.autoproperty.RequestIdAnnotationHandler`

`@RequestId` アノテーションが設定されたフィールドにリクエストIDを設定する。リクエストIDはThreadContextから取得する。

> **注意**: ThreadContextに設定されるリクエストIDについてはThreadContextの設定を参照。

## e) フィールド値をDBに登録するためのクラス

**クラス**: `nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader`

オブジェクトに定義されたフィールド情報とアノテーション情報をロードする。ロードした値はSQL文のバインド変数セット時に使用される。ロードした値はStaticDataCacheを使用してキャッシュされるため、同一クラスへのフィールド情報取得処理が複数回実行されない。リフレクションのコストを軽減し性能劣化を防止する。

オブジェクトのフィールドの値をデータベースに登録する場合のシーケンスと実装例を示す。

<details>
<summary>keywords</summary>

名前付きバインド変数, SQL文バインド変数, 可変条件, 部分一致検索, 名前付き変数, BasicSqlParameterParserFactory, BasicSqlParameterParser, SqlConvertorSupport, VariableConditionSyntaxConvertor, VariableInSyntaxConvertor, VariableOrderBySyntaxConvertor, FieldAnnotationHandlerSupport, CurrentDateTimeAnnotationHandler, UserIdAnnotationHandler, RequestIdAnnotationHandler, FieldAndAnnotationLoader, @CurrentDateTime, @UserId, @RequestId, SQL解析, LIKE検索, 可変条件構文, 可変IN構文, 可変ORDER BY構文, 自動プロパティ設定, バインド変数, $if, $sort, オブジェクトフィールド値のDB登録, 使用例, 処理シーケンス概要

</details>

## クラス図

![クラス図](../../../knowledge/component/libraries/assets/libraries-04_ObjectSave/DbAccessSpec_ObjectStatementClassDesign.jpg)

処理シーケンス（オブジェクトのフィールド値をDBに登録する場合）:

![処理シーケンス図](../../../knowledge/component/libraries/assets/libraries-04_ObjectSave/DbAccessSpec_ObjectStatementSequence.jpg)

1. 登録対象オブジェクトを生成し、必要な情報を設定する。`@UserId`・`@CurrentDateTime` アノテーションが設定されているフィールドには値を設定不要。
2. `AppDbConnection#prepareParameterizedSqlStatement` でSQL文実行用statementを取得する。SQL文のバインド変数はJDBC標準の`?`ではなく名前付き変数名(`:`+フィールド名)で記述する。`BasicSqlParameterParser` が解析しJDBC標準へ変換: (1) `?`に置換したSQL文、(2) `?`に対応するバインド変数名リスト。仕様が不十分な場合は [SqlParameterParser](#) の実装クラスを追加して置き換えること。参照: :ref:`BasicSqlParameterParserの概要<basic-sql-parameter-parser-label>`
3. `BasicSqlPStatement#executeUpdateByObject` でオブジェクトのフィールド値を登録する。
4. オブジェクトのフィールドに自動設定値が設定される:

| アノテーション | ハンドラ | 設定内容 |
|---|---|---|
| `@UserId` | `UserIdAnnotationHandler` | ユーザID |
| `@CurrentDateTime` | `CurrentDateTimeAnnotationHandler` | システム日時 |
| `@RequestId` | `RequestIdAnnotationHandler` | リクエストID |

自動設定値の取得元は [AutoPropertyHandlerの実装クラスのクラス概要](#) を参照。

5. SQL文を実行する。バインド変数への設定は `PreparedStatement#setObject` を使用。フィールドの値が不正（DBへ登録できない値）の場合はSQL実行時例外が発生する。

> **注意**: ハンドラクラスの追加・変更により、各プロジェクトで作成したアノテーションやカラム名で自動設定項目を判断できる。

<details>
<summary>keywords</summary>

クラス図, オブジェクトフィールド値登録, クラス設計, DbAccessSpec_ObjectStatementClassDesign, AppDbConnection, prepareParameterizedSqlStatement, BasicSqlPStatement, executeUpdateByObject, BasicSqlParameterParser, @UserId, @CurrentDateTime, @RequestId, UserIdAnnotationHandler, CurrentDateTimeAnnotationHandler, RequestIdAnnotationHandler, PreparedStatement, 名前付きバインド変数, 自動設定アノテーション, オブジェクトフィールド値DB登録

</details>

## インタフェース定義

**インタフェース** (`nablarch.core.db.statement` パッケージ)

| インタフェース名 | 概要 |
|---|---|
| `SqlParameterParserFactory` | 名前付きバインド変数をもつSQL文を解析するためのオブジェクト(SqlParameterParser)を取得するインタフェース |
| `SqlParameterParser` | SQL文を解析し、`java.sql.PreparedStatement`で実行できる形式のSQL文（バインド変数を「?」に置き換えたSQL文）と名前付きバインド変数のListを取得するインタフェース |
| `SqlConvertor` | SQL文の変換を行うインタフェース |
| `AutoPropertyHandler` | オブジェクトの自動設定項目のフィールドに値を設定するインタフェース。フィールドのアノテーションやフィールド名等を元に値を自動設定する |

**アノテーション**: `@CurrentDateTime`, `@UserId`, `@RequestId`

```java
// Entityクラス実装例
public class MyEntity {
    private String cstId;
    private long kingaku;
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String insDateTime;
    @UserId
    private String insUserId;
    @CurrentDateTime(format="yyyyMMddHHmmss")
    private String updDateTime;
    @UserId
    private String updUserId;
    @RequestId
    private String requestId;
}

// 自動設定項目以外を設定してDB登録
MyEntity entity = new MyEntity();
entity.setCstId("1000000001");
entity.setKingaku(1000);

AppDbConnection perCon = DbConnectionContext.getConnection();

// バインド変数は「:」+「フィールド名」で記述すること（「?」ではなく）
ParameterizedSqlPStatement insert = perCon.prepareParameterizedSqlStatement(
    "INSERT INTO MY_TABLE (CST_ID, KINGAKU, INS_DATE_TIME, INS_USER_ID, UPD_DATE_TIME, UPD_USER_ID, EXECUTION_ID, REQUEST_ID)"
  + " VALUES (:cstId, :kingaku, :insDateTime, :insUserId, :updDateTime, :updUserId, :executionId, :requestId)");
insert.executeUpdateByObject(entity);
```

> **注意**: SQL文の外部化を推奨。外部化した場合の実装例は [sql-gaibuka-label](libraries-04_Statement.md) を参照。

<details>
<summary>keywords</summary>

SqlParameterParserFactory, SqlParameterParser, SqlConvertor, AutoPropertyHandler, 名前付きバインド変数解析, インタフェース定義, ParameterizedSqlPStatement, AppDbConnection, DbConnectionContext, executeUpdateByObject, @CurrentDateTime, @UserId, @RequestId, Java実装例, オブジェクトフィールド値登録

</details>

## 設定内容詳細

**クラス**: `nablarch.core.db.statement.BasicStatementFactory`, `nablarch.core.db.statement.BasicSqlParameterParserFactory`, `nablarch.core.db.statement.sqlconvertor.VariableConditionSyntaxConvertor`, `nablarch.core.db.statement.sqlconvertor.VariableInSyntaxConvertor`, `nablarch.core.db.statement.sqlconvertor.VariableOrderBySyntaxConvertor`, `nablarch.core.db.statement.autoproperty.CurrentDateTimeAnnotationHandler`, `nablarch.core.db.statement.autoproperty.UserIdAnnotationHandler`, `nablarch.core.db.statement.autoproperty.RequestIdAnnotationHandler`, `nablarch.core.cache.BasicStaticDataCache`, `nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader`, `nablarch.core.date.BasicSystemTimeProvider`, `nablarch.core.repository.initialization.BasicApplicationInitializer`

設定ファイル例:

```xml
<component name="statementFactory" class="nablarch.core.db.statement.BasicStatementFactory">
    <property name="sqlParameterParserFactory">
        <component class="nablarch.core.db.statement.BasicSqlParameterParserFactory">
            <property name="sqlConvertors">
                <list>
                    <component class="nablarch.core.db.statement.sqlconvertor.VariableConditionSyntaxConvertor">
                        <property name="allowArrayEmptyString" value="false" />
                    </component>
                    <component class="nablarch.core.db.statement.sqlconvertor.VariableInSyntaxConvertor" />
                    <component class="nablarch.core.db.statement.sqlconvertor.VariableOrderBySyntaxConvertor" />
                </list>
            </property>
        </component>
    </property>
    <property name="objectFieldCache" ref="fieldAnnotationCache"/>
    <property name="updatePreHookObjectHandlerList">
        <list>
            <component class="nablarch.core.db.statement.autoproperty.CurrentDateTimeAnnotationHandler">
                <property name="dateFormat" value="yyyyMMdd"/>
                <property name="fieldAnnotationCache" ref="fieldAnnotationCache"/>
                <property name="dateProvider">
                    <component class="nablarch.core.date.BasicSystemTimeProvider"/>
                </property>
            </component>
            <component class="nablarch.core.db.statement.autoproperty.UserIdAnnotationHandler">
                <property name="fieldAnnotationCache" ref="fieldAnnotationCache"/>
            </component>
            <component class="nablarch.core.db.statement.autoproperty.RequestIdAnnotationHandler">
                <property name="fieldAnnotationCache" ref="fieldAnnotationCache"/>
            </component>
        </list>
    </property>
    <property name="likeEscapeChar" value="\"/>
    <property name="likeEscapeTargetCharList" value="%,％,_,＿"/>
</component>

<component name="fieldAnnotationCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader">
        <component class="nablarch.core.statement.autoproperty.FieldAndAnnotationLoader"/>
    </property>
    <property name="loadOnStartup" value="false"/>
</component>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="fieldAnnotationCache"/>
        </list>
    </property>
</component>
```

**a) BasicStatementFactory プロパティ:**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `sqlParameterParserFactory` | ○ | `nablarch.core.db.statement.SqlParameterParserFactory` 実装クラスを設定。通常は `BasicSqlParameterParserFactory` |
| `objectFieldCache` | ○ | `nablarch.core.cache.StaticDataCache` 実装クラスを設定 |
| `updatePreHookObjectHandlerList` | ○ | `nablarch.core.ObjectHandler` 実装クラスのリストを設定。提供クラス: `CurrentDateTimeAnnotationHandler`, `UserIdAnnotationHandler`, `RequestIdAnnotationHandler` |
| `likeEscapeChar` | ○ | LIKE条件エスケープ文字。未設定時デフォルトは `\`。設定値は `likeEscapeTargetCharList` 未設定でも自動エスケープされる |
| `likeEscapeTargetCharList` | ○ | LIKE条件でエスケープ必要な文字をカンマ区切りで設定。未設定時デフォルトは `%`, `_` |

**a)-1. BasicSqlParameterParserFactory プロパティ:**

| プロパティ名 | 説明 |
|---|---|
| `sqlConvertors` | `SqlConvertor` 実装クラスのリストを設定。省略時デフォルト: `VariableConditionSyntaxConvertor`, `VariableInSyntaxConvertor`, `VariableOrderBySyntaxConvertor` |

**a)-2. VariableConditionSyntaxConvertor プロパティ:**

| プロパティ名 | 説明 |
|---|---|
| `allowArrayEmptyString` | 配列(Collection)の要素数が1でその値が空文字列またはnullの場合に条件に含めるか否か。`false`設定時は`(0 = 0) or`条件を付加して除外。省略時デフォルトは`true` |

> **注意**: 画面アプリケーションでは`allowArrayEmptyString`を`false`に設定すること。リクエストパラメータのキーが存在して値が空文字列の場合、精査後オブジェクトの配列サイズは1・値は空文字列となり、$if構文の条件を除外するのが正しい動作となるため。バッチ処理では条件配列に要素が存在する場合は必ず条件に含める必要があるため`true`（デフォルト値）を設定すること。

**b)-1. CurrentDateTimeAnnotationHandler プロパティ:**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `dateFormat` | ○ | デフォルト日付フォーマット。`java.text.SimpleDateFormat` 準拠 |
| `dateProvider` | ○ | システム日付取得クラス。通常は `nablarch.core.date.BasicSystemTimeProvider` |
| `fieldAnnotationCache` | ○ | `nablarch.core.cache.StaticDataCache` 実装クラスを設定 |

**b)-2. UserIdAnnotationHandler / b)-3. RequestIdAnnotationHandler プロパティ:**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `fieldAnnotationCache` | ○ | `nablarch.core.cache.StaticDataCache` 実装クラスを設定 |

**b)-4. BasicStaticDataCache (`fieldAnnotationCache`) プロパティ** (`FieldAnnotationHandlerSupport` のサブクラスである `CurrentDateTimeAnnotationHandler` や `UserIdAnnotationHandler` などから参照される):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| `loader` | ○ | `nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader` を設定 |

> **重要**: `loader` には必ず `nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader` を設定すること。使用クラスと密結合であるため。本来はこの設定は不変であるため設定ファイルに記述する必要はないが、`StaticDataCache` の実装クラスである `BasicStaticDataCache` を置き換える可能性があるため設定ファイルに記述している。

> **重要**: `BasicStatementFactory`, `CurrentDateTimeAnnotationHandler`, `UserIdAnnotationHandler`, `RequestIdAnnotationHandler` は同一の `BasicStaticDataCache` をref属性で参照すること。別々のキャッシュを設定した場合、同一情報が別々のメモリにキャッシュされ不必要なメモリ消費が発生し、メモリ不足によりシステムに重大な影響を与える可能性がある。

**c) initializer の設定:**
本機能で使用する `BasicStaticDataCache` を初期化する設定を行う（`nablarch.core.repository.initialization.BasicApplicationInitializer` を使用）。詳細は [../02_Repository](libraries-02_Repository.md) を参照。

<details>
<summary>keywords</summary>

BasicStatementFactory, BasicSqlParameterParserFactory, VariableConditionSyntaxConvertor, VariableInSyntaxConvertor, VariableOrderBySyntaxConvertor, CurrentDateTimeAnnotationHandler, UserIdAnnotationHandler, RequestIdAnnotationHandler, BasicStaticDataCache, FieldAndAnnotationLoader, BasicSystemTimeProvider, BasicApplicationInitializer, FieldAnnotationHandlerSupport, sqlParameterParserFactory, objectFieldCache, updatePreHookObjectHandlerList, likeEscapeChar, likeEscapeTargetCharList, allowArrayEmptyString, dateFormat, fieldAnnotationCache, dateProvider, loader, 自動設定値, LIKE条件エスケープ, キャッシュ共有

</details>
