# オブジェクトのフィールドの値のデータベースへの登録機能(オブジェクトのフィールド値を使用した検索機能)

**公式ドキュメント**: [オブジェクトのフィールドの値のデータベースへの登録機能(オブジェクトのフィールド値を使用した検索機能)]()

## 

SQL文のバインド変数には `?` ではなく名前付き変数名（`:変数名`）を記述する必要がある。

```sql
-- 名前付き変数を使用した INSERT
INSERT INTO USER_MTR
VALUES (:userId, :userName, :userNameKana, :tel)

-- 部分一致検索（% はそのまま記述可能）
SELECT USER_NAME
  FROM USER_MTR
 WHERE USER_NAME LIKE :userName%

-- 可変条件（条件が存在する場合のみ WHERE 句に追加）
SELECT USER_NAME
  FROM USER_MTR
 WHERE $if(userName) {USER_NAME LIKE :userName%}
```

## クラス定義

### a) SqlParameterParserFactory実装クラス (`nablarch.core.db.statement`パッケージ)

| クラス名 | 概要 |
|---|---|
| `BasicSqlParameterParserFactory` | BasicSqlParameterParserを生成するSqlParameterParserFactoryの基本実装クラス |

### b) SqlParameterParser実装クラス (`nablarch.core.db.statement`パッケージ)

**クラス**: `BasicSqlParameterParser`

SQL文の解析およびJDBC実行用SQL文への変換処理ルール:

- 名前付きバインド変数はコロン(`:`)で開始され、英数字・アンダースコア(`_`)・パーセント(`%`)で構成される
- LIKE検索パターン:
  - 前方一致: バインド変数名末尾に`%`を付加 (例: `:userName%`)
  - 後方一致: バインド変数名先頭に`%`を付加 (例: `:%userName`)
  - 部分一致: バインド変数名前後に`%`を付加 (例: `:%userName%`)

> **警告**: 後方・部分一致検索はインデックスが使用されずテーブルフルスキャンとなり、極端な性能劣化が発生する。顧客要件で回避不可能な場合にのみ、顧客と合意の上で使用すること。

デフォルトで変換する拡張構文:
- :ref:`可変条件構文<variable_condition_syntax_convertor-label>`
- :ref:`可変IN構文<variable_in_syntax_convertor-label>`
- :ref:`可変ORDER BY構文<variable_order_by_syntax_convertor-label>`

### c) SqlConvertor実装クラス (`nablarch.core.db.statement.sqlconvertor`パッケージ)

| クラス名 | 概要 |
|---|---|
| `SqlConvertorSupport` | SQL文変換クラスをサポートするクラス。バインド変数に対応するフィールドの値を取得する機能を提供 |
| `VariableConditionSyntaxConvertor` | SQL文の可変条件構文を変換するクラス |
| `VariableInSyntaxConvertor` | SQL文の可変IN構文を変換するクラス |
| `VariableOrderBySyntaxConvertor` | SQL文の可変ORDER BY構文を変換するクラス |

#### VariableConditionSyntaxConvertor

可変条件は `$if(フィールド名) {SQL文の条件}` 形式で記述する。

- フィールド値がnullでも空文字列でもない場合（配列の場合はサイズ1以上）: `(0 = 1 OR (条件))` に変換→条件が評価される
- フィールド値がnullまたは空文字列の場合（配列の場合はサイズ0）: `(0 = 0 OR (条件))` に変換→条件が評価されない

> **警告**: `$if`構文が使用できる箇所はWHERE句のみ。SELECT句などその他の箇所で使用した場合は不正なSQL文が生成される。また`$if`のネストも不可。これらの誤った使い方をした場合はSQL実行時エラーとなる。

```java
public class UserMtr {
    private String userName;
    private String userKbn;
}

String sql =
      "SELECT USER_ID, USER_NAME, USER_KBN "
    + "FROM USER_MTR "
    + "WHERE "
    + "$if (userName) {USER_NAME = :user_name} "
    + "AND $if (userKbn) {USER_KBN IN ('1', '2')}";
// UserMtr#userNameがnull・空文字列以外の場合: "USER_NAME = :user_name" が有効な条件となる
// UserMtr#userKbnがnull・空文字列以外の場合: "USER_KBN IN ('1', '2')" が有効な条件となる
```

