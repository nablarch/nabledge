# 共通起動ランチャ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/standalone/main.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/CommandLine.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/logging/LauncherLogFormatter.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/launcher/Main.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/core/log/app/ApplicationSettingLogFormatter.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/ExecutionContext.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Result.Error.html) [8](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Request.html)

## ハンドラクラス名

スタンドアロンアプリケーションの起点となるハンドラ。javaコマンドから直接起動し、システムリポジトリを初期化してハンドラキューを実行する。

**クラス名**: `nablarch.fw.launcher.Main`

処理の流れ:
1. コマンドライン引数のパース（`CommandLine`）
2. 起動ログの出力（`LauncherLogFormatter#getStartLogFormat`）
3. システムリポジトリの初期化
4. 実行コンテキストの初期化（`Main#setupExecutionContext`）
5. アプリケーション設定ログの出力（`ApplicationSettingLogFormatter`）
6. ハンドラキューの実行
7. 例外・エラーに応じたログの出力
8. 終了ログの出力（`LauncherLogFormatter#getEndLogFormat`）

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, Main, CommandLine, nablarch.fw.launcher.CommandLine, ApplicationSettingLogFormatter, nablarch.core.log.app.ApplicationSettingLogFormatter, LauncherLogFormatter, nablarch.fw.launcher.logging.LauncherLogFormatter, setupExecutionContext, 共通起動ランチャ, スタンドアロン起動, ハンドラキュー実行, システムリポジトリ初期化

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

javaコマンドで `Main` を起動する。以下の3オプションは必須（いずれかが欠けると即座に異常終了、終了コード=127）。

| オプション | 説明 |
|---|---|
| `-diConfig` | システムリポジトリ設定ファイルのパス |
| `-requestPath` | `実行アクションクラス名/リクエストID` 形式。`Request#getRequestPath` が返す値として設定される |
| `-userId` | ユーザID。セッションコンテキスト変数 `user.id` に格納 |

```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./batch-config.xml \
  -requestPath admin.DataUnloadBatchAction/BC0012 \
  -userId testUser
```

<details>
<summary>keywords</summary>

diConfig, requestPath, userId, アプリケーション起動, コマンドライン引数, 終了コード 127, nablarch.fw.launcher.Main, Request#getRequestPath, nablarch.fw.Request.getRequestPath, user.id, 必須オプション

</details>

## アプリケーション起動に任意のオプションを設定する

任意のオプションパラメータを「オプション名称」と「オプションの値」のペアで指定可能。

```bash
java nablarch.fw.launcher.Main \
  -optionName optionValue
```

アプリケーションでは `ExecutionContext` の `getSessionScopedVar` でオプション名称を指定して取得する。

```java
final String value = ctx.getSessionScopedVar("optionName");
```

> **補足**: 必須オプションは [main-run_application](#s2) を参照

<details>
<summary>keywords</summary>

getSessionScopedVar, ExecutionContext, nablarch.fw.ExecutionContext, オプションパラメータ, 任意オプション, セッションスコープ変数

</details>

## 例外及びエラーに応じた処理内容

| 例外クラス | 処理内容 |
|---|---|
| `Result.Error`（サブクラス含む） | FATALログ出力後、ステータスコードが0〜127の場合はそのまま返す。0〜127以外の場合は127を返す |
| 上記以外の例外クラス | FATALログ出力後、127を返す |

<details>
<summary>keywords</summary>

Result.Error, nablarch.fw.Result.Error, 例外ハンドリング, 終了コード 127, FATALログ, 異常終了

</details>
