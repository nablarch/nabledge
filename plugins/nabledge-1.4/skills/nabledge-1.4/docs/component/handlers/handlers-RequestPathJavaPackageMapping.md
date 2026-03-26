# リクエストディスパッチハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestPathJavaPackageMapping`

リクエストパスをJavaパッケージ階層にマッピングし、リクエストパスの値に応じて実行するハンドラを切り替えるハンドラ。主に業務アクションハンドラのディスパッチに使用する。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
</component>
```

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /app/action/AdminApp | nablarch.application.AdminApp |
| /app/action/user/UserApp | nablarch.application.user.UserApp |
| /app/application/AdminApp | (ディスパッチ対象無し:404エラー) |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) では、`--requestPath` 引数のリクエストパスに応じてディスパッチ |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が読み込むフレームワーク制御ヘッダ領域の `requestId` ヘッダの値を使用 |
| [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) では本ハンドラを拡張した [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) を使用 |

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, basePath, basePackage, リクエストディスパッチ, 業務アクションハンドラ, Javaパッケージマッピング, HttpRequestJavaPackageMapping, DataReadHandler, FwHeaderReader

</details>

## ハンドラ処理フロー

**往路処理**

1. `nablarch.fw.Request#getRequestPath(): String` でリクエストパスを取得
   - 1a. ベースパスが前方一致しない場合: `Result.NotFound` を送出
   - 1b. パスにJava識別子以外の文字が含まれる場合: `Result.NotFound` を送出
2. ディスパッチ対象クラスの完全修飾名を決定:
   1. リクエストパス中の `"."` を `"/"` に置換
   2. ベースパスをベースパッケージ名に置換（`optionalPackageMappingEntries` が設定されている場合はそちらが優先、マッチしない場合は `basePath` によるマッチングを行う）
   3. 結果を `"."` で分割し、英大文字で始まるトークンをクラス名、それ以前のトークンをパッケージ階層とする
   4. `classNamePrefix`/`classNameSuffix` が設定されている場合はクラス名の前後に付加
3. コンテキストクラスパスから完全修飾名のクラスをロードし、デフォルトコンストラクタでインスタンス作成
   - 3a. クラスがコンテキストクラスパス上に存在しない場合: `Result.NotFound` を送出
   - 3b. インスタンス生成失敗（デフォルトコンストラクタ未定義など）: 実行時例外を送出
5. ハンドラキューにインスタンスを追加
   - `immediate=true`（デフォルト）: ディスパッチハンドラの直後に挿入
   - `immediate=false`: ハンドラキューの末尾に追加
   - ハンドラインタフェース未実装の場合は MethodBinder を使用して [メソッド単位のディスパッチ](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) を行うアダプタを作成
   - 5a. ハンドラインタフェース未実装かつ MethodBinder 未設定: `Result.NotFound` を送出
6. 後続ハンドラに処理を委譲

**復路処理**

7. 結果をリターンして終了

**例外処理**

- 6a. 後続ハンドラで例外発生: そのまま再送出

> **注意**: リクエストパスに ascii 範囲外のマルチバイト文字が含まれていても許容される。ただし、マッピング先 Java クラス名に ascii 範囲外の文字が含まれる場合は 404 エラーとなる。

<details>
<summary>keywords</summary>

nablarch.fw.Request, Result.NotFound, MethodBinder, immediate, ハンドラ処理フロー, ディスパッチ, クラスロード, メソッドディスパッチ, method_binding, classNamePrefix, classNameSuffix, optionalPackageMappingEntries

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePath | String | | "" | ベースパス文字列 |
| basePackage | String | | "" | ベースパッケージ |
| classNamePrefix | String | | "" | ディスパッチ対象クラス名の接頭辞 |
| classNameSuffix | String | | "" | ディスパッチ対象クラス名の接尾辞 |
| immediate | boolean | | true | ハンドラ追加位置（true=ディスパッチハンドラ直後に挿入、false=キュー末尾に追加） |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry | | null | リクエストパスパターンとマッピング先Javaパッケージの組み合わせ |

**基本設定**:

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="nablarch.sample.batch.action" />
  <property name="immediate" value="false" />
</component>
```

**classNameSuffix 使用例**（ディスパッチ対象クラス名を [リソース名] + "Action" とする場合）:

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"     value="nablarch.sample.batch.action" />
  <property name="immediate"       value="false" />
  <property name="classNameSuffix" value="Action" />
</component>
```

**複雑なマッピング設定（optionalPackageMappingEntries）**:

`optionalPackageMappingEntries` を使用することで、リクエストパスごとにマッピング先Javaパッケージを切り替えられる。設定した順にパターンマッチングを行い、最初にマッチしたパッケージを使用する。マッチしない場合は `basePackage` を使用する。パターン書式は :ref:`requestHandlerEntry` と同一のGlob式に似た書式。

> **注意**: パターンマッチは、リクエストパス中のすべての `"."` を `"/"` に置換してから行われる。これはドット区切りのリクエストパス（例: `ss01A001.B01AA001Action/B01AA0010`）との後方互換性のため。

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="optionalPackageMappingEntries">
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
  <property name="basePackage" value="nablarch.sample.base" />
</component>
```

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /admin/AdminApp | nablarch.sample.apps1.admin.AdminApp |
| /user/UserApp | nablarch.sample.apps2.user.UserApp |
| /BaseApp | nablarch.sample.base.BaseApp |

<details>
<summary>keywords</summary>

basePath, basePackage, classNamePrefix, classNameSuffix, immediate, optionalPackageMappingEntries, JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, requestPattern, 設定項目, 複雑なマッピング

</details>
