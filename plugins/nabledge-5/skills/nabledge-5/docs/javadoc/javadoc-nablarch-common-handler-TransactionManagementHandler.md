# class TransactionManagementHandler

**パッケージ:** nablarch.common.handler

**継承階層:**
```
java.lang.Object
  └─ TransactionEventCallback.Provider<Object>
      └─ nablarch.common.handler.TransactionManagementHandler
```

**実装されたインタフェース:**
- Handler<Object,Object>
- InboundHandleable
- OutboundHandleable

---

```java
public class TransactionManagementHandler
extends TransactionEventCallback.Provider<Object>
implements Handler<Object,Object>, InboundHandleable, OutboundHandleable
```

後続処理における透過的トランザクションを実現するハンドラ。<br/>
通常の {@ref Handler} として使用する場合と、{@ref InboundHandleable} {@ref OutboundHandleable} として使用する場合で動作が異なる。

<pre>
{@ref Handler} として使用する場合、本ハンドラの詳細な処理内容は以下の通り。

1.  トランザクションファクトリから使用するトランザクションオブジェクトを取得し、
    {@link nablarch.core.transaction.TransactionContext}上に設定する。
2.  トランザクションを開始する。
3.  ハンドラスタックから次のリクエストハンドラを取得し、処理を委譲する。
4a. 委譲先の処理において例外が発生しなければトランザクションをコミットする。
4b. 例外が発生した場合はトランザクションをロールバックする。
    ただし、このとき送出された例外が、{@link #setTransactionCommitExceptions(java.util.List)}で設定された例外の
    いずれかのサブクラスである場合はトランザクションをコミットする。
5.  トランザクションオブジェクトを{@link TransactionContext}から除去する。

設定例:<br/>
{@code
<component class="nablarch.common.handler.TransactionManagementHandler">
     <!-- トランザクションファクトリ -->
     <property name="transactionFactory"
               value="transactionFactory"/>
     <!-- トランザクションをコミットする例外 -->
     <property name="transactionCommitExceptions">
         <list>
             <value>example.TransactionCommitException</value>
             <value>example.TransactionCommitException2</value>
         </list>
     </property>
</component>
}
</pre>

{@ref InboundHandleable} {@ref OutboundHandleable} として使用する場合、Inbound処理の際にトランザクションを開始し、
Outbound処理の際にトランザクションをコミットまたはロールバックする。<br/>
コミットとロールバックの判定は、 isProcessSucceded が true を返すか false を返すかで判定する。

**作成者:** Iwauo Tajima <iwauo@tis.co.jp>  
**作成者:** Koichi Asano <asano.koichi@tis.co.jp>  

---

## フィールドの詳細

### transactionFactory

```java
private TransactionFactory transactionFactory
```

トランザクションオブジェクトを取得するためのファクトリ

---

### transactionName

```java
private String transactionName
```

トランザクションが使用するコネクションの登録名

---

### transactionCommitExceptions

```java
private List<Class<? extends RuntimeException>> transactionCommitExceptions
```

送出されてもトランザクションをコミットしなければならない例外クラスの一覧

---

## メソッドの詳細

### setTransactionFactory

```java
public void setTransactionFactory(TransactionFactory transactionFactory)
```

トランザクションオブジェクトを取得するためのファクトリを設定する。

**パラメータ:**
- `transactionFactory` - トランザクションオブジェクトを取得するためのファクトリ

---

### setTransactionName

```java
public void setTransactionName(String transactionName)
```

このハンドラが管理するトランザクションの、スレッドコンテキスト上での登録名を設定する。
<pre>
デフォルトでは既定のトランザクション名
({@link TransactionContext#DEFAULT_TRANSACTION_CONTEXT_KEY})を使用する。

</pre>

**パラメータ:**
- `transactionName` - データベース接続のスレッドコンテキスト上の登録名

---

### setTransactionCommitExceptions

```java
public void setTransactionCommitExceptions(List<String> exceptionClassNames)
```

送出されてもトランザクションをコミットしなければならない例外クラスの一覧を設定する。
<pre>
指定可能な例外は実行時例外（RuntimeExceptionのサブクラス）のみである。
なにも指定しなかった場合はいかなる例外についてもロールバックする。
</pre>

**パラメータ:**
- `exceptionClassNames` - 送出されてもトランザクションをコミットしなければならない例外クラスの一覧

---

### mustBeCommittedWhenThrown

```java
boolean mustBeCommittedWhenThrown(RuntimeException e)
```

トランザクションの期間中に指定された例外が送出された場合、
当該のトランザクションをコミットする必要があるか否かを返す。

**パラメータ:**
- `e` - トランザクション期間中に送出された例外オブジェクト

**戻り値:**
コミットする必要があればtrueを返す。

---

### handle

```java
public Object handle(Object inputData, ExecutionContext ctx)
```

{@inheritDoc}
<pre>
このクラスの実装では後続ハンドラに対する処理委譲の前後に、
データベース接続オブジェクトの初期化と終了の処理をそれぞれ行う。
</pre>

---

### handleInbound

```java
public Result handleInbound(ExecutionContext context)
```

---

### handleOutbound

```java
public Result handleOutbound(ExecutionContext context)
```

---

### isCompleteTransaction

```java
protected boolean isCompleteTransaction(ExecutionContext context)
```

トランザクションが正常終了したかどうかを判定する。<br/>
この実装では、ExecutionContext#isProcessSucceded() がtrueを返すかどうかで、判定を行う。

**パラメータ:**
- `context` - ExecutionContext

**戻り値:**
正常終了した場合 true

---
