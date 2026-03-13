# アーキテクチャ概要

**公式ドキュメント**: [アーキテクチャ概要](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web_service/rest/architecture.html)

## RESTfulウェブサービスの構成

JAX-RSサポートはNablarchのウェブアプリケーションをベースとしてRESTfulウェブサービスを構築する機能。JAX-RSのリソースクラスを作るのと同じようにウェブアプリケーションの業務アクションを使用して作成できる。

**使用不可**: `@Context`アノテーションによるServletリソースのインジェクション、CDI。

**使用可能なアノテーション**:
- `@Produces`（レスポンスのメディアタイプの指定）
- `@Consumes`（リクエストのメディアタイプの指定）
- `@Valid`（リクエストに対するBeanValidationの実行）

> **重要**: JAX-RSサポートではクライアントサイドの機能は提供しない。JAX-RSクライアントが必要な場合はJAX-RS実装（Jersey、RESTEasyなど）を使用すること。

RESTfulウェブサービスの構成はNablarchウェブアプリケーションと同じ構成（[web_application-structure](../web-application/web-application-architecture.md) 参照）。

<details>
<summary>keywords</summary>

JAX-RSサポート, @Produces, @Consumes, @Valid, RESTfulウェブサービス構成, クライアントサイド非対応, WebFrontController, CDI使用不可

</details>

## RESTfulウェブサービスの処理の流れ

1. [web_front_controller](../web-application/web-application-web_front_controller.md)（`javax.servlet.Filter`実装クラス）がリクエストを受信
2. [web_front_controller](../web-application/web-application-web_front_controller.md) がハンドラキューに処理を委譲
3. `DispatchHandler`がURIからアクションクラスを特定しハンドラキュー末尾に追加
4. アクションクラスがフォームクラス・エンティティクラスを使用して業務ロジックを実行（[rest-application_design](restful-web-service-application_design.md) 参照）
5. アクションクラスがDTOまたは`HttpResponse`を作成して返却
6. `JaxRsResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換して応答。アクションの処理結果がフォームクラスの場合は`BodyConvertHandler`が`HttpResponse`に変換し、ボディ形式はアクションクラスに設定されたメディアタイプ

<details>
<summary>keywords</summary>

RESTfulウェブサービス処理フロー, DispatchHandler, JaxRsResponseHandler, BodyConvertHandler, HttpResponse, ハンドラキュー, アクションクラス

</details>

## RESTfulウェブサービスで使用するハンドラ

**リクエスト/レスポンス変換ハンドラ**:
- [jaxrs_response_handler](../../component/handlers/handlers-jaxrs_response_handler.md)
- [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md)

**データベース関連ハンドラ**:
- [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md)
- [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md)

**リクエスト検証ハンドラ**:
- [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md)
- [csrf_token_verification_handler](../../component/handlers/handlers-csrf_token_verification_handler.md)

**エラー処理ハンドラ**:
- [global_error_handler](../../component/handlers/handlers-global_error_handler.md)

**その他**:
- [router_adaptor](../../component/adapters/adapters-router_adaptor.md)（リクエストURIとアクションを紐付け）
- [health_check_endpoint_handler](../../component/handlers/handlers-health_check_endpoint_handler.md)

## 最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [global_error_handler](../../component/handlers/handlers-global_error_handler.md) | — | — | 実行時例外またはエラーのログ出力 |
| 2 | [jaxrs_response_handler](../../component/handlers/handlers-jaxrs_response_handler.md) | — | レスポンス書き込み | 例外対応レスポンス生成・書き込み・ログ出力 |
| 3 | [database_connection_management_handler](../../component/handlers/handlers-database_connection_management_handler.md) | DB接続取得 | DB接続解放 | — |
| 4 | [transaction_management_handler](../../component/handlers/handlers-transaction_management_handler.md) | トランザクション開始 | コミット | ロールバック |
| 5 | [router_adaptor](../../component/adapters/adapters-router_adaptor.md) | リクエストパスからアクション（メソッド）を決定 | — | — |
| 6 | [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) | request bodyをフォームクラスに変換 | アクション処理結果のフォームをresponse bodyに変換 | — |
| 7 | [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) | No.6で変換したフォームクラスにバリデーション実行 | — | — |

> **補足**: [router_adaptor](../../component/adapters/adapters-router_adaptor.md) より後ろに設定するハンドラは、ハンドラキューに直接設定するのではなく [router_adaptor](../../component/adapters/adapters-router_adaptor.md) に対して設定する。[jaxrs_adaptor](../../component/adapters/adapters-jaxrs_adaptor.md) を使用した場合、自動的に [body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) と [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) がハンドラキューに追加される。

[body_convert_handler](../../component/handlers/handlers-body_convert_handler.md) と [jaxrs_bean_validation_handler](../../component/handlers/handlers-jaxrs_bean_validation_handler.md) 以外のハンドラを追加する場合やサポートするメディアタイプを増やす場合の設定例:

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
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

標準ハンドラ構成, 最小ハンドラ構成, JaxRsResponseHandler, BodyConvertHandler, JaxRsBeanValidationHandler, JaxRsMethodBinderFactory, global_error_handler, router_adaptor, database_connection_management_handler, transaction_management_handler, jaxrs_adaptor, csrf_token_verification_handler, health_check_endpoint_handler, RoutesMapping

</details>
