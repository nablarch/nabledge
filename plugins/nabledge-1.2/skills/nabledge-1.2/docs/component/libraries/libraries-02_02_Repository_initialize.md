# 初期化処理の使用手順

## 初期化処理の使用手順

初期化処理の手順:
1. `Initializable` インタフェースの `initialize` メソッドに初期化処理を実装する
2. 作成したクラスをコンポーネントとしてDIコンテナに設定する
3. `BasicApplicationInitializer` の `initializeList` プロパティに追加する

> **注意**: 初期化対象クラス (`Initializable` の実装) は**プロジェクトのアーキテクトが作成するもの**であり、通常の各アプリケーション・プログラマはこのような実装を行わない。

**クラス**: `nablarch.core.repository.initialization.BasicApplicationInitializer`

初期化対象クラスの実装例:
```java
public class Message implements Initializable {
    public void initialize() {
        // 初期化処理を実行する。
    }
}
```

コンポーネント設定例:
```xml
<!-- コンポーネント名は必ず "initializer" とする -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <property name="initializeList">
        <list>
            <!-- message、code は別途 component 要素で定義されており、ここでは他で定義したコンポーネントへの参照のみを記述する。 -->
            <component-ref name="message"/>
            <component-ref name="code"/>
        </list>
    </property>
</component>
```

**設定項目** (`BasicApplicationInitializer`):

| プロパティ名 | 説明 |
|---|---|
| initializeList | 初期化が必要なコンポーネントのリスト。リストの順序で初期化が実行される。 |

> **注意**: コンポーネント名 `initializer` として登録するコンポーネントは、`ApplicationInitializer` インタフェースを実装したクラスであれば `BasicApplicationInitializer` 以外でも使用可能。`BasicApplicationInitializer` で対処できない場合は `ApplicationInitializer` を実装したカスタムクラスを作成する。

<details>
<summary>keywords</summary>

BasicApplicationInitializer, Initializable, ApplicationInitializer, initializeList, 初期化処理, DIコンテナ, コンポーネント初期化, アプリケーション起動, アーキテクト

</details>
