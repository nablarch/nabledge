# リクエストディスパッチハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/request_path_java_package_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Request.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/JavaPackageMappingEntry.html)

## ハンドラクラス名

リクエストパスを解析してアクションの `handle` メソッドに処理を委譲するハンドラ。主に [messaging](../../processing-pattern/db-messaging/db-messaging-messaging.md) で使用する。

リクエストパス形式: `/<basePath>/<className>`

| ラベル | 意味 |
|---|---|
| basePath | ディスパッチ対象を表すベースパス |
| className | クラス名（必須） |

> **重要**: リクエストパス（`Request#getRequestPath()`）は、:ref:`main` に記載の通り、コマンドライン起動時に `-requestPath` オプションで指定する。

**クラス名**: `nablarch.fw.handler.RequestPathJavaPackageMapping`

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, Request#getRequestPath(), リクエストディスパッチハンドラ, アクションへのディスパッチ, リクエストパス形式

</details>

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw</artifactId>
</dependency>
```

<details>
<summary>keywords</summary>

nablarch-fw, com.nablarch.framework, モジュール依存関係

</details>

## 制約

なし。

<details>
<summary>keywords</summary>

制約なし

</details>

## ベースパッケージ、ベースパスの設定

`basePackage` プロパティでディスパッチ先クラスのベースパッケージ、`basePath` プロパティでリクエストパスのベースパスを設定する。例: クラス `xxx.yyy.ExampleBatchAction` をベースパス `batch` でディスパッチする場合、リクエストパスは `/batch/ExampleBatchAction`。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
</component>
```

<details>
<summary>keywords</summary>

basePackage, basePath, ベースパッケージ設定, ベースパス設定

</details>

## 複数パッケージのクラスにディスパッチする

リクエストパスのクラス名箇所にベースパッケージからの相対パッケージ名を指定することで、サブパッケージ内のクラスにもディスパッチできる。

例: `basePackage=nablarch.application`、`basePath=/app/action/` の設定で `nablarch.application.xxx.ExampleBatchAction` にディスパッチする場合、リクエストパスは `/app/action/xxx/ExampleBatchAction` を指定する。

<details>
<summary>keywords</summary>

複数パッケージ, 相対パッケージ名, マルチパッケージディスパッチ

</details>

## クラス名のプレフィクス、サフィックスの設定

`classNamePrefix`・`classNameSuffix` プロパティを設定することで、リクエストパスでのプレフィクス・サフィックスの指定を省略できる。

例: クラス名 `XxxProjectXxxxBatchAction` に対して `classNamePrefix=XxxProject`、`classNameSuffix=BatchAction` を設定すると、リクエストパスを `/app/action/Xxxx` と省略できる。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
  <property name="classNamePrefix" value="XxxProject" />
  <property name="classNameSuffix" value="BatchAction" />
</component>
```

<details>
<summary>keywords</summary>

classNamePrefix, classNameSuffix, クラス名プレフィクス, クラス名サフィックス

</details>

## 複雑なパッケージへのディスパッチ

アクションが同一パッケージ配下のサブパッケージにまとめられない場合、`optionalPackageMappingEntries` プロパティに `JavaPackageMappingEntry` を使ってリクエストパスごとに別々のパッケージを設定できる。`optionalPackageMappingEntries` にマッチしない場合は `basePackage` が使用される。

以下のようなリクエストパスとディスパッチ先の対応を設定する例:

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /admin/AdminApp | nablarch.sample.apps1.admin.AdminApp |
| /user/UserApp | nablarch.sample.apps2.user.UserApp |
| /BaseApp | nablarch.sample.base.BaseApp |

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
    <property name="optionalPackageMappingEntries">
      <!-- リクエストパスのパターンとJavaパッケージの組み合わせをマッチさせたい順番に記載する。 -->
      <list>
        <component class="nablarch.fw.handler.JavaPackageMappingEntry">
          <property name="requestPattern" value="/admin//" />
          <property name="basePackage" value="nablarch.sample.apps1" />
        </component>
        <component class="nablarch.fw.handler.JavaPackageMappingEntry">
          <property name="requestPattern" value="/user//" />
          <property name="basePackage" value="nablarch.sample.apps2" />
        </component>
      </list>
    </property>
    <!-- optionalPackageMappingEntriesにマッチするものが存在しない場合に使用されるJavaパッケージ -->
    <property name="basePackage" value="nablarch.sample.base" />
</component>
```

<details>
<summary>keywords</summary>

optionalPackageMappingEntries, JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, requestPattern, 複雑なパッケージへのディスパッチ

</details>

## ディスパッチ対象クラスを遅延実行する

デフォルトはディスパッチ対象クラスへの委譲が即時実行される。ハンドラキュー上の後続ハンドラ実行後にディスパッチしたい場合は `immediate` プロパティに `false` を設定する。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="${nablarch.commonProperty.basePackage}" />
  <property name="immediate" value="false" />
</component>
```

<details>
<summary>keywords</summary>

immediate, 遅延実行, ハンドラキュー後続処理

</details>
