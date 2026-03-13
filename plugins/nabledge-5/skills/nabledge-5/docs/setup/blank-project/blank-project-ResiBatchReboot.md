# テーブルをキューとして使ったメッセージングを再び起動したい場合にすること

**公式ドキュメント**: [テーブルをキューとして使ったメッセージングを再び起動したい場合にすること](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/firstStep_appendix/ResiBatchReboot.html)

## テーブルをキューとして使ったメッセージングの再起動手順

テーブルをキューとして使ったメッセージングを一旦終了した後に再起動する場合、処理対象データの処理済みフラグを再設定する必要がある。

以下の手順でH2データベースのデータを再設定する：

1. 生成したバッチプロジェクトに含まれる `h2/bin/h2.bat` を実行する。

> **補足**: 必ず生成したバッチプロジェクトに含まれるh2.batを起動すること。

2. ブラウザが起動したら以下の接続情報を入力し、[Test Connection]をクリックする：

| 項目 | 値 | 補足 |
|---|---|---|
| JDBC URL | `jdbc:h2:../db/SAMPLE` | h2.batからの相対パスでデータファイルの位置を指定 |
| User Name | `SAMPLE` | |
| Password | `SAMPLE` | |

3. 画面下部に「Test successful」と表示されることを確認する。

4. Passwordを再入力し、[Connect]をクリックする。

> **重要**: [Connect]クリック時に指定したURLにH2データファイルが存在しない場合、H2データファイルが新規生成される。トラブルを避けるために、必ず[Test Connection]でデータファイルの存在を確認すること。

5. 右側のペインの上部にあるSQL入力スペースに以下のSQLを入力する：

```sql
DELETE FROM SAMPLE_USER WHERE USER_INFO_ID = '00000000000000000001';

INSERT INTO SAMPLE_USER(
  USER_INFO_ID
  , LOGIN_ID
  , KANA_NAME
  , KANJI_NAME
  , STATUS
) VALUES (
  '00000000000000000001'
  , 'tarou'
  , 'たろう'
  , '太郎'
  , '0' -- 0: 未処理
);

COMMIT;
```

> **補足**: 上記SQLはSAMPLE_USERテーブルの処理対象レコードのSTATUSを「未処理」（`'0'`）に設定する。

6. 画面上部の[Run]ボタン（緑色）をクリックして実行する。

7. 左上のdisconnectボタン（赤色アイコン）をクリックして切断する。

> **重要**: アーキタイプから生成したプロジェクトはH2の組み込みモードを使用している。組み込みモードは1プロセスからのみ接続を受け付けるため、**切断を忘れるとアプリケーションからH2に接続できなくなる**。

<details>
<summary>keywords</summary>

テーブルをキューとして使ったメッセージング, 処理済みフラグ再設定, H2データベース接続, SAMPLE_USER, 再起動手順, 組み込みモード切断

</details>
