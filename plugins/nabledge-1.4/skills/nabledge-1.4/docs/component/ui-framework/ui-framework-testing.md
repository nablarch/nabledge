# 基盤部品のテスト実施項目

## 

> **注意**: プロジェクトで既存部品を修正または新規追加した場合は、以下に示すものと同等の観点でテストを実施する必要がある。

> **注意**: 現状のテストは打鍵作業に大きく依存している。今後サポートデバイス増加に伴うリグレッションテストの工数を抑えるため自動化を進める予定であり、以下の作業内容は変更される可能性がある。自動化テストケースはプロジェクト側のカスタマイズに伴うリグレッションテストとして流用可能となる予定。

<details>
<summary>keywords</summary>

プロジェクトカスタマイズ時のテスト実施, テスト自動化予定, リグレッションテスト, カスタマイズ対応

</details>

## テスト方針

[internals/jsp_widgets](ui-framework-jsp_widgets.md) に対するブラックボックステストを基本方針とする。各ウィジェットが [reference_jsp_widgets/index](ui-framework-reference_jsp_widgets.md) で定義される外部仕様を満たし、**UI標準**に準拠した表示となることを検証する。

[internals/js_framework](ui-framework-js_framework.md) と [internals/css_framework](ui-framework-css_framework.md) は、上記テストの実施によって間接的に検証される。個別のテストは行わない。

上記に加えて、性能テストおよびチュートリアルアプリケーションを用いた結合テストを実施する。

<details>
<summary>keywords</summary>

ブラックボックステスト, JSPウィジェット, テスト方針, UI標準, 間接検証, 性能テスト, 結合テスト

</details>

## 

[internals/js_framework](ui-framework-js_framework.md)、[internals/inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md): JavaScriptで実装された部分のカバレッジ集計方法が確立していないため、効率的なテストケース抽出およびテスト網羅性評価が実施できない。今後テスト基盤を整備し実施予定。

[internals/jsp_widgets](ui-framework-jsp_widgets.md): 各ウィジェットの実体はJSPタグファイルであり、複雑なロジックは記述できないため、ブラックボックステストで十分な網羅性が得られる。

<details>
<summary>keywords</summary>

ホワイトボックステスト非実施理由, JavaScriptカバレッジ, JSPタグファイル, テスト方針根拠

</details>

## テスト実施環境

| 端末 | OS | ブラウザ | 表示モード | テストパターン |
|---|---|---|---|---|
| PC | Windows 7 SP1 | IE8 | ワイド | **A** |
| PC | Windows 7 SP1 | IE9 | ワイド | **A** |
| PC | Windows 7 SP1 | IE10 | ワイド | **A** |
| PC | Windows 7 SP1 | IE11 | ワイド | **A** |
| PC | Windows 7 SP1 | Firefox | ワイド | **A** |
| PC | Windows 7 SP1 | Chrome | ワイド | **A** |
| Macintosh | OSX 10.9 | safari | ワイド | **A** |
| iPhone 5 | iOS 7.1.2 | mobile safari | ナロー(縦、横) | **B** |
| Galaxy S3 | Android 4.3 | Android標準ブラウザ | ナロー(縦)/コンパクト(横) | **B** |
| iPad (第4世代) | iOS 7.1.2 | mobile safari | コンパクト(縦)/ワイド(横) | **B** |
| Nexus 7 (2012) | Android 4.4.4 | Chrome | ナロー(縦)/コンパクト(横) | **B** |

<details>
<summary>keywords</summary>

テスト対応ブラウザ, テスト実施環境, IE, Safari, Chrome, Firefox, Android, iOS, モバイルデバイス, Windows, OSX

</details>

## 

| テストパターン | 実施テスト |
|---|---|
| **A** | UI部品ウィジェット機能テスト、UI部品ウィジェット性能テスト、UI部品ウィジェット組み合わせテスト、結合テスト、ローカル表示テスト |
| **B** | UI部品ウィジェット機能テスト、UI部品ウィジェット性能テスト、UI部品ウィジェット組み合わせテスト、結合テスト、表示方向切替えテスト |

<details>
<summary>keywords</summary>

テストパターンA, テストパターンB, 実施テスト一覧, ローカル表示テスト, 表示方向切替えテスト, パターン別テスト内容

