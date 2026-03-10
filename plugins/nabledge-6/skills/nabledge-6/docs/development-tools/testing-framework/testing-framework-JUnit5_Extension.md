# JUnit 5用拡張機能

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/06_TestFWGuide/JUnit5_Extension.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/TestSupport.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/TestSupportExtension.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/NablarchTest.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/batch/BatchRequestTestSupport.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/batch/BatchRequestTestExtension.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/batch/BatchRequestTest.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/db/DbAccessTestSupport.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/DbAccessTestExtension.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/DbAccessTest.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/db/EntityTestSupport.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/EntityTestExtension.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/db/EntityTest.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/BasicHttpRequestTestTemplate.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/BasicHttpRequestTestExtension.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/BasicHttpRequestTest.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/HttpRequestTestSupport.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/HttpRequestTestExtension.html) [19](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/HttpRequestTest.html) [20](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/RestTestSupport.html) [21](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/RestTestExtension.html) [22](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/RestTest.html) [23](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/SimpleRestTestSupport.html) [24](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/SimpleRestTestExtension.html) [25](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/http/SimpleRestTest.html) [26](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/integration/IntegrationTestSupport.html) [27](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/integration/IntegrationTestExtension.html) [28](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/integration/IntegrationTest.html) [29](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/messaging/MessagingReceiveTestSupport.html) [30](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingReceiveTestExtension.html) [31](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingReceiveTest.html) [32](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/messaging/MessagingRequestTestSupport.html) [33](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingRequestTestExtension.html) [34](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/messaging/MessagingRequestTest.html) [35](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/AbstractHttpRequestTestTemplate.html) [36](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/junit5/extension/event/TestEventDispatcherExtension.html) [37](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/event/TestEventDispatcher.html)

## 概要

JUnit 5で書かれたテストの中で自動テストフレームワークを使用するための拡張機能。パラメータ化テストなどJUnit 5が提供する機能と自動テストフレームワークを組み合わせて使用できる。

> **補足**: 本拡張機能を導入してもJUnit 4で書かれた既存テストを修正する必要はない。JUnit Vintageを使うことで既存のJUnit 4テストはJUnit 5上で引き続き実行可能（:ref:`run_ntf_on_junit5_with_vintage_engine` 参照）。既存テストはJUnit 4のままにしておき、新規テストのみJUnit 5で実装できる。

<details>
<summary>keywords</summary>

JUnit5拡張機能, 自動テストフレームワーク, JUnit5, JUnit Vintage, パラメータ化テスト, JUnit4互換性

</details>

## 前提条件

- maven-surefire-plugin 2.22.0以上

<details>
<summary>keywords</summary>

maven-surefire-plugin, 前提条件, バージョン要件

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

<details>
<summary>keywords</summary>

nablarch-testing-junit5, モジュール, Maven依存関係, com.nablarch.framework

</details>

## 基本的な使い方

各自動テストフレームワーククラスに対応するExtensionクラスと合成アノテーションを提供。使い方:

1. 対応する合成アノテーション（例: `NablarchTest`）をテストクラスに設定する
2. 使用するクラス（例: `TestSupport`）のインスタンスフィールドをテストクラスに宣言する（可視性は任意）
3. 拡張機能がテスト実行前にインスタンスを生成し、代入可能なフィールドへ自動インジェクションする

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

> **警告**: インジェクション対象フィールドがnullでない場合、拡張機能はエラー終了するので値は設定しないこと。

<details>
<summary>keywords</summary>

TestSupport, NablarchTest, TestSupportExtension, インジェクション, 合成アノテーション, Extensionクラス, フィールドインジェクション

</details>

## Extensionクラスと合成アノテーションの一覧

| 自動テストフレームワークが提供するクラス | Extensionクラス | 合成アノテーション |
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

## BasicHttpRequestTestの補足

`BasicHttpRequestTest` 使用時は `baseUri` パラメータの指定が必要。この値は `AbstractHttpRequestTestTemplate` の `getBaseUri()` の戻り値に対応する。

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

<details>
<summary>keywords</summary>

TestSupportExtension, NablarchTest, BatchRequestTestExtension, BatchRequestTest, DbAccessTestExtension, DbAccessTest, EntityTestExtension, EntityTest, BasicHttpRequestTestExtension, BasicHttpRequestTest, HttpRequestTestExtension, HttpRequestTest, RestTestExtension, RestTest, SimpleRestTestExtension, SimpleRestTest, IntegrationTestExtension, IntegrationTest, MessagingReceiveTestExtension, MessagingReceiveTest, MessagingRequestTestExtension, MessagingRequestTest, BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, baseUri, 合成アノテーション一覧

</details>

## 独自の拡張を加える

