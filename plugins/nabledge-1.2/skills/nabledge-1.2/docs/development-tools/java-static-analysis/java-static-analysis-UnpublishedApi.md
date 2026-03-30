# 使用不許可APIチェックツール

## 概要と前提条件

Javaコーディング規約で規定された使用許可API以外の使用をチェックするツール。APIを限定することで安全でない実装を抑制し、保守性を向上させる。

**前提条件**: Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

使用不許可APIチェックツール, FindBugsカスタムルール, Javaコーディング規約, 公開API, APIチェック, 安全でない実装抑制

</details>

## 仕様（公開APIチェック仕様）

公開API（ホワイトリスト形式の設定ファイルで指定）以外の使用をチェックする。

**チェック対象**:
- 非公開クラスの参照（インスタンス化、クラスメソッドの呼び出し）
- 非公開メソッドの呼び出し
- 非公開例外の補足、および送出

**設定ファイルで公開APIを指定できる単位**:
- パッケージ
- クラスまたはインタフェース
- コンストラクタまたはメソッド

**デフォルト設定ファイル**:

| 設定ファイル名 | 概要 |
|---|---|
| JavaOpenApi.config | Java標準ライブラリ使用可能API |
| NablarchApiForProgrammer.config | プログラマ向け Nablarch Application Framework 使用可能API（業務機能の実装に必要なAPI） |
| NablarchTFWApiForProgrammer.config | プログラマ向け Nablarch Testing Framework 使用可能API（業務機能のテストに必要なAPI） |
| NablarchApiForArchitect.config | アーキテクト向け Nablarch Application Framework 使用可能API（NAFの機能拡張などで利用） |
| NablarchTFWApiForArchitect.config | アーキテクト向け Nablarch Testing Framework 使用可能API（NTFの機能拡張などで利用） |

本ツールはFindBugsのカスタムルールとして提供する。

- バグコード: `UPU`
- バグタイプ: `UPU_UNPUBLISHED_API_USAGE`

使用方法: Eclipse Plugin（s6参照）、Antタスク（s7参照）

<details>
<summary>keywords</summary>

JavaOpenApi.config, NablarchApiForProgrammer.config, NablarchTFWApiForProgrammer.config, NablarchApiForArchitect.config, NablarchTFWApiForArchitect.config, UPU, UPU_UNPUBLISHED_API_USAGE, ホワイトリスト, 非公開クラス, 非公開メソッド, 非公開例外, FindBugsカスタムルール

</details>

## 継承・インタフェース実装に関するチェック仕様

継承されたメソッド・インタフェース定義メソッドのチェック仕様は通常と異なる。本ツールはJavaコーディング規約に従い、インタフェース実装クラスへのアクセスはインタフェースを型として宣言していることを前提とする。

**宣言型に基づくチェック例**:
```java
List list = new ArrayList();
list.add(test); // ListインタフェースのaddメソッドがPublishされているかチェック

SuperClass varSuper = new SubClass();
varSuper.testMethod(); // SuperClass.testMethodがPublishされているかチェック

SubClass varSub = new SubClass();
varSub.testMethod(); // SubClass.testMethod()がPublishされているかチェック
```

宣言されているクラス・インタフェースに当該APIが定義されていない場合、親クラス・インタフェースを自クラスに近い方から順次検索し、最初にAPIが定義されているクラスのメソッドが公開されているか否かを判定する。

![継承クラス図](../../../knowledge/development-tools/java-static-analysis/assets/java-static-analysis-UnpublishedApi/InheritClasses.jpg)

上図の継承関係でのチェック結果:
- `hoge.methodA()` → 使用可能
- `hoge.methodB()` → 使用不可

<details>
<summary>keywords</summary>

継承チェック, インタフェース実装チェック, 宣言型チェック, 親クラス検索, メソッド公開判定, SubClass, SuperClass

</details>

## 設定ファイル配置方法

設定ファイルを格納したディレクトリ（設定ファイルディレクトリ）に複数の設定ファイルを配置できる。設定ファイルの拡張子は `config` とすること。

> **警告**: 本ツールは使用されている全APIに対してチェックを行うため、デフォルト設定ファイルのみでは自プロジェクトで宣言しているAPIもチェック対象となる。**デフォルトの2つの設定ファイルとは別に、自プロジェクト用の設定ファイルを設定ファイルディレクトリに配置し、自プロジェクトのパッケージを一意に特定できるパッケージを記述すること。**
> 例：プロジェクトの全パッケージが「jp.co.tis.sample」で始まる場合、「jp.co.tis.sample」と記述したテキストファイルを設定ファイルディレクトリに1つ配置する。

**設定ファイル配置例**（プロダクションコードとテストコードで分ける場合）:
```
<ワークスペース>
└─<プロジェクト>
   └─tool
      └─staticanalysis
         ├─production（プロダクションコード用設定ファイルディレクトリ）
         │  └─ NablarchApiForProgrammer.config
         └─test（テストコード用設定ファイルディレクトリ）
            ├─ NablarchApiForProgrammer.config
            └─ NablarchTFWApiForProgrammer.config
```

