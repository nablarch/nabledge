# データベース機能のバージョンアップ対応

## データベース機能のバージョンアップ対応

### バージョンアップの際には、以下の手順に従い取り込んでください。

### ■SqlConvertorの実装クラスの変更

#### SqlConvertorインタフェースのconvertメソッドの引数が変更されています。

#### プロジェクトで、このインタフェースの実装クラスを作成している場合には、実装クラスの修正が必要となります。

#### 修正方法は、nablarchで提供している実装クラスを参照してください。

#### nablarchで提供しているSqlConvertorインタフェースの実装クラスは、「nablarch.core.db.statement.sqlconvertor」パッケージ配下にあります。

#### また、本インタフェースの実装クラスをサポートする抽象クラスの「SqlConvertorSupport」のインタフェースも変更されています。

#### これについても、nablarchが提供している実装クラスを参照し、修正を行ってください。

### ■FieldAnnotationHandlerSupport実装クラスの変更

#### getFieldListメソッドの引数及び戻り値が変更されています。

#### プロジェクトで、このクラスの実装クラスを作成している場合、実装クラスの修正が必要となります。

#### 修正方法は、nablarchで提供している実装クラスを参照してください。

#### nablarchで提供しているFieldAnnotationHandlerSupportの実装クラスは、「nablarch.core.db.statement.autoproperty」パッケージ配下にあります。

### ■コンポーネント設定ファイルの修正

#### FieldAndAnnotationLoaderが非推奨に変更になっています。FieldAndAnnotationLoaderのコンポーネント設定をコンポーネント設定ファイル(xml)から削除してください。

#### また、削除したコンポーネント名を使用している箇所も全て削除してください。削除しないと、コンポーネント未定義により実行時エラーとなります。

#### 以下のクラスからfieldAnnotationCacheプロパティが削除されています。

#### コンポーネント設定ファイルからも、fieldAnnotationCacheの設定を削除してください。

#### nablarch.core.db.statement.autoproperty.CurrentDateTimeAnnotationHandler

#### nablarch.core.db.statement.autoproperty.RequestIdAnnotationHandler

#### nablarch.core.db.statement.autoproperty.UserIdAnnotationHandler

#### nablarch.core.db.statement.BasicStatementFactoryクラスからobjectFieldCacheプロパティが削除されています。

#### コンポーネント設定ファイルから、objectFieldCacheプロパティの設定を削除してください。

#### ※今回のリリースでは、廃止したプロパティはそのまま残しています。このため、コンポーネント設定ファイルは修正しなくても動作します。

#### ただし、default-configurationのバージョンを5u5リリースバージョンに変更した場合、コンポーネント設定ファイルに対する修正が必要となります。

#### 修正内容は、コンポーネント名が「statementValueObjectCache」のオブジェクトを全て削除します。

### ■データベース機能に指定しているオブジェクトの修正

#### 今回の対応により、データベース機能ではバインド変数にオブジェクトの値を設定する際にフィールドではなくプロパティ（getter）を参照するようになります。

#### このため、getterの存在しないオブジェクトを指定している場合、オブジェクトを使用した検索や登録機能が動作しなくなります。

#### フィールドのみのオブジェクトを指定している場合には、getterを追加する修正が必要となります。
