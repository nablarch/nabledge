# テーブルをキューとして使ったメッセージングを再び起動したい場合にすること

**公式ドキュメント**: [テーブルをキューとして使ったメッセージングを再び起動したい場合にすること](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/firstStep_appendix/ResiBatchReboot.html)

## 概要

テーブルをキューとして使ったメッセージングを一端終了した後に再び起動させたい場合、処理対象データの処理済みフラグを再設定する必要がある。

<details>
<summary>keywords</summary>

テーブルをキューとして使ったメッセージング, 処理済みフラグ, 再起動, 再設定

</details>

## 手順

1. `h2/bin/h2.bat`を実行する。

> **補足**: 必ず生成したバッチプロジェクトに含まれるh2.batを起動すること。

2. ブラウザが起動したら、以下の通りに入力し、[Test Connection]ボタンをクリックする。

| 項目 | 値 | 補足 |
|---|---|---|
| JDBC URL | `jdbc:h2:../db/SAMPLE` | h2.batからの相対パスでデータファイルの位置を指定する必要がある |
| User Name | `SAMPLE` | |
| Password | `SAMPLE` | |

3. 画面下部に「Test successful」と表示されていることを確認する。

4. Password欄を再び入力し、[Connect]ボタンをクリックする。

> **重要**: [Connect]ボタンクリック時に、指定したURLにH2のデータファイルが存在しない場合、H2のデータファイルが新規生成される。トラブルを避けるために、必ず[Test Connection]をクリックして、データファイルの存在を確認すること。

5. 右側のペインの上部のSQL入力スペースに以下のSQLを入力する。

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

> **補足**: 上記SQLは、テーブルをキューとして使ったメッセージングの処理対象レコードの状態を「未処理」に設定している。

6. 画面上部の[Run]ボタン（緑色のボタン）をクリックする。

7. 左上のdisconnectボタン（赤色のアイコン）をクリックして切断する。

> **重要**: アーキタイプから生成したプロジェクトはH2の組み込みモードを使用している。組み込みモード使用時は、1プロセスからのみ接続を受け付ける。そのため、**切断を忘れると、アプリケーションからH2に接続できなくなる。**

<details>
<summary>keywords</summary>

H2データベース, SAMPLE_USER, h2.bat, 組み込みモード, 未処理状態リセット, JDBC URL, Test Connection

</details>
