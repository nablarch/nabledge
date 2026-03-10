# アーキテクチャ概要

## RESTfulウェブサービスの構成

Jakarta RESTful Web ServicesサポートはNablarchのウェブアプリケーションをベースとする。

> **補足**: Nablarch5では「JAX-RSサポート」と呼ばれていたが、Java EEのEclipse Foundation移管に伴い仕様名が変わったため、Nablarch6で「Jakarta RESTful Web Servicesサポート」に名称変更。機能的な差はなし。

使用できるアノテーション:
- `@Produces`（レスポンスのメディアタイプ指定）
- `@Consumes`（リクエストのメディアタイプ指定）
- `@Valid`（リクエストに対するBeanValidation実行）

使用不可: `@Context`アノテーションによるServletリソースインジェクション、Jakarta Contexts and Dependency Injection

> **重要**: クライアントサイドの機能は提供しない。Jakarta RESTful Web Servicesのクライアントが必要な場合は、JerseyやRESTEasyなどのJakarta RESTful Web Services実装を使用すること。

構成はNablarchウェブアプリケーションと同じ。詳細は :ref:`web_application-structure` を参照。

## RESTfulウェブサービスの処理の流れ

1. :ref:`web_front_controller`（`jakarta.servlet.Filter`実装クラス）がリクエストを受信する。
2. :ref:`web_front_controller` がリクエストの処理をハンドラキュー（handler queue）に委譲する。
3. `DispatchHandler`がURIを元に処理すべきアクションクラスを特定し、ハンドラキューの末尾に追加する。
4. アクションクラスがフォームクラス/エンティティクラスを使用して業務ロジックを実行する。各クラスの詳細は :ref:`rest-application_design` を参照。
5. アクションクラスが処理結果のDTOまたは`HttpResponse`を作成し返却する。
6. `JaxRsResponseHandler`が`HttpResponse`をクライアントへのレスポンスに変換して応答する。アクションの処理結果がフォームクラスの場合は`BodyConvertHandler`により`HttpResponse`に変換され、ボディ形式はアクションクラスに設定されたメディアタイプとなる。

## RESTfulウェブサービスで使用するハンドラ

RESTfulウェブサービス構築用ハンドラ一覧:

**リクエスト・レスポンス変換**
- :ref:`jaxrs_response_handler`
- :ref:`body_convert_handler`

**データベース関連**
- :ref:`database_connection_management_handler`
- :ref:`transaction_management_handler`

**リクエスト検証**
- :ref:`jaxrs_bean_validation_handler`
- :ref:`csrf_token_verification_handler`

**エラー処理**
- :ref:`global_error_handler`

**その他**
- :ref:`リクエストURIとアクションを紐付けるハンドラ <router_adaptor>`
- :ref:`health_check_endpoint_handler`

### 最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | :ref:`global_error_handler` | — | — | 実行時例外/エラー時にログ出力 |
| 2 | :ref:`jaxrs_response_handler` | — | レスポンスの書き込み | 例外対応レスポンス生成・書き込み・ログ出力 |
| 3 | :ref:`database_connection_management_handler` | DB接続を取得 | DB接続を解放 | — |
| 4 | :ref:`transaction_management_handler` | トランザクション開始 | トランザクションをコミット | トランザクションをロールバック |
| 5 | :ref:`リクエストURIとアクションを紐付けるハンドラ <router_adaptor>` | リクエストパスからアクション(メソッド)を決定 | — | — |
| 6 | :ref:`body_convert_handler` | request bodyをフォームクラスに変換 | アクション処理結果のフォームをresponse bodyに変換 | — |
| 7 | :ref:`jaxrs_bean_validation_handler` | No6のフォームクラスをバリデーション | — | — |

> **補足**: :ref:`リクエストURIとアクションを紐付けるハンドラ <router_adaptor>` より後ろのハンドラはハンドラキューに直接設定せず、router_adaptorに対して設定する。:ref:`jaxrs_adaptor` を使用した場合、:ref:`body_convert_handler` と :ref:`jaxrs_bean_validation_handler` が自動追加される。追加ハンドラやメディアタイプ拡張が必要な場合は以下の設定例を参照。

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
