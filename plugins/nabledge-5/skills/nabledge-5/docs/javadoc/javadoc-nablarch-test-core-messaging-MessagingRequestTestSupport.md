# class MessagingRequestTestSupport

**パッケージ:** nablarch.test.core.messaging

**継承階層:**
```
java.lang.Object
  └─ StandaloneTestSupportTemplate
      └─ nablarch.test.core.messaging.MessagingRequestTestSupport
```

---

```java
public class MessagingRequestTestSupport
extends StandaloneTestSupportTemplate
```

メッセージ同期応答用のテストサポートクラス。<br/>
<h3>本クラスを使用する際の注意事項</h3>
<p>
本クラスは、入力データをキューにPUTする用途で、main側のコンポーネント定義ファイルを読み込む。
その際、nablarch.fw.messaging.FwHeaderDefinition実装クラスは、
{@code "fwHeaderDefinition"}という名前で登録されていなければならない。
これ以外の名称を使用する場合は、{@link #getFwHeaderDefinitionName()}をオーバライドすることにより
本クラスが使用するnablarch.fw.messaging.FwHeaderDefinitionコンポーネント名を
変更することができる。

</p>

**作成者:** T.Kawasaki  

---

## フィールドの詳細

### setUpMessages

```java
protected Putter setUpMessages
```

---

### expectedMessages

```java
protected Comparator expectedMessages
```

---

## コンストラクタの詳細

### MessagingRequestTestSupport

```java
protected MessagingRequestTestSupport()
```

コンストラクタ。<br/>
サブクラスから使用されることを想定している。

---

### MessagingRequestTestSupport

```java
public MessagingRequestTestSupport(Class<?> testClass)
```

コンストラクタ。

**パラメータ:**
- `testClass` - テストクラス。

---

## メソッドの詳細

### createTestShotAround

```java
protected TestShotAround createTestShotAround(Class<?> testClass)
```

{@inheritDoc}

---

### beforeExecute

```java
protected void beforeExecute(String sheetName)
```

{@inheritDoc}

---

### beforeExecuteTestShot

```java
protected void beforeExecuteTestShot(TestShot shot)
```

{@inheritDoc}

---

### afterExecuteTestShot

```java
protected void afterExecuteTestShot(TestShot shot)
```

{@inheritDoc}

---

### getMessagingContextFrom

```java
private MessagingContext getMessagingContextFrom(TestShot testShot)
```

{@link nablarch.fw.messaging.MessagingContext}を取得する。

**パラメータ:**
- `testShot` - テストショット

**戻り値:**
生成したインスタンス

---

### getHeaderFormatter

```java
private DataRecordFormatter getHeaderFormatter(TestShot testShot)
```

FW制御ヘッダのフォーマッタを取得する。<br/>
デフォルトの{@link StandardFwHeaderDefinition}の動作では、
{@link FilePathSetting}、{@link FormatterFactory}が{@link nablarch.core.repository.SystemRepository}から
ルックアップされるが、この時点での{@link nablarch.core.repository.SystemRepository}は
テスト側の設定ファイルで初期化された状態であり、これらのインスタンスは正しく取得できない。
ターゲット側の状態を作り出すために、事前にターゲット側の設定から取得済したインスタンスを明示的に指定して、
フォーマット定義を取得する。

**パラメータ:**
- `testShot` - テストショット

**戻り値:**
フォーマッタ

---

### getFwHeaderDefinitionName

```java
protected String getFwHeaderDefinitionName()
```

nablarch.fw.messaging.FwHeaderDefinition実装クラスを
システムリポジトリから取得するための名前を取得する。
本メソッドは、{@code "fwHeaderDefinition"}を返却する。

**戻り値:**
{@code "fwHeaderDefinition"}

---
