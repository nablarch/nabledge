# class CharacterReplacementManager

**パッケージ:** nablarch.core.dataformat

**実装されたインタフェース:**
- Initializable

---

```java
public class CharacterReplacementManager
implements Initializable
```

寄せ字変換処理を行うクラス。
<p>
本クラスは、文字列中のある特定の文字を等価な代替文字に変換する用途での使用を想定している。<br/>
想定する変換の例：　髙→高　碕→崎<br/>
このような文字列変換処理のことを、寄せ時変換処理と呼ぶ。
</p>
<p>
禁則文字を一括で豆腐（■）に変換するような処理は、本クラスでは想定していないので、<br/>
文字を検知した場合に、ワーニングログを出力する機能や、呼び出し元に検知したことを通知する機能は提供しない。<br/>
想定しない変換の例：　唖→■  \→[ 
<p>
寄せ字変換処理は、寄せ字タイプごとに定義された寄せ字変換定義ファイルの情報をもとに行う。<br/>
寄せ字変換定義ファイルは初期化時に読み込み、メモリ上にキャッシュする。
</p>
<p>
本クラスは、文字列中の特定の1文字を、特定の1文字に変換することしかサポートしない（サロゲートペアの変換もサポートしない）。<br/>
よって、寄せ字変換定義ファイルに、「ﾍ゜」のような半角2文字で1文字を表現する合字などの複数の文字や、サロゲートペアが定義された場合は、例外をスローする。
</p>

**作成者:** Masato Inoue  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー *

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

本クラスのコンポーネント設定ファイル上の名前

---

### configList

```java
private List<CharacterReplacementConfig> configList
```

寄せ字変換処理の設定を保持するList

---

### replacementDefinitionMap

```java
private Map<String,CharacterReplacementDefinition> replacementDefinitionMap
```

寄せ字変換テーブルを保持するクラスのMap

---

### CHARACTER_LENGTH_INVALID_MESSAGE

```java
private static final String CHARACTER_LENGTH_INVALID_MESSAGE
```

文字長が異なる場合にスローする例外のメッセージ

---

## メソッドの詳細

### getInstance

```java
public static CharacterReplacementManager getInstance()
```

FormatterFactoryクラスのインスタンスをリポジトリより取得する。
リポジトリより取得できなかった場合は、デフォルトで本クラスのインスタンスを返却する。

**戻り値:**
{@link CharacterReplacementManager}のインスタンス

---

### initialize

```java
public void initialize()
```

初期化処理を行う。

---

### createReplacementTables

```java
protected void createReplacementTables()
```

寄せ字変換定義ファイルを読み込み、寄せ字変換テーブルを生成する。
<p>
寄せ字変換定義ファイルに定義された変換前および変換後の文字列が1文字でない（Stringのlengthが1でない）場合は、
例外をスローする。
</p>
<p>
変換前と変換後の文字のバイト長一致チェックが有効な場合、
寄せ字変換定義ファイルに定義された変換前および変換後の文字列を指定されたエンコーディングに従いバイト配列に変換し、
変換前と変換後のバイト長が一致しない場合は、例外をスローする。
</p>

---

### createReplacementTable

```java
protected CharacterReplacementDefinition createReplacementTable(CharacterReplacementConfig config)
```

寄せ字変換定義ファイルを読み込み、寄せ字変換テーブルを生成する。

**パラメータ:**
- `config` - 寄せ字変換処理の設定を保持するクラス

**戻り値:**
寄せ字変換テーブルを保持するクラス

---

### setEncodingToTable

```java
protected void setEncodingToTable(CharacterReplacementConfig config, CharacterReplacementDefinition definition)
```

寄せ字変換テーブルに、文字エンコーディングを設定する。

**パラメータ:**
- `config` - 寄せ字変換処理の設定を保持するクラス
- `definition` - 寄せ字変換テーブルを保持するクラス

---

### loadPropertyFile

```java
protected Properties loadPropertyFile(String filePath)
```

寄せ字変換定義ファイルをロードする。

**パラメータ:**
- `filePath` - 寄せ字変換定義ファイルのパス

**戻り値:**
寄せ字変換定義ファイルをロードしたPropertiesクラス

---

### checkReplacementCharacterLength

```java
protected void checkReplacementCharacterLength(String fromStr, String toStr, CharacterReplacementConfig config)
```

寄せ字変換定義ファイルに設定された変換前文字列と変換後文字列の文字列長が「1」であることを確認する。

**パラメータ:**
- `fromStr` - 寄せ字変換前の文字列
- `toStr` - 寄せ字変換後の文字列
- `config` - 寄せ字変換処理の設定を保持するクラス

---

### toHexString

```java
private String toHexString(String str)
```

引数の文字列を16進数に変換する。

**パラメータ:**
- `str` - 変換前の文字列

**戻り値:**
16進数に変換した文字列

---

### checkByteLength

```java
protected void checkByteLength(String fromStr, String toStr, CharacterReplacementConfig config)
```

変換前文字列と変換後文字列のバイト長チェックを行う。
バイト長チェックは、文字エンコーディングに従い行う。

**パラメータ:**
- `fromStr` - 変換前文字列
- `toStr` - 変換後文字列
- `config` - 寄せ字変換処理の設定を保持するクラス

---

### checkProperty

```java
protected void checkProperty(String name, String value, CharacterReplacementConfig config)
                   throws IllegalStateException
```

設定されたプロパティの妥当性をチェックする。

**パラメータ:**
- `name` - プロパティ名
- `value` - プロパティの値
- `config` - 寄せ字変換処理の設定を保持するクラス

**例外:**
- `IllegalStateException` - プロパティが設定されていない場合

---

### replaceCharacter

```java
public String replaceCharacter(String typeName, String input)
```

引数で渡された文字列に対して、寄せ字変換処理を行う。

**パラメータ:**
- `typeName` - 寄せ字タイプ名
- `input` - 入力文字列

**戻り値:**
寄せ字変換処理後の文字列

---

### outputLog

```java
protected void outputLog(String typeName, char from, char to, String input)
```

文字を変換した際のログを出力する。

**パラメータ:**
- `typeName` - 寄せ字変換タイプ名
- `from` - 寄せ字変換前の文字
- `to` - 寄せ字変換後の文字
- `input` - 入力文字列

---

### setConfigList

```java
public CharacterReplacementManager setConfigList(List<CharacterReplacementConfig> configList)
```

寄せ字変換処理の設定を保持するListを設定する。

**パラメータ:**
- `configList` - 寄せ字変換処理の設定を保持するList

**戻り値:**
このオブジェクト自体

---

### containsReplacementType

```java
public boolean containsReplacementType(String typeName)
```

引数で指定された寄せ字タイプ名が、寄せ字タイプ名として定義されているかどうかチェックする。

**パラメータ:**
- `typeName` - 寄せ字タイプ名

**戻り値:**
引数で指定された寄せ字タイプ名が定義されている場合、true

---

### checkReplacementTypeEncoding

```java
public boolean checkReplacementTypeEncoding(String typeName, Charset encoding)
```

引数で指定された寄せ字タイプ名と文字エンコーディングの組み合わせが、定義された組み合わせと一致するかどうかをチェックする。
<p>
寄せ字タイプ名と、文字エンコーディングの組み合わせは、通常コンポーネント設定ファイルで定義される。
</p>

**パラメータ:**
- `typeName` - 寄せ字タイプ名
- `encoding` - 文字エンコーディング

**戻り値:**
寄せ字タイプ名が

---
