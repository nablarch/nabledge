# class HotDeployHandler

**パッケージ:** nablarch.fw.hotdeploy

**実装されたインタフェース:**
- Handler<Object,Object>

---

```java
public class HotDeployHandler
implements Handler<Object,Object>
```

NablarchアプリケーションをHotDeployするためのハンドラ。

**作成者:** kawasima  

---

## フィールドの詳細

### targetPackages

```java
private List<String> targetPackages
```

HotDeploy対象のパッケージ *

---

## メソッドの詳細

### handle

```java
public Object handle(Object data, ExecutionContext context)
```

{@inheritDoc}<br/>

---

### getTargetPackages

```java
public List<String> getTargetPackages()
```

HotDeploy対象のパッケージを取得。

**戻り値:**
HotDeploy対象のパッケージ

---

### setTargetPackages

```java
public void setTargetPackages(List<String> targetPackages)
```

HotDeploy対象のパッケージを設定。

**パラメータ:**
- `targetPackages` - HotDeploy対象のパッケージ。

---
