# リクエスト単体テストの実施方法(ファイルアップロード)

## アップロードファイルの記述方法

ファイルアップロードのテストは、画面オンライン処理のテスト（[index](testing-framework-02_RequestUnitTest.md)）が前提となる。

HTTPリクエストパラメータにアップロードファイルを指定するには以下の記述を使用する。

```text
${attach:ファイルパス}
```

> **注意**: ファイルパスはテスト実行時のカレントディレクトリ（プロジェクトルートディレクトリ）からの相対パスで記述する。

<details>
<summary>keywords</summary>

${attach:ファイルパス}, ファイルアップロード, HTTPリクエストパラメータ, アップロードファイル指定, テスト実行カレントディレクトリ, 相対パス

</details>

## バイナリファイルの場合

バイナリファイル（画像等）をアップロードする場合は、事前にファイルを配置しておき、そのパスを指定する。

ディレクトリ構成例:

```
<project_root>
  + test
     + resources
        + images
           + picture.png
```

`LIST_MAP=requestParams`

| uploadfile | comment | public |
|---|---|---|
| `${attach:test/resources/images/picture.png}` | アップロードします。 | `false` |

<details>
<summary>keywords</summary>

バイナリファイル, 画像ファイル, ファイルアップロードテスト, LIST_MAP=requestParams, picture.png

</details>

## 固定長ファイル、CSVファイルの場合

:ref:`固定長ファイル<how_to_setup_fixed_length_file>` や :ref:`CSVファイル<how_to_setup_csv_file>` をアップロードする場合、ファイル内容をテストデータシートに記載する。テスト実行時に自動テストフレームワークがそのデータを元にファイルを作成する。

例: `work/member_list.csv` を作成してアップロード対象として指定する

`LIST_MAP=requestParams`

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv`

ディレクティブ:

```
text-encoding    Windows-31J
record-separator CRLF
```

データ:

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

> **注意**: 固定長ファイルやCSVファイルをアップロードする場合でも事前にファイルを用意することは可能だが、テストデータの保守容易性を考慮するとテストデータシートに記載すべきである。

<details>
<summary>keywords</summary>

SETUP_FIXED, CSVファイル, 固定長ファイル, テストデータシート, how_to_setup_fixed_length_file, how_to_setup_csv_file, member_list.csv, text-encoding, record-separator

</details>
