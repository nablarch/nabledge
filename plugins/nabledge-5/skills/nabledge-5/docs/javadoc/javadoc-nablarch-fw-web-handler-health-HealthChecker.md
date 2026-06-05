# class HealthChecker

**パッケージ:** nablarch.fw.web.handler.health

---

```java
public abstract class HealthChecker
```

ヘルスチェックを行うクラス。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### name

```java
private String name
```

ヘルスチェックの対象を表す名前

---

## メソッドの詳細

### getName

```java
public String getName()
```

ヘルスチェックの対象を表す名前を取得する。

**戻り値:**
ヘルスチェックの対象を表す名前

---

### setName

```java
public void setName(String name)
```

ヘルスチェックの対象を表す名前を設定する。

**パラメータ:**
- `name` - ヘルスチェックの対象を表す名前

---

### check

```java
public boolean check(HttpRequest request, ExecutionContext context)
```

ヘルスチェックを行う。

{@link #tryOut(HttpRequest, ExecutionContext)}を呼び出し、その結果を返す。
{@link #tryOut(HttpRequest, ExecutionContext)}で例外が発生した場合はfalseを返す。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト

**戻り値:**
ヘルスチェックに成功した場合はtrue

---

### tryOut

```java
protected abstract boolean tryOut(HttpRequest request, ExecutionContext context)
               throws Exception
```

ヘルシーと判断できる処理を試す。

**パラメータ:**
- `request` - リクエスト
- `context` - コンテキスト

**戻り値:**
ヘルシーな場合はtrue

**例外:**
- `Exception` - 試した結果発生した例外

---
