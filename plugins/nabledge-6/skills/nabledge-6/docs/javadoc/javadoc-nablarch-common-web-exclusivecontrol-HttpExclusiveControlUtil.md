# class HttpExclusiveControlUtil

**パッケージ:** nablarch.common.web.exclusivecontrol

---

```java
public final class HttpExclusiveControlUtil
```

画面処理における排他制御機能(楽観的ロック)のユーティリティクラス。
<p/>
楽観的ロックは、下記の機能により実現する。
<ul>
<li>処理対象データに対するバージョン番号を取得する。</li>
<li>取得済みのバージョン番号が更新されていないかチェックする。</li>
<li>取得済みのバージョン番号が更新されていないかチェックし、バージョン番号を更新する。</li>
</ul>
取得したバージョン番号は、フレームワークにより、ウィンドウスコープを使用して画面間を持回る。
このため、本クラスは、n:formタグとhiddenタグの暗号化機能の使用を前提とする。

本クラスは、画面処理に依存しない楽観的ロック機能の処理を{@link ExclusiveControlUtil}に委譲する。

{@link nablarch.common.dao.UniversalDao UniversalDao}を使用する場合には、
このクラスではなく{@link nablarch.common.dao.UniversalDao UniversalDao}を使用して排他制御を行うこと。

**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### VERSION_PARAM_NAME

```java
public static final String VERSION_PARAM_NAME
```

バージョン番号をhiddenタグに出力する際に使用するパラメータ名

---

### VERSIONS_VARIABLE_NAME

```java
public static final String VERSIONS_VARIABLE_NAME
```

バージョン番号をリクエストスコープに設定する際に使用する変数名

---

## コンストラクタの詳細

### HttpExclusiveControlUtil

```java
private HttpExclusiveControlUtil()
```

隠蔽コンストラクタ

---

## メソッドの詳細

### prepareVersions

```java
public static boolean prepareVersions(ExecutionContext context, List<? extends ExclusiveControlContext> exclusiveControlContexts)
```

バージョン番号を準備する。
<p/>
指定された{@link ExclusiveControlContext}リストを使用してバージョン番号を取得し、
次回リクエスト時にバージョン番号を送信するために、バージョン番号をリクエストスコープに設定する。
リクエストスコープに設定したバージョン番号は、n:formタグによりウィンドウスコープに設定される。
<p/>
1つでもバージョン番号を準備できなかった場合は処理を中断しfalseを返す。

**パラメータ:**
- `context` - 実行コンテキスト
- `exclusiveControlContexts` - 排他制御コンテキストリスト

**戻り値:**
すべてのバージョン番号を準備できた場合はtrue

---

### prepareVersion

```java
public static boolean prepareVersion(ExecutionContext context, ExclusiveControlContext exclusiveControlContext)
```

バージョン番号を準備する。
<p/>
指定された{@link ExclusiveControlContext}を使用してバージョン番号を取得し、
次回リクエスト時にバージョン番号を送信するために、バージョン番号をリクエストスコープに設定する。
リクエストスコープに設定したバージョン番号は、n:formタグによりウィンドウスコープに設定される。

**パラメータ:**
- `context` - 実行コンテキスト
- `exclusiveControlContext` - 排他制御コンテキスト

**戻り値:**
バージョン番号を準備できた場合はtrue

---

### getVersions

```java
private static List<String> getVersions(ExecutionContext context)
```

リクエストスコープからバージョン番号リストを取得する。

**パラメータ:**
- `context` - 実行コンテキスト

**戻り値:**
バージョン番号リスト

---

### convertToVersionString

```java
private static String convertToVersionString(Version version)
```

バージョン番号オブジェクトを復元可能な文字列に変換する。

**パラメータ:**
- `version` - バージョン番号オブジェクト

**戻り値:**
復元可能な文字列

---

### convertToConditionString

```java
private static String convertToConditionString(Map<String,Object> condition)
```

バージョン番号の主キー条件を復元可能な文字列に変換する。

**パラメータ:**
- `condition` - バージョン番号の主キー条件

**戻り値:**
復元可能な文字列

---

### checkVersions

