# Full-Text Search

全知識ファイルの全セクションに対してキーワードOR検索を実行する。

## 入力

キーワードリスト

## 出力

ヒットしたセクションのリスト（file, section_id）

### 出力形式

```
features/libraries/universal-dao.json|paging
features/libraries/universal-dao.json|overview
```

各行: `ファイル相対パス|セクションID`

## 手順

### Step 1: 全文検索の実行

**ツール**: Bash（`scripts/full-text-search.sh`）

**やること**: `scripts/full-text-search.sh` スクリプトを実行し、キーワードリストを引数として渡す。

**コマンド**:
```bash
bash scripts/full-text-search.sh "ページング" "paging" "UniversalDao"
```

**検索ルール**:

| ルール | 設定 |
|---|---|
| 結合方式 | OR（いずれかのキーワードを含むセクションがヒット） |
| 大文字小文字 | 区別しない |
| マッチ方式 | 部分一致 |
| 検索対象 | 全知識ファイルの全セクション |
| ヒット上限 | なし（section-judgementで絞り込む） |

**出力**: ヒットしたセクションのリスト

## エラーハンドリング

| 状態 | 対応 |
|---|---|
| ヒット0件 | 空の結果を返す（呼び出し元が経路2にフォールバック） |
| jqエラー | stderrにログ出力、該当ファイルをスキップして継続 |
| 知識ファイルが0件 | 空の結果を返す |
