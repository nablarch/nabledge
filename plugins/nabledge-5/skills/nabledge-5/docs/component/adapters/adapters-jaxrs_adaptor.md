# JAX-RSアダプタ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/adaptors/jaxrs_adaptor.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsMethodBinderFactory.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/jersey/JerseyJaxRsHandlerListFactory.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/jackson/Jackson2BodyConverter.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxbBodyConverter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/FormUrlEncodedConverter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/integration/jaxrs/resteasy/ResteasyJaxRsHandlerListFactory.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHandlerListFactory.html)

## モジュール一覧

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

> **補足**: Jackson 2.12.7.1でテスト済み。バージョンを変更する場合はプロジェクト側でテストを行い問題ないことを確認すること。

> **補足**: Nablarch5u16よりJackson1系のサポートを廃止（セキュリティ脆弱性への対応が行われなくなったため）。Jackson1系を使用していた場合はJackson2系へ移行すること。参考: [JVNDB-2019-012258](https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-012258.html)、[GHSA-r6j9-8759-g62w](https://github.com/advisories/GHSA-r6j9-8759-g62w)

<details>
<summary>keywords</summary>

nablarch-jackson-adaptor, nablarch-jersey-adaptor, nablarch-resteasy-adaptor, Jacksonアダプタ, Jerseyアダプタ, RESTEasyアダプタ, Jackson1系廃止, モジュール依存関係

</details>

## Jersey環境下でRESTfulウェブサービスを使用する

JAX-RSの実装がJerseyの場合、Jersey用アダプタを使用する。

`JaxRsMethodBinderFactory#handlerList` に対して `JerseyJaxRsHandlerListFactory` をファクトリインジェクションする。これにより以下のハンドラ構成が自動的に設定される:

- [body_convert_handler](../handlers/handlers-body_convert_handler.md)（以下のコンバータが設定される）:
  - JSONコンバータ: `Jackson2BodyConverter`
  - XMLコンバータ: `JaxbBodyConverter`
  - application/x-www-form-urlencodedコンバータ: `FormUrlEncodedConverter`
- [jaxrs_bean_validation_handler](../handlers/handlers-jaxrs_bean_validation_handler.md)

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
</component>
```

> **補足**: 使用するウェブアプリケーションサーバにJacksonがバンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

<details>
<summary>keywords</summary>

JerseyJaxRsHandlerListFactory, JaxRsMethodBinderFactory, Jackson2BodyConverter, JaxbBodyConverter, FormUrlEncodedConverter, Jersey設定, ファクトリインジェクション, ボディコンバータ自動設定

</details>

## RESTEasy環境下でRESTfulウェブサービスを使用する

JAX-RSの実装がRESTEasyの場合、RESTEasy用アダプタを使用する。

`JaxRsMethodBinderFactory#handlerList` に対して `ResteasyJaxRsHandlerListFactory` をファクトリインジェクションする。これにより以下のハンドラ構成が自動的に設定される:

- [body_convert_handler](../handlers/handlers-body_convert_handler.md)（以下のコンバータが設定される）:
  - JSONコンバータ: `Jackson2BodyConverter`
  - XMLコンバータ: `JaxbBodyConverter`
  - application/x-www-form-urlencodedコンバータ: `FormUrlEncodedConverter`
- [jaxrs_bean_validation_handler](../handlers/handlers-jaxrs_bean_validation_handler.md)

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
</component>
```

> **補足**: 使用するウェブアプリケーションサーバにJacksonがバンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

<details>
<summary>keywords</summary>

ResteasyJaxRsHandlerListFactory, JaxRsMethodBinderFactory, Jackson2BodyConverter, JaxbBodyConverter, FormUrlEncodedConverter, RESTEasy設定, ファクトリインジェクション, ボディコンバータ自動設定

</details>

## 各環境下で使用するボディコンバータを変更（追加）したい

プロジェクトで対応すべきMIMEが増えた場合は、`JaxRsHandlerListFactory` を実装して対応する。実装時は `JerseyJaxRsHandlerListFactory` または `ResteasyJaxRsHandlerListFactory` を参考にすること。

<details>
<summary>keywords</summary>

JaxRsHandlerListFactory, JerseyJaxRsHandlerListFactory, ResteasyJaxRsHandlerListFactory, カスタムボディコンバータ, MIMEタイプ追加, ハンドラリストカスタマイズ

</details>
