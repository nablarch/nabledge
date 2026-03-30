# リクエストディスパッチハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestPathJavaPackageMapping`

リクエストパスをJavaパッケージ階層にマッピングし、リクエストパスの値に応じて実行するハンドラを切り替えるハンドラ。主に**業務アクションハンドラ**のディスパッチに使用する。

設定例 (`basePath=/app/action/`, `basePackage=nablarch.application`):

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
| /app/application/AdminApp | (ディスパッチ対象無し: 404エラー) |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) では、プロセス起動引数 `--requestPath` に指定された [リクエストパス](../../about/about-nablarch/about-nablarch-concept.md) の値に応じてディスパッチを行う |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が読み込むフレームワーク制御ヘッダ領域のリクエストIDヘッダ `(項目名:requestId)` の値を使用する |
| [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) では、本ハンドラを拡張した [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) を使用する |

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, Main, DataReadHandler, HttpRequestJavaPackageMapping, FwHeaderReader, リクエストディスパッチ, 業務アクションハンドラ, Javaパッケージマッピング, basePath, basePackage

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **リクエストパスの取得** (`nablarch.fw.Request#getRequestPath()`): リクエストオブジェクトからリクエストパスを取得する。
   - **1a. ベースパス外アクセスエラー**: 取得したリクエストパスにベースパスが前方一致しない場合、`Result.NotFound` を送出する。
   - **1b. 非Java識別子を含むパスエラー**: リクエストパスの各ディレクトリ文字列中にJava識別子以外の文字が含まれる場合、`Result.NotFound` を送出する。[^1]
2. **ディスパッチ対象クラスの決定**:
   1. リクエストパス中の `"."` を `"/"` に置換する。
   2. リクエストパス先頭からベースパスと一致する部分をマッピング先Javaパッケージ名に置換する (`optionalPackageMappingEntries` が設定されている場合はそちらが優先。マッチしない場合にベースパスによるマッチングを行う)。
   3. 2の結果を `"."` で分割し、英大文字で始まるトークンをクラス名、それ以前をパッケージ階層とする。
   4. `classNamePrefix`/`classNameSuffix` が設定されている場合はクラス名の前後に付加する。
3. **ディスパッチ対象クラスのインスタンス作成**: コンテキストクラスパスから完全修飾名のクラスをロードし、デフォルトコンストラクタでインスタンスを作成する。
   - **3a. クラスロードエラー**: クラスがコンテキストクラスパス上に存在しない場合、`Result.NotFound` を送出する。
   - **3b. インスタンス生成エラー**: デフォルトコンストラクタが未定義またはコンストラクタで例外が発生した場合、実行時例外を送出する。
5. **ハンドラインスタンスをハンドラキューに追加**: `immediate` 設定値によって追加位置が異なる。
   - `immediate=true` (デフォルト): ディスパッチハンドラの直後にハンドラインスタンスを挿入する。
   - `immediate=false`: ハンドラキューの末尾にハンドラインスタンスを追加する。
   - ハンドラインターフェースを実装していないクラスの場合、実行コンテキスト上の `MethodBinder` を使用して [メソッド単位のディスパッチ](../../about/about-nablarch/about-nablarch-concept.md) を行うアダプタが作成される。
   - **5a. ディスパッチ不可能エラー**: ハンドラインターフェース未実装かつ `MethodBinder` が未設定の場合、`Result.NotFound` を送出する。
6. **後続ハンドラの実行**: ハンドラキュー上の後続ハンドラに処理を委譲し、結果を取得する。

**[復路処理]**

7. **正常終了**: ステップ6の結果をリターンして終了する。

**[例外処理]**

- **6a. 後続ハンドラ処理でエラー**: 後続ハンドラの処理中に例外が発生した場合はそのまま再送出して終了する。

[^1]: リクエストパスにascii範囲外のマルチバイト文字が含まれていても許容される。ただし、マッピング先のJavaクラスにascii範囲外の文字が含まれる場合は404エラー扱いとなる。

<details>
<summary>keywords</summary>

nablarch.fw.Request#getRequestPath(), Result.NotFound, MethodBinder, immediate, classNamePrefix, classNameSuffix, ハンドラ処理フロー, クラスロード, メソッド単位のディスパッチ, method_binding, 往路処理, 復路処理

</details>

## 設定項目・拡張ポイント

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePath | String | | "" | ベースパス文字列 |
| basePackage | String | | "" | ベースパッケージ |
| classNamePrefix | String | | "" | ディスパッチ対象クラス名の接頭辞 |
| classNameSuffix | String | | "" | ディスパッチ対象クラス名の接尾辞 |
| immediate | boolean | | true | ハンドラ追加位置 (true: ディスパッチハンドラ直後に挿入, false: キュー末尾に追加) |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry | | null | リクエストパスのパターンとマッピング先Javaパッケージの組み合わせ |

**基本設定例** (ハンドラキュー末尾に追加):

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="nablarch.sample.batch.action" />
  <property name="immediate" value="false" />
</component>
```

**クラス名サフィックスを"Action"とする場合**:

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"     value="nablarch.sample.batch.action" />
  <property name="immediate"       value="false" />
  <property name="classNameSuffix" value="Action" />
</component>
```

**複雑なマッピング設定 (`optionalPackageMappingEntries`)**

`optionalPackageMappingEntries` に設定した順番でリクエストパスとのマッチングが行われ、最初にマッチしたJavaパッケージが使用される。マッチするものが存在しない場合、`basePackage` が使用される。リクエストパスのパターンはGlob式に似た書式で指定する (詳細は :ref:`requestHandlerEntry` を参照)。

> **注意**: リクエストパスのパターンのマッチは、リクエストパス中のすべての `"."` をスラッシュ `"/"` に置換してから行われる（Nablarchのバッチ処理で過去に使用していたドット区切りのリクエストパスとの互換性維持のため）。

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

basePath, basePackage, classNamePrefix, classNameSuffix, immediate, optionalPackageMappingEntries, JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, requestPattern, requestHandlerEntry, 複雑なマッピング設定

</details>
