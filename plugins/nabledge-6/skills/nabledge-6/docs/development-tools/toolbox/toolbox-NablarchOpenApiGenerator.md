# Nablarch OpenAPI Generator

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/toolbox/NablarchOpenApiGenerator/NablarchOpenApiGenerator.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/HttpResponse.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/JaxRsHttpRequest.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/jaxrs/EntityResponse.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Required.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/NumberRange.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/DecimalRange.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Length.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Size.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/validation/ee/Domain.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/beans/BeanUtil.html)

## ツールの概要

[OpenAPI](https://www.openapis.org/) ドキュメントからソースコードを生成する [OpenAPI Generator](https://openapi-generator.tech/) のGenerator実装。Nablarch RESTfulウェブサービス用のGeneratorを提供し、[OpenAPI GeneratorのMavenプラグイン](https://openapi-generator.tech/docs/plugins)に組み込んで実行することでソースコードを生成する。

生成されたソースコードを使用することで、OpenAPIドキュメントで定義したREST APIのインターフェースに従ったアクションクラスの実装が容易となる。

生成物:
- パス・オペレーション定義 → リソース(アクション)インターフェース
- スキーマ定義 → リクエスト/レスポンス対応モデル

> **重要**: NablarchのRESTfulウェブサービスはJakarta RESTful Web Servicesのすべてのアノテーションをサポートしているわけではないため、ここで記載する内容以外のOpenAPIドキュメントの内容は生成されるソースコードに反映されない。サポートしているアノテーションは :ref:`restful_web_service_architecture` および [router_adaptor_path_annotation](../../component/adapters/adapters-router_adaptor.md) を参照。

ソースコード生成時のデフォルト設定例:

```xml
<configuration>
  <inputSpec>${project.basedir}/src/main/resources/openapi.yaml</inputSpec>
  <generatorName>nablarch-jaxrs</generatorName>
  <configOptions>
    <sourceFolder>src/gen/java</sourceFolder>
    <apiPackage>com.example.api</apiPackage>
    <modelPackage>com.example.model</modelPackage>
  </configOptions>
</configuration>
```

各種例はイメージを掴むことを目的とするため抜粋での記載となっている。

<details>
<summary>keywords</summary>

OpenAPI Generator, nablarch-jaxrs, ソースコード生成, リソースインターフェース生成, モデル生成, RESTfulウェブサービス, nablarch-openapi-generator, OpenAPIジェネレーター, NablarchOpenApiGenerator, restful_web_service_architecture, router_adaptor_path_annotation, inputSpec, generatorName, sourceFolder, apiPackage, modelPackage, OpenAPIコード生成

</details>

## 前提条件

- Nablarch RESTfulウェブサービスのソースコード生成元となるOpenAPIドキュメントが作成済みであること
- OpenAPIドキュメントは[OpenAPI 3.0.3](https://spec.openapis.org/oas/v3.0.3.html)仕様で記述されていること

[rest_feature_details-method_signature](../../processing-pattern/restful-web-service/restful-web-service-resource_signature.md) に則った形で生成する。

**生成単位・型定義**:
- OpenAPIドキュメントのパスおよびオペレーション情報を元にJavaインターフェースとして生成
- 生成単位: デフォルトはパスの第一階層でまとめたもの。`useTags: true` の場合はオペレーションのタグ単位
- インターフェース宣言に `Path`、`Generated` アノテーションを注釈

**メソッド宣言に注釈するアノテーション**:

| アノテーション | 条件 |
|---|---|
| `GET` | HTTPメソッドがGETのオペレーション |
| `POST` | HTTPメソッドがPOSTのオペレーション |
| `PUT` | HTTPメソッドがPUTのオペレーション |
| `DELETE` | HTTPメソッドがDELETEのオペレーション |
| `PATCH` | HTTPメソッドがPATCHのオペレーション |
| `HEAD` | HTTPメソッドがHEADのオペレーション |
| `OPTIONS` | HTTPメソッドがOPTIONSのオペレーション |
| `Consumes` | リクエストのコンテンツタイプがある場合 |
| `Produces` | レスポンスのコンテンツタイプがあり、`type: string` かつ `format: binary` 以外の場合 |
| `Valid` | リクエストボディがあり、`useBeanValidation: true` の場合 |

> **補足**: `type: string` かつ `format: binary` はファイルダウンロードを意味する。この場合のコンテンツタイプは `HttpResponse#setContentType` で設定する。

**メソッド名の生成仕様**:
- `operationId` の値をメソッド名として使用
- `operationId` が未指定の場合はパス値とHTTPメソッド名を組み合わせて生成

**メソッド引数の生成仕様**:

| 引数の型 | 条件 |
|---|---|
| リクエストモデルの型 | リクエストボディあり、かつコンテンツタイプがマルチパート以外の場合 |
| `JaxRsHttpRequest` | 常に生成 |
| `ExecutionContext` | 常に生成 |

> **補足**: `PathParam`、`QueryParam` 等には対応していないため、`parameters` 定義はメソッド引数に反映されない。これらは `JaxRsHttpRequest` から取得すること。コンテンツタイプが `multipart/form-data` の場合はリクエストモデル引数は生成されない。アップロードされたファイルも `JaxRsHttpRequest` から取得する。

**メソッド戻り値の生成仕様**:

| 戻り値の型 | 条件 |
|---|---|
| `EntityResponse` | レスポンスがモデルの場合。型パラメータにモデルの型を反映 |
| `HttpResponse` | レスポンスがモデルでない場合、またはHTTPステータスコードが `200` 以外の場合 |

OpenAPIドキュメント例:

```yaml
/projects:
  post:
    operationId: createProject
    requestBody:
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ProjectCreateRequest'
    responses:
      "200":
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ProjectResponse'
/projects/{id}:
  get:
    operationId: findProjectById
    parameters:
    - name: id
      in: path
      required: true
      schema:
        type: string
    responses:
      "200":
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ProjectResponse'
      "404":
        description: プロジェクトが見つからなかった場合
```

生成されるリソース(アクション)インターフェース例:

```java
@Path("/projects")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public interface ProjectsApi {
    @POST
    @Consumes({ "application/json" })
    @Produces({ "application/json" })
    EntityResponse<ProjectResponse> createProject(ProjectCreateRequest projectCreateRequest, JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context);

    @GET
    @Path("/{id}")
    @Produces({ "application/json" })
    EntityResponse<ProjectResponse> findProjectById(JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context);
}
```

<details>
<summary>keywords</summary>

OpenAPI 3.0.3, 前提条件, OpenAPIドキュメント, JaxRsHttpRequest, ExecutionContext, EntityResponse, HttpResponse, nablarch.fw.jaxrs.JaxRsHttpRequest, nablarch.fw.ExecutionContext, nablarch.fw.jaxrs.EntityResponse, nablarch.fw.web.HttpResponse, @GET, @POST, @PUT, @DELETE, @PATCH, @HEAD, @OPTIONS, @Consumes, @Produces, @Valid, @Path, @Generated, リソースインターフェース生成, operationId, useTags, useBeanValidation, ProjectsApi, createProject, findProjectById, ProjectCreateRequest, ProjectResponse

</details>

## 動作概要

OpenAPIドキュメントを入力として以下を生成:

1. パス・オペレーション定義 → リソース(アクション)インターフェース
2. スキーマ定義 → リクエスト/レスポンス対応モデル

> **補足**: `.openapi-generator-ignore`、`.openapi-generator/FILES`、`.openapi-generator/VERSION` が `output` 指定ディレクトリ配下に生成されるが、これらは使用しない。

**生成単位・型定義**:
- スキーマとして定義しているモデルに対してJavaクラスとして生成
- `JsonTypeName`、`Generated` アノテーションを注釈

**プロパティ生成仕様**:
- スキーマに定義されたフィールドに対応するプロパティを生成
- getter/setterを生成し、`JsonProperty` アノテーションを注釈
- メソッドチェイン可能なセッターメソッドを生成（モデル自身の型を返す）
- `useBeanValidation: true` かつOpenAPIドキュメントにバリデーション定義がある場合、 [bean_validation](../../component/libraries/libraries-bean_validation.md) を使用したバリデーションを有効化
- バリデーションアノテーションはNablarch固有の [bean_validation](../../component/libraries/libraries-bean_validation.md) アノテーションと `jakarta.validation.constraints` パッケージのものを使用

**その他の生成仕様**:
- `hashCode`、`equals`、`toString` メソッドを生成

フォーマット→Javaの型変換: `uuid`→`UUID`、`int64`→`Long`、`date`→`LocalDate`

OpenAPIドキュメント例:

```yaml
ProjectResponse:
  description: プロジェクト情報
  type: object
  properties:
    id:
      format: uuid
      type: string
    name:
      type: string
    sales:
      format: int64
      type: integer
    startDate:
      format: date
      type: string
    endDate:
      format: date
      type: string
```

生成されるモデル例:

```java
@JsonTypeName("ProjectResponse")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public class ProjectResponse {
    private UUID id;
    private String name;
    private Long sales;
    private LocalDate startDate;
    private LocalDate endDate;

    @JsonProperty("id")
    public UUID getId() { return id; }
    @JsonProperty("id")
    public void setId(UUID id) { this.id = id; }

    // 他フィールドも同様に@JsonProperty付きgetter/setter
    // hashCode、equals、toString等は省略
}
```

<details>
<summary>keywords</summary>

ソースコード生成, リソースインターフェース, モデル生成, アクションインターフェース, @JsonTypeName, @JsonProperty, Bean Validation対応, useBeanValidation, nablarch.core.validation.ee.Required, nablarch.core.validation.ee.NumberRange, nablarch.core.validation.ee.DecimalRange, nablarch.core.validation.ee.Length, nablarch.core.validation.ee.Size, nablarch.core.validation.ee.Domain, @Required, @NumberRange, @DecimalRange, @Length, @Size, @Domain, @Pattern, jakarta.validation.constraints, ProjectResponse, UUID, Long, LocalDate, スキーマ定義, uuid, int64, date

</details>

## 運用方法

1. ウェブサービスの設計情報を元にOpenAPIドキュメントを作成する
2. Nablarch RESTfulウェブサービスのプロジェクトを作成し、MavenプラグインとしてOpenAPI Generatorおよび本ツールの設定を行う
3. プロジェクトをビルドし、リソース(アクション)インターフェースとモデルを生成する
4. 生成したリソース(アクション)インターフェースとモデルを使用して、Nablarch RESTfulウェブサービスの実装を行う

> **補足**: 本ツールはOpenAPIドキュメントの修正に合わせて繰り返し実行可能。アクションクラスは生成されたリソース(アクション)インターフェースを実装して作成するため、再実行してもアクションクラスの実装内容は失われない。

> **補足**: CLIでも使用可能。詳しくは「CLIとして実行する」を参照。

本ツールで生成されるソースコードをビルドするには、依存関係に以下のモジュールが必要になる。

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-jaxrs</artifactId>
</dependency>
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-core-validation-ee</artifactId>
</dependency>
<dependency>
  <groupId>jakarta.ws.rs</groupId>
  <artifactId>jakarta.ws.rs-api</artifactId>
</dependency>
<dependency>
  <groupId>jakarta.annotation</groupId>
  <artifactId>jakarta.annotation-api</artifactId>
</dependency>
<dependency>
  <groupId>com.fasterxml.jackson.core</groupId>
  <artifactId>jackson-annotations</artifactId>
  <version>2.17.1</version>
</dependency>
```

RESTfulウェブサービスのブランクプロジェクトの依存関係にはこれらがすべて含まれている。

`useBeanValidation`に`true`を指定する:

```xml
<configOptions>
  <!-- Bean Validationを使用する場合はuseBeanValidationにtrueを指定する -->
  <useBeanValidation>true</useBeanValidation>
</configOptions>
```

- `required`フィールドのgetterに`@Required`が付与される
- `maxLength`/`minLength`指定時のgetterに`@Length(min=..., max=...)`が付与される
- HTTPボディでリクエストを受け取るアクションメソッドに`@Valid`が付与される

OpenAPIドキュメント例:

```yaml
ProjectCreateRequest:
  required:
  - projectName
  - projectType
  - startDate
  properties:
    projectName:
      maxLength: 100
      minLength: 1
      type: string
    projectType:
      maxLength: 100
      minLength: 1
      type: string
    startDate:
      format: date
      type: string
    endDate:
      format: date
      type: string
```

生成されるリソース(アクション)インターフェース例（HTTPボディ受け取り時に`@Valid`が付与される）:

```java
@Path("/projects")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public interface ProjectsApi {
    @POST
    @Consumes({ "application/json" })
    @Produces({ "application/json" })
    @Valid
    EntityResponse<ProjectResponse> createProject(ProjectCreateRequest projectCreateRequest, JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context);
}
```

生成されるモデル例:

```java
@JsonTypeName("ProjectCreateRequest")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public class ProjectCreateRequest {
    @JsonProperty("projectName")
    @Required @Length(min = 1, max = 100)
    public String getProjectName() { ... }

    @JsonProperty("projectType")
    @Required @Length(min = 1, max = 100)
    public String getProjectType() { ... }

    @JsonProperty("startDate")
    @Required
    public LocalDate getStartDate() { ... }

    @JsonProperty("endDate")
    public LocalDate getEndDate() { ... }
    // hashCode、equals、toString等は省略
}
```

<details>
<summary>keywords</summary>

運用手順, ソースコード再生成, アクションクラス実装, 繰り返し実行, nablarch-fw-jaxrs, nablarch-core-validation-ee, jackson-annotations, jakarta.ws.rs-api, jakarta.annotation-api, ProjectCreateRequest, @Valid, @Required, @Length, @JsonTypeName, useBeanValidation, Bean Validation, ProjectsApi, EntityResponse, LocalDate

</details>

## Mavenプラグインの設定

本ツールを使用するために最低限必要な、OpenAPI GeneratorのMavenプラグインの設定例:

```xml
<plugin>
  <groupId>org.openapitools</groupId>
  <artifactId>openapi-generator-maven-plugin</artifactId>
  <version>7.10.0</version>
  <dependencies>
    <!-- 本ツールのモジュールを依存関係に追加 -->
    <dependency>
      <groupId>com.nablarch.tool</groupId>
      <artifactId>nablarch-openapi-generator</artifactId>
      <version>1.0.0</version>
    </dependency>
  </dependencies>
  <executions>
    <execution>
      <goals>
        <goal>generate</goal>
      </goals>
      <configuration>
        <!-- OpenAPIドキュメントのファイルパスを指定する -->
        <inputSpec>${project.basedir}/src/main/resources/openapi.yaml</inputSpec>
        <generatorName>nablarch-jaxrs</generatorName>
        <configOptions>
          <sourceFolder>src/gen/java</sourceFolder>
          <apiPackage>com.example.api</apiPackage>
          <modelPackage>com.example.model</modelPackage>
          <!-- その他、本ツールのオプションを指定する -->
        </configOptions>
      </configuration>
    </execution>
  </executions>
</plugin>
```

本ツールは以下の依存関係により提供される:

```xml
<dependency>
  <groupId>com.nablarch.tool</groupId>
  <artifactId>nablarch-openapi-generator</artifactId>
  <version>1.0.0</version>
</dependency>
```

必須設定: `inputSpec`（OpenAPIドキュメントのファイルパス）と `generatorName`（`nablarch-jaxrs` を指定）。その他の設定項目は「Generatorの設定項目」を参照。

> **補足**: 本ツールはOpenAPI Generator 7.10.0で開発・テスト済み。バージョンを変更する場合はプロジェクト側でテストを行うこと。

OpenAPIドキュメント上で定義されたデータ型とフォーマットに対して、本ツールによるJavaのデータ型の対応表を以下に示す。

| OpenAPIのtype | OpenAPIのformat | Javaのデータ型 |
|---|---|---|
| `integer` | (なし) | `java.lang.Integer` |
| `integer` | `int32` | `java.lang.Integer` |
| `integer` | `int64` | `java.lang.Long` |
| `number` | (なし) | `java.math.BigDecimal` |
| `number` | `float` | `java.lang.Float` |
| `number` | `double` | `java.lang.Double` |
| `boolean` | (なし) | `java.lang.Boolean` |
| `string` | (なし) | `java.lang.String` |
| `string` | `byte` | `byte[]` |
| `string` | `date` | `java.time.LocalDate` |
| `string` | `date-time` | `java.time.OffsetDateTime` |
| `string` | `number` | `java.math.BigDecimal` |
| `string` | `uuid` | `java.util.UUID` |
| `string` | `uri` | `java.net.URI` |
| `string` | (`enum` 指定時) | 対応するEnum型を生成 |
| `array` | (なし) | `java.util.List` |
| `array` | (`uniqueItems: true`) | `java.util.Set` |
| `object` | (なし) | 対応するモデルの型 |
| `object` | (対応する型がない場合) | `java.lang.Object` |

> **補足**: `type: string` かつ `format: binary` はリクエストのコンテンツタイプが `multipart/form-data` の場合のみ利用可能。それ以外のコンテンツタイプやレスポンスのモデル定義内で使用した場合はモデルの生成を中止する。上記表以外の `type: string` フォーマットはすべて `java.lang.String` として生成する。

`x-nablarch-domain`拡張属性に値を指定すると`@Domain`アノテーションが生成される（`useBeanValidation`も`true`にする）:

OpenAPIドキュメント例:

```yaml
ProjectCreateRequest:
  required:
  - projectName
  properties:
    projectName:
      type: string
      x-nablarch-domain: "projectName"
```

生成されるモデル例:

```java
@JsonTypeName("ProjectCreateRequest")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public class ProjectCreateRequest {
    @JsonProperty("projectName")
    @Required @Domain("projectName")
    public String getProjectName() { ... }
}
```

<details>
<summary>keywords</summary>

openapi-generator-maven-plugin, Maven設定, inputSpec, generatorName, nablarch-jaxrs, nablarch-openapi-generator, 依存関係, OpenAPI Generator 7.10.0, データ型対応表, OpenAPIデータ型, type, format, integer, number, boolean, string, array, object, java.lang.Integer, java.lang.Long, java.math.BigDecimal, java.lang.Float, java.lang.Double, java.lang.Boolean, java.lang.String, byte[], java.time.LocalDate, java.time.OffsetDateTime, java.util.UUID, java.net.URI, java.util.List, java.util.Set, uniqueItems, multipart/form-data, binary, @Domain, x-nablarch-domain, ドメインバリデーション, @JsonTypeName, ProjectCreateRequest, useBeanValidation, @Required

</details>

## 実行方法

本ツールはMavenの `compile` ゴールで実行できる:

```
mvn compile
```

`sourceFolder` を明示的に設定した場合、`mvn compile` 時に生成されたソースコードがコンパイル対象に含まれる（OpenAPI GeneratorのMavenプラグインによる動作）。

`useBeanValidation` のデフォルト値は `false`。`true` に設定した場合、以下の2方針でプロパティにアノテーションを注釈する。

## OpenAPI仕様プロパティによるバリデーション

[OpenAPI仕様のプロパティ(外部サイト、英語)](https://spec.openapis.org/oas/v3.0.3.html#properties) を使用したバリデーション定義の対応表:

| OpenAPIのtype | OpenAPIのformat | 使用プロパティ | 注釈するアノテーション |
|---|---|---|---|
| `integer` | (フォーマット問わない) | `required` | `Required` |
| `integer` | (なし/`int32`/`int64`) | `minimum`/`maximum` | `NumberRange(min, max)` |
| `number` | (フォーマット問わない) | `required` | `Required` |
| `number` | (なし/`float`/`double`) | `minimum`/`maximum` | `DecimalRange(min, max)` |
| `boolean` | (なし) | `required` | `Required` |
| `string` | (フォーマット問わない) | `required` | `Required` |
| `string` | (なし) | `minLength`/`maxLength` | `Length(min, max)` |
| `string` | (なし) | `pattern` | `Pattern(regexp)` |
| `array` | (なし) | `required` | `Required` |
| `array` | (なし) | `minItems`/`maxItems` | `Size(min, max)` |

> **補足**: `multipleOf`、`exclusiveMinimum`、`exclusiveMaximum`、`minProperties`、`maxProperties` には対応していない。`minimum`/`maximum`、`minLength`/`maxLength`、`minItems`/`maxItems` はどちらか片方のみでも指定可能。Javaのデータ型が `java.math.BigDecimal`、`java.util.List`、`java.util.Set`、またはモデルの場合は `Valid` アノテーションを注釈する。`Pattern` のみJakarta Bean Validation標準のアノテーションで、それ以外はNablarch固有のアノテーション。

## ドメインバリデーション

[OpenAPI仕様の拡張プロパティ(外部サイト、英語)](https://spec.openapis.org/oas/v3.0.3.html#specification-extensions) `x-nablarch-domain` を使用して [bean_validation-domain_validation](../../component/libraries/libraries-bean_validation.md) をサポートする。値にはドメイン名を指定する。

```yaml
propertyName:
  type: string
  x-nablarch-domain: "domainName"
```

`useBeanValidation: true` でソースコードを生成すると、対象プロパティに `Domain("{domainName}")` が注釈される。

> **重要**: ドメインバリデーションと競合する可能性があるバリデーション定義を検出した場合はソースコードの生成を中止する。`x-nablarch-domain` を指定したプロパティに `minimum`、`maximum`、`minLength`、`maxLength`、`minItems`、`maxItems`、`pattern` のいずれかが指定されている場合は生成を中止する。`required` のみ併用可能。

ファイルアップロードの場合、リクエストのコンテンツタイプには `multipart/form-data` を指定する。アップロードファイルには `type: string` かつ `format: binary` を指定する。この時、スキーマに対応するモデルのソースコードは生成されない。アップロードされたファイルは `JaxRsHttpRequest` より取得する。

OpenAPIドキュメント例:

```yaml
/customers/upload:
  post:
    operationId: uploadCustomersCsvFile
    requestBody:
      content:
        multipart/form-data:
          schema:
            $ref: '#/components/schemas/CustomersCsvFileUploadRequest'
    responses:
      "200":
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CustomersCsvFileUploadResultResponse'
```

スキーマ定義（`format: binary`のフィールドを含む場合、モデルクラスは生成されない）:

```yaml
CustomersCsvFileUploadRequest:
  required:
  - fileName
  - file
  type: object
  properties:
    fileName:
      type: string
    file:
      type: string
      format: binary
```

生成されるリソース(アクション)インターフェース例:

```java
@Path("/customers/upload")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public interface CustomersApi {
    @POST
    @Consumes({ "multipart/form-data" })
    @Produces({ "application/json" })
    EntityResponse<CustomersCsvFileUploadResultResponse> uploadCustomersCsvFile(JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context);
}
```

<details>
<summary>keywords</summary>

mvn compile, Mavenビルド, sourceFolder, コンパイル対象, Bean Validation対応, ドメインバリデーション, useBeanValidation, x-nablarch-domain, @Required, @NumberRange, @DecimalRange, @Length, @Size, @Domain, @Pattern, required, minimum, maximum, minLength, maxLength, minItems, maxItems, pattern, Domain, nablarch.core.validation.ee.Domain, CustomersApi, CustomersCsvFileUploadRequest, CustomersCsvFileUploadResultResponse, multipart/form-data, ファイルアップロード, format: binary, @Consumes, JaxRsHttpRequest, EntityResponse

</details>

## 出力先

OpenAPI GeneratorのMavenプラグインのデフォルト設定では、生成されたソースコードは `target/generated-sources/openapi/src/gen/java` に出力される。

出力先を変更したい場合は「Generatorの設定項目」の `output` と `sourceFolder` を参照。

本ツールを使用して、バリデーション定義を含めたソースコードを生成する場合の運用上の注意点を記載する。

## OpenAPI仕様の規定範囲でバリデーション要件を満たせない場合

OpenAPI仕様で規定されているバリデーションは必須定義・長さチェック・正規表現のみのため、業務アプリケーションが求めるものとして不足することがある。自動生成されたソースコードを直接修正することは望ましくないため、ドメインバリデーションを使用しても生成されたモデルに相関バリデーションを実装できない。

> **重要**: バリデーション定義が自動生成モデルと手動実装フォーム等に分散されやすい状況になる点に注意すること。本ツールがデフォルトでバリデーションアノテーションを注釈しないのは、この分散が望ましくないと考えているためである。

[bean_validation-execute_explicitly](../../component/libraries/libraries-bean_validation.md) と同様のアプローチで実装する。自動生成モデルと同じプロパティ定義のフォームを作成し、 `BeanUtil` でプロパティ値をコピー後、バリデーションを実施する:

```java
public class ProjectAction implements ProjectsApi {
    @Override
    public EntityResponse<ProjectResponse> createProject(ProjectCreateRequest projectCreateRequest, JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context) {
        ProjectCreateForm form;
        try {
            form = ProjectValidatorUtil.validate(ProjectCreateForm.class, projectCreateRequest);
        } catch (ApplicationException e) {
            throw e;
        }
        return response;
    }
}

public final class ProjectValidatorUtil {
    public static <T> T validate(Class<T> beanClass, Object src) {
        T bean = BeanUtil.createAndCopy(beanClass, src);
        ValidatorUtil.validate(bean);
        return bean;
    }
}
```

## ドメインバリデーション使用時の注意点

> **重要**: ドメインバリデーションを使用すると、バリデーション仕様がドメイン側に隠蔽されやすくなり、OpenAPIドキュメントからバリデーション仕様が見えなくなる可能性がある点に注意すること。

ファイルダウンロードではレスポンスのコンテンツタイプは任意となる。レスポンスのスキーマ定義は `type: string` かつ `format: binary` とし、ダウンロードするファイルの内容やレスポンスヘッダは `HttpResponse` を使って設定する。

OpenAPIドキュメント例:

```yaml
/customers/upload:
  get:
    operationId: downloadCustomersCsvFile
    responses:
      "200":
        content:
          text/csv:
            schema:
              type: string
              format: binary
```

生成されるリソース(アクション)インターフェース例:

```java
@Path("/customers/upload")
@jakarta.annotation.Generated(value = "nablarch.tool.openapi.codegen.JavaNablarchJaxrsServerCodegen", ...)
public interface CustomersApi {
    @GET
    HttpResponse downloadCustomersCsvFile(JaxRsHttpRequest jaxRsHttpRequest, ExecutionContext context);
}
```

<details>
<summary>keywords</summary>

出力先, target/generated-sources/openapi, output, sourceFolder, バリデーション運用上の注意点, BeanUtil, ValidatorUtil, nablarch.core.beans.BeanUtil, bean_validation-execute_explicitly, ApplicationException, 相関バリデーション, ドメインバリデーション, ProjectValidatorUtil, CustomersApi, HttpResponse, text/csv, ファイルダウンロード, format: binary, @GET, JaxRsHttpRequest

</details>

## Generatorの設定項目

`configuration` タグ内直下の設定:

| 項目名 | 設定内容 | 必須/任意 | デフォルト値 |
|---|---|---|---|
| `inputSpec` | 入力OpenAPIドキュメントのファイルパス | 必須 | なし |
| `generatorName` | Generatorの名前。`nablarch-jaxrs` を指定 | 必須 | なし |
| `output` | ソースコード生成先ディレクトリ | 任意 | `generated-sources/openapi` |

`configOptions` タグ内の本ツール固有設定（すべて任意）:

| 項目名 | 設定内容 | デフォルト値 |
|---|---|---|
| `apiPackage` | リソース(アクション)インターフェースのパッケージ | `org.openapitools.api` |
| `modelPackage` | モデルのパッケージ | `org.openapitools.model` |
| `hideGenerationTimestamp` | `Generated` アノテーションに `date` 属性を付与するか否か（falseでは生成日時が出力される） | `false` |
| `sourceFolder` | ソースコード生成先（`output` からの相対パス）。指定するとコンパイル対象に含まれる | `src/gen/java` |
| `useTags` | インターフェース単位をパスではなくタグ単位にする（複数タグ時は最初のタグが有効） | `false` |
| `serializableModel` | モデルに `java.io.Serializable` を実装 | `false` |
| `generateBuilders` | モデルのビルダークラスを生成 | `false` |
| `useBeanValidation` | OpenAPIドキュメントのバリデーション定義から Bean Validation アノテーションを生成 | `false` |
| `additionalModelTypeAnnotations` | モデルクラス宣言に追加アノテーション（複数は `;` 区切り） | なし |
| `additionalEnumTypeAnnotations` | enum型に追加アノテーション（複数は `;` 区切り） | なし |
| `primitivePropertiesAsString` | プリミティブ型プロパティをすべて `String` として出力 | `false` |
| `supportConsumesMediaTypes` | リクエストを受け付けるメディアタイプ（`,` 区切り） | `application/json,multipart/form-data` |
| `supportProducesMediaTypes` | レスポンスとするメディアタイプ（`,` 区切り） | `application/json` |

<details>
<summary>keywords</summary>

inputSpec, generatorName, output, apiPackage, modelPackage, hideGenerationTimestamp, sourceFolder, useTags, serializableModel, generateBuilders, useBeanValidation, additionalModelTypeAnnotations, additionalEnumTypeAnnotations, primitivePropertiesAsString, supportConsumesMediaTypes, supportProducesMediaTypes, configOptions, 設定項目

</details>

## Bean Validationを使用するソースコードを生成する

`useBeanValidation` を `true` に設定することで、OpenAPIドキュメントのバリデーション定義から Bean Validation の機能を使ったバリデーションを行うソースコードを生成する。デフォルトは `false`。

設定例:
```xml
<configuration>
  <inputSpec>${project.basedir}/src/main/resources/openapi.yaml</inputSpec>
  <generatorName>nablarch-jaxrs</generatorName>
  <configOptions>
    <sourceFolder>src/gen/java</sourceFolder>
    <apiPackage>com.example.api</apiPackage>
    <modelPackage>com.example.model</modelPackage>
    <!-- Bean Validationを使用するソースコードを生成する -->
    <useBeanValidation>true</useBeanValidation>
  </configOptions>
</configuration>
```

> **補足**: OpenAPI仕様のバリデーション定義では業務要件を満たせないことが多く、相関バリデーションも定義できないため、デフォルトは `false`。バリデーション機能を使用する場合の仕様や運用上の注意点は Bean Validationのプロパティ変換 に詳細に記載されている。

<details>
<summary>keywords</summary>

useBeanValidation, Bean Validation, バリデーション, bean_validation

</details>

## CLIとして実行する

本ツールは主にMavenプラグインとして使用することを想定しているが、CLIとしても使用可能。

[OpenAPI Generator 7.10.0のJAR](https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/7.10.0/openapi-generator-cli-7.10.0.jar)と[本ツールのJAR](https://repo1.maven.org/maven2/com/nablarch/tool/nablarch-openapi-generator/1.0.0/nablarch-openapi-generator-1.0.0.jar)をダウンロードして実行:

```
java -cp openapi-generator-cli-7.10.0.jar:nablarch-openapi-generator-1.0.0.jar org.openapitools.codegen.OpenAPIGenerator generate --generator-name nablarch-jaxrs --input-spec openapi.yaml --output out --additional-properties=apiPackage=com.example.api,modelPackage=com.example.model,useBeanValidation=true,hideGenerationTimestamp=true
```

- `--generator-name` には `nablarch-jaxrs` を指定
- OpenAPI Generator設定項目はCLIでもハイフン区切り形式で指定可能（詳細: `java -jar openapi-generator-cli-7.10.0.jar help generate`）
- 本ツール固有の設定項目は `--additional-properties` に `key=value` 形式で指定（複数は `,` 区切り）

> **補足**: 本ツール固有の設定項目は `--additional-properties=hideGenerationTimestamp=true` のように `--additional-properties=` に続けて項目名をそのまま指定する。

<details>
<summary>keywords</summary>

CLI, CLIとして実行, java -cp, openapi-generator-cli, --generator-name, --input-spec, --additional-properties, JARファイル

</details>
