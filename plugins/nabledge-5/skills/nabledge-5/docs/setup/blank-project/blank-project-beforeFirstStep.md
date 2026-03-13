# 初期セットアップの前に

**公式ドキュメント**: [初期セットアップの前に](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/blank_project/beforeFirstStep.html)

## ブランクプロジェクト（プロジェクトのひな形）について

なし

<details>
<summary>keywords</summary>

ブランクプロジェクト, プロジェクトのひな形, ウェブプロジェクト, バッチプロジェクト

</details>

## ブランクプロジェクトの種類

- ウェブプロジェクト
- RESTfulウェブサービスプロジェクト
- JSR352に準拠したバッチプロジェクト
- Nablarchバッチプロジェクト
- コンテナ用ウェブプロジェクト
- コンテナ用RESTfulウェブサービスプロジェクト
- コンテナ用Nablarchバッチプロジェクト

<details>
<summary>keywords</summary>

ウェブプロジェクト, RESTfulウェブサービスプロジェクト, JSR352, Nablarchバッチプロジェクト, コンテナ用プロジェクト, ブランクプロジェクト種類

</details>

## ブランクプロジェクトの設計思想と留意事項

ブランクプロジェクトは初期構築の容易さを重視しており、1プロジェクトで各アプリケーションをビルドできるよう全ソース・リソースファイルを1プロジェクトに配置。最小ハンドラ構成で動作するようコンポーネント定義・依存関係が設定されている。

初期セットアップ後、アーキテクトはプロジェクト構成を検討する必要がある。特に以下の場合は共通部品プロジェクトの要否を検討すること:
- 複数アプリケーション（ウェブアプリケーションとバッチアプリケーション等）が存在する
- アプリケーション間で共通部品（Entityクラス等）が存在する

プロジェクト構成を検討する際は :ref:`mavenModuleStructuresModuleDivisionPolicy` を参照すること。

<details>
<summary>keywords</summary>

プロジェクト構成, 共通部品, mavenModuleStructuresModuleDivisionPolicy, 最小ハンドラ構成, 設計思想

</details>

## 初期セットアップの前提

実行環境に以下のソフトウェアが必要:

**全プロジェクト共通**
- Maven 3.6.3以上

**ウェブ、RESTfulウェブサービス、JSR352に準拠したバッチ、Nablarchバッチ**
- JDK1.8以上

**コンテナ用ウェブ、コンテナ用RESTfulウェブサービス、コンテナ用Nablarchバッチ**
- JDK11以上
- Docker Desktop 2.2.0.0以上

事前準備不要のソフトウェア:

| ソフトウェア | 説明 |
|---|---|
| APサーバ | mvnコマンドでwaitt-maven-pluginを実行し組み込みTomcat8へデプロイするため不要 |
| DBサーバ | アーキタイプにH2 Database Engineを組み込み済みのため別途インストール不要 |

<details>
<summary>keywords</summary>

Maven 3.6.3, JDK, Docker Desktop, 前提条件, H2 Database, Tomcat8, APサーバ, DBサーバ

</details>

## Mavenの設定

NablarchおよびモジュールのMavenリポジトリに接続できるよう、settings.xmlに設定が必要。未設定の場合は :ref:`mvnSetting` を参照。

> **重要**: 以降の手順でMaven関連と思われるトラブルに遭遇した場合は、:ref:`mvnFrequentlyTrouble` を参照すること。

<details>
<summary>keywords</summary>

Maven設定, settings.xml, Mavenリポジトリ, mvnSetting, mvnFrequentlyTrouble

</details>

## 使用するNablarchのバージョンの指定

NablarchではMavenのbomの仕組みを使用して、Nablarchフレームワークを構成する各モジュールのバージョンを定義している。

Mavenコマンドでブランクプロジェクトを生成する際、使用するNablarchのバージョンとしてnablarch-bomのバージョンを指定する必要がある。

nablarch-bom内の定義（抜粋）:

```xml
<dependencyManagement>
  <dependencies>

    <dependency>
      <groupId>com.nablarch.framework</groupId>
      <artifactId>nablarch-core</artifactId>
      <version>1.2.2</version> <!-- nablarch-coreモジュールのバージョンの定義 -->
    </dependency>

    <dependency>
      <groupId>com.nablarch.framework</groupId>
      <artifactId>nablarch-core-applog</artifactId>
      <version>1.0.1</version> <!-- nablarch-core-applogモジュールのバージョンの定義 -->
    </dependency>
```

指定したバージョンは生成されたpom.xmlの `dependencyManagement` に以下のように反映される:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <version>5u6</version> <!-- 指定したバージョン -->
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

<details>
<summary>keywords</summary>

nablarch-bom, バージョン指定, dependencyManagement, nablarch-profile, pom.xml, nablarch-core, bom

</details>

## 初期セットアップを行う際の共通的な注意点

- ブランクプロジェクトを作成するディレクトリパスにはマルチバイト文字を含めないこと。マルチバイト文字があると正常動作しないMavenプラグインが存在し、エラーが発生する可能性がある。
- `mvn archetype:generate` はコマンドラインから実行すること。eclipse4.4.2から実行した場合、意図しないファイルが出力される。
- ブランクプロジェクトをeclipseで開くとMavenライフサイクルに関するエラーが出ることがある（例：`Plugin execution not covered by lifecycle configuration`）。eclipseが提案するプラグインをインストールすることで解消される。ネットワーク環境が不安定な場合は、プラグインを事前インストールしたeclipseを配付する等の対応を検討すること。

<details>
<summary>keywords</summary>

マルチバイト文字, mvn archetype:generate, eclipse, Mavenライフサイクル, Plugin execution not covered by lifecycle configuration

</details>
