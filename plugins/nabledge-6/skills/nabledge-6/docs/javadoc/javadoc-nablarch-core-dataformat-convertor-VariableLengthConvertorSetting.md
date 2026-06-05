# class VariableLengthConvertorSetting

**パッケージ:** nablarch.core.dataformat.convertor

**実装されたインタフェース:**
- ConvertorSetting

---

```java
public class VariableLengthConvertorSetting
implements ConvertorSetting
```

可変長ファイルの読み書きを行う際に使用するコンバータの設定情報を保持するクラス。
コンバータ名とコンバータ実装クラスの対応表 や、タイトルのレコードタイプ名などを、DIコンテナから設定できる。

**作成者:** Masato Inoue  

---

## フィールドの詳細

### factory

```java
private VariableLengthConvertorFactory factory
```

コンバータのファクトリクラス

---

### convertEmptyToNull

```java
private boolean convertEmptyToNull
```

空文字列を{@code null}に変換するフラグ。
<p/>
デフォルトでは{@code null}に変換する({@code true})。

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

システムリポジトリ上の登録名

---

### DEFAULT_SETTING

```java
private static final VariableLengthConvertorSetting DEFAULT_SETTING
```

デフォルトのコンバータ設定情報保持クラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

## メソッドの詳細

### getInstance

```java
public static VariableLengthConvertorSetting getInstance()
```

このクラスのインスタンスをリポジトリより取得する。
リポジトリにインスタンスが存在しない場合は、デフォルトの設定で生成したこのクラスのインスタンスを返却する。

**戻り値:**
このクラスのインスタンス

---

### getConvertorFactory

```java
public ConvertorFactorySupport getConvertorFactory()
```

コンバータのファクトリを返却する。

**戻り値:**
コンバータのファクトリ

---

### setConvertorTable

```java
public ConvertorSetting setConvertorTable(Map<String,String> table)
                                   throws ClassNotFoundException
```

デフォルトのコンバータ名とコンバータ実装クラスの対応表を設定する。

**パラメータ:**
- `table` - コンバータ名と、コンバータの実装クラスを保持するテーブル

**戻り値:**
このオブジェクト自体

**例外:**
- `ClassNotFoundException` - 指定されたクラスが存在しなかった場合、
もしくは、指定されたクラスが ValueConvertorを実装していなかった場合に、スローされる例外

---

### setConvertEmptyToNull

```java
public void setConvertEmptyToNull(boolean convertEmptyToNull)
```

空文字列を{@code null}に変換するかを設定する。
<p/>
デフォルトは{@code null}に変換する({@code true})。

**パラメータ:**
- `convertEmptyToNull` - 空文字列を{@code null}に変換するならtrue

---

### isConvertEmptyToNull

```java
public boolean isConvertEmptyToNull()
```

空文字列を{@code null}に変換するかを取得する。

**戻り値:**
空文字列を{@code null}に変換するならtrue

---

### setVariableLengthConvertorFactory

```java
public void setVariableLengthConvertorFactory(VariableLengthConvertorFactory factory)
```

{@link VariableLengthConvertorFactory}を設定する。

**パラメータ:**
- `factory` - VariableLengthConvertorFactory

---
