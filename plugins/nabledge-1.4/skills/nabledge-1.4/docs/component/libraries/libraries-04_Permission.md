# 認可

## 概要

リクエストに対して認可チェックを行う機能。ハンドラとして使用される（詳細は [../../handler/PermissionCheckHandler](../handlers/handlers-PermissionCheckHandler.md)）。

> **注意**: 通常アーキテクトが本機能を使用して認可処理を局所化するため、アプリケーションプログラマは本機能を直接使用しない。

**クラス**: `nablarch.common.handler.PermissionCheckHandler`, `nablarch.common.permission.BasicPermissionFactory`

DIコンテナの機能を使用して、PermissionCheckHandlerとBasicPermissionFactoryの設定を行い使用する。

### PermissionCheckHandlerの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| permissionFactory | ○ | Permissionを生成するPermissionFactory |
| ignoreRequestIds | | 認可判定を行わないリクエストID（カンマ区切りで複数指定可） |

### BasicPermissionFactoryの設定

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| dbManager | ○ | DBトランザクション制御。`nablarch.core.db.transaction.SimpleDbTransactionManager`インスタンスを指定。詳細は [../01_Core/04_DbAccessSpec](libraries-04_DbAccessSpec.md) 参照 |
| groupTableSchema | ○ | グループテーブルのスキーマ情報。GroupTableSchemaクラスのインスタンス |
| systemAccountTableSchema | ○ | システムアカウントテーブルのスキーマ情報。SystemAccountTableSchemaクラスのインスタンス |
| groupSystemAccountTableSchema | ○ | グループシステムアカウントテーブルのスキーマ情報。GroupSystemAccountTableSchemaクラスのインスタンス |
| permissionUnitTableSchema | ○ | 認可単位テーブルのスキーマ情報。PermissionUnitTableSchemaクラスのインスタンス |
| permissionUnitRequestTableSchema | ○ | 認可単位リクエストテーブルのスキーマ情報。PermissionUnitRequestTableSchemaクラスのインスタンス |
| groupAuthorityTableSchema | ○ | グループ権限テーブルのスキーマ情報。GroupAuthorityTableSchemaクラスのインスタンス |
| systemAccountAuthorityTableSchema | ○ | システムアカウント権限テーブルのスキーマ情報。SystemAccountAuthorityTableSchemaクラスのインスタンス |
| businessDateProvider | ○ | 業務日付取得（有効日From/Toチェックに使用）。`nablarch.core.date.BusinessDateProvider`実装クラスを指定。詳細は :ref:`BusinessDateProvider-label` 参照 |

XML設定例:

```xml
<component name="webFrontController" class="nablarch.fw.web.servlet.WebFrontController">
  <property name="handlerQueue">
    <list>
      <component class="nablarch.fw.RequestHandlerEntry">
        <property name="requestPattern" value="/action//" />
        <property name="handler">
          <component class="nablarch.common.handler.PermissionCheckHandler">
            <property name="permissionFactory" ref="permissionFactory" />
            <property name="ignoreRequestIds" value="RW11AA0101, RW11AA0102, RW99ZZ0601, RW99ZZ0602, RW99ZZ0603, RW99ZZ0604, RW99ZZ0605" />
          </component>
        </property>
      </component>
    </list>
  </property>
</component>

<component name="permissionFactory" class="nablarch.common.permission.BasicPermissionFactory">
  <property name="dbManager">
    <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
      <property name="dbTransactionName" value="PermissionCheck" />
      <property name="transactionFactory" ref="transactionFactory" />
      <property name="connectionFactory" ref="connectionFactory" />
    </component>
  </property>
  <property name="groupTableSchema">
    <component class="nablarch.common.permission.schema.GroupTableSchema">
      <property name="tableName" value="UGROUP" />
      <property name="groupIdColumnName" value="UGROUP_ID" />
    </component>
  </property>
  <property name="systemAccountTableSchema">
    <component class="nablarch.common.permission.schema.SystemAccountTableSchema">
      <property name="tableName" value="SYSTEM_ACCOUNT" />
      <property name="userIdColumnName" value="USER_ID" />
      <property name="userIdLockedColumnName" value="USER_ID_LOCKED" />
      <property name="effectiveDateFromColumnName" value="EFFECTIVE_DATE_FROM" />
      <property name="effectiveDateToColumnName" value="EFFECTIVE_DATE_TO" />
    </component>
  </property>
  <property name="groupSystemAccountTableSchema">
    <component class="nablarch.common.permission.schema.GroupSystemAccountTableSchema">
      <property name="tableName" value="UGROUP_SYSTEM_ACCOUNT" />
      <property name="groupIdColumnName" value="UGROUP_ID" />
      <property name="userIdColumnName" value="USER_ID" />
      <property name="effectiveDateFromColumnName" value="EFFECTIVE_DATE_FROM" />
      <property name="effectiveDateToColumnName" value="EFFECTIVE_DATE_TO" />
    </component>
  </property>
  <property name="permissionUnitTableSchema">
    <component class="nablarch.common.permission.schema.PermissionUnitTableSchema">
      <property name="tableName" value="PERMISSION_UNIT" />
      <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
    </component>
  </property>
  <property name="permissionUnitRequestTableSchema">
    <component class="nablarch.common.permission.schema.PermissionUnitRequestTableSchema">
      <property name="tableName" value="PERMISSION_UNIT_REQUEST" />
      <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
      <property name="requestIdColumnName" value="REQUEST_ID" />
    </component>
  </property>
  <property name="groupAuthorityTableSchema">
    <component class="nablarch.common.permission.schema.GroupAuthorityTableSchema">
      <property name="tableName" value="UGROUP_AUTHORITY" />
      <property name="groupIdColumnName" value="UGROUP_ID" />
      <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
    </component>
  </property>
  <property name="systemAccountAuthorityTableSchema">
    <component class="nablarch.common.permission.schema.SystemAccountAuthorityTableSchema">
      <property name="tableName" value="SYSTEM_ACCOUNT_AUTHORITY" />
      <property name="userIdColumnName" value="USER_ID" />
      <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
    </component>
  </property>
  <property name="businessDateProvider" ref="businessDateProvider" />
</component>

<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider" />
```

