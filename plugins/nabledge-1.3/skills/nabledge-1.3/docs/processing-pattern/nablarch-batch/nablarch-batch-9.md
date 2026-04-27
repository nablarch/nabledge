# 入力データが存在しないバッチ処理はどのように作成するのでしょうか？

> **question:**
> 業務日付更新処理や、一括開閉局制御処理のようにインプットデータが存在しないバッチ処理が存在します。
> このようなバッチ処理の場合はどのように実装したらいいのでしょうか？

> **answer:**
> *nablarch.fw.action.NoInputDataBatchAction* を継承してバッチアクションクラスを実装してください。
> *NoInputDataBatchAction* を継承した場合、*handle* メソッドが一度だけ実行されるので、
> *handle* メソッドに必要となる処理を実装してください。

> 実装方法が不明な場合は、Nablarch Sample Projectの以下クラスを参照してください。

> * >   nablarch.sample.ss99ZZ.B99ZZ011Action
