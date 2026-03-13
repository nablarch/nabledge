# Nablarch 5u9 リリースノート

**公式ドキュメント**: [Nablarch 5u9 リリースノート](https://fintan.jp/page/252/)

## Nablarch 5u9 変更内容・移行ガイド

## Nablarch 5u9 変更内容・移行ガイド (5u8からの変更点)

### アプリケーション対応が必要な変更

**No.1 ThreadLocal変数削除の修正** (不具合)
- ThreadContextを使用している場合のみ設定変更が必要
- 対処: `ThreadContextClearHandler` をハンドラキューに設定すること
- ホットデプロイ時のメモリリークを修正。バッチはプロセス終了時に解放されるため実影響なし
- 修正バージョン: nablarch-core 1.3.0, nablarch-core-applog 1.0.2, nablarch-core-dataformat 1.1.0, nablarch-core-jdbc 1.2.0, nablarch-core-repository 1.1.0, nablarch-core-transaction 1.1.3, nablarch-fw 1.1.2, nablarch-fw-messaging 1.0.2, nablarch-fw-web 1.4.0

**No.2 BigDecimal桁数制限** (変更)
- デフォルトでBigDecimalの桁数が9999桁に制限される
- 9999桁超が必要な場合は設定変更が必要
- 修正バージョン: nablarch-core 1.3.0, nablarch-core-beans 1.1.4, nablarch-core-dataformat 1.1.0, nablarch-core-jdbc 1.2.0

**No.3 ノーマライズハンドラの未入力値→null変換** (変更)
- ノーマライズハンドラ使用時、リクエストパラメータの空文字列がnullに変換される
- 5u8以前の挙動に戻す場合: ノーマライズハンドラに設定されている`TrimNormalizer`を5u8のものに差し替えること
- 修正バージョン: nablarch-fw-web 1.4.0

**No.5 ChunkProgressLogListenerの非推奨化** (変更)
- `ChunkProgressLogListener`は非推奨となった
- 新しい`ProgressLogListener`を使用すること（出力できる情報が多い）
- 出力情報: 処理対象件数, TPS, 未処理件数, 終了予測時間
- アプリケーションでの対応は不要だが、非推奨となった旨を認識すること
- 修正バージョン: nablarch-fw-batch-ee 1.1.0

**No.8 システムリポジトリロードログのレベル変更** (変更)
- XMLファイルパスのログがINFOレベル→DEBUGレベルに変更
- INFOレベル以上のログ設定の場合、起動時のXMLファイルパスログが出力されなくなる
- アプリケーションでの対応は不要
- 修正バージョン: nablarch-core-repository 1.1.0

**No.9 BeanUtil型変換→Dialectへ移行** (変更)
- BeanUtilのコンバータを拡張して型変換処理を変更していた場合: Dialectを拡張して型変換処理を変更すること
- 標準の型変換仕様は後方互換を維持しているため、拡張していない場合は影響なし
- 修正バージョン: nablarch-core-jdbc 1.2.0, nablarch-common-dao 1.4.0

**No.11 Oracle集約関数のSQLException修正** (不具合)
- OracleDialect使用時、数値型カラムが全てBigDecimal型で取得されるようになる
- Integer/Longで取得したい場合: OracleDialectを拡張し、`OracleResultSetConvertor`の実装を5u8のものに差し替えること
- 修正バージョン: nablarch-core-jdbc 1.2.0, nablarch-common-dao 1.4.0

**No.14 CSVデータ読込時の未入力値→null変換** (変更)
- RFC4180/EXCEL等のデフォルトフォーマットでは`emptyToNull=true`がデフォルト
- 過去バージョンと同じ（nullに変換しない）動作にする場合: `CsvFormat`アノテーションで`emptyToNull=false`を指定
- 既存で`CsvFormat`アノテーションを使用している場合: `emptyToNull`属性を追加すること
- 修正バージョン: nablarch-common-databind 1.1.0

**No.15 可変長/固定長ファイル読込時の未入力値→null変換** (変更)
- デフォルトで空文字列をnullに変換する
- nullに変換したくない場合: 以下クラスの`convertEmptyToNull`プロパティに`false`を設定
  - `VariableLengthConvertorSetting`
  - `FixedLengthConvertorSetting`
- 修正バージョン: nablarch-core-dataformat 1.1.0

**No.16 符号付き数値の桁数チェック修正** (不具合)
- 符号文字が桁数チェックに含まれるようになる
- アプリケーションでの対応は不要
- 修正バージョン: nablarch-core-dataformat 1.1.0

**No.17 メール送信失敗時の継続処理変更** (変更)
- 送信失敗時に処理継続するよう変更（従来は異常終了）
- 必須対応: `statusUpdateTransaction`という名前のトランザクションコンポーネント定義が必要
```xml
<component name="statusUpdateTransaction" class="nablarch.core.db.transaction.SimpleDbTransactionManager">
  <property name="dbTransactionName" value="statusUpdateTransaction" />
  <property name="connectionFactory" ref="connectionFactory" />
  <property name="transactionFactory" ref="jdbcTransactionFactory" />
</component>
```
- DB更新失敗時: 障害ログに以下が出力されバッチ異常終了。該当送信要求のステータスを「送信失敗」に手動変更すること
  - `Failed to update unsent status. Need to apply a patch to change the status to failure. mailRequestId=[<リクエストID>]`
- 修正バージョン: nablarch-mail-sender 1.2.0, nablarch-smime-integration 1.1.0

**No.18 メール送信日時の設定** (変更)
- `SystemTimeUtil`を使用して送信日時を設定するため、システム日時の管理機能の設定が必要
- 修正バージョン: nablarch-mail-sender 1.2.0

**No.20 JSPカスタムタグでの指数表記数値のフォーマット変更** (不具合)
- 指数表記を含む数値（例: `9e999999999`）はフォーマットされず、そのまま表示される
- 指数表記をフォーマットしたい場合: 独自のフォーマッタを実装すること
- 修正バージョン: nablarch-fw-web-tag 1.0.6

**No.29 popupタグの非推奨化** (変更)
- 以下のタグが非推奨となった（一部ブラウザのIE保護モードで新しいウィンドウが開けない問題のため）
  - `popupSubmit`タグ
  - `popupButton`タグ
  - `popupLink`タグ

**No.37 ETL設定の改善** (変更)
- 設定方法が変更されたため設定変更が必要
  - 環境依存値をetl.jsonからシステムリポジトリの環境設定ファイル(configファイル)に移動
  - ジョブごとにETL用JOB設定ファイルを分割して記述する方式に変更
- 修正バージョン: nablarch-etl 1.1.0

### アプリケーションへの影響がない主な追加・変更

**No.4 JSR352バッチ起動クラス追加**
- **クラス**: `nablarch.fw.batch.ee.Main` が追加
- プロジェクトごとに起動クラスを作成する必要がなくなった
- バージョン: nablarch-fw-batch-ee 1.1.0

**No.6 DatabaseTableQueueReader#writeLog修正** (不具合)
- `DatabaseTableQueueReader#writeLog`がstaticメソッドのためオーバーライドできなかった問題を修正
- instanceメソッドに変更し、オーバーライド可能になった
- バージョン: nablarch-fw-batch 1.2.1

**No.7 運用担当者向けログユーティリティ追加**
- **クラス**: `nablarch.core.log.operation.OperationLog` が追加
- 障害発生時に運用担当者へ連携するためのログを出力。ロガー名を"operator"に統一
- バージョン: nablarch-core 1.3.0

**No.10 フィールドアクセス機能の復活**
- 5u5(nablarch-core-jdbc:1.1.1)で削除したフィールドアクセス機能を復活
- デフォルトはプロパティ(getter)アクセス
- フィールドアクセスに変更する場合: `nablarch.dbAccess.isFieldAccess=true` を設定
- バージョン: nablarch-core-jdbc 1.2.0

**No.12 IN句キャッシュバグ修正** (不具合)
- IN句を使用したSQLで異なる条件のキャッシュが返される問題を修正
- バージョン: nablarch-core-jdbc 1.2.0

**No.13 IN句SQLログ出力バグ修正** (不具合)
- IN句に配列の値をバインドした場合、配列の最後の値しかSQLログに出力されない問題を修正
- バージョン: nablarch-core-jdbc 1.2.0

**No.19 n:form配下要素でのサブミット不具合修正** (不具合)
- `n:form`内に`name='name'`や`id='name'`となるDOMを置いた場合にサブミットが無視される問題を修正
- バージョン: nablarch-fw-web-tag 1.0.6

**No.24 BeanUtil型変換の注意点** (変更)
- BeanUtilを使用してコピーする際に、精度の高い型から低い型（例: LongからInteger）への変換を行った場合、コピー元の値がコピー先の型の精度を超えていても**エラーとならず正常に処理が終了する**
- そのため、コピー元の値は入力値のバリデーションにより事前にバリデーションしておくこと
- バージョン: nablarch-document 5u9

**No.36 logアダプタ追加**
- APサーバやjBatch等のコンテナとロガーを統一するための以下のアダプタを追加
  - SLF4Jアダプタ: nablarch-slf4j-adaptor 1.0.0
  - JBossLoggingアダプタ: nablarch-jboss-logging-adaptor 1.0.0

**No.38 ETL各種DB対応**
- Oracle以外のDBでもETLが動作するよう修正
- 動作確認済みDB: Oracle, H2, DB2, PostgreSQL, SQLServer
- バージョン: nablarch-etl 1.1.0

**No.40 UI開発基盤の導入不具合修正**
- OSS化(5u6)の際に必要なスクリプトがリポジトリに含まれていなかった問題を修正
- バージョン: nablarch-ui-development-template 1.0.1

**No.41 Java静的チェックの変更**
- CheckstyleとFindbugsからIntelliJ IDEAの静的チェック機能に変更
- nablarch-intellij-plugin 1.0.0 として提供
- 使用不許可APIチェックツール・使用許可API一覧作成ツールはIntelliJプラグインとして提供

### 5u9 バージョンアップ手順

1. `pom.xml`の`<dependencyManagement>`セクションの`nablarch-bom`バージョンを`5u9`に変更
2. Mavenのビルドを再実行

### メール送信の設定変更内容（詳細）

送信ステータス更新フローの変更:
- 変更前: ステータス更新失敗(DB更新失敗)時にメールが二重送信されていた
- 変更後: ステータス更新失敗時はパッチ適用が必要

DB更新失敗時の障害ログ: `Failed to update unsent status. Need to apply a patch to change the status to failure. mailRequestId=[<リクエストID>]`

> **重要**: このログ検出時は、該当送信要求の送信ステータスを「送信失敗」に変更するパッチを適用すること。

<details>
<summary>keywords</summary>

5u9, リリースノート, ThreadContextClearHandler, ThreadLocal, メモリリーク, BigDecimal, 桁数制限, ノーマライズハンドラ, TrimNormalizer, 未入力値, null変換, ChunkProgressLogListener, ProgressLogListener, nablarch.fw.batch.ee.Main, JSR352, バッチ起動クラス, OperationLog, nablarch.core.log.operation.OperationLog, 運用担当者向けログ, OracleDialect, OracleResultSetConvertor, BigDecimal型, 集約関数, CsvFormat, emptyToNull, CSV, VariableLengthConvertorSetting, FixedLengthConvertorSetting, convertEmptyToNull, statusUpdateTransaction, SimpleDbTransactionManager, メール送信, 送信失敗, SystemTimeUtil, popupSubmit, popupButton, popupLink, 非推奨, ETL, nablarch-etl, nablarch-intellij-plugin, SLF4Jアダプタ, JBossLoggingアダプタ, nablarch-slf4j-adaptor, nablarch-jboss-logging-adaptor, 符号付き数値, 桁数チェック, IN句, キャッシュ, システムリポジトリ, ログレベル, DEBUG, BeanUtil, Dialect, 型変換, フィールドアクセス, isFieldAccess, バージョンアップ手順, nablarch-bom, DatabaseTableQueueReader, nablarch-smime-integration, nablarch-core-beans, nablarch-fw-batch-ee, nablarch-fw-web-tag, nablarch-common-dao, nablarch-fw-batch, nablarch-mail-sender, nablarch-common-databind

</details>
