# RESTfulウェブサービスプロジェクトの初期セットアップ

RESTfulウェブサービスプロジェクトの初期セットアップでは以下を行う。

* RESTfulウェブサービスプロジェクトの生成
* RESTfulウェブサービスプロジェクトの動作確認

## 事前準備

後の [起動確認](../../setup/blank-project/blank-project-setup-WebService.md#setup-webservice-startup-test) で使用するため、以下のいずれかをインストールする。

* Firefox
* Chrome

## 生成するプロジェクトの概要

本手順で生成するプロジェクトの概要は以下の通りである。

| 項目 | 説明 |
|---|---|
| プロジェクト種別 | Mavenプロジェクト |
| プロジェクト構成 | 単一プロジェクト構成 |
| 使用DB | H2 Databaes Engine(アプリケーションに組み込み) |
| 組み込まれているアダプタ | * Jersey用アダプタ(詳細は、 [Jakarta RESTful Web Servicesアダプタ](../../component/adapters/adapters-jaxrs-adaptor.md#jaxrs-adaptor) を参照) * ルーティングアダプタ(詳細は、 [ルーティングアダプタ](../../component/adapters/adapters-router-adaptor.md#router-adaptor) を参照) |
| 生成するプロジェクトに含まれるもの | 生成されたプロジェクトには以下が含まれる。  * NablarchのRESTfulウェブサービス用の基本的な設定 * 疎通確認用RESTfulウェブサービス * Mavenと連動して動作するツールの初期設定( [nablarch-archetype-parent(親プロジェクト)](../../setup/blank-project/blank-project-MavenModuleStructures.md#about-maven-parent-module) を参照することによって取り込んでいる)。 |

他のプロジェクトとの関係、及びディレクトリ構成は、 [Mavenアーキタイプの構成](../../setup/blank-project/blank-project-MavenModuleStructures.md) を参照。

## ブランクプロジェクト作成

Nablarchが提供するアーキタイプを使用してブランクプロジェクトを生成する。

### mvnコマンドの実行

[Maven Archetype Plugin(外部サイト、英語)](https://maven.apache.org/archetype/maven-archetype-plugin/usage.html) を使用して、ブランクプロジェクトを生成する。

カレントディレクトリを、ブランクプロジェクトを作成したいディレクトリ(任意のディレクトリで可)に変更する。

その後、以下のコマンドを実行する。

```bat
mvn archetype:generate -DarchetypeGroupId=com.nablarch.archetype -DarchetypeArtifactId=nablarch-jaxrs-archetype -DarchetypeVersion={nablarch_version}
```

上記コマンドで使用されているNablarchのバージョンは ​ となっている。バージョンを変更したい場合は、以下のパラメータを変更すること。

| 設定値 | 説明 |
|---|---|
| archetypeVersion | 使用したいアーキタイプのバージョンを指定する。（Nablarch 6u2以降を指定すること） |

#### プロジェクト情報の入力

上記コマンドを実行すると、以下の項目について入力を求められるので、 生成されるブランクプロジェクトに関する情報を入力する。

| 入力項目 | 説明 | 設定例 |
|---|---|---|
| groupId | グループID（通常はパッケージ名を入力） | `com.example` |
| artifactId | アーティファクトID | `myapp-jaxrs` |
| version | バージョン番号 | `0.1.0` |
| package | パッケージ(通常はグループIDと同じ) | `com.example` |

> **Important:**
> 項目groupIdおよびpackageは、Javaのパッケージ名にマッピングされる。
> よって、これらの入力値には、英小文字、数字、ドットを使用し、ハイフンは使用しないこと。

プロジェクト情報の入力が終わると、Y: :と表示される。

* 入力した内容をもとに、ひな形を生成する場合には「Y」を入力してください。
* プロジェクト情報の入力をやり直したい場合には「N」を入力してください。

コマンドが正常終了した場合、ブランクプロジェクトがカレントディレクトリ配下に作成される。

## 疎通確認

### 自動テスト

アーキタイプから生成したプロジェクトには、以下のユニットテストが含まれている。

| ユニットテストのクラス | テスト内容 |
|---|---|
| SampleActionTest | DBアクセスを伴うテストが可能かを確認する。 |

ユニットテストを実行することで、ブランクプロジェクトの生成に成功していることを確認する。

以下のコマンドを実行する。

```text
cd myapp-jaxrs
mvn test
```

> **Tip:**
> ここで使用しているMavenの「clean」「test」は、MavenのBuilt-in Lifecycleである。

> 他にどのようなLifecycleが存在するかについては、 [Built-in Lifecycle Bindings(外部サイト、英語)](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#Built-in_Lifecycle_Bindings)  を参照。

実行に成功すると、以下のようなログがコンソールに出力される。

```text
(中略)
[INFO] ----------------------< com.example:myapp-jaxrs >-----------------------
[INFO] Building myapp-jaxrs 0.1.0
[INFO] --------------------------------[ war ]---------------------------------
(中略)
[INFO] Results:
[INFO]
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
(以下略)
```

### 起動確認

生成したプロジェクトには、以下のサービスが含まれている。

| サービスを実装しているクラス | 内容 |
|---|---|
| SampleAction | RESTfulウェブサービスを実装する際に、一般的に使用するNablarchの機能についての動作確認用サービス。  応答にJSONを使用するサービスと、XMLを使用するサービスが存在する。 |

ブラウザからサービスを呼び出すことによって、ブランクプロジェクトの生成に成功していることを確認する。

#### サービスの起動

まだ、生成したプロジェクトにカレントディレクトリを移動していない場合は移動する。

```text
cd myapp-jaxrs
```

その後、以下のコマンドを実行することで、疎通確認用のアプリケーションをビルドしてから起動する。

```text
mvn jetty:run
```

> **Tip:**
> 上記のコマンド例で使用しているMavenの「jetty:run」は、 Jetty Maven Pluginのrunゴールを使用するという指定である。
> アプリケーションのビルドを行うcompileゴールは「jetty:run」で合わせて実行されるため、明示的に実行する必要はない。

> Jetty Maven Pluginについては [Jetty Maven Plugin(外部サイト、英語)](https://jetty.org/docs/jetty/12/programming-guide/maven-jetty/jetty-maven-plugin.html)  を参照。

起動に成功するとコンソールに以下のようなログが出力される。

```text
(中略)
2020-04-28 08:46:53.366 -INFO- nablarch.fw.web.servlet.NablarchServletContextListener [null] boot_proc = [] proc_sys = [jaxrs] req_id = [null] usr_id = [null] [nablarch.fw.web.servlet.NablarchServletContextListener#contextInitialized] initialization completed.
```

#### 応答にJSONを使用するサービスを呼び出す

FireFoxまたはChromeを起動し、以下のURLをアドレスバーに入力する。

```text
http://localhost:9080/find/json (左記の通り末尾に「/」は不要)
```

成功するとブラウザに以下のようにJSON形式の応答が表示される。

```text
[{"userId":1,"kanjiName":"名部楽太郎","kanaName":"なぶらくたろう"},{"userId":2,"kanjiName":"名部楽次郎","kanaName":"なぶらくじろう"}]
```

> **Tip:**
> FireFoxまたはChromeの代わりにInternet Explorer 11を使用すると、ダウンロードするか否かの確認メッセージが表示される。

#### 応答にXMLを使用するサービスを呼び出す

FireFoxまたはChromeを起動し、以下のURLをアドレスバーに入力する。

```text
http://localhost:9080/find/xml (左記の通り末尾に「/」は不要)
```

成功するとブラウザに以下のようにXML形式の応答が表示される。

```xml
<userList>
  <sampleUser>
    <kanaName>なぶらくたろう</kanaName>
    <kanjiName>名部楽太郎</kanjiName>
    <userId>1</userId>
  </sampleUser>
  <sampleUser>
    <kanaName>なぶらくじろう</kanaName>
    <kanjiName>名部楽次郎</kanjiName>
    <userId>2</userId>
  </sampleUser>
</userList>
```

### 疎通確認になぜか失敗する場合

原因は分からないが疎通確認に失敗する場合、どこかで手順を誤っている可能性がある。

原因が分からない場合は、[ブランクプロジェクト作成](../../setup/blank-project/blank-project-setup-WebService.md#firststepgeneratejaxrsblankproject) からやり直してみること。

## データベースに関する設定を行う

ブランクプロジェクトは、初期状態ではH2 Database Engineを使用するように設定されている。使用するRDBMSを変更する場合は、[使用するRDBMSの変更手順](../../setup/blank-project/blank-project-CustomizeDB.md#customize-db) を参照して設定すること。

またER図からのDDL生成や実行、Entityクラスの自動生成を行うにはgsp-dba-maven-pluginの初期設定および実行を行う。詳細は [gsp-dba-maven-plugin(DBA作業支援ツール)の初期設定方法](../../setup/blank-project/blank-project-addin-gsp.md#gsp-maven-plugin) を参照。

## 補足

H2のデータの確認方法や、ブランクプロジェクトに組み込まれているツールに関しては、 [初期セットアップ手順　補足事項](../../setup/blank-project/blank-project-firststep-complement.md) を参照すること。