自動テストフレームワークが提供するクラスを継承し、独自の拡張を加える場合の対応方法について説明する。

> **補足**: ここで説明する手順は、JUnit 4で書かれた既存の独自拡張クラスを本拡張機能用に使用する場合にも適用できる。

独自拡張クラスを作成する場合は、大きく次のようにして対応する:

1. 自動テストフレームワークが提供するクラスを継承し、独自拡張クラスを作成する
2. 継承元のクラスに対応するExtensionクラスを継承した独自拡張用のExtensionを作成し、独自拡張クラスのインスタンスを生成するように実装する
3. `@ExtendWith`アノテーションを使って独自ExtensionクラスをテストクラスにApplyする

<details>
<summary>keywords</summary>

独自拡張クラス, Extensionクラス継承, JUnit4移植

</details>

## 独自拡張クラスを作成する

フレームワーク提供クラスはインスタンス生成時にテストクラスの`Class`オブジェクトを渡す必要がある。独自拡張クラスにはテストクラスの`Class`オブジェクトを受け取るコンストラクタを定義すること。

`TestSupport`を継承した独自拡張クラスの例:

```java
public class CustomTestSupport extends TestSupport {
    // テストクラスの Class インスタンスを TestSupport のコンストラクタに渡せるように実装する
    public CustomTestSupport(Class<?> testClass) {
        super(testClass);
    }

    // 独自の拡張メソッドを実装する
}
```

> **補足**: `SimpleRestTestSupport`は、テストクラスの`Class`オブジェクトをコンストラクタで渡さなくても使用できる。

<details>
<summary>keywords</summary>

TestSupport, SimpleRestTestSupport

</details>

## 独自拡張用のExtensionを作成する

継承元クラスに対応するExtensionクラスを継承し、独自拡張用のExtensionを作成する。`TestSupport`を継承した場合、対応Extensionは`TestSupportExtension`となる。

`createSupport()`をオーバーライドして、作成した独自拡張クラスのインスタンスを返す。生成したインスタンスは`TestEventDispatcherExtension`の`support`フィールド（`protected`の`TestEventDispatcher`型）に保存される。サブクラスから参照可能。

> **補足**: `AbstractHttpRequestTestTemplate`を直接継承した場合、対応Extensionとして`BasicHttpRequestTestExtension`が使用できる。

```java
public class CustomTestSupportExtension extends TestSupportExtension {

    // createSupport() をオーバーライドし、独自拡張クラスのインスタンスを返すように実装する
    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        return new CustomTestSupport(testInstance.getClass());
    }
}
```

<details>
<summary>keywords</summary>

TestSupportExtension, AbstractHttpRequestTestTemplate, BasicHttpRequestTestExtension, TestEventDispatcherExtension, TestEventDispatcher, createSupport

</details>

## ExtendWithでテストクラスに適用する

作成した独自拡張用のExtensionは、`@ExtendWith`アノテーションを使ってテストクラスに適用できる。

```java
import org.junit.jupiter.api.extension.ExtendWith;

// 1. ExtendWith で独自拡張用のExtensionをテストクラスに適用する
@ExtendWith(CustomTestSupportExtension.class)
class YourTest {
    // 2. 独自拡張クラスをインスタンス変数で宣言する
    CustomTestSupport support;

    @Test
    void test() {
        // 3. テスト内で独自拡張クラスを使用する
        support.customMethod();
    }
}
```

<details>
<summary>keywords</summary>

@ExtendWith, ExtendWith

</details>

## BasicHttpRequestTestTemplateを拡張する場合はアノテーションも作成する

`BasicHttpRequestTestTemplate`または`AbstractHttpRequestTestTemplate`を拡張する場合、`baseUri`を独自拡張クラスのインスタンスに連携する必要がある。`@ExtendWith`ではパラメータの連携ができないため、合成アノテーションも独自に作成する必要がある。

独自拡張クラス（`baseUri`をコンストラクタで受け取る）:

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

合成アノテーション（`@ExtendWith`で独自Extensionを指定し、`baseUri`をパラメータとして宣言）:

```java
import org.junit.jupiter.api.extension.ExtendWith;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
// この後作成する独自拡張用のExtensionを指定する
@ExtendWith(CustomHttpRequestTestExtension.class)
public @interface CustomHttpRequestTest {
    // baseUri を渡せるように宣言する
    String baseUri();
}
```

独自拡張用Extension（`findAnnotation(Object, Class)`でテストクラスのアノテーション情報を取得して`baseUri`を連携）:

