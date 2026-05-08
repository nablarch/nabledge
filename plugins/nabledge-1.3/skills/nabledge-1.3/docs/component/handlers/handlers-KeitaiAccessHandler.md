## 携帯端末アクセスハンドラ

**クラス名:** `nablarch.fw.web.handler.KeitaiAccessHandler`

-----

-----

### 概要

本ハンドラは携帯端末、特にいわゆる「フィーチャーフォン」からのアクセスを想定したページを出力するハンドラである。
具体的には以下の処理を行う。

* リクエストパラメータ中に埋め込まれた遷移先URIでリクエストパスを置換する。
  これにより、javascriptに対応していない携帯端末でも、サブミットボタン毎の遷移先切替、
  ウィンドウスコープの利用等が可能となる。
* javascript等の出力を抑制するフラグ(nablarch_jsUnsupported)をリクエストスコープ変数に設定する。
  (このフラグはJSP中の各カスタムライブラリで使用される。)

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPレスポンスハンドラ | nablarch.fw.web.handler.HttpResponseHandler | HttpRequest | HttpResponse | - | HTTPレスポンスの内容に沿ってレスポンス処理かサーブレットフォーワードのいずれかを行う。 | 既定のエラー画面をレスポンス後、例外を再送出する。ただしサーブレットフォーワード処理中にエラーが発生した場合はログ出力のみを行なう。 |
| 携帯対応ハンドラ | nablarch.fw.web.handler.KeitaiAccessHandler | HttpRequest | HttpResponse | - | - | - |
| スレッドコンテキスト変数設定ハンドラ(リクエストスレッド) | nablarch.common.handler.ThreadContextHandler_request | Object | Object | 前のループで設定されたスレッドコンテキスト変数をクリアするためここで再初期化する。 | - | - |
| Nablarchカスタムタグ制御ハンドラ | nablarch.common.web.handler.NablarchTagHandler | HttpRequest | HttpResponse | Nablarchカスタムタグの動作に必要な事前処理を実施する。 | - | - |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) | 本ハンドラでは、携帯端末向けにjavascriptを使用しないHTMLを出力させるフラグを設定 するため、 [HTTPレスポンスハンドラ](../../component/handlers/handlers-HttpResponseHandler.md) を本ハンドラの上位に配置しないと、 その設定がレスポンスに反映されない。 |
| [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) | 本ハンドラで書換えたリクエストパスの内容をもとに、 [スレッドコンテキスト](../../component/libraries/libraries-thread-context.md) 上のリクエストID属性 を決定するので、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md) は本ハンドラの後続に配置する必要が ある。 |
| [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-NablarchTagHandler.md) | 本ハンドラで設定したリクエストパラメータ **nablarch_sumbit** の値をもとに 改竄チェックやウィンドウスコープの展開等を行うので、 [Nablarchカスタムタグ制御ハンドラ](../../component/handlers/handlers-NablarchTagHandler.md) は、本ハンドラの後続に配置する必要がある。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (携帯対応画面出力フラグを設定)**

遷移先のJSPページでの javascript等の出力を抑制するフラグ変数 (**nablarch_jsUnsupported**)
をリクエストスコープに設定する。

**2. (リクエストパスに対する書き換え処理)**

リクエストパラメータ中に"nablarch_uri_override"で始まる名前のパラメータが
存在した場合、その内容を元に、リクエストパスを置換するとともに、リクエストパラメータ **nablarch_sumit**
の値を設定する。

**3. (後続ハンドラへの処理移譲)**

**2.** で書き換え処理を行ったHTTPリクエストオブジェクトを
後続ハンドラに渡して処理を委譲する。
その結果であるHTTPレスポンスオブジェクトを取得する。

**[復路での処理]**

**4. (正常終了)**

**3.** で取得したHTTPレスポンスオブジェクトをリターンして終了する。

**[例外処理]**

**3a. (後続ハンドラ処理中のエラー)**

後続ハンドラの処理中にエラーが発生した場合は、そのまま再送出して終了する。

### 設定項目・拡張ポイント

本ハンドラ自体に設定項目は存在しないが、
携帯対応を行うリクエストパスの範囲を限定するため、通常は [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md) と組み合わせて使用する。

**設定例**

この設定例では、サーブレットコンテキストからの相対パス "/action/mobile/" 配下のアクセスに対して
本ハンドラを動作させている。

```xml
<!-- 携帯対応ハンドラ -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action/mobile//"/>
  <property name="handler">
    <component class="nablarch.fw.web.handler.KeitaiAccessHandler" />
  </property>
</component>
```
