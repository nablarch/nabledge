# configファイルの設定値の取得方法を教えてください

## configファイルの設定値の取得方法

configファイルの値は `SystemRepository` クラスの `getString` メソッドで取得する。

非アスキー文字（マルチバイト文字）はJavaのpropertyファイルのようにユニコードエスケープする必要はなく、そのまま設定できる。

<details>
<summary>keywords</summary>

SystemRepository, getString, configファイル取得, 非アスキー文字, マルチバイト文字, システムリポジトリ, 環境設定ファイル

</details>
