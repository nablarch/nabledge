# ファクトリーインジェクションの使用手順

## ファクトリーインジェクションの使用手順

ファクトリーインジェクションの使用手順:

1. `ComponentFactory` インタフェースを実装したファクトリークラスを作成する
2. 作成したファクトリークラスをDIコンテナに登録する

`ComponentFactory` を実装したクラスをコンポーネント設定ファイルに登録すると、DIコンテナはその設定を特別に扱い、`ComponentFactory` に定義された `createObject` メソッドが返すオブジェクトをコンポーネントとして扱う。

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

**コンポーネント設定ファイル**:
```xml
<component name="sampleComponent" class="example.SampleComponentFactory"/>
```

**使用例** (`sampleComponent` を指定すると `SampleComponentFactory` ではなく `SampleComponent` が取得できる):
```java
SampleComponent comp = (SampleComponent) SystemRepository.getObject("sampleComponent");
```

<details>
<summary>keywords</summary>

ComponentFactory, SampleComponentFactory, SampleComponent, createObject, SystemRepository, ファクトリーインジェクション, DIコンテナ登録, コンポーネント設定ファイル, ファクトリークラス

</details>
