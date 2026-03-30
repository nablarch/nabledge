# HTTPリクエストディスパッチハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.HttpRequestJavaPackageMapping`

画面オンライン処理におけるリクエストパス中のベースURIをJavaパッケージ階層にマッピングし、動的に委譲先ハンドラを決定するディスパッチ処理を行う。

[RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) を直接継承しており、以下の2点のみ異なる:

1. ディスパッチ対象クラスが確定した時点で、HTTPアクセスログにその内容を出力する。
2. ベースパス設定時にURLの書式精査を行うアクセサ(`#setBaseUri()`)を追加。

その他の機能詳細は [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) を参照。

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, nablarch.fw.handler.HttpRequestJavaPackageMapping, RequestPathJavaPackageMapping, HTTPリクエストディスパッチ, ベースURI, Javaパッケージマッピング, HTTPアクセスログ, setBaseUri

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | | "" | ベースURI |
| basePackage | String | | "" | ベースパッケージ |
| immediate | boolean | | true | ハンドラ追加位置 |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry | | null | リクエストパスのパターンとマッピング先Javaパッケージの組み合わせ |

**設定例**: ベースURI `/webapp/sample` をパッケージ `nablarch.sample.apps` にマッピングする場合:

```xml
<component class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri"    value="/webapp/sample" />
  <property name="basePackage" value="nablarch.sample.apps" />
</component>
```

上記設定時のディスパッチ例:

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /webapp/sample/AdminApp | nablarch.sample.apps.AdminApp |
| /webapp/sample/user/UserApp | nablarch.sample.apps.user.UserApp |

<details>
<summary>keywords</summary>

baseUri, basePackage, immediate, optionalPackageMappingEntries, JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, nablarch.fw.web.handler.HttpRequestJavaPackageMapping, 設定項目, ディスパッチ設定例

</details>
