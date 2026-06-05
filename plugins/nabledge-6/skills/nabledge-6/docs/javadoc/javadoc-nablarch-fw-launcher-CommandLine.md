# class CommandLine

**パッケージ:** nablarch.fw.launcher

**実装されたインタフェース:**
- Request<String>

---

```java
public class CommandLine
implements Request<String>
```

コマンドラインオプション、コマンドライン引数をパースして格納するクラス。
<p/>

**作成者:** Iwauo Tajima  
**関連項目:** Main  
**関連項目:** CommandLineParser  

---

## フィールドの詳細

### opts

```java
private Map<String,String> opts
```

コマンドラインオプションのMap

---

### args

```java
private List<String> args
```

コマンドライン引数のList

---

## コンストラクタの詳細

### CommandLine

```java
public CommandLine(String commandline)
```

デフォルトコンストラクタ

与えられたコマンドライン文字列を{@link CommandLineParser}で解析し保持する。

**パラメータ:**
- `commandline` - コマンドライン文字列

---

### CommandLine

```java
public CommandLine(Map<String,String> opts, List<String> args)
```

テスト用に使用するコンストラクタ。

**パラメータ:**
- `opts` - コマンドラインオプションのMap
- `args` - コマンドラインオプションのList

---

## メソッドの詳細

### validateOptions

```java
private void validateOptions(Map<String,String> options)
                     throws IllegalArgumentException
```

コマンドラインパラメータの内容をバリデーションする。

**パラメータ:**
- `options` - コマンドラインパラメータ

**例外:**
- `IllegalArgumentException` - コマンドラインパラメータの内容が不正だった場合。

---

### getRequestPath

```java
public String getRequestPath()
```

{@inheritDoc}
<p/>
リクエストパスを返す。
デフォルトでは実行されたコマンドのフルパス文字列を返す。

---

### setRequestPath

```java
public CommandLine setRequestPath(String requestPath)
```

---

### getParam

```java
public String getParam(String name)
```

{@inheritDoc}
<p/>
コマンドラインオプションの値を返す。
値が指定されていない場合は空文字を返す。
<pre>
例
-requestPath test.SampleAction/BC001 --> "test.SampleAction/BC001"を返す。
-server --> ""を返す。
</pre>

---

### getParamMap

```java
public Map<String,String> getParamMap()
```

{@inheritDoc}
<p/>
コマンドラインオプションのMapを取得する。

---

### setParamMap

```java
public CommandLine setParamMap(Map<String,String> opts)
```

コマンドラインオプションのMapを設定する。

**パラメータ:**
- `opts` - 名前付きコマンドライン引数のMap

**戻り値:**
このオブジェクト自体

---

### getArgs

```java
public List<String> getArgs()
```

コマンドライン引数のリストを返す。

**戻り値:**
引数リスト

---
