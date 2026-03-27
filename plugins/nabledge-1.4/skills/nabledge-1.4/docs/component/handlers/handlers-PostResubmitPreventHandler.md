# POST再送信防止ハンドラ

## 概要

> **警告**: 新規プロジェクトにおける本ハンドラの使用は推奨されていません。

> **警告**: DoS攻撃等により大量のリクエストが送信された場合、リダイレクト処理が実行されずPOST情報がセッションに蓄積され、メモリを圧迫する可能性がある。本ハンドラを使用せず、業務アクションにてリダイレクトのレスポンスを返すことでPOST再送信を防止すること。

**クラス名**: `nablarch.fw.web.post.PostResubmitPreventHandler`

POSTリクエストに対してリダイレクトを使用して再リクエストを受け付けることで、ブラウザからのPOSTデータ再送信を防止する。

**使用が必要となるセキュリティ脅威シナリオ**

:ref:`WebView_NoCacheTag` をJSPに指定していても、ブラウザの戻るボタンを押下して前画面に戻った場合、F12開発者ツールなどで前画面で入力した内容を盗み見ることが可能である。これは、正規ユーザが操作した端末を操作直後に悪意ある者に操作された場合にセキュリティ上の脅威となりうる。

通常は、端末を入室に認証が必要な区画に設置する、ログイン時にパスワードを入力させる、他人に端末を操作させないなど、物理的なセキュリティを高めることでこの脅威は回避できる。システム的にこれを回避したい場合に本ハンドラを使用する。

- multipartリクエストには対応していない
- 保護する情報を入力する :ref:`WebView_FormTag` のpreventPostResubmit属性をtrueに設定すること（「POST再送信防止が指示されたリクエスト」の条件）
- POST再送信防止が指示されたリクエストでリダイレクト後のGETリクエストが複数送信された場合、2回目以降は設定パスに遷移する

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | 本ハンドラは [NablarchTagHandler](handlers-NablarchTagHandler.md) の上位に配置する必要がある |

<details>
<summary>keywords</summary>

PostResubmitPreventHandler, nablarch.fw.web.post.PostResubmitPreventHandler, NablarchTagHandler, POST再送信防止, preventPostResubmit, multipart非対応, セッション, 非推奨, F12開発者ツール, 戻るボタン, セキュリティ脅威, WebView_NoCacheTag, システム的回避, WebView_FormTag

</details>

## ハンドラ処理フロー

**往路処理**

1. POST再送信防止が指示されたリクエストか判定
   - 該当する場合（1a）: リクエスト情報をセッションスコープに格納し、同一URIにリダイレクト
2. POST後にリダイレクトされたリクエストか判定
   - 該当する場合（2a）: セッションスコープのリクエスト情報を復元し削除
   - セッションに復元対象が存在しない場合: GETが複数回送信されたと判断し設定パスへ遷移。遷移先パス未設定の場合はシステムエラー
3. 後続ハンドラを呼び出す

**復路処理**

4. 後続ハンドラの結果をリターンして終了

**例外処理**

3a. 後続ハンドラ実行中の例外はそのまま再送出して終了

<details>
<summary>keywords</summary>

POST再送信防止ハンドラ処理フロー, リダイレクト, セッションスコープ復元, GETリクエスト複数回, システムエラー, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| forwardPathMapping | Map | | | リダイレクト後のGETが複数回送信された場合の遷移先パスマッピング。キーはリクエストID、値は遷移先パス。複数マッチする場合は最も文字数が長いキーのパスに遷移 |

```xml
<component name="postResubmitPreventHandler"
    class="nablarch.fw.web.post.PostResubmitPreventHandler">
  <property name="forwardPathMapping">
    <map>
      <entry key="R"  value="redirect:///action/ErrorAction/index" />
      <entry key="R2" value="redirect:///action/ErrorAction/index2" />
      <entry key="R3" value="/error.jsp" />
    </map>
  </property>
</component>
```

<details>
<summary>keywords</summary>

forwardPathMapping, POST再送信防止設定, リクエストIDマッピング, 遷移先パス, GETリクエスト複数回遷移先

</details>
