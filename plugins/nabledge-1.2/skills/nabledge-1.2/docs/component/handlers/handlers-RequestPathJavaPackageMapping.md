# リクエストディスパッチハンドラ

## 概要

**クラス名**: `nablarch.fw.handler.RequestPathJavaPackageMapping`

リクエストパスをJavaパッケージ階層にマッピングし、リクエストパスの値に応じて実行するハンドラを切り替えるハンドラ。主に**業務アクションハンドラ**のディスパッチに使用する。

**ハンドラキュー位置** ([../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) での構成):
DataReadHandler → **RequestPathJavaPackageMapping** → MessagingAction

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
</component>
```

上記設定時のリクエストパスとディスパッチ先クラスの対応:

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /app/action/AdminApp | nablarch.application.AdminApp |
| /app/action/user/UserApp | nablarch.application.user.UserApp |
| /app/application/AdminApp | (ディスパッチ対象無し:404エラー) |

**関連するハンドラ**:

| ハンドラ | 内容 |
|---|---|
| [Main](handlers-Main.md) | [../architectural_pattern/batch](../../processing-pattern/nablarch-batch/nablarch-batch-batch-architectural_pattern.md) では、プロセス起動引数 `--requestPath` に指定された [リクエストパス](../../about/about-nablarch/about-nablarch-concept.md) の値に応じてディスパッチ |
| [DataReadHandler](handlers-DataReadHandler.md) | [../architectural_pattern/messaging_request_reply](../../processing-pattern/mom-messaging/mom-messaging-messaging_request_reply.md) では、[../reader/FwHeaderReader](../readers/readers-FwHeaderReader.md) が読み込むリクエストIDヘッダ (項目名:requestId) の値を使用 |
| [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) | [../architectural_pattern/web_gui](../../processing-pattern/web-application/web-application-web_gui.md) では、本ハンドラを拡張した [HttpRequestJavaPackageMapping](handlers-HttpRequestJavaPackageMapping.md) を使用 |

<details>
<summary>keywords</summary>

RequestPathJavaPackageMapping, nablarch.fw.handler.RequestPathJavaPackageMapping, リクエストディスパッチ, Javaパッケージマッピング, 業務アクションハンドラ, ディスパッチ, basePath, basePackage, HttpRequestJavaPackageMapping, DataReadHandler, FwHeaderReader

</details>

## ハンドラ処理フロー

**[往路処理]**

1. **リクエストパスの取得**: `nablarch.fw.Request#getRequestPath()` でリクエストパスを取得
   - **1a. ベースパス外アクセス**: ベースパスが前方一致しない場合、`Result.NotFound` を送出
   - **1b. 非Java識別子エラー**: ディレクトリ文字列にJava識別子以外の文字が含まれる場合、`Result.NotFound` を送出（ascii範囲外のマルチバイト文字は許容。ただしマッピング先クラス名にascii範囲外文字が含まれる場合は404エラー）
2. **ディスパッチ対象クラスの決定**:
   1. リクエストパス中の `.` を `/` に置換
   2. ベースパスと一致する部分をベースパッケージ名に置換（`optionalPackageMappingEntries` が設定されている場合は優先。マッチしない場合はベースパスによるマッチング。詳細は :ref:`複雑なマッピング定義<optionalPackageMappingEntries>` 参照）
   3. 置換後の文字列を `.` で分割し、英大文字で始まるトークンをクラス名、それ以前をパッケージ階層とする
   4. `classNamePrefix`/`classNameSuffix` が設定されている場合はクラス名の前後に付加
3. **インスタンス作成**: 完全修飾名のクラスをロードし、デフォルトコンストラクタでインスタンスを作成
   - **3a. クラスロードエラー**: クラスがクラスパス上に存在しない場合、`Result.NotFound` を送出
   - **3b. インスタンス生成エラー**: デフォルトコンストラクタ未定義またはコンストラクタ内例外発生の場合、実行時例外を送出
5. **ハンドラキューへの追加**:
   - `immediate=true`（デフォルト）: ディスパッチハンドラの直後に挿入
   - `immediate=false`: ハンドラキューの末尾に追加
   - ハンドラインターフェース未実装の場合: `MethodBinder` を使用して [メソッド単位のディスパッチ](../../about/about-nablarch/about-nablarch-concept.md) を行うアダプタを作成
   - **5a. ディスパッチ不可能**: ハンドラインターフェース未実装かつ `MethodBinder` 未設定の場合、`Result.NotFound` を送出
6. **後続ハンドラの実行**: 後続ハンドラへ処理を委譲し結果を取得

**[復路処理]**

7. **正常終了**: 後続ハンドラの結果をリターンして終了

**[例外処理]**

- **後続ハンドラ処理エラー**: 後続ハンドラ処理中に例外が発生した場合はそのまま再送出して終了

<details>
<summary>keywords</summary>

Result.NotFound, nablarch.fw.Request, getRequestPath, MethodBinder, 往路処理, 復路処理, 例外処理, Java識別子, immediate, optionalPackageMappingEntries, classNamePrefix, classNameSuffix

</details>

## 設定項目・拡張ポイント

**設定項目**:

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
|---|---|---|---|---|
| basePath | String |  | "" | ベースパス文字列 |
| basePackage | String |  | "" | ベースパッケージ |
| classNamePrefix | String |  | "" | ディスパッチ対象クラス名の接頭辞 |
| classNameSuffix | String |  | "" | ディスパッチ対象クラス名の接尾辞 |
| immediate | boolean |  | true | ハンドラ追加位置（true=ディスパッチハンドラ直後、false=キュー末尾） |
| optionalPackageMappingEntries | nablarch.fw.handler.JavaPackageMappingEntry |  | null | リクエストパスのパターンとマッピング先Javaパッケージの組み合わせ |

**基本設定**:

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage" value="nablarch.sample.batch.action" />
  <property name="immediate" value="false" />
</component>
```

**クラス名サフィックスに `Action` を付与する場合**:

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"     value="nablarch.sample.batch.action" />
  <property name="immediate"       value="false" />
  <property name="classNameSuffix" value="Action" />
</component>
```

**複雑なマッピング設定 (`optionalPackageMappingEntries`)**:

`optionalPackageMappingEntries` に設定した順番にリクエストパスのパターンマッチングが行われ、最初にマッチしたJavaパッケージが使用される。マッチしない場合は `basePackage` が使用される。パターンはGlob式に似た書式で指定（:ref:`requestHandlerEntry` と同一記法）。

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

> **注意**: パターンマッチはリクエストパス中のすべての `.` を `/` に置換してから行われる。これはNablarchのバッチ処理で過去に使用していたドット区切りのリクエストパス（例: `ss01A001.B01AA001Action/B01AA0010`）との互換性のため。

<details>
<summary>keywords</summary>

basePath, basePackage, classNamePrefix, classNameSuffix, immediate, optionalPackageMappingEntries, JavaPackageMappingEntry, nablarch.fw.handler.JavaPackageMappingEntry, requestPattern, 設定項目, 複雑なマッピング設定

</details>
