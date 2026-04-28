## 初期化処理の使用手順

初期化処理を行うために必要な条件は下記の通りである。

1. Initializable インタフェースに定義された initialize メソッドに初期化時の処理を実装する。
2. 1で作成したクラスをコンポーネントとしてDIコンテナに設定する。
3. BasicApplicationInitializer のプロパティ initializeList に2で設定したコンポーネントを加える。

以下に使用方法の例を示す。

## 初期化対象クラスの定義

初期化対象クラスは、 Initializable インタフェースに定義された initialize メソッドを実装する。
initializeメソッドには、コンポーネントに必要な初期化処理を実装する。

```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class Message implements Initializable {

    // Initializableで定義されているinitializeメソッドを実装する。
    // 必要な初期化処理を本メソッド内ですべて実装する。
    public void initialize() {

        // 初期化処理を実行する。

    }
}
```

## コンポーネント設定ファイルの定義

```xml
<!--
  ApplicationInitializer インタフェースを実装したクラスを登録する。
  コンポーネント名は必ずinitializerとする。
 -->
<component name="initializer" class="nablarch.core.repository.initialization.BasicApplicationInitializer">
    <!--
      BasicApplicationInitializer の initializeList プロパティ。
      ここで記述した順序で初期化が実行される。
    -->
    <property name="initializeList">
        <list>
            <!--
              初期化が必要なコンポーネント。
              message 、 code は別途 component 要素で定義されており、ここでは他で定義したコンポーネントヘの参照のみを記述する。
            -->
            <component-ref name="message"/>
            <component-ref name="code"/>
        </list>
    </property>
</component>
```

## 設定項目

BasicApplicationInitializerの設定

| property名 | 設定内容 |
|---|---|
| initializeList | 初期化が必要となるコンポーネントのリスト。 BasicApplicationInitializer はこのリストの順序に従い初期化を実行する。 |

> **Note:**
> コンポーネント名 Initializer として登録するコンポーネントは、 ApplicationInitializer インタフェースを
> 実装したクラスであれば、 BasicApplicationInitializer 以外のクラスでも初期化処理を実行できる。
> BasicApplicationInitializer では対処できない初期化処理が必要となった場合、 ApplicationInitializer インタフェースを
> 実装したクラスを作成し、必要な初期化処理を実装すること。
