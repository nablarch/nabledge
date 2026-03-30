# 使用不許可APIチェックツール

## 概要

Javaコーディング規約で規定された公開API以外の使用をチェックするツール。公開APIはホワイトリスト形式の設定ファイルで指定し、プロジェクトのコーディング規約に合わせてカスタマイズ可能。

<details>
<summary>keywords</summary>

使用不許可APIチェックツール, FindBugsカスタムルール, ホワイトリスト, 公開API

</details>

## 前提条件

Nablarch開発環境構築ガイドに従って開発環境を構築済みであること。

<details>
<summary>keywords</summary>

前提条件, Nablarch開発環境構築ガイド, 開発環境構築

</details>

## 仕様

公開API以外の呼び出しを以下のルールでチェックする:
- 非公開クラスの参照（インスタンス化、クラスメソッドの呼び出し）
- 非公開メソッドの呼び出し
- 非公開例外の補足および送出

設定ファイルには以下の単位で公開APIを指定できる:
- パッケージ
- クラスまたはインタフェース
- コンストラクタまたはメソッド

デフォルト提供設定ファイル:

| 設定ファイル名 | 概要 |
|---|---|
| `JavaOpenApi.config` | Java標準ライブラリ使用可能API |
| `NablarchApiForProgrammer.config` | プログラマ向けNAF使用可能API（業務機能実装） |
| `NablarchTFWApiForProgrammer.config` | プログラマ向けNTF使用可能API（業務機能テスト） |
| `NablarchApiForArchitect.config` | アーキテクト向けNAF使用可能API（機能拡張等） |
| `NablarchTFWApiForArchitect.config` | アーキテクト向けNTF使用可能API（機能拡張等） |

FindBugsカスタムルールとして提供。バグコード: `UPU`、バグタイプ: `UPU_UNPUBLISHED_API_USAGE`。
実行方法: Antタスクまたは Eclipse Plugin。

<details>
<summary>keywords</summary>

UPU_UNPUBLISHED_API_USAGE, JavaOpenApi.config, NablarchApiForProgrammer.config, NablarchTFWApiForProgrammer.config, NablarchApiForArchitect.config, NablarchTFWApiForArchitect.config, 非公開API使用チェック, バグコード UPU

</details>

## 継承・インタフェース実装に関するチェック仕様

インタフェースを型として宣言していることを前提とする（Javaコーディング規約に従う）。

宣言型に基づいてチェックを行う:
```java
List list = new ArrayList();
list.add(test); // Listインタフェースのaddメソッドが公開されているかをチェック

SuperClass varSuper = new SubClass();
varSuper.testMethod(); // SuperClass.testMethodが公開されているかをチェック

SubClass varSub = new SubClass();
varSub.testMethod(); // SubClass.testMethod()が公開されているかをチェック
```

宣言されたクラス・インタフェースに対象APIが定義されていない場合、親クラス/インタフェースを自クラスに近い方から順次検索し、最初にAPIが定義されたクラスのメソッドが公開されているか否かを判定する。

継承関係の例:
```java
ClassC hoge = new ClassC();
hoge.methodA(); // 使用可能
hoge.methodB(); // 使用不可
```

<details>
<summary>keywords</summary>

継承チェック仕様, インタフェース実装チェック, 宣言型によるチェック, 親クラス検索

</details>

## 設定ファイル配置方法

設定ファイルの拡張子は `config` とすること。設定ファイルディレクトリには複数の設定ファイルを配置可能。

> **警告**: 本ツールは使用されている全APIをチェックするため、デフォルト設定ファイルのみでは自プロジェクトで宣言しているAPIもチェック対象になる。デフォルトの2つの設定ファイルとは別に、**自プロジェクト用の設定ファイルを設定ファイルディレクトリに配置し、自プロジェクトのパッケージを一意に特定できるパッケージを記述すること。**
> 例: 全パッケージが `jp.co.tis.sample` で始まる場合、`jp.co.tis.sample` と記述したテキストファイルを設定ファイルディレクトリに配置する。

