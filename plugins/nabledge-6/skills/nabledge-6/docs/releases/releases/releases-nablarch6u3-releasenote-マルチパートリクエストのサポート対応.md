# ■Jakarta RESTful Web Servicesアダプタでマルチパートリクエストを扱うための設定変更手順

【本手順の適用対象となるシステム】
本手順は、以下の条件をすべて満たすシステムを対象としています。
・Nablarch 6u2以前からのバージョンアップであること
・Jakarta RESTful Web ServicesアダプタのJerseyJaxRsHandlerListFactoryまたはResteasyJaxRsHandlerListFactoryを使用していること
※RESTfulウェブサービスのブランクプロジェクトは、デフォルトでJerseyJaxRsHandlerListFactoryを使用するように構成されています
・Nablarchの標準機能を使用して、RESTfulウェブサービスでマルチパートリクエストを扱いたい
【変更内容の概要】
Nablarch 6u3では、RESTfulウェブサービスでマルチパートリクエストを扱えるようにするためにマルチパート用のBodyConverterを追加しています。
それに伴いJakarta RESTful Web ServicesアダプタのJerseyJaxRsHandlerListFactoryおよびResteasyJaxRsHandlerListFactoryに
該当のBodyConverterを追加していますが、マルチパートをリクエストを扱うためにはさらに以下の対応を行う必要があります。
・コンポーネント定義ファイルへのファイルパス設定、ファイルアップロード機能設定の追加
・ハンドラキューへのマルチパートリクエストハンドラの追加
・ファイルアップロード用の一時ディレクトリやアップロードサイズの上限などのプロパティの設定
これらの変更を行うことにより、RESTfulウェブサービスでマルチパートリクエストが扱えるようになり、ファイルアップロードが可能になります。
【変更手順】
【コンポーネント定義ファイルへのファイルパス設定、ファイルアップロード機能設定の追加】
src/main/resources/rest-component-configuration.xml に以下の設定を追加します。
<!-- ファイルパス設置 -->
<import file="nablarch/webui/filepath-for-webui.xml" />
<!-- ファイルアップロード機能設定 -->
<import file="nablarch/webui/multipart.xml" />
【ハンドラキューへのマルチパートリクエストハンドラの追加】
src/main/resources/rest-component-configuration.xml のハンドラキュー(webFrontController)に以下の定義を追加してください。
<component-ref name="multipartHandler"/>
追加位置は、セッション変数保存ハンドラおよびCSRFトークン検証ハンドラの制約事項を確認して決定してください。
https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/SessionStoreHandler.html#session-store-handler-constraint
https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/csrf_token_verification_handler.html#id4
また、環境ごとにハンドラキューを上書きしている場合は、そちらのハンドラキュー定義にも反映してください。
【ファイルアップロード用の一時ディレクトリやアップロードサイズの上限などのプロパティの設定】
ファイルパス設定を追加したことにより、以下のプロパティを定義する必要があります。
src/main/resources/common.properties
nablarch.uploadSettings.contentLengthLimit
src/env/[環境別]/resources/env.properties
nablarch.filePathSetting.basePathSettings.format
nablarch.filePathSetting.basePathSettings.output
nablarch.uploadSettings.autoCleaning
nablarch.filePathSetting.basePathSettings.uploadFileTmpDir
設定内容は、マルチパートリクエストハンドラを確認してください。
https://nablarch.github.io/docs/6u3/doc/application_framework/application_framework/handlers/web/multipart_handler.html
「nablarch.filePathSetting.basePathSettings.format」は汎用データフォーマットのフォーマット定義ファイル用のパス設定ですが、
汎用データフォーマットを使用しないのであればダミー値でかまいません。
