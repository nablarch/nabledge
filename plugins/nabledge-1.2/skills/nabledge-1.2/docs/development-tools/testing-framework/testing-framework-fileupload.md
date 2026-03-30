# リクエスト単体テストの実施方法(ファイルアップロード)

## アップロードファイルの記述方法

ファイルアップロードのテストは画面オンライン処理のテストの一種であり、[index](testing-framework-02_RequestUnitTest.md)が前提となる。

HTTPリクエストパラメータの値に以下の記述でアップロードファイルを指定できる。

```text
${attach:ファイルパス}
```

> **注意**: ファイルパスはテスト実行時のカレントディレクトリ（プロジェクトルートディレクトリ）からの相対パスで記述する。

<details>
<summary>keywords</summary>

ファイルアップロード, HTTPリクエストパラメータ, アップロードファイル指定, ${attach:ファイルパス}, 相対パス, プロジェクトルートからの相対パス

</details>

## バイナリファイルの場合

画像ファイル等のバイナリファイルをアップロードする場合は、事前にファイルを配置しておき、そのファイルへのパスを指定する。

テストデータ例（`LIST_MAP=requestParams`）:

| uploadfile | comment | public |
|---|---|---|
| `${attach:test/resources/images/picture.png}` | アップロードします。 | `false` |

<details>
<summary>keywords</summary>

バイナリファイル, 画像ファイルアップロード, ファイルパス指定, uploadfile, picture.png

</details>

## 固定長ファイル、CSVファイルの場合

:ref:`固定長ファイル<how_to_setup_fixed_length_file>`や:ref:`CSVファイル<how_to_setup_csv_file>`をアップロードする場合、そのファイル内容をテストデータシートに記載する。テスト実行時に自動テストフレームワークがこのデータを元にファイルを作成する。

テストデータ例（`LIST_MAP=requestParams`）:

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv` ディレクティブ:

| プロパティ | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

データ:

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

> **注意**: 固定長ファイルやCSVファイルをアップロードする場合でも事前にファイルを用意することは可能だが、テストデータの保守容易性を考慮するとテストデータシートに記載すべきである。

<details>
<summary>keywords</summary>

固定長ファイル, CSVファイル, テストデータシート, SETUP_FIXED, 自動ファイル生成, テストデータ保守容易性, text-encoding, record-separator

</details>
