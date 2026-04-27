# 認可データ設定ツール

## 概要

認可に使用するテーブルは、テーブル数が多く、多対多の関連を持つ等、
比較的複雑な構造となっている。
このため、整合性を保ちつつ大量の認可データを作成するのに
労力がかかってしまう。

本ツールは、整合性のとれた認可データを作成するための補助ツールである。
本ツールを利用することで、人間が理解しやすくかつ整合性を保証したフォーマットを使用して、データを作成することができる。

作成したデータをツールに入力すると、ツールは、そのままマスタデータとして投入可能な形式でファイルを出力する。

### ツール利用の流れ

* 環境設定ファイル の編集を行う。
* 認可データ作成シートの記入 を行う。
* ツールを実行する。（ 自動生成ツールの実行手順 参照）

## ツール配置場所

本ツールはチュートリアルプロジェクトの `tool/authgenerator` ディレクトリに配置されている。

配下のファイル/ディレクトリ構成を以下に示す。

| ファイル/ディレクトリ | 説明 |
|---|---|
| 認可データ作成シート.xls | 認可データ作成シート( 認可データ作成シートの記入 を参照) |
| resources | 本ツールの設定ファイル配置場所（ 利用の準備 を参照） |
| authgen-build.xml | 本ツールを実行するためのAntビルドファイル( 自動生成ツールの実行手順 を参照) |
| authgen.properties | Antビルドファイルのプロパティファイル（通常、変更の必要なし） |

## 利用の準備

自動生成ツールの設定ファイルに、利用に必要な設定を記述する。

設定ファイルとその設定内容は下記の通り。

| ファイル | 設定内容 |
|---|---|
| nablarch/tool/authgenerator/AuthGenerator.xml | コンポーネント定義ファイル。通常は編集しない。 |
| nablarch/tool/authgenerator/AuthGenerator.config | 環境設定ファイル。ファイルパス、テーブル名等 |

### コンポーネント定義ファイル

通常、コンポーネント定義ファイルは編集する必要はない。
例外については、 生成不要なテーブルが存在する場合 の項を参照。

### 環境設定ファイル

基本的な設定は、この環境設定ファイルで行う。
通常は、下表の項目以外は修正する必要はない。

| キー名 | 設定内容 |
|---|---|
| authgen.inputBookPath | 認可データ作成シートのファイルパス |
| authgen.outputBookPath | 出力先ファイルパス |
| ugroupSystemAccount.converter.effectiveDateFrom | 有効開始日(yyyyMMdd) |
| ugroupSystemAccount.converter.effectiveDateTo | 有効終了日(yyyyMMdd) |

> **Note:**
> その他の項目については、テーブル名、カラム名がNablarch標準と異なる場合のみ修正する。
> 例として、テーブルの接頭辞に `T_` を、カラム名の接頭辞に `C_` を使用する場合の
> 記述例を以下に示す。

> ```bash
> ###############################################################################
> # SYSTEM_ACCOUNT_AUTHORITY
> ###############################################################################
> 
> # 入力シート名
> # テーブル名が異なる場合、Excelシート名と本設定値を変更すること
> systemAccountAuthority.inputSheetName=__T_SYSTEM_ACCOUNT_AUTHORITY__
> 
> # マトリックスのキー（主従の組み合わせ）
> # カラム名が異なる場合、Excelデータ上のカラム名と本設定値を変更すること
> systemAccountAuthority.converter.mainKey=C_USER_ID
> systemAccountAuthority.converter.subKey=C_PERMISSION_UNIT_ID
> 
> # データ出力に不要なカラム（カンマ区切りで複数指定可）
> # カラム名が異なる場合、Excelデータ上のカラム名と本設定値を変更すること
> systemAccountAuthority.converter.unconcernedKeys=C_KANJI_NAME
> 
> # 出力シート名
> # テーブル名が異なる場合、Excelデータ上のカラム名とExcelのシート名と本設定値を変更すること
> systemAccountAuthority.writer.outputSheetName=T_SYSTEM_ACCOUNT_AUTHORITY
> ```

> テーブル名、カラム名を変更する場合、認可データ作成シート上のテーブル名、カラム名も併せて修正すること。

## 認可データ作成シートの記入

実際に認可データを記入していく。
基本的には、シート名はテーブル名と紐付いている。

### 通常のテーブル

以下のシートについては、Nablarch Testing Framework の `SETUP_TABLE` と同じ書式で記載する。

* REQUEST
* USERS
* UGROUP
* SYSTEM_ACCOUNT
* PERMISSION_UNIT

### 関連テーブル

関連テーブルについては、 __<テーブル名>__ という命名規則になっている。

以下のシートについては、多対多の関係をマトリックス形式で記入する。

* __UGROUP_SYSTEM_ACCOUNT__
* __SYSTEM_ACCOUNT_AUTHORITY__
* __UGROUP_AUTHORITY__

当箇所のセルに `o` (英小文字のオー)を記入する  [1] 。
UGROUP_SYSTEM_ACCOUNTの例を以下に示す。

UGROUP_SYSTEM_ACCOUNT

| SYSTEM_ACCOUNT |  | UGROUP |  |
|---|---|---|---|
| US001 | 奈部楽太郎 | o | o |
| US002 | 奈部楽次郎 |  |  |
| US003 | 奈部楽三郎 | o |  |

