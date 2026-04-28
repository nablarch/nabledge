# 使用許可API一覧作成ツール

## 概要

本ツールは、使用不許可APIチェックツールの設定ファイルとなる公開APIの一覧と、公開APIのJavadocを生成する。

生成される使用許可API一覧をそのまま「使用不許可APIチェックツール」の設定ファイルとして利用することで、
プロジェクトで実装した基盤部品などについて、業務アプリからの利用を想定していない非公開APIが利用されていないかどうかを使用不許可APIチェックツールを利用してチェックすることができる。

## 使用方法

本ツールは、Javadocを生成する際に利用するDocletとして提供される。

Javadoc生成時に以下のDocletを利用し、必要なオプションを渡すことで使用許可API一覧および使用許可APIのみが出力されているJavadocが生成される。

なお、実行時にはNablarch Application Framework, Nablarch ToolboxおよびJDKに付属のtools.jarをdocletpathに指定する必要がある。

**本ツールが提供するDoclet**

nablarch.tool.published.doclet.PublishedDoclet

**必要な引数**

| 引数 | 説明 | 必須 |
|---|---|---|
| output | 使用許可API一覧の出力先ファイルを指定する。 使用不許可APIチェックツールの設定ファイルとして利用する場合には、拡張子を **config** とすること。 | ○ |
| tag | 出力対象とするタグを指定する。カンマ区切りで複数指定することができる。 | × |

**出力対象**

nablarch.core.util.annotation.Publishedアノテーションの付与された、

* クラス
* コンストラクタ
* メソッド
* フィールド
* アノテーション

が出力対象となる。

引数tagに出力対象タグが指定されている場合、該当するtag属性が指定されているPublishedアノテーションが付与されたものと、
tag属性が指定されていないPublishedアノテーションが付与されたものが出力対象となる。

引数tagが指定されない場合には、tag属性が指定されていないPublishedアノテーションが付与されたものが出力対象となる。

### Ant Javadocタスクの設定方法

本ツールを利用してAntのJavadocタスクを実行する場合は、javadocタグ内で以下のように設定すればよい。

| 設定項目 | 設定値 | 備考 |
|---|---|---|
| **docletタグ** |  |  |
| docletタグのname属性 | nablarch.tool.published.doclet.PublishedDoclet |  |
| docletタグのpath属性 | nablarch.jar, nablarch-toolbox.jar, tools.jar のパス（;区切り） | pathref属性で、pathタグのidを指定しても可 |
| **docletタグ内のparamタグ（出力先ファイルを指定）** |  |  |
| paramタグのname属性 | -output | 必ず設定する必要がある |
| paramタグのvalue属性 | 出力先ファイル |  |
| **docletタグ内のparamタグ（出力対象タグを指定）** |  |  |
| paramタグのname属性 | -tag | 引数tagを指定しない場合は、このparamタグは不要 |
| paramタグのvalue属性 | 出力対象とするタグ |  |

実際のAntファイルの例を以下に記載する。

ただし、以下の例では、本ツールの設定に必要な項目のみ設定している。Javadocタスクに必要なその他の設定については、
[Ant Javadoc Task](http://ant.apache.org/manual/Tasks/javadoc.html) を参照すること。

```xml
<!-- 本ツールの実行時にクラスパスに含める必要があるパスを定義する。-->
<!-- 以下は、Nablarch_totorialワークスペースの場合の値。実際に利用する際には適切な値に修正すること。 -->
<path id="lib.path">
  <!-- nablarch.jarをクラスパスに含める。-->
  <pathelement location="main/web/WEB-INF/lib/nablarch.jar" />
  <!-- Nablarch Toolboxをクラスパスに含める。 -->
  <pathelement location="tool_lib/nablarch-toolbox.jar" />
  <!-- Oracle JDK付属の tools.jar をクラスパスに含める。 -->
  <pathelement location="tool_lib/tools.jar" />
</path>

<javadoc>
  <!-- docletタグで、使用許可API一覧作成ツールのDocletクラスと、必要なクラスパスを設定する。 -->
  <doclet name="nablarch.tool.published.doclet.PublishedDoclet" pathref="lib.path">
    <!-- 出力対象とするタグを指定する。指定しない場合には不要。 -->
    <param name="-tag" value="architect"/>
    <!-- 使用許可API一覧の出力先ファイルを指定する。 -->
    <param name="-output" value="ProjectOpenApiForArchitect.config"/>
  </doclet>
</javadoc>
```
