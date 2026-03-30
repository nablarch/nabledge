# configファイルの設定値の取得方法を教えてください

## configファイルの設定値の取得方法

configファイルの値は`SystemRepository`クラスの`getString`メソッドで取得する。

非ASCII文字（マルチバイト文字など）はPropertyファイルのようにUnicode表記にする必要はなく、そのまま設定できる。

<details>
<summary>keywords</summary>

SystemRepository, getString, configファイル設定値取得, 非ASCII文字設定, マルチバイト文字, Unicodeエスケープ不要

</details>