### スキーマクラスのプロパティ

**GroupTableSchema** (`nablarch.common.permission.schema.GroupTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| groupIdColumnName | ○ | グループIDカラムの名前 |

**SystemAccountTableSchema** (`nablarch.common.permission.schema.SystemAccountTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| userIdColumnName | ○ | ユーザIDカラムの名前 |
| userIdLockedColumnName | ○ | ユーザIDロックカラムの名前 |
| failedCountColumnName | ○ | 認証失敗回数カラムの名前 |
| effectiveDateFromColumnName | ○ | 有効日(From)カラムの名前 |
| effectiveDateToColumnName | ○ | 有効日(To)カラムの名前 |

**GroupSystemAccountTableSchema** (`nablarch.common.permission.schema.GroupSystemAccountTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| groupIdColumnName | ○ | グループIDカラムの名前 |
| userIdColumnName | ○ | ユーザIDカラムの名前 |
| effectiveDateFromColumnName | ○ | 有効日(From)カラムの名前 |
| effectiveDateToColumnName | ○ | 有効日(To)カラムの名前 |

**PermissionUnitTableSchema** (`nablarch.common.permission.schema.PermissionUnitTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| permissionUnitIdColumnName | ○ | 認可単位IDカラムの名前 |

**PermissionUnitRequestTableSchema** (`nablarch.common.permission.schema.PermissionUnitRequestTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| permissionUnitIdColumnName | ○ | 認可単位IDカラムの名前 |
| requestIdColumnName | ○ | リクエストIDカラムの名前 |

**GroupAuthorityTableSchema** (`nablarch.common.permission.schema.GroupAuthorityTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| groupIdColumnName | ○ | グループIDカラムの名前 |
| permissionUnitIdColumnName | ○ | 認可単位IDカラムの名前 |

**SystemAccountAuthorityTableSchema** (`nablarch.common.permission.schema.SystemAccountAuthorityTableSchema`):

| プロパティ名 | 必須 | 説明 |
|---|---|---|
| tableName | ○ | テーブル名 |
| userIdColumnName | ○ | ユーザIDカラムの名前 |
| permissionUnitIdColumnName | ○ | 認可単位IDカラムの名前 |

### 初期化設定

BasicPermissionFactoryクラスは初期化が必要なため :ref:`repository_initialize` に従いInitializableインタフェースを実装している。permissionFactoryが初期化されるよう下記の設定を行うこと。

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
  <property name="initializeList">
    <list>
      <component-ref name="permissionFactory"/>
    </list>
  </property>
</component>
```

<details>
<summary>keywords</summary>

認可チェック, PermissionCheckHandler, ハンドラ, 認可処理, BasicPermissionFactory, WebFrontController, RequestHandlerEntry, GroupTableSchema, SystemAccountTableSchema, GroupSystemAccountTableSchema, PermissionUnitTableSchema, PermissionUnitRequestTableSchema, GroupAuthorityTableSchema, SystemAccountAuthorityTableSchema, BasicBusinessDateProvider, SimpleDbTransactionManager, BasicApplicationInitializer, permissionFactory, ignoreRequestIds, dbManager, groupTableSchema, systemAccountTableSchema, groupSystemAccountTableSchema, permissionUnitTableSchema, permissionUnitRequestTableSchema, groupAuthorityTableSchema, systemAccountAuthorityTableSchema, businessDateProvider, tableName, groupIdColumnName, userIdColumnName, userIdLockedColumnName, failedCountColumnName, effectiveDateFromColumnName, effectiveDateToColumnName, permissionUnitIdColumnName, requestIdColumnName, 認可チェック設定, スキーマ情報設定, BasicPermissionFactory設定, PermissionCheckHandler設定

</details>

## 特徴

### グループ単位とユーザ単位を併用した権限設定

グループに権限を設定し、ユーザにグループを割り当てることでグループ単位の権限管理が可能。さらにユーザに直接権限を設定することでイレギュラーな権限付与にも対応可能。

### 自由度の高いテーブル定義

テーブル名・カラム名を自由に設定可能。カラムのデータ型もJavaの型に変換可能であれば任意のデータ型を使用できる。プロジェクトの命名規約に従ったテーブル定義が作成できる。

ログイン処理など、一部の処理のみ認可判定の対象から除外したい場合は、PermissionCheckHandlerの設定でignoreRequestIdsプロパティを指定する。

リクエストIDがRW11AA0101とRW11AA0102を認可判定の対象から除外する場合の設定例:

```xml
<!-- PermissionCheckHandlerの設定 -->
<component class="nablarch.common.handler.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory" />
  <property name="ignoreRequestIds" value="RW11AA0101, RW11AA0102" />
</component>
```

<details>
<summary>keywords</summary>

グループ権限, ユーザ権限, 権限設定, テーブル定義, グループ単位, ignoreRequestIds, 認可判定除外, PermissionCheckHandler, リクエストID除外, ログイン処理除外

</details>

## 要求

### 実装済み

- 機能（任意のリクエストのかたまり）単位で認可判定の設定を行うことができる
- ユーザに対してグループを設定でき、グループ単位で認可判定の設定を行うことができる
- リクエストIDを設定し、特定のリクエストIDを認可判定の対象から除外できる
- ユーザに有効日（From/To）を設定できる
- ユーザとグループの関連に有効日（From/To）を設定できる
- 認可判定の結果に応じて画面項目（メニューやボタンなど）の表示・非表示を切り替えることができる

### 未実装

- 本機能で使用するマスタデータをメンテナンスできる
- 本機能で使用するマスタの初期データを一括登録できる
- 認証機能によりユーザIDがロックされているユーザの認可判定を失敗にできる

### 未検討

- データへのアクセスを制限できる
- 機能単位の権限に有効日（From/To）を設定できる

> **注意**: 下記のコードはフレームワークが行う処理であり、通常のアプリケーションでは実装する必要がない。

PermissionCheckHandlerにより、スレッドローカルにPermissionが保持されている。`nablarch.common.permission.PermissionUtil`からPermissionを取得し、リクエストIDを指定して認可判定を行う。

```java
// PermissionUtilからPermissionを取得する
Permission permission = PermissionUtil.getPermission();

// リクエストIDを指定して認可判定を行う。
if (permission.permit("リクエストID")) {

    // 認可に成功した場合の処理

} else {

    // 認可に失敗した場合の処理

}
```

<details>
<summary>keywords</summary>

認可判定, リクエストID除外, 有効日, 画面項目表示制御, 認可機能, PermissionUtil, Permission, permit, getPermission, 認可チェック使用例

</details>

## 構成 - 概念モデル

リクエストIDを使用して認可判定を行う。リクエストIDの体系はアプリケーション毎に設計する。

**認可単位**: ユーザが機能として認識する最小単位の概念。認可単位には認可を実現するために必要なリクエスト（Webアプリであれば画面のイベント）が複数紐付く。

- グループに認可単位を紐付け → グループ権限
- ユーザに認可単位を直接紐付け → ユーザ権限

> **注意**: グループ権限とユーザ権限が異なる場合は、双方の権限に紐づく認可単位が足し合わされる。

> **注意**: 通常はグループ権限を登録しユーザにグループを割り当てることで権限設定を行う。ユーザ権限はイレギュラーな権限付与に対応するために使用する。

<details>
<summary>keywords</summary>

認可単位, リクエストID, グループ権限, ユーザ権限, 概念モデル, 認可

</details>

## 構成 - クラス図

**インタフェース**:

| インタフェース名 | 概要 |
|---|---|
| `nablarch.common.permission.Permission` | 認可インタフェース。認可判定の実現方法毎に実装クラスを作成する |
| `nablarch.common.permission.PermissionFactory` | Permission生成インタフェース。認可情報の取得先毎に実装クラスを作成する |

**実装クラス**:

| クラス名 | 概要 |
|---|---|
| `nablarch.common.permission.BasicPermission` | 保持しているリクエストIDを使用して認可を行うPermissionの基本実装クラス |
| `nablarch.common.permission.BasicPermissionFactory` | BasicPermissionを生成するPermissionFactoryの基本実装クラス。DBのユーザ・グループ毎の認可単位テーブル構造からユーザに紐付く認可情報を取得する |
| `nablarch.common.handler.PermissionCheckHandler` | 認可判定を行うハンドラ |
| `nablarch.common.permission.PermissionUtil` | 権限管理に使用するユーティリティ |

<details>
<summary>keywords</summary>

Permission, PermissionFactory, BasicPermission, BasicPermissionFactory, PermissionCheckHandler, PermissionUtil, クラス図

</details>

## 構成 - シーケンス図

1. PermissionCheckHandlerは、リクエスト毎にユーザに紐付くPermissionを取得し、認可判定後にPermissionをスレッドローカルに格納する
2. 個別アプリケーションで認可判定が必要な場合は、PermissionUtilからPermissionを取得して認可判定を行う
3. 認証機能によりユーザIDがロックされている場合は認可失敗となる
4. 認可判定の対象リクエストのチェックには、設定で指定されたリクエストIDを使用して行う（:ref:`ignoreRequestIdsSetting` 参照）
5. ユーザIDとリクエストIDはPermissionCheckHandlerより先に処理するハンドラでThreadContextに設定する（:ref:`ThreadContextHandler` が行う）

<details>
<summary>keywords</summary>

PermissionCheckHandler, PermissionUtil, ignoreRequestIdsSetting, ThreadContextHandler, スレッドローカル, シーケンス図

</details>

## 構成 - テーブル定義

テーブル名・カラム名はBasicPermissionFactoryの設定で指定するため任意の名前を使用できる。DBの型もJavaの型に変換可能であれば任意の型を使用できる。

> **注意**: システムアカウントテーブルは認証機能と同じテーブルを使用することを想定しているため、認証機能で使用するデータ項目（パスワード等）が含まれる。

**グループ**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |

**システムアカウント**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| ユーザID | java.lang.String | ユニークキー |
| ユーザIDロック | boolean | |
| 有効日(From) | java.lang.String | 書式 yyyyMMdd。指定しない場合は"19000101" |
| 有効日(To) | java.lang.String | 書式 yyyyMMdd。指定しない場合は"99991231" |

**グループシステムアカウント**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |
| ユーザID | java.lang.String | ユニークキー |
| 有効日(From) | java.lang.String | ユニークキー。書式 yyyyMMdd。指定しない場合は"19000101" |
| 有効日(To) | java.lang.String | 書式 yyyyMMdd。指定しない場合は"99991231" |

**認可単位**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| 認可単位ID | java.lang.String | ユニークキー |

**認可単位リクエスト**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| 認可単位ID | java.lang.String | ユニークキー |
| リクエストID | java.lang.String | ユニークキー |

**グループ権限**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |
| 認可単位ID | java.lang.String | ユニークキー |

**システムアカウント権限**:

| 定義 | Javaの型 | 制約 |
|---|---|---|
| ユーザID | java.lang.String | ユニークキー |
| 認可単位ID | java.lang.String | ユニークキー |

<details>
<summary>keywords</summary>

テーブル定義, グループ, グループID, システムアカウント, ユーザID, ユーザIDロック, グループシステムアカウント, 認可単位, 認可単位ID, 認可単位リクエスト, リクエストID, グループ権限, システムアカウント権限, BasicPermissionFactory

</details>
