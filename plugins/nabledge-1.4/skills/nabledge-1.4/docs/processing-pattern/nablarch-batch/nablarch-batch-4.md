# 入出力ファイルの各項目の項目IDは、対応するテーブルのカラム名と一致させたほうが良いのでしょうか？

## ファイル項目IDとカラム物理名の一致推奨

ファイルの項目IDはテーブルのカラム物理名と一致させることを推奨。一致させると実装時の負荷を軽減できる。

Nablarchの`SqlRow`（DBの結果レコード）および`DataRecord`（ファイルのレコード）は、大文字・小文字・アンダースコアの有無を区別しない仕様のため、以下のような対応が可能:

| 項目名 | カラム物理名 | ファイルの項目ID |
|---|---|---|
| ユーザID | USER_ID | userId |
| 漢字名称 | KANJI_NAME | kanjiName |
| カナ名称 | KANA_NAME | kanaName |
| 電話番号 | TEL_NO | telNo |

ただし、テーブルの1カラムに対してファイルの項目が複数となる場合は一致させることができない。

**カラム物理名と一致させた場合**: `SqlRow`をそのままファイル出力可能。

```java
@Override
public Result handle(SqlRow inputData, ExecutionContext context) {
    FileRecordWriterHolder.write("data", inputData, "ファイルID");
    return new Success();
}
```

**カラム物理名と一致させなかった場合**: ファイル出力用の`Map`（`HashMap`）を生成し、値の詰め直しが必要。

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

SqlRow, DataRecord, FileRecordWriterHolder, ExecutionContext, Result, Success, HashMap, Map, 項目ID, カラム物理名, ファイルレイアウト設計, バッチ入出力ファイル

</details>
