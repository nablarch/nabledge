# リクエスト単体テストの実施方法(ファイルアップロード)

**公式ドキュメント**: [リクエスト単体テストの実施方法(ファイルアップロード)](https://nablarch.github.io/docs/LATEST/doc/development_tools/testing_framework/guide/development_guide/05_UnitTestGuide/02_RequestUnitTest/fileupload.html)

## アップロードファイルの記述方法

ファイルアップロードのテストはウェブアプリケーションのテストの一種であり、実施にはウェブアプリケーションのテスト設定が前提となる。

HTTPリクエストパラメータの値に `${attach:ファイルパス}` を記述することで、アップロードファイルを指定できる。

> **補足**: ファイルパスはテスト実行時のカレントディレクトリ（プロジェクトルートディレクトリ）からの相対パスで記述する。

<details>
<summary>keywords</summary>

ファイルアップロード, アップロードファイル指定, HTTPリクエストパラメータ, attachパラメータ, ${attach:ファイルパス}, ウェブアプリケーションテスト前提, ファイルアップロードテスト前提条件

</details>

## バイナリファイルの場合

バイナリファイル（画像等）をアップロードする場合は、事前にファイルを配置しておき、そのパスを `${attach:パス}` で指定する。

テストデータ例（`LIST_MAP=requestParams`）:

| uploadfile | comment | public |
|---|---|---|
| `${attach:test/resources/images/picture.png}` | アップロードします。 | `false` |

<details>
<summary>keywords</summary>

バイナリファイルアップロード, 画像ファイルアップロード, LIST_MAP, requestParams, ${attach:��ス}

</details>

## 固定長ファイル、CSVファイルの場合

:ref:`固定長ファイル<how_to_setup_fixed_length_file>` や :ref:`CSVファイル<how_to_setup_csv_file>` をアップロードする場合、ファイル内容をテストデータシートに記載する。テスト実行時に自動テストフレームワークがこのデータを元にファイルを作成する。

> **補足**: 事前にファイルを用意しておくことも可能だが、テストデータの保守容易性を考慮するとテストデータシートに記載すべきである。

テストデータ例:

`LIST_MAP=requestParams`

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv` ディレクティブ:

| 項目 | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

データ:

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

<details>
<summary>keywords</summary>

固定長ファイルアップロード, CSVファイルアップロード, SETUP_FIXED, テストデータシート, how_to_setup_fixed_length_file, how_to_setup_csv_file, 自動ファイル生成, LIST_MAP, requestParams

</details>
