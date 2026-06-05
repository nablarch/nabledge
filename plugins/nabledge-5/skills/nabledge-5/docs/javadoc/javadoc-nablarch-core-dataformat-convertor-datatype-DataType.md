# class DataType

**パッケージ:** nablarch.core.dataformat.convertor.datatype

---

```java
public abstract class DataType
```

ファイルや電文のストリームを読み書きし、
フィールドへの変換を行うデータタイプが継承すべき抽象基底クラス。

**param:** 入出力時のデータの型  
**param:** 入力データが変換されるオブジェクトの型  
**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### field

```java
private FieldDefinition field
```

フィールド定義

---

### convertEmptyToNull

```java
protected boolean convertEmptyToNull
```

空文字列を{@code null}に変換するフラグ

---

## メソッドの詳細

### initialize

```java
public abstract DataType<F,T> initialize(Object args)
```

初期化処理を行う。

**パラメータ:**
- `args` - データタイプのパラメータ

**戻り値:**
初期化されたデータタイプ （通常はthisをリターンする）

---

### convertOnRead

```java
public abstract F convertOnRead(T data)
```

入力時に読み込んだデータを変換する。

**パラメータ:**
- `data` - フィールドの値データ

**戻り値:**
変換後の値

---

### convertOnWrite

```java
public abstract T convertOnWrite(Object data)
```

出力時に書き込むデータの変換を行う。

**パラメータ:**
- `data` - 書き込みを行うデータ

**戻り値:**
変換後の値

---

### init

```java
public DataType<F,T> init(FieldDefinition field, Object args)
```

初期化処理を行う。

**パラメータ:**
- `field` - フィールド定義
- `args` - データタイプのパラメータ

**戻り値:**
初期化されたデータタイプ （通常はthisをリターンする）

---

### getSize

```java
public abstract Integer getSize()
```

扱うデータ型に応じたデータサイズを返却する。
（固定長データを扱う場合はバイト長、可変長データを扱う場合は文字列長を返却する）

**戻り値:**
データサイズ

---

### getField

```java
public FieldDefinition getField()
```

フィールド定義を取得する。

**戻り値:**
フィールド定義

---

### removePadding

```java
public F removePadding(Object data)
```

パディングを取り除く。

**パラメータ:**
- `data` - 対象データ

**戻り値:**
パディング除去後のデータ

---

### setConvertEmptyToNull

```java
public void setConvertEmptyToNull(boolean convertEmptyToNull)
```

空文字列を{@code null}に変換するかを設定する。

**パラメータ:**
- `convertEmptyToNull` - 空文字列を{@code null}に変換するならtrue

---
