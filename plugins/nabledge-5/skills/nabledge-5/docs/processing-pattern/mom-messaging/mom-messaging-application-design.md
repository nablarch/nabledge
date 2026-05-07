# アプリケーションの責務配置

MOMメッセージングを作成する際に実装すべきクラスとその責務について説明する。

**クラスとその責務**

![mom_messaging_design.png](../../../knowledge/assets/mom-messaging-application-design/mom_messaging_design.png)

アクションクラス(action class)

アクションクラスは、データリーダ(
FwHeaderReader /
MessageReader
)が読み込んだ要求電文(
RequestMessage
)を元に業務ロジックを実行し、応答電文(
ResponseMessage
)を返却する。

例えば、要求電文の取り込みであれば、業務ロジックとして以下の処理を行う。

* 要求電文からフォームクラスを作成して、バリデーションを行う。
* フォームクラスからエンティティクラスを作成して、データベースにデータを追加する。
* 応答電文を作成して返す。

> **Tip:**
> 応答不要メッセージングでは、以下の点が異なる。

> * >   応答不要メッセージングは、データ取り込みが目的で、業務ロジックは後続するバッチが行うため、
>   バリデーションを行わない。
> * >   応答不要メッセージングは電文を返さないので、
>   処理結果として Success を返す。

フォームクラス(form class)

データリーダ(
FwHeaderReader /
MessageReader
)が読み込んだ要求電文(
RequestMessage
)をマッピングするクラス。

要求電文をバリデーションするためのアノテーションの設定や相関バリデーションのロジックを持つ。

フォームクラスのプロパティは全て String で定義する

プロパティを String とすべき理由は、 [Bean Validation](../../component/libraries/libraries-bean-validation.md#バリデーションルールの設定方法) を参照。
ただし、バイナリ項目の場合はバイト配列で定義する。

エンティティクラス(entity class)

テーブルと1対1で対応するクラス。カラムに対応するプロパティを持つ。

> **Important:**
> メッセージングでは、システムで共通のデータリーダを使うことを想定しているため、
> [Nablarchバッチアプリケーションの責務配置](../../processing-pattern/nablarch-batch/nablarch-batch-application-design.md#アプリケーションの責務配置) と異なり、
> アクションがデータリーダを生成する責務を持っていない。

> メッセージングで使用するデータリーダは、コンポーネント定義に `dataReader` という名前で追加する。
