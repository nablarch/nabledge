# class MessageReplyHandler

**パッケージ:** nablarch.fw.messaging.handler

**実装されたインタフェース:**
- Handler<Object,Result>

---

```java
public class MessageReplyHandler
implements Handler<Object,Result>
```

受信電文に設定された宛先に対して応答電文を送信するハンドラ。 

本ハンドラは、後続ハンドラの処理結果であるResponseMessageオブジェクトの内容を
もとに応答電文を構築し送信する。
送信した応答電文オブジェクトをこのハンドラの戻り値として返す。

<div><b>他のハンドラとの前後関係</b></div>
<hr/>

<pre>
- トランザクション制御ハンドラ
   同ハンドラとの前後関係は、2相コミットを使用するか否かで変わる。

   a) 2相コミットを使用する場合。
      DBトランザクションとJMSトランザクションをトランザクションマネージャー側で
      まとめてコミットするので、トランザクション制御ハンドラは、このハンドラより
      先に実行されなければならない。

   b) 2相コミットを使用しない場合。
     このハンドラが応答を送信する前に、DBトランザクション終了させ、業務処理の結果を
     確定させる必要がある。
     このため、トランザクション制御ハンドラはこのハンドラの後に実行されなければ
     ならない。

- データリードハンドラ
   要求電文のフォーマット不正に起因する例外はデータリーダで発生する可能性があり、
   そのエラー応答電文をこのハンドラで送出する必要がある。
   このため、データリードハンドラはこのハンドラの後に実行されなければならない。
</pre>


<div><b>例外制御</b></div>
<hr/>
このハンドラでは、全てのエラー(java.lang.Error)及び実行時例外を補足しエラー応答を行う。
(従って、本ハンドラではいかなる場合においても応答電文の送信処理を実行することになる。)
エラー応答が正常に終了した場合は、捕捉した例外を再送出する。
Fatalログの出力およびサーバプロセス停止要否の判断はnablarch.fw.handler.RequestThreadLoopHandlerで行う。
</p>
応答電文の送信処理中にエラーが発生した場合は、以下の処理を行う。
いずれのケースにおいても、Fatalログの出力はnablarch.fw.handler.RequestThreadLoopHandlerで行われる。
<pre>
1. 後続ハンドラが正常終了していた(=応答電文オブジェクトがリターンされていた)場合。
     送信エラーを再送出する。

2. 後続ハンドラが異常終了していた(=実行時例外/エラーが送出されていた)場合。
     送信エラーの内容をWarningレベルのログに出力した上で、
     後続ハンドラが送出した例外を再送出する。　
</pre>

**作成者:** Iwauo Tajima  

---

## フィールドの詳細

### fwHeaderDefinition

```java
private FwHeaderDefinition fwHeaderDefinition
```

応答電文中のフレームワークヘッダ定義

---

### LOGGER

```java
private static final Logger LOGGER
```

ロガー

---

## コンストラクタの詳細

### MessageReplyHandler

```java
public MessageReplyHandler()
```

コンストラクタ。

---

## メソッドの詳細

### handle

```java
public Result handle(Object data, ExecutionContext ctx)
```

{@inheritDoc}
この実装では後続ハンドラの処理結果であるResponseMessageのオブジェクトの内容を
もとに応答電文を構築し送信する。
また、送信した応答電文オブジェクトをハンドラの戻り値として返す。

---

### errorResponseOf

```java
protected ResponseMessage errorResponseOf(Throwable e, ExecutionContext ctx)
```

後続ハンドラの処理中に未捕捉の例外が発生した場合に応答するエラー電文を作成する。

**パラメータ:**
- `ctx` - 実行コンテキスト
- `e` - 発生した例外

**戻り値:**
エラー応答電文

---

### getStatusCode

```java
protected String getStatusCode(ResponseMessage message)
```

応答電文のフレームワーク制御ヘッダに設定するステータスコードを取得する。
<p/>
デフォルトの設定では、Result.getStatusCode() の戻り値と同じ値を
フレームワーク制御ヘッダーに指定する。

プロジェクト固有のステータスコード体系を定義している場合は、本メソッドを
オーバーライドすること。

**パラメータ:**
- `message` - 応答電文オブジェクト

**戻り値:**
フレームワーク制御ヘッダに設定するステータスコード

---

### rethrow

```java
private void rethrow(Throwable e)
```

渡された例外を再送出する。

**パラメータ:**
- `e` - 例外

---

### setFwHeaderDefinition

```java
public MessageReplyHandler setFwHeaderDefinition(FwHeaderDefinition def)
```

応答電文中のフレームワーク制御ヘッダ定義を設定する。

**パラメータ:**
- `def` - フレームワーク制御ヘッダ定義

**戻り値:**
このオブジェクト自体

---
