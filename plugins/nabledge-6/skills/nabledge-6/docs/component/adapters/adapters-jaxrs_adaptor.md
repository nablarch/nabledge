# Jakarta RESTful Web Servicesアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jaxrs_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsMethodBinderFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/jersey/JerseyJaxRsHandlerListFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/jackson/Jackson2BodyConverter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxbBodyConverter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/FormUrlEncodedConverter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/MultipartFormDataBodyConverter.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/resteasy/ResteasyJaxRsHandlerListFactory.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHandlerListFactory.html)

## モジュール一覧

> **補足**: Nablarch5では「JAX-RSアダプタ」という名称だったが、Java EEのEclipse Foundation移管に伴い「Jakarta RESTful Web Servicesアダプタ」に名称変更。機能的な差はない。名称変更された他の機能は:ref:`renamed_features_in_nablarch_6`を参照。

:ref:`restful_web_service`で使用するための以下のアダプタを提供する。

- JSONを[Jackson](https://github.com/FasterXML/jackson)で変換するアダプタ
- [Jersey](https://eclipse-ee4j.github.io/jersey/)で:ref:`restful_web_service`を使用するためのアダプタ
- [RESTEasy](https://resteasy.dev/)で:ref:`restful_web_service`を使用するためのアダプタ

**モジュール**:
```xml
<!-- jacksonアダプタを使う場合 -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jackson-adaptor</artifactId>
</dependency>

<!-- Jersey用アダプタを使う場合 -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-jersey-adaptor</artifactId>
</dependency>

<!-- RESTEasy用アダプタを使う場合 -->
<dependency>
  <groupId>com.nablarch.integration</groupId>
  <artifactId>nablarch-resteasy-adaptor</artifactId>
</dependency>
```

> **補足**: Jacksonはバージョン2.17.1でテスト済み。バージョンを変更する場合はプロジェクト側でテストを行うこと。

> **補足**: Jackson1系はNablarch5u16よりサポート廃止。Jackson1系を使用していた場合はJackson2系へ移行すること。参考: https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-012258.html, https://github.com/advisories/GHSA-r6j9-8759-g62w

<details>
<summary>keywords</summary>

nablarch-jackson-adaptor, nablarch-jersey-adaptor, nablarch-resteasy-adaptor, Jacksonアダプタ, Jerseyアダプタ, RESTEasyアダプタ, モジュール依存関係, Jackson2.17.1, Jackson1系廃止

</details>

## Jersey環境下でRESTfulウェブサービスを使用する

ウェブアプリケーションサーバの[Jakarta RESTful Web Services](https://jakarta.ee/specifications/restful-ws/)実装が[Jersey](https://eclipse-ee4j.github.io/jersey/)の場合、`JaxRsMethodBinderFactory#handlerList`に`JerseyJaxRsHandlerListFactory`をファクトリインジェクションする。これによりJersey用の以下のハンドラ構成が自動設定される。

**:ref:`body_convert_handler` の設定（自動設定されるコンバータ）**:

| コンテントタイプ | コンバータクラス |
|---|---|
| JSON | `Jackson2BodyConverter` |
| XML | `JaxbBodyConverter` |
| application/x-www-form-urlencoded | `FormUrlEncodedConverter` |
| multipart/form-data | `MultipartFormDataBodyConverter` |

> **補足**: JSONコンバータはDate and Time API使用のため、[jackson-modules-java8](https://github.com/FasterXML/jackson-modules-java8)のJava 8 Date/timeモジュールを追加・設定済み。

- :ref:`jaxrs_bean_validation_handler`

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <property name="methodBinderFactory">
    <component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
      <property name="handlerList">
        <!-- handlerListプロパティにJerseyのハンドラキューをファクトリインジェクションする -->
        <component class="nablarch.integration.jaxrs.jersey.JerseyJaxRsHandlerListFactory"/>
      </property>
    </component>
  </property>
  <!-- 上記以外のプロパティは省略 -->
</component>
```

> **補足**: ウェブアプリケーションサーバに[Jackson](https://github.com/FasterXML/jackson)がバンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

<details>
<summary>keywords</summary>

JerseyJaxRsHandlerListFactory, JaxRsMethodBinderFactory, Jackson2BodyConverter, JaxbBodyConverter, FormUrlEncodedConverter, MultipartFormDataBodyConverter, jaxrs_bean_validation_handler, Jersey設定, ハンドラ自動構成, ボディコンバータ

</details>

## RESTEasy環境下でRESTfulウェブサービスを使用する

ウェブアプリケーションサーバの[Jakarta RESTful Web Services](https://jakarta.ee/specifications/restful-ws/)実装が[RESTEasy](https://resteasy.dev/)の場合、`JaxRsMethodBinderFactory#handlerList`に`ResteasyJaxRsHandlerListFactory`をファクトリインジェクションする。これによりRESTEasy用の以下のハンドラ構成が自動設定される。

**:ref:`body_convert_handler` の設定（自動設定されるコンバータ）**:

| コンテントタイプ | コンバータクラス |
|---|---|
| JSON | `Jackson2BodyConverter` |
| XML | `JaxbBodyConverter` |
| application/x-www-form-urlencoded | `FormUrlEncodedConverter` |
| multipart/form-data | `MultipartFormDataBodyConverter` |

> **補足**: JSONコンバータはDate and Time API使用のため、[jackson-modules-java8](https://github.com/FasterXML/jackson-modules-java8)のJava 8 Date/timeモジュールを追加・設定済み。

- :ref:`jaxrs_bean_validation_handler`

```xml
<component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
  <property name="methodBinderFactory">
    <component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
      <property name="handlerList">
        <!-- handlerListプロパティにRESTEasyのハンドラキューをファクトリインジェクションする -->
        <component class="nablarch.integration.jaxrs.resteasy.ResteasyJaxRsHandlerListFactory"/>
      </property>
    </component>
  </property>
  <!-- 上記以外のプロパティは省略 -->
</component>
```

> **補足**: ウェブアプリケーションサーバに[Jackson](https://github.com/FasterXML/jackson)がバンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

<details>
<summary>keywords</summary>

ResteasyJaxRsHandlerListFactory, JaxRsMethodBinderFactory, Jackson2BodyConverter, JaxbBodyConverter, FormUrlEncodedConverter, MultipartFormDataBodyConverter, jaxrs_bean_validation_handler, RESTEasy設定, ハンドラ自動構成, ボディコンバータ

</details>

## 各環境下で使用するボディコンバータを変更（追加）したい

プロジェクトで対応すべきMIMEが増えた場合は、`JaxRsHandlerListFactory`を実装して対応する。実装の参考として`JerseyJaxRsHandlerListFactory`および`ResteasyJaxRsHandlerListFactory`が利用できる。

<details>
<summary>keywords</summary>

JaxRsHandlerListFactory, JerseyJaxRsHandlerListFactory, ResteasyJaxRsHandlerListFactory, カスタムボディコンバータ, MIMEタイプ追加, ボディコンバータ変更, ボディコンバータ拡張

</details>
