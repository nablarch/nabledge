# 入出力ファイルの各項目の項目IDは、対応するテーブルのカラム名と一致させたほうが良いのでしょうか？

## 項目IDとカラム物理名の一致について

> **推奨**: 入出力ファイルの項目IDはテーブルのカラム物理名と一致させること。一致させると実装時の負荷を軽減できる。

`SqlRow`（DBの結果レコード）と`DataRecord`（ファイルのレコード）は、大文字・小文字・アンダースコアの有無を区別しない仕様のため、以下のような対応が可能。

| 項目名 | カラム物理名 | ファイルの項目ID |
|---|---|---|
| ユーザID | USER_ID | userId |
| 漢字名称 | KANJI_NAME | kanjiName |
| カナ名称 | KANA_NAME | kanaName |
| 電話番号 | TEL_NO | telNo |

ただし、ファイルのレイアウトはテーブルのように正規化されていないため、テーブルのカラム名1に対してファイルの項目が複数となる場合はカラム物理名と一致させることができない。

**カラム物理名と一致させた場合**: `SqlRow`をそのままファイル出力可能。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext context) {
    FileRecordWriterHolder.write("data", inputData, "ファイルID");
    return new Success();
}
```

**カラム物理名と一致させなかった場合**: ファイル出力用のMapを生成し、値の詰め直しが必要。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext context) {
    Map<String, Object> outputData = new HashMap<String, Object>();
    outputData.put("userId", inputData.get("id"));
    outputData.put("kanjiName", inputData.get("name"));
    outputData.put("kanaName", inputData.get("kana_name"));
    outputData.put("telNo", inputData.get("tel"));
    FileRecordWriterHolder.write("data", outputData, "ファイルID");
    return new Success();
}
```

<details>
<summary>keywords</summary>

SqlRow, DataRecord, FileRecordWriterHolder, ExecutionContext, Success, HashMap, 項目ID設計, カラム物理名一致, ファイルレコード, 大文字小文字区別なし, 実装負荷軽減

</details>
