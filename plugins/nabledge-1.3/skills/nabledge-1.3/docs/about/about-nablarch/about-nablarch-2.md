# configファイルの設定値の取得方法を教えてください

> **question:**
> configファイルに設定している値の取得方法を教えて下さい。
> また、configファイルには非アスキー文字（マルチバイト文字など）は、そのまま設定することは可能でしょうか？
> Javaのpropertyファイルのように、設定しなければいけないのかが知りたいです。

> **answer:**
> configファイルの値は、 *SystemRepository* クラスの *getString* メソッドを使用して取得してください。
> 非アスキー文字ですが、propertyファイルのようにユニコードで設定する必要はありません。

> 詳細は、以下の参照してください。

> * >   SystemRepositoryのJavaDoc
> * >   **[Nablarch Application Framework解説書]** -> **[NAF基盤ライブラリ]** -> **[リポジトリ]** -> **[環境設定ファイル記述ルール]**
