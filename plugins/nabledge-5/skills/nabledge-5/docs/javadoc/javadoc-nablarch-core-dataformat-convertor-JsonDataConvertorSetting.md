# class JsonDataConvertorSetting

**パッケージ:** nablarch.core.dataformat.convertor

**実装されたインタフェース:**
- ConvertorSetting

---

```java
public class JsonDataConvertorSetting
implements ConvertorSetting
```

JSONデータの読み書きを行う際に使用するコンバータの設定情報を保持するクラス。
コンバータ名とコンバータ実装クラスの対応表 や、タイトルのレコードタイプ名などを、DIコンテナから設定できる。

**作成者:** TIS  

---

## フィールドの詳細

### factory

```java
private JsonDataConvertorFactory factory
```

コンバータのファクトリクラス

---

### REPOSITORY_KEY

```java
private static final String REPOSITORY_KEY
```

システムリポジトリ上の登録名

---

### DEFAULT_SETTING

```java
private static final JsonDataConvertorSetting DEFAULT_SETTING
```

デフォルトのコンバータ設定情報保持クラスのインスタンス。
リポジトリからインスタンスを取得できなかった場合に、デフォルトでこのインスタンスが使用される。

---

## メソッドの詳細

### getInstance

```java
public static JsonDataConvertorSetting getInstance()
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

### setJsonDataConvertorFactory

```java
public void setJsonDataConvertorFactory(JsonDataConvertorFactory factory)
```

{@link JsonDataConvertorFactory}を設定する。

**パラメータ:**
- `factory` - {@link JsonDataConvertorFactory}

---
