# リクエストハンドラエントリ

## 

**クラス名**: `nablarch.fw.RequestHandlerEntry`

対象ハンドラをラップし、特定の [リクエストパス](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) に対してのみ実行するハンドラ。

## リクエストパスのパターン指定

Glob式に似た書式でリクエストパスのパターンを指定する。`*` は `.` と `/` を除く任意文字列にマッチ。末尾の `/` が `//` の場合、それ以前の文字列で前方一致すればマッチ成功と判定する。`//` 以降の文字列（リソース名）については別途マッチ判定が行われる（すなわち「サブディレクトリ全体」にマッチし、さらに `//` 以降のパターンでリソース名もフィルタリングされる）。

### 基本パターン

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/` | `/` | 呼ばれる |
| `/` | `/index.jsp` | 呼ばれない |
| `/*` | `/` | 呼ばれる |
| `/*` | `/app` | 呼ばれる |
| `/*` | `/app/` | 呼ばれない（`*` は `/` にマッチしない） |
| `/*` | `/index.jsp` | 呼ばれない（`*` は `.` にマッチしない） |
| `/app/*.jsp` | `/app/index.jsp` | 呼ばれる |
| `/app/*.jsp` | `/app/admin` | 呼ばれない |
| `/app/*/test` | `/app/admin/test` | 呼ばれる |
| `/app/*/test` | `/app/test/` | 呼ばれない |

### 前方一致パターン（`//` 使用）

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/app//` | `/` | 呼ばれない |
| `/app//` | `/app/` | 呼ばれる |
| `/app//` | `/app/admin/` | 呼ばれる |
| `/app//` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.html` | 呼ばれない（`*.jsp` がマッチしない） |

<details>
<summary>keywords</summary>

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, リクエストパスフィルタリング, Globパターン, ハンドラ実行制限, リクエストパスパターン指定

</details>

## ハンドラ処理フロー

## 往路処理

1. **ハンドラ実行判定**: リクエストオブジェクトからリクエストパスを取得し、設定された実行対象リクエストパスパターンと合致するか判定
2. **実行対象外**: パターン不一致の場合、後続ハンドラに処理移譲し結果を取得
3. **実行対象**: パターン一致の場合、委譲対象ハンドラに処理を委譲し結果を取得

## 復路処理

4. **正常終了**: 往路2または3の結果をリターン

## 例外処理

後続ハンドラまたは委譲対象ハンドラの処理中にエラーが発生した場合、特段の例外処理を行わず、例外をそのまま送出

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, リクエストパスマッチング, 委譲対象ハンドラ

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | 説明 |
|---|---|---|---|
| handler | Handler | ○ | 委譲対象ハンドラ |
| requestPattern | String | ○ | 委譲対象ハンドラを実行するリクエストパスのパターン |

### 設定例（画面オンライン処理）

宣言的トランザクション制御の対象範囲を `/action` 配下に限定する場合：

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action//"/>
  <property name="handler" ref="transactionManagementHandler"/>
</component>
```

### 設定例（複数パッケージ）

単一のリクエストハンドラエントリでは異なるベースパッケージへのディスパッチが不可。ss11AA をベースパッケージに指定した場合のディスパッチ範囲は以下のとおり：

```
nablarch
   +-sample
       +- ss11AA <-- ベースパッケージ
       |     +- RM11AA0101Action   <-- 委譲可
       |     +- RM11AA0102Action   <-- 委譲可
       +- ss99ZZ
             +- RM99ZZ0101Action   <-- 委譲不可
```

複数のリクエストハンドラエントリを使用することで、複数のベースパッケージ配下のクラスへのディスパッチが可能：

```xml
<!-- サブシステムss11AA向け -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/RM11AA*"/>
  <property name="handler">
    <component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
      <property name="basePackage" value="nablarch.sample.ss11AA" />
      <property name="immediate" value="false" />
    </component>
  </property>
</component>

<!-- サブシステムss99ZZ向け -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/RM99ZZ*"/>
  <property name="handler">
    <component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
      <property name="basePackage" value="nablarch.sample.ss99ZZ" />
      <property name="immediate" value="false" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

handler, requestPattern, RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, 設定項目, 複数パッケージ, basePackage, immediate

</details>
