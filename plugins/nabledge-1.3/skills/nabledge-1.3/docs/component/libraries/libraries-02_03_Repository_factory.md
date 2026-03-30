# ファクトリーインジェクションの使用手順

## ファクトリーインジェクションの使用手順

`ComponentFactory`インタフェースを実装したクラスをコンポーネント設定ファイルに登録すると、DIコンテナはそれを特別扱いし、`createObject`メソッドが返すオブジェクトをコンポーネントとして使用する。

**使用手順**:
1. `ComponentFactory`インタフェースを実装したファクトリークラスを作成する
2. ファクトリークラスを通常のコンポーネントと同様にDIコンテナに登録する

**クラス**: `ComponentFactory`

**ファクトリークラス実装例**:
```java
// ******** 注意 ********
// 下記のコードはプロジェクトのアーキテクトが作成するものである。
// 通常、各アプリケーション・プログラマはこのような実装を行わない。

public class SampleComponentFactory implements ComponentFactory<SampleComponent> {
    public SampleComponent createObject() {
        // コンポーネントを生成する。
        // この例では単にクラスをnewして返しているが、フレームワーク外のソフトウェアに
        // 含まれるクラスの場合は、クラスに必要な初期化処理をハードコーディングする。
        return new SampleComponent();
    }
}
```

**コンポーネント設定ファイル**:
```xml
<component name="sampleComponent" class="example.SampleComponentFactory"/>
```

**使用時の挙動**: `SystemRepository.getObject("sampleComponent")`を呼び出すと、`SampleComponentFactory`ではなく`SampleComponent`が返される。
```java
SampleComponent comp = (SampleComponent) SystemRepository.getObject("sampleComponent");
```

<details>
<summary>keywords</summary>

ComponentFactory, SampleComponentFactory, SampleComponent, SystemRepository, createObject, ファクトリーインジェクション, DIコンテナ, コンポーネント設定ファイル

</details>
