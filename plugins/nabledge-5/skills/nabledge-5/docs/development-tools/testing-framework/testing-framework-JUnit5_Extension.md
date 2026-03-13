# JUnit 5用拡張機能

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/TestSupport.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/TestSupportExtension.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/NablarchTest.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/batch/BatchRequestTestSupport.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/batch/BatchRequestTestExtension.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/batch/BatchRequestTest.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/db/DbAccessTestSupport.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/DbAccessTestExtension.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/DbAccessTest.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/db/EntityTestSupport.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/EntityTestExtension.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/EntityTest.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/BasicHttpRequestTestTemplate.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/BasicHttpRequestTestExtension.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/BasicHttpRequestTest.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/HttpRequestTestSupport.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/HttpRequestTestExtension.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/HttpRequestTest.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/RestTestSupport.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/RestTestExtension.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/RestTest.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/SimpleRestTestSupport.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/SimpleRestTestExtension.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/SimpleRestTest.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/integration/IntegrationTestSupport.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/integration/IntegrationTestExtension.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/integration/IntegrationTest.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/messaging/MessagingReceiveTestSupport.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingReceiveTestExtension.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingReceiveTest.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/messaging/MessagingRequestTestSupport.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingRequestTestExtension.html) [34](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingRequestTest.html) [35](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/AbstractHttpRequestTestTemplate.html) [36](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/event/TestEventDispatcherExtension.html) [37](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/event/TestEventDispatcher.html)

## 概要

JUnit 5で書かれたテストの中で自動テストフレームワークを使用するための拡張機能。パラメータ化テストなどJUnit 5が提供する機能と自動テストフレームワークを組み合わせて使用可能になる。

> **補足**: 本拡張機能を導入しても、JUnit 4で書かれた既存の自動テストフレームワークのテストを修正する必要はない。JUnit Vintageを使うことでJUnit 4のテストは引き続きJUnit 5上で実行できる（[run_ntf_on_junit5_with_vintage_engine](testing-framework-01_Abstract.md) 参照）。既存テストはJUnit 4のままにしておき、新規テストのみJUnit 5で記述できる。

独自拡張クラスとJUnit5 Extensionを作成し、テストクラスに適用する手順。

> **補足**: JUnit 4の既存独自拡張クラスをJUnit5拡張機能に移植する場合にも適用できる。

## 作成手順

1. フレームワーク提供クラスを継承して独自拡張クラスを作成する
2. 継承元に対応するExtensionクラスを継承した独自拡張用Extensionを作成し、独自拡張クラスのインスタンスを生成するよう実装する
3. `@ExtendWith`で独自Extensionクラスをテストクラスに適用する

## 独自拡張クラスの作成

フレームワーク提供クラスはインスタンス生成時にテストクラスの`Class`オブジェクトを渡す必要がある。独自拡張クラスにはテストクラスの`Class`オブジェクトを受け取るコンストラクタを定義すること。

> **補足**: `SimpleRestTestSupport` は`Class`オブジェクトをコンストラクタで渡さなくても使用できる。

```java
public class CustomTestSupport extends TestSupport {
    public CustomTestSupport(Class<?> testClass) {
        super(testClass);
    }
    // 独自の拡張メソッドを実装する
}
```

## 独自拡張用Extensionの作成

継承元クラスと対応するExtensionクラスの対応:

| 継承元クラス | 対応するExtensionクラス |
|---|---|
| `TestSupport` | `TestSupportExtension` |
| `AbstractHttpRequestTestTemplate` の直接継承 | `BasicHttpRequestTestExtension` |

`createSupport()`をオーバーライドして独自拡張クラスのインスタンスを返す。生成インスタンスは `TestEventDispatcherExtension` の`support`フィールド（`protected`、`TestEventDispatcher`型）に保存される。

```java
public class CustomTestSupportExtension extends TestSupportExtension {
    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        return new CustomTestSupport(testInstance.getClass());
    }
}
```

## テストクラスへの適用

```java
import org.junit.jupiter.api.extension.ExtendWith;

@ExtendWith(CustomTestSupportExtension.class)
class YourTest {
    CustomTestSupport support;

    @Test
    void test() {
        support.customMethod();
    }
}
```

<details>
<summary>keywords</summary>

JUnit5拡張機能, 自動テストフレームワーク, JUnit5統合, パラメータ化テスト, JUnit Vintage, 既存テスト互換性, TestSupport, SimpleRestTestSupport, TestSupportExtension, AbstractHttpRequestTestTemplate, BasicHttpRequestTestExtension, TestEventDispatcherExtension, TestEventDispatcher, @ExtendWith, createSupport, 独自拡張クラス, JUnit5 Extension作成

