# セッションストア

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/libraries/session_store.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionUtil.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeStateEncoder.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JavaSerializeEncryptStateEncoder.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/encoder/JaxbStateEncoder.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionManager.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/DbStore.html) [9](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/store/UserSessionSchema.html) [10](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/encryption/AesEncryptor.html) [11](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/encryption/Base64Key.html) [12](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/util/Base64Util.html) [13](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionKeyNotFoundException.html) [14](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/session/SessionStore.html)

## 機能概要

HTTPセッションを抽象化した機能。セッションIDをクッキー（`NABLARCH_SID`、変更可）で追跡し、セッションIDごとにセッションストアに読み書きする。

**処理フロー**:
1. [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の往路処理でクッキーからセッションIDを取得し、セッションストアからセッション変数をロードする
2. `SessionUtil` を通してセッション変数を読み書きする
3. [session_store_handler](../handlers/handlers-SessionStoreHandler.md) の復路処理でセッション変数をセッションストアに保存する
4. JSPで参照できるようリクエストスコープに設定する（既に同名の値が存在する場合は設定しない）

> **重要**: 以下の機能は用途が重複するため非推奨:
> - :ref:`hidden暗号化<tag-hidden_encryption>`
> - [session_concurrent_access_handler](../handlers/handlers-session_concurrent_access_handler.md)
> - `ExecutionContext` のセッションスコープにアクセスするAPI

> **補足**: `NABLARCH_SID` クッキーはJSESSIONIDとは別物である。

> **補足**: Nablarch 5u16より、セッションストアの有効期間保存先にHTTPセッション以外も選択可能になった。

> **補足**: セッションIDには `UUID` を使用している。

### セッション変数の保存先

標準で提供する3種類のストア:
- :ref:`DBストア <session_store-db_store>`
- :ref:`HIDDENストア <session_store-hidden_store>`
- :ref:`HTTPセッションストア <session_store-http_session_store>`

[redisstore_lettuce_adaptor](../adapters/adapters-redisstore_lettuce_adaptor.md) を使用することで、Redisを保存先として使用できる。

### セッション変数の直列化の仕組み

| 直列化方式 | クラス |
|---|---|
| Java標準シリアライズ（デフォルト） | `JavaSerializeStateEncoder` |
| Java標準シリアライズ＋暗号化 | `JavaSerializeEncryptStateEncoder` |
| JAXBによるXMLベース | `JaxbStateEncoder` |

## セッションストアの特長と選択基準

デフォルトで使用できるセッション変数の保存先と特徴:

**DBストア**
- 保存先: データベース上のテーブル
- 特徴:
  - ローリングメンテナンス等でAPサーバが停止した場合でもセッション変数の復元が可能
  - APサーバのヒープ領域を圧迫しない
  - 同一セッションの処理が複数スレッドで実行された場合後勝ち（先に保存されたセッションのデータは消失する）

**HIDDENストア**
- 保存先: クライアントサイド（`hidden`タグを使用して画面間でセッション変数を引き回す）
- 特徴:
  - 複数タブでの画面操作を許容できる
  - APサーバのヒープ領域を圧迫しない
  - 同一セッションの処理が複数スレッドで実行された場合、セッションのデータはそれぞれのスレッドに紐付けて保存される

**HTTPセッションストア**
- 保存先: APサーバのヒープ領域（APサーバの設定によってはDB・ファイル等に保存される場合あり）
- 特徴:
  - 認証情報のようなアプリケーション全体で頻繁に使用する情報の保持に適している
  - APサーバごとに情報を保持するため、スケールアウト時に工夫が必要
  - 大量データを保存するとヒープ領域を圧迫する恐れがある
  - 同一セッションの処理が複数スレッドで実行された場合後勝ち（先に保存されたセッションのデータは消失する）

選択基準:

| 用途 | セッションストア |
|---|---|
| 入力〜確認〜完了画面間で入力情報の保持（複数タブでの画面操作を許容しない） | :ref:`DBストア <session_store-db_store>` |
| 入力〜確認〜完了画面間で入力情報の保持（複数タブでの画面操作を許容する） | :ref:`HIDDENストア <session_store-hidden_store>` |
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

SessionUtil, JavaSerializeStateEncoder, JavaSerializeEncryptStateEncoder, JaxbStateEncoder, ExecutionContext, セッションストア概要, セッション変数の保存先, セッション変数の直列化, NABLARCH_SID, DBストア, HIDDENストア, HTTPセッションストア, Redis, redisstore_lettuce_adaptor, UUID, セッションストア選択基準, セッション変数保存先, 複数タブ対応, ローリングメンテナンス, 後勝ち

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

## 有効期間の管理方法

- セッションの有効期間はデフォルトではHTTPセッションに保存されている。
- 設定変更により有効期間の保存先をデータベースに変更できる。詳細は :ref:`db_managed_expiration` を参照。
- [redisstore_lettuce_adaptor](../adapters/adapters-redisstore_lettuce_adaptor.md) を使用した場合は有効期限をRedisに保存できる。

> **補足**: 有効期間をデータベースに保存する意義については :ref:`stateless_web_app` 参照。

<details>
<summary>keywords</summary>

nablarch-fw-web, nablarch-fw-web-dbstore, モジュール, Maven依存関係, セッション有効期間管理, 有効期限データベース保存, HTTPセッション有効期間, Redis有効期限, db_managed_expiration

</details>

## 制約

### 保存対象はシリアライズ可能なJava Beansオブジェクトであること

セッションストアに保存するオブジェクトはシリアライズ可能なJava Beansオブジェクトである必要がある。プロパティの型はJavaの基本型またはシリアライズ可能なJava Beansオブジェクトである必要がある。プロパティには配列やコレクションも使用できる。

<details>
<summary>keywords</summary>

シリアライズ, Java Beansオブジェクト, 保存対象の制約, シリアライズ可能

</details>

## 使用方法：セッションストアを使用するための設定

[session_store_handler](../handlers/handlers-SessionStoreHandler.md) の設定に加えて、`SessionManager` をコンポーネント定義に設定する。コンポーネント名は **`sessionManager`** とすること。

```xml
<component name="sessionManager" class="nablarch.common.web.session.SessionManager">
  <!-- デフォルトで使用されるストア名 -->
  <property name="defaultStoreName" value="db"/>
  <property name="availableStores">
    <list>
      <component class="nablarch.common.web.session.store.HiddenStore"/>
      <component-ref name="dbStore" />
      <component class="nablarch.common.web.session.store.HttpSessionStore"/>
    </list>
  </property>
</component>

<component name="dbStore" class="nablarch.common.web.session.store.DbStore"/>

<!-- DBストアの初期化設定 -->
<component name="initializer"
    class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="dbStore" />
    </list>
  </property>
</component>
```

DBストアを使用する場合、以下のテーブルを作成する:

**`USER_SESSION` テーブル**:

| カラム名 | データ型 |
|---|---|
| SESSION_ID (PK) | `java.lang.String` |
| SESSION_OBJECT | `byte[]` |
| EXPIRATION_DATETIME | `java.sql.Timestamp` |

> **重要**: Oracleで正常に動作しないケースがあるため、`SESSION_ID` はCHARではなくVARCHARで定義すること。

テーブル名・カラム名は `DbStore.userSessionSchema` に `UserSessionSchema` のコンポーネントを定義して変更可能:

```xml
<property name="userSessionSchema">
  <component class="nablarch.common.web.session.store.UserSessionSchema"/>
</property>
```

> **補足**: DBストアを使用した場合、ブラウザが閉じられた際にテーブル上にセッション情報が残ることがある。期限切れのセッション情報は定期的に削除すること。

<details>
<summary>keywords</summary>

SessionManager, DbStore, UserSessionSchema, defaultStoreName, availableStores, userSessionSchema, USER_SESSIONテーブル, HiddenStore, HttpSessionStore, BasicApplicationInitializer, セッションストア設定

</details>

## 使用方法：入力～確認～完了画面間で入力情報を保持する

複数タブでの画面操作を許容するか否かでストアを使い分ける:

| ケース | 使用するストア |
|---|---|
| 複数タブを許容しない | DBストア（データベーステーブルにセッション変数を保持） |
| 複数タブを許容する | HIDDENストア（クライアントサイドにセッション変数を保持） |

HIDDENストアを使用する場合、入力・確認画面のJSPに [tag-hidden_store_tag](libraries-tag_reference.md) を使用する:

```jsp
<n:form>
  <!-- name属性にはHiddenStoreのparameterNameプロパティの値を設定 -->
  <n:hiddenStore name="nablarch_hiddenStore" />
</n:form>
```

> **補足**: セッションストアにはFormではなくEntityを格納すること。Entityを格納することでセッションストアから取り出したオブジェクトをすぐに業務ロジックで使用できる。Formを格納すると密結合なソースが生まれやすく、バリデーション前のデータが保持されるためセキュリティリスクも高まる。

<details>
<summary>keywords</summary>

複数タブ対応, HIDDENストア, DBストア, hiddenStore, n:hiddenStore, nablarch_hiddenStore, 入力確認完了画面, セッション変数保持

</details>

## 使用方法：認証情報を保持する

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
>
> 詳細は [csrf_token_verification_handler-regeneration](../handlers/handlers-csrf_token_verification_handler.md) を参照。

ログアウト時:
```java
// セッションストア全体を破棄
SessionUtil.invalidate(ctx);
```

<details>
<summary>keywords</summary>

SessionUtil.changeId, SessionUtil.invalidate, SessionUtil.put, CsrfTokenUtil, CSRFトークン再生成, 認証情報, ログイン, ログアウト, セッションID変更

</details>

## 使用方法：JSPからセッション変数の値を参照する

通常のリクエストスコープやセッションスコープと同様の手順でJSPからセッション変数を参照できる。

> **重要**: リクエストスコープに同名の値が既に存在する場合、JSPからセッション変数を参照できない。セッション変数にはリクエストスコープと重複しない名前を設定すること。

<details>
<summary>keywords</summary>

JSPからセッション変数参照, リクエストスコープ, セッションスコープ, セッション変数名前重複

</details>

## 使用方法：HIDDENストアの暗号化設定をカスタマイズする

デフォルト設定:

| 設定項目 | 設定内容 |
|---|---|
| 暗号化アルゴリズム | `AES` |
| 暗号化キー | アプリケーションサーバ内で共通の自動生成キー |

アプリケーションサーバが冗長化されている場合、サーバごとに異なるキーが生成されるため復号に失敗することがある。この場合、明示的にキーを設定する:

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

暗号化キーとIVはbase64エンコードした値を設定する。鍵の生成には `KeyGenerator`、IVの生成には `SecureRandom` を使用するとよい。base64エンコードには `Base64Util` または `java.util.Base64.Encoder` を使用する。

<details>
<summary>keywords</summary>

AesEncryptor, Base64Key, Base64Util, HIDDENストア暗号化, KeyGenerator, SecureRandom, 暗号化キー, IV, AES, 冗長化, base64

</details>

## 使用方法：セッション変数に値が存在しない場合の遷移先画面を指定する

ブラウザの戻るボタン等による不正な画面遷移でセッション変数が存在しない場合、`SessionKeyNotFoundException` が送出される。この例外を捕捉して任意のエラーページに遷移させる。

**システム共通のエラーページに遷移させる場合**（ハンドラで捕捉）:
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

**リクエスト毎に遷移先を指定する場合**（[on_error_interceptor](../handlers/handlers-on_error.md) を使用）:
```java
@OnError(type = SessionKeyNotFoundException.class, path = "redirect://error")
public HttpResponse backToNew(HttpRequest request, ExecutionContext context) {
  Project project = SessionUtil.get(context, "project");
  // 処理は省略
}
```

<details>
<summary>keywords</summary>

SessionKeyNotFoundException, OnError, HttpErrorResponse, Handler, on_error_interceptor, セッション変数不存在時の遷移, 不正な画面遷移, ブラウザ戻るボタン, SampleErrorHandler

</details>

## 拡張例

### セッション変数の保存先を追加する

1. `SessionStore` を継承し、追加したい保存先に対応したクラスを作成する
2. `SessionManager.availableStores` に、作成したクラスのコンポーネント定義を追加する

<details>
<summary>keywords</summary>

SessionStore, セッション変数の保存先追加, availableStores, SessionManager

</details>
