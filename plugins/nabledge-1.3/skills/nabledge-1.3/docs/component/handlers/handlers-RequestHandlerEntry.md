# リクエストハンドラエントリ

## 概要とリクエストパスパターン指定

**クラス名**: `nablarch.fw.RequestHandlerEntry`

ハンドラをラップし、特定の [リクエストパス](../../about/about-nablarch/about-nablarch-concept.md) に対してのみ実行させる。

**リクエストパスのパターン指定**

パターンは **Glob式** に似た書式で指定。`*` はワイルドカードで `.` と `/` を除く任意の文字の任意個の列にマッチ。

| requestPattern | リクエストパス | 結果 |
|---|---|---|
| `/` | `/` | 呼ばれる |
| `/` | `/index.jsp` | 呼ばれない |
| `/*` | `/` | 呼ばれる |
| `/*` | `/app` | 呼ばれる |
| `/*` | `/app/` | 呼ばれない（`*`は`/`にマッチしない） |
| `/*` | `/index.jsp` | 呼ばれない（`*`は`.`にマッチしない） |
| `/app/*.jsp` | `/app/index.jsp` | 呼ばれる |
| `/app/*.jsp` | `/app/admin` | 呼ばれない |
| `/app/*/test` | `/app/admin/test` | 呼ばれる |
| `/app/*/test` | `/app/test/` | 呼ばれない |

末尾の`/`が`//`と重ねられた場合、それ以前の文字列について前方一致すればマッチ（サブディレクトリ全体にマッチ）。リソース名を表す`//`以降の文字列については別途マッチ判定が行われる。

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

RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, リクエストハンドラエントリ, リクエストパスパターン, Glob式, ワイルドカード, サブディレクトリ前方一致

</details>

## ハンドラ処理フロー

**往路処理**

1. リクエストオブジェクトからリクエストパスを取得し、設定された **実行対象リクエストパスパターン** と合致するか判定
2. パターンが合致しない場合: 後続ハンドラに処理委譲し結果取得
3. パターンが合致した場合: 設定された **委譲対象ハンドラ** に処理委譲し結果取得

**復路処理**

4. 上記2.または3.の結果をリターンして終了

**例外処理**

後続ハンドラまたは委譲対象ハンドラの処理中にエラーが発生した場合、特段の例外処理は行わずそのまま例外を送出する。

<details>
<summary>keywords</summary>

ハンドラ処理フロー, 往路処理, 復路処理, 例外処理, リクエストパス判定, 委譲対象ハンドラ, 実行対象リクエストパスパターン

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| handler | Handler | ○ | | 委譲対象ハンドラ |
| requestPattern | String | ○ | | 委譲対象ハンドラを実行するリクエストパスのパターン |

**画面オンライン処理での設定例**（宣言的トランザクション制御の対象範囲を`/action`配下に限定）

```xml
<component class="nablarch.fw.RequestHandlerEntry">
  <property name="requestPattern" value="/action//"/>
  <property name="handler" ref="transactionManagementHandler"/>
</component>
```

**複数パッケージ設定例**

単一のリクエストハンドラエントリでは、ベースパッケージが異なるパッケージへのディスパッチが不可。異なるリクエストパスにマッチする複数のエントリを使用することで、複数のベースパッケージ配下のクラスにディスパッチできる。

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

handler, requestPattern, immediate, RequestHandlerEntry, nablarch.fw.RequestHandlerEntry, RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, トランザクション制御, 複数パッケージ, ディスパッチ, basePackage

</details>
