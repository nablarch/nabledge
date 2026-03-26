# リクエスト単体テストの実施方法

## テストクラスの書き方

テストクラス作成ルール: (1) テスト対象Actionクラスと同一パッケージ (2) クラス名は`{Action名}RequestTest` (3) `nablarch.test.core.http.BasicHttpRequestTestTemplate`を継承

> **注意**: `BasicHttpRequestTestTemplate`は`DbAccessTestSupport`の機能も兼ね備えており、データベース設定などもクラス単体テストと同様に実行できる。

```java
package nablarch.sample.management.user;
public class UserSearchActionRequestTest extends BasicHttpRequestTestTemplate {
```

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, DbAccessTestSupport, リクエスト単体テスト, テストクラス命名規則, テストクラス作成

</details>

## テストメソッド分割

テストメソッド分割ルール:
1. リクエストID毎（Actionのメソッド毎）に正常系・異常系でテストメソッドを作成
2. 異常系がない場合（例: メニューからの単純な画面遷移）は正常系のみ作成
3. 画面表示検証で同一シート内の条件分岐が煩雑になる場合は画面表示検証用メソッドを別途作成、そうでない場合は正常系または異常系のメソッドに含める

テストデータシートが煩雑になり可読性が下がる場合はシートを分割する。

メソッド分割例:

| リクエストID | Actionメソッド名 | 正常系 | 異常系 | 画面表示検証用 |
|---|---|---|---|---|
| USERS00101 | doUsers00101 | testUsers00101Normal | testUsers00101Abnormal | testUsers00101View |

<details>
<summary>keywords</summary>

テストメソッド分割, 正常系, 異常系, 画面表示検証, リクエストID

</details>

## テストデータの書き方

テストデータ記述ルール:
- Excelファイルはテストソースコードと同じディレクトリに同じファイル名（拡張子のみ異なる）で格納

**setUpDb シート**: 共通のデータベース初期値を記載。テストメソッド実行時に自動投入される。

**テストケース一覧 (LIST_MAP=testShots)**:

| カラム名 | 説明 | 必須 |
|---|---|---|
| no | テストケース番号（1からの連番） | ○ |
| description | テストケース説明。HTMLダンプファイル名に使用。OSで規定されたファイル名に利用可能な文字のみ使用可。OSで無効な文字の使用やファイル名長さ上限超過はIOExceptionの原因になる。 | ○ |
| context | リクエストIDとユーザ情報を指定。詳細は :ref:`request_test_user_info` 参照。 | ○ |
| cookie | Cookie情報。詳細は :ref:`request_test_cookie_info` 参照。 | |
| isValidToken | トークンを設定する場合はtrueを指定。 | |
| setUpTable | テストケース実行前にDBに登録するデータの :ref:`グループID<tips_groupId>` 。 | |
| expectedStatusCode | 期待するHTTPステータスコード。302と303は同一視してアサートされる。 | ○ |
| expectedMessageId | 期待するメッセージID（複数はカンマ区切り）。空欄の場合メッセージが出力されるとテスト失敗。 | |
| expectedSearch | 期待する検索結果のLIST_MAP ID。リクエストスコープからの取得キーは`searchResult`。 | |
| expectedTable | 期待するDBの状態の :ref:`グループID<tips_groupId>` 。 | |
| forwardUri | 期待するフォワード先URI。空欄の場合はJSPフォワードが行われないとアサートされる。システムエラー画面や認証エラー画面へ遷移することを想定するテストケースでは、その画面を描画するJSPへのURIを記載する（例: `/jsp/systemError.jsp` はシステムエラー画面のデフォルト値）。 | |
| expectedContentLength | コンテンツレングスヘッダの期待値（ファイルダウンロード用）。 | |
| expectedContentType | コンテンツタイプヘッダの期待値（ファイルダウンロード用）。 | |
| expectedContentFileName | コンテンツディスポジションヘッダのファイル名期待値（ファイルダウンロード用）。 | |
| expectedMessage | メッセージ同期送信の要求電文の :ref:`グループID<tips_groupId>` 。 | |
| responseMessage | メッセージ同期送信の応答電文の :ref:`グループID<tips_groupId>` 。 | |
| expectedMessageByClient | HTTPメッセージ同期送信の要求電文の :ref:`グループID<tips_groupId>` 。 | |
| responseMessageByClient | HTTPメッセージ同期送信の応答電文の :ref:`グループID<tips_groupId>` 。 | |

