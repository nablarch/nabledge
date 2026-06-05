# class ValidatableFileDataReader

**パッケージ:** nablarch.fw.reader

**継承階層:**
```
java.lang.Object
  └─ FileDataReader
      └─ nablarch.fw.reader.ValidatableFileDataReader
```

---

```java
public class ValidatableFileDataReader
extends FileDataReader
```

ファイル内容のバリデーション機能を追加したデータリーダ。
<p/>
ファイル全件の読み込みを行い、このリーダが提供する{@link FileValidatorAction}に実装されたバリデーションロジックを
{@link #setValidatorAction(FileValidatorAction)}から設定することができる。
バリデーションが正常終了した場合は、入力ファイルを開きなおして本処理を行う。<br/>
また、{@link #setUseCache(boolean)}に{@code true}を設定することで、バリデーション時に読み込んだデータを
メモリ上にキャッシュし、都度2回の読み込みを1回に削減することができる。<br/>
ただし、データ量によってはメモリリソースを大幅に消費する点に注意すること。<br/>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### validatorAction

```java
private FileValidatorAction validatorAction
```

バリデーションを実装したハンドラ

---

### useCache

```java
private boolean useCache
```

バリデーション時に読み込んだデータを本処理で使用するかどうか。

---

### recordCache

```java
private List<DataRecord> recordCache
```

バリデーションで読み込んだデータを格納するキャッシュ

---

### validated

```java
private boolean validated
```

バリデーション済みフラグ

---

## コンストラクタの詳細

### ValidatableFileDataReader

```java
public ValidatableFileDataReader()
```

{@code ValidatableFileDataReader}オブジェクトを生成する。

---

## メソッドの詳細

### read

```java
public synchronized DataRecord read(ExecutionContext ctx)
```

データファイルを1レコードづつ読み込む。
<p/>
ファイルがバリデーション済みでない場合、バリデーションを行う。<br/>
次に読み込むレコードが存在しない場合、{@code null}を返す。
<p/>
データをキャッシュしている場合、キャッシュからデータを読み込み返却する。<br/>
キャッシュしていない場合、データファイルからデータを読み込み返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
１レコード分のデータレコード

---

### hasNext

```java
public synchronized boolean hasNext(ExecutionContext ctx)
```

次に読み込むデータが存在するかどうかを返却する。
<p/>
データをキャッシュしている場合、キャッシュから結果を返却する。<br/>
キャッシュしていない場合、データファイルから結果を返却する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**戻り値:**
次に読み込むデータが存在する場合は {@code true}

---

### close

```java
public synchronized void close(ExecutionContext ctx)
```

このリーダの利用を停止し、内部的に保持している各種リソースを解放する。
<p/>
キャッシュを有効にしていた場合、キャッシュを削除する。

**パラメータ:**
- `ctx` - 実行コンテキスト

---

### validate

```java
protected void validate(ExecutionContext ctx)
```

バリデーションを行う。
<p/>
キャッシュを有効にしている場合、読み込んだデータをキャッシュする。<br/>
無効にしている場合、入力ファイルの再読み込みを行うため、{@link FileDataReader}を初期化する。

**パラメータ:**
- `ctx` - 実行コンテキスト

**例外:**
- `IllegalStateException` - バリデーション処理を実装したオブジェクトが{@code null}の場合
- `RuntimeException` - 実行時例外が発生した場合
- `Error` - エラーが発生した場合

---

### initialize

```java
protected void initialize()
```

キャッシュを使用しない場合、ファイルリーダを初期化する。

---

### setUseCache

```java
public synchronized ValidatableFileDataReader setUseCache(boolean useCache)
```

バリデーション時に読み込んだデータをキャッシュし、本処理で使用するかどうかを設定する。

**パラメータ:**
- `useCache` - キャッシュを有効化する場合は{@code true}

**戻り値:**
このオブジェクト自体

---

### setValidatorAction

```java
public ValidatableFileDataReader setValidatorAction(FileValidatorAction validatorAction)
```

バリデーション処理を実装したアクションクラスを設定する。

**パラメータ:**
- `validatorAction` - バリデーションを実装したアクションクラス

**戻り値:**
このオブジェクト自体

**例外:**
- `IllegalArgumentException` - バリデーションを実装したアクションクラスが{@code null}の場合

---