</details>

## 前提条件

- Java 8以上
- maven-surefire-plugin 2.22.0以上

`BasicHttpRequestTestTemplate` または `AbstractHttpRequestTestTemplate` を拡張する場合、`baseUri`を独自拡張クラスのインスタンスに連携する必要がある。`@ExtendWith`ではパラメータ連携ができないため、独自アノテーションも作成する必要がある。

## 独自拡張クラスの作成

まず、`BasicHttpRequestTestTemplate` を継承して独自拡張クラスを作成する。コンストラクタにはテストクラスと`baseUri`を渡せるようにしておく:

```java
public class CustomHttpRequestTestSupport extends BasicHttpRequestTestTemplate {
    private final String baseUri;

    public CustomHttpRequestTestSupport(Class<?> testClass, String baseUri) {
        super(testClass);
        this.baseUri = baseUri;
    }

    @Override
    protected String getBaseUri() {
        return baseUri;
    }
}
```

## 独自合成アノテーションの作成

次に、独自拡張クラス用の合成アノテーションを作成する。`baseUri`を渡せるように宣言し、この後作成する独自Extensionを`@ExtendWith`で指定する:

```java
import org.junit.jupiter.api.extension.ExtendWith;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@ExtendWith(CustomHttpRequestTestExtension.class)
public @interface CustomHttpRequestTest {
    String baseUri();
}
```

## 独自Extensionの実装

独自Extensionでは`findAnnotation(Object, Class)`を使ってアノテーション情報を取得し、`baseUri`を独自拡張クラスに連携する:

```java
public class CustomHttpRequestTestExtension extends BasicHttpRequestTestExtension {
    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        CustomHttpRequestTest annotation = findAnnotation(testInstance, CustomHttpRequestTest.class);
        return new CustomHttpRequestTestSupport(testInstance.getClass(), annotation.baseUri());
    }
}
```

## テストクラスへの適用

独自の合成アノテーションを使って次のように実装することで、`BasicHttpRequestTestTemplate`を継承した独自拡張クラスを使用できる:

```java
@CustomHttpRequestTest(baseUri = "/custom/")
class YourTest {
    CustomHttpRequestTestSupport support;

    @Test
    void test() {
        support.customMethod();
    }
}
```

<details>
<summary>keywords</summary>

Java 8, maven-surefire-plugin, 動作要件, バージョン要件, BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, CustomHttpRequestTest, findAnnotation, baseUri, BasicHttpRequestTestExtension, 独自合成アノテーション, CustomHttpRequestTestSupport, getBaseUri

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-testing-junit5</artifactId>
  <scope>test</scope>
</dependency>
```

Extensionで以下のメソッドをオーバーライドすることによってテストの事前処理・事後処理を実装できる:

- `beforeAll` / `afterAll`: テストクラス全体での事前・事後処理
- `beforeEach` / `afterEach`: テストメソッドごとの事前・事後処理

> **重要**: オーバーライド時は必ず最初に親クラスの同メソッド（`super.beforeAll(context)`等）を実行すること。実行しない場合、親クラスで定義された事前・事後処理が呼ばれなくなる。

```java
@Override
public void beforeAll(ExtensionContext context) {
    // 必ず最初に親のメソッドを実行する
    super.beforeAll(context);
    // 独自の事前処理を実装する
}
```

<details>
<summary>keywords</summary>

nablarch-testing-junit5, Maven依存関係, com.nablarch.framework, beforeAll, afterAll, beforeEach, afterEach, 事前処理, 事後処理, super.beforeAll

</details>

## 基本的な使い方

自動テストフレームワークが提供するクラスのインスタンスを拡張機能側で生成し、テストクラスにインジェクションする仕組み。JUnit 5のExtensionを利用する。

クラスごとに**Extensionクラス**と**合成アノテーション**が用意されている。例: `TestSupport` には `TestSupportExtension` と `NablarchTest` が対応する。

使用手順:
1. 対応する合成アノテーションをテストクラスに設定する
2. 使用するクラスをテストクラスのインスタンスフィールドとして宣言する（可視性は問わない）
3. テスト内でフィールドを使用する

```java
@NablarchTest
class YourTest {
    TestSupport support;

