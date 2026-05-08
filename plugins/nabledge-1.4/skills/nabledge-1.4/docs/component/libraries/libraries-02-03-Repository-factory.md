## ファクトリーインジェクションの使用手順

ファクトリーインジェクションを使用する際の手順は下記の通り。

1. ComponentFactory インタフェースを実装したクラス(ファクトリークラス)を作成する。
2. 作成したファクトリークラスを通常のコンポーネントと同様にDIコンテナに登録する。

ComponentFactory インタフェースを実装したクラスをコンポーネントとしてコンポーネント設定ファイルに記述した場合、DIコンテナは
この設定を特別に扱い、 ComponentFactory インタフェースに定義された createObject メソッドで返されたオブジェクト
をコンポーネントとする。

実装例を下記に示す。

## ファクトリークラスの実装例

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

## コンポーネント設定ファイル

```xml
<?xml version="1.0" encoding="UTF-8"?>
<component-configuration xmlns="http://tis.co.jp/nablarch/component-configuration" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://tis.co.jp/nablarch/component-configuration ./component-configuration.xsd">

    <component name="sampleComponent" class="example.SampleComponentFactory"/>
</component-configuration>
```

## 使用例

```java
// "sampleComponent" を指定した場合、 SampleComponentFactory ではなく、
// SampleComponent が取得できる。
SampleComponent comp = (SampleComponent) SystemRepository.getObject("sampleComponent");
```
