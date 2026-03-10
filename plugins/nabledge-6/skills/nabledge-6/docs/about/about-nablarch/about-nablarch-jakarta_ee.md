# Jakarta EEの仕様名に関して

## 省略名の表記に関して

Nablarch6では基本的にすべてJakarta EEでの仕様名に置き換えて表記している（例: JPA → Jakarta Persistence、JAX-RS → Jakarta RESTful Web Services）。読みやすさが損なわれる場合は省略名を残している部分もある。本解説書内で登場する省略名は特に断りが無い限り以下のようにJakarta EEの仕様を指す。

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

Java EEがEclipse Foundationに移管され各仕様の名称が変更されたことに伴い、Nablarch5からNablarch6で以下の機能名称が変更された。変更されたのは名称のみで機能的な変更はない。後方互換を維持するためクラスやパッケージの名前などは変更されていない。

| Nablarch5までの名称 | Nablarch6からの名称 |
|---|---|
| JAX-RS BeanValidationハンドラ | [../application_framework/application_framework/handlers/rest/jaxrs_bean_validation_handler](handlers-jaxrs_bean_validation_handler.md) |
| JAX-RSアダプタ | [../application_framework/adaptors/jaxrs_adaptor](adapters-jaxrs_adaptor.md) |
| JAX-RSサポート | [Jakarta RESTful Web Servicesサポート](restful-web-service-architecture.md) |
| JAX-RSレスポンスハンドラ | [../application_framework/application_framework/handlers/rest/jaxrs_response_handler](handlers-jaxrs_response_handler.md) |
| JSPカスタムタグ | [../application_framework/application_framework/libraries/tag](libraries-tag.md) |
| JSP静的解析ツール | [../development_tools/toolbox/JspStaticAnalysis/index](toolbox-JspStaticAnalysis.md) |
| JSR352に準拠したバッチアプリケーション | [../application_framework/application_framework/batch/jsr352/index](jakarta-batch-jsr352.md) |

> **注意**: 「JAX-RS BeanValidationハンドラ」の「BeanValidation」はNablarchが提供するバリデーション機能 [../application_framework/application_framework/libraries/validation/bean_validation](libraries-bean_validation.md) を指しているため、Jakarta Bean Validationには変更していない。
