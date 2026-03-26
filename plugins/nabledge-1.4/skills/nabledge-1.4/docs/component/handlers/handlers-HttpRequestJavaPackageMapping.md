# HTTPリクエストディスパッチハンドラ

## 

**クラス名**: `nablarch.fw.web.handler.HttpRequestJavaPackageMapping`

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, nablarch.fw.web.handler.HttpRequestJavaPackageMapping, HTTPリクエストディスパッチ, ディスパッチハンドラ

</details>

## 概要

画面オンライン処理のリクエストパス中のベースURI（部分文字列）をJavaパッケージ階層にマッピングし、委譲先ハンドラを動的に決定するディスパッチハンドラ。

実装は [RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) に委譲。[RequestPathJavaPackageMapping](handlers-RequestPathJavaPackageMapping.md) との相違点:
1. ディスパッチ対象クラス確定時に、HTTPアクセスログへその内容を出力する
2. `#setBaseUri()` でベースパス設定時にURLの書式精査を行う

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, HTTPアクセスログ, リクエストパスマッピング, ベースURI, Javaパッケージマッピング, setBaseUri

</details>

## 

**ハンドラ処理概要**

ハンドラキュー: `HttpRequestJavaPackageMapping`

<details>
<summary>keywords</summary>

HttpRequestJavaPackageMapping, ハンドラ処理概要, ハンドラキュー

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| baseUri | String | | "" | ベースURI |
| basePackage | String | | "" | ベースパッケージ |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry | | null | リクエストパスパターンとマッピング先Javaパッケージの組み合わせ |

```xml
<component class="nablarch.fw.web.handler.HttpRequestJavaPackageMapping">
  <property name="baseUri"    value="/webapp/sample" />
  <property name="basePackage" value="nablarch.sample.apps" />
</component>
```

ディスパッチ例（baseUri=`/webapp/sample`、basePackage=`nablarch.sample.apps`）:

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /webapp/sample/AdminApp | nablarch.sample.apps.AdminApp |
| /webapp/sample/user/UserApp | nablarch.sample.apps.user.UserApp |

<details>
<summary>keywords</summary>

baseUri, basePackage, optionalPackageMappingEntries, JavaPackageMappingEntry, 設定項目, ディスパッチ設定

</details>
