# セッションストア

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/session_store.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeStateEncoder.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeEncryptStateEncoder.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JaxbStateEncoder.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/java/util/UUID.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionManager.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/HiddenStore.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/DbStore.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/HttpSessionStore.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/UserSessionSchema.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionKeyNotFoundException.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionStore.html) [15](https://nablarch.github.io/docs/LATEST/javadoc/javax/crypto/KeyGenerator.html) [16](https://nablarch.github.io/docs/LATEST/javadoc/java/security/SecureRandom.html) [17](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Base64.html) [18](https://nablarch.github.io/docs/LATEST/javadoc/java/util/Base64.Encoder.html)

## 機能概要

HTTPセッションを抽象化した機能を提供する。セッションIDをクッキー（`NABLARCH_SID`、変更可）で追跡し、セッションIDごとにセッションストアへ読み書きする。セッションIDごとに読み書きされる値をセッション変数と呼ぶ。

**処理フロー**:
1. [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路処理で、クッキーのセッションIDをもとにセッションストアからセッション変数をロード
2. 業務アクションから `SessionUtil` を通してセッション変数に読み書き
3. [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の復路処理で、セッション変数をセッションストアに保存
4. JSPで参照できるようにセッション変数をリクエストスコープに設定（同名の値が既存の場合は設定しない）

> **重要**: 本機能を使用する場合、以下の機能は用途が重複するため非推奨:
> - :ref:`hidden暗号化<tag-hidden_encryption>`
> - [session_concurrent_access_handler](../handlers/handlers-session_concurrent_access_handler.md)
> - `ExecutionContext` のセッションスコープにアクセスするAPI

> **補足**: 本機能で使用するクッキー（`NABLARCH_SID`）はJSESSIONIDとは全く別物。

> **補足**: Nablarch 5u16より、セッションストアの有効期間保存先にHTTPセッション以外も選べるようになった。

> **補足**: クッキーで使用するセッションIDには `UUID` を使用している。

**セッション変数の保存先（標準3種）**:
- :ref:`DBストア <session_store-db_store>`
- :ref:`HIDDENストア <session_store-hidden_store>`
- :ref:`HTTPセッションストア <session_store-http_session_store>`

また、[redisstore_lettuce_adaptor](../adapters/adapters-redisstore_lettuce_adaptor.md) を使用することでRedisを保存先として使用可能。詳細な選択基準は [session_store-future_of_store](#s10) を参照。

**セッション変数の直列化方式（選択可）**:
- `Java標準のシリアライズ（デフォルト）`
- `Java標準のシリアライズ＋暗号化`
- `Jakarta XML BindingによるXMLベースの直列化`

**DBストア**
- 保存先: データベース上のテーブル
- ローリングメンテナンス等でAPサーバが停止した場合でもセッション変数の復元が可能
- APサーバのヒープ領域を圧迫しない
- 同一セッションの処理が複数スレッドで実行された場合後勝ちとなる（先に保存されたセッションのデータは消失する）

**HIDDENストア**
- 保存先: クライアントサイド（`hidden`タグを使用して画面間でセッション変数を引き回して実現）
- 複数タブでの画面操作を許容できる
- APサーバのヒープ領域を圧迫しない
- 同一セッションの処理が複数スレッドで実行された場合、セッションのデータはそれぞれのスレッドに紐付けて保存される

**HTTPセッションストア**
- 保存先: APサーバのヒープ領域（設定によってはDB/ファイル等）
- 認証情報のようなアプリケーション全体で頻繁に使用する情報の保持に適している
- APサーバ毎に情報を保持するためスケールアウト時に工夫が必要
- 大量データ保存でヒープ領域を圧迫する恐れあり
- 同一セッションの処理が複数スレッドで実行された場合後勝ちとなる（先に保存されたセッションのデータは消失する）

| 用途 | セッションストア |
|---|---|
| 入力～確認～完了画面間で入力情報の保持（複数タブでの画面操作を許容しない） | :ref:`DBストア <session_store-db_store>` |
| 入力～確認～完了画面間で入力情報の保持（複数タブでの画面操作を許容する） | :ref:`HIDDENストア <session_store-hidden_store>` |
| 認証情報の保持 | :ref:`DBストア <session_store-db_store>` または :ref:`HTTPセッションストア <session_store-http_session_store>` |
| 検索条件の保持 | 使用しない [1] |
| 検索結果一覧の保持 | 使用しない [2] |
| セレクトボックス等の画面表示項目の保持 | 使用しない [3] |
| エラーメッセージの保持 | 使用しない [3] |

[1] 認証情報を除き、セッションストアでは複数機能に跨るデータの保持は想定していない。ブラウザのローカルストレージに検索時のURLを保持するなど、アプリケーションの要件に合わせて設計・実装すること。
[2] 一覧情報のような大量データは保存領域を圧迫する可能性があるのでセッションストアには保存しない。
[3] 画面表示に使用する値はリクエストスコープを使用して受け渡せばよい。

> **補足**: [redisstore_lettuce_adaptor](../adapters/adapters-redisstore_lettuce_adaptor.md) については、保存先が異なるだけで特徴はDBストアと同じになる。

<details>
<summary>keywords</summary>

SessionUtil, ExecutionContext, JavaSerializeStateEncoder, JavaSerializeEncryptStateEncoder, JaxbStateEncoder, UUID, セッションストア, セッション変数, DBストア, HIDDENストア, HTTPセッションストア, 直列化, NABLARCH_SID, セッションストア選択基準, 複数タブ対応, セッション変数保存先, スケールアウト

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>

<!-- DBストアを使用する場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-dbstore</artifactId>
</dependency>
```

セッションの有効期間はデフォルトではHTTPセッションに保存されている。設定を変更することで有効期間の保存先をデータベースに変更できる。詳細は :ref:`db_managed_expiration` を参照。

[redisstore_lettuce_adaptor](../adapters/adapters-redisstore_lettuce_adaptor.md) を使用した場合は有効期限をRedisに保存できる。

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-fw-web-dbstore, モジュール依存関係, DBストア, セッション有効期間, 有効期間保存先, データベース管理, Redis有効期限, HTTPセッション

</details>

## 制約

セッションストアに保存するオブジェクトはシリアライズ可能なJava Beansオブジェクトである必要がある。プロパティの型はJavaの基本型またはシリアライズ可能なJava Beansオブジェクト。配列やコレクションも使用可。

<details>
<summary>keywords</summary>

シリアライズ可能, Java Beans, 制約, シリアライズ

</details>

## セッションストアを使用するための設定

[session_store_handler](../handlers/handlers-SessionStoreHandler.md) の設定に加えて、`SessionManager` を `"sessionManager"` というコンポーネント名で設定する。

```xml
<component name="sessionManager" class="nablarch.common.web.session.SessionManager">
  <property name="defaultStoreName" value="db"/>
  <property name="availableStores">
    <list>
      <component class="nablarch.common.web.session.store.HiddenStore"/>
      <component-ref name="dbStore"/>
      <component class="nablarch.common.web.session.store.HttpSessionStore"/>
    </list>
  </property>
</component>

<component name="dbStore" class="nablarch.common.web.session.store.DbStore"/>

<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="dbStore"/>
    </list>
  </property>
</component>
```

DBストアを使用する場合、`USER_SESSION` テーブルを作成する必要がある:

| カラム名 | データ型 |
|---|---|
| SESSION_ID (PK) | `java.lang.String` |
| SESSION_OBJECT | `byte[]` |
| EXPIRATION_DATETIME | `java.sql.Timestamp` |

> **重要**: `SESSION_ID` はCHARではなくVARCHARで定義すること（Oracleで正常に動作しないケースあり）。

テーブル名・カラム名を変更する場合は、`DbStore.userSessionSchema` に `UserSessionSchema` のコンポーネントを定義する。

```xml
<property name="userSessionSchema">
  <component class="nablarch.common.web.session.store.UserSessionSchema"/>
</property>
```

> **補足**: DBストア使用時、ブラウザが閉じられた場合などにテーブルにセッション情報が残ることがある。期限切れのセッション情報は定期的に削除する必要がある。

<details>
<summary>keywords</summary>

SessionManager, DbStore, HiddenStore, HttpSessionStore, USER_SESSION, userSessionSchema, UserSessionSchema, BasicApplicationInitializer, セッションストア設定, コンポーネント設定

</details>

## 入力～確認～完了画面間で入力情報を保持する

入力～確認～完了画面間で入力情報を保持する場合、複数タブでの画面操作を許容するか否かでセッションストアを使い分ける。

- **複数タブ不許容**: DBストアを使用（サーバーサイドのDBテーブルにセッション変数を保持）
- **複数タブ許容**: HIDDENストアを使用（クライアントサイドにセッション変数を保持）

HIDDENストア使用時は、入力・確認画面のJSPに [tag-hidden_store_tag](libraries-tag_reference.md) を使用する:

```jsp
<n:form>
  <!--
    name属性にはコンポーネント設定ファイルに定義した、
    HiddenStoreのparameterNameプロパティの値を設定
  -->
  <n:hiddenStore name="nablarch_hiddenStore" />
</n:form>
```

> **補足**: セッションストアにはFormではなくEntity（業務ロジック実行用オブジェクト）を格納すること。Entityを格納することでセッションストアから取り出したオブジェクトをすぐに業務ロジックで使用できる。Formを格納するとデータ変換処理等が業務ロジックに入り込み密結合になる。また、Formには外部入力値が含まれバリデーション前は信頼できない値を保持した状態となるため、セキュリティリスクが高まる。

<details>
<summary>keywords</summary>

tag-hidden_store_tag, n:hiddenStore, HIDDENストア, 複数タブ, 入力確認完了画面, Entity, Form, parameterName, HiddenStore

</details>

## 認証情報を保持する

認証情報を保持する場合はDBストアを使用する。

ログイン時:
```java
// ログイン前にセッションIDを変更する
SessionUtil.changeId(ctx);

// CSRFトークンを再生成する（CSRFトークン検証ハンドラを使用している場合）
CsrfTokenUtil.regenerateCsrfToken(ctx);

// ログインユーザの情報をセッションストアに保存
SessionUtil.put(ctx, "user", user, "db");
```

> **重要**: 以下の条件を全て満たす場合、ログイン時にCSRFトークンの再生成が必要:
> - [csrf_token_verification_handler](../handlers/handlers-csrf_token_verification_handler.md) を使用している
> - ログイン時にセッションIDの変更のみを行う（セッション情報は維持する）
> 詳細は [csrf_token_verification_handler-regeneration](../handlers/handlers-csrf_token_verification_handler.md) を参照。

ログアウト時:
```java
// セッションストア全体を破棄
SessionUtil.invalidate(ctx);
```

<details>
<summary>keywords</summary>

SessionUtil.changeId, CsrfTokenUtil.regenerateCsrfToken, SessionUtil.put, SessionUtil.invalidate, csrf_token_verification_handler, 認証, ログイン, ログアウト

</details>

## JSPからセッション変数の値を参照する

通常のリクエストスコープやセッションスコープと同様の手順で、JSPからセッション変数の値を参照できる。

> **重要**: 既にリクエストスコープ上に同名の値が存在する場合は参照できない。セッション変数にはリクエストスコープと重複しない名前を設定すること。

<details>
<summary>keywords</summary>

JSP, セッション変数参照, リクエストスコープ, セッション変数名

</details>

## HIDDENストアの暗号化設定をカスタマイズする

HIDDENストアのデフォルト暗号化設定:

| 設定項目 | 設定内容 |
|---|---|
| 暗号化アルゴリズム | AES |
| 暗号化キー | アプリケーションサーバ内で共通の自動生成されたキーを使用 |

アプリケーションサーバが冗長化されている場合、サーバごとに異なるキーが生成されるため復号に失敗するケースがある。この場合、明示的に暗号化/復号のキーを設定する。

```xml
<component class="nablarch.common.web.session.store.HiddenStore">
  <property name="encryptor">
    <component class="nablarch.common.encryption.AesEncryptor">
      <property name="base64Key">
        <component class="nablarch.common.encryption.Base64Key">
          <property name="key" value="OwYMOWbnLyYy93P8oIayeg==" />
          <property name="iv" value="NOj5OUN+GlyGYTc6FM0+nw==" />
        </component>
      </property>
    </component>
  </property>
</component>
```

- 暗号化の鍵およびIVはbase64エンコードした値を設定する
- 鍵の生成: `KeyGenerator` を使用
- IVの生成: `SecureRandom` を使用
- base64エンコード: `getEncoder()` より取得できる `Encoder` を使用

<details>
<summary>keywords</summary>

AesEncryptor, Base64Key, KeyGenerator, SecureRandom, HIDDENストア, 暗号化, 冗長化, AES

</details>

## セッション変数に値が存在しない場合の遷移先画面を指定する

正常な画面遷移では必ずセッション変数が存在するが、ブラウザの戻るボタン等による不正な画面遷移でセッション変数が存在しない場合、`SessionKeyNotFoundException` が送出される。この例外を捕捉して任意のエラーページに遷移させる。

**システムで共通のエラーページへ遷移**: ハンドラで例外を捕捉して遷移先を指定する。
```java
public class SampleErrorHandler implements Handler<Object, Object> {
  @Override
  public Object handle(Object data, ExecutionContext context) {
    try {
      return context.handleNext(data);
    } catch (SessionKeyNotFoundException e) {
      throw new HttpErrorResponse(HttpResponse.Status.BAD_REQUEST.getStatusCode(),
              "/WEB-INF/view/errors/BadTransition.jsp", e);
    }
  }
}
```

**リクエスト毎に遷移先を指定**: [on_error_interceptor](../handlers/handlers-on_error.md) を使用する。システム共通エラーページとの併用で一部リクエストのみ遷移先を変更することも可能。
```java
@OnError(type = SessionKeyNotFoundException.class, path = "redirect://error")
public HttpResponse backToNew(HttpRequest request, ExecutionContext context) {
  Project project = SessionUtil.get(context, "project");
}
```

<details>
<summary>keywords</summary>

SessionKeyNotFoundException, on_error_interceptor, HttpErrorResponse, OnError, 不正な画面遷移, 戻るボタン, SampleErrorHandler

</details>

## 拡張例

セッション変数の保存先を追加する手順:
1. `SessionStore` を継承して追加したい保存先に対応したクラスを作成する
2. `SessionManager.availableStores` に作成したクラスのコンポーネント定義を追加する

<details>
<summary>keywords</summary>

SessionStore, SessionManager.availableStores, 保存先追加, カスタムストア

</details>
