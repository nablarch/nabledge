# リクエスト単体テストの実施方法

**公式ドキュメント**: [リクエスト単体テストの実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/rest.html)

## 前提条件

RESTfulウェブサービス実行基盤向けのテストでは、他の実行基盤向けテスティングフレームワークに加え、依存モジュールの追加が必要。詳細は [自動テストフレームワークの使用方法](testing-framework-RequestUnitTest_rest.md) 参照。

<details>
<summary>keywords</summary>

RESTfulウェブサービステスト, 依存モジュール追加, テスティングフレームワーク設定, rest_testing_fw

</details>

## テストクラスの書き方

**クラス**: `nablarch.test.core.http.RestTestSupport`、`nablarch.test.core.http.SimpleRestTestSupport`

テストデータのDB投入・アサートが不要な場合は `SimpleRestTestSupport` を継承する（その場合は [テストデータの書き方](#s2) は不要）。各スーパークラスの詳細は [自動テストフレームワークの使用方法](testing-framework-RequestUnitTest_rest.md) 参照。

テストメソッドに `@Test` アノテーションを付与する（JUnit4ベース）。

リクエストは [事前準備補助機能](testing-framework-RequestUnitTest_rest.md) で生成し、[リクエスト送信メソッド](testing-framework-RequestUnitTest_rest.md) で送信する。ステータスコードは [スーパークラスのメソッド](testing-framework-RequestUnitTest_rest.md) で検証する。レスポンスボディは任意のライブラリを使用してアプリケーションに合わせて検証する。

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

<details>
<summary>keywords</summary>

RestTestSupport, SimpleRestTestSupport, RestMockHttpRequest, HttpResponse, assertStatusCode, sendRequest, readTextResource, @Test, RESTテストクラス作成, レスポンス検証, JSONAssert, JSONCompareMode, JsonPathMatchers

</details>

## テストデータの書き方

RESTfulウェブサービス実行基盤向けテストで自動的に読み込まれるExcelデータは以下のみ:
1. テストクラスで共通のデータベース初期値（:ref:`request_test_setup_db` 参照）
2. テストメソッド毎のデータベース初期値

> **重要**: RESTfulウェブサービス実行基盤向けのテストでは、Excelファイルが存在しない場合でもエラーにならず、DBへのデータ投入がスキップされるだけ（他の実行基盤向けテストとは異なる）。

> **重要**: 上記以外のデータをExcelに記載した場合、[how_to_get_data_from_excel](testing-framework-03_Tips.md) に記載の方法でテストクラスに値取得処理を記述する必要がある。`RestTestSupport` は以下のメソッドを提供する:
> ```java
> List<Map<String, String>> getListMap(String sheetName, String id)
> List<Map<String, String[]>> getListParamMap(String sheetName, String id)
> Map<String, String[]> getParamMap(String sheetName, String id)
> ```

**テストメソッド毎のデータベース初期値**: Excelファイルに**テストメソッドの名前**でシートを用意し、`SETUP_TABLES` データタイプで初期値を記載する。フレームワークがテストメソッド実行時に自動投入する。

<details>
<summary>keywords</summary>

getListMap, getListParamMap, getParamMap, SETUP_TABLES, Excelなしスキップ, テストメソッド別DB初期値, RestTestSupport

</details>
