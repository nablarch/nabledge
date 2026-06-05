# class BulkValidator

**パッケージ:** nablarch.fw.web.upload.util

---

```java
public class BulkValidator
```

アップロードファイルを一括バリデーションするためのクラス。
<p/>
バリデーションエラーが存在した場合でも処理を継続し、全レコードのバリデーションを実行する。

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### formatter

```java
private final DataRecordFormatter formatter
```

アップロードファイルのレコードフォーマッタ

---

### fileName

```java
private final String fileName
```

アップロードされたファイルのファイル名

---

## コンストラクタの詳細

### BulkValidator

```java
BulkValidator(DataRecordFormatter formatter, String fileName)
```

コンストラクタ。

**パラメータ:**
- `formatter` - アップロードファイルのレコードフォーマッタ
- `fileName` - アップロードされたファイルのファイル名

---

## メソッドの詳細

### getFormatter

```java
public DataRecordFormatter getFormatter()
```

レコードフォーマッタを取得する。<br/>
特殊な要件のため、独自のアップロード処理をおこなわなければならない場合、
本メソッドで取得した{@link DataRecordFormatter}を使用して、
任意の処理を実行できる。

**戻り値:**
レコードフォーマッタ

---

### validateAll

```java
public BulkValidationResult<FORM> validateAll(ValidatingStrategy<FORM> validatingStrategy)
```

一括バリデーション処理を行う。
<p/>
引数で与えられたバリデーションロジックを使用して、全レコードのバリデーション処理を行う。

**パラメータ:**
- `validatingStrategy` - バリデーションロジック
- `<FORM>` - バリデーションに使用するフォームクラスの型

**戻り値:**
バリデーション結果

---

### setUpMessageIdOnError

```java
public ErrorHandlingBulkValidator setUpMessageIdOnError(String messageIdOnFormatError, String messageIdOnValidationError, String messageIdOnEmptyFile)
```

エラー発生時のメッセージIDを指定し、一括バリデーションクラスのインスタンスを生成する。
<p/>
本FWが提供しているバリデーションのみで要件を満たせる場合は、本コンストラクタで生成した一括バリデーションクラスを使う。
要件を満たせない場合は、{@link #validateAll(ValidatingStrategy)}を使用する。

**パラメータ:**
- `messageIdOnFormatError` - 形式エラー（{@link InvalidDataFormatException}）発生時のメッセージID
- `messageIdOnValidationError` - バリデーションエラー発生時のメッセージID
- `messageIdOnEmptyFile` - ファイルが空の場合のメッセージID

**戻り値:**
一括バリデーションクラスのインスタンス

---
