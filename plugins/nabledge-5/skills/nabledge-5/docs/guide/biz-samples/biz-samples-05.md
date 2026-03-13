# データベースを用いたファイル管理機能サンプル

**公式ドキュメント**: [データベースを用いたファイル管理機能サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/05/index.html)

## 概要

業務アプリケーションで使用するファイルをDBで一元管理するための機能の実装サンプル。

[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/v5-main)

**想定用途**:
- 画面からのファイルアップロード・ダウンロード
- 比較的少数のファイルを扱うファイル転送（一度に送受信するファイルが数十個程度）
- 比較的小さなファイルの管理（証明写真のような小さな画像等）

> **補足**: 本サンプルはDBとしてH2を使用している。H2以外を使用する場合は、各DBに合わせた実装に修正すること。

**ファイルアップロード時の処理フロー**:
1. ブラウザがファイルを送信
2. Nablarchのマルチパートリクエストハンドラがファイルを解析し一時ファイルに保存
3. 本サンプルがバイナリ形式でDBに格納

**ファイルダウンロード時の処理フロー**:
1. ダウンロードタグのクリックによりファイル要求が発生
2. 業務ActionクラスがStreamをStreamResponseに設定
3. 本サンプルがStreamをDBから取得

<details>
<summary>keywords</summary>

ファイル管理, DBファイル管理, ファイルアップロード, ファイルダウンロード, マルチパートリクエストハンドラ, H2データベース, StreamResponse

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.common.file.management`

<details>
<summary>keywords</summary>

please.change.me.common.file.management, ファイル管理パッケージ

</details>

## 機能

## 実装済み機能

- **ファイル登録**: ファイルのStreamをバイナリカラムに格納。ユニークなファイル管理IDをNablarchの採番機能で採番し呼び出し元に返却。ファイルサイズがカラムサイズを超えないことをチェック。
- **ファイル削除**: ファイル管理IDを元に削除サイン（SAKUJO_SGN）を書き換えて論理削除。
- **ファイル取得**: ファイル管理IDを元にファイル管理テーブルからファイルを取得し返却。

## 前提仕様

- 削除は論理削除のみ。運用時には論理削除状態のレコードのクリンナップについて別途検討が必要。
- テーブル定義には最小限のカラムのみ存在。追加情報が必要な場合は業務ごとにテーブルを別途作成する想定。
- ファイル内容チェックはファイルサイズがカラムサイズを超えないことのみ。他のチェックは呼び出し側で実施する想定。
- ファイルの更新処理は存在しない。更新に相当する処理を行う場合は、削除処理 → 登録処理の順に実行する。

<details>
<summary>keywords</summary>

ファイル登録, ファイル削除, 論理削除, ファイル取得, ファイルサイズチェック, 採番機能, SAKUJO_SGN, FILE_CONTROL

</details>

## 構成

## クラス定義

| クラス名 | 概要 |
|---|---|
| `FileManagementUtil` | DBへ格納したファイルを管理するユーティリティクラス。処理はFileManagementを実装するクラスに委譲する。 |
| `FileManagement` | ファイル管理を行うクラスが実装するインターフェース。 |
| `DbFileManagement` | DBへ格納したファイルを管理するクラスの本体。 |

## テーブル定義: FILE_CONTROL（ファイル管理テーブル）

| 論理名 | 物理名 | 定義 | 制約 | 補足 |
|---|---|---|---|---|
| ファイル管理ID | FILE_CONTROL_ID | 文字列 | 主キー | Nablarchの採番機能で採番したシステム一意なID |
| ファイル内容 | FILE_OBJECT | バイナリ | | |
| 削除サイン | SAKUJO_SGN | 文字列 | | 0: 未削除, 1: 削除済 |

<details>
<summary>keywords</summary>

FileManagementUtil, FileManagement, DbFileManagement, FILE_CONTROL, ファイル管理テーブル, クラス図, テーブル定義

</details>

## 使用方法

## コンポーネント設定

| 設定対象コンポーネント | 論理名 |
|---|---|
| ファイル管理機能本体 | fileManagement |
| 採番機能 | sequenceIdGenerator |
| 採番時に使用するフォーマッタ | dbFileManagementFormatter |

```xml
<!-- ファイル管理機能 -->
<component name="fileManagement" class="please.change.me.common.file.management.DbFileManagement">
  <!-- 格納ファイルの最大長(単位：バイト) -->
  <property name="maxFileSize" value="10000000"/>
  <!-- 採番機能識別Key -->
  <property name="fileIdKey" value="1103" />
  <!-- 採番機能 -->
  <property name="idGenerator" ref="sequenceIdGenerator" />
  <!-- 採番時に使用するフォーマッタ -->
  <property name="idFormatter" ref="dbFileManagementFormatter" />
</component>

<!-- 採番機能 -->
<component name="sequenceIdGenerator" class="nablarch.common.idgenerator.SequenceIdGenerator" />

<!-- 採番時フォーマッタ(18桁、0埋め) -->
<component name="dbFileManagementFormatter" class="nablarch.common.idgenerator.formatter.LpadFormatter">
  <property name="length" value="18" />
  <property name="paddingChar" value="0" />
</component>
```

**DbFileManagementプロパティ**:

| プロパティ名 | 説明 |
|---|---|
| maxFileSize | 格納ファイルの最大長（バイト単位） |
| fileIdKey | 採番機能でDbFileManagement用採番を識別するためのKey |
| idGenerator | 採番機能のコンポーネント |
| idFormatter | 採番時に使用するフォーマッタのコンポーネント |

## ファイルアップロード時の使用例

```java
public void doSaveFile(HttpRequest req, ExecutionContext ctx) {
    PartInfo part = req.getPart("fileToSave").get(0);
    // 業務個別のファイル精査はここで実施
    String fileId = FileManagementUtil.save(part);
    // 以降、fileIdを使用した処理
}
```

## ファイルダウンロード時の使用例

```java
public HttpResponse doTempFile(HttpRequest req, ExecutionContext ctx) {
    String fileId = "000000000000000001";
    Blob blob = FileManagementUtil.find(fileId);
    StreamResponse res = new StreamResponse(blob);
    res.setContentDisposition("temp.png");
    res.setContentType("image/png");
    return res;
}
```

<details>
<summary>keywords</summary>

FileManagementUtil, DbFileManagement, SequenceIdGenerator, LpadFormatter, maxFileSize, fileIdKey, idGenerator, idFormatter, StreamResponse, コンポーネント設定, PartInfo, Blob

</details>