#### VariableInSyntaxConvertor

IN句の条件部分を動的に生成する場合、バインド変数名の末尾を`[]`で終わらせる。

- IN句バインド変数に対応するフィールドは配列またはCollectionとして定義すること
- 配列(Collection)の要素数がIN句の条件数となる

```java
public class UserSearchCondition {
    private List userKbn;
}

String sql =
      "SELECT USER_ID, USER_NAME, USER_KBN "
    + "FROM USER_MTR "
    + "WHERE $if (userKbn) {USER_KBN IN (:userKbn[])}";
// ['1', '2']のListを設定: (0 = 1 OR (USER_KBN IN (?, ?))) に変換
// サイズ0のListを設定: (0 = 0 OR (USER_KBN IN (?))) に変換 ※条件式には固定で"null"が設定される
```

> **注意**: IN句の条件数はデータベースベンダーによって上限が設けられている。各アプリケーションでこの上限を超えないよう設計すること。

> **警告**: IN句の拡張構文では、検索条件オブジェクトにMapインタフェースの実装クラスを指定することは不可。Mapは値に対する型情報が存在しないため、IN句構築時に値が配列またはCollectionであることのチェックが確実に行えないため。

> **警告**: IN句の条件項目に設定する配列(Collection)がnullやサイズ0になる可能性がある場合は、必ず可変条件と組み合わせて使用すること。可変条件としなかった場合にサイズ0の配列やnullを設定すると、条件が`IN (null)`となり想定したデータが取得できない可能性がある。

> **警告**: IN句以外の箇所にIN句用バインド変数(末尾`[]`)を設定しないこと。不正なSQL文が生成されSQL実行時エラーとなる。例: `USER_ID = :userId[]` にフィールド値`["00001", "00002"]`を設定すると`USER_ID = ?, ?`という不正なSQLが生成される。

リテラル処理のルール:

- リテラル部分に名前付きバインド変数と同じ形式の文字列が記述されていてもバインド変数として扱わない
- リテラル文字は、シングルクォート(`'`)で囲われている
- リテラル文字のエスケープ文字は、シングルクォート(`'`)である
- SQL文にコメントが存在しない

> **警告**: 本クラスでは、SQL文の妥当性のチェックは行わない。不正な構文のSQL文があった場合には、SQL文実行時に例外が発生する。

#### VariableOrderBySyntaxConvertor

可変ORDER BY構文の書き方:

```
$sort(フィールド名) {(ケース1)(ケース2)・・・(ケースn)}
```

- `フィールド名`: 検索条件オブジェクトからソートIDを取得する際に使用するフィールド名
- 各ケースは `(ソートID ケース本体)` 形式（半角丸括弧で囲む、ソートIDとケース本体は半角スペースで区切る）
- ソートIDには半角スペース不可、ケース本体には半角スペース可
- 括弧開き以降で最初に登場する文字列をソートIDとする
- ソートID以降で括弧閉じまでの間をケース本体とする
- ソートIDおよびケース本体はトリミングする
- デフォルトケースはソートIDに`default`を指定する

動作:
- フィールド値が一致するケースのケース本体をORDER BY句としてSQL文に追加
- 一致ケースなし＋デフォルトケースあり: デフォルトのケース本体をORDER BY句として追加
- 一致ケースなし＋デフォルトケースなし: 可変ORDER BY構文を削除したSQL文を返す

```java
public class UserMtr {
    private String userName;
    private String sortId;
}

String sql =
      "SELECT USER_ID, USER_NAME FROM USER_MTR "
    + "WHERE USER_NAME = :user_name "
    + "$sort(sortId) {(1 USER_ID ASC) (2 USER_ID DESC) (3 USER_NAME ASC) (4 USER_NAME DESC) (default USER_ID)}";
// sortId=null → ORDER BY USER_ID (デフォルト)
// sortId=1   → ORDER BY USER_ID ASC
// sortId=2   → ORDER BY USER_ID DESC
// sortId=5   → ORDER BY USER_ID (デフォルト)
```

