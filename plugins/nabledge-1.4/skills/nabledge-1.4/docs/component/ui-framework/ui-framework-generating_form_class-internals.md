# フォーム自動生成機能

## 概要

設計工程で作成した業務画面JSPから、フォームクラスのJavaソースコードを自動生成する機能。

<details>
<summary>keywords</summary>

フォームクラス自動生成, JSPからJavaソースコード生成, フォーム自動生成機能, 業務画面JSP

</details>

## 使用方法

- 業務画面JSPをローカル表示して右クリックのコンテキストメニューから「フォームクラス生成」を選択
- ブラウザのダウンロードダイアログが開き、生成ソースコードをローカルディスクの任意の場所に保存できる
- 生成コードに含まれるもの：業務画面の入力項目に対応したフィールド定義、アクセサ、単項目精査を定義するアノテーション
- サブクラス側に実装するもの：ウィンドウスコープ経由で引き渡す項目、hidden項目、項目間精査処理

> **注意**: 画面項目一覧に表示されるのはJSPに直接記述した項目のみ。`<jsp:include>`などを経由して描画する項目はJSPのプレビューには表示されるが、画面項目一覧には表示されない。これは、共通化された表示項目は共通部品として個別に設計され、各画面の設計書から参照される形となるためである。

> **警告**: フォーム自動生成機能はFirefoxブラウザのみに対応している。

<details>
<summary>keywords</summary>

フォームクラス生成, コンテキストメニュー, Firefoxブラウザ, 単項目精査, サブクラス実装, ウィンドウスコープ, hidden項目, 項目間精査

</details>

## 関連ファイル

| パス | 内容 |
|---|---|
| /js/devtool/resource/フォーム基底クラステンプレート.java | 生成されるフォームクラスのテンプレート |
| /js/devtool/resource/コード値定義.js | コード設計書の内容を保持するデータファイル。Nablarch Toolboxの画面項目定義データ自動生成ツールで生成。 |
| /js/devtool/resource/ドメイン定義.js | ドメイン定義書の同名シートの内容を保持するデータファイル。Nablarch Toolboxの画面項目定義データ自動生成ツールで生成。 |
| /js/devtool/resource/データタイプ定義.js | ドメイン定義書のデータタイプ定義シートの内容を保持するデータファイル。Nablarch Toolboxの画面項目定義データ自動生成ツールで生成。 |
| /js/devtool/resource/精査処理定義.js | ドメイン定義書の精査処理定義シートの内容を保持するデータファイル。Nablarch Toolboxの画面項目定義データ自動生成ツールで生成。 |
| /js/devtool/resource/タグ定義.js | 各タグのメタ情報を記述するファイル。各タグが入力項目か否かを判定する場合などに参照。プロジェクトでプラグインを追加した場合は本ファイルへのメタ情報記述が必要。記載内容は [../internals/configuration_files](ui-framework-configuration_files.md) を参照。 |

> **注意**: 設計書から自動生成するファイルは、設計書が修正された場合に再生成して最新化する必要がある。

<details>
<summary>keywords</summary>

フォーム基底クラステンプレート, コード値定義.js, ドメイン定義.js, データタイプ定義.js, 精査処理定義.js, タグ定義.js, Nablarch Toolbox, 画面項目定義データ自動生成ツール

</details>

## 出力仕様

### パッケージ宣言（出力回数: 1回）

パッケージ名の固定部はPJの名前空間で書き換えること。

```java
package please.change.me.ss【機能ID】;
```

- 【機能ID】: ファイル名(=画面ID)の部分文字列

### インポート宣言（出力回数: 1回）

固定的な内容をそのまま出力。PJ側でカスタム精査を追加している場合はテンプレートに依存クラスを追加すること。

> **警告**: 余分なクラスが出力されるため、CI等で静的検査を行う場合は検出対象外にすること。

```java
import java.util.HashMap;
import java.util.Map;
import java.math.BigDecimal;
import please.change.me.core.validation.validator.MailAddress;
import nablarch.common.code.validator.CodeValue;
import nablarch.core.validation.PropertyName;
import nablarch.core.validation.ValidateFor;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationUtil;
import nablarch.core.validation.convertor.Digits;
import nablarch.core.validation.validator.NumberRange;
import nablarch.core.validation.validator.Length;
import nablarch.core.validation.validator.Required;
import nablarch.core.validation.validator.unicode.SystemChar;
import nablarch.core.db.support.ListSearchInfo;
```

