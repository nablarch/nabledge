# 画面遷移処理

## JSPでの画面遷移実装（n:form / n:submitタグ）

## JSPでの画面遷移実装（n:form / n:submitタグ）

アプリケーションフレームワーク提供のカスタムタグを使用して画面遷移を実装する。

- **n:formタグ**: HTMLフォームを作成する
- **n:submitタグ**: ボタンを指定する。`uri`属性にサブミットするパスを指定する

JSPソースファイル: [W11AC0201.jsp](../../../knowledge/guide/web-application/assets/web-application-05_screenTransition/W11AC0201.jsp), [W11AC0202.jsp](../../../knowledge/guide/web-application/assets/web-application-05_screenTransition/W11AC0202.jsp)

> **補足**: W11AC0202.jsp 内で W11AC0201.jsp を取り込んでいる。

<details>
<summary>keywords</summary>

n:form, n:submit, uri属性, HTMLフォーム, 画面遷移, W11AC0201.jsp, W11AC0202.jsp, カスタムタグ

</details>

## 登録画面への戻り時の入力値の復元

## 登録画面への戻り時の入力値の復元

「登録画面へ」ボタンで前の画面に戻った場合に入力内容を復元するには、以下の2点のみ実装する。これだけで、単純に戻り先の画面へ遷移させれば入力内容が復元される。

1. 入力項目（テキストエリア、ラジオボタンなど）を作成する際は、アプリケーションフレームワーク提供のカスタムタグを使用する
2. n:formタグの`windowScopePrefixes`属性に、入力項目のカスタムタグの`name`属性に指定したプレフィックス（:ref:`(参照)<04_JSPNameAttribute>`）を指定する

<details>
<summary>keywords</summary>

windowScopePrefixes, 入力値復元, 前画面へ戻る, カスタムタグ, n:form, ウィンドウスコープ

</details>
