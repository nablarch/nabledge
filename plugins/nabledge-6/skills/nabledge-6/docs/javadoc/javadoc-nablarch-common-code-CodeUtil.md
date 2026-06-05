# class CodeUtil

**パッケージ:** nablarch.common.code

---

```java
public final class CodeUtil
```

コードの値、及び名称の取り扱いのために使用するユーティリティ。
</p>
コードの値、及び名称の取得処理は{@link CodeManager}によって提供される。
{@link CodeManager}の実装は、SystemRepositoryからコンポーネント名{@value #CODE_MANGER_NAME}で取得される。
</p>

**関連項目:** CodeManager  
**作成者:** Koichi Asano  

---

## フィールドの詳細

### CODE_MANGER_NAME

```java
private static final String CODE_MANGER_NAME
```

メッセージリソースのコンポーネント名。

---

## コンストラクタの詳細

### CodeUtil

```java
private CodeUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getName

```java
public static String getName(String codeId, String value)
               throws IllegalArgumentException
```

コード値に対応するコード名称を取得する。
<p/>
対象の言語は{@link nablarch.core.ThreadContext}で設定された言語となる。
{@link nablarch.core.ThreadContext}で設定が行われていない場合は、デフォルトロケールの言語となる。
<p/>

**パラメータ:**
- `codeId` - コードID
- `value` - コード値

**戻り値:**
コード値に対応するコード名称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getName

```java
public static String getName(String codeId, String value, Locale locale)
               throws IllegalArgumentException
```

コード値、言語に対応するコード名称を取得する。

**パラメータ:**
- `codeId` - コードID
- `value` - コード値
- `locale` - 言語

**戻り値:**
コード値に対応するコード名称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getShortName

```java
public static String getShortName(String codeId, String value)
                    throws IllegalArgumentException
```

コード値に対応するコードの略称を取得する。
<p/>
対象の言語は{@link nablarch.core.ThreadContext}にて設定された言語となる。
{@link nablarch.core.ThreadContext}で設定が行われていない場合は、デフォルトロケールの言語となる。
<p/>

**パラメータ:**
- `codeId` - コードID
- `value` - コード値

**戻り値:**
コード値に対応するコードの略称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getShortName

```java
public static String getShortName(String codeId, String value, Locale locale)
                    throws IllegalArgumentException
```

コード値、言語に対応するコードの略称を取得する。

**パラメータ:**
- `codeId` - コードID
- `value` - コード値
- `locale` - 言語

**戻り値:**
コード値に対応するコードの略称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getOptionalName

```java
public static String getOptionalName(String codeId, String value, String optionColumnName)
                       throws IllegalArgumentException
```

コード値に対応するコードのオプション名称(名称、略称の他に使用する補助名称)を取得する。
<p/>
対象の言語は{@link nablarch.core.ThreadContext}にて設定された言語となる。
{@link nablarch.core.ThreadContext}で設定が行われていない場合は、デフォルトロケールの言語となる。

**パラメータ:**
- `codeId` - コードID
- `value` - コード値
- `optionColumnName` - 取得するオプション名称のカラム名（大文字・小文字を区別せずに使用する）

**戻り値:**
コード値に対応するコードのオプション名称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getOptionalName

```java
public static String getOptionalName(String codeId, String value, String optionColumnName, Locale locale)
                       throws IllegalArgumentException
```

コード値、言語に対応するコードのオプション名称を取得する。
<p/>
対象の言語は引数の言語によって決定される。

**パラメータ:**
- `codeId` - コードID
- `value` - コード値
- `optionColumnName` - 取得するオプション名称のカラム名（大文字・小文字を区別せずに使用する）
- `locale` - 言語

**戻り値:**
コード値に対応するコードのオプション名称

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getValues

```java
public static List<String> getValues(String codeId)
                       throws IllegalArgumentException
```

コードIDに紐付く全てのコード値を取得する。
</p>
コード値の順序は、コード名称テーブルのソート順カラムに、言語ごとに設定された値で決定される。
返却値は、言語ごとに定義されたソート順に従い、並び替えが行われる。

**パラメータ:**
- `codeId` - コードID

**戻り値:**
コードIDに紐付く全てのコード値

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、対象のコード値または言語に対応するデータが存在しない場合

---

### getValues

```java
public static List<String> getValues(String codeId, String pattern)
                       throws IllegalArgumentException
```

コードIDとパターンに紐付くコード値を取得する。
</p>
コード値の順序は、コード名称テーブルのソート順カラムに、言語ごとに設定された値で決定される。
返却値は、言語ごとに定義されたソート順に従い、並び替えが行われる。
対象の言語は{@link nablarch.core.ThreadContext}にて設定された言語となる。
{@link nablarch.core.ThreadContext}で設定が行われていない場合は、デフォルトロケールの言語となる。

**パラメータ:**
- `codeId` - コードID
- `pattern` - 使用するパターンのカラム名（大文字・小文字を区別せずに使用する）

**戻り値:**
コードIDとパターンに紐付くコード値

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、パターンまたは言語に対応するデータが存在しない場合

---

### getValues

```java
public static List<String> getValues(String codeId, Locale locale)
                       throws IllegalArgumentException
```

コードIDに紐付く全てのコード値を取得する。
</p>
コード値の順序は、コード名称テーブルのソート順カラムに、言語ごとに設定された値で決定される。
返却値は、言語ごとに定義されたソート順に従い、並び替えが行われる。

**パラメータ:**
- `codeId` - コードID
- `locale` - 言語

**戻り値:**
コードIDに紐付く全てのコード値

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、コード値または言語に対応するデータが存在しない場合

---

### getValues

```java
public static List<String> getValues(String codeId, String pattern, Locale locale)
                       throws IllegalArgumentException
```

コードIDとパターンに紐付くコード値を取得する。
</p>
コード値の順序は、コード名称テーブルのソート順カラムに、言語ごとに設定された値で決定される。
返却値は、言語ごとに定義されたソート順に従い、並び替えが行われる。

**パラメータ:**
- `codeId` - コードID
- `pattern` - 使用するパターンのカラム名（大文字・小文字を区別せずに使用する）
- `locale` - 言語

**戻り値:**
コードIDとパターンに紐付くコード値

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しないか、パターンまたは言語に対応するデータが存在しない場合

---

### contains

```java
public static boolean contains(String codeId, String value)
                 throws IllegalArgumentException
```

コード値がコードに存在するかチェックする。

**パラメータ:**
- `codeId` - コードID
- `value` - コード値

**戻り値:**
コード値がコードに存在する場合 true

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しない場合

---

### contains

```java
public static boolean contains(String codeId, String pattern, String value)
                 throws IllegalArgumentException
```

コード値がパターンに存在するかチェックする。

**パラメータ:**
- `codeId` - コードID
- `pattern` - 使用するパターンのカラム名（大文字・小文字を区別せずに使用する）
- `value` - コード値

**戻り値:**
コード値がコードに存在する場合 true

**例外:**
- `IllegalArgumentException` - 指定したコードIDが存在しない場合か、指定したパターンが存在しない場合

---

### getCodeManager

```java
private static CodeManager getCodeManager()
```

CodeManagerをリポジトリから取得する。

**戻り値:**
リポジトリから取得したCodeManager

---
