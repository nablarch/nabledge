# Section Search

候補ファイルの `index[].hints` とキーワードをマッチングし、候補セクションを選定する。

## 入力

候補ファイルのリスト + キーワードリスト

## 出力

候補セクションのリスト（file, section_id）

### 出力形式

```
features/libraries/universal-dao.json|paging
features/libraries/universal-dao.json|overview
```

全文検索の出力形式と同一。

## 手順

### Step 1: セクションのhints一括抽出

**ツール**: Bash（jq）

**やること**: 候補ファイルの `index[].hints` を一括で抽出する。

**コマンド**:
```bash
KNOWLEDGE_DIR="$(cd "$(dirname "$0")/.." && pwd)/knowledge"  # スクリプトから呼ぶ場合

for file in features/libraries/universal-dao.json \
            features/libraries/database-access.json; do
  jq -r --arg f "$file" \
    '.index[] | "\($f)|\(.id)|\(.hints | join(","))"' \
    "$KNOWLEDGE_DIR/$file" 2>/dev/null
done
```

**出力例**:
```
features/libraries/universal-dao.json|overview|UniversalDao,DAO,O/Rマッパー,CRUD
features/libraries/universal-dao.json|paging|ページング,paging,per,page,Pagination
```

### Step 2: マッチングとスコアリング

**ツール**: メモリ内（エージェント判断）

**やること**: 各セクションのhintsに対して、キーワードリストの各キーワードを部分一致で照合する。

**マッチングロジック**:
- 部分一致（hintsの要素にキーワードが含まれる、またはキーワードにhints要素が含まれる）
- 大文字小文字区別なし
- マッチしたキーワード1つにつき +1点
- スコアが **1点以上** のセクションを候補とする

**選定ルール**:
- 最大セクション数: **20件**
- スコア降順で選定

**出力**: 候補セクションのリスト

## エラーハンドリング

| 状態 | 対応 |
|---|---|
| 候補ファイルが0件 | 空リストを返す |
| hintsが空のセクション | スキップ |
| JSON読み込みエラー | 該当ファイルをスキップ |
