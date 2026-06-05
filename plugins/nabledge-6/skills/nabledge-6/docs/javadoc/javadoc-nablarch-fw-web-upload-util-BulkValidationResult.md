# class BulkValidationResult

**パッケージ:** nablarch.fw.web.upload.util

---

```java
public class BulkValidationResult
```

一括バリデーション結果を保持するクラス。
<p/>
バリデーション結果の取得やバリデーション済みオブジェクトの登録機能を持つ。

**param:** バリデーションに使用するフォームクラスの型  
**作成者:** T.Kawasaki  

---

## フィールドの詳細

### BATCH_SIZE

```java
private static final int BATCH_SIZE
```

INSERT時の一括実行数のデフォルト値

---

### validObjects

```java
private final List<FORM> validObjects
```

バリデーション済みオブジェクト

---

### errorMessages

```java
private ErrorMessages errorMessages
```

エラーメッセージ

---

### batchSize

```java
private final int batchSize
```

INSERT時の一括実行数

---

## コンストラクタの詳細

### BulkValidationResult

```java
BulkValidationResult()
```

{@code BulkValidationResult}を生成する。

---

### BulkValidationResult

```java
BulkValidationResult(int batchSize)
```

INSERT時の一括実行数を指定して、{@code BulkValidationResult}を生成する。

**パラメータ:**
- `batchSize` - 一括実行数

---

## メソッドの詳細

### hasError

```java
public boolean hasError()
```

エラーが発生しているかどうかを判定する。

**戻り値:**
エラーが１件でも発生している場合は、{@code true}

---

### getErrorMessages

```java
public ErrorMessages getErrorMessages()
```

エラーメッセージを取得する。
<p/>
エラーが発生していない場合、空の{@link ErrorMessages}が返却される。

**戻り値:**
エラーメッセージ

---

### isEmpty

```java
public boolean isEmpty()
```

バリデーション対象があるかどうか。
<p/>
バリデーション実行前に呼び出した場合結果は保証されない。

**戻り値:**
バリデーション対象がない場合{@code true}

---

### getValidObjects

```java
public List<FORM> getValidObjects()
                           throws ApplicationException
```

バリデーション済みオブジェクトを取得する。

**戻り値:**
バリデーション済みオブジェクト

**例外:**
- `ApplicationException` - 一件でもバリデーションエラーが発生していた場合。
         この例外には、発生したすべてのバリデーションエラーのメッセージが格納されている。

---

### importWith

```java
public int importWith(DbAccessSupport dbAccessSupport, String insertSqlId)
```

指定されたSQLIDを用いて、バリデーション済みオブジェクト({@link #getValidObjects}の結果)を一括登録する。

**パラメータ:**
- `dbAccessSupport` - 登録に使用する{@link DbAccessSupport}クラス
- `insertSqlId` - 登録に使用するSQLID

**戻り値:**
レコード登録件数(バリデーション済みオブジェクトがない場合は0を返す)

---

### importAll

```java
public int importAll(InsertionStrategy<FORM> strategy)
```

登録ロジックを用いて、バリデーション済みオブジェクト({@link #getValidObjects}の結果)を一括登録する。

**パラメータ:**
- `strategy` - 登録ロジック

**戻り値:**
レコード登録件数(バリデーション済みオブジェクトがない場合は0を返す)

---

### isTimeToExecBatch

```java
private boolean isTimeToExecBatch(int cnt)
```

バッチ実行すべきタイミングであるかどうか判定する。

**パラメータ:**
- `cnt` - 現在のカウント

**戻り値:**
バッチ実行すべき場合は、{@code true}

---

### addValidObject

```java
void addValidObject(FORM validObject)
```

バリデーション結果として、バリデーション済みのオブジェクトを追加する。

**パラメータ:**
- `validObject` - 追加するバリデーション済みオブジェクト

---

### addErrors

```java
void addErrors(int recordNumber, List<Message> messages)
```

バリデーション結果として、エラーメッセージを追加する。

**パラメータ:**
- `recordNumber` - エラーとなったレコード行
- `messages` - エラーメッセージ

---

### addError

```java
void addError(Integer recordNumber, Message message)
```

バリデーション結果として、エラーメッセージを追加する。

**パラメータ:**
- `recordNumber` - エラーとなったレコード行
- `message` - エラーメッセージ

---
