# 認可データ設定ツール

## 

認可テーブルは多対多の関連を持つ複雑な構造で、整合性を保ちながら大量の認可データを手動作成するのは困難。本ツールを使用すると人間が理解しやすいフォーマット（認可データ作成シート.xls）でデータを記述し、整合性を保証したままDBへのマスタデータとして投入可能なファイルを出力できる。

<details>
<summary>keywords</summary>

認可データ設定ツール, 認可データ作成, 認可テーブル, マスタデータ生成, 整合性保証

</details>

## ツール利用の流れ

1. 環境設定ファイル（`nablarch/tool/authgenerator/AuthGenerator.config`）を編集する
2. 認可データ作成シート（`認可データ作成シート.xls`）に認可データを記入する
3. ツールを実行する（`ant -f authgen-build.xml`）

<details>
<summary>keywords</summary>

ツール利用手順, authgenerator実行手順, 認可データ作成ワークフロー, 環境設定ファイル編集, authgen-build.xml

</details>

## 

ツールはチュートリアルプロジェクトの `tool/authgenerator` ディレクトリに配置されている。

| ファイル/ディレクトリ | 説明 |
|---|---|
| 認可データ作成シート.xls | 認可データ作成シート |
| resources | ツールの設定ファイル配置場所 |
| authgen-build.xml | Antビルドファイル |
| authgen.properties | Antビルドファイルのプロパティファイル（通常変更不要） |

<details>
<summary>keywords</summary>

ツール配置場所, authgeneratorディレクトリ構成, 認可データ作成シート.xls, authgen-build.xml, resources

</details>

## コンポーネント定義ファイル

`nablarch/tool/authgenerator/AuthGenerator.xml` は通常編集不要。生成不要なテーブルがある場合のみ `matrixComponentNames` リストから該当コンポーネントを削除する（詳細はs13参照）。

<details>
<summary>keywords</summary>

コンポーネント定義ファイル, AuthGenerator.xml, matrixComponentNames, 生成不要なテーブル

</details>

## 

設定ファイルとその内容：

| ファイル | 設定内容 |
|---|---|
| `nablarch/tool/authgenerator/AuthGenerator.xml` | コンポーネント定義ファイル。通常は編集しない。 |
| `nablarch/tool/authgenerator/AuthGenerator.config` | 環境設定ファイル。ファイルパス、テーブル名等を設定する。 |

<details>
<summary>keywords</summary>

利用の準備, 設定ファイル一覧, AuthGenerator.config, AuthGenerator.xml, 環境設定ファイル

</details>

## 環境設定ファイル

| キー名 | 設定内容 |
|---|---|
| `authgen.inputBookPath` | 認可データ作成シートのファイルパス |
| `authgen.outputBookPath` | 出力先ファイルパス |
| `ugroupSystemAccount.converter.effectiveDateFrom` | 有効開始日（yyyyMMdd） |
| `ugroupSystemAccount.converter.effectiveDateTo` | 有効終了日（yyyyMMdd） |

> **注意**: 上記以外の項目はテーブル名・カラム名がNablarch標準と異なる場合のみ修正する。テーブル名/カラム名を変更する場合は、認可データ作成シート上のテーブル名/カラム名も併せて修正すること。

テーブル名・カラム名のカスタマイズ例（接頭辞 `T_`/`C_` 使用時）：

```bash
systemAccountAuthority.inputSheetName=__T_SYSTEM_ACCOUNT_AUTHORITY__
systemAccountAuthority.converter.mainKey=C_USER_ID
systemAccountAuthority.converter.subKey=C_PERMISSION_UNIT_ID
systemAccountAuthority.converter.unconcernedKeys=C_KANJI_NAME
systemAccountAuthority.writer.outputSheetName=T_SYSTEM_ACCOUNT_AUTHORITY
```

<details>
<summary>keywords</summary>

環境設定ファイル, authgen.inputBookPath, authgen.outputBookPath, effectiveDateFrom, effectiveDateTo, テーブル名カスタマイズ, カラム名カスタマイズ, AuthGenerator.config

</details>

## 

シート名はテーブル名と紐付いている。シートの種類：
- **通常のテーブル**: Nablarch Testing Frameworkの `SETUP_TABLE` と同じ書式
- **関連テーブル**: `__<テーブル名>__` の命名規則でマトリックス形式

<details>
<summary>keywords</summary>

認可データ作成シート, シート記入方法, SETUP_TABLE, マトリックス形式, シート名テーブル名対応

</details>

## 通常のテーブル

以下のシートはNablarch Testing Frameworkの `SETUP_TABLE` と同じ書式で記載する：

- REQUEST
- USERS
- UGROUP
- SYSTEM_ACCOUNT
- PERMISSION_UNIT

<details>
<summary>keywords</summary>

通常のテーブル, REQUEST, USERS, UGROUP, SYSTEM_ACCOUNT, PERMISSION_UNIT, SETUP_TABLE書式

</details>

## 

```bash
ant -f authgen-build.xml
```

入力ファイル（認可データ作成シート）を読み取り、変換して出力ファイルに書き出す。出力ファイルはそのまま編集なしでDBに投入可能。出力ファイル名は `authgen.outputBookPath` で設定（デフォルト: `MASTER_DATA_AUTH.xls`）。

> **注意**: 実行時、どの認可単位にも属さないリクエストIDが存在する場合はログ（標準出力）に出力される（例: `Unused Request ID found. [[RM11XX9999]]`）。通常は誤りなので修正すること。

<details>
<summary>keywords</summary>

