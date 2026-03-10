# リクエスト単体テストの実施方法

## 前提条件

RESTfulウェブサービス実行基盤向けのテストでは、他の実行基盤向けテスティングフレームワークに加え、依存モジュールの追加が必要。詳細は :ref:`自動テストフレームワークの使用方法 <rest_testing_fw>` 参照。

## テストクラスの書き方

**クラス**: `nablarch.test.core.http.RestTestSupport`、`nablarch.test.core.http.SimpleRestTestSupport`

テストデータのDB投入・アサートが不要な場合は `SimpleRestTestSupport` を継承する（その場合は :ref:`テストデータの書き方 <rest_test_data>` は不要）。各スーパークラスの詳細は :ref:`自動テストフレームワークの使用方法 <rest_test_superclasses>` 参照。

テストメソッドに `@Test` アノテーションを付与する（JUnit4ベース）。

リクエストは :ref:`事前準備補助機能 <rest_test_helper>` で生成し、:ref:`リクエスト送信メソッド <rest_test_execute>` で送信する。ステータスコードは :ref:`スーパークラスのメソッド <rest_test_assert>` で検証する。レスポンスボディは任意のライブラリを使用してアプリケーションに合わせて検証する。

```java
import nablarch.fw.web.HttpResponse;
import nablarch.fw.web.RestMockHttpRequest;
import nablarch.test.core.http.RestTestSupport;
import org.json.JSONException;
import org.junit.Test;
import org.skyscreamer.jsonassert.JSONAssert;
import org.skyscreamer.jsonassert.JSONCompareMode;

import static com.jayway.jsonpath.matchers.JsonPathMatchers.hasJsonPath;
import static org.hamcrest.Matchers.hasSize;
import static org.junit.Assert.assertThat;

public class SampleTest extends RestTestSupport {
    @Test
    public void プロジェクト一覧が取得できること() throws JSONException {
        String message = "プロジェクト一覧取得";
        RestMockHttpRequest request = get("/projects");               // リクエスト生成
        HttpResponse response = sendRequest(request);                 // リクエスト送信
        assertStatusCode(message, HttpResponse.Status.OK, response);  // ステータスコード検証

        assertThat(response.getBodyString(), hasJsonPath("$", hasSize(10)));    // json-path-assert
        JSONAssert.assertEquals(message, readTextResource("プロジェクト一覧が取得できること.json"),
                response.getBodyString(), JSONCompareMode.LENIENT);             // JSONAssert
    }
}
```

## テストデータの書き方

RESTfulウェブサービス実行基盤向けテストで自動的に読み込まれるExcelデータは以下のみ:
1. テストクラスで共通のデータベース初期値（:ref:`request_test_setup_db` 参照）
2. テストメソッド毎のデータベース初期値

> **重要**: RESTfulウェブサービス実行基盤向けのテストでは、Excelファイルが存在しない場合でもエラーにならず、DBへのデータ投入がスキップされるだけ（他の実行基盤向けテストとは異なる）。

> **重要**: 上記以外のデータをExcelに記載した場合、:ref:`how_to_get_data_from_excel` に記載の方法でテストクラスに値取得処理を記述する必要がある。`RestTestSupport` は以下のメソッドを提供する:
> ```java
> List<Map<String, String>> getListMap(String sheetName, String id)
> List<Map<String, String[]>> getListParamMap(String sheetName, String id)
> Map<String, String[]> getParamMap(String sheetName, String id)
> ```

**テストメソッド毎のデータベース初期値**: Excelファイルに**テストメソッドの名前**でシートを用意し、`SETUP_TABLES` データタイプで初期値を記載する。フレームワークがテストメソッド実行時に自動投入する。

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

## RequestResponseProcessorの実装クラスを作成する

取引単体テストで前のレスポンス値（セッションID、CSRFトークン等）を次のリクエストに引き継ぐには `RequestResponseProcessor` インターフェースの実装クラスを作成する。

**提供実装クラス**:
- `RequestResponseCookieManager`: `Set-Cookie`ヘッダからプロパティで指定した名前のクッキーを抽出し、`Cookie`ヘッダに引き継ぐ
- `NablarchSIDManager`: :ref:`session_store_handler` のデフォルトクッキー名 `NABLARCH_SID` でセッションIDを抽出。クッキー名をデフォルトから変更した場合は `RequestResponseCookieManager` を使用してクッキー名を明示する

> **重要**: NablarchのDIコンテナではインスタンスはシングルトンになるため、明示的に状態を初期化しないと複数テストケース間で状態が引き継がれる。フレームワークはテストケースごとに `RequestResponseProcessor#reset` を呼び出す。複数テストケース間で状態を引き継ぎたくない場合は `reset()` に初期化処理を実装する。内部状態を持たない場合や複数のテストケース間で状態を共有したい場合は、`reset()` を何もしないメソッドにしてよい。

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
