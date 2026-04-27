# 入出力ファイルの各項目の項目IDは、対応するテーブルのカラム名と一致させたほうが良いのでしょうか？

> **question:**
> 入出力ファイルのインタフェース設計時に定義する各項目の項目IDは、
> 対応するテーブルのカラム物理名と一致させる必要はあるのでしょうか？

> **answer:**
> 項目IDは、テーブルのカラム物理名と一致させると実装時の負荷を軽減することができます。
> このため、テーブルのカラム物理名と一致させることを推奨します。

> なお、Nablarchのデータベースの結果レコードを表すSqlRowや、ファイルのレコードを表すDataRecordは、
> 大文字、小文字、アンダースコアの有無を区別しない仕様のため、以下のように定義することができます。

> 以下に例を示します。

> | > 項目名 | > カラム物理名 | > ファイルの項目ID |
> |---|---|---|
> | > ユーザID | > USER_ID | > userId |
> | > 漢字名称 | > KANJI_NAME | > kanjiName |
> | > カナ名称 | > KANA_NAME | > kanaName |
> | > 電話番号 | > TEL_NO | > telNo |

> ただし、ファイルのレイアウトはテーブルのように正規化されているわけではないので、
> テーブルのカラム名1に対して、ファイルの項目が複数となる場合があります。
> このようなケースでは、テーブルのカラム物理名とは一致させることはできません。

> ファイル出力を例に、項目IDをカラム物理名と一致させた場合と一致させなかった場合の実装の違いを示します。

> * >   カラム物理名と一致させた場合

>   ```java
>   @Override
>   public Result handle(SqlRow inputData, ExecutionContext context) {
>       // データベースから取得したinputDataをそのままファイル出力することが出来る。
>       FileRecordWriterHolder.write("data", inputData, "ファイルID");
>       return new Success();
>   }
>   ```
> * >   カラム物理名と一致させなかった場合

>   ```java
>   @Override
>   public Result handle(SqlRow inputData, ExecutionContext context) {
>       // ファイル出力用のMapを生成し、値の詰め直しを行う必要があります。
>       Map<String, Object> outputData = new HashMap<String, Object>();
>       outputData.put("userId", inputData.get("id"));
>       outputData.put("kanjiName", inputData.get("name"));
>       outputData.put("kanaName", inputData.get("kana_name"));
>       outputData.put("telNo", inputData.get("tel"));
>       FileRecordWriterHolder.write("data", outputData, "ファイルID");
>       return new Success();
>   }
>   ```
