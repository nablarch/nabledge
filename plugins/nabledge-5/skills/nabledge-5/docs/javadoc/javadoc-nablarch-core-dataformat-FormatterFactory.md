# class FormatterFactory

**パッケージ:** nablarch.core.dataformat

---

```java
public class FormatterFactory
```

データレコードフォーマッタ（{@link DataRecordFormatter}）を生成するファクトリクラス。
<p>
フォーマット定義ファイルのパースを行い、ディレクティブで指定されたファイルタイプに対応するデータレコードフォーマッタを生成して返却する。<br/>
具体的には、ファイルタイプが "Variable" の場合に{@link VariableLengthDataRecordFormatter}を、
ファイルタイプが "Fixed" の場合に{@link FixedLengthDataRecordFormatter}を生成する。
</p>
<p>
フォーマット定義情報保持クラスは、本クラスの内部でキャッシュし、同一のフォーマット定義ファイルが何度もパースされないように制御する。
デフォルトではフォーマット定義ファイルのパース結果はキャッシュされる。
</p>
<p>
また、リポジトリに「formatterFactory」のキーで本クラスのインスタンスを格納することで、設定を変更することができる。<br/><br/>
以下に、設定可能な項目の一覧を示す。
<table border="1">
<tr bgcolor="#cccccc">
<th>プロパティ名</th>
<th>型</th>
<th>概要</th>
</tr>
<tr>
<td>allowedRecordSeparatorList</td>
<td>{@code List<String>}</td>
<td>レコード終端文字列として許容する文字列のリスト</td>
</tr>
<tr>
<td>defaultReplacementType</td>
<td>{@code Map<String, String>}</td>
<td>フィールドタイプ名に対応するデフォルトの寄せ字変換タイプ名のMap</td>
</tr>
<tr>
<td>encoding</td>
<td>String</td>
<td>フォーマット定義ファイルのエンコーディング</td>
</tr>
<tr>
<td>cacheLayoutFileDefinition</td>
<td>boolean</td>
<td>フォーマット定義ファイルのパース結果のキャッシュ要否</td>
</tr>
</table>
<br/>
また、以下にフォーマット定義ファイルの定義例を示す。
<pre>
{@code
<component name="formatterFactory"
    class="nablarch.core.dataformat.FormatterFactory">
  <property name="cacheLayoutFileDefinition" value="false" />
  <property name="defaultReplacementType">
    <map>
      <entry key="X" value="type_hankaku" />
      <entry key="N" value="type_zenkaku" />
    </map>
  </property>
</component>
}
</pre>
</p>

**関連項目:** DataRecordFormatter  
**関連項目:** LayoutDefinition  
**作成者:** Masato Inoue  

---

## フィールドの詳細

### layoutDefinitionCache

```java
private Map<String,LayoutDefinition> layoutDefinitionCache
```

フォーマット定義ファイルのパース結果クラスのキャッシュ

---

### cacheLayoutFileDefinition

```java
private boolean cacheLayoutFileDefinition
```

フォーマット定義ファイルのパース結果のキャッシュ要否

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

ファクトリクラスのコンポーネント設定ファイル上の名前

---

### FILE_TYPE_VARIABLE

```java
private static final String FILE_TYPE_VARIABLE
```

可変長ファイルタイプの名前

---

### FILE_TYPE_FIXED

```java
private static final Object FILE_TYPE_FIXED
```

可変長ファイルタイプの名前

---

### FILE_TYPE_JSON

```java
private static final Object FILE_TYPE_JSON
```

JSONファイルタイプの名前

---

### FILE_TYPE_XML

```java
private static final Object FILE_TYPE_XML
```

XMLファイルタイプの名前

---

### allowedRecordSeparatorList

```java
private List<String> allowedRecordSeparatorList
```

許容するレコード終端文字列のリスト

---

### defaultReplacementType

```java
private Map<String,String> defaultReplacementType
```

データタイプ名に対応するデフォルトの寄せ字変換タイプ名のMap

---

### encoding

```java
private String encoding
```

フォーマット定義ファイルのファイルエンコーディング

---

### defaultSetting

```java
private static FormatterFactory defaultSetting
```

デフォルトのファクトリクラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

## メソッドの詳細

### getInstance

```java
public static FormatterFactory getInstance()
```

FormatterFactoryクラスのインスタンスをリポジトリより取得する。
リポジトリより取得できなかった場合は、デフォルトで本クラスのインスタンスを返却する。

**戻り値:**
このクラスのインスタンス

---

### setCacheLayoutFileDefinition

```java
public synchronized FormatterFactory setCacheLayoutFileDefinition(boolean cacheLayoutFileDefinition)
```

フォーマット定義ファイルのパース結果のキャッシュ要否を設定する。

