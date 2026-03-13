# OIDCのIDトークンを用いた認証サンプル

**公式ドキュメント**: [OIDCのIDトークンを用いた認証サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/12/index.html)

## 提供パッケージ

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/v5-main)

**パッケージ**: `please.change.me.common.oidc.verification`

## 依存ライブラリの追加

IDトークンはJWT形式で作成される。JWTを扱うためのライブラリとしてAuth0が公開している`java-jwt`と`jwks-rsa-java`を使用する。

```xml
<dependencies>
  <!-- JWTライブラリ -->
  <dependency>
    <groupId>com.auth0</groupId>
    <artifactId>java-jwt</artifactId>
    <version>4.2.2</version>
  </dependency>
  <dependency>
    <groupId>com.auth0</groupId>
    <artifactId>jwks-rsa</artifactId>
    <version>0.21.3</version>
  </dependency>
</dependencies>
```

ADB2CパッケージではHTTPクライアントも必要:

```xml
<dependencies>
  <!-- HTTPクライアント -->
  <dependency>
    <groupId>org.apache.httpcomponents.client5</groupId>
    <artifactId>httpclient5</artifactId>
    <version>5.2.1</version>
  </dependency>
</dependencies>
```

<details>
<summary>keywords</summary>

please.change.me.common.oidc.verification, OIDCサンプル, IDトークン認証, パッケージ構成, ソースコード, java-jwt, jwks-rsa, httpclient5, com.auth0, JWTライブラリ

</details>

## 概要

OpenID Connect（OIDC）で発行されるIDトークンを用いて認証を行うサンプル。

**想定構成**:
- NablarchのRESTfulウェブサービスをバックエンドとして稼働
- IDトークンはフロントエンド（SPA、モバイルアプリ等）で取得し、バックエンドに送信
- 認証成功時にログインセッションを確立し、認証後はステートフルなセッション管理
- 認証処理は業務アクションで実装

