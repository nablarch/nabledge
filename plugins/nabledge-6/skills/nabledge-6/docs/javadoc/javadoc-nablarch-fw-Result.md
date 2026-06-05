# interface Result

**パッケージ:** nablarch.fw

---

```java
public interface Result
```

ハンドラでの処理結果を表すインターフェース。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  

---

## メソッドの詳細

### getStatusCode

```java
int getStatusCode()
```

ステータスコードを返す。

**戻り値:**
ステータスコード

---

### getMessage

```java
String getMessage()
```

処理結果に関する詳細情報を返す。

**戻り値:**
詳細情報

---

### isSuccess

```java
boolean isSuccess()
```

処理が正常終了したかどうかを返す。

**戻り値:**
正常終了した場合は{@code true}

---
