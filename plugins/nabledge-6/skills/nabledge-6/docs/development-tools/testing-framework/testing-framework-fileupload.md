# リクエスト単体テストの実施方法(ファイルアップロード)

## アップロードファイルの記述方法

ファイルアップロードのテストはウェブアプリケーションのテストの一種であるため、ファイルアップロードのテストを実施するにはウェブアプリケーションのテスト（index）が前提となる。

HTTPリクエストパラメータにアップロードファイルを指定するには、パラメータ値に以下の記述を使用する。

```text
${attach:ファイルパス}
```

> **補足**: ファイルパスは、**テスト実行時のカレントディレクトリからの相対パス**（プロジェクトルートディレクトリからの相対パス）で記述する。

## バイナリファイルの場合

画像ファイル等のバイナリファイルをアップロードする場合は、事前にファイルを配置しておき、そのファイルへのパスを `${attach:パス}` で指定する。

**例**: `uploadfile` キーで `test/resources/images/picture.png` をアップロードする場合

ファイル配置:
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

## 固定長ファイル、CSVファイルの場合

:ref:`固定長ファイル<how_to_setup_fixed_length_file>` や :ref:`CSVファイル<how_to_setup_csv_file>` をアップロードする場合、ファイル内容をテストデータシートに記載する。テスト実行時に自動テストフレームワークがこのデータを元にファイルを作成する。

**例**: `work/member_list.csv` を作成してアップロード対象として指定する場合

`LIST_MAP=requestParams`

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv`

// ディレクティブ

| プロパティ | 値 |
|---|---|
| text-encoding | Windows-31J |
| record-separator | CRLF |

// データ

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

> **補足**: 固定長ファイルやCSVファイルのアップロードでも事前にファイルを用意することは可能だが、テストデータの保守容易性を考慮するとテストデータシートに記載すべきである。
