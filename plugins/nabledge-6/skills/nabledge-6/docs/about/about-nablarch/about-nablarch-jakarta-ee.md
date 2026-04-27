# Jakarta EEの仕様名に関して

**目次**

* 省略名の表記に関して
* Nablarch5と6で名称が変更になった機能について

## 省略名の表記に関して

Java EEで使われていた仕様の省略名について、Nablarch6では基本的にすべてJakarta EEでの仕様名に置き換えて表記している。

**例**

* JPA (Java Persistence API) → Jakarta Persistence
* JAX-RS (Java API for RESTful Web Services) → Jakarta RESTful Web Services

ただし、読みやすさが損なわれる場合は省略名を残している部分もある。
特に断りが無い限り、本解説書内で登場する省略名は以下のようにJakarta EEの仕様を指すものとする。

省略名とJakarta EEの仕様の対応表

| 省略名 | Jakarta EE仕様 |
|---|---|
| JSF | [Jakarta Faces (外部サイト、英語)](https://jakarta.ee/specifications/faces/) |
| JASPIC | [Jakarta Authentication (外部サイト、英語)](https://jakarta.ee/specifications/authentication/) |
| JACC | [Jakarta Authorization (外部サイト、英語)](https://jakarta.ee/specifications/authorization/) |
| JMS | [Jakarta Messaging (外部サイト、英語)](https://jakarta.ee/specifications/messaging/) |
| JPA | [Jakarta Persistence (外部サイト、英語)](https://jakarta.ee/specifications/persistence/) |
| JTA | [Jakarta Transactions (外部サイト、英語)](https://jakarta.ee/specifications/transactions/) |
| jBatch | [Jakarta Batch (外部サイト、英語)](https://jakarta.ee/specifications/batch/) |
| JCA | [Jakarta Connectors (外部サイト、英語)](https://jakarta.ee/specifications/connectors/) |
| JAF | [Jakarta Activation (外部サイト、英語)](https://jakarta.ee/specifications/activation/) |
| EL | [Jakarta Expression Language (外部サイト、英語)](https://jakarta.ee/specifications/expression-language/) |
| EJB | [Jakarta Enterprise Beans (外部サイト、英語)](https://jakarta.ee/specifications/enterprise-beans/) |
| JAXB | [Jakarta XML Binding (外部サイト、英語)](https://jakarta.ee/specifications/xml-binding/) |
| JSON-B | [Jakarta JSON Binding (外部サイト、英語)](https://jakarta.ee/specifications/jsonb/) |
| JSON-P | [Jakarta JSON Processing (外部サイト、英語)](https://jakarta.ee/specifications/jsonp/) |
| JSP | [Jakarta Server Pages (外部サイト、英語)](https://jakarta.ee/specifications/pages/) |
| JAX-WS | [Jakarta XML Web Services (外部サイト、英語)](https://jakarta.ee/specifications/xml-web-services/) |
| JAX-RS | [Jakarta RESTful Web Services (外部サイト、英語)](https://jakarta.ee/specifications/restful-ws/) |
| JSTL | [Jakarta Standard Tag Library (外部サイト、英語)](https://jakarta.ee/specifications/tags/) |
| CDI | [Jakarta Contexts and Dependency Injection (外部サイト、英語)](https://jakarta.ee/specifications/cdi/) |

## Nablarch5と6で名称が変更になった機能について

Java EEがEclipse Foundationに移管され各仕様の名称が変更されたことに伴い、Nablarchが提供する機能でJava EEの仕様名を含んでいたものは名称の変更を行った。
以下に、変更前後の名称の対応表を記載する。

Nablarch5,6で名称が変更になった機能の対応表

| Nablarch5までの名称 | Nablarch6からの名称 |
|---|---|
| JAX-RS BeanValidationハンドラ | [Jakarta RESTful Web Servcies Bean Validationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md) [1] |
| JAX-RSアダプタ | [Jakarta RESTful Web Servicesアダプタ](../../component/adapters/adapters-jaxrs-adaptor.md) |
| JAX-RSサポート | [Jakarta RESTful Web Servicesサポート](../../processing-pattern/restful-web-service/restful-web-service-architecture.md) |
| JAX-RSレスポンスハンドラ | [Jakarta RESTful Web Servicesレスポンスハンドラ](../../component/handlers/handlers-jaxrs-response-handler.md) |
| JSPカスタムタグ | [Jakarta Server Pagesカスタムタグ](../../component/libraries/libraries-tag.md) |
| JSP静的解析ツール | [Jakarta Server Pages静的解析ツール](../../development-tools/toolbox/toolbox-JspStaticAnalysis.md) |
| JSR352に準拠したバッチアプリケーション | [Jakarta Batchに準拠したバッチアプリケーション](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md) |

「BeanValidation」はNablarchが提供するバリデーション機能である [Bean Validation](../../component/libraries/libraries-bean-validation.md) を指しているため、Jakarta Bean Validationには変更していない。

なお、変更されたのは名称のみで機能的な変更はない。
また、後方互換を維持するためにクラスやパッケージの名前などは変更されていない。
