# Nablarchフレームワークが使用するテーブル名の変更手順

**公式ドキュメント**: [Nablarchフレームワークが使用するテーブル名の変更手順](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/setting_guide/CustomizingConfigurations/CustomizeSystemTableName.html)

## 概要

テーブル名が命名規約にそぐわない場合、またはスキーマ修飾したい場合に変更する。

<details>
<summary>keywords</summary>

テーブル名変更, 命名規約, スキーマ修飾, テーブル名カスタマイズ, 認可チェック用テーブル

</details>

## 変更方法

以下は、Nablarchが提供する各アーキタイプから生成したブランクプロジェクトで、Nablarchフレームワークが使用するテーブル名を一律「T_テーブル名」に変更する場合の例である。

`src/main/resources/common.properties` に各機能のテーブル設定を追加する。

```properties
# 日付管理
nablarch.businessDateTable.tableName=T_BUSINESS_DATE

# コード管理
nablarch.codeNameTable.name=T_CODE_NAME
nablarch.codePatternTable.name=T_CODE_PATTERN

# 自動採番
nablarch.idGeneratorTable.tableName=T_ID_GENERATE

# メール送信
nablarch.mailAttachedFileTable.tableName=T_MAIL_ATTACHED_FILE
nablarch.mailRecipientTable.tableName=T_MAIL_RECIPIENT
nablarch.mailRequestTable.tableName=T_MAIL_REQUEST
nablarch.mailTemplateTable.tableName=T_MAIL_TEMPLATE

# メッセージ管理（データベースで管理時）
nablarch.messageTable.tableName=T_MESSAGE

# サービス提供可否チェック
# (nablarch.batchRequestTable.nameはプロセス多重起動防止、プロセス停止制御でも使用する。)
nablarch.requestTable.name=T_REQUEST
nablarch.batchRequestTable.name=T_BATCH_REQUEST

# 認可チェック
nablarch.permissionUnitTable.name=T_PERMISSION_UNIT
nablarch.permissionUnitRequestTable.name=T_PERMISSION_UNIT_REQUEST
nablarch.systemAccountTable.name=T_SYSTEM_ACCOUNT
nablarch.systemAccountAuthorityTable.name=T_SYSTEM_ACCOUNT_AUTHORITY
nablarch.ugroupTable.name=T_UGROUP
nablarch.ugroupAuthorityTable.name=T_UGROUP_AUTHORITY
nablarch.ugroupSystemAccountTable.name=T_UGROUP_SYSTEM_ACCOUNT
```

ウェブアプリケーションの場合、セッションストアのテーブル名も変更する（コンポーネント未定義の場合は定義する）。

```xml
<component class="nablarch.common.web.session.store.DbStore">
  <property name="userSessionSchema">
    <component class="nablarch.common.web.session.store.UserSessionSchema">
      <property name="tableName" value="T_USER_SESSION" />
      <property name="sessionIdName" value="SESSION_ID" />
      <property name="sessionObjectName" value="SESSION_OBJECT" />
      <property name="expirationDatetimeName" value="EXPIRATION_DATETIME" />
    </component>
  </property>
</component>
```

<details>
<summary>keywords</summary>

nablarch.businessDateTable.tableName, nablarch.codeNameTable.name, nablarch.codePatternTable.name, nablarch.idGeneratorTable.tableName, nablarch.mailAttachedFileTable.tableName, nablarch.mailRecipientTable.tableName, nablarch.mailRequestTable.tableName, nablarch.mailTemplateTable.tableName, nablarch.messageTable.tableName, nablarch.requestTable.name, nablarch.batchRequestTable.name, nablarch.permissionUnitTable.name, nablarch.permissionUnitRequestTable.name, nablarch.systemAccountTable.name, nablarch.systemAccountAuthorityTable.name, nablarch.ugroupTable.name, nablarch.ugroupAuthorityTable.name, nablarch.ugroupSystemAccountTable.name, DbStore, UserSessionSchema, common.properties, セッションストア, テーブル名設定, 認可チェック, コード管理, メール送信, 自動採番, プロセス多重起動防止, ブランクプロジェクト, アーキタイプ, T_テーブル名

</details>
