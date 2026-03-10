# セッション並行アクセスハンドラ

## ハンドラクラス名

> **重要**: 新規プロジェクトにおける本ハンドラの使用は推奨しない。セッション変数保存ハンドラを使用すること。

セッションごとにリクエスト処理の並行同時アクセスに対してスレッド間の処理不整合を防ぐ。

処理内容:
1. セッションに保持した情報のコピーを作成する
2. 処理終了後、他のスレッドによってセッションが更新されていないかチェックし、更新済みであればエラーとする
3. 処理終了後、セッション情報のコピーをセッションに反映する

**クラス名**: `nablarch.fw.web.handler.SessionConcurrentAccessHandler`

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web</artifactId>
</dependency>
```

## 制約

なし。