この表は、以下の様な意味となる。

* US001のユーザは、ユーザグループUG001とUG002に所属する。
* US002のユーザは、ユーザグループに所属しない。
* US003のユーザは、ユーザグループUG001に所属する。

上記の表の場合、ツールを実行すると、
`UGROUP_SYSTEM_ACCOUNT` というシート名で、以下のようなデータに変換される。

SETUP_TABLE=UGROUP_SYSTEM_ACCOUNT

| USER_ID | UGROUP_ID |
|---|---|
| US001 | UG001 |
| US001 | UG002 |
| US003 | UG001 |

このチェックマークはデフォルトでは `o` (英小文字のオー)であるが、
環境設定ファイルを修正することにより変更可能である。

マークを `x` (英小文字のエックス)に変更する場合の例を以下に示す。

```bash
authgen.checkMark=x
```

#### PERMISSION_UNIT_REQUEST

`__PERMISSION_UNIT_REQUEST__` シートは上記のシートとは別な記法で記載する。

一つの認可単位(PERMISSION_UNIT_ID)に対して、その認可単位が取り得るリクエストID(REQUEST_ID)の
 **範囲** を記載する [2] 。範囲が複数に別れる場合は、FROM_2,TO_2、FROM_3,TO_3... というように
右に続けて記入する。

PERMISSION_UNIT_REQUEST

| PERMISSION_UNIT |  | REQUEST_ID |  |  |  |
|---|---|---|---|---|---|
| PU001 | ログイン | RW11AA0101 | RW11AA0199 | RW11AB0101 | RW11AB0199 |
| PU002 | 一覧照会 | RW11AC0101 | RW11AC0199 |  |  |

リクエストIDの一覧が以下のようにあるとする。

REQUEST

| REQUEST_ID | REQUEST_NAME |
|---|---|
| RW11AA0101 | ログイン画面初期表示処理 |
| RW11AA0102 | ログイン処理 |
| RW11AB0101 | メニュー表示処理 |
| RW11AC0101 | ユーザ情報一覧照会画面初期表示処理 |
| RW11AC0102 | ユーザ検索処理 |
| RW11AC0103 | ユーザ情報詳細画面表示処理 |
| RW11AC0104 | ユーザ一覧CSVダウンロード処理 |
| RW11ZZ9999 | 未使用  [3] |

この状態でツールを実行すると、
`PERMISSION_UNIT_REQUEST` というシート名で、以下のようなデータに変換される。

SETUP_TABLE=PERMISSION_UNIT_REQUEST

| PERMISSION_UNIT_ID | REQUEST_ID |
|---|---|
| PU001 | RW11AA0101 |
| PU001 | RW11AA0102 |
| PU001 | RW11AB0101 |
| PU002 | RW11AC0101 |
| PU002 | RW11AC0102 |
| PU002 | RW11AC0103 |
| PU002 | RW11AC0104 |

リクエストIDそのものではなく、リクエストIDの取り得る **範囲** を指定することで、
新たにリクエストを追加した際に、認可単位との関連付けが自動的になされるというメリットがある。
例えば、新たなリクエスト RW11AA0103（ログアウト処理）を追加した場合、
リクエストIDがRW11AA0101～RW11AA0199の範囲に入るため、認可単位PU001（ログイン）に含まれることになる。

どの認可単位にも属さないリクエストIDが存在する場合（上記例の場合、RW11ZZ9999）、
ツール実行時に、そのリクエストIDがログ（標準出力）に出力される。

```text
Unused Request ID found. [[RM11XX9999]]
```

通常、認可単位に属さないリクエストIDは存在しないはずであるので、
誤りである場合は修正すること。

## 生成不要なテーブルが存在する場合

生成不要なテーブルが存在する場合、以下の手順で作業を行う。

認可データ作成シートから、不要なテーブルに関連するシートを削除する。

例えば、 `SYSTEM_ACOUNT_AUTHORITY` が不要な場合、以下のシートを削除する。

* SYSTEM_ACCOUNT_AUTHORITY
* __SYSTEM_ACCOUNT_AUTHORITY__

コンポーネント定義ファイルの以下の箇所から、不要なコンポーネント登録を削除する。

```xml
<list name="matrixComponentNames">
  <value>systemAccountAuthority</value>
  <value>ugroupAuthority</value>
  <value>ugroupSystemAccount</value>
  <value>permissionUnitRequest</value>
</list>
```

例えば、 `SYSTEM_ACOUNT_AUTHORITY` が不要な場合、
`systemAccountAuthority` の行を削除する。

```xml
<list name="matrixComponentNames">
  <value>ugroupAuthority</value>
  <value>ugroupSystemAccount</value>
  <value>permissionUnitRequest</value>
</list>
```

## 自動生成ツールの実行手順

ツールは以下のように実行する。

```bash
ant -f authgen-build.xml
```

ツールを実行すると、入力ファイル（認可データ設定シート）を読み取り、
データを変換して、ファイル出力する [4]  。
出力されたファイルはそのまま編集なしでDBに投入可能である。

出力されるファイルのファイル名は、 環境設定ファイル に記載したもの。デフォルトでは、 `MASTER_DATA_AUTH.xls` ）。
