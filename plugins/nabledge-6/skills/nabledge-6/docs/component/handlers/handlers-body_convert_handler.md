# リクエストボディ変換ハンドラ

## ハンドラクラス名

**クラス名**: `nablarch.fw.jaxrs.BodyConvertHandler`

リクエストボディとレスポンスボディの変換処理を行うハンドラ。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
```

## 制約

本ハンドラは `router_adaptor` よりも後ろに設定すること。リソース(アクション)クラスのメソッドに設定されたアノテーション情報を元に変換処理を行うため、ディスパッチ先を特定する `router_adaptor` よりも後ろに配置する必要がある。

## 変換処理を行うコンバータを設定する

`bodyConverters` プロパティに、プロジェクトで使用するMIMEに対応した `BodyConverter` の実装クラスを設定する。

> **補足**: 設定されたコンバータで変換できないMIMEが使用された場合、ステータスコード `415` を返却する。

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

## リクエストボディをFormに変換する

リクエストボディの変換フォーマットはメソッドの `Consumes` アノテーションで決まる。リクエストヘッダの `Content-Type` が `Consumes` のMIMEと異なる場合、ステータスコード `415` を返却する。

この例では、`MediaType.APPLICATION_JSON` が示す `application/json` に対応した `BodyConverter` でリクエストボディが `Person` に変換される。

```java
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public HttpResponse saveJson(Person person) {
    UniversalDao.insert(person);
    return new HttpResponse();
}
```

## リソース(アクション)の処理結果をレスポンスボディに変換する

レスポンスボディへの変換フォーマットはメソッドの `Produces` アノテーションで決まる。

この例では、`MediaType.APPLICATION_JSON` が示す `application/json` に対応した `BodyConverter` でリクエストボディが `Person` に変換される。

```java
GET
@Produces(MediaType.APPLICATION_JSON)
public List<Person> findJson() {
    return UniversalDao.findAll(Person.class);
}
```
