# class ExclusiveControlUtil

**パッケージ:** nablarch.common.exclusivecontrol

---

```java
public final class ExclusiveControlUtil
```

排他制御機能のユーティリティクラス。
<p/>
排他制御用テーブルの操作は、{@link ExclusiveControlManager}に委譲する。
本クラスで使用する{@link ExclusiveControlManager}のオブジェクトは
{@link SystemRepository}から"exclusiveControlManager"という名前で取得する。

{@link nablarch.common.dao.UniversalDao UniversalDao}を使用する場合には、
このクラスではなく{@link nablarch.common.dao.UniversalDao UniversalDao}を使用して排他制御を行うこと。

**関連項目:** ExclusiveControlManager  
**作成者:** Kiyohito Itoh  

---

## フィールドの詳細

### EXCLUSIVE_CONTROL_MANAGER_NAME

```java
private static final String EXCLUSIVE_CONTROL_MANAGER_NAME
```

ExclusiveControlManagerのコンポーネント名

---

## コンストラクタの詳細

### ExclusiveControlUtil

```java
private ExclusiveControlUtil()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### getExclusiveControlManager

```java
private static ExclusiveControlManager getExclusiveControlManager()
```

ExclusiveControlManagerを取得する。

**戻り値:**
ExclusiveControlManager

---

### getVersion

```java
public static Version getVersion(ExclusiveControlContext context)
```

バージョン番号を取得する。(楽観的ロック)

**パラメータ:**
- `context` - {@link ExclusiveControlContext}

**戻り値:**
バージョン番号。バージョン番号が存在しない場合は{@code null}

---

### checkVersions

```java
public static void checkVersions(List<Version> versions)
                   throws OptimisticLockException
```

バージョン番号が更新されていないかチェックする。(楽観的ロック)

**パラメータ:**
- `versions` - バージョン番号

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### updateVersionsWithCheck

```java
public static void updateVersionsWithCheck(List<Version> versions)
                             throws OptimisticLockException
```

バージョン番号の更新チェックとバージョン番号の更新を行う。(楽観的ロック)

**パラメータ:**
- `versions` - バージョン番号

**例外:**
- `OptimisticLockException` - バージョン番号が更新されていた場合

---

### updateVersion

```java
public static void updateVersion(ExclusiveControlContext context)
```

バージョン番号を更新する。(悲観的ロック)

**パラメータ:**
- `context` - {@link ExclusiveControlContext}

---

### addVersion

```java
public static void addVersion(ExclusiveControlContext context)
```

バージョン番号を追加する。

**パラメータ:**
- `context` - {@link ExclusiveControlContext}

---

### removeVersion

```java
public static void removeVersion(ExclusiveControlContext context)
```

バージョン番号を削除する。

**パラメータ:**
- `context` - {@link ExclusiveControlContext}

---

### convertToVariableName

```java
public static String convertToVariableName(Enum<?> columnName)
```

カラム名を名前付き変数名(先頭コロンを除く)に変換する。

**パラメータ:**
- `columnName` - カラム名

**戻り値:**
名前付き変数名(先頭コロンを除く)

---

### convertToVariableName

```java
public static String convertToVariableName(String columnName)
```

カラム名を名前付き変数名(先頭コロンを除く)に変換する。

**パラメータ:**
- `columnName` - カラム名

**戻り値:**
名前付き変数名(先頭コロンを除く)

---
