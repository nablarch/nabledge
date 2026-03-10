# OIDCのIDトークンを用いた認証サンプル

**公式ドキュメント**: [OIDCのIDトークンを用いた認証サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/12/index.html)

## 提供パッケージ

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-oidc)

**パッケージ**: `please.change.me.common.oidc.verification`

<details>
<summary>keywords</summary>

please.change.me.common.oidc.verification, OIDCサンプルパッケージ, IDトークン認証サンプル, ソースコード

</details>

## 概要

OIDCで発行されるIDトークンを用いた認証サンプル。以下の構成を想定。

- NablarchのRESTfulウェブサービスをバックエンドとして使用
- IDトークンはフロントエンド（SPA、モバイルアプリ等）で取得しバックエンドに送信
- 認証成功時にログインセッションを確立し、認証後はステートフルなセッション管理を行う
- 認証処理は業務アクションで実装

**本サンプルの対象範囲**: Nablarchを使用するバックエンドアプリケーションのみ。フロントエンドアプリケーション（Web、モバイルアプリ等）で行うIDトークンの取得方法は本サンプルの対象外。

対応サービス：
- [Amazon Cognitoユーザープール](https://aws.amazon.com/jp/cognito/)（以下ユーザープール）→ パッケージ: `please.change.me.common.oidc.verification.cognito`
- [Azure Active Directory B2C](https://learn.microsoft.com/ja-jp/azure/active-directory-b2c/)（以下ADB2C）→ パッケージ: `please.change.me.common.oidc.verification.adb2c`

本ページはcognitoパッケージをベースとして説明。adb2cパッケージを使用する場合は対応するコンポーネントに読み替えること。

> **補足**: 本サンプルは2024年9月時点のユーザープール・ADB2Cの仕様に合わせて実装。利用するサービスの最新仕様を確認し、適宜カスタマイズすること。

<details>
<summary>keywords</summary>

OIDC認証, IDトークン検証, Amazon Cognito, Azure Active Directory B2C, RESTfulウェブサービス認証, ステートフルセッション管理, please.change.me.common.oidc.verification.cognito, please.change.me.common.oidc.verification.adb2c

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
| `CognitoIdTokenVerifier` | CognitoのIDトークンが有効か検証する機能を提供 |
| `CognitoSignatureAlgorithmProvider` | Cognitoのトークン署名検証に使用するアルゴリズムを提供 |
| `CognitoRSAKeyProvider` | Cognitoのトークン検証に使用するRSA公開鍵を提供 |

**クラス（業務アクション）**:

| クラス名 | 概要 |
|---|---|
| `LoginAction` | 認証処理の業務アクション |
| `LoginRequestForm` | 認証のリクエスト情報を格納するフォーム |

<details>
<summary>keywords</summary>

IdTokenVerifier, SignatureAlgorithmProvider, CognitoIdTokenVerifier, CognitoSignatureAlgorithmProvider, CognitoRSAKeyProvider, LoginAction, LoginRequestForm, クラス構成, IDトークン検証クラス, 認証業務アクション

</details>

## 依存ライブラリの追加

JWTライブラリとして、Auth0が公開している `java-jwt` と `jwks-rsa-java` を使用する。

**モジュール**:
```xml
<dependency>
  <groupId>com.auth0</groupId>
  <artifactId>java-jwt</artifactId>
  <version>4.4.0</version>
</dependency>
<dependency>
  <groupId>com.auth0</groupId>
  <artifactId>jwks-rsa</artifactId>
  <version>0.22.1</version>
</dependency>
```

<details>
<summary>keywords</summary>

java-jwt, jwks-rsa, jwks-rsa-java, Auth0, JWT, IDトークン, JWTライブラリ

</details>

## 環境依存値の設定

IDトークン検証コンポーネントに以下の環境依存値をプロパティとして設定する。

| 名前 | 説明 |
|---|---|
| aws.cognito.region | Cognitoリージョンコード（例: ap-northeast-1） |
| aws.cognito.userPool.id | ユーザープールID |
| aws.cognito.userPool.clientId | ユーザープールに登録したアプリケーションのクライアントID |

設定方法: :ref:`repository-overwrite_environment_configuration` または :ref:`repository-overwrite_environment_configuration_by_os_env_var`

> **補足**: 秘匿情報はバージョン管理対象ファイルへの記述を避け、システムプロパティやOS環境変数として設定すること。

<details>
<summary>keywords</summary>

aws.cognito.region, aws.cognito.userPool.id, aws.cognito.userPool.clientId, 環境依存値, Cognito, ユーザープール

</details>

## コンポーネント定義の設定

```xml
<component name="idTokenVerifier" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoIdTokenVerifier">
  <property name="region" value="${aws.cognito.region}" />
  <property name="userPoolId" value="${aws.cognito.userPool.id}" />
  <property name="clientId" value="${aws.cognito.userPool.clientId}" />
  <property name="signatureAlgorithmProvider" ref="signatureAlgorithmProvider" />
</component>
<component name="signatureAlgorithmProvider" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoSignatureAlgorithmProvider">
  <property name="rsaKeyProvider" ref="rsaKeyProvider" />
</component>
<component name="rsaKeyProvider" class="please.change.me.common.oidc.verification.cognito.jwt.CognitoRSAKeyProvider">
  <property name="region" value="${aws.cognito.region}" />
  <property name="userPoolId" value="${aws.cognito.userPool.id}" />
</component>
```

<details>
<summary>keywords</summary>

CognitoIdTokenVerifier, CognitoSignatureAlgorithmProvider, CognitoRSAKeyProvider, idTokenVerifier, signatureAlgorithmProvider, rsaKeyProvider, コンポーネント定義

</details>

## IDトークンの検証

**クラス**: `CognitoIdTokenVerifier`, `CognitoSignatureAlgorithmProvider`, `CognitoRSAKeyProvider`

`CognitoIdTokenVerifier`: Cognitoのガイドに従ってIDトークンを検証する。有効期限の許容範囲は60秒。

```java
JWTVerifier verifier = JWT.require(signatureAlgorithmProvider.get())
        .acceptExpiresAt(60)
        .withAudience(clientId)
        .withIssuer("https://cognito-idp." + region + ".amazonaws.com/" + userPoolId)
        .withClaim("token_use", "id")
        .build();
return verifier.verify(idToken);
```

`CognitoSignatureAlgorithmProvider`: `Algorithm.RSA256(rsaKeyProvider)` を返却する。

> **補足**: 署名検証以外の処理についてローカル開発環境でテストが実装しやすくするため、署名検証に必要な情報を差し替えやすいように、署名検証用コンポーネント（`CognitoSignatureAlgorithmProvider` / `CognitoRSAKeyProvider`）を別コンポーネントとして分離している。

`CognitoRSAKeyProvider`: `RSAKeyProvider` と `Initializable` を実装。CognitoのJWKSエンドポイントからJWKおよびRSA公開鍵（`RSAPublicKey`）を取得する。`getPublicKeyById` で `Jwk` を取得し、`JwkException` 発生時は `null` を返す。`RSAPrivateKey` の取得はサポートしない（`getPrivateKey()` は `UnsupportedOperationException` をスロー）。`getPrivateKeyId()` は未定義であるためインタフェースの仕様に則り `null` を返却する。設定値: キーIDは1時間に4つまでキャッシュ、JWKSアクセスは1分で10回まで許容、プロキシなし。

> **補足**: 署名検証の鍵情報は、事前に判明していた場合でも固定値を使わず、JWKSエンドポイントから最新情報を取得すること（サービスによっては鍵情報を定期ローテーションし、緊急事態では予告なく変更される場合があるため）。

<details>
<summary>keywords</summary>

IdTokenVerifier, JWTVerifier, RSAKeyProvider, JwkProvider, JwkProviderBuilder, Initializable, RSAPublicKey, RSAPrivateKey, Jwk, JwkException, DecodedJWT, SignatureAlgorithmProvider, Algorithm, UnsupportedOperationException, IDトークン検証, AWS Cognito, OIDC認証, JWT認証, JWKSエンドポイント

</details>

## 認証用業務アクションのパス設定

JAX-RSの`@Path`アノテーションで認証用業務アクションのパスを設定する:

```java
@Path("/cognito/login")
public class LoginAction {
```

マッピング詳細: :ref:`router_adaptor_path_annotation`

<details>
<summary>keywords</summary>

@Path, LoginAction, JAX-RS, router_adaptor_path_annotation

</details>

## 認証および成功時のログイン状態設定

IDトークン検証が成功した場合はログインセッションを確立し、失敗した場合はHTTPステータス401のエラーレスポンスを返す。認証成功後はセッションIDとCSRFトークンを変更する。

> **補足**: CSRF対策のため、CSRFトークン検証ハンドラの使用を想定。詳細: :ref:`csrf_token_verification_handler`

```java
@POST
@Consumes(MediaType.APPLICATION_JSON)
@Valid
public void login(ExecutionContext context, LoginRequestForm form) {
    DecodedJWT decodedJWT = verifyIdToken(form.getIdToken());
    SessionUtil.changeId(context);
    CsrfTokenUtil.regenerateCsrfToken(context);
    String userId = decodedJWT.getSubject();
    SessionUtil.put(context, "user.id", userId);
}
```

無効なIDトークンの場合は401(Unauthorized)を返す。コンポーネントはプロパティを使用して定義しているため、`SystemRepository` から取得する:

```java
IdTokenVerifier idTokenVerifier = SystemRepository.get("idTokenVerifier");
try {
    return idTokenVerifier.verify(idToken);
} catch (JWTVerificationException e) {
    throw new HttpErrorResponse(HttpResponse.Status.UNAUTHORIZED.getStatusCode());
}
```

<details>
<summary>keywords</summary>

@POST, @Consumes, @Valid, MediaType, ExecutionContext, DecodedJWT, SessionUtil, CsrfTokenUtil, SystemRepository, HttpResponse, HttpErrorResponse, JWTVerificationException, IdTokenVerifier, LoginRequestForm, csrf_token_verification_handler, ログインセッション, CSRFトークン

</details>
