# ファクトリーインジェクションの使用手順

## ファクトリーインジェクションの使用手順

`ComponentFactory` インタフェースを実装したクラスをコンポーネント設定ファイルに記述すると、DIコンテナは `createObject()` メソッドの戻り値をコンポーネントとして扱う（ファクトリークラス自体ではなく）。

**手順**:
1. `ComponentFactory<T>` インタフェースを実装したファクトリークラスを作成する
2. ファクトリークラスを通常のコンポーネントと同様にDIコンテナに登録する

**インタフェース**: `ComponentFactory`

**ファクトリークラス実装例**:

> **注意**: 下記のコードはプロジェクトのアーキテクトが作成するものである。通常、各アプリケーション・プログラマはこのような実装を行わない。

```java
public class SampleComponentFactory implements ComponentFactory<SampleComponent> {
    public SampleComponent createObject() {
        // この例では単にクラスをnewして返しているが、フレームワーク外のソフトウェアに
        // 含まれるクラスの場合は、クラスに必要な初期化処理をハードコーディングする。
        return new SampleComponent();
    }
}
```

**コンポーネント設定ファイル例**:
```xml
<component name="sampleComponent" class="example.SampleComponentFactory"/>
```

**使用例** (`SystemRepository.getObject("sampleComponent")` で `SampleComponentFactory` ではなく `SampleComponent` が返される):
```java
SampleComponent comp = (SampleComponent) SystemRepository.getObject("sampleComponent");
```

<details>
<summary>keywords</summary>

ComponentFactory, createObject, SampleComponentFactory, SampleComponent, SystemRepository, ファクトリーインジェクション, DIコンテナ登録, コンポーネントファクトリー

</details>
