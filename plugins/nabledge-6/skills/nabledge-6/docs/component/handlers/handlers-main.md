# 共通起動ランチャ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/main.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/CommandLine.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/Main.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingLogFormatter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Request.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html)

## ハンドラクラス名

スタンドアロンで起動するアプリケーションの起点となるハンドラ。javaコマンドから直接起動し、システムリポジトリを初期化してハンドラキューを実行する。

**クラス**: `nablarch.fw.launcher.Main`

処理の流れ:
1. コマンドライン引数のパース（`CommandLine`）
2. 起動ログの出力（`LauncherLogFormatter#getStartLogFormat`）
3. システムリポジトリの初期化
4. 実行コンテキストの初期化（`Main#setupExecutionContext`）
5. アプリケーション設定ログの出力（`ApplicationSettingLogFormatter`）
6. ハンドラキューの実行
7. 例外及びエラーに応じたログの出力
8. 終了ログの出力（`LauncherLogFormatter#getEndLogFormat`）

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, Main, CommandLine, LauncherLogFormatter, ApplicationSettingLogFormatter, スタンドアロン起動, ハンドラキュー実行, システムリポジトリ初期化, 起動ランチャ, setupExecutionContext, 実行コンテキスト初期化, getStartLogFormat, getEndLogFormat

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw-standalone, com.nablarch.framework, モジュール依存関係, Maven

</details>

## アプリケーションを起動する

`Mainクラス` をjavaコマンドで起動する。以下の3オプションは必須で、いずれか欠けると即時異常終了する（終了コード = 127）。

| オプション | 説明 |
|---|---|
| `-diConfig` | システムリポジトリの設定ファイルパスを指定。このパスでシステムリポジトリを初期化する。 |
| `-requestPath` | 書式: `実行するアクションのクラス名/リクエストID`。`Request#getRequestPath` が返す値となる。 |
| `-userId` | ユーザID。セッションコンテキスト変数に `user.id` として格納される。 |

```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./batch-config.xml \
  -requestPath admin.DataUnloadBatchAction/BC0012 \
  -userId testUser
```

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, -diConfig, -requestPath, -userId, アプリケーション起動, 起動オプション, 異常終了, 終了コード127, user.id, Request#getRequestPath

</details>

## アプリケーション起動に任意のオプションを設定する

任意のオプションパラメータをオプション名称と値のペアで指定できる。

```bash
java nablarch.fw.launcher.Main \
  -optionName optionValue
```

`ExecutionContext` の `getSessionScopedVar` でオプション名称を指定して値を取得する。

```java
public Result handle(String inputData, ExecutionContext ctx) {
  final String value = ctx.getSessionScopedVar("optionName");
  return new Result.Success();
}
```

<details>
<summary>keywords</summary>

ExecutionContext, nablarch.fw.ExecutionContext, getSessionScopedVar, 任意オプションパラメータ, セッションコンテキスト変数取得, Result, Result.Success

</details>

## 例外及びエラーに応じた処理内容

捕捉した例外・エラーの種類に応じて以下の処理を行う。

| 例外クラス | 処理内容 |
|---|---|
| `Result.Error`（サブクラス含む） | FATALレベルのログ出力後、ステータスコードが0〜127の場合はそのまま返し、それ以外は127を返す。 |
| 上記以外の例外クラス | FATALレベルのログ出力後、127を返す。 |

<details>
<summary>keywords</summary>

Result.Error, nablarch.fw.Result.Error, 例外処理, エラー処理, 終了コード127, FATALログ

</details>
