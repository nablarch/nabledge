# ■テスティングフレームワークの設定変更方法

### ここでは、テスティングフレームワークの設定変更方法について説明します。

### ◆概要

#### テスティングフレームワークはWebアプリケーションのリクエスト単体テストを実現するために内部でJettyを使用しています。

#### JettyはJavaのバージョンにより、提供されるモジュールが異なり、かつ後方互換性もありません。

参考：https://www.eclipse.org/jetty/documentation/current/what-jetty-version.html

#### そのため、Java11対応に伴い、テスティングフレームワークが使用しているJettyをJavaのバージョンによって切り替える必要があり、

#### テスティングフレームワークのJetty依存部分を以下の2つのモジュールに分割しました。

・com.nablarch.framework:nablarch-testing-jetty6

・com.nablarch.framework:nablarch-testing-jetty9

#### 上記のモジュールのうち、使用するJettyのバージョンに応じて選択する必要があります。

#### また、テスト用のコンポーネント設定ファイルに、モジュールに応じたコンポーネントを登録しておく必要があります。

### ◆モジュールの選択方法

#### Java6～8を使用しており、Nablarchのバージョンを上げたいが既存のテスト資産には極力影響を与えたくない場合

⇒nablarch-testing-jetty6を選択してください。フレームワーク、依存ライブラリの差異を最小限に抑えられます。

#### Nablarchのバージョンを上げて、Javaのバージョンも11に上げたい場合

⇒nablarch-testing-jetty9を選択してください。

（Java11ではJetty6は動作しないため自動的にJetty9を選択することになります）

#### Java8または11を使用しており、Servlet API 3.0以降の機能をリクエスト単体テストで使用したい場合

⇒nablarch-testing-jetty9を選択してください。

### ◆対応方法

#### 現状のJetty6をそのまま使用し続ける場合の手順を記載します。

#### pom.xmlの変更

#### 以下の依存ライブラリを追加します。

#### 変更後の実装例を示します。

#### 使用するJavaのバージョンにより、生成するクラスが変わります。

#### コンポーネント定義ファイル(src/test/resources/unit-test.xml)への設定追加

#### Jetty9を使用する場合は、解説書の以下の手順を参照してださい。

#### https://nablarch.github.io/docs/5u15/doc/application_framework/application_framework/blank_project/setup_blankProject/setup_Java11.html#jetty-restful
