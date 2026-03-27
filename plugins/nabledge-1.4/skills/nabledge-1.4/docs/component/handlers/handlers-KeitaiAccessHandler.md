# 携帯端末アクセスハンドラ

## 概要

**クラス名**: `nablarch.fw.web.handler.KeitaiAccessHandler`

携帯端末（フィーチャーフォン）向けアクセスを想定したページを出力するハンドラ。以下の処理を行う:
1. リクエストパラメータ中に埋め込まれた遷移先URIでリクエストパスを置換する（javascriptに対応していない携帯端末でのサブミットボタン毎の遷移先切替・ウィンドウスコープ利用が可能となる）
2. javascript等の出力を抑制するフラグ（`nablarch_jsUnsupported`）をリクエストスコープ変数に設定する（JSP中の各カスタムライブラリで使用される）

**ハンドラキュー配置順の制約**:

| ハンドラ | 配置ルール |
|---|---|
| [HttpResponseHandler](handlers-HttpResponseHandler.md) | 本ハンドラの**上位**に配置すること。未配置の場合、携帯対応フラグ設定がレスポンスに反映されない |
| [ThreadContextHandler](handlers-ThreadContextHandler.md) | 本ハンドラの**後続**に配置すること。書き換えたリクエストパスをもとにリクエストID属性を決定するため |
| [NablarchTagHandler](handlers-NablarchTagHandler.md) | 本ハンドラの**後続**に配置すること。`nablarch_sumbit`の値をもとに改竄チェック・ウィンドウスコープ展開等を行うため |

<details>
<summary>keywords</summary>

KeitaiAccessHandler, nablarch.fw.web.handler.KeitaiAccessHandler, nablarch_jsUnsupported, 携帯端末アクセス, フィーチャーフォン対応, HttpResponseHandler, ThreadContextHandler, NablarchTagHandler, ハンドラキュー配置順

</details>

## ハンドラ処理フロー

**[往路処理]**

1. `nablarch_jsUnsupported`フラグをリクエストスコープに設定する
2. リクエストパラメータ中に`nablarch_uri_override`で始まる名前のパラメータが存在した場合、その内容でリクエストパスを置換し、リクエストパラメータ`nablarch_sumit`の値を設定する
3. 書き換えたHTTPリクエストオブジェクトを後続ハンドラに委譲し、HTTPレスポンスオブジェクトを取得する

**[復路処理]**

4. 取得したHTTPレスポンスオブジェクトをリターンして終了する

**[例外処理]**

3a. 後続ハンドラ処理中のエラーは再送出して終了する

<details>
<summary>keywords</summary>

nablarch_jsUnsupported, nablarch_uri_override, nablarch_sumit, nablarch_sumbit, リクエストパス書き換え, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しない。携帯対応を行うリクエストパスの範囲を限定するため、通常は [RequestHandlerEntry](handlers-RequestHandlerEntry.md) と組み合わせて使用する。

**設定例** (サーブレットコンテキストからの相対パス `/action/mobile/` 配下のアクセスに本ハンドラを適用):

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

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, requestPattern, リクエストパス制限, 携帯対応ハンドラ設定例

</details>
