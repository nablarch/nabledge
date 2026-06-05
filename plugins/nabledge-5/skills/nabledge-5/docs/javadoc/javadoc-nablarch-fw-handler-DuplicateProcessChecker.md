# interface DuplicateProcessChecker

**パッケージ:** nablarch.fw.handler

---

```java
public interface DuplicateProcessChecker
```

プロセスの多重起動を防止するためのチェック処理を行うインタフェース。

**作成者:** Hisaaki Shioiri  

---

## メソッドの詳細

### checkAndActive

```java
void checkAndActive(String processIdentifier)
                    throws AlreadyProcessRunningException
```

プロセスの2重起動チェックとアクティブ化を行う。

プロセスが既に実行中の場合には、{@link AlreadyProcessRunningException}を送出する。

**パラメータ:**
- `processIdentifier` - プロセスを識別する値

**例外:**
- `AlreadyProcessRunningException` - プロセスの多重起動の場合

---

### inactive

```java
void inactive(String processIdentifier)
```

プロセスの非アクティブ化を行う。

**パラメータ:**
- `processIdentifier` - プロセスを識別する値

---
