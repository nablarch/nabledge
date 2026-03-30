# 携帯端末アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.KeitaiAccessHandler`

携帯端末（フィーチャーフォン）からのアクセスを処理するハンドラ。以下の処理を行う:
- リクエストパラメータ中の`nablarch_uri_override`で始まるパラメータでリクエストパスを置換する。これによりJavaScript非対応端末でも、サブミットボタン毎の遷移先切替・ウィンドウスコープ利用が可能になる。
- JavaScript等の出力を抑制するフラグ（`nablarch_jsUnsupported`）をリクエストスコープ変数に設定する（JSP中の各カスタムライブラリで使用される）。

**関連ハンドラの配置制約**:

| ハンドラ | 配置 | 理由 |
|---|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラの上位 | `nablarch_jsUnsupported`フラグの設定がレスポンスに反映されるために必要 |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラの後続 | 書換え後のリクエストパスをもとに[スレッドコンテキスト](../libraries/libraries-thread_context.md)上のリクエストID属性を決定するため |
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | 本ハンドラの後続 | `nablarch_sumbit`の値をもとに改竄チェックやウィンドウスコープの展開等を行うため |

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch.fw.web.handler.KeitaiAccessHandler, 携帯端末アクセス, フィーチャーフォン, nablarch_jsUnsupported, JavaScript出力抑制, リクエストパス置換, HttpResponseHandler, ThreadContextHandler, NablarchTagHandler, ハンドラ配置制約

</details>

## ハンドラ処理フロー

**[往路処理]**
1. `nablarch_jsUnsupported`をリクエストスコープに設定する。
2. `nablarch_uri_override`で始まるパラメータが存在する場合、そのパラメータの内容でリクエストパスを置換し、`nablarch_sumit`の値を設定する。
3. 書き換え後のHTTPリクエストオブジェクトを後続ハンドラに渡して処理を委譲し、HTTPレスポンスオブジェクトを取得する。

**[復路処理]**

4. 取得したHTTPレスポンスオブジェクトをリターンして終了する。

**[例外処理]**

3a. 後続ハンドラ処理中にエラーが発生した場合は、そのまま再送出して終了する。

<details>
<summary>keywords</summary>

nablarch_uri_override, nablarch_sumit, nablarch_jsUnsupported, 往路処理, 復路処理, 例外処理, リクエストパス書き換え

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目はない。携帯対応を行うリクエストパスの範囲を限定するため、通常は[RequestHandlerEntry](handlers-RequestHandlerEntry.md)と組み合わせて使用する。

**設定例**: サーブレットコンテキストからの相対パス `/action/mobile/` 配下のアクセスに本ハンドラを適用する場合。

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action/mobile//"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.KeitaiAccessHandler" />
  </property>
</component>
```

<details>
<summary>keywords</summary>

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, requestPattern, 携帯対応ハンドラ設定, リクエストパス限定

</details>
