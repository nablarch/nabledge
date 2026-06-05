# class BasicApplicationInitializer

**パッケージ:** nablarch.core.repository.initialization

**実装されたインタフェース:**
- ApplicationInitializer

---

```java
public class BasicApplicationInitializer
implements ApplicationInitializer
```

{@link Initializable}を実装したコンポーネントを指定した順序で初期化するクラス。<br>

**作成者:** Hisaaki Sioiri  

---

## フィールドの詳細

### initializeList

```java
private List<Object> initializeList
```

初期化対象オブジェクトリスト

---

## メソッドの詳細

### initialize

```java
public void initialize()
```

初期化処理を行う。<br>
<br>
初期化対象一覧内のオブジェクトを順次初期化する。<br>
初期化処理で例外が発生した場合には、以降の処理は行わず呼び出し元に例外を送出する。<br>
初期化対象オブジェクトと設定されているクラスが、Initializableインタフェースを実装していない場合には、
例外を送出し以降の処理は行わない。<br>
<b>本メソッドは、同期化を行わない。</b>

---

### setInitializeList

```java
public void setInitializeList(List<Object> initializeList)
```

初期化対象オブジェクトリストを設定する。

**パラメータ:**
- `initializeList` - 初期化対象のオブジェクトが設定されたList

---
