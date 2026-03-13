# リクエスト単体テストの実施方法

**公式ドキュメント**: [リクエスト単体テストの実施方法](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/rest.html)

## 前提条件

RESTfulウェブサービス実行基盤向けのテストでは、他の実行基盤向けテスティングフレームワークに加え依存するモジュールを追加する必要がある。詳細は [自動テストフレームワークの使用方法](testing-framework-RequestUnitTest_rest.md) 参照。

<details>
<summary>keywords</summary>

RESTfulウェブサービス, テスト前提条件, 依存モジュール追加, rest_testing_fw

</details>

## テストクラスの書き方

テストクラスのスーパークラス選択:
- DBデータ投入・アサートが必要: `nablarch.test.core.http.RestTestSupport` を継承
- DBデータ投入・アサートが不要: `nablarch.test.core.http.SimpleRestTestSupport` を継承（テストデータの書き方は不要）

各スーパークラスの詳細は [自動テストフレームワークの使用方法](testing-framework-RequestUnitTest_rest.md) 参照。

テスティングフレームワークはJUnit4ベース。テスト対象メソッドに `@Test` アノテーションを付与する。

リクエスト送信・検証のAPI:
- リクエスト生成: スーパークラスの [事前準備補助機能](testing-framework-RequestUnitTest_rest.md) を使用
- リクエスト送信: スーパークラスの [リクエスト送信メソッド](testing-framework-RequestUnitTest_rest.md) を呼び出す
- ステータスコード検証: スーパークラスの [メソッド](testing-framework-RequestUnitTest_rest.md) を呼び出す
- レスポンスボディ: 任意のライブラリを使用

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
        RestMockHttpRequest request = get("/projects");
        HttpResponse response = sendRequest(request);
        assertStatusCode(message, HttpResponse.Status.OK, response);
        assertThat(response.getBodyString(), hasJsonPath("$", hasSize(10)));
        JSONAssert.assertEquals(message, readTextResource("プロジェクト一覧が取得できること.json"),
                response.getBodyString(), JSONCompareMode.LENIENT);
    }
}
```

<details>
<summary>keywords</summary>

RestTestSupport, SimpleRestTestSupport, RestMockHttpRequest, HttpResponse, @Test, sendRequest, assertStatusCode, readTextResource, JSONAssert, JSONCompareMode, JSONException, テストクラス作成, スーパークラス継承, リクエスト送信, ステータスコード検証

</details>

## テストデータの書き方

テストデータは :ref:`how_to_write_excel` の方法で記述できる。RESTfulウェブサービス実行基盤向けテストでフレームワークが自動読み込みするデータは以下のみ:
- テストクラスで共通のデータベース初期値
- テストメソッド毎のデータベース初期値

> **重要**: RESTfulウェブサービス実行基盤向けテストでは、Excelファイルが存在しない場合でもエラーにならず、DBへのデータ投入がスキップされるだけ（他の実行基盤のテストとは異なる）。

> **重要**: 上記以外のテストデータをExcelに記載した場合は、[how_to_get_data_from_excel](testing-framework-03_Tips.md) の方法でテストクラスに値を取得する処理を記述する必要がある。`RestTestSupport` では以下のメソッドを提供する:
> ```java
> List<Map<String, String>> getListMap(String sheetName, String id)
> List<Map<String, String[]>> getListParamMap(String sheetName, String id)
> Map<String, String[]> getParamMap(String sheetName, String id)
> ```

**テストクラスで共通のデータベース初期値**: :ref:`request_test_setup_db` 参照。

**テストメソッド毎のデータベース初期値**: テストデータのExcelファイルにテストメソッドの名前でシートを用意し、`SETUP_TABLES` データタイプでデータベース初期値を記載する。フレームワークによりテストメソッド実行時に投入される。

<details>
<summary>keywords</summary>

テストデータ, Excelファイル, データベース初期値, SETUP_TABLES, getListMap, getListParamMap, getParamMap, RestTestSupport

</details>
