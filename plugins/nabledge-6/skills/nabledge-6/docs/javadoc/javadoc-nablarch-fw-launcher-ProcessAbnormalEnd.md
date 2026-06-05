# class ProcessAbnormalEnd

**パッケージ:** nablarch.fw.launcher

**継承階層:**
```
java.lang.Object
  └─ TransactionAbnormalEnd
      └─ nablarch.fw.launcher.ProcessAbnormalEnd
```

---

```java
public class ProcessAbnormalEnd
extends TransactionAbnormalEnd
```

アプリケーションを異常終了させる際に送出する例外クラス。
<p/>
この例外が送出された場合、フレームワークは以下の処理を行う。
<pre>
1. 運用ログへの出力
  Fatalレベルで運用ログを出力する。

2. 業務処理の中断
  後続の業務処理の受付を停止し、現在処理中の業務処理についても割り込み要求を行って
  処理終了まで待機する。

3. プロセスの停止
  業務処理停止後、指定された終了コードでプロセスを終了させる。
</pre>

**作成者:** hisaaki sioiri  

---

## コンストラクタの詳細

### ProcessAbnormalEnd

```java
public ProcessAbnormalEnd(int exitCode, String failureCode, Object messageOptions)
```

終了コードとメッセージ（障害コードとオプション）を元に例外を構築する。

**パラメータ:**
- `exitCode` - 終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---

### ProcessAbnormalEnd

```java
public ProcessAbnormalEnd(int exitCode, Throwable error, String failureCode, Object messageOptions)
```

終了コードとメッセージ（障害コードとオプション）、元例外{@link Throwable}を元に例外を構築する。
<p/>
元例外が存在しない場合は、{@link #ProcessAbnormalEnd(int, String, Object...)} を使用する。

**パラメータ:**
- `exitCode` - 終了コード(プロセスを終了({@link System#exit(int)})する際に設定する値)
- `error` - 元例外
- `failureCode` - 障害コード
- `messageOptions` - 障害コードからメッセージを取得する際に使用するオプション情報

---
