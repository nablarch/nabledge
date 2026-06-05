# class XmlDataBuilder

**パッケージ:** nablarch.core.dataformat

**継承階層:**
```
java.lang.Object
  └─ StructuredDataEditorSupport
      └─ nablarch.core.dataformat.XmlDataBuilder
```

**実装されたインタフェース:**
- StructuredDataBuilder

---

```java
public class XmlDataBuilder
extends StructuredDataEditorSupport
implements StructuredDataBuilder
```

XMLパーサー。<br>
この実装ではStAXを使用してXMLデータの構築を行います。

**作成者:** TIS  

---

## フィールドの詳細

### TARGET_XML_VERSION

```java
private static final String TARGET_XML_VERSION
```

作成対象XMLのバージョン

---

### contentName

```java
private String contentName
```

属性あり要素のコンテンツ名(デフォルトはbody)

---

## コンストラクタの詳細

### XmlDataBuilder

```java
public XmlDataBuilder()
```

コンストラクタ

---

## メソッドの詳細

### setContentName

```java
public void setContentName(String contentName)
```

属性ありコンテンツの要素名を設定する。

**パラメータ:**
- `contentName` - 属性ありコンテンツの要素名

---

### buildData

```java
public void buildData(Map<String,?> map, LayoutDefinition layoutDef, OutputStream out)
               throws IOException, InvalidDataFormatException
```

XML文字列を作成します。

**パラメータ:**
- `map` - フラットマップ
- `layoutDef` - フォーマット定義
- `out` - XML文字列出力先ストリーム

**例外:**
- `IOException` - 読み込みに伴うIO処理で問題が発生した場合
- `InvalidDataFormatException` - 読み込んだデータがフォーマット定義に違反している場合

---

### buildXml

```java
private void buildXml(String currentKeyBase, Map<String,?> map, LayoutDefinition ld, RecordDefinition rd, XMLStreamWriter writer, NestedKeys nestedKeys)
              throws XMLStreamException, InvalidDataFormatException
```

XMLを構築します。

**パラメータ:**
- `currentKeyBase` - キー名ベース
- `map` - 出力対象マップ
- `ld` - フォーマット定義
- `rd` - レコードタイプ定義
- `writer` - XMLライタ
- `nestedKeys` - ネストしたキーの集合

**例外:**
- `XMLStreamException` - XML出力に失敗した場合
- `InvalidDataFormatException` - 読み込んだデータがフォーマット定義に違反している場合

---

### writeObjectArray

```java
private void writeObjectArray(XMLStreamWriter writer, LayoutDefinition ld, RecordDefinition nrd, FieldDefinition fd, String currentKeyBase, String mapKey, Map<String,?> map, NestedKeys nestedKeys)
                      throws XMLStreamException
```

オブジェクト配列の出力処理です

**パラメータ:**
- `writer` - XMLライタ
- `ld` - フォーマット定義
- `nrd` - レコードタイプ定義
- `fd` - フィールド定義
- `currentKeyBase` - キー名ベース
- `mapKey` - マップキー
- `map` - 出力対象マップ
- `nestedKeys` - ネストしたキーの集合

**例外:**
- `XMLStreamException` - XML出力に失敗した場合

---

### writeStringArray

```java
private void writeStringArray(XMLStreamWriter writer, FieldDefinition fd, String currentKeyBase, String mapKey, Map<String,?> map)
                      throws XMLStreamException
```

文字列配列の出力処理です

**パラメータ:**
- `writer` - XMLライタ
- `fd` - フィールド定義
- `currentKeyBase` - キー名ベース
- `mapKey` - マップキー
- `map` - 出力対象マップ

**例外:**
- `XMLStreamException` - XML出力に失敗した場合

---

### writeObject

```java
private void writeObject(XMLStreamWriter writer, LayoutDefinition ld, RecordDefinition nrd, FieldDefinition fd, String mapKey, Map<String,?> map, String currentKeyBase, NestedKeys nestedKeys)
                 throws XMLStreamException
```

オブジェクトの出力処理です

**パラメータ:**
- `writer` - XMLライタ
- `ld` - フォーマット定義
- `nrd` - レコードタイプ定義
- `fd` - フィールド定義
- `mapKey` - マップキー
- `map` - 出力対象マップ
- `currentKeyBase` - キー名ベース
- `nestedKeys` - ネストしたキーの集合

**例外:**
- `XMLStreamException` - XML出力に失敗した場合

---

### writeValue

```java
private void writeValue(XMLStreamWriter writer, FieldDefinition fd, String mapKey, Map<String,?> map, String currentKeyBase)
                throws XMLStreamException
```

値の出力処理です

**パラメータ:**
- `writer` - XMLライタ
- `fd` - フィールド定義
- `mapKey` - マップキー
- `map` - 出力対象マップ
- `currentKeyBase` - キー名ベース

**例外:**
- `XMLStreamException` - XML出力に失敗した場合

---