自動生成ツール実行, ant authgen-build.xml, MASTER_DATA_AUTH.xls, 未使用リクエストID, Unused Request ID

</details>

## 関連テーブル

`__<テーブル名>__` の命名規則のシートは多対多の関係をマトリックス形式で記入する。

対象シート：
- `__UGROUP_SYSTEM_ACCOUNT__`
- `__SYSTEM_ACCOUNT_AUTHORITY__`
- `__UGROUP_AUTHORITY__`

チェックマークのデフォルトは `o`（英小文字のオー）。`authgen.checkMark=x` で変更可能。

記入例（UGROUP_SYSTEM_ACCOUNT）：行=USER_ID、列=UGROUP_ID で、`o` が入っている箇所が所属関係を示す。

| USER_ID | KANJI_NAME | UG001 | UG002 |
|---|---|---|---|
| US001 | 奈部楽太郎 | o | o |
| US002 | 奈部楽次郎 | | |
| US003 | 奈部楽三郎 | o | |

上記の場合、`UGROUP_SYSTEM_ACCOUNT` テーブルに以下の行が生成される：

| USER_ID | UGROUP_ID |
|---|---|
| US001 | UG001 |
| US001 | UG002 |
| US003 | UG001 |

<details>
<summary>keywords</summary>

関連テーブル, マトリックス形式, UGROUP_SYSTEM_ACCOUNT, SYSTEM_ACCOUNT_AUTHORITY, UGROUP_AUTHORITY, authgen.checkMark, 多対多

</details>

## PERMISSION_UNIT_REQUEST

`__PERMISSION_UNIT_REQUEST__` シートは、PERMISSION_UNIT_IDに対して取り得るREQUEST_IDの**範囲**（FROM_N/TO_N）を指定する記法で記入する。範囲が複数の場合はFROM_2/TO_2、FROM_3/TO_3と右に続けて記入する。

**入力例（`__PERMISSION_UNIT_REQUEST__` シート）**：

| PERMISSION_UNIT_ID | PERMISSION_UNIT_NAME | FROM_1 | TO_1 | FROM_2 | TO_2 |
|---|---|---|---|---|---|
| PU001 | ログイン | RW11AA0101 | RW11AA0199 | RW11AB0101 | RW11AB0199 |
| PU002 | 一覧照会 | RW11AC0101 | RW11AC0199 | | |

**REQUESTテーブル（存在するリクエストID一覧）**：

| REQUEST_ID | REQUEST_NAME |
|---|---|
| RW11AA0101 | ログイン画面初期表示処理 |
| RW11AA0102 | ログイン処理 |
| RW11AB0101 | メニュー表示処理 |
| RW11AC0101 | ユーザ情報一覧照会画面初期表示処理 |
| RW11AC0102 | ユーザ検索処理 |
| RW11AC0103 | ユーザ情報詳細画面表示処理 |
| RW11AC0104 | ユーザ一覧CSVダウンロード処理 |
| RW11ZZ9999 | 未使用 |

ツールを実行すると、FROM/TO範囲内に存在するREQUEST_IDが展開され、`PERMISSION_UNIT_REQUEST` シートに以下のデータが生成される：

**出力（`SETUP_TABLE=PERMISSION_UNIT_REQUEST`）**：

| PERMISSION_UNIT_ID | REQUEST_ID |
|---|---|
| PU001 | RW11AA0101 |
| PU001 | RW11AA0102 |
| PU001 | RW11AB0101 |
| PU002 | RW11AC0101 |
| PU002 | RW11AC0102 |
| PU002 | RW11AC0103 |
| PU002 | RW11AC0104 |

RW11ZZ9999はどの認可単位の範囲にも含まれないため出力されず、ログに `Unused Request ID found.` として出力される。

> **補足**: リクエストIDそのものではなく範囲で指定することで、新規リクエスト追加時に自動的に認可単位との関連付けがされる。例えば RW11AA0103（ログアウト処理）を追加すると、PU001（RW11AA0101〜RW11AA0199の範囲）に自動的に含まれる。

<details>
<summary>keywords</summary>

PERMISSION_UNIT_REQUEST, リクエストID範囲指定, FROM_1, TO_1, FROM_2, TO_2, 認可単位, 自動関連付け, 範囲展開, RW11AA0101, RW11ZZ9999

</details>

## 認可データ作成シート編集

生成不要なテーブルがある場合、認可データ作成シートから関連するシートを削除する。

例: `SYSTEM_ACCOUNT_AUTHORITY` が不要な場合、以下のシートを削除する：
- `SYSTEM_ACCOUNT_AUTHORITY`
- `__SYSTEM_ACCOUNT_AUTHORITY__`

<details>
<summary>keywords</summary>

認可データ作成シート編集, 不要テーブル削除, シート削除, 生成不要なテーブル

</details>

## コンポーネント定義ファイル編集

コンポーネント定義ファイル（`AuthGenerator.xml`）の `matrixComponentNames` リストから不要なコンポーネント登録を削除する。

例: `SYSTEM_ACCOUNT_AUTHORITY` が不要な場合、`systemAccountAuthority` の行を削除する：

```xml
<list name="matrixComponentNames">
  <value>ugroupAuthority</value>
  <value>ugroupSystemAccount</value>
  <value>permissionUnitRequest</value>
</list>
```

<details>
<summary>keywords</summary>

コンポーネント定義ファイル編集, matrixComponentNames, systemAccountAuthority, ugroupAuthority, ugroupSystemAccount, permissionUnitRequest

</details>
