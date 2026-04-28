# ∇Nablarch Application Framework 解説書

introduction
overview_of_NAF
basic_policy
architectural_pattern/concept
architectural_pattern/web_gui
architectural_pattern/batch
architectural_pattern/messaging
02_FunctionDemandSpecifications/01_Core/01_Log.rst
02_FunctionDemandSpecifications/01_Core/02_Repository.rst
core_library/thread_context
02_FunctionDemandSpecifications/01_Core/04_DbAccessSpec.rst
core_library/record_format
core_library/file_access
core_library/enterprise_messaging_overview
core_library/mail
02_FunctionDemandSpecifications/01_Core/03_TransactionManager.rst
02_FunctionDemandSpecifications/01_Core/05_StaticDataCache.rst
core_library/validation
02_FunctionDemandSpecifications/01_Core/07_Message.rst
02_FunctionDemandSpecifications/03_Common/06_IdGenerator.rst
02_FunctionDemandSpecifications/03_Common/08_ExclusiveControl.rst
02_FunctionDemandSpecifications/03_Common/02_CodeManager.rst
02_FunctionDemandSpecifications/01_Core/06_SystemTimeProvider.rst
02_FunctionDemandSpecifications/03_Common/04_Permission.rst
02_FunctionDemandSpecifications/03_Common/05_ServiceAvailability.rst
02_FunctionDemandSpecifications/03_Common/07_WebView
common_library/file_upload_utility
02_FunctionDemandSpecifications/03_Common/99_Utility
handler/index.rst
reader/index.rst
api/link.rst

## 目次

1. [序 : Nablarch Application Framework (NAF)とは ?](../../about/about-nablarch/about-nablarch-introduction.md)
2. [NAF概要](../../about/about-nablarch/about-nablarch-overview-of-NAF.md)
3. [共通方針](../../about/about-nablarch/about-nablarch-basic-policy.md)

**I: NAF実行制御基盤**

1. [NAF基本アーキテクチャ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md)
2. [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md)
3. [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md)
4. [メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging.md)

**II: NAF基盤ライブラリ**

1. [ログ出力](../../component/libraries/libraries-01-Log.md)
2. [リポジトリ](../../component/libraries/libraries-02-Repository.md)
3. [同一スレッド内でのデータ共有(スレッドコンテキスト)](../../component/libraries/libraries-thread-context.md)
4. [データベースアクセス(検索、更新、登録、削除)機能](../../component/libraries/libraries-04-DbAccessSpec.md)
5. [汎用データフォーマット機能](../../component/libraries/libraries-record-format.md)
6. [ファイルアクセス機能](../../component/libraries/libraries-file-access.md)
7. [システム間メッセージング機能](../../component/libraries/libraries-enterprise-messaging-overview.md)
8. [メール送信](../../component/libraries/libraries-mail.md)
9. [トランザクション管理](../../component/libraries/libraries-03-TransactionManager.md)
10. [静的データのキャッシュ](../../component/libraries/libraries-05-StaticDataCache.md)
11. [入力値のバリデーション](../../component/libraries/libraries-core-library-validation.md)
12. [メッセージ管理](../../component/libraries/libraries-07-Message.md)

**III: NAF共通コンポーネント**

1. [採番機能](../../component/libraries/libraries-06-IdGenerator.md)
2. [排他制御機能](../../component/libraries/libraries-08-ExclusiveControl.md)
3. [コード管理](../../component/libraries/libraries-02-CodeManager.md)
4. [日付の管理機能](../../component/libraries/libraries-06-SystemTimeProvider.md)
5. [認可](../../component/libraries/libraries-04-Permission.md)
6. [開閉局](../../component/libraries/libraries-05-ServiceAvailability.md)
7. [JSPカスタムタグライブラリ](../../component/libraries/libraries-07-WebView.md)
8. [ファイルアップロード業務処理用ユーティリティ](../../component/libraries/libraries-file-upload-utility.md)
9. [ユーティリティ](../../component/libraries/libraries-99-Utility.md)

**IV: リファレンス**

1. [ハンドラリファレンス](../../component/handlers/handlers-handler.md)
2. [データリーダリファレンス](../../component/readers/readers-reader.md)
3. [APIドキュメント(Javadoc)](../javadoc/index.html)
