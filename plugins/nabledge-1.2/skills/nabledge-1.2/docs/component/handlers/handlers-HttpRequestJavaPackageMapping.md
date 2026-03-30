# HTTPリクエストディスパッチハンドラ

**公式ドキュメント**: [HTTPリクエストディスパッチハンドラ]()

## 概要

**クラス名**: `nablarch.fw.handler.HttpRequestJavaPackageMapping`

画面オンライン処理のリクエストパス中のベースURIをJavaパッケージ階層にマッピングし、委譲先ハンドラを動的に決定するディスパッチハンドラ。[RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) を直接継承しており、以下2点のみ異なる:

1. ディスパッチ対象クラス確定時にHTTPアクセスログへその内容を出力する
2. ベースパス設定時にURLの書式精査を行うアクセサ(`#setBaseUri()`)を追加

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, nablarch.fw.handler.HttpRequestJavaPackageMapping, RequestPathJavaPackageMapping, setBaseUri, ディスパッチ, HTTPアクセスログ, リクエストパスマッピング

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | | "" | ベースURI |
| basePackage | String | | "" | ベースパッケージ |
| immediate | boolean | | true | ハンドラ追加位置 |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry | | null | リクエストパスのパターンとマッピング先Javaパッケージの組み合わせ |

```xml
<component class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri"    value="/webapp/sample" />
  <property name="basePackage" value="nablarch.sample.apps" />
</component>
```

ディスパッチ例（baseUri=/webapp/sample、basePackage=nablarch.sample.apps の場合）:

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /webapp/sample/AdminApp | nablarch.sample.apps.AdminApp |
| /webapp/sample/user/UserApp | nablarch.sample.apps.user.UserApp |

<details>
<summary>keywords</summary>

baseUri, basePackage, immediate, optionalPackageMappingEntries, nablarch.fw.handler.JavaPackageMappingEntry, ベースURI, ベースパッケージ, ディスパッチ設定, XML設定例

</details>
