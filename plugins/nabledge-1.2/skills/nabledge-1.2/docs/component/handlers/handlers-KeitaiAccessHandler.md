# 携帯端末アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.KeitaiAccessHandler`

フィーチャーフォンからのアクセスを想定したページを出力するハンドラ。以下の処理を行う:
1. リクエストパラメータ中に埋め込まれた遷移先URIでリクエストパスを置換する（javascript非対応端末でもサブミットボタン毎の遷移先切替やウィンドウスコープの利用が可能になる）
2. javascript等の出力を抑制するフラグ（`nablarch_jsUnsupported`）をリクエストスコープ変数に設定する（JSP中の各カスタムライブラリで使用）

**関連ハンドラと配置制約**

| ハンドラ | 配置制約 |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラの**上位**に配置しないと、javascript抑制設定がレスポンスに反映されない |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラの**後続**に配置する必要がある（書き換え後のリクエストパスから[スレッドコンテキスト](../libraries/libraries-thread_context.md)上のリクエストIDを決定するため） |
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | 本ハンドラの**後続**に配置する必要がある（`nablarch_sumbit`の値をもとに改竄チェックやウィンドウスコープ展開を行うため） |

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch.fw.web.handler.KeitaiAccessHandler, nablarch_jsUnsupported, フィーチャーフォン, 携帯端末アクセス, javascript出力抑制, リクエストパス置換, nablarch_sumbit, HttpResponseHandler, ThreadContextHandler, NablarchTagHandler

</details>

## ハンドラ処理フロー

**[往路処理]**
1. `nablarch_jsUnsupported`フラグをリクエストスコープに設定する
2. リクエストパラメータに`nablarch_uri_override`で始まる名前のパラメータが存在した場合、その内容でリクエストパスを置換し、`nablarch_sumit`の値を設定する
3. 書き換え後のHTTPリクエストオブジェクトを後続ハンドラに委譲し、HTTPレスポンスオブジェクトを取得する

**[復路処理]**

4. 取得したHTTPレスポンスオブジェクトをリターンして終了する

**[例外処理]**

- 3a. 後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する

<details>
<summary>keywords</summary>

nablarch_uri_override, nablarch_sumit, nablarch_jsUnsupported, 往路処理, 復路処理, 例外処理, ハンドラ処理フロー

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。携帯対応を行うリクエストパスの範囲を限定するため、通常は[RequestHandlerEntry](handlers-RequestHandlerEntry.md)と組み合わせて使用する。

**設定例（`/action/mobile/`配下のアクセスに対して本ハンドラを動作させる場合）**:

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

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, requestPattern, 携帯対応, パス限定, 設定例

</details>
