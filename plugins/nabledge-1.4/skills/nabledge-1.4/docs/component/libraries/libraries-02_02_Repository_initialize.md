# 初期化処理の使用手順

## 初期化処理の使用手順

初期化処理を行うための条件:
1. `Initializable` インタフェースの `initialize` メソッドに初期化処理を実装する
2. 作成したクラスをDIコンテナにコンポーネントとして設定する
3. `BasicApplicationInitializer` の `initializeList` プロパティに追加する

**初期化対象クラスの定義**

`Initializable` インタフェースの `initialize` メソッドを実装する。このコードはプロジェクトのアーキテクトが作成するものであり、通常、各アプリケーション・プログラマはこのような実装を行わない。

```java
public class Message implements Initializable {

    // Initializableで定義されているinitializeメソッドを実装する。
    // 必要な初期化処理を本メソッド内ですべて実装する。
    public void initialize() {

        // 初期化処理を実行する。

    }
}
```

**コンポーネント設定ファイルの定義**

コンポーネント名は必ず `initializer` とする。

```xml
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <component-ref name="message"/>
            <component-ref name="code"/>
        </list>
    </property>
</component>
```

| プロパティ名 | 説明 |
|---|---|
| initializeList | 初期化が必要なコンポーネントのリスト。リストの順序で初期化が実行される。 |

> **注意**: コンポーネント名 `initializer` で登録するクラスは `ApplicationInitializer` インタフェースを実装していれば `BasicApplicationInitializer` 以外のクラスでも使用可能。`BasicApplicationInitializer` で対処できない場合は `ApplicationInitializer` を実装したカスタムクラスを作成すること。

<details>
<summary>keywords</summary>

Initializable, BasicApplicationInitializer, ApplicationInitializer, initializeList, 初期化処理, DIコンテナ初期化, コンポーネント初期化

</details>
