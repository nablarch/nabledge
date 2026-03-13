# Nablarch 5u7 リリースノート

**公式ドキュメント**: [Nablarch 5u7 リリースノート](https://fintan.jp/page/252/)

## アプリケーションフレームワーク 変更点

## Nablarch 5u7 アプリケーションフレームワーク 変更点

5u6からの変更点。アプリケーションへの影響が「あり」の項目は個別に対処が必要。

### 1. ResourceLocatorで発生する可能性のあるStackOverflowErrorへの対応

- **分類**: ウェブアプリケーション / 不具合
- **修正モジュール**: nablarch-fw-web 1.2.3（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: あり

> **重要**: 複雑な正規表現を削除したため以下が削除（仕様変更）された。
> - publicフィールド `SYNTAX` を削除
> - メソッド `isValidPath` を削除
>
> これらを使用している場合は、旧バージョンのソースコードから実装をプロジェクト側に移植すること。

### 2. プリミティブ配列を値に持つMapをログにダンプできるように変更

- **分類**: ログ出力 / 不具合
- **修正モジュール**: nablarch-core 1.2.3（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: なし

LogUtilを使ってプリミティブ配列を値に持つMapをダンプすると`ClassCastException`が発生する問題を修正。

### 3. 複数の値を出力するタグでプリミティブ配列を扱えるように修正

- **分類**: JSPカスタムタグ / 不具合
- **修正モジュール**: nablarch-fw-web-tag 1.0.4（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: なし

複数値出力タグで対象がプリミティブ配列として保持されている場合に`ClassCastException`が発生する問題を修正。

### 4. n:textareaで表示するデータの先頭改行が削除されないように修正

- **分類**: JSPカスタムタグ / 不具合
- **修正モジュール**: nablarch-fw-web-tag 1.0.4（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: あり

> **重要**: n:textareaタグで先頭の改行が削除されることを前提にアプリケーションで何らかの処理を入れている場合は、その処理を削除する必要がある。

### 5. 配列要素の孫要素を出力できない問題に対応

- **分類**: 汎用データフォーマット / 不具合
- **修正モジュール**: nablarch-core-dataformat 1.0.2（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: なし

`element(配列)->child->grandchild` のように配列要素から孫要素があるXMLを出力すると子要素が見つからないエラーが発生していた問題を修正。

### 6. 属性を持つ要素にコンテンツを定義できない問題に対応

- **分類**: 汎用データフォーマット / 不具合
- **修正モジュール**: nablarch-core-dataformat 1.0.2（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: あり

フォーマット定義ファイルでコンテンツを表すフィールドのフィールド名を `body` とすることで属性を持つ要素にコンテンツを定義できるようになった。

> **重要**: 要素名が `body` となる要素を持つXMLの入出力を想定している場合に対処が必要。例：
> ```xml
> <root>
>   <child>
>     <body>value</body>
>   </child>
> </root>
> ```
> このようなXMLを扱う場合は参照先ドキュメント（汎用データフォーマット: XMLで属性を持つ要素にコンテンツを定義する）を参照して変更すること。

フォーマット定義ファイル例:
```
[root]
1 child OB
[child]
1 @attr X
2 body X
```

対応するXML例:
```xml
<root>
  <child attr="value1">value2</child>
</root>
```

### 7. BeanUtilでnullの要素を１つだけ持つプロパティの値をコピーできない不具合に対応

- **分類**: 汎用ユーティリティ / 不具合
- **修正モジュール**: nablarch-core-beans 1.1.3（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: なし（条件によっては影響あり）

以下の条件に該当する場合にコピーできない問題を修正（コピー先にnullをコピーするよう対応）:
- コピー元の型が配列型
- コピー先が非配列型
- コピー元の配列の値がサイズ1でnull

> **注意**: BeanUtilを使用しており、アプリケーションでリクエストパラメータの値をnullに変更している処理がある場合は影響を受ける可能性がある。影響を受ける処理がある場合は処理を見直すこと。

### 8. Interceptor.Implを公開APIに変更

- **分類**: インターセプタ / 変更
- **修正モジュール**: nablarch-core 1.2.3
- **アプリケーションへの影響**: なし

`Interceptor.Impl`は非公開APIだったが、アプリケーションでInterceptorを作成する際に継承が必要なため公開APIに変更した。

### 9. nablarch-bomに定義されているnablarch-wmq-adaptorのバージョンが誤っていたので修正

- **分類**: Mavenプロファイル / 不具合
- **修正モジュール**: nablarch-profiles 5u7（起因バージョン: 5u6）
- **アプリケーションへの影響**: なし

修正前: nablarch-wmq-adaptor 1.0.0 → 修正後: 1.0.1

### 10. モジュールのバイトコードをJava6に準拠するように修正

- **分類**: フレームワーク / 不具合
- **アプリケーションへの影響**: あり（アプリケーション側の対処は不要）

以下モジュールのバイトコードがJava7準拠だったためJava6準拠に修正:

| モジュール | 修正後バージョン | 起因バージョン |
|---|---|---|
| nablarch-core-validation-ee | 1.0.4 | 1.0.3 |
| nablarch-etl | 1.0.2 | 1.0.1 |
| nablarch-fw-batch-ee | 1.0.2 | 1.0.1 |
| nablarch-fw-jaxrs | 1.0.2 | 1.0.1 |
| nablarch-jackson-adaptor | 1.0.2 | 1.0.1 |
| nablarch-jersey-adaptor | 1.0.2 | 1.0.1 |
| nablarch-resteasy-adaptor | 1.0.2 | 1.0.1 |

### 11. XML、JSONで使用可能なデータタイプ名が誤っていたので修正（解説書）

- **分類**: 汎用データフォーマット / 不具合（解説書）
- **起因バージョン**: 5u6
- **アプリケーションへの影響**: なし

XML及びJSONで使用可能なデータタイプ名の記載を修正: 誤 `XS9` → 正 `SX9`

### 12. 空白を含むパスを使用できない仕様を追記（解説書）

- **分類**: ファイルパス管理 / 不具合（解説書）
- **起因バージョン**: 5u6
- **アプリケーションへの影響**: なし

空白を含むパスを使用できない仕様をドキュメントに追記（「ディレクトリと拡張子を設定する」のポイントに追記）。

<details>
<summary>keywords</summary>

5u7, リリースノート, ResourceLocator, StackOverflowError, SYNTAX, isValidPath, LogUtil, ClassCastException, プリミティブ配列, n:textarea, 先頭改行, 汎用データフォーマット, bodyフィールド, BeanUtil, null配列コピー, Interceptor, Interceptor.Impl, バイトコード, Java6, nablarch-fw-web, nablarch-fw-web-tag, nablarch-core-dataformat, nablarch-core-beans, nablarch-core, nablarch-profiles, nablarch-wmq-adaptor, nablarch-core-validation-ee, nablarch-etl, nablarch-fw-batch-ee, nablarch-fw-jaxrs, nablarch-jackson-adaptor, nablarch-jersey-adaptor, nablarch-resteasy-adaptor, アプリケーションへの影響, ウェブアプリケーション, ログ出力, JSPカスタムタグ

</details>

## テスティングフレームワーク 変更点

## Nablarch 5u7 テスティングフレームワーク 変更点

### 13. アクションの返すパスのアサート方法を変更

- **分類**: テスティングフレームワーク / 不具合
- **修正モジュール**: nablarch-testing 1.0.7（起因バージョン: 1.0.0）
- **アプリケーションへの影響**: あり

Webアプリケーションのアクションが返す`HttpResponse`のパスアサート方法を変更:
- **変更前**: http(https)を示すパスの場合、ホスト名を除いた部分をアサート
- **変更後**: ホスト名を含む全体をアサート

> **重要**: 期待値のパスだけではなくホストを含む完全なパスに変更すること。
>
> 例: アクションが `return new HttpResponse("https://calendar.google.com/calendar");` を返す場合、期待値は `https://calendar.google.com/calendar` と完全なパスで設定する。

<details>
<summary>keywords</summary>

5u7, テスティングフレームワーク, HttpResponse, パスアサート, ホスト名, nablarch-testing, アプリケーションへの影響, 期待値

</details>

## バージョンアップ手順

## Nablarch 5u7 バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションに指定されている`nablarch-bom`のバージョンを`5u7`に書き換える
2. Mavenのビルドを再実行する

<details>
<summary>keywords</summary>

5u7, バージョンアップ, pom.xml, nablarch-bom, dependencyManagement, Maven

</details>
