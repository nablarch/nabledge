# 初期セットアップの前に

## ブランクプロジェクト（プロジェクトのひな形）について

ブランクプロジェクト（プロジェクトのひな形）に関するセクション。「ブランクプロジェクトの種類」および「ブランクプロジェクトの設計思想と留意事項」を含む。

## ブランクプロジェクトの種類

初期セットアップで作成可能なブランクプロジェクトの種類:

- ウェブプロジェクト
- RESTfulウェブサービスプロジェクト
- Jakarta Batchに準拠したバッチプロジェクト
- Nablarchバッチプロジェクト
- コンテナ用ウェブプロジェクト
- コンテナ用RESTfulウェブサービスプロジェクト
- コンテナ用Nablarchバッチプロジェクト

## ブランクプロジェクトの設計思想と留意事項

ブランクプロジェクトは初期構築の容易さを重視した設計。1プロジェクトで全アプリケーションをビルドできるよう、全ソースファイルとリソースファイルを1プロジェクトに配置する。最小ハンドラ構成で動作するようにコンポーネントの定義・依存関係が設定されている。

初期セットアップ完了後、アーキテクトはプロジェクト構成を検討すること。以下の場合は共通部品を配置するプロジェクトの要否を検討:

- システムを構成するアプリケーションが複数（ウェブとバッチ等）存在する
- アプリケーション間で共通の部品（例: Entityクラス）が存在する

プロジェクト構成の検討時は :ref:`mavenModuleStructuresModuleDivisionPolicy` を参照すること。

## 初期セットアップの前提

実行環境への前提ソフトウェア:

| カテゴリ | ソフトウェア |
|---|---|
| 全プロジェクト共通 | Maven 3.9.9以上 |
| ウェブ、RESTfulウェブサービス、Jakarta Batchに準拠したバッチ、Nablarchバッチ | JDK17以上 |
| コンテナ用ウェブ、コンテナ用RESTfulウェブサービス、コンテナ用Nablarchバッチ | JDK17以上 + Docker Desktop 2.2.0.0以上 |

事前準備不要なソフトウェア:

| ソフトウェア | 理由 |
|---|---|
| APサーバ | ウェブ・RESTfulプロジェクトの疎通確認にJetty12を使用。mvnコマンドからjetty-ee10-maven-pluginを実行し組み込みJetty12へデプロイ・起動するため事前準備不要 |
| DBサーバ | アーキタイプにH2 Database Engine（H2）が組み込まれているため別途インストール不要 |

## Mavenの設定

初期セットアップ前に、NablarchおよびモジュールのMavenリポジトリへの接続設定をMavenのsettings.xmlに対して行うこと。未設定の場合は :ref:`mvnSetting` を参照して設定すること。

> **重要**: Maven関連と思われるトラブルに遭遇した場合は :ref:`mvnFrequentlyTrouble` を参照すること。

## 使用するNablarchのバージョンの指定

Mavenコマンドでブランクプロジェクトを生成する際、使用するNablarchのバージョンとしてnablarch-bomのバージョンを指定する必要がある。

nablarch-bom定義例（抜粋）:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.framework</groupId>
      <artifactId>nablarch-core</artifactId>
      <version>1.2.2</version>
    </dependency>
    <dependency>
      <groupId>com.nablarch.framework</groupId>
      <artifactId>nablarch-core-applog</artifactId>
      <version>1.0.1</version>
    </dependency>
  </dependencies>
</dependencyManagement>
```

生成されたブランクプロジェクトのpom.xmlへの反映:

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>com.nablarch.profile</groupId>
      <artifactId>nablarch-bom</artifactId>
      <version>6</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

## 初期セットアップを行う際の共通的な注意点

初期セットアップ時の注意点:

- ブランクプロジェクトを作成するディレクトリのパスにマルチバイト文字を含めないこと。マルチバイト文字が含まれていると正常に動作しないmaven プラグインが存在するため、エラーが発生する可能性がある。
- `mvn archetype:generate` はコマンドラインから実行すること。eclipse 4.4.2から実行した場合、意図しないファイルが出力される。
- 作成したブランクプロジェクトをeclipseで開くとMavenライフサイクル関連エラー（例: `Plugin execution not covered by lifecycle configuration`）が出力されることがある。eclipseがプラグインのインストールを提案するので従うこと。ネットワーク環境が不安定な場合は、予めプラグインをインストールしたeclipseを配付する等の対応を検討すること。
