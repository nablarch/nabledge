# Nablarchカスタムタグ制御ハンドラ

## 概要

**クラス名**: `nablarch.common.web.handler.NablarchTagHandler`

フレームワークが提供するカスタムタグと連動し、ウィンドウスコープをはじめとする各種機能を実現するハンドラ。

カスタムタグの詳細: [../02_FunctionDemandSpecifications/03_Common/07_WebView](../libraries/libraries-07_WebView.md)

**関連ハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [MultipartHandler](handlers-MultipartHandler.md) | POSTパラメータのリクエストボディを読み込むため、本ハンドラの後続に配置する必要がある |

<details>
<summary>keywords</summary>

NablarchTagHandler, nablarch.common.web.handler.NablarchTagHandler, MultipartHandler, カスタムタグ制御, ウィンドウスコープ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **(内部フォーワードによる重複実行スキップ)** 内部フォーワードによる再実行の場合、本ハンドラの処理を行わず後続ハンドラに委譲し結果をリターン。
2. **(Nablarchカスタムタグ向け処理)** 以下を実行:
   - ボタン/リンク毎のパラメータ変更機能のため、リクエストに変更パラメータを設定
   - checkboxタグのチェックなしに対応する値をリクエストに設定
   - hiddenタグの暗号化機能に対応する改竄チェックと復号
   - HTTPアクセスログのリクエストパラメータを出力
   - CustomTagConfigをリクエストスコープに設定（カスタムタグのデフォルト値をJSPで参照可能にする）。設定可能なデフォルト値の詳細は :ref:`WebView_NablarchTagHandler` を参照

   > **注意**: 改竄チェックと復号は、hiddenタグの暗号化機能を「使用する」に設定している場合のみ処理される。

2a. **(Hidden項目改竄)** 復号されたHidden項目内のチャレンジコードがセッション上のものと不一致の場合、INFOレベルのログを出力し、設定されたエラー遷移先/ステータスコードを指定したHTTPエラーレスポンスを送出。

3. **(後続ハンドラに対する処理委譲)** ハンドラキュー上の後続ハンドラに委譲し結果を取得。

**[復路処理]**

4. **(正常終了)** 3.で取得した処理結果をリターンして終了。

**[例外制御]**

3a. **(後続ハンドラでのエラー)** 後続ハンドラ実行中のエラーはそのまま再送出して終了。

<details>
<summary>keywords</summary>

NablarchTagHandler, CustomTagConfig, hiddenタグ改竄チェック, 往路処理, 復路処理, ハンドラ処理フロー, チャレンジコード

</details>

## 改竄検知の判定について

本ハンドラは以下の順序でリクエストの改竄を検知する:

1. HTTP POST以外で送信された場合、改竄エラーとして処理。
2. セッションからウィンドウスコープの暗号化に使用する鍵を取得。セッションから鍵が取得できない場合、改竄エラーまたはセッション無効化時エラーとして処理。
3. ウィンドウスコープのデータをセッションの鍵で復号。リクエストパラメータからウィンドウスコープの値が取得できない場合または復号失敗の場合は改竄エラーとして処理。
4. 復号したデータに含まれるデータのハッシュ値を比較して有効性を判定。ハッシュ値不一致の場合、改竄エラーとして処理。
5. ウィンドウスコープの値から前画面で遷移可能なリクエストIDを全て取得し、処理中のリクエストIDと比較。含まれない場合、改竄エラーとして処理。

**悪意のないユーザでも改竄エラーが発生するケース**:
- セッションから暗号化キーが取得できない場合（長時間未使用によるセッション無効化、ログアウト後の別ウィンドウからのリクエスト送信など）。ただし`sessionExpirePath`を設定した場合は指定したフォワード先を使用できる。
- 改竄検知対象のリクエストIDの画面をURL直接指定した場合（ブックマークを含む）。
- Nablarchのカスタムタグで作成したサブミットボタン押下以外の方法でリクエストパラメータをPOSTした場合（アプリケーションバグでも発生しうる）。

改竄エラー画面には「既にログアウトしたか長時間未使用でログアウトした」または「正しくない画面遷移が行われた」旨のメッセージを表示すればよい。実際に改竄を行ったユーザに詳細を通知する必要はない。

<details>
<summary>keywords</summary>

改竄検知, ウィンドウスコープ暗号化, sessionExpirePath, 改竄エラー, セッション無効化

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| path | String | ○ | | 改竄検知時のエラー画面リソースパス |
| statusCode | int | | 400 | 改竄検知時のレスポンスステータスコード |
| sessionExpirePath | String | | pathの値 | セッション無効化時のエラー画面リソースパス |
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

path, statusCode, sessionExpirePath, sessionExpireStatusCode, NablarchTagHandler設定, 改竄エラー画面

</details>
