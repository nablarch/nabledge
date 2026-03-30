# 入出力ファイルの各項目の項目IDは、対応するテーブルのカラム名と一致させたほうが良いのでしょうか？

## ファイル項目IDとテーブルカラム物理名の一致推奨

## ファイル項目IDとテーブルカラム物理名の一致推奨

ファイルの項目IDはテーブルのカラム物理名と一致させることを推奨（実装時の負荷軽減のため）。

> **補足**: `SqlRow`（DBの結果レコード）と`DataRecord`（ファイルのレコード）は、大文字・小文字・アンダースコアの有無を区別しない仕様。カラム物理名 `USER_ID` → ファイル項目ID `userId` のように定義可能。

| 項目名 | カラム物理名 | ファイルの項目ID |
|---|---|---|
| ユーザID | USER_ID | userId |
| 漢字名称 | KANJI_NAME | kanjiName |
| カナ名称 | KANA_NAME | kanaName |
| 電話番号 | TEL_NO | telNo |

**カラム物理名と一致させた場合**: DBから取得した`SqlRow`をそのままファイル出力できる。

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

**例外**: ファイルのレイアウトはテーブルのように正規化されていないため、1つのカラムに対してファイルの項目が複数となる場合は、カラム物理名と一致させることはできない。

<details>
<summary>keywords</summary>

SqlRow, DataRecord, FileRecordWriterHolder, ExecutionContext, Success, HashMap, 項目ID設計, カラム物理名一致, ファイル出力, 値の詰め直し

</details>
