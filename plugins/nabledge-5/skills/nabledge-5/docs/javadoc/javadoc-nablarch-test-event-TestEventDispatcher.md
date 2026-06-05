# class TestEventDispatcher

**パッケージ:** nablarch.test.event

---

```java
public abstract class TestEventDispatcher
```

テストイベントディスパッチャクラス。<br/>
テスト実行時における各種イベントを検知し、リポジトリに登録されたリスナーに通知する。
テストクラスは本クラスまたは本クラスのサブクラスを継承することで、
リスナーに自動的にイベント通知を行えるようになる。

---

## フィールドの詳細

### TEST_EVENT_LISTENERS_KEY

```java
static final String TEST_EVENT_LISTENERS_KEY
```

テストイベントリスナを取得するためのキー

---

### first

```java
private static boolean first
```

初回のテストかどうか

---

### errorInStaticInitializer

```java
private static Throwable errorInStaticInitializer
```

静的初期化子で発生した例外。<br/>
この例外が設定されている場合、すなわち静的初期化子で例外が発生した場合は、
本クラスのサブクラスは全てエラー（テスト失敗）となる。

---

### testName

```java
public final TestName testName
```

テスト名

---

## メソッドの詳細

### initializeDefaultRepository

```java
private static void initializeDefaultRepository()
```

ブートストラップの為のリポジトリ初期化を行う。<br/>
本メソッドはクラスの静的初期化子から起動される。
<p>
{@link BeforeClass}でリポジトリの初期化を行うと、
他の{@link BeforeClass}メソッドが先に呼ばれた場合に
リポジトリが初期化されていないという事態が発生しうる。
これを回避するために静的初期化子にてリポジトリの初期化を行う。
</p>
<p>
静的初期化子起動時に例外・エラーが発生すると、初回クラスロード時には
{@link java.lang.ExceptionInInitializerError}が発生する。しかし、
2回目以降のクラス生成時には{@link java.lang.NoClassDefFoundError}が発生するので、
単独ではエラーになった理由がわからない。
原因究明が容易になるよう、静的初期化子では例外・エラーを発生させないようにしている。
例外・エラーが発生した場合は、これをキャッチして内部的に保持しておき、
静的初期化子の実行は正常に終了させる。
テスト実行前に呼び出される{@link #dispatchEventOfBeforeTestClassAndBeforeSuit()}にて、
保持しておいた発生した例外・エラーをスローする
（{@link #checkErrorInStaticInitializer()}）。
</p>

---

### getListeners

```java
private static List<TestEventListener> getListeners()
```

イベントリスナーの初期化を行う。

**戻り値:**
初期化されたリスナー

---

### getMethodName

```java
protected final String getMethodName()
```

テストメソッド名を取得する。
サブクラスは、テストメソッド内で本メソッドを起動することで、
実行中のテストメソッド名を取得できる。
<pre>
{@code

**戻り値:**
実行中のテストメソッド名

---

### dispatchEventOfBeforeTestClassAndBeforeSuit

```java
public static void dispatchEventOfBeforeTestClassAndBeforeSuit()
```

テストクラス前とテストスイート前のイベントをディスパッチする。

---

### dispatchEventOfBeforeTestMethod

```java
public final void dispatchEventOfBeforeTestMethod()
```

テストメソッド前のイベントをディスパッチする。

---

### dispatchEventOfAfterTestMethod

```java
public final void dispatchEventOfAfterTestMethod()
```

テストメソッド後のイベントをディスパッチする。

---

### dispatchEventOfAfterTestClass

```java
public static void dispatchEventOfAfterTestClass()
```

テストクラス終了後のイベントをディスパッチする。

---

### checkErrorInStaticInitializer

```java
private static void checkErrorInStaticInitializer()
                                   throws Error
```

静的初期化子でエラーが発生していないかどうか確認する。

**例外:**
- `Error` - 静的初期化子でエラーが発生していた場合

---
