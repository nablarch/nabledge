# ユニバーサルDAOとJakarta Persistenceとの機能比較

この章では、以下の機能の比較を示す。

* [ユニバーサルDAO](../../component/libraries/libraries-universal-dao.md#ユニバーサルdao)
* <a href="https://jakarta.ee/specifications/persistence/" target="_blank">Jakarta Persistence(外部サイト、英語)</a>

> **Important:**
> ユニバーサルDAOでは、JPAで定義されているアノテーションのうち、 [Entityに使用できるJakarta Persistenceアノテーション](../../component/libraries/libraries-universal-dao.md#entityに使用できるjakarta-persistenceアノテーション) に記載のあるものだけをサポートしている。
> ここに記載のないアノテーションに関連する機能については、使用できない。

機能比較（○：提供あり　△：一部提供あり　×：提供なし　－:対象外）

| 機能 | ユニバーサルDAO | Jakarta Persistence |
|---|---|---|
| リレーションシップに対応できる | × [1] | ○ |
| Entityを元にCRUDが実行できる   SQLを作成することなくCRUDのSQLを実行できる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#sqlを書かなくても単純なcrudができる) | ○ |
| 検索結果をJava Beansオブジェクトとして取得できる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#検索結果をbeanにマッピングできる) | ○ |
| 任意のSQL文を実行できる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#任意のsqlsqlファイルで検索する) | ○ |
| SQLの動的組み立てができる | △ [2]   [解説書へ](../../component/libraries/libraries-universal-dao.md#任意のsqlsqlファイルで検索する) | ○ |
| バッチ実行ができる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#バッチ実行一括登録更新削除を行う) | × |
| 大量データを取得する際に遅延ロードができる   (ヒープを圧迫せずに大量データを処理できる) | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#検索結果を遅延ロードする) | × |
| ページング用の範囲指定の検索ができる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#ページングを行う) | ○ |
| サロゲートキーの値を採番できる | ○   [解説書へ](../../component/libraries/libraries-universal-dao.md#サロゲートキーを採番する) | ○ |
| Entityの状態をデータベースに反映時に   Jakarta Bean Validationが実行できる | × [3] | ○ |
| データベースアクセス前後に   任意の処理(コールバック呼び出し)を実行できる | × [4] | ○ |
| 排他制御ができる | △ [5]   [解説書へ(楽観ロック)](../../component/libraries/libraries-universal-dao.md#楽観的ロックを行う)   [解説書へ(悲観ロック)](../../component/libraries/libraries-universal-dao.md#悲観的ロックを行う) | ○ |

リレーションシップがあるテーブルの検索はSQLを作成することで対応できる。登録、更新、削除については、テーブル毎に必要な処理を呼び出すことで対応する。

ユニバーサルDAOでは、条件及びソート項目に限り動的な組み立てができる。詳細は、 [SQLの動的組み立て](../../component/libraries/libraries-database.md#実行時のbeanオブジェクトの状態を元にsql文を動的に構築できる) を参照

Nablarchでは、外部からのデータを受け付けたタイミングでバリデーションを実施し、バリデーションエラーがない場合のみEntityへ変換しデータベースへ保存する。

任意の処理が必要となる場合は、ユニバーサルDAOを呼び出す側で処理を行うことで対応する。

ユニバーサルDAOでは、楽観的ロックのみサポートする。悲観的ロックやJakarta Persistenceで定義されている検索時のロックモードの指定などはサポートしない。(悲観的ロックは、 `select for update` などを使用することで実現できる。)
