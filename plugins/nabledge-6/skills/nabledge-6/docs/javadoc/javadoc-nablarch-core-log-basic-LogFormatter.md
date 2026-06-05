# interface LogFormatter

**パッケージ:** nablarch.core.log.basic

---

```java
public interface LogFormatter
```

ログのフォーマットを行うインタフェース。<br>
<br>
ログのフォーマットの種類毎に本インタフェースの実装クラスを作成する。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### initialize

```java
void initialize(ObjectSettings settings)
```

初期処理を行う。

**パラメータ:**
- `settings` - LogFormatterの設定

---

### format

```java
String format(LogContext context)
```

ログのフォーマットを行う。

**パラメータ:**
- `context` - {@link LogContext}

**戻り値:**
フォーマット済みのログ

---
