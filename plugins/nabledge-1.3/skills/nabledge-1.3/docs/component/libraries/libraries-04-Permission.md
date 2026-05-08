# 認可

## 概要

リクエストに対して認可チェックを行う機能を提供する。

本機能は、ハンドラとして使用されることを想定している。詳細は [認可制御ハンドラ](../../component/handlers/handlers-PermissionCheckHandler.md) を参照すること。

通常アーキテクトが本機能を使用して実装を行い認可処理を局所化するため、アプリケーションプログラマは本機能を直接使用しない。

## 特徴

### グループ単位とユーザ単位を併用した権限設定

グループに対して権限を設定し、ユーザにグループを設定することで、グループ単位の権限を設定することができる。
さらに、ユーザに直接権限を設定することもできるため、イレギュラーな権限付与に対応することができる。

### 自由度の高いテーブル定義

テーブル名・カラム名を自由に付けることができ、カラムのデータ型についてもフレームワークが規定するJavaの型に変換可能であれば任意のデータ型を使用できる。
そのため、個別アプリケーションは、プロジェクトの命名規約を使用して、本機能に必要なテーブル定義を作成することができる。

## 要求

### 実装済み

* 機能（任意のリクエストのかたまり）単位で認可判定の設定を行うことができる。
* ユーザに対してグループを設定することができ、グループ単位で認可判定の設定を行うことができる。
* リクエストIDを設定し、特定のリクエストIDを認可判定の対象から除外できる。
* ユーザに有効日（From/To）を設定できる。
* ユーザとグループの関連に有効日（From/To）を設定できる。
* 認可判定の結果に応じて画面項目（メニューやボタンなど）の表示・非表示を切り替えることができる。

### 未実装

* 本機能で使用するマスタデータをメンテナンスできる。
* 本機能で使用するマスタの初期データを一括登録できる。
* 認証機能によりユーザIDがロックされているユーザの認可判定を失敗にできる。

### 未検討

* データへのアクセスを制限できる。
* 機能単位の権限に有効日（From/To）を設定できる。

## 構成

### 概念モデル

認可情報の概念モデルを下記に示す。
本機能では、リクエストIDを使用して認可判定を行う。リクエストIDの体系は、アプリケーション毎に設計する。

![Permission_ConceptualModel.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_ConceptualModel.jpg)

本機能では、ユーザが機能として認識する最小単位の概念として、認可単位という用語を使用する。

認可単位とリクエストの関係を下記に示す。

![Permission_Unit.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_Unit.jpg)

この例では、社員登録は入力画面→確認画面→完了画面、社員検索は検索画面→検索結果画面と画面遷移することを想定している。
認可単位には、認可を実現するために必要なリクエスト（Webアプリケーションであれば画面のイベント）が複数紐付く。

グループに認可単位を紐付けることでグループ権限、ユーザに認可単位を直接紐付けることでユーザ権限を表す。
グループ権限とユーザ権限の例を下記に示す。

![Permission_Authority.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_Authority.jpg)

| ユーザ | 説明 |
|---|---|
| Aさん | 人事部グループに紐づいているので、社員登録・社員削除・社員検索・社員情報変更を使用できる。 |
| Bさん | 社員グループに紐づいているので、社員検索・社員情報変更を使用できる。 |
| Cさん | パートナーグループに紐づいているので、社員情報変更のみ使用できる。 |
| Xさん | 部長グループと社員グループに紐づいているので、社員登録・社員削除・社員検索・社員情報変更を使用できる。 |
| Yさん | 社員グループに紐づいているので、社員検索・社員情報変更を使用できる。 さらにDさんは、社員登録認可単位に直接紐づいているので、社員登録も使用できる。  > **Note:** > Yさんのようにグループ権限とユーザ権限が異なる場合は、 > 双方の権限に紐づく認可単位が足し合わされる。 |

> **Note:**
> 通常は、認可情報のメンテナンス性を考慮して、グループ権限を登録し、ユーザにグループを割り当てることで権限の設定を行う。
> ユーザに直接認可単位を紐付けるユーザ権限は、イレギュラーな権限付与に対応するために使用する。

