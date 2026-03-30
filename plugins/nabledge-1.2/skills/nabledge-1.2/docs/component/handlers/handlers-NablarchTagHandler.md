# Nablarchカスタムタグ制御ハンドラ

## 概要

**クラス名**: `nablarch.common.web.handler.NablarchTagHandler`

カスタムタグと連動し、ウィンドウスコープをはじめとする各種機能を実現するハンドラ。

カスタムタグの詳細: [../02_FunctionDemandSpecifications/03_Common/07_WebView](../libraries/libraries-07_WebView.md)

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [MultipartHandler](handlers-MultipartHandler.md) | POSTパラメータのためにリクエストボディを読み込む。NablarchTagHandlerの後続に配置すること。 |

<details>
<summary>keywords</summary>

NablarchTagHandler, nablarch.common.web.handler.NablarchTagHandler, MultipartHandler, CustomTagConfig, ウィンドウスコープ, カスタムタグ制御ハンドラ

</details>

## ハンドラ処理フロー

**[往路処理]**

1. 内部フォーワードによる再実行の場合は処理をスキップし、後続ハンドラに委譲して結果をリターン
2. カスタムタグ向け処理を実行:
   - ボタン/リンク毎のパラメータ変更機能のため、リクエストに変更パラメータを設定
   - checkboxタグのチェックなしに対応する値をリクエストに設定
   - hiddenタグの暗号化機能に対応する改竄チェックと復号
   - HTTPアクセスログのリクエストパラメータを出力
   - `CustomTagConfig` をリクエストスコープに設定（設定可能なデフォルト値の詳細は :ref:`WebView_NablarchTagHandler` 参照）

> **注意**: 改竄チェックと復号は、カスタムタグのデフォルト値設定でhiddenタグの暗号化機能を「使用する」に設定している場合のみ実行される

2a. Hidden項目改竄検知時: 復号されたチャレンジコードがセッションのものと不一致の場合、INFOレベルのログを出力後、設定されたエラー遷移先/ステータスコードでHTTPエラーレスポンスを送出

3. 後続ハンドラに処理委譲

**[復路処理]**

4. 手順3で取得した処理結果をリターン

**[例外制御]**

3a. 後続ハンドラ実行中のエラーはそのまま再送出

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 改竄チェック, CustomTagConfig, hiddenタグ暗号化, 内部フォーワード

</details>

## 改竄検知の判定について

リクエストの改竄を下記順序で検知する:

1. HTTP POST以外のリクエストは改竄エラーとして処理
2. セッションからウィンドウスコープ暗号化用の鍵を取得。取得できない場合は改竄エラーまたはセッション無効化時エラーとして処理
3. ウィンドウスコープデータをセッション上の鍵で復号。リクエストパラメータからウィンドウスコープ値が取得できない場合、または復号失敗の場合は改竄エラーとして処理
4. 復号データのハッシュ値を検証。一致しない場合は改竄エラーとして処理
5. ウィンドウスコープの値から前画面で遷移可能なリクエストIDを取得し、処理中のリクエストIDと比較。含まれていない場合は改竄エラーとして処理

**実際の改竄以外に改竄エラーとなるケース:**

- セッションから暗号化キーが取得できない場合（長時間未使用によるセッション無効、ログアウト後の別ウィンドウからのリクエスト等）。ただし `sessionExpirePath` を設定済みの場合はそのフォワード先を使用可能
- 改竄検知対象のリクエストIDをURL直接指定した場合（ブックマーク含む）
- Nablarchカスタムタグで作成したサブミットボタン以外の方法でPOSTした場合（アプリケーションバグでも発生しうる）

**エラー画面設計指針:** 改竄エラー画面には実際の改竄者への通知は不要のため、以下のいずれかが発生したことを伝えるメッセージを表示:
- 既にログアウトしたか、長期間未使用のためログアウトされた
- 正しくない画面遷移が行われた

<details>
<summary>keywords</summary>

改竄検知, 改竄エラー, sessionExpirePath, ウィンドウスコープ暗号化, セッション無効化, 改竄エラー画面設計

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| path | String | ○ | | 改竄を検知した場合に送信する画面のリソースパス。判定基準は :ref:`detection_logic` 参照 |
| statusCode | int | | 400 | 改竄を検知した場合のレスポンスステータス |
| sessionExpirePath | String | | pathと同値 | セッションが無効化されていた際に遷移する画面のリソースパス |
| sessionExpireStatusCode | int | | 400 | セッションが無効化されていた場合のレスポンスステータス |

```xml
<component name="nablarchTagHandler"
           class="nablarch.common.web.handler.NablarchTagHandler">
  <property name="path" value="/TAMPERING-DETECTED.jsp" />
  <property name="statusCode" value="400" />
</component>
```

<details>
<summary>keywords</summary>

path, statusCode, sessionExpirePath, sessionExpireStatusCode, 設定項目, NablarchTagHandler XML設定例

</details>
