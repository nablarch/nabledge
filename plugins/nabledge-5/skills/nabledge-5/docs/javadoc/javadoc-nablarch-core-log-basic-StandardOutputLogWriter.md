# class StandardOutputLogWriter

**パッケージ:** nablarch.core.log.basic

**継承階層:**
```
java.lang.Object
  └─ LogWriterSupport
      └─ nablarch.core.log.basic.StandardOutputLogWriter
```

---

```java
public class StandardOutputLogWriter
extends LogWriterSupport
```

標準出力にログを書き込むクラス。<br>
<br>
開発時にコンソール上で出力されたログを確認する場合などに使用できる。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### onWrite

```java
protected void onWrite(String formattedMessage)
```

標準出力にログを書き込む。

**パラメータ:**
- `formattedMessage` - フォーマット済みのログ

---
