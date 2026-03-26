# リクエスト単体テストの実施方法(ファイルアップロード)

## アップロードファイルの記述方法

ファイルアップロードのテストは画面オンライン処理の一種。実施には画面オンライン処理のテスト（[index](testing-framework-02_RequestUnitTest.md)）が前提。

HTTPリクエストパラメータの値に以下の記述をすることで、アップロードファイルを指定できる:

```text
${attach:ファイルパス}
```

> **注意**: ファイルパスはテスト実行時のカレントディレクトリ（プロジェクトルートディレクトリ）からの相対パスで記述する。

<details>
<summary>keywords</summary>

ファイルアップロードテスト, アップロードファイル指定, ${attach:ファイルパス}, HTTPリクエストパラメータ, 相対パス, プロジェクトルートディレクトリ

</details>

## バイナリファイルの場合

画像ファイル等バイナリファイルをアップロードする場合は、事前にファイルを配置しておき、そのファイルへのパスを指定する。

以下の例では、`uploadfile` キーでプロジェクト配下の `test/resources/images/picture.png` をアップロードする:

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

バイナリファイルアップロード, 画像ファイルアップロード, ${attach:test/resources/images/picture.png}, LIST_MAP=requestParams, 事前にファイルを配置

</details>

## 固定長ファイル、CSVファイルの場合

:ref:`固定長ファイル<how_to_setup_fixed_length_file>` や :ref:`CSVファイル<how_to_setup_csv_file>` をアップロードする場合、ファイル内容をテストデータシートに記載する。テスト実行時に自動テストフレームワークがこのデータを元にファイルを作成する。

以下の例では、`work` ディレクトリ配下に `member_list.csv` を作成し、アップロード対象として指定している:

`LIST_MAP=requestParams`

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv`

ディレクティブ:

| text-encoding | Windows-31J |
|---|---|
| record-separator | CRLF |

データ:

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

> **注意**: 固定長ファイルやCSVファイルをアップロードする場合でも、事前にファイルを用意することも可能だが、テストデータの保守容易性を考慮するとテストデータシートに記載するべき。

<details>
<summary>keywords</summary>

固定長ファイルアップロード, CSVファイルアップロード, SETUP_FIXED, LIST_MAP=requestParams, how_to_setup_fixed_length_file, how_to_setup_csv_file, テストデータシート, 自動テストフレームワーク

</details>
