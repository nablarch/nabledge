# class DataRecordFormatterSupport

**パッケージ:** nablarch.core.dataformat

**実装されたインタフェース:**
- DataRecordFormatter

---

```java
public abstract class DataRecordFormatterSupport
implements DataRecordFormatter
```

フォーマット定義ファイルの内容に従い、ファイルデータの読み書きを行うクラスの抽象基底クラス。
<p>
本クラスでは、フォーマット定義情報保持クラス（LayoutDefinition）の初期化および内容の妥当性検証を行い、
実際のファイルデータの読み書きはサブクラスにて行う。
</p>
<p>
本クラスを継承するクラスでは、以下のディレクティブを指定することができる。
<ul>
<li>ファイルタイプ</li>
<li>文字エンコーディング</li>
<li>レコード終端文字列（改行コード）</li>
</ul>
※ディレクティブとは、文字エンコーディングや改行コード、フィールド区切り文字など、
ファイルを読み書きする際に"ファイル単位"で定義できる各種設定項目のことを示す。
</p>

**作成者:** Masato Inoue  

---

## フィールドの詳細

### recordNumber

```java
private int recordNumber
```

読み込みまたは書き込み中のレコードのレコード番号

---

### definition

```java
private LayoutDefinition definition
```

フォーマット定義ファイルの情報を保持するクラス

---

### directiveMap

```java
private Map<String,Directive> directiveMap
```

ディレクティブの名前と、ディレクティブの値のデータ型の定義を保持するMap

---

### defaultEncoding

```java
private Charset defaultEncoding
```

デフォルトの文字エンコーディング

---

### recordSeparator

```java
private String recordSeparator
```

レコード終端文字列

---

### isInitialized

```java
private boolean isInitialized
```

本クラスが初期化されたかどうかのフラグ

---

### allowedRecordSeparatorList

```java
private List<String> allowedRecordSeparatorList
```

許容するレコード終端文字列のリスト。
デフォルトでは、[\r][\n][\r\n]を許容する。

---

### defaultReplacementType

```java
private Map<String,String> defaultReplacementType
```

データタイプ名に対応するデフォルトの寄せ字変換タイプ名

---

## コンストラクタの詳細

### DataRecordFormatterSupport

```java
public DataRecordFormatterSupport()
```

コンストラクタ。
ディレクティブを初期化する。

---

## メソッドの詳細

### createDirectiveMap

```java
protected Map<String,Directive> createDirectiveMap()
```

使用するディレクティブの名前とDirectiveのMapを生成する。
サブクラスで使用するディレクティブを追加する場合は、本メソッドをオーバーライドし、任意のディレクティブを追加すること。

**戻り値:**
使用するディレクティブの名前と値の型のMap

---

### getConvertorSetting

```java
protected abstract ConvertorSetting getConvertorSetting()
```

コンバータの設定情報を取得する。

**戻り値:**
コンバータの設定情報

---

### initialize

```java
public DataRecordFormatter initialize()
```

フォーマット定義情報保持クラスの初期化を行う。
初期化は本メソッドの1回目の実行時のみ行われ、2回目以降の実行時に初期化は行われない。

**戻り値:**
このオブジェクト自体

---

### initializeDefinition

```java
protected void initializeDefinition()
```

