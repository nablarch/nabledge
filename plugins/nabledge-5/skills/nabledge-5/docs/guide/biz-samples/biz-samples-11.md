# メッセージング基盤テストシミュレータサンプル

**公式ドキュメント**: [メッセージング基盤テストシミュレータサンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/11/index.html)

## 用途

> **重要**: 本サンプルではMOMとしてIBM MQ 9.3 を使用。IBM MQ 9.3 はJava 8以上がサポート対象のため、本サンプルではJava 8を使用する。

[mom_system_messaging](../../component/libraries/libraries-mom_system_messaging.md)、[http_system_messaging](../../component/libraries/libraries-http_system_messaging.md) を使用するアプリケーションのテストで、対向先システムをシミュレートするサンプル実装を提供する。

- **疎通テスト**: テスト環境構築後のNablarchフレームワーク、ミドルウェア、ハードウェア等の設定確認用の簡易通信対向先として使用可能。
- **結合テスト**: システム間通信の擬似対向先として使用可能。Excelファイルで設定したシナリオによるテストができる。取引単体テストと異なり、OSやミドルウェアも含めた動作確認が可能。
- **負荷テスト**: 大量メッセージ送受信による負荷テストが可能。

<details>
<summary>keywords</summary>

疎通テスト, 結合テスト, 負荷テスト, メッセージングシミュレータ, mom_system_messaging, http_system_messaging, IBM MQ, Java 8, 対向先システム

</details>

## 特徴

**取引単体テストと同じ手順でテストデータ作成可能**: 余計な学習コストが発生しない。

**特殊・複雑なテストケースへの対応（メッセージ受信、カスタマイズが必要）**:
- 要求電文の内容に応じて応答電文の内容を動的に変更するテスト
- 意図的な応答遅延によるタイムアウト等の異常系テスト

**マルチスレッドで要求電文送信可能（メッセージ送信）**: Nablarchのマルチスレッド実行制御ハンドラを使用。大量メッセージの負荷テストが可能。

<details>
<summary>keywords</summary>

テストデータ作成, マルチスレッド, 異常系テスト, タイムアウトテスト, メッセージ受信, メッセージ送信, 取引単体テスト, カスタマイズ

</details>

## 要求

### メッセージ受信時の機能

- HTTPメッセージ受信・MOM同期応答メッセージ受信用の応答電文を送信できる。
- 要求電文のログを出力できる。
- 任意のHTTPステータスコードを返却できる。
- シミュレータへの要求順序にあわせた応答電文を送信可能（Excelファイルに記述された内容を上から順に返却）。

### メッセージ送信時の機能

- HTTPメッセージ送信・MOM同期応答メッセージ送信・MOM応答不要メッセージ送信用の要求電文を送信できる。
- 指定回数、同じ電文を送信する。
- 応答電文のログを出力できる。
- Excelファイルに記述された内容を順に送信できる。

<details>
<summary>keywords</summary>

HTTPメッセージ受信, MOM同期応答メッセージ受信, HTTPステータスコード, 応答電文, 要求電文, ログ出力, Excelファイル, シナリオ, MOM応答不要メッセージ送信

</details>

## 使用方法

本サンプルは、利用者が目的とするテストを実施するためにJavaファイル等をカスタマイズすることを想定しているため、バイナリではなくソースコードや設定ファイルの形で提供されている。そのため、シミュレータを使用するには以下の手順でビルドを実行し、実行モジュールを作成する必要がある。

1. シミュレータのソースコードを取得する:

```bash
git clone https://github.com/nablarch/nablarch-messaging-simulator.git
```

2. `target/build` 配下に実行モジュールを作成し、実行環境に配置する:

```bat
mvn clean dependency:copy-dependencies -DoutputDirectory=target/build/lib package
```

3. 以下のbatファイルを実行してシミュレータを起動する:

| 種別 | batファイル |
|---|---|
| HTTPメッセージ受信 | `http-incoming-startup.bat` |
| HTTPメッセージ送信 | `http-outgoing-startup.bat` |
| MOMメッセージ受信 | `mom-incoming-startup.bat` |
| MOMメッセージ送信 | `mom-outgoing-startup.bat` |

<details>
<summary>keywords</summary>

シミュレータ起動, http-incoming-startup.bat, http-outgoing-startup.bat, mom-incoming-startup.bat, mom-outgoing-startup.bat, 実行モジュール作成, Maven, nablarch-messaging-simulator, ビルド, ソースコード提供, カスタマイズ

</details>

## 拡張例

**リクエスト送信回数の指定（`sendCount`オプション）**: デフォルトはCSVファイルの行数分。同一データを繰り返し送信する場合に使用。

```bat
java <省略> nablarch.fw.launcher.Main <省略> -sendCount 10000
```

**リクエスト種類に応じたレスポンス切り替え（メッセージ受信）**: アクションクラスの `getRequestId` メソッドを修正する。HTTPとMOM共通。

```java
public class HttpIncomingSimulateAction implements Handler<HttpRequest, HttpResponse> {

    protected String getRequestId(HttpRequest request) {
        // リクエストURIをもとに、レスポンスのリクエストIDを切り替える。
        return request.getRequestUri().endsWith("RM11AC0101") ? "RM11AC0201" : "RM11AC0202";
    }
}
```

> **補足**: MOMメッセージ受信時のレスポンス切り替えも、HTTPと同様に `getRequestId` メソッドを修正する。

**意図的なレスポンス遅延（メッセージ受信）**: アクションクラスの `handle` メソッドに遅延処理を直接実装する。

```java
public class HttpIncomingSimulateAction implements Handler<HttpRequest, HttpResponse> {

    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        try {
            TimeUnit.SECONDS.sleep(10); // 10秒遅延
        } catch (InterruptedException e) {
            // 例外処理
        }
        // ...
    }
}
```

<details>
<summary>keywords</summary>

sendCount, getRequestId, HttpIncomingSimulateAction, レスポンス遅延, TimeUnit, リクエスト送信回数, レスポンス切り替え, handle, Handler, HttpRequest, HttpResponse, ExecutionContext

</details>