### クラス図

![Permission_ClassDiagram.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_ClassDiagram.jpg)

#### 各クラスの責務

##### インタフェース定義

| インタフェース名 | 概要 |
|---|---|
| nablarch.common.permission.Permission | 認可を行うインタフェース。 認可判定の実現方法毎に本インタフェースの実装クラスを作成する。 |
| nablarch.common.permission.PermissionFactory | Permissionを生成するインタフェース。 認可情報の取得先毎に本インタフェースの実装クラスを作成する。 |

##### クラス定義

a) nablarch.common.permission.Permissionの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.permission.BasicPermission | 保持しているリクエストIDを使用して認可を行うPermissionの基本実装クラス。 |

b) nablarch.common.permission.PermissionFactoryの実装クラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.permission.BasicPermissionFactory | BasicPermissionを生成するPermissionFactoryの基本実装クラス。  データベース上のユーザ及びユーザが属するグループ毎に使用できる 認可単位を保持したテーブル構造から、ユーザに紐付く認可情報を取得する。 |

c) その他のクラス

| クラス名 | 概要 |
|---|---|
| nablarch.common.handler.PermissionCheckHandler | 認可判定を行うハンドラ。 |
| nablarch.common.permission.PermissionUtil | 権限管理に使用するユーティリティ。 |

### シーケンス図

本機能のシーケンス図を下記に示す。

