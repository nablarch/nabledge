* [想定読者、位置付け、対象工程、注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md)
* [Nablarch Application Framework 概要](../../about/about-nablarch/about-nablarch-01-NablarchOutline.md)
* [単体テスト概要](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md)
* [業務アプリケーション開発手順](../../guide/web-application/web-application-03-DevelopmentStep.md)
* [業務アプリケーションの実装方法 (画面オンライン処理編)](../../guide/web-application/web-application-04-Explanation.md)
* [業務アプリケーションの実装方法 (バッチ処理編)](../../guide/nablarch-batch/nablarch-batch-04-Explanation-batch.md)
* [業務アプリケーションの実装方法 (メッセージング処理編)](../../guide/mom-messaging/mom-messaging-04-Explanation-messaging.md)
* [業務アプリケーションの実装方法 (その他の処理)](../../guide/libraries/libraries-04-Explanation-other.md)
* [フレームワークAPIの使用例集](../../guide/web-application/web-application-09-examples.md)
* [開発を容易にするためのユーティリティ](../../guide/web-application/web-application-08-utilities.md)
* [ログ出力の設定方法とログの見方(画面オンライン処理編)](../../guide/web-application/web-application-Web-Log.md)
* [携帯端末(フィーチャーフォン)向け画面を実装する際の留意点](../../guide/web-application/web-application-12-keitai.md)
* [単体テスト実施方法](../../development-tools/testing-framework/testing-framework-05-UnitTestGuide.md)
* [自動テストフレームワークの使用方法](../../development-tools/testing-framework/testing-framework-06-TestFWGuide.md)
* [プログラミング工程で使用するツール](../../development-tools/toolbox/toolbox-08-TestTools.md)
* [Appendix A: ウィンドウスコープ概要](../../guide/web-application/web-application-02-WindowScope.md)

## プログラミング・単体テストガイド

-----

-----

-----

### 本書について

本書では、Nablarch Application Framework(以下アプリケーションフレームワーク)およびNablarch 自動テストフレームワーク(以下自動テストフレームワーク)を使用したアプリケーションの実装方法と単体テストの実施方法について説明する。

本書の想定読者、位置づけ、対象とする工程、注意事項について以下に示す。

* [想定読者、位置付け、対象工程、注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md)

### Nablarchアプリケーション開発概要

本章では、Nablarchを使用してアプリケーション開発を行う上で理解しておく必要のある基本的な知識について説明する。

初めてNablarchを使用して開発を行うアプリケーションプログラマは、本章を読んで下さい。

#### アプリケーションフレームワーク概要

以下では、アプリケーションフレームワークの概要と、アプリケーションの構成要素について説明する。

本節を読むと、アプリケーションプログラマが何を作成すればよいかを理解することができる。

* [Nablarch Application Framework 概要](../../about/about-nablarch/about-nablarch-01-NablarchOutline.md)

#### 単体テスト概要

以下では、作成したアプリケーションについて、どのような単体テストを実施すればよいかを説明する。

* [単体テスト概要](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md)

### Nablarchアプリケーション開発手順

本章では、Nablarchを使用したアプリケーション開発の流れをチュートリアル形式で説明する。

初めてNablarchを使用して開発を行うアプリケーションプログラマは、本章を読んで下さい。

* [業務アプリケーション開発手順](../../guide/web-application/web-application-03-DevelopmentStep.md)

### Nablarchアプリケーション開発リファレンス

本章では、アプリケーションの実装方法や単体テストの実施方法など、アプリケーション開発の詳細について説明する。

アプリケーションプログラマは、必要に応じて各節を参照して下さい。

#### アプリケーション実装方法

基本的なアプリケーションの実装方法について、サンプルアプリケーションを例に説明する。

以下のサンプルアプリケーションの中から、開発対象のアプリケーションに近いものを選んで参照して下さい。

* [業務アプリケーションの実装方法 (画面オンライン処理編)](../../guide/web-application/web-application-04-Explanation.md)
* [業務アプリケーションの実装方法 (バッチ処理編)](../../guide/nablarch-batch/nablarch-batch-04-Explanation-batch.md)
* [業務アプリケーションの実装方法 (同期応答メッセージ受信処理編)](../../guide/mom-messaging/mom-messaging-04-Explanation-real.md)
* [業務アプリケーションの実装方法 (応答不要メッセージ受信処理編)](../../guide/mom-messaging/mom-messaging-04-Explanation-delayed-receive.md)
* [業務アプリケーションの実装方法 (HTTP同期応答メッセージ受信処理編)](../../guide/http-messaging/http-messaging-04-Explanation-http-real.md)
* [業務アプリケーションの実装方法 (応答不要メッセージ送信処理編)](../../guide/mom-messaging/mom-messaging-04-Explanation-delayed-send.md)
* [業務アプリケーションの実装方法 (同期応答メッセージ送信処理編)](../../guide/mom-messaging/mom-messaging-04-Explanation-send-sync.md)
* [業務アプリケーションの実装方法 (HTTP同期応答メッセージ送信処理編)](../../guide/http-messaging/http-messaging-04-Explanation-http-send-sync.md)
* [業務アプリケーションの実装方法 (メール送信処理編)](../../guide/libraries/libraries-04-Explanation-mail.md)

##### アプリケーション実装例集

アプリケーション開発で頻繁に実装する処理の実装方法について説明する。

* [web-application-DB](../../guide/web-application/web-application-DB.md)
* [画面オンライン処理の実装例集](../../guide/web-application/web-application-CustomTag.md)
* [精査処理の実装例集](../../guide/web-application/web-application-Validation.md)
* [その他実装例集](../../guide/web-application/web-application-Other.md)

##### 開発を容易にするためのユーティリティ

アプリケーションでの開発を容易にするためのユーティリティについて説明をする。

* [開発を容易にするためのユーティリティ](../../guide/web-application/web-application-08-utilities.md)

##### 開発時のログ出力の設定方法とログの見方

アプリケーションの開発時にデバッグ作業に必要な情報を収集するために、
ログ出力の設定方法と出力されたログの見方を説明する。

* [web-application-Log](../../guide/web-application/web-application-Log.md)

##### 携帯端末(フィーチャーフォン)向け画面を実装する場合の留意点

携帯端末(フィーチャーフォン)向け画面を実装する場合の留意点について、
以下に説明する。

* [携帯端末(フィーチャーフォン)向け画面を実装する際の留意点](../../guide/web-application/web-application-12-keitai.md)

#### 単体テスト実施方法

単体テストの実施方法について説明する。

* [単体テスト実施方法](../../development-tools/testing-framework/testing-framework-05-UnitTestGuide.md)

#### 自動テストフレームワーク使用方法

自動テストフレームワークの使用方法を説明する。

* [自動テストフレームワークの使用方法](../../development-tools/testing-framework/testing-framework-06-TestFWGuide.md)

#### プログラミング工程で使用するツールの使用方法

プログラミング工程で使用するツールの使用方法を説明する。

* [プログラミング工程で使用するツール](../../development-tools/toolbox/toolbox-08-TestTools.md)