### クラス宣言部（出力回数: 1回）

```java
/**
 *  【画面名】フォーム。
 *
 * @author 【設計担当者名】
 * @since 1.0
**/
public abstract class 【画面ID】FormBase 【extends ListSearchInfo】{
```

- 【画面名】: JSP内の`<t:page_template>`タグのtitle属性
- 【設計担当者名】: JSP内の`<spec:author>`タグの内容
- 【画面ID】: ファイル名から拡張子を除いた文字列
- 【extends ListSearchInfo】: 画面内に`<table:search_result>`が存在すれば`ListSearchInfo`を継承

### フィールド定義・アクセサ（出力回数: 入力項目ごとに1回）

入力項目 = `<field:xxx>`系タグのうち`<field:label>`（表示要素）・`<field:hint>`（装飾要素）等を除いたもの。

```java
/** 【フィールド論理名】 **/
private 【フィールドJava型】 【フィールド物理名】;

/**
 * 【フィールド論理名】を取得する。
 *
 * @return 【フィールド論理名】。
**/
public 【Java型】 get【フィールド物理名】() {
    return this.【フィールド物理名】;
}

/**
 * 【フィールド論理名】を設定する。
 *
 * @param 【フィールド物理名】 設定する【フィールド論理名】。
**/
@PropertyName("【フィールド論理名】")
【必須精査アノテーション】
【データ長精査アノテーション】
【データ形式精査アノテーション】
【追加精査アノテーション】
public void set【フィールド物理名】(【Java型】 【フィールド物理名】) {
    this.【フィールド物理名】 = 【フィールド物理名】;
}
```

フィールドの仕様：
- 【フィールド論理名】: `<field:xxx>`タグのtitle属性
- 【フィールド物理名】: `<field:xxx>`タグのname属性
- 【フィールドJava型】: `BigDecimal`（domainが数値型）/ `String[]`（`<field:listbuilder>`・`<field:checkbox>`等の複数入力項目）/ `String`（上記以外）

アノテーションの仕様：
- 【必須精査アノテーション】: `required=true`の場合は`@Required`を出力
- 【データ長精査アノテーション】: **ドメイン定義.js** のdomain属性値から **データタイプ定義.js** / **精査処理定義.js** を参照し、`@Length`（文字列長精査）/ `@Digits`（数値桁精査）/ なし のいずれかを出力
- 【データ形式精査アノテーション】: 同様にdomain属性からデータ形式精査種別に対応するアノテーションを出力
- 【追加精査アノテーション】: **ドメイン定義.js** の【データタイプ詳細】欄に `[精査処理定義名:精査引数名1=精査引数1,...]` 形式の記述がある場合に対応するアノテーションを出力（例: `[文字列長精査:min=4,max=12]`）

### コンストラクタ定義（出力回数: 1回）

```java
/** デフォルトコンストラクタ。 **/
public 【画面ID】FormBase() {
}

/**
 * Mapを引数にとるコンストラクタ。
 * @param params 項目名をキーとし、項目値を値とするMap
**/
public 【画面ID】FormBase(Map<String, Object> params) {
    【フィールド物理名】 = (【Java型】) params.get("【フィールド物理名】");
    setPageNumber((Integer) params.get("pageNumber"));
    setSortId((String) params.get("sortId"));
}
```

### Mapへの変換（出力回数: 1回）

```java
/**
 * プロパティの情報をMapに変換する。
 *
 * @return 変換後のMap
**/
protected Map<String, Object> toMap() {
    Map<String, Object> result = new HashMap<String, Object>();
    result.put("【フィールド物理名】", 【フィールド物理名】);
    result.put("pageNumber", getPageNumber());
    result.put("sortId", getSortId());
    return result;
}
```

<details>
<summary>keywords</summary>

パッケージ宣言, インポート宣言, クラス宣言, ListSearchInfo, table:search_result, フィールド定義, @PropertyName, @Required, @Length, @Digits, @SystemChar, @CodeValue, @NumberRange, コンストラクタ, toMap, FormBase

</details>
