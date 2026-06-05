# interface CsrfTokenGenerator

**パッケージ:** nablarch.fw.web.handler.csrf

---

```java
public interface CsrfTokenGenerator
```

CSRFトークンの生成を行うインターフェース。

<p>
このインターフェースの実装クラスが生成する値は暗号論的に安全なものでなければいけない。
例えば{@link java.security.SecureRandom}を使用して値を生成するなど。
</p>

**作成者:** Uragami Taichi  

---

## メソッドの詳細

### generateToken

```java
String generateToken()
```

CSRFトークンを生成して返す。

**戻り値:**
生成されたCSRFトークン

---
