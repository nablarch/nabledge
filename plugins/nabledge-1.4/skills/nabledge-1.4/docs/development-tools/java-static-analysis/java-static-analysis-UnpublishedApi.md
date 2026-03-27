# 使用不許可APIチェックツール

## 仕様

**前提条件**: Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

本ツールは公開API（使用を許可するAPI）以外の使用をチェックするツール。公開APIはホワイトリスト形式の設定ファイルで指定し、Nablarch導入プロジェクトのコーディング規約に従いカスタマイズ可能。

公開API以外の呼び出しは以下のルールでチェックを行う:

- 非公開クラスの参照（インスタンス化、クラスメソッドの呼び出し）
- 非公開メソッドの呼び出し
- 非公開例外の補足、及び送出

設定ファイルには次の単位で公開APIを指定できる:

- パッケージ
- クラスまたはインタフェース
- コンストラクタまたはメソッド

デフォルトで提供する設定ファイル:

| 設定ファイル名 | 概要 |
|---|---|
| JavaOpenApi.config | Nablarchが規定するJava標準ライブラリ使用可能API |
| NablarchApiForProgrammer.config | プログラマ向け Nablarch Application Framework 使用可能API（業務機能の実装に必要なAPI） |
| NablarchTFWApiForProgrammer.config | プログラマ向け Nablarch Testing Framework 使用可能API（業務機能のテストに必要なAPI） |
| NablarchApiForArchitect.config | アーキテクト向け Nablarch Application Framework 使用可能API（NAFの機能拡張などで利用する必要があるAPI） |
| NablarchTFWApiForArchitect.config | アーキテクト向け Nablarch Testing Framework 使用可能API（NTFの機能拡張などで利用する必要があるAPI） |

本ツールはFindBugsのカスタムルールとして提供する。AntタスクまたはEclipse Pluginとして通常のFindBugsと同様の方法で使用できる。

- バグコード：UPU
- バグタイプ：UPU_UNPUBLISHED_API_USAGE

<details>
<summary>keywords</summary>

非公開クラス参照チェック, 非公開メソッドチェック, 非公開例外チェック, FindBugsカスタムルール, UPU, UPU_UNPUBLISHED_API_USAGE, JavaOpenApi.config, NablarchApiForProgrammer.config, NablarchTFWApiForProgrammer.config, NablarchApiForArchitect.config, NablarchTFWApiForArchitect.config, ホワイトリスト, 公開API, Antタスク, EclipsePlugin, 前提条件, 開発環境構築

</details>

## 継承・インタフェース実装に関するチェック仕様

継承・インタフェース実装時のチェック仕様は通常と異なる。本ツールはインタフェース実装クラスへのアクセスはインタフェースを型として宣言していることを前提とする。

型として宣言されているクラス/インタフェースに対してチェックを行う:

```java
List list = new ArrayList();
list.add(test); // Listインタフェースのaddメソッドが公開されていることをチェックする

SuperClass varSuper = new SubClass();
varSuper.testMethod(); // SuperClass.testMethodが公開されていることをチェックする

SubClass varSub = new SubClass();
varSub.testMethod(); // SubClass.testMethod()が公開されていることをチェックする
```

宣言されているクラス/インタフェースに当該のAPIが定義されていない場合、親クラスまたはインタフェースを自クラスに近い方から順次検索し、最初に見つかったクラスのメソッドが公開されているか否かを判定する。

![継承クラス関係図](../../../knowledge/development-tools/java-static-analysis/assets/java-static-analysis-UnpublishedApi/InheritClasses.jpg)

```java
ClassC hoge = new ClassC();
hoge.methodA(); // 使用可能
hoge.methodB(); // 使用不可
```

<details>
<summary>keywords</summary>

継承チェック仕様, インタフェース実装, メソッド継承検索, API使用可否判定, SuperClass, SubClass, 宣言型によるチェック, ClassC

</details>

## 設定ファイル配置方法

設定ファイルの拡張子は `config` とする。設定ファイルディレクトリには複数の設定ファイルを配置可能。

> **警告**: 本ツールは使用されている全てのAPIをチェックするため、デフォルト設定ファイルのみでは自プロジェクトで宣言しているAPIもチェック対象となる。**デフォルトの2つの設定ファイルとは別に、自プロジェクト用の設定ファイルを設定ファイルディレクトリに配置し、自プロジェクトのパッケージを一意に特定できるパッケージを記述すること。**
>
> 例：全パッケージが `jp.co.tis.sample` で始まる場合、`jp.co.tis.sample` と記述したテキストファイルを1つ配置する。

プロダクションコード/テストコードごとに設定ファイルディレクトリを分けて配置する:

```
<ワークスペース>
├─<プロジェクト>
│  ├─tool
│  │  └─staticanalysis
│  │     ├─production（プロダクションコード用設定ファイルディレクトリ）
│  │     │  └─ NablarchApiForProgrammer.config
│  │     └─test（テストコード用設定ファイルディレクトリ）
│  │        ├─ NablarchApiForProgrammer.config
│  │        └─ NablarchTFWApiForProgrammer.config
```

フレームワーク拡張コードの場合は `NablarchApiForArchitect.config`、`NablarchTFWApiForArchitect.config` を使用する。

<details>
<summary>keywords</summary>

設定ファイル配置, config拡張子, 自プロジェクト設定, プロダクションコード設定, テストコード設定, NablarchApiForProgrammer.config, NablarchTFWApiForProgrammer.config, NablarchApiForArchitect.config, NablarchTFWApiForArchitect.config

