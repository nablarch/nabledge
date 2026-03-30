# バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください

## バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください

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

nablarch.fw.launcher.Main, -classpath, %CLASSPATH%, -diConfig, -requestPath, -userId, %batchArgs%, バッチ起動, コマンドライン起動, Javaコマンド, 都度起動バッチ, 常駐バッチ, batch-component-configuration.xml, resident-batch-component-configuration.xml

</details>