> **注意**: `description`はHTMLダンプファイル名に使用されるため、OSで規定されたファイル名に利用可能な文字のみ使用すること。OSで無効な文字（例: 改行コード）の使用やファイル名の長さ上限超過はIOExceptionが発生する。

> **注意**: HTTPステータスコード302と303は同一視してアサートされる（RFC規定のHTTP 1.1では303が推奨だが、主要WebコンテナはレガシーブラウザのためにHTTP 302を使用しているため）。

**ユーザ情報 (LIST_MAP)**: 複数のユーザ情報を使い分けることで、権限によって処理が異なる機能をテスト可能。

**Cookie情報 (LIST_MAP)**: 任意項目。Cookieが不要なケースは空白とする。

**リクエストパラメータ (LIST_MAP=requestParams)**:
- 各テストケースで送信するHTTPパラメータをLIST_MAPで記載（ID=`requestParams`）
- テストケース一覧と行単位で関連付けられる
- :ref:`http_dump_tool` を使用してデータ作成（初期画面表示以外）
- マーカー列としてテストケース番号を記載すること
- リクエストパラメータが不要な場合でもLIST_MAP=requestParamsには必ず列を定義し、テストケース数分の行を定義する（パラメータなし時はテストケース番号列のみ）
- ※`[no]`列はテストケース番号を視覚的に表すマーカー列であり、実際のHTTPリクエストパラメータには含まれない

<details>
<summary>keywords</summary>

testShots, setUpDb, LIST_MAP, requestParams, expectedStatusCode, expectedMessageId, expectedSearch, expectedTable, forwardUri, テストケース一覧, Cookie情報, ユーザ情報, context, cookie, isValidToken, setUpTable, expectedContentLength, expectedContentType, expectedContentFileName, expectedMessage, responseMessage, expectedMessageByClient, responseMessageByClient

</details>

## ひとつのキーに対して複数の値を設定する場合

HTTPリクエストパラメータで1つのキーに複数の値を設定する場合、**カンマ区切り**で記述する。

- `foo`に`one`と`two`を設定: `one,two`
- 値にカンマを含む場合は`\`でエスケープ（例: `\,`）
- 値にバックスラッシュを含む場合は`\\`でエスケープ
- 例: `\1,000`という値を表すには`\\1\,000`と記述する

<details>
<summary>keywords</summary>

リクエストパラメータ複数値, カンマ区切り, エスケープ, リクエストパラメータ

</details>

## 期待する検索結果

期待する検索結果をテストケース一覧とリンクさせる。テストケース一覧の`expectedSearch`カラムに、同シート内のLIST_MAP IDを指定する。リクエストスコープから取得する際のキーは`searchResult`。

<details>
<summary>keywords</summary>

expectedSearch, searchResult, 検索結果検証, LIST_MAP

</details>

## 期待するデータベースの状態

更新系テストケースで期待するデータベースの状態を確認する場合、テストケース一覧の`expectedTable`カラムに期待するテーブルの :ref:`グループID<tips_groupId>` を指定する。

<details>
<summary>keywords</summary>

expectedTable, データベース検証, 更新系テスト, グループID

</details>

## テストメソッドの書き方

**クラス**: `nablarch.test.core.http.BasicHttpRequestTestTemplate`を継承する。

テスト実行フロー:
1. データシートからtestShots LIST_MAPを取得
2. 各テストケースについて以下を繰り返し実行:
   1. データベース初期化
   2. ExecutionContext、HTTPリクエストを生成
   3. `beforeExecuteRequest`メソッド呼出
   4. トークンが必要な場合、トークンを設定
   5. テスト対象のリクエスト実行
   6. 実行結果の検証（HTTPステータスコード・メッセージID・HTTPレスポンス値・検索結果・テーブル更新結果）
   7. `afterExecuteRequest`メソッド呼出

オーバーライド必須の抽象メソッド:

```java
@Override
protected String getBaseUri() {
    return "/action/management/user/UserSearchAction/";
}
```

テストメソッド作成: テストシートに対応するメソッドを作成し、スーパクラスの`execute(String sheetName)`（通常）または`execute(String sheetName, Advice advice)`を呼び出す。

```java
@Test
public void testUsers00101Normal() {
    execute("testUsers00101Normal");
}
```

<details>
<summary>keywords</summary>

BasicHttpRequestTestTemplate, getBaseUri, execute, beforeExecuteRequest, afterExecuteRequest, テストメソッド作成

</details>
