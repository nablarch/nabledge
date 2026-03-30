# 初期化処理の使用手順

## 初期化処理の使用手順

## 初期化処理の使用手順

初期化処理を行うための条件:
1. `Initializable` インタフェースの `initialize` メソッドに初期化処理を実装する
2. 作成したクラスをDIコンテナにコンポーネントとして設定する
3. `BasicApplicationInitializer` の `initializeList` プロパティに追加する

**クラス**: `Initializable`, `BasicApplicationInitializer`

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class Message implements Initializable {
    public void initialize() {
        // 初期化処理を実行する。
    }
}
```

コンポーネント名は必ず `initializer` とする:

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
| initializeList | 初期化が必要なコンポーネントのリスト。リストの順序で初期化を実行する。 |

> **注意**: コンポーネント名 `initializer` に登録するクラスは `ApplicationInitializer` インタフェースを実装していれば `BasicApplicationInitializer` 以外でも可。`BasicApplicationInitializer` で対処できない初期化処理が必要な場合、`ApplicationInitializer` を実装したクラスを作成すること。

<details>
<summary>keywords</summary>

Initializable, BasicApplicationInitializer, ApplicationInitializer, initializeList, 初期化処理, DIコンテナ初期化, コンポーネント初期化順序

</details>