**対応サービス**:
- [Amazon Cognito ユーザープール](https://aws.amazon.com/jp/cognito/)
- [Azure Active Directory B2C](https://learn.microsoft.com/ja-jp/azure/active-directory-b2c/)

**パッケージ構成**:
- Cognito用: `please.change.me.common.oidc.verification.cognito`
- ADB2C用: `please.change.me.common.oidc.verification.adb2c`

**取り扱い範囲**: 本サンプルで取り扱うのはNablarchを使用するバックエンドアプリケーションのみ。フロントエンドアプリケーション（Web、モバイルアプリ等）で行うIDトークンの取得方法は本サンプルの対象外。

**説明の方針**: 考え方はどちらのパッケージでも同じであるため、本ページではcognitoパッケージのサンプルをベースとして説明する。adb2cパッケージを使用する場合は、適宜対応するコンポーネントに読み替えること。

> **補足**: 本サンプルは2023年3月時点のユーザープール・ADB2Cの仕様に合わせて実装している。必ず利用するサービスの最新の仕様を確認し、適宜カスタマイズすること。

## 環境依存値の設定

IDトークンを検証するためのコンポーネントは、サービスへアクセスするための情報を環境依存値としてプロパティから参照する。以下の環境依存値を実行環境に設定する。

| 名前 | 説明 |
|---|---|
| aws.cognito.region | Cognitoを作成しているリージョンコード（例：ap-northeast-1） |
| aws.cognito.userPool.id | ユーザープールID |
| aws.cognito.userPool.clientId | ユーザープールに登録したアプリケーションのクライアントID |

環境依存値の設定方法については [repository-overwrite_environment_configuration](../../component/libraries/libraries-repository.md) や [repository-overwrite_environment_configuration_by_os_env_var](../../component/libraries/libraries-repository.md) を参照。

> **補足**: サービスへのアクセスに必要な情報に秘匿すべき情報が含まれる場合は、バージョン管理システムで管理対象となるファイルへの記述を避け、システムプロパティやOS環境変数として設定すること。

<details>
<summary>keywords</summary>

please.change.me.common.oidc.verification.cognito, please.change.me.common.oidc.verification.adb2c, OIDC認証, IDトークン, Amazon Cognito, Azure Active Directory B2C, RESTfulウェブサービス, 認証処理, 業務アクション, aws.cognito.region, aws.cognito.userPool.id, aws.cognito.userPool.clientId, Cognito認証

</details>

## 構成

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `IdTokenVerifier` | IDトークンが有効であるか検証する機能を提供 |
| `SignatureAlgorithmProvider` | トークンの署名検証に使用するアルゴリズムを提供 |

**クラス（コンポーネント）**:

| クラス名 | 概要 |
|---|---|
| `CognitoIdTokenVerifier` | CognitoのIDトークンが有効であるか検証する機能を提供 |
| `CognitoSignatureAlgorithmProvider` | Cognitoのトークン署名検証に使用するアルゴリズムを提供 |
| `CognitoRSAKeyProvider` | Cognitoが発行するトークンの検証に使用するRSA公開鍵を提供 |

**クラス（業務アクション）**:

| クラス名 | 概要 |
|---|---|
| `LoginAction` | 認証処理の業務アクション |
| `LoginRequestForm` | 認証のリクエスト情報を格納するフォーム |

## コンポーネント定義の設定

IDトークンを検証するための処理は、プロパティの使用や起動時の初期化を考慮してコンポーネントとして作成している。それらのコンポーネントをコンポーネント設定ファイルに定義する。

```xml
<!-- IDトークン検証コンポーネント -->
<component name="idTokenVerifier" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoIdTokenVerifier">
  <property name="region" value="${aws.cognito.region}" />
  <property name="userPoolId" value="${aws.cognito.userPool.id}" />
  <property name="clientId" value="${aws.cognito.userPool.clientId}" />
  <property name="signatureAlgorithmProvider" ref="signatureAlgorithmProvider" />
</component>
<!-- トークン署名検証用アルゴリズム提供コンポーネント -->
<component name="signatureAlgorithmProvider" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoSignatureAlgorithmProvider">
  <property name="rsaKeyProvider" ref="rsaKeyProvider" />
</component>
<!-- トークン署名検証用RSA公開鍵提供コンポーネント -->
<component name="rsaKeyProvider" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoRSAKeyProvider">
  <property name="region" value="${aws.cognito.region}" />
  <property name="userPoolId" value="${aws.cognito.userPool.id}" />
</component>
```

<details>
<summary>keywords</summary>

IdTokenVerifier, SignatureAlgorithmProvider, CognitoIdTokenVerifier, CognitoSignatureAlgorithmProvider, CognitoRSAKeyProvider, LoginAction, LoginRequestForm, クラス図, インタフェース, 業務アクション, 署名検証

</details>

## IDトークンの検証

## IDトークンの検証

`CognitoIdTokenVerifier`はCognitoのガイドに従ってIDトークンを検証する。クライアント側でIDトークン取得後に即時送信されることを想定し、有効期限の許容範囲は60秒。

```java
JWTVerifier verifier = JWT.require(signatureAlgorithmProvider.get())
        .acceptExpiresAt(60)
        .withAudience(clientId)
        .withIssuer(createUserPoolUrl(region, userPoolId))
        .withClaim("token_use", "id")
        .build();
return verifier.verify(idToken);
```

`CognitoSignatureAlgorithmProvider`はRSA256アルゴリズムを返却:

```java
public Algorithm get() {
    return Algorithm.RSA256(rsaKeyProvider);
}
```

`CognitoRSAKeyProvider`は`RSAKeyProvider`インタフェースと`Initializable`インタフェースの両方を実装する。`initialize()`ではCognitoが公開するJWKSエンドポイントから公開鍵を取得するための`JwkProvider`を`JwkProviderBuilder`で構築する。

```java
public class CognitoRSAKeyProvider implements RSAKeyProvider, Initializable {
    ...
    @Override
    public RSAPublicKey getPublicKeyById(String keyId) {
        try {
            Jwk jwk = provider.get(keyId);
            return (RSAPublicKey) jwk.getPublicKey();
        } catch (JwkException e) {
            return null;
        }
    }

    @Override
    public void initialize() {
        this.provider = new JwkProviderBuilder(createUserPoolUrl(region, userPoolId))
                .cached(true)
                .cached(4, 1, TimeUnit.HOURS)
                .rateLimited(true)
                .rateLimited(10, 1, TimeUnit.MINUTES)
                .proxied(Proxy.NO_PROXY)
                .build();
    }
}
```

プロバイダの設定内容:
- キーIDは1時間に4つまでキャッシュ（キーのローテーションを跨いだ場合でも通常使用ではキャッシュされる範囲）
- JWKSエンドポイントへのアクセスは1分で10回まで許容（キャッシュを考慮すると通常使用では到達しない範囲）
- プロキシは使用しない

> **補足**: 署名に使用する鍵情報はローテーションされる場合があるため、事前に鍵情報が判明していた場合でも固定値を使用せず、JWKSエンドポイントから最新情報を取得すること。

<details>
<summary>keywords</summary>

CognitoIdTokenVerifier, CognitoSignatureAlgorithmProvider, CognitoRSAKeyProvider, RSAKeyProvider, Initializable, JWTVerifier, JwkProvider, JwkProviderBuilder, Jwk, JwkException, JWKS公開鍵取得, JWT署名検証

</details>

## 認証用業務アクションのパス設定

## 認証用業務アクションのパス設定

JAX-RSの`@Path`アノテーションで認証用業務アクションのパスを設定する:

```java
@Path("/cognito/login")
public class LoginAction {
```

JAX-RSの`@Path`アノテーションによるマッピングについては [router_adaptor_path_annotation](../../component/adapters/adapters-router_adaptor.md) を参照。

<details>
<summary>keywords</summary>

LoginAction, @Path, JAX-RS

</details>

## 認証および成功時のログイン状態設定

## 認証および成功時のログイン状態設定

認証処理を実装する業務アクションでは、IDトークンの検証を呼び出し、異常が検知されなければログインセッションを確立する。

```java
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public void login(ExecutionContext context, LoginRequestForm form) {
    DecodedJWT decodedJWT = verifyIdToken(form.getIdToken());
    // 認証成功後にセッションIDおよびCSRFトークンを変更する
    SessionUtil.changeId(context);
    CsrfTokenUtil.regenerateCsrfToken(context);
    // IDトークンのsubjectからユーザーIDを取得してセッションに保持する
    String userId = decodedJWT.getSubject();
    SessionUtil.put(context, "user.id", userId);
}
```

`verifyIdToken`ではシステムリポジトリから`IdTokenVerifier`を取得してIDトークンを検証する。`JWTVerificationException`がスローされた場合は、HTTPステータス401（Unauthorized）のエラーレスポンスを返却する:

```java
private DecodedJWT verifyIdToken(String idToken) {
    IdTokenVerifier idTokenVerifier = SystemRepository.get("idTokenVerifier");
    try {
        return idTokenVerifier.verify(idToken);
    } catch (JWTVerificationException e) {
        throw new HttpErrorResponse(HttpResponse.Status.UNAUTHORIZED.getStatusCode());
    }
}
```

> **補足**: CSRF対策のため、CSRFトークン検証ハンドラの使用を想定している。詳細は [csrf_token_verification_handler](../../component/handlers/handlers-csrf_token_verification_handler.md) を参照。

<details>
<summary>keywords</summary>

JWTVerificationException, IDトークン検証, セッション管理, DecodedJWT, SessionUtil, CsrfTokenUtil, HttpErrorResponse, SystemRepository

</details>