> **警告**: `VariableOrderBySyntaxConvertor`はSQL文の妥当性チェックを行わない。不正な構文のSQL文があった場合はSQL実行時エラーとなる。

### d) AutoPropertyHandler実装クラス (`nablarch.core.db.statement.autoproperty`パッケージ)

| クラス名 | 概要 |
|---|---|
| `FieldAnnotationHandlerSupport` | フィールドのアノテーション情報を元に値を設定するクラスをサポートするクラス |
| `CurrentDateTimeAnnotationHandler` | `@CurrentDateTime`アノテーションが設定されているフィールドにシステム日時を設定するクラス |
| `UserIdAnnotationHandler` | `@UserId`アノテーションが設定されているフィールドにThreadContextからユーザIDを設定するクラス |
| `RequestIdAnnotationHandler` | `@RequestId`アノテーションが設定されているフィールドにThreadContextからリクエストIDを設定するクラス |

`CurrentDateTimeAnnotationHandler` のフィールド型別設定方法:

| フィールドのデータ型 | 設定方法 |
|---|---|
| `java.sql.Date` | システム日時をjava.sql.Dateに変換して設定 |
| `Timestamp` | システム日時をjava.sql.Timestampに変換して設定 |
| `Time` | システム日時をjava.sql.Timeに変換して設定 |
| `String`, `Integer`, `Long` | `CurrentDateTime`のformatプロパティに設定されている値でSimpleDateFormatを使用してフォーマットして設定。formatプロパティが未指定の場合は [設定ファイル](#) のデフォルトフォーマットを使用 |

> **注意**: システム日時は [system-date-time-feature](libraries-06_SystemTimeProvider.md) を使用して取得する。

`UserIdAnnotationHandler`: ユーザIDはThreadContextから取得する。ThreadContextに設定されるユーザIDについては [thread-context-label](libraries-thread_context.md) を参照。

`RequestIdAnnotationHandler`: リクエストIDはThreadContextから取得する。ThreadContextに設定されるリクエストIDについては [thread-context-label](libraries-thread_context.md) を参照。

### e) フィールド値をデータベースに登録するためのクラス (`nablarch.core.db.statement.autoproperty`パッケージ)

**クラス**: `FieldAndAnnotationLoader`

オブジェクトに定義されたフィールド情報とフィールドのアノテーション情報をロードするクラス。ロードした値は [../05_StaticDataCache](libraries-05_StaticDataCache.md) を使用してキャッシュされるため、同一クラスに対するフィールド情報取得処理が複数回実行されることはない（リフレクションコストを軽減）。

1. 登録対象オブジェクトを生成し必要な情報を設定する。@UserId・@CurrentDateTimeアノテーション付きフィールドへの値設定は不要。
2. `AppDbConnection#prepareParameterizedSqlStatement`でSQL実行用statementを取得する。バインド変数はJDBCの`?`ではなく名前付き変数（`:フィールド名`形式）を記述する。`BasicSqlParameterParser`がSQL解析を行い、JDBC標準SQL文とバインド変数名マッピングを生成する。
3. `BasicSqlPStatement#executeUpdateByObject`でオブジェクトのフィールド値を登録する。
4. フィールドへの自動設定値付与:

| アノテーション | ハンドラクラス | 設定内容 |
|---|---|---|
| `@UserId` | `UserIdAnnotationHandler` | ユーザIDを設定 |
| `@CurrentDateTime` | `CurrentDateTimeAnnotationHandler` | システム日時を設定 |
| `@RequestId` | `RequestIdAnnotationHandler` | リクエストIDを設定 |

5. `PreparedStatement#setObject`でフィールド値をバインド変数に設定しSQL実行。フィールド値が不正な場合はSQL実行時例外が発生する。

> **注意**: `BasicSqlParameterParser`の仕様が不十分な場合は、[SqlParameterParser](#) の実装クラスを追加して置き換えること。

<details>
<summary>keywords</summary>

名前付きバインド変数, SQL文, $if構文, 可変条件, 部分一致検索, バインド変数, BasicSqlParameterParserFactory, BasicSqlParameterParser, SqlConvertorSupport, VariableConditionSyntaxConvertor, VariableInSyntaxConvertor, VariableOrderBySyntaxConvertor, FieldAnnotationHandlerSupport, CurrentDateTimeAnnotationHandler, UserIdAnnotationHandler, RequestIdAnnotationHandler, FieldAndAnnotationLoader, @CurrentDateTime, @UserId, @RequestId, SQL可変条件構文, 可変IN構文, 可変ORDER BY構文, LIKE検索, AutoPropertyHandler, システム日時設定, $sort構文, SqlParameterParserFactory, SqlParameterParser, SqlConvertor, AppDbConnection, BasicSqlPStatement, executeUpdateByObject, prepareParameterizedSqlStatement, PreparedStatement, オブジェクト登録, 自動設定値, DBへの登録シーケンス

</details>

## クラス図

![クラス図](../../../knowledge/component/libraries/assets/libraries-04_ObjectSave/DbAccessSpec_ObjectStatementClassDesign.jpg)

```java
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

MyEntity entity = new MyEntity();
entity.setCstId("1000000001");
entity.setKingaku(1000);

AppDbConnection perCon = DbConnectionContext.getConnection();
// バインド変数は「?」ではなく「:フィールド名」形式で記述する
ParameterizedSqlPStatement insert = perCon.prepareParameterizedSqlStatement(
        "INSERT INTO MY_TABLE (CST_ID, KINGAKU, INS_DATE_TIME, INS_USER_ID, UPD_DATE_TIME, UPD_USER_ID, EXECUTION_ID, REQUEST_ID)"
      + " VALUES (:cstId, :kingaku, :insDateTime, :insUserId, :updDateTime, :updUserId, :executionId, :requestId)");
insert.executeUpdateByObject(entity);
```

> **注意**: SQL文の外部化を推奨。外部化した場合の実装例は [sql-gaibuka-label](libraries-04_Statement.md) を参照。

<details>
<summary>keywords</summary>

クラス図, オブジェクトフィールド値, データベース登録, クラス設計, AppDbConnection, ParameterizedSqlPStatement, executeUpdateByObject, DbConnectionContext, @CurrentDateTime, @UserId, @RequestId, Java実装例, オブジェクトフィールド登録, INSERT文, バインド変数

</details>

## インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| `nablarch.core.db.statement.SqlParameterParserFactory` | 名前付きバインド変数をもつSQL文を解析するための `SqlParameterParser` を取得するインタフェース |
| `nablarch.core.db.statement.SqlParameterParser` | 名前付きバインド変数をもつSQL文を解析するインタフェース。解析結果として (1) `PreparedStatement` で実行可能な形式のSQL文（バインド変数を `?` に置き換え）、(2) 名前付きバインド変数のList を取得できる |
| `nablarch.core.db.statement.SqlConvertor` | SQL文の変換を行うインタフェース |
| `nablarch.core.db.statement.AutoPropertyHandler` | オブジェクトの自動設定項目のフィールドに値を設定するインタフェース。フィールドのアノテーションやフィールド名等を元に値を自動設定する |

```xml
<!-- StatementFactoryの設定 -->
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
    <property name="likeEscapeChar" value="\">
    <property name="likeEscapeTargetCharList" value="%,％,_,＿">
</component>

<!-- フィールドとアノテーション情報キャッシュ -->
<component name="fieldAnnotationCache" class="nablarch.core.cache.BasicStaticDataCache">
    <property name="loader">
        <component class="nablarch.core.statement.autoproperty.FieldAndAnnotationLoader"/>
    </property>
    <property name="loadOnStartup" value="false"/>
</component>

<!-- 初期化機能 -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="fieldAnnotationCache"/>
        </list>
    </property>
</component>
```

**a) BasicStatementFactory の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| sqlParameterParserFactory | ○ | `SqlParameterParserFactory`実装クラスを設定。本サンプルでは`nablarch.core.db.statement.BasicSqlParameterParserFactory`。 |
| objectFieldCache | ○ | `nablarch.core.cache.StaticDataCache`実装クラスを設定。本サンプルでは`fieldAnnotationCache`への参照。 |
| updatePreHookObjectHandlerList | ○ | `nablarch.core.ObjectHandler`実装クラスのリスト。本サンプルでは`CurrentDateTimeAnnotationHandler`、`UserIdAnnotationHandler`、`RequestIdAnnotationHandler`を設定。 |
| likeEscapeChar | ○ | LIKE条件のエスケープ文字。省略時デフォルトは`\`。設定値は`likeEscapeTargetCharList`未設定でも自動エスケープされる。 |
| likeEscapeTargetCharList | ○ | LIKE条件でエスケープが必要な文字をカンマ区切りで設定。省略時デフォルトは`%`、`_`。 |

**a)-1. BasicSqlParameterParserFactory の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| sqlConvertors | | `SqlConvertor`実装クラスのリスト。省略時は`VariableConditionSyntaxConvertor`、`VariableInSyntaxConvertor`、`VariableOrderBySyntaxConvertor`がデフォルト使用。 |

**a)-2. VariableConditionSyntaxConvertor の設定**

| プロパティ名 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|
| allowArrayEmptyString | | true | 配列(Collection)要素数が1でその値が空文字列またはnullの場合に条件に含めるか否か。`false`の場合は条件除外（`(0 = 0) or`条件を付加）。 |

> **注意**: 画面アプリケーションでは`false`を設定すること。リクエストパラメータでキーが存在し値が空文字列の場合、配列サイズ1・値空文字列となり$if構文の条件を除外するのが正しい動作。バッチ処理では条件配列に要素がある場合は必ず条件に含めるため`true`（デフォルト）を設定すること。

**a)-3. VariableInSyntaxConvertor / a)-4. VariableOrderBySyntaxConvertor**

プロパティなし。設定不要。

**b)-1. CurrentDateTimeAnnotationHandler の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| dateFormat | ○ | デフォルトの日付フォーマット（`java.text.SimpleDateFormat`形式）。 |
| dateProvider | ○ | システム日付取得クラス。本サンプルでは`nablarch.core.date.BasicSystemTimeProvider`。 |
| fieldAnnotationCache | ○ | `nablarch.core.cache.StaticDataCache`実装クラス。本サンプルでは`fieldAnnotationCache`への参照。 |

**b)-2. UserIdAnnotationHandler の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| fieldAnnotationCache | ○ | `nablarch.core.cache.StaticDataCache`実装クラス。 |

**b)-3. RequestIdAnnotationHandler の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| fieldAnnotationCache | ○ | `nablarch.core.cache.StaticDataCache`実装クラス。 |

**b)-4. BasicStaticDataCache（fieldAnnotationCache）の設定**

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| loader | ○ | `nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader`を設定すること。 |

> **重要**: `loader`には必ず`nablarch.core.db.statement.autoproperty.FieldAndAnnotationLoader`を設定すること。このクラスと密結合のため変更不可。

> **重要**: 以下のコンポーネントはpropertyのref属性で同一の`BasicStaticDataCache`を参照すること: `BasicStatementFactory`、`CurrentDateTimeAnnotationHandler`、`UserIdAnnotationHandler`、`RequestIdAnnotationHandler`。別々の`BasicStaticDataCache`を設定すると同じ情報が別々のメモリ上にキャッシュされ、メモリ不足でシステムに重大な影響を与える可能性がある。

**c) initializer の設定**

本機能で使用する`BasicStaticDataCache`を初期化する。initializerの詳細は [../02_Repository](libraries-02_Repository.md) を参照。

<details>
<summary>keywords</summary>

SqlParameterParserFactory, SqlParameterParser, SqlConvertor, AutoPropertyHandler, 名前付きバインド変数解析, インタフェース, PreparedStatement, BasicStatementFactory, BasicSqlParameterParserFactory, VariableConditionSyntaxConvertor, VariableInSyntaxConvertor, VariableOrderBySyntaxConvertor, CurrentDateTimeAnnotationHandler, UserIdAnnotationHandler, RequestIdAnnotationHandler, BasicStaticDataCache, FieldAndAnnotationLoader, BasicSystemTimeProvider, BasicApplicationInitializer, sqlParameterParserFactory, objectFieldCache, updatePreHookObjectHandlerList, likeEscapeChar, likeEscapeTargetCharList, allowArrayEmptyString, dateFormat, dateProvider, fieldAnnotationCache, loader, 設定ファイル, LIKE条件エスケープ, キャッシュ設定

</details>
