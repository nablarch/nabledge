# リクエストディスパッチハンドラ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/handlers/common/request_path_java_package_mapping.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Request.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/RequestPathJavaPackageMapping.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/handler/JavaPackageMappingEntry.html)

## ハンドラクラス名

**クラス**: `nablarch.fw.handler.RequestPathJavaPackageMapping`

リクエストパスを元にアクションへ処理を委譲するハンドラ。主に [messaging](../../processing-pattern/db-messaging/db-messaging-messaging.md) でアクションにディスパッチする目的で使用する。

リクエストパスは `Request#getRequestPath()` から取得する。

**リクエストパス形式**: `/<basePath>/<className>`

| ラベル | 意味 |
|---|---|
| basePath | ディスパッチ対象を表すベースパス |
| className | クラス名（必須） |

例: クラス `xxx.yyy.ExampleBatchAction`、ベースパス `batch` → リクエストパス `/batch/ExampleBatchAction`

> **重要**: `Request#getRequestPath()` で取得されるリクエストパスは、 :ref:`main` に記載の通り、コマンドライン起動時に `-requestPath` オプションで指定する。

処理: リクエストパスを解析し、対応するアクションの `handle` メソッドを呼び出す。

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, リクエストディスパッチ, アクション委譲, リクエストパス解析, メッセージングディスパッチ

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

nablarch-fw, モジュール依存設定, com.nablarch.framework

</details>

## 制約

なし

<details>
<summary>keywords</summary>

制約なし, RequestPathJavaPackageMapping制約

</details>

## ベースパッケージ、ベースパスの設定

`basePackage` プロパティでディスパッチ先クラスのベースパッケージ、`basePath` プロパティでリクエストパスのベースパスを設定する。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
</component>
```

<details>
<summary>keywords</summary>

basePackage, basePath, ベースパッケージ設定, ベースパス設定, RequestPathJavaPackageMapping設定

</details>

## 複数パッケージのクラスにディスパッチする

リクエストパスのクラス名指定箇所に、ベースパッケージからの相対パッケージ名を指定することで複数パッケージのクラスへディスパッチできる。

例: [request_path_java_package_mapping_path_setting](#s3) の設定（basePath=`/app/action/`、basePackage=`nablarch.application`）で `nablarch.application.xxx.ExampleBatchAction` へディスパッチする場合、リクエストパスに `/app/action/xxx/ExampleBatchAction` を指定する。

<details>
<summary>keywords</summary>

複数パッケージディスパッチ, 相対パッケージ指定, リクエストパスサブパッケージ

</details>

## クラス名のプレフィクス、サフィックスの設定

`classNamePrefix` および `classNameSuffix` プロパティを設定することで、リクエストパスでのクラス名プレフィクス・サフィックスの指定を省略できる。

例: クラス名が `XxxProjectXxxxBatchAction`（プレフィクス `XxxProject`、サフィックス `BatchAction`）の場合、以下の設定でリクエストパスを `/app/action/Xxxx` のように省略できる。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"        value="/app/action/" />
  <property name="basePackage"     value="nablarch.application" />
  <property name="classNamePrefix" value="XxxProject" />
  <property name="classNameSuffix" value="BatchAction" />
</component>
```

<details>
<summary>keywords</summary>

classNamePrefix, classNameSuffix, クラス名省略, プレフィクス設定, サフィックス設定

</details>

## 複雑なパッケージへのディスパッチ

[request_path_java_package_mapping_multi_package_dispatch](#s4) の方法では、アクションを同一パッケージ配下のサブパッケージにまとめる必要がある制約がある。`optionalPackageMappingEntries` プロパティに `JavaPackageMappingEntry` を使用してリクエストパスごとに別々のパッケージを設定できる。

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
          <property name="basePackage"    value="nablarch.sample.apps1" />
        </component>
        <component class="nablarch.fw.handler.JavaPackageMappingEntry">
          <property name="requestPattern" value="/user//" />
          <property name="basePackage"    value="nablarch.sample.apps2" />
        </component>
      </list>
    </property>
    <!-- optionalPackageMappingEntriesにマッチするものが存在しない場合に使用されるJavaパッケージ -->
    <property name="basePackage" value="nablarch.sample.base" />
</component>
```

<details>
<summary>keywords</summary>

JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, optionalPackageMappingEntries, requestPattern, 複雑なパッケージディスパッチ, パッケージマッピング, リクエストパターン設定

</details>

## ディスパッチ対象クラスを遅延実行する

デフォルトではディスパッチ先クラスへの委譲は即時実行される。ハンドラキュー上の後続ハンドラ実行後にディスパッチしたい場合は、`immediate` プロパティに `false` を設定する。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="${nablarch.commonProperty.basePackage}" />
  <property name="immediate"   value="false" />
</component>
```

<details>
<summary>keywords</summary>

immediate, 遅延実行, ディスパッチタイミング制御, 後続ハンドラ実行後ディスパッチ

</details>
