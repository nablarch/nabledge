# アーキテクチャ概要

**目次**

* RESTfulウェブサービスの構成
* RESTfulウェブサービスの処理の流れ
* RESTfulウェブサービスで使用するハンドラ

  * 標準ハンドラ構成

Nablarchでは、JAX-RSのリソースクラスを作るのと同じように、ウェブアプリケーションの業務アクションを使用して
RESTfulウェブサービスを作成する機能（JAX-RSサポート）を提供する。

JAX-RSサポートは、Nablarchのウェブアプリケーションをベースとする。
そのため、JAX-RSで使用できる@Contextアノテーションを使用したServletリソースのインジェクションやCDIなどは使用できない。
以下に、JAX-RSサポートで使用できるアノテーションを示す。

* Produces(レスポンスのメディアタイプの指定)
* Consumes(リクエストのメディアタイプの指定)
* Valid(リクエストに対するBeanValidationの実行)

JSR339とJAX-RSサポートとの機能比較は、 [JAX-RSサポート/JSR339/HTTPメッセージングの機能比較](../../processing-pattern/restful-web-service/restful-web-service-functional-comparison.md#restful-web-service-functional-comparison) を参照。

> **Important:**
> JAX-RSサポートでは、クライアントサイドの機能は提供しない。
> JAX-RSクライアントを使用する必要がある場合は、JAX-RS実装(JerseyやRESTEasyなど)を使用すること。

## RESTfulウェブサービスの構成

Nablarchウェブアプリケーションと同じ構成となる。
詳細は、 [ウェブアプリケーションの構成](../../processing-pattern/web-application/web-application-architecture.md#web-application-structure) を参照。

## RESTfulウェブサービスの処理の流れ

RESTfulウェブサービスがリクエストを処理し、レスポンスを返却するまでの処理の流れを以下に示す。

![rest-design.png](../../../knowledge/assets/restful-web-service-architecture/rest-design.png)

1. [Webフロントコントローラ](../../processing-pattern/web-application/web-application-web-front-controller.md#web-front-controller) ( javax.servlet.Filter の実装クラス)がrequestを受信する。
2. [Webフロントコントローラ](../../processing-pattern/web-application/web-application-web-front-controller.md#web-front-controller) は、requestに対する処理をハンドラキュー(handler queue)に委譲する。
3. ハンドラキューに設定されたディスパッチハンドラ(DispatchHandler) が、URIを元に処理すべきアクションクラス(action class)を特定しハンドラキューの末尾に追加する。
4. アクションクラス(action class)は、フォームクラス(form class)やエンティティクラス(entity class)を使用して業務ロジック(business logic) を実行する。 
  
  各クラスの詳細は、 [RESTFulウェブサービスの責務配置](../../processing-pattern/restful-web-service/restful-web-service-application-design.md#rest-application-design) を参照。
5. action classは、処理結果を示すDTOや HttpResponse を作成し返却する。
6. ハンドラキュー内のHTTPレスポンスハンドラ(JaxRsResponseHandler)が、 HttpResponse をクライアントに返却するレスポンスに変換し、クライアントへ応答を返す。 
  
  なお、アクションクラス(action class)の処理結果がフォームクラス(form class)の場合には、 BodyConvertHandler により HttpResponse に変換される。 
  
  変換される HttpResponse のボディの形式は、 アクションクラス(action class)に設定されたメディアタイプとなる。

## RESTfulウェブサービスで使用するハンドラ

Nablarchでは、RESTfulウェブサービスを構築するために必要なハンドラを標準で幾つか提供している。
プロジェクトの要件に従い、ハンドラキューを構築すること。(要件によっては、プロジェクトカスタムなハンドラを作成することになる)

各ハンドラの詳細は、リンク先を参照すること。

リクエストやレスポンスの変換を行うハンドラ

* [JAX-RSレスポンスハンドラ](../../component/handlers/handlers-jaxrs-response-handler.md#jaxrs-response-handler)
* [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler)

データベースに関連するハンドラ

* [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler)
* [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler)

リクエストの検証を行うハンドラ

* [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler)
* [CSRFトークン検証ハンドラ](../../component/handlers/handlers-csrf-token-verification-handler.md#csrf-token-verification-handler)

エラー処理に関するハンドラ

* [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#global-error-handler)

その他のハンドラ

* [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router-adaptor.md#router-adaptor)
* [ヘルスチェックエンドポイントハンドラ](../../component/handlers/handlers-health-check-endpoint-handler.md#health-check-endpoint-handler)

### 標準ハンドラ構成

NablarchでRESTfulウェブサービスを構築する際の、必要最小限のハンドラキューを以下に示す。
これをベースに、プロジェクト要件に従ってNablarchの標準ハンドラやプロジェクトで作成したカスタムハンドラを追加する。

最小ハンドラ構成

| No. | ハンドラ | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|
| 1 | [グローバルエラーハンドラ](../../component/handlers/handlers-global-error-handler.md#global-error-handler) |  |  | 実行時例外、またはエラーの場合、ログ出力を行う。 |
| 2 | [JAX-RSレスポンスハンドラ](../../component/handlers/handlers-jaxrs-response-handler.md#jaxrs-response-handler) |  | レスポンスの書き込み処理を行う。 | 例外(エラー)に対応したレスポンスの生成と書き込み処理とログ出力処理を行う。 |
| 3 | [データベース接続管理ハンドラ](../../component/handlers/handlers-database-connection-management-handler.md#database-connection-management-handler) | DB接続を取得する。 | DB接続を解放する。 |  |
| 4 | [トランザクション制御ハンドラ](../../component/handlers/handlers-transaction-management-handler.md#transaction-management-handler) | トランザクションを開始する。 | トランザクションをコミットする。 | トランザクションをロールバックする。 |
| 5 | [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) | リクエストパスをもとに呼び出すアクション(メソッド)を決定する。 |  |  |
| 6 | [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) | request bodyをアクションで受け付けるフォームクラスに変換する。 | アクションの処理結果のフォームの内容をresponse bodyに変換する。 |  |
| 7 | [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler) | No6で変換したフォームクラスに対してバリデーションを実行する。 |  |  |

> **Tip:**
> [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) より後ろに設定するハンドラは、
> ハンドラキューに直接設定するのではなく [リクエストURIとアクションを紐付けるハンドラ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) に対して設定する。

> [JAX-RSアダプタ](../../component/adapters/adapters-jaxrs-adaptor.md#jaxrs-adaptor) を使用した場合、自動的に [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) と [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler) がハンドラキューに追加される。

> [リクエストボディ変換ハンドラ](../../component/handlers/handlers-body-convert-handler.md#body-convert-handler) と [JAX-RS BeanValidationハンドラ](../../component/handlers/handlers-jaxrs-bean-validation-handler.md#jaxrs-bean-validation-handler) 以外のハンドラを設定したい場合や、サポートするメディアタイプを増やしたい場合は、
> 以下の設定例や [JAX-RSアダプタ](../../component/adapters/adapters-jaxrs-adaptor.md#jaxrs-adaptor) の実装を参考にハンドラキューを構築すること。

> ```xml
> <component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
>   <property name="handlerQueue">
>     <list>
>       <!-- 前段のハンドラは省略 -->
> 
>       <!-- リクエストURIとアクションを紐付けるハンドラの設定 -->
>       <component name="packageMapping" class="nablarch.integration.router.RoutesMapping">
>         <!-- ハンドラ以外の設定値は省略 -->
>         <property name="methodBinderFactory">
>           <component class="nablarch.fw.jaxrs.JaxRsMethodBinderFactory">
>             <property name="handlerList">
>               <list>
>                 <!--
>                 リクエストURIとアクションを紐付けるハンドラ以降のハンドラキューの設定
>                 ※各クラスの設定値は省略
>                 -->
>                 <component class="nablarch.fw.jaxrs.BodyConvertHandler">
>                   <!-- サポートするメディアタイプのコンバータを設定する -->
>                 </component>
>                 <component class="nablarch.fw.jaxrs.JaxRsBeanValidationHandler" />
>               </list>
>             </property>
>           </component>
>         </property>
>       </component>
>     </list>
>   </property>
> </component>
> ```
