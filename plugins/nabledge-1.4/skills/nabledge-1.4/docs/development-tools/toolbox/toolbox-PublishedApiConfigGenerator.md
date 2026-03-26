# 使用許可API一覧作成ツール

## 使用許可API一覧作成ツールの概要と使用方法

使用不許可APIチェックツールの設定ファイルとなる公開APIの一覧と公開APIのJavadocを生成するツール。生成した使用許可API一覧を「使用不許可APIチェックツール」の設定ファイルとして利用できる。

**配置場所**: `tool_lib/nablarch-toolbox.jar`（nablarch-toolbox.jarの一部）

**Docletクラス**: `nablarch.tool.published.doclet.PublishedDoclet`

実行時にNablarch Application Framework、Nablarch Toolbox、tools.jarをdocletpathに指定する必要がある。

**引数**:

| 引数 | 説明 | 必須 |
|---|---|---|
| output | 使用許可API一覧の出力先ファイル。使用不許可APIチェックツールの設定ファイルとして利用する場合は拡張子を **config** とすること | ○ |
| tag | 出力対象タグ（カンマ区切りで複数指定可） | × |

**出力対象**: `nablarch.core.util.annotation.Published`アノテーション付与のクラス、コンストラクタ、メソッド、フィールド、アノテーション

- tag引数指定時: 該当tag属性のPublishedアノテーション付与のもの + tag属性なしのPublishedアノテーション付与のもの
- tag引数未指定時: tag属性なしのPublishedアノテーション付与のもののみ

**Ant Javadocタスク設定例**:

ただし、以下の例では、本ツールの設定に必要な項目のみ設定している。Javadocタスクに必要なその他の設定については、[Ant Javadoc Task](http://ant.apache.org/manual/Tasks/javadoc.html) を参照すること。

```xml
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

PublishedDoclet, nablarch.tool.published.doclet.PublishedDoclet, @Published, nablarch.core.util.annotation.Published, 使用許可API一覧作成ツール, 使用不許可APIチェックツール設定ファイル生成, Javadoc生成, 公開API一覧

</details>

## docletタグ

Ant JavadocタスクにおけるdocletタグのAnt設定:

| 設定項目 | 設定値 | 備考 |
|---|---|---|
| name属性 | `nablarch.tool.published.doclet.PublishedDoclet` | |
| path属性 | nablarch.jar、nablarch-toolbox.jar、tools.jarのパス（;区切り） | pathref属性でpathタグのidを指定しても可 |

<details>
<summary>keywords</summary>

Ant Javadocタスク docletタグ設定, nablarch.tool.published.doclet.PublishedDoclet, docletpath設定, nablarch-toolbox.jar

</details>

## docletタグ内のparamタグ（出力先ファイルを指定）

Ant Javadocタスクのdocletタグ内paramタグ（出力先ファイル指定）の設定:

| 設定項目 | 設定値 | 備考 |
|---|---|---|
| name属性 | `-output` | 必ず設定する必要がある |
| value属性 | 出力先ファイルパス | |

<details>
<summary>keywords</summary>

-output, 使用許可API一覧出力先ファイル指定, configファイル出力

</details>

## docletタグ内のparamタグ（出力対象タグを指定）

Ant Javadocタスクのdocletタグ内paramタグ（出力対象タグ指定）の設定:

| 設定項目 | 設定値 | 備考 |
|---|---|---|
| name属性 | `-tag` | tag引数を指定しない場合、このparamタグは不要 |
| value属性 | 出力対象とするタグ | |

<details>
<summary>keywords</summary>

-tag, 出力対象タグ指定, Publishedアノテーション タグフィルタ

</details>
