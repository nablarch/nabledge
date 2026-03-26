# データベースを用いたファイル管理機能サンプル

## 概要

DBにファイルをバイナリ形式で格納し一元管理するサンプル実装。

**対象用途**:
- 画面からのファイルアップロード・ダウンロード
- 比較的少数のファイル転送（一度に数十個程度）
- 比較的小さなファイル（証明写真のような小さな画像等）

> **注意**: 本サンプルはOracleを使用。Oracle以外のDBを使用する場合は各DBに合わせた実装に修正すること。

**ファイルアップロード時の処理フロー**:
1. ブラウザがファイルを送信
2. Nablarchのマルチパートリクエストハンドラがリクエストをパースし一時ファイルに保存
3. 本サンプルが一時ファイルをバイナリ形式でDBに格納

**ファイルダウンロード時の処理フロー**:
1. ダウンロードタグのクリックによりファイル要求
2. 業務ActionクラスがDBからStreamを取得
3. StreamをStreamResponseに設定してレスポンス返却

<details>
<summary>keywords</summary>

DBファイル管理, ファイルアップロード, ファイルダウンロード, バイナリ格納, StreamResponse, マルチパートリクエスト

</details>

## 提供パッケージ

**パッケージ**: `please.change.me.common.file.management`

<details>
<summary>keywords</summary>

please.change.me.common.file.management, ファイル管理パッケージ

</details>

## 機能

**実装済み機能**:

- **ファイル登録**: ファイルのStreamを元にバイナリカラムへ格納。格納時にNablarchの採番機能でユニークなファイル管理IDを採番し呼び出し元に返却。ファイルサイズがカラムのサイズを超えないことをチェック。
- **ファイル削除**: ファイル管理IDを元に削除サインを書き換えて論理削除。
- **ファイル取得**: ファイル管理IDを元にファイル管理テーブルからファイルを取得して返却。

**前提仕様**:
- 削除は論理削除のみ。物理削除（クリーンアップ）は別途運用で対応すること。
- テーブル定義は最小限のカラムのみ。追加情報が必要な場合は業務ごとに別テーブルを作成すること。
- ファイル内容のチェックはファイルサイズのみ。他のチェックは呼び出し側で実施すること。
- ファイル更新処理は存在しない。更新が必要な場合はファイルの削除処理とファイルの登録処理を順に実行すること。

<details>
<summary>keywords</summary>

ファイル登録, ファイル削除, ファイル取得, 論理削除, ファイルサイズチェック, 採番機能

</details>

## 構成

**クラス定義**:

| クラス名 | 概要 |
|---|---|
| `FileManagementUtil` | DBへ格納したファイルを管理するユーティリティクラス。処理はFileManagementを実装するクラスに委譲する。 |
| `FileManagement` | ファイル管理を行うクラスが実装するインターフェース。 |
| `DbFileManagement` | DBへ格納したファイルを管理するクラスの本体。 |

**テーブル定義 FILE_CONTROL（ファイル管理テーブル）**:

| 論理名 | 物理名 | 定義 | 制約 | 補足 |
|---|---|---|---|---|
| ファイル管理ID | FILE_CONTROL_ID | 文字列 | 主キー | Nablarchの採番機能で採番した一意なID |
| ファイル内容 | FILE_OBJECT | バイナリ | | |
| 削除サイン | SAKUJO_SGN | 文字列 | | 0:未削除 / 1:削除済 |

> **注意**: ファイル管理IDの採番にはOracleのシーケンスを使用している。

<details>
<summary>keywords</summary>

FileManagementUtil, FileManagement, DbFileManagement, FILE_CONTROL, FILE_CONTROL_ID, FILE_OBJECT, SAKUJO_SGN, ファイル管理テーブル

</details>

## 使用方法 — コンポーネント定義ファイル設定

FileManagementUtil使用時に必要となる各コンポーネントのプロパティをコンポーネント定義ファイルに設定する。

| 設定対象 | 設定例の論理名 |
|---|---|
| ファイル管理機能本体 | fileManagement |
| 採番機能 | oracleSequenceIdGenerator |
| 採番時に使用するフォーマッター | dbFileManagementFormatter |

> **注意**: 下記の例では採番機能として「ベンダー依存のデータベース関連拡張サンプル実装」に含まれる`OracleSequenceIdGenerator`を使用している。

```xml
<!-- ファイル管理機能 -->
<component name="fileManagement" class="please.change.me.common.file.management.fileManagement">
  <property name="maxFileSize" value="10000000"/>
  <property name="fileIdKey" value="1103" />
  <property name="idGenerator" ref="oracleSequenceIdGenerator" />
  <property name="idFormatter" ref="dbFileManagementFormatter" />
</component>

<!-- 採番機能 -->
<component name="oracleSequenceIdGenerator" class="nablarch.common.idgenerator.OracleSequenceIdGenerator">
  <property name="idTable">
    <map>
      <entry key="1103" value="FILE_ID_SEQ"/>
    </map>
  </property>
</component>

<!-- 採番時に使用するフォーマッター -->
<component name="dbFileManagementFormatter" class="nablarch.common.idgenerator.formatter.LpadFormatter">
  <property name="length" value="18" />
  <property name="paddingChar" value="0" />
</component>
```

<details>
<summary>keywords</summary>

FileManagementUtil, OracleSequenceIdGenerator, LpadFormatter, maxFileSize, fileIdKey, idGenerator, idFormatter, ベンダー依存のデータベース関連拡張サンプル実装, コンポーネント定義

</details>

## 使用方法 — ファイルアップロード時

ブラウザからアップロードされたファイルをDBに保存する場合の使用例。

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

<details>
<summary>keywords</summary>

FileManagementUtil, PartInfo, HttpRequest, ExecutionContext, save, getPart, ファイルアップロード実装, 業務個別のファイル精査

</details>

## 使用方法 — ファイルダウンロード時

ファイルをDBから取り出してブラウザにダウンロードさせる場合の使用例。

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

FileManagementUtil, Blob, HttpRequest, ExecutionContext, HttpResponse, find, StreamResponse, ファイルダウンロード実装

</details>
