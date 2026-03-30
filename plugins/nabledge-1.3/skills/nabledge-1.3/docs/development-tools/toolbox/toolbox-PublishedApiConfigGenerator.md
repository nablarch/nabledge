# 使用許可API一覧作成ツール

## 概要

使用不許可APIチェックツールの設定ファイルとなる公開APIの一覧と、公開APIのJavadocを生成するツール。

生成した使用許可API一覧を「使用不許可APIチェックツール」の設定ファイルとして利用することで、プロジェクトで実装した基盤部品などについて、業務アプリからの利用を想定していない非公開APIが使われていないかチェックできる。

<details>
<summary>keywords</summary>

使用許可API一覧作成ツール, 使用不許可APIチェックツール, 公開API一覧生成, Javadoc生成, Published, 基盤部品, プロジェクト実装

</details>

## 使用方法

**Docletクラス**: `nablarch.tool.published.doclet.PublishedDoclet`

実行時に `nablarch.jar`、`nablarch-toolbox.jar`、`tools.jar` を `docletpath` に指定する必要がある。

**引数**

| 引数 | 説明 | 必須 |
|---|---|---|
| output | 使用許可API一覧の出力先ファイルを指定する。使用不許可APIチェックツールの設定ファイルとして利用する場合は拡張子を **config** にする。 | ○ |
| tag | 出力対象とするタグをカンマ区切りで複数指定可能。 | × |

**出力対象**

`nablarch.core.util.annotation.Published` アノテーションが付与されたクラス、コンストラクタ、メソッド、フィールド、アノテーション。

- `tag` 指定あり: 指定タグ属性付き `Published` アノテーションの付与されたものと、`tag` 属性なし `Published` アノテーションの付与されたものが対象
- `tag` 指定なし: `tag` 属性なし `Published` アノテーションの付与されたもののみが対象

<details>
<summary>keywords</summary>

PublishedDoclet, nablarch.tool.published.doclet.PublishedDoclet, nablarch.core.util.annotation.Published, output, tag, docletpath, 使用許可API一覧設定ファイル

</details>

## Ant Javadocタスクの設定方法

AntのJavadocタスクで本ツールを利用する場合の設定。

| 設定項目 | 設定値 | 備考 |
|---|---|---|
| docletタグ name属性 | `nablarch.tool.published.doclet.PublishedDoclet` | |
| docletタグ path属性 | nablarch.jar, nablarch-toolbox.jar, tools.jar のパス（;区切り） | pathref属性でpathタグのid指定も可 |
| paramタグ name属性（出力先指定） | `-output` | 必須 |
| paramタグ value属性（出力先指定） | 出力先ファイルパス | |
| paramタグ name属性（タグ指定） | `-tag` | tagを指定しない場合は不要 |
| paramタグ value属性（タグ指定） | 出力対象とするタグ | |

```xml
<!-- 本ツールの実行時にクラスパスに含める必要があるパスを定義する。-->
<path id="lib.path">
  <pathelement location="main/web/WEB-INF/lib/nablarch.jar" />
  <pathelement location="tool_lib/nablarch-toolbox.jar" />
  <pathelement location="tool_lib/tools.jar" />
</path>

<javadoc>
  <doclet name="nablarch.tool.published.doclet.PublishedDoclet" pathref="lib.path">
    <param name="-tag" value="architect"/>
    <param name="-output" value="ProjectOpenApiForArchitect.config"/>
  </doclet>
</javadoc>
```

<details>
<summary>keywords</summary>

Ant Javadocタスク設定, javadocタグ, docletタグ, pathref, lib.path, path id, nablarch.jar, nablarch-toolbox.jar, tools.jar, param, -output, -tag

</details>
