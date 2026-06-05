# interface LogWriter

**パッケージ:** nablarch.core.log.basic

---

```java
public interface LogWriter
```

ログを出力先に書き込むインタフェース。<br>
<br>
出力先の媒体毎に本インタフェースの実装クラスを作成する。

**作成者:** Kiyohito Itoh  

---

## メソッドの詳細

### initialize

```java
void initialize(ObjectSettings settings)
```

初期処理を行う。<br>
<br>
ログの出力先に応じたリソースの確保などを行う。

**パラメータ:**
- `settings` - LogWriterの設定

---

### terminate

```java
void terminate()
```

終了処理を行う。<br>
<br>
ログの出力先に応じて確保しているリソースの解放などを行う。

---

### write

```java
void write(LogContext context)
```

ログを出力先に書き込む。

**パラメータ:**
- `context` - {@link LogContext}

---