フレームワーク拡張コードには `NablarchApiForArchitect.config`、`NablarchTFWApiForArchitect.config` を使用する。

<details>
<summary>keywords</summary>

設定ファイルディレクトリ, configファイル, プロダクションコード設定, テストコード設定, 自プロジェクトパッケージ設定, NablarchApiForArchitect.config, NablarchTFWApiForArchitect.config

</details>

## 設定ファイル記述方法

設定ファイルには、パッケージ・クラス・インタフェース・コンストラクタ・メソッドのレベルで公開APIを指定できる。設定ファイル1行につき1つの公開APIを記述する。記述順序は問わない。

| 指定レベル | 説明 |
|---|---|
| パッケージ | 指定パッケージ配下の全API（サブパッケージ含む）を公開。パッケージ名を記述。 |
| クラス・インタフェース | 指定クラス/インタフェースの全APIを公開。完全修飾名で記述。 |
| コンストラクタ・メソッド | 指定コンストラクタ/メソッドのみ公開。完全修飾名＋引数型（参照型も完全修飾名）で記述。 |

> **注意**: ネストクラスのコンストラクタは完全修飾名とは記述方法が異なる。`Result.Success`クラスの引数なしコンストラクタを公開する場合は `nablarch.fw.Result.Success.Result.Success()` と設定すること（`nablarch.fw.Result.Success.Success()` ではコンストラクタは使用可能とならないので注意）。

**記述例**:
```
// パッケージ指定
java.lang
nablarch.fw.web

// クラス・インタフェース指定
nablarch.common.code.CodeUtil
java.lang.Object
nablarch.fw.Result.Success

// コンストラクタ指定
java.lang.Boolean.Boolean(boolean)
java.lang.StringBuilder.StringBuilder(java.lang.String)
nablarch.fw.web.HttpResponse.HttpResponse()

// メソッド指定
java.lang.String.indexOf(int)
nablarch.core.validation.ValidationContext.isValid()
nablarch.fw.web.HttpResponse.write(byte[])
nablarch.fw.web.HttpRequest.setParam(java.lang.String, java.lang.String...)

// ネストクラスのコンストラクタ（Result.SuccessがResultのネストクラスの場合）
nablarch.fw.Result.Success.Result.Success()
nablarch.fw.Result.Success.Result.Success(java.lang.String)

// ネストクラスのメソッド
nablarch.fw.Result.Success.Result.getStatusCode()
```

<details>
<summary>keywords</summary>

nablarch.common.code.CodeUtil, nablarch.fw.Result.Success, nablarch.fw.web.HttpResponse, nablarch.core.validation.ValidationContext, nablarch.fw.web.HttpRequest, パッケージ指定, クラス指定, メソッド指定, ネストクラス, 完全修飾名

</details>

## Eclipse Pluginとして使用

> **注意**: Eclipseではアーキテクトとプログラマまたはプロダクションコードとテストコードの分類に従ったチェックができない。CIなどでAntタスクとしても実行し、使用不許可APIが使用されていないことを分類に従って定期的に必ずチェックすること。

**設定手順**（Nablarch開発環境構築ガイドに従って環境構築した場合は不要）:

1. `nablarch-tfw.jar` を `<Eclipseホームディレクトリ>/dropins（またはplugins）/<FindBugsEclipsePluginホームディレクトリ>/plugin/` に配置する。
2. `eclipse.ini` の `-vmargs` の下に以下を追加する:
   ```
   -Dnablarch-findbugs-config=<テストコード用設定ファイルディレクトリの絶対パス>
   ```
3. Eclipseを再起動する。

**チェック結果確認**: エディターの左端に現れるバグマーク、またはFindBugsパースペクティブで確認できる。

<details>
<summary>keywords</summary>

nablarch-tfw.jar, nablarch-findbugs-config, eclipse.ini, FindBugsEclipsePlugin, Eclipse設定, -vmargs

</details>

## FindBugsのAntタスクとして使用

FindBugsをAntから実行する場合、`nablarch-tfw.jar` をクラスパスに含め、`systemProperty` 要素に `nablarch-findbugs-config` キーで設定ファイルディレクトリの絶対パスを設定する。

- プロダクションコードのタスク: プロダクションコード用設定ファイルディレクトリの絶対パスを設定
- テストコードのタスク: テストコード用設定ファイルディレクトリの絶対パスを設定

> **注意**: チェック結果の確認方法は、各プロジェクトでFindBugsをどう使用するかによって異なるためここでは述べない（CI上で使用することを想定している）。

**Antタスク定義例** ([Findbugs公式サイト](http://findbugs.sourceforge.net/ja/manual/anttask.html) 参照):
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

nablarch-tfw.jar, nablarch-findbugs-config, FindBugsTask, Antタスク, systemProperty, findbugsタスク

</details>
