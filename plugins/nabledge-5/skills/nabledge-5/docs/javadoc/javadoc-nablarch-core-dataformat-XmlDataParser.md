# class XmlDataParser

**パッケージ:** nablarch.core.dataformat

**継承階層:**
```
java.lang.Object
  └─ StructuredDataEditorSupport
      └─ nablarch.core.dataformat.XmlDataParser
```

**実装されたインタフェース:**
- StructuredDataParser

---

```java
public class XmlDataParser
extends StructuredDataEditorSupport
implements StructuredDataParser
```

XMLパーサー。<br>
この実装ではDOMを使用してXMLデータの解析を行います。

5u14より、DTDの使用を禁止するように修正を行った。これはXXE攻撃を防ぐためである。
後方互換性を維持するため、DTDの使用を許可するプロパティを設けている({@link #setAllowDTD(boolean)})。
読み込み対象となるXMLが信頼できるものであり、かつ、DTDを使用しなければならない場合のみ、
本プロパティを使用してDTDの使用を許可することができる。

**作成者:** TIS  

---

## フィールドの詳細

### contentName

```java
private String contentName
```

属性あり要素のコンテンツ名(デフォルトはbody)

---

### allowDTD

```java
private boolean allowDTD
```

DTDの使用を許可するか否か(デフォルトは「許可しない」({@code false})

---

## メソッドの詳細

### parseData

```java
public Map<String,?> parseData(InputStream xml, LayoutDefinition layoutDef)
                        throws IOException, InvalidDataFormatException
```

フラットマップを作成します。

**パラメータ:**
- `xml` - XML文字列
- `layoutDef` - フォーマット定義

**戻り値:**
フラットマップ

**例外:**
- `IOException` - 読み込みに伴うIO処理で問題が発生した場合
- `InvalidDataFormatException` - 読み込んだデータがフォーマット定義に違反している場合

---

### createDocumentBuilderFactory

```java
protected DocumentBuilderFactory createDocumentBuilderFactory(LayoutDefinition layoutDef)
                                                    throws ParserConfigurationException
```

本クラスで使用する{@link DocumentBuilderFactory}のインスタンスを生成する。

**パラメータ:**
- `layoutDef` - レイアウト定義 (本実装では使用しないがオーバーライド用に用意している。)

**戻り値:**
{@link DocumentBuilderFactory}のインスタンス

**例外:**
- `ParserConfigurationException` - {@link DocumentBuilderFactory#setFeature(String, boolean)}に失敗した場合

---

### makeMap

```java
private void makeMap(String currentKeyBase, Map<String,Object> outMap, LayoutDefinition layoutDef, RecordDefinition recordDef, Element parent)
```

フラットMap作成処理</br>
XMLを解析したDOMから、キーで階層構造を表現した１階層のMapを作成します。

**パラメータ:**
- `currentKeyBase` - キー名ベース
- `outMap` - 出力対象マップ
- `layoutDef` - フォーマット定義
- `recordDef` - レコードタイプ定義
- `parent` - 親ノード

---

### isElementNode

```java
private boolean isElementNode(Element element)
```

指定した要素の子要素に{@link Node#ELEMENT_NODE}が含まれるか判定する。

**パラメータ:**
- `element` - 要素

**戻り値:**
子要素に {@link Node#ELEMENT_NODE} が含まれていれば{@code true}

---

### getChildElement

```java
private Element getChildElement(String targetNodeName, Element parent)
```

子ノードを取得します。

**パラメータ:**
- `targetNodeName` - 取得対象となるノード名
- `parent` - 取得元の親ノード

**戻り値:**
子ノード

---

### toString

```java
private String toString(Node node)
```

ノードを文字列に変換する。

**パラメータ:**
- `node` - 変換対象となるノード

**戻り値:**
返還後の文字列（引数がnullの場合はnullが返却される）

---

### toStringArray

```java
private String[] toStringArray(NodeList nodeList)
```

NodeListを文字列配列に変換する。

**パラメータ:**
- `nodeList` - 変換対象となるNodeList

**戻り値:**
返還後の文字列配列

---

### setContentName

```java
public void setContentName(String contentName)
```

属性あり要素のコンテンツ名を設定する。

**パラメータ:**
- `contentName` - 属性あり要素のコンテンツ名

---

### setAllowDTD

```java
public void setAllowDTD(boolean allowDTD)
```

DTDの使用を許可する。
デフォルトは「許可しない」({@code false})。

**パラメータ:**
- `allowDTD` - 許可する場合、真

---
