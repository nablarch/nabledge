# 別紙_分割後jarの取り込み

1. 分割後ライブラリの導入
リリース zip の mvn_repository/com/nablarch/framework/ ディレクトリ以下のjarファイルを、nablarch-testingを除き全てコピーします。
これらのjarファイルが、今までのnablarch.jarに相当します。
これらのファイルを、今までnablarch.jarが存在した場所に配置し、クラスパスを設定します。
2. PJ成果物の修正
上述のjarファイル群には、後方互換性維持用のライブラリが含まれています（nablarch-backward-compatibility)。
このライブラリを導入することにより、分割後のライブラリを導入する際に変更点が極小化されます。
一部、後方互換性維持ライブラリで吸収しきれない変更がありますので、
以下の対処を行います。
2-1. コンポーネント定義ファイルの修正
以下のクラスについて、コンポーネント定義ファイルでの使用箇所を修正してください。（class属性）
・nablarch.fw.handler.ProcessStopHandler
【修正例】
[変更前]
<component name="processStopHandler" class="nablarch.fw.handler.ProcessStopHandler">
[変更後]
<component name="processStopHandler" class="nablarch.fw.handler.BasicProcessStopHandler">
2-2. Javaソースファイルの修正
以下のクラスは、パッケージが変更になりました。
変更前  変更後
nablarch.fw.Result.ServiceError  nablarch.fw.results.ServiceError
nablarch.fw.Result.BadRequest  nablarch.fw.results.BadRequest
nablarch.fw.Result.Unauthorized  nablarch.fw.results.Unauthorized
nablarch.fw.Result.Conflicted  nablarch.fw.results.Conflicted
nablarch.fw.Result.Forbidden  nablarch.fw.results.Forbidden
nablarch.fw.Result.RequestEntityTooLarge  nablarch.fw.results.RequestEntityTooLarge
nablarch.fw.Result.ServiceUnavailable  nablarch.fw.results.ServiceUnavailable
nablarch.fw.Result.InternalError  nablarch.fw.results.InternalError
javaソースファイルで、上記クラスを参照している場合、
当該ソースファイルに対して修正を行います。
【修正例】
[変更前]
import nablarch.fw.Result.ServiceError;
[変更後]
import nablarch.fw.results.ServiceError;
※Eclipse等のIDEにある、import編成機能を使うと効率よく修正できます。
