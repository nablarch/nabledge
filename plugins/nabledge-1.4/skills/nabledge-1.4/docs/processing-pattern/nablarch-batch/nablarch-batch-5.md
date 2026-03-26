# バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください

## バッチアプリケーションのコマンドライン起動方法

コマンドプロンプト/ターミナルからバッチアプリケーションを起動する場合、以下のJavaコマンドを使用する。

**クラス**: `nablarch.fw.launcher.Main`

```sh
java -classpath %CLASSPATH% nablarch.fw.launcher.Main -diConfig %diConfig% -requestPath %requestPath% -userId %userId% %batchArgs%
```

| 引数 | 説明 |
|---|---|
| `-classpath %CLASSPATH%` | Eclipseでプロダクションコードに設定しているクラスパス |
| `-diConfig %diConfig%` | コンポーネント定義ファイルのルートファイル名。都度起動バッチ: `batch-component-configuration.xml`、常駐バッチ: `resident-batch-component-configuration.xml` |
| `-requestPath %requestPath%` | リクエストパス（自動テストの `LIST_MAP=testShots` の `requestPath` カラムの値） |
| `-userId %userId%` | ユーザID（`LIST_MAP=testShots` の `userId` カラムの値） |
| `%batchArgs%` | バッチアプリケーションで必要な引数やオプション |

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, バッチアプリケーション起動, コマンドライン起動, Javaコマンド, クラスパス設定, diConfig, requestPath, userId, batchArgs, コンポーネント定義ファイル

</details>
