# JAX-RSアダプタ

**目次**

* モジュール一覧
* Jersey環境下でRESTfulウェブサービスを使用する
* RESTEasy環境下でRESTfulウェブサービスを使用する
* 各環境下で使用するボディコンバータを変更（追加）したい

[RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) で使用するための以下のアダプタを提供する。

* JSONを [Jackson(外部サイト、英語)](https://github.com/FasterXML/jackson) を使って変換するアダプタ
* [Jersey(外部サイト、英語)](https://eclipse-ee4j.github.io/jersey/)  で [RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) を使用するためのアダプタ
* [RESTEasy(外部サイト、英語)](https://resteasy.dev/) で [RESTfulウェブサービス](../../processing-pattern/restful-web-service/restful-web-service-rest.md#restful-web-service) を使用するためのアダプタ

## モジュール一覧

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

> **Tip:**
> Jacksonのバージョン2.12.7.1を使用してテストを行っている。
> バージョンを変更する場合は、プロジェクト側でテストを行い問題ないことを確認すること。

> **Tip:**
> Jackson1系ライブラリの脆弱性対応が行われなくなったため、Nablarch5u16よりJackson1系のサポートを廃止した。
> Jackson1系を使用していた場合はJackson2系へ移行すること。

> 【参考情報】

> * >   [https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-012258.html](https://jvndb.jvn.jp/ja/contents/2019/JVNDB-2019-012258.html)
> * >   [https://github.com/advisories/GHSA-r6j9-8759-g62w](https://github.com/advisories/GHSA-r6j9-8759-g62w)

## Jersey環境下でRESTfulウェブサービスを使用する

ウェブアプリケーションサーバにバンドルされている [JAX-RS(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=339) の実装が、
[Jersey(外部サイト、英語)](https://eclipse-ee4j.github.io/jersey/) の場合には、Jersey用のアダプタを使用する。

以下にJersey用アダプタの適用方法を示す。

JaxRsMethodBinderFactory#handlerList
に対して、Jersey用のハンドラを構築するファクトリクラス(JerseyJaxRsHandlerListFactory)
をファクトリインジェクションする。これにより、Jersey用の以下のハンドラ構成が自動的に設定される。

* [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) の設定(以下のコンバータが設定される)

  * JSONのコンバータには Jackson2BodyConverter が設定される。
  * XMLのコンバータには JaxbBodyConverter が設定される。
  * application/x-www-form-urlencodedのコンバータには FormUrlEncodedConverter が設定される。
* [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler)

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

> **Tip:**
> 使用するウェブアプリケーションサーバに [Jackson(外部サイト、英語)](https://github.com/FasterXML/jackson) が
> バンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

## RESTEasy環境下でRESTfulウェブサービスを使用する

ウェブアプリケーションサーバにバンドルされている [JAX-RS(外部サイト、英語)](https://jcp.org/en/jsr/detail?id=339) の実装が、
[RESTEasy(外部サイト、英語)](https://resteasy.dev/) の場合には、RESTEasy用のアダプタを使用する。

以下にRESTEasy用アダプタの適用方法を示す。

JaxRsMethodBinderFactory#handlerList
に対して、RESTEasy用のハンドラを構築するファクトリクラス(ResteasyJaxRsHandlerListFactory)
をファクトリインジェクションする。これにより、RESTEasy用の以下のハンドラ構成が自動的に設定される。

* [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) の設定(以下のコンバータが設定される)

  * JSONのコンバータには Jackson2BodyConverter が設定される。
  * XMLのコンバータには JaxbBodyConverter が設定される。
  * application/x-www-form-urlencodedのコンバータには FormUrlEncodedConverter が設定される。
* [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler)

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

> **Tip:**
> 使用するウェブアプリケーションサーバに [Jackson(外部サイト、英語)](https://github.com/FasterXML/jackson) が
> バンドルされていない場合は、Jacksonのモジュールをアプリケーションモジュールとセットでデプロイすること。

## 各環境下で使用するボディコンバータを変更（追加）したい

プロジェクトで対応すべきMIMEが増えた場合には、 JaxRsHandlerListFactory を実装し対応する。

実装方法は、本アダプタ
(JerseyJaxRsHandlerListFactory 、 ResteasyJaxRsHandlerListFactory)
を参考にすると良い。
