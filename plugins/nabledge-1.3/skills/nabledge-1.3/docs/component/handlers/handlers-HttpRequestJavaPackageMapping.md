## HTTPリクエストディスパッチハンドラ

**クラス名:** `nablarch.fw.handler.HttpRequestJavaPackageMapping`

-----

### 概要

このハンドラは、画面オンライン処理におけるリクエストパス中の部分文字列(ベースURI)をJavaパッケージ階層にマッピングすることで、
動的に委譲先ハンドラを決定するディスパッチ処理を行う。

本ハンドラの実装は [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) を直接継承しており、その機能は以下の2点を除けば全く同じものである。

1. ディスパッチ対象のクラスが確定した時点で、HTTPアクセスログにその内容を出力する。
2. ベースパスを設定する際にURLの書式精査を行うアクセサ(**#setBaseUri()**)を追加。

機能の詳細については、 [リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) を参照すること。

-----

**ハンドラ処理概要**

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 |
|---|---|---|---|---|---|---|
| HTTPリクエストパスによるディスパッチハンドラ | nablarch.fw.handler.HttpRequestJavaPackageMapping | HttpRequest | Object | HTTPリクエストパスをもとに業務アクションを決定しハンドラキューに追加する。HTTPメソッドによるメソッド単位のディスパッチを行う。(HttpMethodBinding) | - | - |

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ベースURI | baseUri | String | 任意指定 (デフォルト = "") |
| ベースパッケージ | basePackage | String | 任意指定 (デフォルト = "") |
| ハンドラ追加位置 | immediate | boolean | 任意指定 (デフォルト = true) |
| リクエストパスのパターンとマッピング先 Javaパッケージの組み合わせ | optionalPackageMappingEntries | nablarch.fw.handler .JavaPackageMappingEntry | 任意指定 (デフォルト = null) |

**設定例**

以下の設定では、画面オンライン処理のリクエストパス中のベースURI（コンテキストルート） **/webapp/sample** を、
Javaパッケージ **nablarch.sample.apps** に対応させている。

```xml
<!-- ディスパッチ -->
<component class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri"    value="/webapp/sample" />
  <property name="basePackage" value="nablarch.sample.apps" />
</component>
```

上記設定を行った場合のディスパッチの例を以下に示す。

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /webapp/sample/AdminApp | nablarch.sample.apps.AdminApp |
| /webapp/sample/user/UserApp | nablarch.sample.apps.user.UserApp |