```java
public static void checkVersions(HttpRequest request, ExecutionContext context)
                   throws OptimisticLockException
```

バージョン番号をチェックする。
<p/>
リクエストパラメータに含まれるバージョン番号を使用して、
バージョン番号が更新されていないかをチェックする。
どれか一つでもバージョン番号が更新されていた場合は、
更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。
<p/>
全てのバージョン番号が更新されていない場合は、
次回リクエスト時にバージョン番号を送信するために、バージョン番号をリクエストスコープに設定する。
リクエストスコープに設定したバージョン番号は、n:formタグによりウィンドウスコープに設定される。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### checkVersions

```java
public static void checkVersions(HttpRequest request, ExecutionContext context, String targetPkListParamName)
                   throws OptimisticLockException
```

指定されたウィンドウスコープ変数上の配列に格納された各PK値に対して
バージョン番号をチェックする。
<p/>
リクエストパラメータに含まれるバージョン番号を使用して、
バージョン番号が更新されていないかをチェックする。
どれか一つでもバージョン番号が更新されていた場合は、
更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。
<p/>
全てのバージョン番号が更新されていない場合は、
次回リクエスト時にバージョン番号を送信するために、バージョン番号をリクエストスコープに設定する。
リクエストスコープに設定したバージョン番号は、n:formタグによりウィンドウスコープに設定される。
<p/>
なお、PKが組み合わせキーとなる場合は{@link HttpExclusiveControlUtil#checkVersion(HttpRequest, ExecutionContext, ExclusiveControlContext)}
を使用すること。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト
- `targetPkListParamName` - 更新対象のPK値の配列を格納したウィンドウスコープ変数名

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### checkVersion

```java
public static void checkVersion(HttpRequest request, ExecutionContext context, ExclusiveControlContext exclusiveControlContext)
                  throws OptimisticLockException
```

引数で渡された排他制御コンテキストに格納されたPK値に対してバージョン番号をチェックする。
<p/>
排他制御コンテキストに格納されたバージョン番号を使用して、バージョン番号が更新されていないかをチェックする。
どれか一つでもバージョン番号が更新されていた場合は、更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。
<p/>
全てのバージョン番号が更新されていない場合は、
次回リクエスト時にバージョン番号を送信するために、バージョン番号をリクエストスコープに設定する。
リクエストスコープに設定したバージョン番号は、n:formタグによりウィンドウスコープに設定される。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト
- `exclusiveControlContext` - 排他制御コンテキスト

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### executeCheckVersions

```java
private static void executeCheckVersions(HttpRequest request, ExecutionContext context, String targetPkListParamName)
                          throws OptimisticLockException
```

論理排他チェックを行う。

**パラメータ:**
- `request` - リクエスト
- `context` - 実行コンテキスト
- `targetPkListParamName` - 更新対象のPK値の配列を格納したウィンドウスコープ変数名

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### getVersions

```java
private static List<Version> getVersions(HttpRequest request)
```

リクエストパラメータに含まれるバージョン番号を取得する。

**パラメータ:**
- `request` - リクエスト

**戻り値:**
バージョン番号

---

### getVersions

```java
private static List<Version> getVersions(HttpRequest request, String targetPkListParamName)
```

バージョン番号を取得する。

**パラメータ:**
- `request` - HTTPリクエストオブジェクト
- `targetPkListParamName` - 更新対象PK値のリストを格納したウィンドウスコープ上の変数名

**戻り値:**
バージョン番号

---

### getVersion

```java
private static List<Version> getVersion(HttpRequest request, ExclusiveControlContext context)
```

指定された排他制御コンテキストに対応するバージョン番号をリクエストパラメータから取得する。

**パラメータ:**
- `request` - HTTPリクエストオブジェクト
- `context` - 排他制御コンテキスト

**戻り値:**
バージョン番号

---

### isSameTable

```java
private static boolean isSameTable(ExclusiveControlContext context, Version version)
```

排他制御コンテキストのテーブルとリクエストパラメータから取得したテーブルが一致するか否かを判定する。

**パラメータ:**
- `context` - 排他制御コンテキスト
- `version` - リクエストパラメータから取得したバージョン情報

**戻り値:**
排他制御コンテキストとリクエストパラメータのテーブルが一致する場合は {@code true}

---

### isSameCondition

```java
private static boolean isSameCondition(Map<String,Object> contextCondition, Map<String,Object> paramCondition, Enum<?>[] primaryKeyColumnNames)
```

排他制御コンテキストの主キー条件とリクエストパラメータから取得した主キー条件が一致するか否かを判定する。
<p/>
どちらか一方の主キー値が取得できない場合は、falseを返す。

**パラメータ:**
- `contextCondition` - 排他制御コンテキストの主キー条件
- `paramCondition` - リクエストパラメータから取得した主キー条件
- `primaryKeyColumnNames` - 主キーのカラム名の配列

**戻り値:**
主キー条件が全てマッチすればtrue、一つでも異なればfalse

---

### getPrimaryKeyValue

```java
private static Object getPrimaryKeyValue(Map<String,Object> condition, String primaryKeyColumnName)
```

主キー値を取得する。

**パラメータ:**
- `condition` - 主キー条件
- `primaryKeyColumnName` - 取得したい主キーのカラム名

**戻り値:**
主キー値

---

### convertToVersion

```java
private static Version convertToVersion(String versionString)
```

バージョン番号文字列からバージョン番号オブジェクトに変換する。

**パラメータ:**
- `versionString` - バージョン番号文字列

**戻り値:**
バージョン番号オブジェクト

---

### convertToCondition

```java
private static Map<String,Object> convertToCondition(String conditionString)
```

主キー条件文字列からマップオブジェクトに変換する。

**パラメータ:**
- `conditionString` - 主キー条件文字列

**戻り値:**
マップオブジェクト

---

### updateVersionsWithCheck

```java
public static void updateVersionsWithCheck(HttpRequest request)
                             throws OptimisticLockException
```

バージョン番号の更新チェックとバージョン番号の更新を行う。
<p/>
リクエストパラメータに含まれるバージョン番号を使用して、
バージョン番号が更新されていないかのチェックと更新を行う。
どれか一つでもバージョン番号が更新されていた場合は、
更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。

**パラメータ:**
- `request` - リクエスト

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### updateVersionsWithCheck

```java
public static void updateVersionsWithCheck(HttpRequest request, String targetPkListParamName)
                             throws OptimisticLockException
```

指定されたウィンドウスコープ変数上の配列に格納された各PK値に対して
バージョン番号の更新チェックとバージョン番号の更新を行う。
<p/>
リクエストパラメータに含まれるバージョン番号を使用して、
バージョン番号が更新されていないかのチェックと更新を行う。
どれか一つでもバージョン番号が更新されていた場合は、
更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。
<p/>
なお、PKが組み合わせキーとなる場合は、{@link HttpExclusiveControlUtil#updateVersionWithCheck(HttpRequest, ExclusiveControlContext)}
を使用すること。

**パラメータ:**
- `request` - リクエスト
- `targetPkListParamName` - 更新対象のPK値の配列を格納したウィンドウスコープ変数名

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### updateVersionWithCheck

```java
public static void updateVersionWithCheck(HttpRequest request, ExclusiveControlContext exclusiveControlContext)
                            throws OptimisticLockException
```

引数で渡された排他制御コンテキストに格納されたPK値に対してバージョン番号のチェックとバージョン情報の更新を行う。
<p/>
排他制御コンテキストに格納されたバージョン番号を使用して、バージョン番号が更新されていないかのチェックと更新を行う。
どれか一つでもバージョン番号が更新されていた場合は、更新されているバージョン番号を設定した{@link OptimisticLockException}を送出する。
<p/>

**パラメータ:**
- `request` - リクエスト
- `exclusiveControlContext` - 排他制御コンテキスト

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### executeUpdateVersionsWithCheck

```java
private static void executeUpdateVersionsWithCheck(HttpRequest request, String targetPkListParamName)
                                    throws OptimisticLockException
```

論理排他チェック後、バージョン番号を更新する。

**パラメータ:**
- `request` - リクエスト
- `targetPkListParamName` - 更新対象のPK値の配列を格納したウィンドウスコープ変数名

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---
