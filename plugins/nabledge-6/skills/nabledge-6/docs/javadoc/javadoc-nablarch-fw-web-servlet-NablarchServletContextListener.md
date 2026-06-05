# class NablarchServletContextListener

**パッケージ:** nablarch.fw.web.servlet

**実装されたインタフェース:**
- ServletContextListener

---

```java
public class NablarchServletContextListener
implements ServletContextListener
```

コンテキストの初期化を行う。<br/>
<br/>
本クラスにおけるロガーの取得処理は、アプリケーションの起動時にログの初期処理を確実に行う意図があるため、削除しないこと。

**作成者:** Koichi Asano  

---

## フィールドの詳細

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

### DI_CONTAINER_CONFIG_FILE_KEY

```java
private static final String DI_CONTAINER_CONFIG_FILE_KEY
```

DIコンテナの設定ファイル名の設定キー。

---

### DI_CONTAINER_DUPLICATE_DEFINITION_CONFIG_KEY

```java
private static final String DI_CONTAINER_DUPLICATE_DEFINITION_CONFIG_KEY
```

設定値に重複する設定が存在した場合の動作ポリシーの設定キー。

---

### DI_CONTAINER_ALLOW_STATIC_PROPERTY_KEY

```java
private static final String DI_CONTAINER_ALLOW_STATIC_PROPERTY_KEY
```

staticプロパティインジェクションの許可設定キー。

---

### INITIALIZATION_COMPLETED_KEY

```java
private static final String INITIALIZATION_COMPLETED_KEY
```

初期化成否を格納するためのキー

---

## メソッドの詳細

### contextInitialized

```java
public void contextInitialized(ServletContextEvent event)
```

{@inheritDoc}<br/>
<br/>
リポジトリの初期化処理を行う。<br/>
初期化処理完了後にINFOレベルでログを出力する。
リクエスト単体テスト時にはリポジトリの初期化は行わない（自動テストフレームワークにて実施）。

---

### setInitializationCompleted

```java
private void setInitializationCompleted()
```

初期化に成功したことを後続処理で検知するために
リポジトリに{@link Object}を登録する。

---

### isInitializationCompleted

```java
public static boolean isInitializationCompleted()
```

初期化成否を返す。

**戻り値:**
初期化に成功した場合true

---

### initializeRepository

```java
private void initializeRepository(ServletContextEvent event)
```

リポジトリの初期化を行う。

**パラメータ:**
- `event` - ServletContextEvent

---

### evaluateDuplicateDefinitionPolicy

```java
private DuplicateDefinitionPolicy evaluateDuplicateDefinitionPolicy(String stringExpression)
```

文字列から、設定値重複時の動作ポリシーを評価する。

**パラメータ:**
- `stringExpression` - 文字列表現

**戻り値:**
設定値重複時の動作ポリシー

---

### isRequestTest

```java
private boolean isRequestTest()
```

リクエスト単体テストであるか判定する。

**戻り値:**
判定結果

---

### initializeLog

```java
private void initializeLog()
```

各種ログの初期化を行う。

---

### contextDestroyed

```java
public void contextDestroyed(ServletContextEvent event)
```

{@inheritDoc}<br/>
<br/>
コンポーネントの廃棄処理と、ログの終了処理を行う。<br/>
ログの終了処理の直前にINFOレベルでログを出力する。

---
