# class NoMoreHandlerException

**パッケージ:** nablarch.fw

**継承階層:**
```
java.lang.Object
  └─ Result.NotFound
      └─ nablarch.fw.NoMoreHandlerException
```

---

```java
public class NoMoreHandlerException
extends Result.NotFound
```

ハンドラーキュー上に処理を委譲するためのハンドラが存在しない場合に
送出される例外。

**作成者:** Iwauo Tajima  

---

## コンストラクタの詳細

### NoMoreHandlerException

```java
public NoMoreHandlerException()
```

デフォルトコンストラクタ

---

### NoMoreHandlerException

```java
public NoMoreHandlerException(String message)
```

コンストラクタ

**パラメータ:**
- `message` - エラーメッセージ

---
