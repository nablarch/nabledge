# Nablarchカスタムタグ制御ハンドラ

## 概要

**クラス名**: `nablarch.common.web.handler.NablarchTagHandler`

Nablarchカスタムタグと連動し、ウィンドウスコープをはじめとする各種機能を実現するハンドラ。

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [MultipartHandler](handlers-MultipartHandler.md) | 本ハンドラはPOSTパラメータを使用するためリクエストボディを読み込む。そのため、MultipartHandlerは本ハンドラの後続に配置すること。 |

<details>
<summary>keywords</summary>

NablarchTagHandler, nablarch.common.web.handler.NablarchTagHandler, MultipartHandler, ウィンドウスコープ, カスタムタグ制御ハンドラ, ハンドラ配置順序

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **内部フォーワードによる重複実行スキップ**: 内部フォーワードによる再実行の場合、処理を後続ハンドラに委譲してそのまま終了。
2. **Nablarchカスタムタグ向け処理の実行**:
   - ボタン/リンク毎のパラメータ変更機能のため、リクエストに変更パラメータを設定
   - checkboxタグのチェックなし対応値をリクエストに設定
   - hiddenタグの暗号化機能に対応する改竄チェックと復号
   - HTTPアクセスログのリクエストパラメータを出力
   - `CustomTagConfig` をリクエストスコープに設定（設定可能なデフォルト値の詳細は :ref:`WebView_NablarchTagHandler` 参照）

> **注意**: 改竄チェックと復号は、カスタムタグのデフォルト値設定においてhiddenタグの暗号化機能を「使用する」に設定している場合のみ実行。

2a. **Hidden項目改竄検知**: 復号したチャレンジコードがセッション上のものと一致しない場合、INFOレベルのログを出力し、設定されたエラー遷移先/ステータスコードでHTTPエラーレスポンスを送出。

3. 後続ハンドラに処理を委譲し、結果を取得。

**[復路処理]**

4. 手順3で取得した処理結果をリターンして終了。

**[例外制御]**

3a. 後続ハンドラ実行中にエラーが発生した場合は、そのまま再送出して終了。

<details>
<summary>keywords</summary>

NablarchTagHandler, 往路処理, 復路処理, 例外制御, CustomTagConfig, hidden暗号化, 改竄チェック, リクエストスコープ, 内部フォーワード, チャレンジコード

</details>

## 改竄検知の判定について

改竄検知の判定順序:

1. HTTPメソッドがPOST以外の場合 → 改竄エラー
2. セッションからウィンドウスコープ暗号化キーを取得。取得できない場合 → 改竄エラーまたはセッション無効化時エラー
3. セッションの鍵でウィンドウスコープデータを復号。リクエストパラメータから値が取得できない、または復号失敗 → 改竄エラー
4. 復号データに含まれるハッシュ値と復号データ全体のハッシュ値を比較。不一致 → 改竄エラー
5. ウィンドウスコープの値から前画面JSP遷移可能なリクエストIDを全て取得し、処理中リクエストIDと比較。含まれない場合 → 改竄エラー

実際の改竄以外に改竄エラーとなるケース:
- セッション無効化（長時間未操作、ログアウト後の別ウィンドウからのリクエスト送信）: `sessionExpirePath` 設定時はそちらへ遷移可能
- 改竄検知対象リクエストIDの画面へURL直接指定（ブックマーク含む）
- Nablarchカスタムタグのサブミットボタン押下以外の方法でPOSTリクエスト送信（アプリケーションバグでも発生しうる）

> **重要**: 改竄エラー画面は実際の改竄行為以外でも表示されるため、「既にログアウトした、または長期間未使用でログアウトされた」「正しくない画面遷移が行われた」旨のメッセージを表示すること。改竄エラーは実際の攻撃者への通知は不要。

<details>
<summary>keywords</summary>

改竄検知, セッション無効化, sessionExpirePath, ウィンドウスコープ復号, 改竄エラー, ハッシュ値比較, リクエストID検証

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| path | String | ○ | | hidden項目の改竄を検知した場合に遷移する画面のリソースパス。判定基準は :ref:`detection_logic` 参照。 |
| statusCode | int | | 400 | 改竄検知時のレスポンスステータスコード |
| sessionExpirePath | String | | pathの値 | セッション無効化時に遷移する画面のリソースパス。未指定時はpathと同じ。 |
| sessionExpireStatusCode | int | | 400 | セッション無効化時のレスポンスステータスコード |

```xml
<component name="nablarchTagHandler"
           class="nablarch.common.web.handler.NablarchTagHandler">
  <property name="path" value="/TAMPERING-DETECTED.jsp" />
  <property name="statusCode" value="400" />
</component>
```

<details>
<summary>keywords</summary>

path, statusCode, sessionExpirePath, sessionExpireStatusCode, NablarchTagHandler設定, 改竄エラー画面パス, セッション無効化エラー

</details>
