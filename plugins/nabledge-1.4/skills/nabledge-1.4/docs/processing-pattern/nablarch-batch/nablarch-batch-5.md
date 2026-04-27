# バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください

> **question:**
> バッチアプリケーションを自動テスト以外の方法で起動する方法を教えてください。
> 起動時に必要なJava起動オプションやプログラム引数などもあわせて教えてください。

> **answer:**
> コマンドプロンプトやターミナル等のコンソールから起動する場合には、Javaコマンドを使用して以下のように起動します。

> ```sh
> java -classpath %CLASSPATH% nablarch.fw.launcher.Main -diConfig %diConfig% -requestPath %requestPath% -userId %userId% %batchArgs%
> 
> # %CLASSPATH% -> Eclipseでプロダクションコードに設定しているクラスパスを設定します。
> # %diConfig% -> コンポーネント定義ファイルのルートファイル名を設定します。
> #               Nablarch Samapleプロジェクトの場合には、以下の構成となっています。
> #               都度起動バッチ:batch-component-configuration.xml
> #               常駐バッチ:resident-batch-component-configuration.xml
> # %requestPath% -> リクエストパスを設定します。(自動テストの「LIST_MAP=testShots」の「requestPath」カラムに設定した文字列となります)
> # %userId% -> ユーザIDを設定します。(「LIST_MAP=testShots」の「userId」カラムに設定した文字列となります)
> # %batchArgs% -> バッチアプリケーションで必要となる引数やオプションを設定してください。
> ```
