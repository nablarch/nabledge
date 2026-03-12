# データベースを用いたファイル管理機能サンプル

**公式ドキュメント**: [データベースを用いたファイル管理機能サンプル](https://nablarch.github.io/docs/LATEST/doc/biz_samples/05/index.html)

## 概要

DBを用いてファイルを一元管理するサンプル実装。[ソースコード](https://github.com/nablarch/nablarch-biz-sample-all/tree/main/nablarch-db-file-management)

想定用途:
- 画面からのファイルアップロード・ダウンロード
- 一度に送信/受信するファイルが数十個程度の比較的少数のファイル転送
- 証明写真のような比較的小さなファイルの管理

> **補足**: 本サンプルはDBとしてH2を使用。H2以外を使用する場合は各DBに合わせた実装に修正すること。

**ファイルアップロード時の処理:**
1. ブラウザからのファイル送信をNablarchのマルチパートリクエストハンドラが解析し一時ファイルに保存
2. 本サンプルがファイルをバイナリ形式でDBに格納

**ファイルダウンロード時の処理:**
1. ダウンロードタグのクリックによりファイル要求
2. 業務ActionクラスがStreamをStreamResponseに設定（本サンプルはStreamをDBから取得）

<details>
<summary>keywords</summary>

FileManagementUtil, DbFileManagement, FileManagement, ファイル管理, DBファイル管理, ファイルアップロード, ファイルダウンロード, バイナリ格納

</details>

## 機能

**実装済み機能:**

- **ファイル登録機能**: ファイルのStreamをバイナリカラムに格納。Nablarchの採番機能でユニークなファイル管理IDを採番し、呼び出し元に返却する。ファイルサイズがカラムサイズを超えないことをチェック。
- **ファイルの削除機能**: ファイル管理IDを元に削除サインを書き換えて論理削除。
- **ファイルの取得機能**: ファイル管理IDを元にファイル管理テーブルからファイルを取得して返却。

**前提としている仕様:**

- 削除は論理削除のみ。運用時には論理削除状態のレコードのクリーンアップを別途検討すること。
- テーブル定義には最小限のカラムのみ。追加情報が必要な場合は業務ごとに別テーブルを作成すること。
- ファイル内容チェックはファイルサイズがカラムサイズを超えないことのみ。他のチェックは呼び出し側で行うこと。
- ファイルの更新処理は存在しない。更新が必要な場合はファイルの削除処理とファイルの登録処理を順に実行すること。

<details>
<summary>keywords</summary>

ファイル登録機能, ファイル削除機能, 論理削除, ファイル取得機能, ファイルサイズチェック, 採番, FileManagementUtil, DbFileManagement

</details>

## 構成

**クラス構成:**

| クラス名 | 概要 |
|---|---|
| `FileManagementUtil` | DBへ格納したファイルを管理するユーティリティクラス。処理はFileManagementを実装するクラスに委譲する。 |
| `FileManagement` | ファイル管理を行うクラスが実装するインターフェース。 |
| `DbFileManagement` | DBへ格納したファイルを管理するクラスの本体。 |

**ファイル管理テーブル (FILE_CONTROL):**

| 論理名 | 物理名 | 定義 | 制約 | 補足 |
|---|---|---|---|---|
| ファイル管理ID | FILE_CONTROL_ID | 文字列 | 主キー | システムで採番した一意なID（Nablarchの採番機能で採番） |
| ファイル内容 | FILE_OBJECT | バイナリ | | |
| 削除サイン | SAKUJO_SGN | 文字列 | | 0:未削除、1:削除済 |

> **重要**: 採番にはシーケンスが必要。コンポーネント設定ファイルで指定する`fileIdKey`と同名のシーケンスを事前に作成すること。

<details>
<summary>keywords</summary>

FileManagementUtil, FileManagement, DbFileManagement, FILE_CONTROL, FILE_CONTROL_ID, FILE_OBJECT, SAKUJO_SGN, クラス構成, テーブル定義, ファイル管理テーブル

</details>

## 使用方法

**FileManagementUtilのコンポーネント設定:**

| 設定対象コンポーネント | 論理名 |
|---|---|
| ファイル管理機能本体 | fileManagement |
| 採番機能 | sequenceIdGenerator |
| 採番時に使用するフォーマッタ | dbFileManagementFormatter |

```xml
<!-- ファイル管理機能(論理名fileManagementのコンポーネントを、FileManagementUtilクラスが使用する) -->
<component name="fileManagement" class="please.change.me.common.file.management.DbFileManagement">
  <!-- 格納ファイルの最大長(単位：バイト) -->
  <property name="maxFileSize" value="10000000"/>
  <!-- 採番機能で、DbFileManagement用の採番である旨を識別するためのKey -->
  <property name="fileIdKey" value="FILE_CONTROL_SEQ" />
  <property name="idGenerator" ref="sequenceIdGenerator" />
  <property name="idFormatter" ref="dbFileManagementFormatter" />
</component>

<component name="sequenceIdGenerator" class="nablarch.common.idgenerator.SequenceIdGenerator" />

<component name="dbFileManagementFormatter" class="nablarch.common.idgenerator.formatter.LpadFormatter">
  <property name="length" value="18" />
  <property name="paddingChar" value="0" />
</component>
```

**ファイルアップロード時の使用例:**

```java
public void doSaveFile(HttpRequest req, ExecutionContext ctx) {
    // 保存対象のパートを取得
    PartInfo part = req.getPart("fileToSave").get(0);
    
    //必要であれば、このタイミングで業務個別のファイル精査を実施。
    
    //DBにファイルを登録
    String fileId = FileManagementUtil.save(part);
    
    //以降、必要に応じてfileIdを使用した処理を行う。
}
```

**ファイルダウンロード時の使用例:**

```java
public HttpResponse doTempFile(HttpRequest req, ExecutionContext ctx) {
    //ダウンロードに使用するファイルID
    String fileId = "000000000000000001";
    
    // ファイルをDBから取得
    Blob blob = FileManagementUtil.find(fileId);
    
    // レスポンス情報を設定
    StreamResponse res = new StreamResponse(blob);
    res.setContentDisposition("temp.png");
    res.setContentType("image/png");
    return res;
}
```

<details>
<summary>keywords</summary>

FileManagementUtil, DbFileManagement, SequenceIdGenerator, LpadFormatter, maxFileSize, fileIdKey, idGenerator, idFormatter, StreamResponse, PartInfo, Blob, コンポーネント設定, ファイルアップロード実装, ファイルダウンロード実装

</details>
