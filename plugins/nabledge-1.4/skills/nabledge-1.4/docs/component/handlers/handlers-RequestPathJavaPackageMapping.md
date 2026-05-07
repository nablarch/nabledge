## リクエストディスパッチハンドラ

**クラス名:** `nablarch.fw.handler.RequestPathJavaPackageMapping`

-----

-----

### 概要

[リクエストディスパッチハンドラ](../../component/handlers/handlers-RequestPathJavaPackageMapping.md) は、 [リクエストパス](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) をJavaパッケージ階層にマッピングすることで、
リクエストパスの値に応じて実行するハンドラを任意に切り替えることを可能とするハンドラである。

主に **業務アクションハンドラ** のディスパッチを行う際に使用する。

例えば、以下の設定例では、リクエストパスが **/app/action/** で始まる場合に、
後続処理を Javaパッケージ **nablarch.application** 配下のクラスにディスパッチする。
(ディスパッチ対象のクラスをハンドラキューに追加する。)

```xml
<!-- ディスパッチ -->
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePath"    value="/app/action/" />
  <property name="basePackage" value="nablarch.application" />
</component>
```

この場合、リクエストパスの値とディスパッチ先のクラス名との対応は以下のようになる。

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /app/action/AdminApp | nablarch.application.AdminApp |
| /app/action/user/UserApp | nablarch.application.user.UserApp |
| /app/application/AdminApp | (ディスパッチ対象無し:404エラー) |

-----

**ハンドラ処理概要** ([MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) での構成)

| ハンドラ | クラス名 | 入力型 | 結果型 | 往路処理 | 復路処理 | 例外処理 | コールバック |
|---|---|---|---|---|---|---|---|
| データリードハンドラ(FW制御ヘッダリーダ/メッセージリーダ利用) | nablarch.fw.handler.DataReadHandler_messaging | Object | Result | 要求電文を受信しFW制御ヘッダ部を解析して要求電文オブジェクト(RequestMessage)を作成し後続のハンドラに渡す。また、FW制御ヘッダのrequestId/userIdの値をメッセージコンテキストに設定する。 | - | - | - |
| リクエストディスパッチハンドラ | nablarch.fw.handler.RequestPathJavaPackageMapping | Request | Object | 引数として渡されたリクエストオブジェクトのリクエストパスから、処理対象の業務アクションを決定しハンドラキューに追加する。 | - | - | - |
| 同期応答電文処理用業務アクションハンドラ | nablarch.fw.action.MessagingAction | RequestMessage | ResponseMessage | 要求電文の内容をもとに業務処理を実行する。 | 業務処理の結果と要求電文の内容から応答電文の内容を作成して返却する。 | - | トランザクションロールバック時にエラー応答電文を作成する。 |

**関連するハンドラ**

| ハンドラ | 内容 |
|---|---|
| [共通起動ランチャ](../../component/handlers/handlers-Main.md) | [バッチ実行制御基盤](../../processing-pattern/nablarch-batch/nablarch-batch-architectural-pattern-batch.md) では、プロセス起動引数 **--requestPath** に指定された [リクエストパス](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) の値に応じてディスパッチを行う。 |
| [データリードハンドラ](../../component/handlers/handlers-DataReadHandler.md) | [MOM同期応答メッセージング実行制御基盤](../../processing-pattern/mom-messaging/mom-messaging-messaging-request-reply.md) では、 [要求電文(FWヘッダ)リーダ](../../component/readers/readers-FwHeaderReader.md) が読み込むフレームワーク制御ヘッダ領域のリクエストIDヘッダ **(項目名:requestId)** の値を使用する。 |
| [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-HttpRequestJavaPackageMapping.md) | [画面オンライン実行制御基盤](../../processing-pattern/web-application/web-application-web-gui.md) では、本ハンドラを拡張した [HTTPリクエストディスパッチハンドラ](../../component/handlers/handlers-HttpRequestJavaPackageMapping.md) を使用する。 |

### ハンドラ処理フロー

**[往路処理]**

**1. (リクエストパスの取得)**

ハンドラの引数として渡されたリクエストオブジェクトから、以下のAPIを使用してリクエストパスを取得する。:

```
nablarch.fw.Request#getRequestPath(): String
```

**1a. (ベースパス外アクセスエラー)**

取得したリクエストパスに対して、本ハンドラに設定されたベースパスが前方一致しない場合は、
実行時例外 [Result.NotFound](../../javadoc/nablarch/fw/Result.NotFound.html) を送出する。

**1b. (非Java識別子を含むパスによるアクセスエラー)**

取得したリクエストパスの各ディレクトリ文字列中に、Java識別子以外の文字 [1] が含まれていた場合は、
Javaの名前空間にマッピングすることができないので、実行時例外 [Result.NotFound](../../javadoc/nablarch/fw/Result.NotFound.html) を送出する。

**2. (ディスパッチ対象クラスの決定)**

以下の仕様に従って、ディスパッチ対象クラスの完全修飾名を決定する。

1. リクエストパス中の **”.”** を **”/”** に置換する。
2. リクエストパスの先頭から 本ハンドラに設定された **ベースパス** と一致する部分を、同じく本ハンドラに設定された
  **マッピング先Javaパッケージ名** に置換する。
  (**optionalPackageMappingEntries** が設定されている場合は、そちらの設定によるマッピングが優先される。
  マッチするものが存在しなかった場合は、上記の **ベースパス** によるマッチングを行う。
  **optionalPackageMappingEntries** の仕様と設定方法については、 [複雑なマッピング定義](../../component/handlers/handlers-RequestPathJavaPackageMapping.md#-javaパッケージの組み合わせ----------------------------------------------javapackagemappingentry----デフォルト--null---)
  の項を参照。)
3. **2.** の結果文字列を **”.”** で分割する。分割後の各トークンの内、英大文字で始まっているものをクラス名とし、
  それ以前の各トークンをパッケージ階層とする。
4. 本ハンドラ設定値として、 **ディスパッチ対象クラス名の接頭辞/接尾辞** が設定されている場合はクラス名の前後にそれぞれ付加する。

**3. (ディスパッチ対象クラスのインスタンス作成)**

コンテキストクラスパスから、 **2.** で決定された完全修飾名のクラスをロードし、
デフォルトコンストラクタを用いてインスタンスを作成する。

**3a. (クラスロードエラー)**

対象のクラスがコンテキストクラスパス上に存在しなかった場合は、実行時例外 [Result.NotFound](../../javadoc/nablarch/fw/Result.NotFound.html) を送出する。

**3b. (インスタンス生成時エラー)**

対象のクラスにデフォルトコンストラクタが定義されていない場合や、コンストラクタ内で例外が送出されるなど、
何らかの理由でインスタンスの生成に失敗した場合は、実行時例外を送出する。

**5. (ハンドラインスタンスをハンドラキューに追加)**

実行コンテキスト上のハンドラキューにハンドラインスタンスを追加する。
ハンドラの追加位置は、本ハンドラの設定値(**immediate**)によって以下のように定まる。

ディスパッチハンドラの直後にハンドラインスタンスを挿入する。 (デフォルト)

ハンドラキューの末尾にハンドラインスタンスを追加する。

なお、ハンドラキューに追加したインスタンスがハンドラインタフェースを実装していなかった場合は、
実行コンテキスト上の **MethodBinder** を使用して、 [メソッド単位のディスパッチ](../../about/about-nablarch/about-nablarch-architectural-pattern-concept.md#リクエストの識別と業務処理の実行) を行う
ハンドラインターフェースのアダプタが作成される。

**5a. (ディスパッチ不可能エラー)**

対象のクラスがハンドラインターフェースを実装しておらず、また、実行コンテキスト上に **MethodBinder** が設定されていない場合は、
[Result.NotFound](../../javadoc/nablarch/fw/Result.NotFound.html) が送出される。

**6. (後続ハンドラの実行)**

ハンドラキュー上の後続ハンドラに対して処理を委譲し、その結果を取得する。

**[復路処理]**

**7. (正常終了)**

**6.** の結果をリターンして終了する。

**[例外処理]**

**6a. (後続ハンドラ処理でエラー)**

後続ハンドラの処理中に例外が発生した場合はそのまま再送出して終了する。

リクエストパスに ascii範囲外のマルチバイト文字が含まれていても許容される。
ただし、マッピング先のJavaクラスにascii範囲外の文字が含まれる場合は、404エラー扱いとなる。

### 設定項目・拡張ポイント

本ハンドラの設定項目の一覧は以下のとおり。

| 設定項目 | プロパティ名 | データ型 | 備考 |
|---|---|---|---|
| ベースパス文字列 | basePath | String | 任意指定 (デフォルト = "") |
| ベースパッケージ | basePackage | String | 任意指定 (デフォルト = "") |
| ディスパッチ対象クラス名の接頭辞 | classNamePrefix | String | 任意指定 (デフォルト = "") |
| ディスパッチ対象クラス名の接尾辞 | classNameSuffix | String | 任意指定 (デフォルト = "") |
| ハンドラ追加位置 | immediate | boolean | 任意指定 (デフォルト = true) |
| リクエストパスのパターンとマッピング先 Javaパッケージの組み合わせ | optionalPackageMappingEntries | nablarch.fw.handler .JavaPackageMappingEntry | 任意指定 (デフォルト = null) |

**基本設定**

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <!-- ベースパッケージ -->
  <property name="basePackage" value="nablarch.sample.batch.action" />
  <!-- ハンドラ追加位置(ハンドラキューの末尾に追加) -->
  <property name="immediate" value="false" />
</component>
```

**ディスパッチ対象のクラス名を [リソース名] + "Action" とする場合**

```xml
<component class="nablarch.fw.handler.RequestPathJavaPackageMapping">
  <property name="basePackage"     value="nablarch.sample.batch.action" />
  <property name="immediate"       value="false" />
  <property name="classNameSuffix" value="Action" />
</component>
```

**複雑なマッピング設定**

optionalPackageMappingEntries プロパティに設定を行うことで、リクエストパスごとにマッピング先Javaパッケージを切り替えることができる。
optionalPackageMappingEntries プロパティには、リクエストパスのパターンとJava パッケージの組み合わせを設定する。

optionalPackageMappingEntries プロパティに設定した順番にリクエストパスのパターンとリクエストパスとのマッチングが行われ、
最初にマッチしたJavaパッケージが使用される。マッチするものが存在しない場合、本ハンドラのbasePackage プロパティに設定したJavaパッケージが使用される。

リクエストパスのパターンは、Glob式に似た書式で指定することができる。
詳細は、 [リクエストハンドラエントリ](../../component/handlers/handlers-RequestHandlerEntry.md#リクエストハンドラエントリ) を参照すること（リクエストハンドラエントリと同一の記法でパターンを指定できる）。

例えば、以下の設定では、リクエストパスのパターン **/sample/admin//** をJavaパッケージ **nablarch.sample.app1** 、
リクエストパスのパターン **/sample/user//** をJavaパッケージ **nablarch.sample.apps2** に対応させている。
いずれのリクエストパターンにもマッチしない場合は、本ハンドラのbasePackage プロパティに設定した **nablarch.sample.base** が使用される。

```xml
<!-- ディスパッチ -->
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

| リクエストパス | ディスパッチ対象クラス |
|---|---|
| /admin/AdminApp | nablarch.sample.apps1.admin.AdminApp |
| /user/UserApp | nablarch.sample.apps2.user.UserApp |
| /BaseApp | nablarch.sample.base.BaseApp |

> **Note:**
> リクエストパスのパターンのマッチは、リクエストパス中のすべての **”.”** をスラッシュ **”/”** に置換してから行われる。
> この仕様は、Nablarchのバッチ処理で過去に使用していたドット区切りのリクエストパス（例： ss01A001.B01AA001Action/B01AA0010）との互換性を保つために存在している。
