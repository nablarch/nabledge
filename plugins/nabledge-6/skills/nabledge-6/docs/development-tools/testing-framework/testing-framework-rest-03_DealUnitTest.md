# 取引単体テストの実施方法

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/03_DealUnitTest/rest.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/RequestResponseProcessor.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/RequestResponseCookieManager.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/NablarchSIDManager.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/test/core/http/ComplexRequestResponseProcessor.html)

## 取引単体テストのテストクラス例

ウェブサービスで1リクエスト=1取引の場合、取引単体テストは不要。複数リクエストで取引が成立する場合は、リクエスト毎のテストを連続実行することで実施可能。

```java
@Test
public void プロジェクト更新取引() {
    String message1 = "変更対象取得";
    RestMockHttpRequest request001 = get("/projects?projectName=プロジェクト００１");
    HttpResponse response001 = sendRequest(request001);
    assertStatusCode(message1, HttpResponse.Status.OK, response001);
    // 取得した変更対象を使って更新用フォームを作成
    Project project = parseProject(response001).setProjectName("プロジェクト８８８");
    ProjectUpdateForm updateForm = new ProjectUpdateForm(project);

    String message2 = "プロジェクト更新";
    RestMockHttpRequest updateRequest = put("/projects").setBody(updateForm);
    HttpResponse updateResponse = sendRequest(updateRequest);
    assertStatusCode(message2, HttpResponse.Status.OK, updateResponse);

    String message3 = "取得したプロジェクトが変更した内容と一致すること";
    RestMockHttpRequest request888 = get("/projects?projectName=プロジェクト８８８");
    HttpResponse response888 = sendRequest(request888);
    assertStatusCode(message3, HttpResponse.Status.OK, response888);
    assertProjectEquals(project, parseProject(response888));
}
```

<details>
<summary>keywords</summary>

取引単体テスト, 複数リクエスト取引, RESTテスト, RestMockHttpRequest, HttpResponse, sendRequest, assertStatusCode, parseProject, Project, ProjectUpdateForm, assertProjectEquals, @Test

</details>

## RequestResponseProcessorの実装クラスを作成する

取引単体テストで前のレスポンス値（セッションID、CSRFトークン等）を次のリクエストに引き継ぐには `RequestResponseProcessor` インターフェースの実装クラスを作成する。

**提供実装クラス**:
- `RequestResponseCookieManager`: `Set-Cookie`ヘッダからプロパティで指定した名前のクッキーを抽出し、`Cookie`ヘッダに引き継ぐ
- `NablarchSIDManager`: [session_store_handler](../../component/handlers/handlers-SessionStoreHandler.md) のデフォルトクッキー名 `NABLARCH_SID` でセッションIDを抽出。クッキー名をデフォルトから変更した場合は `RequestResponseCookieManager` を使用してクッキー名を明示する

> **重要**: NablarchのDIコンテナではインスタンスはシングルトンになるため、明示的に状態を初期化しないと複数テストケース間で状態が引き継がれる。フレームワークはテストケースごとに `RequestResponseProcessor#reset` を呼び出す。複数テストケース間で状態を引き継ぎたくない場合は `reset()` に初期化処理を実装する。内部状態を持たない場合や複数のテストケース間で状態を共有したい場合は、`reset()` を何もしないメソッドにしてよい。

<details>
<summary>keywords</summary>

RequestResponseProcessor, RequestResponseCookieManager, NablarchSIDManager, Cookie引き継ぎ, セッションID管理, CSRFトークン, テストケース状態管理, cookieName, reset, NABLARCH_SID

</details>

## コンポーネント設定ファイルのdefaultProcessor設定

実装クラスをコンポーネント設定ファイルに `defaultProcessor` という名前で設定する。

単一プロセッサの設定例:
```xml
<component name="defaultProcessor" class="nablarch.test.core.http.RequestResponseCookieManager"/>
  <property name="cookieName" value="JSESSIONID"/>
</component>
```

複数の `RequestResponseProcessor` を設定したい場合は `ComplexRequestResponseProcessor` を使用する:
```xml
<component name="defaultProcessor" class="nablarch.test.core.http.ComplexRequestResponseProcessor">
  <property name="processors">
    <list>
      <component class="nablarch.test.core.http.RequestResponseCookieManager"/>
        <property name="cookieName" value="JSESSIONID"/>
      </component>
      <component class="nablarch.test.core.http.NablarchSIDManager"/>
      <component class="com.example.test.CSRFTokenManager"/>
    </list>
  </property>
</component>
```

`defaultProcessor` という名前で設定された `RequestResponseProcessor` は、内蔵サーバへのリクエスト送信前に `RequestResponseProcessor#processRequest` が、レスポンス受信後に `RequestResponseProcessor#processResponse` が実行される。

<details>
<summary>keywords</summary>

defaultProcessor, ComplexRequestResponseProcessor, processors, processRequest, processResponse, RequestResponseCookieManager, NablarchSIDManager, JSESSIONID, コンポーネント設定

</details>
