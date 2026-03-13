# 基盤部品のテスト実施項目

**公式ドキュメント**: [基盤部品のテスト実施項目](https://nablarch.github.io/docs/LATEST/doc/development_tools/ui_dev/doc/testing.html)

## 概要

> **補足**: 既存部品の修正・新規追加時は、基本的に以下と同等の観点でテストを実施する必要がある。

> **補足**: 現状のテストは打鍵作業に大きく依存している。今後サポートデバイス増加に伴うリグレッション工数削減のためテスト自動化を計画中のため、以下の作業内容は変更される可能性がある。自動化されたテストケースはプロジェクト側カスタマイズ時のリグレッションテストとして流用可能となる予定。

<details>
<summary>keywords</summary>

テスト実施方針, カスタマイズ対応テスト, テスト自動化計画, リグレッションテスト

</details>

## テスト方針

基本的に [internals/jsp_widgets](testing-framework-jsp_widgets.md) に対するブラックボックステストを実施する。

テスト目的:
- 各ウィジェットが [reference_jsp_widgets/index](testing-framework-ui-dev-doc-reference-jsp-widgets.md) で定義される外部仕様を満たすこと
- **UI標準** に準拠した表示となること

[internals/js_framework](testing-framework-js_framework.md) ・ [internals/css_framework](testing-framework-css_framework.md) は [internals/jsp_widgets](testing-framework-jsp_widgets.md) のテストにより間接的に検証するため個別テストは行わない。

上記に加え、性能テストおよびサンプルアプリを用いた結合テストも実施する。

> **補足**: ホワイトボックス的なテストケース抽出を行っていない理由:
> - [internals/js_framework](testing-framework-js_framework.md) / [internals/inbrowser_jsp_rendering](testing-framework-inbrowser_jsp_rendering.md): JavaScriptのカバレッジ集計方法が未確立のため効率的なテストケース抽出・網羅性評価ができない。今後テスト基盤を整備して実施予定。
> - [internals/jsp_widgets](testing-framework-jsp_widgets.md): 各ウィジェットの実体はJSPタグファイルであり複雑なロジックは記述できないため、ブラックボックステストで十分な網羅性が得られる。

<details>
<summary>keywords</summary>

ブラックボックステスト, テスト方針, jsp_widgets, js_framework, css_framework, ホワイトボックステスト

</details>

## テスト実施環境

| 端末 | OS | ブラウザ | 表示モード | 実施テストパターン |
|---|---|---|---|---|
| PC | Windows 10 Pro (ビルド番号16299) | IE11 | ワイド | **A** |
| PC | Windows 10 Pro (ビルド番号16299) | Firefox | ワイド | **A** |
| PC | Windows 10 Pro (ビルド番号16299) | Chrome | ワイド | **A** |
| Macintosh | OSX 10.9.5 | safari | ワイド | **A** |
| iPhone 5 | iOS 10.3.3 | mobile safari | ナロー(縦、横) | **B** |
| iPad (第4世代) | iOS 10.3.3 | mobile safari | コンパクト(縦)、ワイド(横) | **B** |
| Nexus 7 (2012) | Android 5.1.1 | Chrome | ナロー(縦)、コンパクト(横) | **B** |

| 実施テストパターン | 実施テスト |
|---|---|
| **A** | UI部品ウィジェット機能テスト、UI部品ウィジェット性能テスト、UI部品ウィジェット組み合わせテスト、結合テスト、ローカル表示テスト |
| **B** | UI部品ウィジェット機能テスト、UI部品ウィジェット性能テスト、UI部品ウィジェット組み合わせテスト、結合テスト、表示方向切替えテスト |

<details>
<summary>keywords</summary>

テスト実施環境, 対応ブラウザ, IE11, Firefox, Chrome, Safari, mobile safari, テストパターン, Windows, iOS, Android, Macintosh, iPhone 5, iPad, Nexus 7

</details>

## 実施テスト内容

実施テストの種別:
- UI部品ウィジェット機能テスト
- UI部品ウィジェット性能テスト
- UI部品ウィジェット組み合わせテスト
- 結合テスト
- ローカル表示テスト
- 表示方向切替えテスト

<details>
<summary>keywords</summary>

実施テスト内容, UIテスト種別, テスト分類

</details>

## UI部品ウィジェット機能テスト

[internals/jsp_widgets](testing-framework-jsp_widgets.md) に対して以下の観点で単体テストを行う:
- 各ウィジェットの挙動が [reference_jsp_widgets/index](testing-framework-ui-dev-doc-reference-jsp-widgets.md) の外部仕様に準拠していること
- 各ウィジェットの表示が **UI標準** に記載されている対応UI部品仕様に準拠すること

機能テストは各ウィジェットに定義されている属性値ごとに実施し、以下を確認する:
1. HTMLの属性値が期待通りに設定されているか（画面ソースコードまたはインスペクタで確認）
2. ウィジェットの表示が仕様に従っているか（目視確認）

> **補足**: 一部テストケースでは属性値確認（上記1）を自動化。その場合は表示確認（上記2）のみ実施。

<details>
<summary>keywords</summary>

UI部品ウィジェット機能テスト, 外部仕様検証, 属性値確認, HTMLインスペクタ, 単体テスト, 目視確認

</details>

## UI部品ウィジェット性能テスト

300個のウィジェットを配置した画面で以下の基準を満たすことを検証する:

1. 画面ロードが完了しユーザ操作可能になるまで **1秒以内**（リクエスト発行からloadイベント発火まで。ブラウザのデフォルトプロファイラで計測。**サーバ処理は単に折り返すのみとし**、ローカルサーバを使用する）
2. 画面ロード後の操作でJavaScriptスレッドの処理待ち（カーソルが渦巻き型に変化）が発生しないこと

> **補足**: テスト基準値300個の根拠: **UI標準** で1画面の入力項目上限を100件程度と規定しており、これに安全率3倍をかけた値。

<details>
<summary>keywords</summary>

UI部品ウィジェット性能テスト, 300ウィジェット, 画面ロード1秒以内, パフォーマンステスト, JavaScriptスレッド

</details>

## UI部品ウィジェット組み合わせテスト

他のUI部品と干渉する可能性のある部品を組み合わせて使用しても問題が発生しないことを検証する。

例: タブと開閉可能領域、readonly機能とプレースホルダー機能

<details>
<summary>keywords</summary>

UI部品ウィジェット組み合わせテスト, タブ, 開閉可能領域, readonly, プレースホルダー, 干渉テスト

</details>

## 結合テスト

Nablarchのサンプルアプリケーションを用いて、サーバサイドの完全な実装を含むアプリケーションとしてのストーリーテストを実施する。

<details>
<summary>keywords</summary>

結合テスト, サンプルアプリケーション, ストーリーテスト, サーバサイド

</details>

## ローカル表示テスト

[internals/inbrowser_jsp_rendering](testing-framework-inbrowser_jsp_rendering.md) によるローカル表示のテストを行う。

UIウィジェット機能テストのテストJSPをローカル表示し、 [reference_jsp_widgets/index](testing-framework-ui-dev-doc-reference-jsp-widgets.md) で記載されている仕様どおりに動作することを検証する。

<details>
<summary>keywords</summary>

ローカル表示テスト, inbrowser_jsp_rendering, ローカル表示, JSPローカル表示

</details>

## 表示方向切替えテスト

各モバイルデバイスについて、縦持ち・横持ちを切り替えた際に、画面の表示モードが **UI標準** で定義された表示モードに切り替わることを確認する。

<details>
<summary>keywords</summary>

表示方向切替えテスト, 縦横切替, モバイルデバイス, 表示モード, 縦持ち, 横持ち

</details>
