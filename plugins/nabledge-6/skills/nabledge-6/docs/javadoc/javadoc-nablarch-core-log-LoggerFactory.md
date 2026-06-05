# interface LoggerFactory

**パッケージ:** nablarch.core.log

---

```java
public interface LoggerFactory
```

{@link Logger}を生成するインタフェース。<br>
<br>
ログ出力機能の実装毎に本インタフェースの実装クラスを作成する。<br>
<br>
LoggerFactoryは、{@link LoggerManager}により生成、管理される。<br>
{@link LoggerManager}は、初期処理においてLoggerFactoryの生成後に{@link #initialize(LogSettings)}メソッド、
終了処理においてLoggerFactoryを破棄する際に{@link #terminate()}メソッドをそれぞれ1度だけ呼び出すので、
LoggerFactoryの初期処理と終了処理は複数スレッドから呼ばれることはない。

**作成者:** Kiyohito Itoh  
**関連項目:** LoggerManager  

---

## メソッドの詳細

### initialize

```java
void initialize(LogSettings settings)
```

初期処理を行う。<br>
<br>
ログの出力先に応じたリソースの確保などを行う。

**パラメータ:**
- `settings` - ログ出力の設定

---

### terminate

```java
void terminate()
```

終了処理を行う。<br>
<br>
ログの出力先に応じて確保しているリソースの解放などを行う。

---

### get

```java
Logger get(String name)
```

{@link Logger}を取得する。<br>
<br>
{@link Logger}名に対応する{@link Logger}が見つからない場合は、何も処理しない{@link Logger}を返し、
nullを返したり、例外を送出しないこと。

**パラメータ:**
- `name` - {@link Logger}名

**戻り値:**
{@link Logger}名に対応する{@link Logger}

---
