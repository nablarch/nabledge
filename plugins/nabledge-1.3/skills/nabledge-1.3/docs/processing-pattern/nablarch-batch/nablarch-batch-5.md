# バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください

## コンソールからのバッチ起動方法

コンソール（コマンドプロンプト/ターミナル）からJavaコマンドで起動する。

```sh
java -classpath %CLASSPATH% nablarch.fw.launcher.Main -diConfig %diConfig% -requestPath %requestPath% -userId %userId% %batchArgs%
```

| 引数 | 設定値 |
|---|---|
| `-classpath %CLASSPATH%` | Eclipseでプロダクションコードに設定しているクラスパス |
| `-diConfig %diConfig%` | コンポーネント定義ファイルのルートファイル名。Nablarch Sampleプロジェクトの場合: 都度起動バッチ: `batch-component-configuration.xml` / 常駐バッチ: `resident-batch-component-configuration.xml` |
| `-requestPath %requestPath%` | リクエストパス（自動テストの`LIST_MAP=testShots`の`requestPath`カラムの値） |
| `-userId %userId%` | ユーザID（自動テストの`LIST_MAP=testShots`の`userId`カラムの値） |
| `%batchArgs%` | バッチアプリケーションで必要な引数・オプション |

<details>
<summary>keywords</summary>

nablarch.fw.launcher.Main, バッチ起動, コマンドライン起動, Java起動オプション, requestPath, diConfig, userId, batchArgs, 都度起動バッチ, 常駐バッチ

</details>
