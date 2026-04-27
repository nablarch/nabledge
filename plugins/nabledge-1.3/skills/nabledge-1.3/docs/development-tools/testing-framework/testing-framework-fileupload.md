# リクエスト単体テストの実施方法(ファイルアップロード)

ファイルアップロードのテストは、画面オンライン処理のテストの一種である。
したがって、ファイルアップロードのテストを実施するには、画面オンライン処理の [リクエスト単体テストの実施方法](../../development-tools/testing-framework/testing-framework-02-requestunittest-index.md) が前提となる。

ファイルアップロードのテストをする場合、HTTPリクエストパラメータにアップロードファイルを指定する必要がある。
本項では、HTTPリクエストパラメータにアップロードファイルを指定する方法を解説する。

-----

## アップロードファイルの記述方法

HTTPリクエストパラメータの値に、以下の記述をすることで、
HTTPリクエストパラメータにアップロードファイルを指定できる。

```text
${attach:ファイルパス}
```

> **Note:**
> ファイルパスは、 **テスト実行時のカレントディレクトリからの相対パス** 、すなわち、
> プロジェクトルートディレクトリからの相対パスで記述する。

## バイナリファイルの場合

画像ファイル等、バイナリファイルをアップロードする場合は、事前にファイルを配置しておき、
そのファイルへのパスを指定する。

以下の例では、uploadfileというキーで、プロジェクト配下のtest/resources/images
ディレクトリにあるpicture.pngをアップロードする。

```text
<project_root>
     + test
        + resources
           + images
              + picture.png
```

-----

`LIST_MAP=requestParams`

| uploadfile | comment | public |
|---|---|---|
| `${attach:test/resources/images/picture.png}` | アップロードします。 | `false` |

## 固定長ファイル、CSVファイルの場合

[固定長ファイル](../../development-tools/testing-framework/testing-framework-02-requestunittest-batch.md#how-to-setup-fixed-length-file)や
[CSVファイル](../../development-tools/testing-framework/testing-framework-02-requestunittest-batch.md#how-to-setup-csv-file) をアップロードする場合、
そのファイル内容をテストデータシートに記載する。
テスト実行時に、自動テストフレームワークがこのデータを元にファイルを作成する。

以下の例では、workディレクトリ配下にmember_list.csvファイルを作成し、
そのファイルをアップロード対象として指定している。

-----

`LIST_MAP=requestParams`

| uploadfile | comment |
|---|---|
| `${attach:work/member_list.csv}` | 10月度新規会員を登録 |

`SETUP_FIXED=work/member_list.csv`

// ディレクティブ

| text-encoding | Windows-31J |  |
|---|---|---|
| record-separator | CRLF |  |

// データ

| name | age | address |
|---|---|---|
| 山田太郎 | 30 | 東京都港区芝浦1-1 |
| 田中次郎 | 20 | 大阪府門真市東田町2-2 |

-----

> **Note:**
> 固定長ファイルやCSVファイルをアップロードする場合でも、
> バイナリファイルと同様に、事前にファイルを用意しておくことも可能であるが、
> テストデータの保守容易性を考慮するとテストデータシートに記載しておくべきである。