設定ファイル配置例（プロダクションコード用とテストコード用でディレクトリを分ける）:
```
<ワークスペース>
└─<プロジェクト>
   └─tool/staticanalysis/
      ├─production/（プロダクションコード用）
      │  └─NablarchApiForProgrammer.config
      └─test/（テストコード用）
         ├─NablarchApiForProgrammer.config
         └─NablarchTFWApiForProgrammer.config
```

フレームワーク拡張コードをチェックする場合は `NablarchApiForArchitect.config`、`NablarchTFWApiForArchitect.config` を使用する。

<details>
<summary>keywords</summary>

設定ファイルディレクトリ, プロジェクト用設定ファイル, プロダクションコード設定, テストコード設定, nablarch-findbugs-config

</details>

## 設定ファイル記述方法

1行につき1つの公開APIを記述。記述順序は問わない。

| 指定レベル | 説明 | 設定例 |
|---|---|---|
| パッケージ | 指定パッケージ配下の全API（サブパッケージ含む）を公開 | `java.lang`、`nablarch.fw.web` |
| クラス・インタフェース | 指定クラス/インタフェースの全APIを公開。完全修飾クラス名を記述 | `nablarch.common.code.CodeUtil`、`nablarch.fw.Result.Success` |
| コンストラクタ・メソッド | 指定コンストラクタ/メソッドを公開。完全修飾名で記述（参照型引数も完全修飾名） | `java.lang.Boolean.Boolean(boolean)`、`java.lang.String.indexOf(int)` |

**ネストクラスのコンストラクタは通常の完全修飾名とは異なる記述方法が必要**:

```
// SuccessがResultのネストクラスの場合（引数なしコンストラクタ）
nablarch.fw.Result.Success.Result.Success()
// 引数ありコンストラクタ
nablarch.fw.Result.Success.Result.Success(java.lang.String)
// メソッドの場合
nablarch.fw.Result.Success.Result.getStatusCode()
```

> **注意**: `nablarch.fw.Result.Success.Success()` と設定した場合、Result.Successクラスのコンストラクタは使用可能とはならない。

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

パッケージ指定, クラス指定, メソッド指定, ネストクラスコンストラクタ, ValidationContext, 完全修飾名, HttpResponse, HttpRequest, CodeUtil

</details>

## Eclipse Pluginとして使用

> **注意**: Eclipseではアーキテクトとプログラマやプロダクションコードとテストコードの分類に従ったチェックができない。CIなどでAntタスクとしても実行し、分類に従ったチェックを定期的に必ず実施すること。

**設定手順**（Nablarch開発環境構築ガイドに従って環境構築済みの場合は不要）:

1. `nablarch-tfw.jar` をFindBugsEclipsePluginホームディレクトリ配下の `plugin` ディレクトリに配置:
   ```
   <Eclipseホームディレクトリ>/dropins(またはplugins)/<FindBugsEclipsePluginホームディレクトリ>/plugin/nablarch-tfw.jar
   ```

2. `eclipse.ini` の `-vmargs` 配下にシステムプロパティ `nablarch-findbugs-config` を設定:
   ```
   -vmargs
   -Dnablarch-findbugs-config=<テストコード用設定ファイルディレクトリの絶対パス>
   ```

3. Eclipseを再起動する。

チェック結果はエディターの左端のバグマークまたはFindBugsパースペクティブで確認できる。

<details>
<summary>keywords</summary>

Eclipse Plugin, nablarch-findbugs-config, nablarch-tfw.jar, FindBugsパースペクティブ, eclipse.ini

</details>

## FindBugsのAntタスクとして使用

FindBugsをAntから実行する際の設定:
- `nablarch-tfw.jar` をクラスパスに含める。
- `systemProperty` 要素にキー `nablarch-findbugs-config` で設定ファイルディレクトリの絶対パスを設定する。
  - プロダクションコードチェックタスク: プロダクションコード用設定ファイルディレクトリの絶対パス
  - テストコードチェックタスク: テストコード用設定ファイルディレクトリの絶対パス

findbugsタスク定義例:
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

Antタスク, nablarch-findbugs-config, nablarch-tfw.jar, systemProperty, findbugsタスク定義

</details>
