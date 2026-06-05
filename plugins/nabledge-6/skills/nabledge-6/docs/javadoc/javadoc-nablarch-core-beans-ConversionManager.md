# interface ConversionManager

**パッケージ:** nablarch.core.beans

---

```java
public interface ConversionManager
```

型変換機能を管理するインタフェース。

**作成者:** Naoki Yamamoto  

---

## メソッドの詳細

### getConverters

```java
Map<Class<?>,Converter<?>> getConverters()
```

型変換に使用する{@link Converter}を格納したMapを取得する。
<p/>
Mapのキーには変換先の型、値にはキーで指定した型に対応する{@link Converter}を設定する。

**戻り値:**
{@link Converter}を格納したMap

---

### getExtensionConvertor

```java
List<ExtensionConverter<?>> getExtensionConvertor()
```

拡張の型変換リストを返す。
<p>
優先順位が高いものをリストのより先頭に設定する必要がある。

**戻り値:**
拡張型変換のリスト

---
