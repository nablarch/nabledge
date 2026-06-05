# class JsonBoolean

**パッケージ:** nablarch.core.dataformat.convertor.datatype

**継承階層:**
```
java.lang.Object
  └─ CharacterStreamDataString
      └─ nablarch.core.dataformat.convertor.datatype.JsonBoolean
```

---

```java
public class JsonBoolean
extends CharacterStreamDataString
```

JSONにおける真偽値を表現するマーカークラス。
<p>
入力時には文字列に対して何もせずそのまま返却し、
出力時にはオブジェクトを文字列に変換して返却する。
なお、出力時にオブジェクトがnullの場合はnullを返却する。
</p>
<p>
本クラスはマーカークラスとして存在し、上記以外の特別な処理は行わない。
</p>

**作成者:** TIS  

---

## メソッドの詳細

### convertOnRead

```java
public String convertOnRead(String data)
```

{@inheritDoc}
この実装では、入力時に、引数の文字列に対して何もせずに返却する。

**パラメータ:**
- `data` - フィールドの値データ

**戻り値:**
変換後の値

---

### convertOnWrite

```java
public String convertOnWrite(Object data)
```

この実装では、出力時に、引数のオブジェクトを文字列に変換して返却する。
<p/>
引数がnullの場合は、nullを返却する。

**パラメータ:**
- `data` - 書き込みを行うデータ

**戻り値:**
変換後の値

---