**パラメータ:**
- `cacheLayoutFileDefinition` - フォーマット定義ファイルのパース結果のキャッシュ要否

**戻り値:**
このオブジェクト自体

---

### createFormatter

```java
public synchronized DataRecordFormatter createFormatter(File layoutFile)
```

データレコードフォーマッタのインスタンスを生成する。
フォーマット定義ファイルのパース結果をキャッシュする設定の場合は、フォーマット定義ファイルのパースは２度行わない。

**パラメータ:**
- `layoutFile` - フォーマット定義ファイル

**戻り値:**
データレコードフォーマッタのインスタンス

---

### createFormatter

```java
public synchronized DataRecordFormatter createFormatter(LayoutDefinition definition)
```

フォーマット定義情報保持クラスをもとに、データレコードフォーマッタのインスタンスを生成する。

**パラメータ:**
- `definition` - フォーマット定義情報保持クラス

**戻り値:**
データレコードフォーマッタのインスタンス

---

### getDefinitionFromCache

```java
protected LayoutDefinition getDefinitionFromCache(File layoutFile)
```

キャッシュからフォーマット定義情報保持クラスを取得する。
フォーマット定義情報保持クラスをキャッシュから取得できない場合は、生成する。

**パラメータ:**
- `layoutFile` - フォーマット定義ファイル

**戻り値:**
フォーマット定義情報保持クラス

---

### createFormatter

```java
protected DataRecordFormatter createFormatter(String fileType, String formatFilePath)
```

データレコードフォーマッタを生成する。

ファイルタイプにより下記のとおりフォーマッタの生成を行い、
これら以外のファイルタイプの場合は例外をスローする。
<table border="1">
<tr bgcolor="#cccccc">
<th>ファイルタイプ</th>
<th>フォーマッタクラス</th>
</tr>
<tr>
<td>Variable</td>
<td>VariableLengthDataRecordFormatter</td>
</tr>
<tr>
<td>Fixed</td>
<td>FixedLengthDataRecordFormatter</td>
</tr>
<tr>
<td>JSON</td>
<td>JsonDataRecordFormatter</td>
</tr>
<tr>
<td>XML</td>
<td>XmlDataRecordFormatter</td>
</tr>
</table>

**パラメータ:**
- `fileType` - ファイルタイプ
- `formatFilePath` - フォーマット定義ファイルのパス（例外発生時に使用する）

**戻り値:**
フォーマッタ

---

### setFormatterProperty

```java
protected void setFormatterProperty(DataRecordFormatter formatter)
```

データレコードフォーマッタにプロパティを設定する。
<p>
具体的には、データレコードフォーマッタの型がDataRecordFormatterSupportの場合に、
本クラスに設定された以下のプロパティを、データレコードフォーマッタのプロパティに設定する。
<ul>
<li>データタイプ名に対応するデフォルトの寄せ字変換タイプ名のMap</li>
<li>許容するレコード終端文字列のリスト</li>
</ul>
</p>

**パラメータ:**
- `formatter` - データレコードフォーマッタ

---

### createDefinition

```java
protected LayoutDefinition createDefinition(File layoutFile)
```

フォーマット定義ファイルを読み込み、フォーマット定義情報保持クラスを生成する。

**パラメータ:**
- `layoutFile` - フォーマット定義ファイル

**戻り値:**
フォーマット定義情報保持クラス

---

### createLayoutFileParser

```java
protected LayoutFileParser createLayoutFileParser(String layoutFilePath)
```

フォーマット定義ファイルのパーサを生成する。

**パラメータ:**
- `layoutFilePath` - フォーマット定義ファイルのパス

**戻り値:**
フォーマット定義ファイルのパーサ

---

### setAllowedRecordSeparatorList

```java
public FormatterFactory setAllowedRecordSeparatorList(List<String> allowedRecordSeparatorList)
```

許容するレコード終端文字列のリストを設定する。

**パラメータ:**
- `allowedRecordSeparatorList` - 許容されるレコード終端文字列のリスト

**戻り値:**
このオブジェクト自体

---

### setDefaultReplacementType

```java
public FormatterFactory setDefaultReplacementType(Map<String,String> defaultReplacementType)
```

データタイプ名に対応するデフォルトの寄せ字変換タイプ名のMapを設定する。

**パラメータ:**
- `defaultReplacementType` - データタイプ名に対応するデフォルトの寄せ字変換タイプ名のMap

**戻り値:**
このオブジェクト自体

---

### setEncoding

```java
public FormatterFactory setEncoding(String encoding)
```

フォーマット定義ファイルのファイルエンコーディングを設定する。

**パラメータ:**
- `encoding` - フォーマット定義ファイルのファイルエンコーディング

**戻り値:**
このオブジェクト自体

---
