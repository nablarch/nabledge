# アーキテクチャ

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/nablarch/architecture.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/OnDoubleSubmission.html) [3](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/token/UseToken.html) [4](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnErrors.html) [5](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/interceptor/OnError.html) [6](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/common/web/interceptor/InjectForm.html) [7](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/Interceptor.Factory.html)

## Nablarchアプリケーションフレームワークの主な構成要素

> **警告**: 本項で解説するアーキテクチャは、[jsr352_batch](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md) には該当しない（詳細は [jsr352_batch](../../processing-pattern/jakarta-batch/jakarta-batch-jsr352.md) の [jsr352_architecture](../../processing-pattern/jakarta-batch/jakarta-batch-architecture.md) を参照）。

![Nablarchアプリケーションフレームワーク構成要素](../../../knowledge/about/about-nablarch/assets/about-nablarch-architecture/fw-design.png)

<details>
<summary>keywords</summary>

Nablarchフレームワーク構成要素, アーキテクチャ概要, JSR352バッチ適用外, フレームワーク設計図

</details>

## ハンドラキュー(handler queue)

ハンドラキューとは、リクエスト/レスポンスへの横断的処理を行うハンドラ群を定められた順序で定義したキュー。サーブレットフィルタのチェーン実行と同様に処理を実行する。

![ハンドラキュー処理](../../../knowledge/about/about-nablarch/assets/about-nablarch-architecture/handlers.png)

**ハンドラの主な処理**:
- リクエストのフィルタリング（アクセス権限のあるリクエストのみ受け付ける処理など）
- リクエスト/レスポンスの変換
- リソースの取得・解放（DB接続の取得・解放など）

> **補足**: 横断的処理はプロジェクト側でハンドラを実装して対応すること。業務ロジッククラスの親クラスに共通処理を実装するのではなく、個別ハンドラとして実装することを推奨する（個別ハンドラの前後に処理を追加したい場合は [nablarch_architecture-interceptor](#s2) を使用すること）。
>
> - **個別ハンドラで実装した場合**: 各ハンドラの責務が明確でテスト容易・保守性高い。共通処理の抜き差しも容易。
> - **親クラスに共通処理を実装した場合**: 処理増加で親クラスが肥大化し複数責務を持つ。テスト複雑化・不具合の温床。継承漏れが異常終了にならず不具合検知が困難。

**処理フロー**:
1. Nablarchは受け取ったリクエストに対し、ハンドラキュー上のハンドラを先頭から順に実行する。
2. レスポンスが返却された場合、これまでに実行されたハンドラを逆順に実行する。

ハンドラは前後関係を意識してハンドラキューに設定しないと正常に動作しないものがある。ハンドラキュー構築時は各ハンドラのドキュメントを参照すること。

### インターセプタ(interceptor)

インターセプタとは、実行時に動的にハンドラキューに追加されるハンドラのこと。特定のリクエストのみ処理を追加したい場合や、リクエストごとに設定値を切り替えて処理を実行したい場合に適している。

> **補足**: インターセプタは、Jakarta EEのJakarta Contexts and Dependency Injectionで定義されているインターセプタと同様に処理を実行する。

> **重要**: インターセプタの実行順序は設定ファイルで設定する必要がある。設定がない場合、実行順はJVM依存となる。Nablarchがデフォルトで提供するインターセプタの実行順（この順序で設定すること）:
> 1. `OnDoubleSubmission`
> 2. `UseToken`
> 3. `OnErrors`
> 4. `OnError`
> 5. `InjectForm`
>
> インターセプタの実行順設定の詳細は `Factory` を参照。

<details>
<summary>keywords</summary>

ハンドラキュー, ハンドラ, インターセプタ, 横断的処理, OnDoubleSubmission, UseToken, OnErrors, OnError, InjectForm, nablarch.common.web.token.OnDoubleSubmission, nablarch.common.web.token.UseToken, nablarch.fw.web.interceptor.OnErrors, nablarch.fw.web.interceptor.OnError, nablarch.common.web.interceptor.InjectForm, Interceptor.Factory, nablarch.fw.Interceptor.Factory

</details>

## ライブラリ(library)

ライブラリとは、データベースアクセスやファイルアクセス、ログ出力などのようにハンドラから呼び出されるコンポーネント群のこと。Nablarchアプリケーションフレームワークが提供するライブラリは [library](../../component/libraries/libraries-libraries.md) を参照。

<details>
<summary>keywords</summary>

ライブラリ, データベースアクセス, ファイルアクセス, ログ出力, コンポーネント

</details>