フォーマット定義情報保持クラス({@link LayoutDefinition}）の初期化および内容の妥当性を検証し、
フォーマット定義情報保持クラスから必要な情報を本クラスのプロパティに設定する。
フォーマット定義情報保持クラスがすでに初期化されている場合、初期化は行わない。

---

### initializeDefinition

```java
private void initializeDefinition(LayoutDefinition definition)
```

フォーマット定義情報保持クラスの初期化および内容の妥当性を検証する。

**パラメータ:**
- `definition` - 初期化対象インスタンス

---

### validateDirectives

```java
protected void validateDirectives(Map<String,Object> directive)
```

ディレクティブの内容の妥当性を検証する。
<p>
サブクラスで独自のディレクティブを使用する場合は、このメソッドをオーバーライドし、独自のディレクティブに対して妥当性検証を行うこと。<br/>
<br/>
{@link DataRecordFormatter}では以下の仕様を満たしているかどうかの検証を行う。
<ul>
<li>ディレクティブの値のデータ型が正しい</li>
<li>ファイルタイプが定義されている</li>
<li>エンコーディングが定義されている</li>
<li>エンコーディングがCharset型に変換できる</li>
<li>レコード終端文字列が許容されている文字である</li>
</ul>
</p>
<p>
妥当性検証に失敗した場合は、{@link SyntaxErrorException}がスローされる。
</p>

**パラメータ:**
- `directive` - ディレクティブ

---

### validateFileType

```java
private void validateFileType(Map<String,Object> directive)
```

ディレクティブのファイルタイプをバリデーションする。

**パラメータ:**
- `directive` - バリデーション対象ディレクティブ

---

### validateEncoding

```java
private void validateEncoding(Map<String,Object> directive)
```

ディレクティブのエンコーディングをバリデーションする。

**パラメータ:**
- `directive` - バリデーション対象ディレクティブ

---

### validateRecordSeparator

```java
private void validateRecordSeparator(Map<String,Object> directive)
```

レコード区切り文字をバリデーションする。

**パラメータ:**
- `directive` - バリデーション対象ディレクティブ

---

### escape

```java
private String escape(String s)
```

文字列中の'\r','\t','\n'をエスケープする。

**パラメータ:**
- `s` - 対象文字列

**戻り値:**
エスケープ後の文字列

---

### isAvailable

```java
private boolean isAvailable(String encoding)
```

エンコーディングが利用可能かどうか判定する。

**パラメータ:**
- `encoding` - エンコーディング名

**戻り値:**
利用可能な場合、真

---

### handleMissingDirective

```java
private void handleMissingDirective(Directive notFound)
                            throws SyntaxErrorException
```

必須のディレクティブが指定されていない場合の例外をスローする。

**パラメータ:**
- `notFound` - 必須のディレクティブ

**例外:**
- `SyntaxErrorException` - 必ずスローされる

---

### newSyntaxError

```java
SyntaxErrorException newSyntaxError(Object msgElements)
```

{@link SyntaxErrorException}を生成する。
<p/>
引数に与えられた要素を連結して例外メッセージとする。
例外には、その例外の原因となったファイルパスが設定される。

**パラメータ:**
- `msgElements` - メッセージの要素

**戻り値:**
{@link SyntaxErrorException}インスタンス

---

### initializeField

```java
protected void initializeField(Map<String,Object> directive)
```

フィールドを初期化する。
<p/>
{@link DataRecordFormatterSupport}では、ディレクティブに設定された以下の値をフィールドに設定する。
<ul>
<li>レコード終端文字列</li>
<li>文字エンコーディング</li>
</ul>

**パラメータ:**
- `directive` - ディレクティブ

---

### validateDirectivesDataType

```java
protected void validateDirectivesDataType(Map<String,Object> directive)
```

定義されたすべてのディレクティブの値のデータ型が正しいことを検証する。

**パラメータ:**
- `directive` - ディレクティブ

---

### initializeClassifier

```java
protected void initializeClassifier()
```

レコード識別情報が存在する場合（マルチレイアウトファイルの場合）、
レコード識別情報に関連するフィールド定義クラスの初期化（コンバータ設定およびエンコーディング設定）を行う。
<p/>
レコード種別識別定義の場合は、フィールド位置の整合性チェックは行わない。

---

### initializeFieldDefinition

```java
protected void initializeFieldDefinition()
```

フィールド定義クラスについて、以下の初期化処理を行う。
<ul>
<li>コンバータ設定</li>
<li>エンコーディング設定</li>
<li>差分定義が行われている場合は、親のフィールド定義情報を反映</li>
<li>レコード長、フィールド長の妥当性検証</li>
</ul>

---

### setFieldProperty

```java
protected void setFieldProperty(FieldDefinition field, RecordDefinition recordDef)
```

フィールド定義情報保持クラスのプロパティを設定する。

**パラメータ:**
- `field` - フィールド定義情報保持クラス
- `recordDef` - レコード定義情報保持クラス

---

### validateRecordLength

```java
protected void validateRecordLength(int head, RecordDefinition record)
```

レコード長の妥当性を検証する。

**パラメータ:**
- `head` - 位置
- `record` - レコード定義情報保持クラス

---

### validatePosition

```java
protected void validatePosition(int head, FieldDefinition field)
```

開始位置と、現在位置の妥当性を検証する。

**パラメータ:**
- `head` - 位置
- `field` - フィールド定義情報保持クラス

---

### addConvertorToField

```java
protected void addConvertorToField(FieldDefinition field, RecordDefinition recordDefinition)
```

フィールドのフォーマット定義を保持するクラスに関連するコンバータを生成し、フィールド定義クラスに設定する。
コンバータを生成する役割を担うコンバータファクトリは、サブクラスで指定されたコンバータ情報設定クラスをもとに生成する。
{@link #getConvertorSetting()}

**パラメータ:**
- `field` - フォーマット定義を保持するクラス
- `recordDefinition` - レコード定義情報保持クラス

---

### createCharacterReplacer

```java
protected CharacterReplacer createCharacterReplacer(FieldDefinition field, String replacementType)
```

デフォルトの寄せ字コンバータを生成する。

**パラメータ:**
- `field` - フィールド
- `replacementType` - 寄せ字変換タイプ

**戻り値:**
デフォルトの寄せ字コンバータ

---

### setDataTypeProperty

```java
protected DataRecordFormatterSupport setDataTypeProperty(DataType<?,?> dataType)
```

データタイプの設定を行う。ファイルタイプ個別の設定を行う必要がある場合、必要に応じてサブクラスでオーバーライドする。

**パラメータ:**
- `dataType` - データタイプ

**戻り値:**
このオブジェクト自体

---

### setValueConvertorProperty

```java
protected void setValueConvertorProperty(ValueConvertor<?,?> valueConvertor)
```

コンバータの設定を行う。ファイルタイプ個別の設定を行う必要がある場合、必要に応じてサブクラスでオーバーライドする。

**パラメータ:**
- `valueConvertor` - コンバータ

---

### setDefinition

```java
public DataRecordFormatter setDefinition(LayoutDefinition definition)
```

{@inheritDoc}

---

### getDefinition

```java
protected LayoutDefinition getDefinition()
```

フォーマット定義ファイルの情報を保持するクラスを取得する。

**戻り値:**
フォーマット定義ファイルの情報を保持するクラス

---

### setAllowedRecordSeparatorList

```java
public DataRecordFormatterSupport setAllowedRecordSeparatorList(List<String> allowedRecordSeparatorList)
```

許容するレコード終端文字列のリストを設定する。

**パラメータ:**
- `allowedRecordSeparatorList` - 許容されるレコード終端文字列のリスト

**戻り値:**
このオブジェクト自体

---

### getRecordNumber

```java
public int getRecordNumber()
```

読み込みまたは書き込み中のレコードのレコード番号を取得する。

**戻り値:**
recordNumber 読み込みまたは書き込み中のレコードのレコード番号

---

### incrementRecordNumber

```java
protected void incrementRecordNumber()
```

読み込みまたは書き込み中のレコードのレコード番号をインクリメントする。

---

### setRecordNumber

```java
protected void setRecordNumber(int recordNumber)
```

読み込みまたは書き込み中のレコードのレコード番号を設定する。

**パラメータ:**
- `recordNumber` - 読み込みまたは書き込み中のレコードのレコード番号

---

### getDefaultEncoding

```java
public Charset getDefaultEncoding()
```

デフォルトの文字エンコーディングを取得する。

**戻り値:**
文字エンコーディング

---

### getRecordSeparator

```java
protected String getRecordSeparator()
```

レコード終端文字列を取得する。

**戻り値:**
レコード終端文字列

---

### setDefaultReplacementType

```java
public DataRecordFormatterSupport setDefaultReplacementType(Map<String,String> defaultReplacementType)
```

データタイプ名に対応するデフォルトの寄せ字変換タイプ名を設定する。

**パラメータ:**
- `defaultReplacementType` - データタイプ名に対応するデフォルトの寄せ字変換タイプ名

**戻り値:**
このオブジェクト自体

---

### newInvalidDataFormatException

```java
protected final InvalidDataFormatException newInvalidDataFormatException(Object msgElements)
```

引数を連結したものをメッセージとして、{@link InvalidDataFormatException}を生成する。<br/>
この例外には、フォーマットファイルのパスと例外発生時の行番号が設定される。

**パラメータ:**
- `msgElements` - メッセージ要素

**戻り値:**
{@link InvalidDataFormatException}インスタンス

---

### addFormatAndRecordNumberTo

```java
protected final InvalidDataFormatException addFormatAndRecordNumberTo(InvalidDataFormatException e)
```

{@link InvalidDataFormatException}に
フォーマットファイルのパスと例外発生時の行番号を設定する。

**パラメータ:**
- `e` - 設定対象の例外インスタンス

**戻り値:**
引数で与えられたインスタンス

---

### getFileType

```java
public String getFileType()
```

このフォーマッタが取り扱うファイル種別を返却する。

**戻り値:**
ファイル種別

---

### getMimeType

```java
public String getMimeType()
```

このフォーマッタが取り扱うファイルのmime-typeを返却する。<br>
デフォルトではtext/plainを返却する。必要に応じサブクラスでオーバーライドすること。

**戻り値:**
ファイルのmime-type

---
