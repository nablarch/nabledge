# class TestEventDispatcherExtension

**パッケージ:** nablarch.test.junit5.extension.event

**実装されたインタフェース:**
- TestInstancePostProcessor
- BeforeAllCallback
- AfterAllCallback
- BeforeEachCallback
- AfterEachCallback

---

```java
public abstract class TestEventDispatcherExtension
implements TestInstancePostProcessor, BeforeAllCallback, AfterAllCallback, BeforeEachCallback, AfterEachCallback
```

NTF の JUnit 5 用 Extension の基底となる抽象クラス。
<p>
このクラスは、 {@link TestEventDispatcher} が提供する JUnit 4 用の拡張機能を、
JUnit 5 の Extension の仕組みで再現する。
</p>
<p>
各 Extension はこのクラスを継承して作成することで、共通する部分の処理を省略できる。
</p>

**作成者:** Tanaka Tomoyuki  

---

## フィールドの詳細

### NOOP_STATEMENT

```java
private static final Statement NOOP_STATEMENT
```

何も処理を行わない{@link Statement}。

---

### support

```java
protected TestEventDispatcher support
```

Extension が生成しテストクラスにインジェクションする、サポートクラスのインスタンス。
<p>
このフィールドは、 {@link #postProcessTestInstance(Object, ExtensionContext)} が実行されたときに初期化される。
設定される値は、 {@link #createSupport(Object, ExtensionContext)} が返却したインスタンスが使用される。
</p>

---

## メソッドの詳細

### postProcessTestInstance

```java
public void postProcessTestInstance(Object testInstance, ExtensionContext context)
                             throws Exception
```

---

### createSupport

```java
protected abstract TestEventDispatcher createSupport(Object testInstance, ExtensionContext context)
```

テストインスタンスにインジェクションするサポートクラスのインスタンスを生成する。

**パラメータ:**
- `testInstance` - テストインスタンス
- `context` - コンテキスト

**戻り値:**
サポートクラスのインスタンス

---

### buildInjectionTargetCondition

```java
private Predicate<Field> buildInjectionTargetCondition(Class<? extends TestEventDispatcher> supportClass)
```

指定されたフィールドが、サポートクラスのインスタンスをインジェクションする対象となるか判定するための
{@link Predicate} を生成する。

**パラメータ:**
- `supportClass` - 生成されたサポートクラスの {@link Class} オブジェクト

**戻り値:**
インジェクション対象の判定を行うための {@link Predicate}

---

### beforeAll

```java
public void beforeAll(ExtensionContext context)
```

---

### beforeEach

```java
public void beforeEach(ExtensionContext context)
                throws Exception
```

テストメソッドの前処理を実行する。

**パラメータ:**
- `context` - コンテキスト

**例外:**
- `Exception` - 例外がスローされた場合

---

### emulateTestRules

```java
private void emulateTestRules(ExtensionContext context)
```

JUnit4の{@link TestRule}を再現する。

**パラメータ:**
- `context` - コンテキスト

---

### convert

```java
private Description convert(ExtensionContext extensionContext)
```

{@link ExtensionContext}(JUnit5) の情報を {@link Description}(JUnit4) に詰め替える。

**パラメータ:**
- `extensionContext` - {@link ExtensionContext}

**戻り値:**
{code extensionContext} の情報をもとに構築された {@link Description}

---

### resolveTestRules

```java
protected List<TestRule> resolveTestRules()
```

テストに対して適用する JUnit 4 の {@link TestRule} のリストを取得する。
<p>
JUnit 4 時代に作成した独自のサポートクラスを移植する場合は、
このメソッドをオーバーライドしてサポートクラスで宣言したルールインスタンスを
リストにして返却するように実装する。<br>
オーバーライドした場合は、親クラスが返したリストに追加する形でルールを追加すること。
以下に実装例を示す。
</p>
<pre>{@code
public List<TestRule> resolveTestRules() {
    // 親の resolveTestRules() が返したリストをベースにする
    List<TestRule> testRules = new ArrayList<>(super.resolveTestRules());
    // 独自の TestRule を追加する
    testRules.add(((YourSupport)support).yourTestRule);
    return testRules;
}
}</pre>

**戻り値:**
テストに適用したい JUnit 4 の {@link TestRule} のリスト

---

### afterEach

```java
public void afterEach(ExtensionContext context)
               throws Exception
```

テストメソッドの後処理を実行する。

**パラメータ:**
- `context` - コンテキスト

**例外:**
- `Exception` - 例外がスローされた場合

---

### afterAll

```java
public void afterAll(ExtensionContext context)
```

---

### findAnnotation

```java
protected A findAnnotation(Object testInstance, Class<A> annotationClass)
```

指定されたテストインスタンスのクラスに設定されたアノテーションを取得する。

**パラメータ:**
- `testInstance` - テストインスタンス(null不可)
- `annotationClass` - 取得するアノテーションの型
- `<A>` - アノテーションの型

**戻り値:**
テストクラスに設定されたアノテーション

---
