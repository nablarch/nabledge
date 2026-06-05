# interface FlowProceedCondition

**パッケージ:** nablarch.integration.workflow.condition

---

```java
public interface FlowProceedCondition
```

シーケンスフローの遷移判定を行うインタフェース。

**作成者:** hisaaki sioiri  
**導入バージョン:** 1.4.2  

---

## メソッドの詳細

### isMatch

```java
boolean isMatch(String instanceId, Map<String,?> param, SequenceFlow sequenceFlow)
```

シーケンスフローに従ってワークフローが進行可能か判定する。

**パラメータ:**
- `instanceId` - インスタンスID
- `param` - パラメータ
- `sequenceFlow` - 評価対象のシーケンスフロー

**戻り値:**
遷移可能な場合はtrue

---
