# アーキテクチャ概要

**公式ドキュメント**: [アーキテクチャ概要](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/architecture.html)

## RESTfulウェブサービスの構成

Jakarta RESTful Web ServicesサポートはNablarchのウェブアプリケーションをベースとする。

> **補足**: Nablarch5では「JAX-RSサポート」と呼ばれていたが、Java EEのEclipse Foundation移管に伴い仕様名が変わったため、Nablarch6で「Jakarta RESTful Web Servicesサポート」に名称変更。機能的な差はなし。

使用できるアノテーション:
- `@Produces`（レスポンスのメディアタイプ指定）
- `@Consumes`（リクエストのメディアタイプ指定）
- `@Valid`（リクエストに対するBeanValidation実行）

使用不可: `@Context`アノテーションによるServletリソースインジェクション、Jakarta Contexts and Dependency Injection

> **重要**: クライアントサイドの機能は提供しない。Jakarta RESTful Web Servicesのクライアントが必要な場合は、JerseyやRESTEasyなどのJakarta RESTful Web Services実装を使用すること。

構成はNablarchウェブアプリケーションと同じ。詳細は [web_application-structure](../web-application/web-application-architecture.md) を参照。

<details>
<summary>keywords</summary>

Jakarta RESTful Web Servicesサポート, @Produces, @Consumes, @Valid, ウェブサービス構成, クライアントサイド制限, 使用可能アノテーション, Servletリソースインジェクション, Jakarta CDI

</details>

## RESTfulウェブサービスの処理の流れ

1. [web_front_controller](../web-application/web-application-web_front_controller.md)（`jakarta.servlet.Filter`実装クラス）がリクエストを受信する。
2. [web_front_controller](../web-application/web-application-web_front_controller.md) がリクエストの処理をハンドラキュー（handler queue）に委譲する。
3. `DispatchHandler`がURIを元に処理すべきアクションクラスを特定し、ハンドラキューの末尾に追加する。
4. アクションクラスがフォームクラス/エンティティクラスを使用して業務ロジックを実行する。各クラスの詳細は [rest-application_design](restful-web-service-application_design.md) を参照。
5. アクションクラスが処理結果のDTOまたは`HttpResponse`を作成し返却する。
6. `JaxRsResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換して応答する。アクションの処理結果がフォームクラスの場合は`BodyConvertHandler`により`HttpResponse`に変換され、ボディ形式はアクションクラスに設定されたメディアタイプとなる。

<details>
<summary>keywords</summary>

WebFrontController, DispatchHandler, JaxRsResponseHandler, BodyConvertHandler, HttpResponse, 処理フロー, ハンドラキュー, jakarta.servlet.Filter

</details>

## RESTfulウェブサービスで使用するハンドラ

RESTfulウェブサービス構築用ハンドラ一覧:

**リクエスト・レスポンス変換**
- [jaxrs_response_handler](../../component/handlers/handlers-jaxrs_response_handler.md)
- [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md)

**データベース関連**
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**リクエスト検証**
- [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md)
- [csrf_token_verification_handler](../../component/handlers/handlers-csrf_token_verification_handler.md)

**エラー処理**
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**
- [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router_adaptor.md)
- [health_check_endpoint_handler](../../component/handlers/handlers-health_check_endpoint_handler.md)

### 最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | — | — | 実行時例外/エラー時にログ出力 |
| 2 | [jaxrs_response_handler](../../component/handlers/handlers-jaxrs_response_handler.md) | — | レスポンスの書き込み | 例外対応レスポンス生成・書き込み・ログ出力 |
| 3 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | DB接続を取得 | DB接続を解放 | — |
| 4 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | トランザクション開始 | トランザクションをコミット | トランザクションをロールバック |
| 5 | [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router_adaptor.md) | リクエストパスからアクション(メソッド)を決定 | — | — |
| 6 | [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) | request bodyをフォームクラスに変換 | アクション処理結果のフォームをresponse bodyに変換 | — |
| 7 | [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) | No6のフォームクラスをバリデーション | — | — |

> **補足**: [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router_adaptor.md) より後ろのハンドラはハンドラキューに直接設定せず、router_adaptorに対して設定する。[jaxrs_adaptor](../../component/adapters/adapters-jaxrs_adaptor.md) を使用した場合、[body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) と [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) が自動追加される。追加ハンドラやメディアタイプ拡張が必要な場合は以下の設定例を参照。

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <!-- 前段のハンドラは省略 -->
      <component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
        <property name="methodBinderFactory">
          <component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
            <property name="handlerList">
              <list>
                <component class="nablarch.fw.jaxrs.BodyConvertHandler">
                  <!-- サポートするメディアタイプのコンバータを設定する -->
                </component>
                <component class="nablarch.fw.jaxrs.JaxRsBeanValidationHandler" />
              </list>
            </property>
          </component>
        </property>
      </component>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

最小ハンドラ構成, JaxRsResponseHandler, BodyConvertHandler, JaxRsBeanValidationHandler, global_error_handler, router_adaptor, RoutesMapping, JaxRsMethodBinderFactory, jaxrs_adaptor, ハンドラキュー設定

</details>
