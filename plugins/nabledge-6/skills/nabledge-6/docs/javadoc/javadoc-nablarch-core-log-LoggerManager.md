# class LoggerManager

**パッケージ:** nablarch.core.log

---

```java
public final class LoggerManager
```

ログ出力機能の全体を取りまとめるクラス。<br>
<br>
クラスローダ毎に設定で指定された{@link LoggerFactory}の生成、保持を行う。<br>
ログ出力機能の実装に依存する初期処理、終了処理、{@link Logger}の生成は{@link LoggerFactory}に委譲する。<br>
クラスローダ毎に{@link LoggerFactory}を保持するのは、クラスローダ階層により生じる問題に対応するためである。
<p/>
使用する{@link LoggerFactory}は、プロパティファイルに設定する。<br>
プロパティファイルのパスは、システムプロパティを使用して、”nablarch.log.filePath”をキーにファイルパスを指定する。<br>
このファイルパスは、クラスパスとファイルシステム上のパスのどちらを指定しても良い。<br>
ファイルパスの指定方法は、{@link nablarch.core.util.FileUtil#getResource(String)}を参照すること。<br>
システムプロパティを指定しなかった場合は、クラスパス直下のlog.propertiesを使用する。<br>
プロパティファイルが存在しない場合は、例外を送出する。<br>
<p/>
ログの出力先によってはリソースの確保と解放が必要となるため、本クラスは初期処理と終了処理を行う。<br>
初期処理は、初回の{@link Logger}の取得が行われるタイミングで本クラスが内部的に実行する。<br>
終了処理は、フレームワーク側で実行するタイミングを判断できないので、
ログの出力要求を行うアプリケーション毎にアプリケーションの終了時に{@link #terminate()}メソッドを呼び出すこと。<br>
アプリケーションの終了時とは、例えばWebアプリケーションの場合であれば、
ServletContextListener#contextDestroyedメソッドが呼ばれるタイミングを想定している。

**作成者:** Kiyohito Itoh  
**関連項目:** nablarch.core.log.LoggerFactory  
**関連項目:** Logger  

---

## フィールドの詳細

### LOGGER_FACTORY_CREATOR

```java
private static final ObjectCreator<LoggerFactory> LOGGER_FACTORY_CREATOR
```

LoggerFactoryを生成する{@link ObjectCreator}

---

## コンストラクタの詳細

### LoggerManager

```java
private LoggerManager()
```

隠蔽コンストラクタ。

---

## メソッドの詳細

### terminate

```java
public static void terminate()
```

ログ出力の終了処理を行う。<br>
<br>
クラスローダに紐付く全てのオブジェクトを解放する。

---

### get

```java
public static Logger get(Class<?> clazz)
```

ロガーを取得する。<br>
<br>
指定されたクラスのFQCNを指定して{@link #get(String)}メソッドを呼び出す。

**パラメータ:**
- `clazz` - ロガー名に使用するクラス。クラスのFQCNをロガー名に使用する。

**戻り値:**
ロガー

---

### get

```java
public static Logger get(String name)
```

ロガーを取得する。<br>
<br>
クラスローダに紐付く{@link LoggerFactory}から取得したロガーを返す。<br>
<br>
ロガー名に対応するロガーが見つからない場合は、何も処理しないロガーを返す。

**パラメータ:**
- `name` - ロガー名

**戻り値:**
ロガー

---