* PermissionCheckHandlerは、リクエストの度にユーザに紐付くPermissionを取得し、認可判定を行った後、Permissionをスレッドローカルに格納する。
* 個別アプリケーションにおいて認可判定が必要な場合は、PermissionUtilからPermissionを取得して認可判定を行う。
* 認証機能によりユーザIDがロックされている場合は認可失敗となる。
* 認可判定の対象リクエストのチェックには、設定で指定されたリクエストIDを使用して行う。設定方法は、 [特定のリクエストIDを認可判定の対象から除外する方法](../../component/libraries/libraries-04-Permission.md#特定のリクエストidを認可判定の対象から除外する方法) を参照のこと。
* ユーザIDとリクエストIDは、PermissionCheckHandlerよりも先に処理を行うハンドラにより、ThreadContextに設定しておく必要がある。ThreadContextへの設定は、 [スレッドコンテキスト変数管理ハンドラ](../../component/handlers/handlers-ThreadContextHandler.md#スレッドコンテキスト変数管理ハンドラ) が行う。

![Permission_SequenceDiagram.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_SequenceDiagram.jpg)

### テーブル定義

本機能で使用するテーブル定義を下記に示す。

テーブル名、カラム名は、後述するBasicPermissionFactoryの設定で指定するので、任意の名前を使用できる。
データベースの型についても、表のJavaの型に変換可能な型であれば、任意の型を使用できる。

#### グループ

グループテーブルには、グループ情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |

#### システムアカウント

システムアカウントテーブルには、アカウント情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| ユーザID | java.lang.String | ユニークキー |
| ユーザIDロック | boolean |  |
| 有効日(From) | java.lang.String | 書式 yyyyMMdd 指定しない場合は"19000101" |
| 有効日(To) | java.lang.String | 書式 yyyyMMdd 指定しない場合は"99991231" |

#### グループシステムアカウント

グループシステムアカウントテーブルには、グループとシステムアカウントの関連情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |
| ユーザID | java.lang.String | ユニークキー |
| 有効日(From) | java.lang.String | ユニークキー 書式 yyyyMMdd 指定しない場合は"19000101" |
| 有効日(To) | java.lang.String | 書式 yyyyMMdd 指定しない場合は"99991231" |

#### 認可単位

認可単位には、認可単位情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| 認可単位ID | java.lang.String | ユニークキー |

#### 認可単位リクエスト

認可単位リクエストテーブルには、認可単位とリクエストの関連情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| 認可単位ID | java.lang.String | ユニークキー |
| リクエストID | java.lang.String | ユニークキー |

#### グループ権限

グループ権限テーブルには、グループと認可単位の関連情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| グループID | java.lang.String | ユニークキー |
| 認可単位ID | java.lang.String | ユニークキー |

#### システムアカウント権限

システムアカウント権限テーブルには、システムアカウントと認可単位の関連情報を格納する。

| 定義 | Javaの型 | 制約 |
|---|---|---|
| ユーザID | java.lang.String | ユニークキー |
| 認可単位ID | java.lang.String | ユニークキー |

#### テーブル定義の例

* システムアカウントテーブルは、認証機能と同じテーブルを使用することを想定しているので、認証機能で使用するデータ項目（パスワード等）が含まれている。

![Permission_ERDiagram.jpg](../../../knowledge/assets/libraries-04-Permission/Permission_ERDiagram.jpg)

## 使用方法

使用方法について解説する。

### BasicPermissionFactoryの設定方法

本機能では、DIコンテナの機能を使用して、PermissionCheckHandlerとBasicPermissionFactoryの設定を行い使用する。
DIコンテナの機能については、 [リポジトリ](../../component/libraries/libraries-02-Repository.md) を参照すること。

PermissionCheckHandlerとBasicPermissionFactoryの設定例を下記に示す。

```xml
<component name="webFrontController"
           class="nablarch.fw.web.servlet.WebFrontController">
    <property name="handlerQueue">
        <list>

            <!-- PermissionCheckHandler以外の設定は省略 -->

            <!-- PermissionCheckHandlerの設定 -->
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

<!-- BasicPermissionFactoryの設定 -->
<component name="permissionFactory" class="nablarch.common.permission.BasicPermissionFactory">
    <property name="dbManager">
        <component class="nablarch.core.db.transaction.SimpleDbTransactionManager">
            <property name="dbTransactionName" value="PermissionCheck" />
            <property name="transactionFactory" ref="transactionFactory" />
            <property name="connectionFactory" ref="connectionFactory" />
        </component>
    </property>
    <property name="groupTableSchema">
        <!-- GroupTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.GroupTableSchema">
            <property name="tableName" value="UGROUP" />
            <property name="groupIdColumnName" value="UGROUP_ID" />
        </component>
    </property>
    <property name="systemAccountTableSchema">
        <!-- SystemAccountTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.SystemAccountTableSchema">
            <property name="tableName" value="SYSTEM_ACCOUNT" />
            <property name="userIdColumnName" value="USER_ID" />
            <property name="userIdLockedColumnName" value="USER_ID_LOCKED" />
            <property name="effectiveDateFromColumnName" value="EFFECTIVE_DATE_FROM" />
            <property name="effectiveDateToColumnName" value="EFFECTIVE_DATE_TO" />
        </component>
    </property>
    <property name="groupSystemAccountTableSchema">
        <!-- GroupSystemAccountTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.GroupSystemAccountTableSchema">
            <property name="tableName" value="UGROUP_SYSTEM_ACCOUNT" />
            <property name="groupIdColumnName" value="UGROUP_ID" />
            <property name="userIdColumnName" value="USER_ID" />
            <property name="effectiveDateFromColumnName" value="EFFECTIVE_DATE_FROM" />
            <property name="effectiveDateToColumnName" value="EFFECTIVE_DATE_TO" />
        </component>
    </property>
    <property name="permissionUnitTableSchema">
        <!-- PermissionUnitTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.PermissionUnitTableSchema">
            <property name="tableName" value="PERMISSION_UNIT" />
            <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
        </component>
    </property>
    <property name="permissionUnitRequestTableSchema">
        <!-- PermissionUnitRequestTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.PermissionUnitRequestTableSchema">
            <property name="tableName" value="PERMISSION_UNIT_REQUEST" />
            <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
            <property name="requestIdColumnName" value="REQUEST_ID" />
        </component>
    </property>
    <property name="groupAuthorityTableSchema">
        <!-- GroupAuthorityTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.GroupAuthorityTableSchema">
            <property name="tableName" value="UGROUP_AUTHORITY" />
            <property name="groupIdColumnName" value="UGROUP_ID" />
            <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
        </component>
    </property>
    <property name="systemAccountAuthorityTableSchema">
        <!-- SystemAccountAuthorityTableSchemaの設定 -->
        <component class="nablarch.common.permission.schema.SystemAccountAuthorityTableSchema">
            <property name="tableName" value="SYSTEM_ACCOUNT_AUTHORITY" />
            <property name="userIdColumnName" value="USER_ID" />
            <property name="permissionUnitIdColumnName" value="PERMISSION_UNIT_ID" />
        </component>
    </property>
    <property name="businessDateProvider" ref="businessDateProvider" />
  </property>
</component>

<component name="businessDateProvider" class="nablarch.core.date.BasicBusinessDateProvider" />
```

BasicPermissionFactoryの設定では、複数テーブルのスキーマ情報を指定する。
設定が煩雑にならないように、テーブル毎にスキーマ情報を格納するクラスを設けている。
スキーマ情報を格納するクラスを下記に示す。

| クラス名 | 概要 |
|---|---|
| nablarch.common.permission.schema.GroupTableSchema | グループテーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.SystemAccountTableSchema | システムアカウントテーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.GroupSystemAccountTableSchema | グループシステムアカウントテーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.PermissionUnitTableSchema | 認可単位テーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.PermissionUnitRequestTableSchema | 認可単位リクエストテーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.GroupAuthorityTableSchema | グループ権限テーブルのスキーマ情報を保持するクラス。 |
| nablarch.common.permission.schema.SystemAccountAuthorityTableSchema | システムアカウント権限テーブルのスキーマ情報を保持するクラス。 |

プロパティの説明を下記に示す。

#### PermissionCheckHandlerの設定

| property名 | 設定内容 |
|---|---|
| permissionFactory(必須) | Permissionを生成するPermissionFactory。 |
| ignoreRequestIds | 認可判定を行わないリクエストID。 複数指定する場合はカンマ区切り。 |

#### BasicPermissionFactoryの設定

| property名 | 設定内容 |
|---|---|
| dbManager(必須) | データベースへのトランザクション制御を行うSimpleDbTransactionManager。 nablarch.core.db.transaction.SimpleDbTransactionManagerクラスのインスタンスを指定する。 SimpleDbTransactionManagerについては、 [データベースアクセス(検索、更新、登録、削除)機能](../../component/libraries/libraries-04-DbAccessSpec.md) を参照すること。 |
| groupTableSchema(必須) | グループテーブルのスキーマ情報。GroupTableSchemaクラスのインスタンス。 |
| systemAccountTableSchema(必須) | システムアカウントテーブルのスキーマ情報。SystemAccountTableSchemaクラスのインスタンス。 |
| groupSystemAccountTableSchema(必須) | グループシステムアカウントテーブルのスキーマ情報。GroupSystemAccountTableSchemaクラスのインスタンス。 |
| permissionUnitTableSchema(必須) | 認可単位テーブルのスキーマ情報。PermissionUnitTableSchemaクラスのインスタンス。 |
| permissionUnitRequestTableSchema(必須) | 認可単位リクエストテーブルのスキーマ情報。PermissionUnitRequestTableSchemaクラスのインスタンス。 |
| groupAuthorityTableSchema(必須) | グループ権限テーブルのスキーマ情報。GroupAuthorityTableSchemaクラスのインスタンス。 |
| systemAccountAuthorityTableSchema(必須) | システムアカウント権限テーブルのスキーマ情報。SystemAccountAuthorityTableSchemaクラスのインスタンス。 |
| businessDateProvider(必須) | 業務日付の取得に使用するBusinessDateProvider。 nablarch.core.date.BusinessDateProviderインタフェースを実装したクラスのインスタンスを指定する。 業務日付は、有効日（From/To）のチェックに使用する。  業務日付の詳細は、 [業務日付機能](../../component/libraries/libraries-06-SystemTimeProvider.md#業務日付機能) を参照すること。 |

#### GroupTableSchema（グループ）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| groupIdColumnName(必須) | グループIDカラムの名前。 |

#### SystemAccountTableSchema（システムアカウント）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| userIdColumnName(必須) | ユーザIDカラムの名前。 |
| userIdLockedColumnName(必須) | ユーザIDロックカラムの名前。 |
| failedCountColumnName(必須) | 認証失敗回数カラムの名前。 |
| effectiveDateFromColumnName(必須) | 有効日(From)カラムの名前。 |
| effectiveDateToColumnName(必須) | 有効日(To)カラムの名前。 |

#### GroupSystemAccountTableSchema（グループシステムアカウント）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| groupIdColumnName(必須) | グループIDカラムの名前。 |
| userIdColumnName(必須) | ユーザIDカラムの名前。 |
| effectiveDateFromColumnName(必須) | 有効日(From)カラムの名前。 |
| effectiveDateToColumnName(必須) | 有効日(To)カラムの名前。 |

#### PermissionUnitTableSchema（認可単位）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| permissionUnitIdColumnName(必須) | 認可単位IDカラムの名前。 |

#### PermissionUnitRequestTableSchema（認可単位ケースリクエスト）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| permissionUnitIdColumnName(必須) | 認可単位IDカラムの名前。 |
| requestIdColumnName(必須) | リクエストIDカラムの名前。 |

#### GroupAuthorityTableSchema（グループ権限）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| groupIdColumnName(必須) | グループIDカラムの名前。 |
| permissionUnitIdColumnName(必須) | 認可単位IDカラムの名前。 |

#### SystemAccountAuthorityTableSchema（システムアカウント権限）の設定

| property名 | 設定内容 |
|---|---|
| tableName(必須) | テーブル名。 |
| userIdColumnName(必須) | ユーザIDカラムの名前。 |
| permissionUnitIdColumnName(必須) | 認可単位IDカラムの名前。 |

BasicPermissionFactoryクラスは初期化が必要なため、  [初期化処理の使用手順](../../component/libraries/libraries-02-02-Repository-initialize.md#初期化処理の使用手順)  に記述したInitializableインタフェースを実装している。
[初期化処理の使用手順](../../component/libraries/libraries-02-02-Repository-initialize.md#初期化処理の使用手順) を参考にして、下記のように permissionFactory が初期化されるよう設定すること。

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <!-- 他のコンポーネントは省略 -->
            <component-ref name="permissionFactory"/>
        </list>
    </property>
</component>
```

### 特定のリクエストIDを認可判定の対象から除外する方法

ログイン処理など、一部の処理のみ認可判定の対象から除外したい場合がある。
そのような場合は、PermissionCheckHandlerの設定でignoreRequestIdsプロパティを指定する。
リクエストIDがRW11AA0101とRW11AA0102を認可判定の対象から除外する場合の設定例を下記に示す。

```xml
<!-- PermissionCheckHandlerの設定 -->
<component class="nablarch.common.handler.PermissionCheckHandler">
  <property name="permissionFactory" ref="permissionFactory" />
  <property name="ignoreRequestIds" value="RW11AA0101, RW11AA0102" />
</component>
```

### 使用例

認可判定の使用例を下記に示す。

```java
// ******** 注意 ********
// 下記のコードはフレームワークが行う処理であり、通常のアプリケーションでは実装する必要がない。
// 従って、本フレームワークを使用する場合、アプリケーション・プログラマはこのような実装を行わない。

// PermissionCheckHandlerにより、スレッドローカルにPermissionが保持されている。
// PermissionUtilからPermissionを取得する
Permission permission = PermissionUtil.getPermission();

// リクエストIDを指定して認可判定を行う。
if (permission.permit("リクエストID")) {

    // 認可に成功した場合の処理

} else {

    // 認可に失敗した場合の処理

}
```