</details>

## 設定ファイル記述方法

設定ファイルには以下の単位で公開APIを指定できる。1行につき1つの公開APIを記述する（順序は問わない）。

| 指定レベル | 説明 | 記述例 |
|---|---|---|
| パッケージ | 指定パッケージ配下（サブパッケージ含む）の全APIを公開 | `java.lang`、`nablarch.fw.web` |
| クラス/インタフェース | 完全修飾名で指定。そのクラス/インタフェースの全APIを公開。ネストクラスはドット区切り | `nablarch.common.code.CodeUtil`、`nablarch.fw.Result.Success` |
| コンストラクタ/メソッド | 完全修飾名＋引数型（参照型も完全修飾名）で指定 | `java.lang.Boolean.Boolean(boolean)`、`nablarch.fw.web.HttpRequest.setParam(java.lang.String, java.lang.String...)` |

> **注意**: ネストクラスのコンストラクタは通常の完全修飾名とは異なる記述方法。`nablarch.fw.Result.Success` の引数なしコンストラクタを公開する場合は `nablarch.fw.Result.Success.Result.Success()` と記述する。`nablarch.fw.Result.Success.Success()` と設定した場合はコンストラクタは使用可能とならないため注意。

設定ファイルの記述例:

```
java.lang
nablarch.fw.web
nablarch.common.code.CodeUtil
java.lang.Object
java.lang.Boolean(boolean)
java.lang.StringBuilder(java.lang.String)
nablarch.fw.web.HttpResponse.HttpResponse()
java.lang.String.indexOf(int)
nablarch.core.validation.ValidationContext.isValid()
nablarch.fw.web.HttpResponse.write(byte[])
nablarch.fw.web.HttpRequest.setParam(java.lang.String, java.lang.String...)
```

<details>
<summary>keywords</summary>

設定ファイル記述方法, パッケージ指定, クラス指定, メソッド指定, ネストクラスコンストラクタ, 完全修飾名, 公開API設定, コンストラクタ指定, HttpResponse, HttpRequest, ValidationContext, StringBuilder, CodeUtil, Boolean

</details>

## Eclipse Pluginとして使用

Eclipseでのチェックではアーキテクト向けとプログラマ向け、プロダクションコードとテストコードなどの分類に従ったチェックを行うことができない。CIなどでAntタスクとしても実行し、使用不許可APIが使用されていないことを分類に従って定期的に必ずチェックすること。

**設定方法**（Nablarch開発環境構築ガイドに従って環境構築済みの場合は不要）:

1. `nablarch-tfw.jar` を FindBugsEclipsePlugin ホームディレクトリ直下の `plugin` ディレクトリに配置する:

```
<Eclipseホームディレクトリ>
├─dropins(またはplugins)
│  ├─<FindBugsEclipsePluginホームディレクトリ>
│  │  └─plugin
│  │     └─ nablarch-tfw.jar
```

2. Eclipseホームディレクトリの `eclipse.ini` を修正する。`-vmargs` の下に、システムプロパティ `nablarch-findbugs-config` キーでテストコード用設定ファイルディレクトリの絶対パスを設定する:

```
-vmargs
-Dnablarch-findbugs-config=C:/nablarch/workspace/Nablarch_sample/tool/staticanalysis/published-config/test
```

3. Eclipseを再起動する。

**チェック結果確認**: エディターの左端に現れるバグマーク、またはFindBugsパースペクティブで確認できる。

<details>
<summary>keywords</summary>

EclipsePlugin設定, nablarch-tfw.jar, eclipse.ini, FindBugsEclipsePlugin, nablarch-findbugs-config, バグマーク確認, FindBugsパースペクティブ, 分類チェック不可, システムプロパティ

</details>

## FindBugsのAntタスクとして使用

FindBugsをAntから実行する場合、`nablarch-tfw.jar` をクラスパスに含めること。

`systemProperty` 要素に `nablarch-findbugs-config` というキーで設定ファイルディレクトリの絶対パスを設定する:

- プロダクションコードに対してチェックするタスク: プロダクションコード用設定ファイルディレクトリの絶対パスを設定
- テストコードに対してチェックするタスク: テストコード用設定ファイルディレクトリの絶対パスを設定

findbugsタスクの定義例:

```xml
<target name="findbugs">
  <taskdef name="findBugs" classname="edu.umd.cs.findbugs.anttask.FindBugsTask" classpath="tool_lib/findbugs-1.3.9-rc1/findbugs-ant.jar" />
  <delete dir="reports/findbugs" />
  <mkdir dir="reports/findbugs" />
  <findbugs home="reports/findbugs"
      output="xml"
      outputFile="nablarch-findbugs.xml"
      excludeFilter="findbugs-exclude.xml" >
      <class location="target/main" />
      <auxClasspath path="main/web/WEB-INF/lib/xxxxx.jar" />
      <sourcePath path="main/java" />
      <systemProperty name="nablarch-findbugs-config" value="C:/nablarch/workspace/Nablarch_sample/tool/staticanalysis/published-config" />
  </findbugs>
</target>
```

<details>
<summary>keywords</summary>

FindBugsAntタスク, nablarch-tfw.jar, nablarch-findbugs-config, systemProperty, findbugsタスク定義, プロダクションコードチェック, テストコードチェック, findbugsタスクXML, FindBugsTask

</details>