    @Test
    void test() {
        Map<String, String> map = support.getMap(sheetName, id);
    }
}
```

> **警告**: インジェクション対象フィールドがnullでない場合、拡張機能はエラー終了する。フィールドに値を設定しないこと。

独自拡張クラスでJUnit 4の`TestRule`を使用している場合、Extensionで`resolveTestRules()`をオーバーライドすることで再現させたい`TestRule`をリストで返す。

例えば次のような独自拡張クラスが存在したとする:

```java
import org.junit.Rule;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class CustomTestSupport extends TestSupport {
    @Rule
    public Timeout timeout = new Timeout(1000, TimeUnit.MILLISECONDS);

    public CustomTestSupport(Class<?> testClass) {
        super(testClass);
    }
}
```

これを本拡張機能に移植する場合、Extensionクラスを次のように実装する:

```java
public class CustomTestSupportExtension extends TestSupportExtension {
    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        return new CustomTestSupport(testInstance.getClass());
    }

    @Override
    protected List<TestRule> resolveTestRules() {
        // 親クラスの resolveTestRules() の結果をベースにしてリストを生成する
        List<TestRule> rules = new ArrayList<>(super.resolveTestRules());
        // 独自拡張クラスで定義しているTestRuleをリストに追加する
        rules.add(((CustomTestSupport) support).timeout);
        return rules;
    }
}
```

> **重要**: `resolveTestRules()`オーバーライド時は必ず`super.resolveTestRules()`が返すリストをベースにすること。そうしない場合、親クラスで登録した`TestRule`が再現されなくなる。

<details>
<summary>keywords</summary>

TestSupport, TestSupportExtension, NablarchTest, インジェクション, 合成アノテーション, Extension, フィールドインジェクション, 警告, TestRule, resolveTestRules, JUnit4移植, JUnit 4, Timeout, super.resolveTestRules

</details>

## Extensionクラスと合成アノテーションの一覧

| 自動テストFWが提供するクラス | Extensionクラス | 合成アノテーション |
|---|---|---|
| `TestSupport` | `TestSupportExtension` | `NablarchTest` |
| `BatchRequestTestSupport` | `BatchRequestTestExtension` | `BatchRequestTest` |
| `DbAccessTestSupport` | `DbAccessTestExtension` | `DbAccessTest` |
| `EntityTestSupport` | `EntityTestExtension` | `EntityTest` |
| `BasicHttpRequestTestTemplate` | `BasicHttpRequestTestExtension` | `BasicHttpRequestTest` |
| `HttpRequestTestSupport` | `HttpRequestTestExtension` | `HttpRequestTest` |
| `RestTestSupport` | `RestTestExtension` | `RestTest` |
| `SimpleRestTestSupport` | `SimpleRestTestExtension` | `SimpleRestTest` |
| `IntegrationTestSupport` | `IntegrationTestExtension` | `IntegrationTest` |
| `MessagingReceiveTestSupport` | `MessagingReceiveTestExtension` | `MessagingReceiveTest` |
| `MessagingRequestTestSupport` | `MessagingRequestTestExtension` | `MessagingRequestTest` |

**BasicHttpRequestTestの補足**: `BasicHttpRequestTestTemplate` のみ、合成アノテーション `BasicHttpRequestTest` 使用時に `baseUri` の指定が必要。この値は `AbstractHttpRequestTestTemplate` の `getBaseUri()` が返却する値に対応する。

```java
@BasicHttpRequestTest(baseUri = "/test/")
class YourTestClass {
    BasicHttpRequestTestTemplate support;

    @Test
    void test() {
        support.execute();
    }
}
```

> **重要**: `@RegisterExtension`で使用する場合は必ず**staticフィールド**で使用すること。インスタンスフィールドで使用した場合、`beforeAll`や`afterAll`等の処理が実行されず、Extensionが正常に動作しなくなる。

```java
class YourTest {
    // static フィールドで RegisterExtension を使用する
    @RegisterExtension
    static TestSupportExtension extension = new TestSupportExtension();

    // 自動テストフレームワークが提供するクラスのインスタンスフィールドを宣言する
    TestSupport support;

    @Test
    void test() {
        // support を使用する
    }
}
```

<details>
<summary>keywords</summary>

TestSupportExtension, BatchRequestTestExtension, DbAccessTestExtension, EntityTestExtension, BasicHttpRequestTestExtension, HttpRequestTestExtension, RestTestExtension, SimpleRestTestExtension, IntegrationTestExtension, MessagingReceiveTestExtension, MessagingRequestTestExtension, NablarchTest, BatchRequestTest, DbAccessTest, EntityTest, BasicHttpRequestTest, HttpRequestTest, RestTest, SimpleRestTest, IntegrationTest, MessagingReceiveTest, MessagingRequestTest, baseUri, AbstractHttpRequestTestTemplate, Extension一覧, TestSupport, @RegisterExtension, RegisterExtension, staticフィールド, プログラマティック登録

</details>