</details>

## 実施テスト内容

- UI部品ウィジェット機能テスト
- UI部品ウィジェット性能テスト
- UI部品ウィジェット組み合わせテスト
- 結合テスト
- ローカル表示テスト
- 表示方向切替えテスト

<details>
<summary>keywords</summary>

テスト種別一覧, 実施テスト

</details>

## UI部品ウィジェット機能テスト

[internals/jsp_widgets](ui-framework-jsp_widgets.md) に対して以下の観点でテストを行う:

- 各ウィジェットの挙動が [reference_jsp_widgets/index](ui-framework-reference_jsp_widgets.md) で記述した外部仕様に準拠していること
- 各ウィジェットの表示が**UI標準**に記載されている対応するUI部品の仕様に準拠すること

各ウィジェットに定義されている属性値ごとにテストを実施し、以下を確認する:

1. HTMLの属性値が期待通りに設定されていることを、画面ソースコードまたはインスペクタを使用して確認
2. ウィジェットの表示が仕様に従っていることを目視確認

一部のテストケースでは(1)の確認作業を自動化済み。その場合は(2)の表示確認のみを行えばよい。

<details>
<summary>keywords</summary>

UIウィジェット機能テスト, ブラックボックステスト, HTML属性値確認, 表示目視確認, 属性値ごとのテスト, インスペクタ

</details>

## UI部品ウィジェット性能テスト

[internals/jsp_widgets](ui-framework-jsp_widgets.md) を1画面内に大量配置した場合でも問題なく動作することを検証する。

**テスト基準**: 画面内に300個のウィジェットを配置した画面について以下を検証:

1. 画面ロードが完了しユーザ操作が可能となるまで**1秒以内**で完了すること（ロード時間はリクエスト発行からロードイベント発火までの時間をブラウザのデフォルトプロファイラで計測。サーバ処理は単に折り返すのみとし、ローカルサーバを使用）
2. 画面ロード後の操作でJavaScriptスレッドの処理待ち（カーソルが渦巻き型に変化）が発生しないこと

> **注意**: 基準値300個 = **UI標準**での1画面入力項目上限100件 × 安全率3倍。**UI標準**が1画面100件を上限とする根拠は、入力項目数が極端に増加するとユーザビリティが著しく低下するためである（1ページあたりの入力項目が多いとユーザの離脱率が高まり、また画面を誤ってクローズした場合に入力内容が全て消失する危険性がある）。

<details>
<summary>keywords</summary>

性能テスト, 300ウィジェット, 1秒以内, JavaScriptスレッド処理待ち, ロード時間, 安全率, ユーザビリティ低下, 離脱率, データ消失リスク, 入力項目上限100件, 設計根拠

</details>

## UI部品ウィジェット組み合わせテスト

他のUI部品と干渉する可能性のある部品について、組み合わせて使用しても問題が発生しないことを検証する。

例: タブと開閉可能領域、readonly機能とプレースホルダー機能など

<details>
<summary>keywords</summary>

組み合わせテスト, タブ, 開閉可能領域, readonly, プレースホルダー, 部品干渉

</details>

## 結合テスト

Nablarchのチュートリアルアプリケーションを用いて、サーバーサイドの完全な実装を含んだアプリケーションとしてのストーリーテストを実施する。

<details>
<summary>keywords</summary>

結合テスト, チュートリアルアプリケーション, ストーリーテスト, サーバーサイド

</details>

## ローカル表示テスト

[internals/inbrowser_jsp_rendering](ui-framework-inbrowser_jsp_rendering.md) によるローカル表示のテストを行う。UIウィジェット機能テストのテストJSPをローカル表示し、[reference_jsp_widgets/index](ui-framework-reference_jsp_widgets.md) に記載されている仕様どおりに動作することを検証する。

<details>
<summary>keywords</summary>

ローカル表示テスト, inbrowser_jsp_rendering, JSPローカル表示

</details>

## 表示方向切替えテスト

各モバイルデバイスについて、縦持ち・横持ちを切替えた際に画面の表示モードが**UI標準**で定義された表示モードに切り替わることを確認する。

<details>
<summary>keywords</summary>

表示方向切替えテスト, モバイル, 縦持ち, 横持ち, 表示モード切替え

</details>
