# Section Judgement

候補セクションの内容を読み、検索クエリとの関連度を判定する。全文検索（経路1）とインデックス検索（経路2）の両方から呼び出される共通ワークフロー。

## 入力

- 候補セクションのリスト（file, section_id）
- 検索キーワードリスト（呼び出し元のメモリ内にある。Step 0で使用）

## 出力

関連セクションのリスト（file, section_id, relevance）

### 出力形式

```
file: features/libraries/universal-dao.json, section_id: paging, relevance: high
file: features/libraries/universal-dao.json, section_id: overview, relevance: partial
```

呼び出し元がポインタJSONに変換する。

## 手順

### Step 0: hintsベースのpre-filter

**ツール**: Bash（jq）

**やること**: 候補セクションのindex.hintsを取得し、検索キーワードとの関連度を簡易判定する。明らかに無関係なセクションを本文読み込み前に除外する。

**コマンド**:
```bash
KNOWLEDGE_DIR=".claude/skills/nabledge-6/knowledge"

for pair in "component/libraries/libraries-universal_dao.json:paging" \
            "component/libraries/libraries-universal_dao.json:overview" \
            "component/libraries/libraries-database.json:dialect-support"; do
  file="${pair%%:*}"
  section="${pair##*:}"
  hints=$(jq -r --arg sec "$section" \
    '.index[] | select(.id == $sec) | .hints | join(",")' \
    "$KNOWLEDGE_DIR/$file" 2>/dev/null)
  echo "$file:$section|$hints"
done
```

**判定ルール**（エージェントがメモリ内の検索キーワードと照合）:
- hintsに検索キーワードが1つ以上含まれる（部分一致、大文字小文字区別なし）→ **候補として残す**
- hintsに検索キーワードが1つも含まれない → **除外**
- hintsが空またはindex内にセクションが見つからない → **候補として残す**（安全側に倒す）

**出力**: フィルタ済みの候補セクションリスト → Step A に渡す

### Step A: 候補セクションの内容を一括読み出し

**ツール**: Bash（`scripts/read-sections.sh`）

**やること**: 候補セクションの内容を一括で読み出す。1回のツールコールで全セクションの内容を取得する。候補が多い場合は2〜3回に分割（1回あたり最大10セクション程度）。

**コマンド**:
```bash
bash scripts/read-sections.sh \
  "features/libraries/universal-dao.json:paging" \
  "features/libraries/universal-dao.json:overview" \
  "features/libraries/database-access.json:query"
```

**出力**: 各セクションの本文テキスト

### Step B: 各セクションの関連度を判定

**ツール**: メモリ内（エージェント判断）

**やること**: セクション内容を読んで判定する。

**判定基準**:

| 判定 | 条件 | 具体例 |
|---|---|---|
| **High** | 検索クエリに**直接回答できる情報**を含む。メソッド名、設定例、コード例、手順など実行可能な具体的情報がある | 「ページングの実装方法」に対して `per()`, `page()` メソッドの使い方とコード例があるセクション |
| **Partial** | **前提知識、関連機能、コンテキスト情報**を含む。直接の回答ではないが理解に必要 | 「ページングの実装方法」に対してUniversalDaoの基本的な使い方（前提知識）を説明するセクション |
| **None** | 検索クエリと**無関係** | 「ページングの実装方法」に対してログ出力の設定を説明するセクション |

**判定手順**:
1. このセクションは検索クエリに直接回答する情報を含んでいるか？ → YES: **High** / NO: 次へ
2. このセクションは検索クエリの理解に必要な前提知識・関連情報を含んでいるか？ → YES: **Partial** / NO: **None**

**迷った場合**: HighとPartialで迷ったら**Partial**を選ぶ（保守的に判定）。

### Step C: フィルタ・ソート

**ツール**: メモリ内（エージェント判断）

**やること**: 判定結果をフィルタ・ソートする。

**処理**:
- Noneを除外
- High → Partial の順でソート
- 同一relevance内はファイルパスでソート

**出力**: 関連セクションのリスト

## 打ち切り条件

| 条件 | 動作 |
|---|---|
| 読み込みセクション数が **20件** に達した | 残りの候補は処理しない |
| Highが **5件** 見つかった | 残りの候補は処理しない |
| いずれかの条件に先に到達した方 | 処理を停止 |

## エラーハンドリング

| 状態 | 対応 |
|---|---|
| 候補セクションが0件 | 空リストを返す |
| セクション内容が `SECTION_NOT_FOUND` | そのセクションをスキップ |
| 全セクションがNone判定 | 空リストを返す |
