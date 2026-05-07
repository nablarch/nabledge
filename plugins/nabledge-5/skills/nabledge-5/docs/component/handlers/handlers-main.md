# 共通起動ランチャ

**目次**

* ハンドラクラス名
* モジュール一覧
* アプリケーションを起動する
* アプリケーション起動に任意のオプションを設定する
* 例外及びエラーに応じた処理内容

スタンドアロンで起動するアプリケーションの起点となるハンドラ。

javaコマンドから直接起動することで、システムリポジトリの初期化を行い、そこに定義されたハンドラキューを実行させることができる。

本ハンドラでは、以下の処理を行う。
処理の詳細は、カッコ内のJavadocを参照。

* コマンドライン引数のパース( CommandLine )
* 起動ログの出力( LauncherLogFormatter#getStartLogFormat )
* システムリポジトリの初期化
* 実行コンテキストの初期化( Main#setupExecutionContext )
* アプリケーション設定ログの出力( ApplicationSettingLogFormatter )
* ハンドラキューの実行
* 例外及びエラーに応じたログの出力
* 終了ログの出力( LauncherLogFormatter#getEndLogFormat )

処理の流れは以下のとおり。

![Main_flow.png](../../../knowledge/assets/handlers-main/Main_flow.png)

## ハンドラクラス名

* nablarch.fw.launcher.Main

## モジュール一覧

```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-standalone</artifactId>
</dependency>
```

## アプリケーションを起動する

javaコマンドで Mainクラス を指定してアプリケーションを起動する。

フレームワークの動作に必要となる以下の3つのオプションは、必ず指定する必要がある。
以下のオプションのうちいずれかが欠けていた場合は、即座に異常終了する。(終了コード = 127)

-diConfig

システムリポジトリの設定ファイルのパスを指定する。
このオプションで指定されたパスを使ってシステムリポジトリを初期化する。

-requestPath

実行するアクションとリクエストIDを指定する。

以下の書式で定義される文字列を設定する。

```bash
実行するアクションのクラス名/リクエストID
```

このオプションで指定されたリクエストパスを
Request#getRequestPath
が返すようになる。

-userId

ユーザIDを設定する。
この値はセッションコンテキスト変数に `user.id` という名前で格納される。

以下に実行例を示す。

```bash
java nablarch.fw.launcher.Main \
  -diConfig file:./batch-config.xml \
  -requestPath admin.DataUnloadBatchAction/BC0012 \
  -userId testUser
```

## アプリケーション起動に任意のオプションを設定する

Mainクラス 起動時に、任意のオプションパラメータを指定することが出来る。

オプションパラメータは、「オプション名称」と「オプションの値」のペアで設定する。

例えば、オプション名称が `optionName` で 値が `optionValue` の場合は、以下のように指定する。

```bash
java nablarch.fw.launcher.Main \
  -optionName optionValue
```

アプリケーションでオプションを使用する場合は、 ExecutionContext から取得する。

```java
 @Override
public Result handle(String inputData, ExecutionContext ctx) {
  // getSessionScopedVarにオプション名称を指定して、値を取得する。
  final String value = ctx.getSessionScopedVar("optionName");

  // 処理

  return new Result.Success();
}
```

> **Tip:**
> アプリケーション起動時に必ず指定する必要があるオプションは、 [アプリケーションを起動する](../../component/handlers/handlers-main.md#main-run-application) を参照

## 例外及びエラーに応じた処理内容

このハンドラでは捕捉した例外及びエラーの内容に応じて、以下の処理と結果を返す。

| 例外クラス | 処理内容 |
|---|---|
| Result.Error  (サブクラス含む) | FATALレベルのログ出力を行う。  ログ出力後、ハンドラの処理結果として、以下の値を返す。  ステータスコードが0～127の場合  ステータスコードをそのまま返す。  ステータスコードが0～127以外の場合  127を返す。 |
| 上記以外の例外クラス | FATALレベルのログ出力を行う。  ログ出力後、ハンドラの処理結果として、127を返す。 |
