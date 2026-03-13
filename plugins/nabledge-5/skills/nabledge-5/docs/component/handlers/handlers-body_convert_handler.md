# リクエストボディ変換ハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/rest/body_convert_handler.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/BodyConvertHandler.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/Consumes.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/javax/ws/rs/Produces.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/BodyConverter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxbBodyConverter.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/FormUrlEncodedConverter.html)

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.BodyConvertHandler`

リクエストボディとレスポンスボディの変換処理を行うハンドラ。

<details>
<summary>keywords</summary>

BodyConvertHandler, nablarch.fw.jaxrs.BodyConvertHandler, ハンドラクラス名, リクエストボディ変換ハンドラ

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-jaxrs, com.nablarch.framework, モジュール依存, Maven依存関係

</details>

## 制約

[router_adaptor](../adapters/adapters-router_adaptor.md) よりも後ろに設定すること。このハンドラはリソース(アクション)クラスのメソッドに設定されたアノテーション情報を元にリクエスト及びレスポンスの変換処理を行うため、ディスパッチ先を特定する [router_adaptor](../adapters/adapters-router_adaptor.md) よりも後ろに設定する必要がある。

<details>
<summary>keywords</summary>

router_adaptor, 設定順序, ハンドラ配置制約, ディスパッチ

</details>

## 変換処理を行うコンバータを設定する

`bodyConverters` プロパティに、プロジェクトで使用するMIMEに対応した `BodyConverter` の実装クラスを設定する。

```xml
<component class="nablarch.fw.jaxrs.BodyConvertHandler">
  <property name="bodyConverters">
    <list>
      <!-- application/xmlに対応したリクエスト・レスポンスのコンバータ -->
      <component class="nablarch.fw.jaxrs.JaxbBodyConverter" />
      <!-- application/x-www-form-urlencodedに対応したリクエスト・レスポンスのコンバータ -->
      <component class="nablarch.fw.jaxrs.FormUrlEncodedConverter" />
    </list>
  </property>
</component>
```

> **補足**: `bodyConverters` に設定されたコンバータで変換できないMIMEが使用された場合、サポートしていないメディアタイプを示すステータスコード(`415`)を返却する。

<details>
<summary>keywords</summary>

bodyConverters, BodyConverter, JaxbBodyConverter, FormUrlEncodedConverter, MIMEタイプ, 415ステータスコード, コンバータ設定

</details>

## リクエストボディをFormに変換する

リクエストボディの変換フォーマットは、メソッドに設定された `Consumes` アノテーションで決まる。`@Consumes` に設定されたMIMEとリクエストヘッダのContent-Typeが異なる場合、ステータスコード(`415`)を返却する。

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse saveJson(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```

<details>
<summary>keywords</summary>

@Consumes, Consumes, Content-Type, 415ステータスコード, リクエストボディ変換, MediaType.APPLICATION_JSON

</details>

## リソース(アクション)の処理結果をレスポンスボディに変換する

レスポンスボディへの変換フォーマットは、メソッドに設定された `Produces` アノテーションで決まる。

```java
GET
@Produces(MediaType.APPLICATION_JSON)
public List<Person> findJson() {
    return UniversalDao.findAll(Person.class);
}
```

<details>
<summary>keywords</summary>

@Produces, Produces, レスポンスボディ変換, MediaType.APPLICATION_JSON, findJson

</details>
