# リクエストハンドラエントリ

## リクエストハンドラエントリ

**クラス名**: `nablarch.fw.RequestHandlerEntry`

対象ハンドラをラップし、特定の [リクエストパス](../../about/about-nablarch/about-nablarch-concept.md) に対してのみ実行できるハンドラ。

**リクエストパスのパターン指定**

"/"で区切られた階層構造（URI、Unixシステムパス、Javaの名前空間等）を想定。ハンドラを実行するリクエストパスのパターンをGlob式に似た書式で指定できる。

1. ワイルドカード指定はUnix/DOSのGlob式に準じる。`*`はワイルドカードで`.`と`/`を除く任意の文字の任意個の列にマッチする。

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/` | `/` | 呼ばれる |
| `/` | `/index.jsp` | 呼ばれない |
| `/*` | `/` | 呼ばれる |
| `/*` | `/app` | 呼ばれる |
| `/*` | `/app/` | 呼ばれない（`*`は`/`にはマッチしない） |
| `/*` | `/index.jsp` | 呼ばれない（`*`は`.`にはマッチしない） |
| `/app/*.jsp` | `/app/index.jsp` | 呼ばれる |
| `/app/*.jsp` | `/app/admin` | 呼ばれない |
| `/app/*/test` | `/app/admin/test` | 呼ばれる |
| `/app/*/test` | `/app/test/` | 呼ばれない |

2. 最後尾の`/`が`//`と重ねられている場合、それ以前の文字列について前方一致すればマッチ成功（サブディレクトリ全体にマッチ）。リソース名を表す`//`以降の文字列については別途マッチ判定が行われる。

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/app//` | `/` | 呼ばれない |
| `/app//` | `/app/` | 呼ばれる |
| `/app//` | `/app/admin/` | 呼ばれる |
| `/app//` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/admin/index.jsp` | 呼ばれる |
| `//*.jsp` | `/app/index.html` | 呼ばれない（`*.jsp`がマッチしない） |

<details>
<summary>keywords</summary>

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, リクエストパスのパターン指定, Glob式, ワイルドカード, リクエストハンドラエントリ, サブディレクトリ全体マッチ

</details>

## ハンドラ処理フロー

**往路処理**

1. (ハンドラ実行判定) リクエストパスを取得し、設定された**実行対象リクエストパスパターン**と合致するか判定する。
2. (実行対象外) パターンが合致しない場合は後続ハンドラに処理移譲し、その結果を取得する。
3. (実行対象) パターンが合致した場合は**委譲対象ハンドラ**に処理委譲し、その結果を取得する。

**復路処理**

4. (正常終了) 2.または3.の結果をリターンして終了する。

**例外処理**

- (エラー終了) 後続ハンドラまたは委譲対象ハンドラの処理中にエラーが発生した場合、例外処理は行わず例外をそのまま送出する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 委譲対象ハンドラ, 実行対象リクエストパスパターン, 往路処理, 復路処理, 例外処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | 備考 |
|---|---|---|---|
| handler | Handler | ○ | 委譲対象ハンドラ |
| requestPattern | String | ○ | 委譲対象ハンドラを実行するリクエストパスのパターン |

**設定例（画面オンライン処理）**

宣言的トランザクション制御の対象範囲を特定パス(`/action`)配下に限定する場合：

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action//"/>
  <property name="handler" ref="transactionManagementHandler"/>
</component>
```

**設定例（複数パッケージ使用）**

単一のリクエストハンドラエントリでは、ベースパッケージが異なるパッケージへのディスパッチはできない。異なるリクエストパスにマッチする複数のリクエストハンドラエントリを使用することで、複数のベースパッケージ配下のクラスにディスパッチできる。

```xml
<!-- サブシステムss11AA向け -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/RM11AA*"/>
  <property name="handler">
    <component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
      <property name="basePackage" value="nablarch.sample.ss11AA" />
      <property name="immediate"   value="false" />
    </component>
  </property>
</component>

<!-- サブシステムss99ZZ向け -->
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/RM99ZZ*"/>
  <property name="handler">
    <component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
      <property name="basePackage" value="nablarch.sample.ss99ZZ" />
      <property name="immediate"   value="false" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

handler, requestPattern, RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, 設定項目, 複数パッケージ, basePackage

</details>
