# class BasicApplicationDisposer

**パッケージ:** nablarch.core.repository.disposal

**実装されたインタフェース:**
- ApplicationDisposer

---

```java
public class BasicApplicationDisposer
implements ApplicationDisposer
```

{@link Disposable}を実装したコンポーネントを指定した順序で廃棄するクラス。<br>
<p>
このクラスはマルチスレッド下で安全に操作できるように、すべてのメソッドを {@code synchronized} で宣言している。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

---

### disposableList

```java
private List<Disposable> disposableList
```

---

## メソッドの詳細

### dispose

```java
public synchronized void dispose()
```

{@inheritDoc}
<p>
このメソッドを一度実行すると{@link Disposable}の参照は破棄されるため、
二回以上実行しても同じ廃棄処理が何度も繰り返されることはない。
</p>

---

### setDisposableList

```java
public synchronized void setDisposableList(List<Disposable> disposableList)
```

{@link Disposable}のリストを設定する。

**パラメータ:**
- `disposableList` - {@link Disposable}のリスト

---

### addDisposable

```java
public synchronized void addDisposable(Disposable disposable)
```

---
