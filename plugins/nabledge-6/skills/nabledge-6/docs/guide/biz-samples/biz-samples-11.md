# メッセージング基盤テストシミュレータサンプル

**公式ドキュメント**: [メッセージング基盤テストシミュレータサンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/11/index.html)

## 用途

> **重要**: 本サンプルではMOMとしてIBM MQ 9.3を使用。IBM MQ 9.3はJava 8以上がサポート対象のため、本サンプルではJava 17を使用する。

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-messaging-simulator)

**疎通テスト**: テスト環境構築後のNablarchフレームワーク・ミドルウェア・ハードウェアの設定確認のための簡易的な対向先システムとして使用できる。

**結合テスト**: システム間通信の擬似的な対向先システムとして使用できる。シミュレータに要求電文/応答電文として使用するデータを設定することで、シナリオを用いたテストができる。シミュレータを使用したテストではOSやミドルウェアも含めた動作を確認できる点が取引単体テストと異なる。

**負荷テスト**: 大量のメッセージ送受信が可能。

<details>
<summary>keywords</summary>

疎通テスト, 結合テスト, 負荷テスト, テスト対向先システム, メッセージングシミュレータ, MOMメッセージング, HTTPメッセージング, IBM MQ

</details>

## 特徴

- 取引単体テストと同じ手順でテストデータを作成できるため、追加の学習コストが発生しない。
- カスタマイズにより特殊・複雑なテストケースに対応可能（メッセージ受信時）:
  - 要求電文の内容に応じて応答電文の内容を動的に変更するテスト
  - 意図的な応答遅延によるタイムアウト発生等の異常系テスト
- マルチスレッドで要求電文を送信可能（メッセージ送信時）: 大量メッセージ送信の負荷テストが可能。

<details>
<summary>keywords</summary>

テストデータ作成, マルチスレッド送信, 動的レスポンス切り替え, 異常系テスト, タイムアウトテスト

</details>

## 要求

### シミュレータがメッセージ受信する場合

- HTTPメッセージ受信、MOM同期応答メッセージ受信用の応答電文を送信できる。
- 要求電文のログを出力できる。
- 任意のHTTPステータスコードを返却できる。
- シミュレータへの要求順序にあわせた応答電文を送信可能（単体テスト時と同様、Excelファイルに記述された内容を上から順に返却する）。

### シミュレータがメッセージ送信する場合

- HTTPメッセージ送信、MOM同期応答メッセージ送信、MOM応答不要メッセージ送信用の要求電文を送信できる。
- 指定回数、同じ電文を送信する。
- 応答電文のログを出力できる。
- Excelファイルに記述された内容を順に送信できる。

<details>
<summary>keywords</summary>

メッセージ受信, メッセージ送信, HTTPステータスコード, 応答電文, 要求電文, ログ出力, Excelファイル, 送信回数指定

</details>

## 使用方法

### シミュレータの取得

```bash
git clone https://github.com/nablarch/nablarch-biz-sample-all.git
```

### 実行モジュールの作成

`nablarch-messaging-simulator/target/build` 配下に実行モジュールを作成する。

```bat
cd nablarch-messaging-simulator/
mvn clean dependency:copy-dependencies -DoutputDirectory=target/build/lib package
```

### シミュレータの起動

実行モジュールに含まれる以下のbatファイルを実行する。

| 種別 | batファイル |
|---|---|
| HTTPメッセージ受信 | http-incoming-startup.bat |
| HTTPメッセージ送信 | http-outgoing-startup.bat |
| MOMメッセージ受信 | mom-incoming-startup.bat |
| MOMメッセージ送信 | mom-outgoing-startup.bat |

<details>
<summary>keywords</summary>

シミュレータ起動, ビルド手順, http-incoming-startup.bat, mom-incoming-startup.bat, mvn, git clone

</details>

## 拡張例

### リクエスト送信回数の指定（メッセージ送信時）

デフォルトはCSVの行数分のリクエストを送信。`-sendCount` オプションで送信回数を指定できる。

```bat
java <省略> nablarch.fw.launcher.Main <省略> -sendCount 10000
```

### リクエストの種類に応じたレスポンス切り替え（メッセージ受信時）

アクションクラスの `getRequestId` メソッドを修正してレスポンスを切り替える。

```java
public class HttpIncomingSimulateAction implements Handler<HttpRequest, HttpResponse> {
    protected String getRequestId(HttpRequest request) {
        // リクエストURIをもとに、レスポンスのリクエストIDを切り替える。
        return request.getRequestUri().endsWith("RM11AC0101") ? "RM11AC0201" : "RM11AC0202";
    }
}
```

> **補足**: MOMメッセージ受信時にレスポンスを切り替えたい場合も、同様に `getRequestId` メソッドを修正する。

### 意図的なレスポンス遅延（メッセージ受信時）

アクションクラスの `handle` メソッドに遅延処理を実装する。

```java
public class HttpIncomingSimulateAction implements Handler<HttpRequest, HttpResponse> {
    public HttpResponse handle(HttpRequest request, ExecutionContext context) {
        try {
            // 10秒遅延させる
            TimeUnit.SECONDS.sleep(10);
        } catch (InterruptedException e) {
            // 例外処理
        }
        // 省略
    }
}
```

<details>
<summary>keywords</summary>

HttpIncomingSimulateAction, getRequestId, sendCount, レスポンス遅延, リクエスト送信回数, nablarch.fw.launcher.Main, HttpRequest, HttpResponse, ExecutionContext, TimeUnit

</details>