```java
public class CustomHttpRequestTestExtension extends BasicHttpRequestTestExtension {

    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        // テストクラスからアノテーションの情報を取得する
        CustomHttpRequestTest annotation = findAnnotation(testInstance, CustomHttpRequestTest.class);
        // 独自拡張クラスのコンストラクタに baseUri の情報を連携する
        return new CustomHttpRequestTestSupport(testInstance.getClass(), annotation.baseUri());
    }
}
```

使用例:

```java
// 独自の合成アノテーションをテストクラスに設定する(baseUri も設定する)
@CustomHttpRequestTest(baseUri = "/custom/")
class YourTest {
    // 独自拡張クラスをフィールドで宣言する
    CustomHttpRequestTestSupport support;

    @Test
    void test() {
        // 独自拡張クラスをテストで使用する
        support.customMethod();
    }
}
```

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, AbstractHttpRequestTestTemplate, findAnnotation, 合成アノテーション, baseUri

</details>

## 事前処理・事後処理を実装する

独自拡張用のExtensionでは、以下のメソッドをオーバーライドすることでテストの事前処理・事後処理を実装できる:

- `beforeAll` / `afterAll`: テストクラス全体の事前・事後処理
- `beforeEach` / `afterEach`: テストメソッドごとの事前・事後処理

> **重要**: オーバーライド時は必ず最初に親クラスの同メソッドを呼び出すこと。呼び出さない場合、親クラスで定義された事前・事後処理が実行されなくなる。

```java
@Override
public void beforeAll(ExtensionContext context) {
    // 必ず最初に親のメソッドを実行する
    super.beforeAll(context);

    // 独自の事前処理を実装する
    ...
}
```

<details>
<summary>keywords</summary>

beforeAll, beforeEach, afterAll, afterEach

</details>

## JUnit 4のTestRuleを再現する

既存プロジェクトなどで作成した独自拡張クラス内でJUnit 4の`TestRule`（`@Rule`付き）を使用している場合に、本拡張機能に移植する方法。

独自拡張用のExtensionで`resolveTestRules()`をオーバーライドし、再現させたい`TestRule`をリストに追加して返却することで、JUnit 5のテスト上でもJUnit 4の`TestRule`を再現できる。

> **重要**: `resolveTestRules()`オーバーライド時は、必ず`super.resolveTestRules()`の結果をベースにすること。そうしない場合、親クラスで登録している`TestRule`が再現されなくなる。

元の独自拡張クラス（JUnit 4の`TestRule`を使用）:

```java
import org.junit.Rule;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class CustomTestSupport extends TestSupport {
    // JUnit 4のTestRuleを使用している
    @Rule
    public Timeout timeout = new Timeout(1000, TimeUnit.MILLISECONDS);

    public CustomTestSupport(Class<?> testClass) {
        super(testClass);
    }
}
```

移植後の独自拡張用Extension:

```java
public class CustomTestSupportExtension extends TestSupportExtension {

    @Override
    protected TestEventDispatcher createSupport(Object testInstance, ExtensionContext context) {
        return new CustomTestSupport(testInstance.getClass());
    }

    // 1. resolveTestRules メソッドをオーバーライドする
    @Override
    protected List<TestRule> resolveTestRules() {
        // 2. 親クラスの resolveTestRules() の結果をベースにしてリストを生成する
        List<TestRule> rules = new ArrayList<>(super.resolveTestRules());
        // 3. 独自拡張クラスで定義しているTestRuleをリストに追加する
        rules.add(((CustomTestSupport) support).timeout);
        // 4. 生成したリストを返却する
        return rules;
    }
}
```

<details>
<summary>keywords</summary>

@Rule, resolveTestRules, TestRule再現, TestRule, JUnit4移植

</details>

## RegisterExtensionで使用する

RegisterExtensionを使用してExtensionのインスタンスを手続き的に生成してテストクラスに適用できる。

> **重要**: RegisterExtensionを使用する場合は必ず`static`フィールドで使用すること。インスタンスフィールドで使用した場合、`beforeAll`や`afterAll`などの処理が実行されず、Extensionが正常に動作しなくなる。

```java
class YourTest {
    // 1. static フィールドで RegisterExtension を使用する
    @RegisterExtension
    static TestSupportExtension extension = new TestSupportExtension();

    // 2. 自動テストフレームワークが提供するクラスのインスタンスフィールドを宣言する
    TestSupport support;

    @Test
    void test() {
        // 3. support をテストで使用する
        ...
    }
}
```

> **補足**: RegisterExtensionについては、[公式ガイドの「5.2.2. Programmatic Extension Registration」](https://junit.org/junit5/docs/5.11.0/user-guide/#extensions-registration-programmatic)を参照のこと。

<details>
<summary>keywords</summary>

TestSupportExtension, TestSupport, @RegisterExtension, RegisterExtension, staticフィールド, プログラム的登録, beforeAll, afterAll

</details>
