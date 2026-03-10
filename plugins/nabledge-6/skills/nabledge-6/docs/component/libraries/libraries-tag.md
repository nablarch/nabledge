# Jakarta Server Pagesカスタムタグ

## 機能概要

> **補足**: Nablarch 5までは「JSPカスタムタグ」という名称だったが、Nablarch 6で「Jakarta Server Pagesカスタムタグ」に名称変更された。機能的な差はない。その他Nablarch 6で名称変更された機能は :ref:`renamed_features_in_nablarch_6` を参照。

カスタムタグの制約:
- Jakarta Server Pages 3.1以降をサポートするWebコンテナで動作する
- 条件分岐やループの制御にはJakarta Standard Tag Libraryを使用する
- XHTML 1.0 Transitionalに対応した属性をサポートする
- クライアントのJavaScriptが必須（:ref:`tag-onclick_override` を参照）
- GETリクエストで一部のカスタムタグが使用できない（:ref:`tag-using_get` を参照）

> **重要**: HTML5で追加された属性は :ref:`動的属性 <dynamic_attribute>` を使用して記述できる。頻繁に使用される以下の属性はカスタムタグの属性として事前定義済み: autocomplete（input、password、form）、autofocus（input、textarea、select、button）、placeholder（text、password、textarea）、maxlength（textarea）、multiple（input）。HTML5で追加されたinput要素（search、tel、url、email、date、month、week、time、datetimeLocal、number、range、color）の固有属性はカスタムタグで個別定義していないため、動的属性で指定する必要がある。

> **重要**: カスタムタグはリッチな画面やSPA（シングルページアプリケーション）に対応していない。対象とする画面遷移パターン: 検索→詳細画面、入力→確認→完了画面、ポップアップによる入力補助。JavaScriptを多用する場合はカスタムタグが出力するJavaScript（:ref:`tag-onclick_override`）との副作用に注意。

**HTMLエスケープ漏れ防止**: カスタムタグはデフォルトでHTMLエスケープするため、EL式のようなXSS脆弱性を防げる。詳細は :ref:`tag-html_escape`、:ref:`tag-html_unescape` を参照。

> **重要**: JavaScriptへのエスケープ処理は提供していない。scriptタグのボディやonclick属性などJavaScriptを記述する部分に動的な値（入力データなど）を埋め込まないこと。埋め込む場合はプロジェクトの責任でエスケープ処理を実施すること。

**入力画面と確認画面のJSP共通化**: 入力画面向けJSPに確認画面との差分（ボタンなど）のみ追加実装するだけで確認画面を作成できる。詳細は :ref:`tag-make_common` を参照。

## モジュール一覧

**モジュール**:
```xml
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-tag</artifactId>
</dependency>

<!-- hidden暗号化を使う場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-common-encryption</artifactId>
</dependency>

<!-- ファイルダウンロードを使う場合のみ -->
<dependency>
  <groupId>com.nablarch.framework</groupId>
  <artifactId>nablarch-fw-web-extension</artifactId>
</dependency>
```

## カスタムタグの設定

カスタムタグの設定は :ref:`nablarch_tag_handler` と `CustomTagConfig` により行う。

**:ref:`nablarch_tag_handler`**: カスタムタグを使用するリクエスト処理時の前処理を行うハンドラ。カスタムタグを使用する場合は設定が必須。以下の機能に必要:
- :ref:`tag-checkbox_off_value`
- :ref:`tag-hidden_encryption`
- :ref:`tag-submit_change_parameter`
- :ref:`tag-composite_key`

**クラス**: `CustomTagConfig` — カスタムタグのデフォルト値設定クラス。`customTagConfig`という名前でコンポーネント定義に追加する。設定項目の詳細は `CustomTagConfig` のJavadocを参照。

## カスタムタグを使用する(taglibディレクティブの指定方法)

カスタムタグとJSTLを使用するため、以下のtaglibディレクティブを指定する。

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="n" uri="http://tis.co.jp/nablarch" %>
```

## 入力フォームを作る

入力フォームは以下のカスタムタグを使用して作成する:
- :ref:`tag-form_tag`
- :ref:`tag-text_tag` などの入力に関するカスタムタグ
- :ref:`tag-submit_tag` などのサブミットを行うカスタムタグ
- :ref:`tag-error_tag` などのエラー表示を行うカスタムタグ

**入力値の復元**: バリデーションエラーなどで入力フォームを再表示した場合、カスタムタグによりリクエストパラメータから入力値が復元される。

**初期値の出力**: アクション側でリクエストスコープに初期値を設定したオブジェクトを設定し、カスタムタグのname属性とリクエストスコープ上の変数名が対応するようにname属性を指定する（:ref:`tag-access_rule` を参照）。

**サブミット先のURI指定**: フォームに配置された複数のボタン/リンクから別々のURIにサブミットできる。uri属性にサブミット先URIを指定する（:ref:`tag-specify_uri` を参照）。

**実装例**:
```jsp
<n:form>
  <div>
    <label>ユーザID</label>
    <n:text name="form.userId" />
    <n:error name="form.userId" messageFormat="span" errorCss="alert alert-danger" />
  </div>
  <div>
    <label>パスワード</label>
    <n:password name="form.password" />
    <n:error name="form.password" messageFormat="span" errorCss="alert alert-danger" />
  </div>
  <div style="padding: 8px 0;">
    <n:submit type="submit" uri="/action/login" value="ログイン" />
  </div>
</n:form>
```

> **補足**: :ref:`tag-form_tag` のname属性の制約: (1) 画面内で一意な名前を指定する（JavaScriptでサブミット対象フォームを特定するために使用）。指定しない場合はカスタムタグが一意な値を自動設定する。(2) JavaScriptの変数名の構文に則った値を指定する（先頭は英字始まり、以降は英数字またはアンダーバー）。

## 選択項目(プルダウン/ラジオボタン/チェックボックス)を表示する

選択項目の表示には以下のカスタムタグを使用する。

- :ref:`tag-select_tag` (プルダウン)
- :ref:`tag-radio_buttons_tag` (複数のラジオボタン)
- :ref:`tag-checkboxes_tag` (複数のチェックボックス)

アクション側で選択肢リストをリクエストスコープに設定し、カスタムタグで使用する。

> **補足**: 選択状態の判定は、選択された値と選択肢の値をともに `Object#toString` してから行う。

**選択肢クラスの例**

```java
public class Plan {
    private String planId;   // 選択肢の値
    private String planName; // 選択肢のラベル

    public Plan(String planId, String planName) {
        this.planId = planId;
        this.planName = planName;
    }

    // カスタムタグはgetPlanId()から値を取得する
    public String getPlanId() { return planId; }
    // カスタムタグはgetPlanName()からラベルを取得する
    public String getPlanName() { return planName; }
}
```

**アクションでのリクエストスコープ設定**

```java
List<Plan> plans = Arrays.asList(new Plan("A", "フリー"), new Plan("B", "ベーシック"), new Plan("C", "プレミアム"));
// カスタムタグはここで指定した名前を使ってリクエストスコープから選択肢リストを取得する
context.setRequestScopedVar("plans", plans);
```

**プルダウン (n:select)**

```jsp
<n:select name="form.plan1"
          listName="plans"
          elementLabelProperty="planName"
          elementValueProperty="planId" />
```

| 属性 | 説明 |
|---|---|
| listName | 選択肢リストの名前 |
| elementLabelProperty | ラベルを表すプロパティ名 |
| elementValueProperty | 値を表すプロパティ名 |

出力されるHTML ("form.plan1"の値が"A"の場合):

```html
<select name="form.plan1">
  <option value="A" selected="selected">フリー</option>
  <option value="B">ベーシック</option>
  <option value="C">プレミアム</option>
</select>
```

**ラジオボタン (n:radioButtons)**

```jsp
<n:radioButtons name="form.plan2" listName="plans"
                elementLabelProperty="planName" elementValueProperty="planId" />
```

デフォルトはbrタグで出力。`listFormat` 属性でdiv/span/ul/ol/スペース区切りに変更可能。

出力されるHTML ("form.plan2"の値が"B"の場合。IDは `nablarch_radio1`, `nablarch_radio2`, ... の形式で自動生成):

```html
<input id="nablarch_radio1" type="radio" name="form.plan2" value="A" />
<label for="nablarch_radio1">フリー</label><br />
<input id="nablarch_radio2" type="radio" name="form.plan2" value="B" checked="checked" />
<label for="nablarch_radio2">ベーシック</label><br />
<input id="nablarch_radio3" type="radio" name="form.plan2" value="C" />
<label for="nablarch_radio3">プレミアム</label><br />
```

**チェックボックス (n:checkboxes)**

```jsp
<n:checkboxes name="form.plan4" listName="plans"
              elementLabelProperty="planName" elementValueProperty="planId" />
```

デフォルトはbrタグで出力。`listFormat` 属性でdiv/span/ul/ol/スペース区切りに変更可能。

出力されるHTML ("form.plan4"の値が"C"の場合。IDは `nablarch_checkbox1`, `nablarch_checkbox2`, ... の形式で自動生成):

```html
<input id="nablarch_checkbox1" type="checkbox" name="form.plan4" value="A" checked="checked" />
<label for="nablarch_checkbox1">フリー</label><br />
<input id="nablarch_checkbox2" type="checkbox" name="form.plan4" value="B" />
<label for="nablarch_checkbox2">ベーシック</label><br />
<input id="nablarch_checkbox3" type="checkbox" name="form.plan4" value="C" />
<label for="nablarch_checkbox3">プレミアム</label><br />
```

> **重要**: :ref:`tag-radio_buttons_tag` と :ref:`tag-checkboxes_tag` はカスタムタグで全選択肢を出力するためHTML出力に制限がある。プロジェクトでデザインをコントロールできない場合（デザイン会社作成のHTMLベース開発など）は、JSTLの `c:forEach` タグと :ref:`tag-radio_tag` または :ref:`tag-checkbox_tag` を使って自由にHTMLを実装すること。

```jsp
<c:forEach items="${plans}" var="plan">
  <n:radioButton name="form.plan3" label="${plan.planName}" value="${plan.planId}" />
</c:forEach>
```

## チェックボックスでチェックなしに対する値を指定する

HTMLのcheckboxタグはチェックなしの場合にリクエストパラメータが送信されない。:ref:`tag-checkbox_tag` ではチェックなしに対応する値を指定できる機能を提供する。

```jsp
<n:checkbox name="form.useMail" value="true" label="使用する"
            offLabel="使用しない" offValue="false" />
```

| 属性 | デフォルト | 説明 |
|---|---|---|
| useOffValue | true | チェックなしの値設定を使用するか否か。一括削除など複数選択の場合はfalseを指定 |
| offLabel | | チェックなし時のラベル。入力画面と確認画面を共通化した場合に確認画面で表示 |
| offValue | 0 | チェックなし時の値 |

> **補足**: この機能は :ref:`nablarch_tag_handler` と :ref:`hidden暗号化 <tag-hidden_encryption>` を使って実現している。checkboxタグ出力時にチェックなし値をhiddenタグに出力し、:ref:`nablarch_tag_handler` がリクエスト受付時にチェックされていない場合のみリクエストパラメータにチェックなし値を設定する。

## 入力データを画面間で持ち回る(ウィンドウスコープ)

> **重要**: 画面間での入力データ保持には :ref:`session_store` を使用すること。ウィンドウスコープは以下の理由から非推奨:
>
> 1. データをキー/値のペアで保持するためBeanをそのまま格納できず、データをバラす必要があり実装が煩雑になる
>
>    ```java
>    // こんなBeanがあるとする。
>    Person person = new Person();
>    person.setName("名前");
>    person.setAge("年齢");
>
>    // ウィンドウスコープへの設定(アクションで行う場合)
>    request.setParam("person.name", person.getName());
>    request.setParam("person.age", person.getAge());
>    ```
>
>    ```jsp
>    <%-- ウィンドウスコープへの設定(JSPで行う場合) --%>
>    <n:hidden name="person.name" />
>    <n:hidden name="person.age" />
>    ```
>
> 2. カスタムタグの属性指定でデータ設定を行うため動きが把握しにくく実装難易度が高い

入力データはクライアント側にhiddenタグとして保持する（ウィンドウスコープ）。ウィンドウスコープのデータは :ref:`hidden暗号化<tag-hidden_encryption>` により暗号化される。

> **重要**: ウィンドウスコープのデータはhiddenタグに暗号化して出力されるため、Ajax等でクライアント側からウィンドウスコープの内容を書き換えることはできない。

ウィンドウスコープへのデータ設定には :ref:`tag-form_tag` の `windowScopePrefixes` 属性を使用する。

> **重要**: `windowScopePrefixes` はパラメータ名の**前方一致**でウィンドウスコープに設定する。例えば `windowScopePrefixes="user"` と指定すると `users` で始まるパラメータもウィンドウスコープに設定される。

**画面ごとの設定例** (検索条件: `searchCondition.*`、入力データ: `user.*`)

![ウィンドウスコープの画面遷移とデータの流れ](../../knowledge/component/libraries/assets/libraries-tag/window_scope.png)

```jsp
<!-- 検索画面: ウィンドウスコープデータを送信しない -->
<n:form>

<!-- 更新画面: 検索条件だけ送信 -->
<n:form windowScopePrefixes="searchCondition">

<!-- 更新確認画面: 検索条件と入力データを送信（カンマ区切りで複数指定） -->
<n:form windowScopePrefixes="searchCondition,user">

<!-- 更新完了画面: 検索条件だけ送信 -->
<n:form windowScopePrefixes="searchCondition">
```

> **重要**: データベースのデータは主キーや楽観ロック用データなど必要最低限に留めること。表示用データ（入力項目ではなく表示するだけの項目）はhiddenで引き回さずデータが必要になる度にDBから取得すること。hiddenのデータ量増加は通信速度低下・メモリ圧迫につながる。

> **重要**: ウィンドウスコープに格納したデータをアクション側で使用する場合は :ref:`バリデーション<validation>` を行うこと（リクエストパラメータとして持ち回っているため）。

> **補足**: :ref:`tag-form_tag` では、既に入力項目として出力したリクエストパラメータを :ref:`tag-hidden_tag` の出力から除外する。

> **補足**: ログイン情報など全業務に渡って必要な情報はサーバ側（セッション）に保持すること。

## クライアントに保持するデータを暗号化する(hidden暗号化)

:ref:`ウィンドウスコープ<tag-window_scope>` や :ref:`tag-hidden_tag` の値はクライアント側で改竄・参照される可能性があるため、hidden暗号化機能を提供する。デフォルトで全 :ref:`tag-form_tag` で暗号化、全リクエストで復号・改竄チェックを行う。

> **重要**: 仕様が複雑で使用が容易でなく、またウィンドウスコープの使用が非推奨であるため本機能も非推奨。特に理由がない限り :ref:`useHiddenEncryption <tag-use_hidden_encryption>` には `false` を設定すること。

**hidden暗号化の処理フロー**

![hidden暗号化の処理イメージ](../../knowledge/component/libraries/assets/libraries-tag/hidden_encryption.png)

:ref:`tag-form_tag` が暗号化、:ref:`nablarch_tag_handler` が復号および改竄チェックを行う。

**暗号化処理**

**インタフェース**: `nablarch.common.encryption.Encryptor`

デフォルトアルゴリズム: `AES(128bit)`。変更する場合は `Encryptor` を実装したクラスをコンポーネント定義に `hiddenEncryptor` という名前で登録する。

暗号化対象（フォームごとにまとめて1つのhiddenタグで出力）:
- :ref:`tag-hidden_tag` で明示的に指定したhiddenパラメータ
- :ref:`ウィンドウスコープ<tag-window_scope>` の値
- :ref:`サブミットを行うカスタムタグ <tag_reference_submit>` で指定したリクエストID
- :ref:`サブミットを行うカスタムタグ <tag_reference_submit>` で追加したパラメータ

改竄検知のためハッシュ値を含め、BASE64でエンコードしてhiddenタグに出力する。リクエストIDは異なるフォーム間の暗号化値入れ替えによる改竄検知に、ハッシュ値は値の書き換えによる改竄検知に使用する。

> **補足**: :ref:`tag-hidden_tag` で指定したhiddenパラメータは暗号化されるためJavaScriptから操作できない。クライアント側のJavaScriptでhiddenパラメータを操作したい場合は :ref:`tag-plain_hidden_tag` を使用すること。

**復号処理**

:ref:`nablarch_tag_handler` が以下の場合に改竄と判定し設定された画面に遷移させる:
- 暗号化したhiddenパラメータ（nablarch_hidden）が存在しない
- BASE64のデコードに失敗
- 復号に失敗
- 暗号化時のハッシュ値と復号後のハッシュ値が不一致
- 暗号化時のリクエストIDと受け付けたリクエストIDが不一致

**暗号化キー**

セッション毎に生成するため、同一ユーザでも再ログイン後はログイン前の画面から処理を継続できない。

**設定プロパティ** (:ref:`tag-setting` で設定)

| プロパティ名 | デフォルト | 説明 |
|---|---|---|
| useHiddenEncryption | true | hidden暗号化を使用するか否か |
| noHiddenEncryptionRequestIds | | hidden暗号化を行わないリクエストID |

`noHiddenEncryptionRequestIds` に指定するリクエスト:
- ログイン画面などアプリケーションの入口となるリクエスト
- ブックマークから遷移してくるリクエスト
- 外部サイトから遷移してくるリクエスト

:ref:`tag-form_tag`: 暗号化対象のリクエストIDが1つでも含まれていれば暗号化する（1つも含まれない場合は暗号化しない）。

:ref:`nablarch_tag_handler`: リクエストされたリクエストIDが暗号化対象の場合のみ復号する。

## 複合キーのラジオボタンやチェックボックスを作る

> **重要**: `CompositeKeyConvertor` と `CompositeKeyArrayConvertor` をコンポーネント定義に追加しておく必要がある。設定方法は :ref:`nablarch_validation-definition_validator_convertor` を参照。

> **重要**: この機能は :ref:`nablarch_validation` でのみ使用できる。:ref:`bean_validation` は対応していない。

複合キー対応のカスタムタグ:
- :ref:`tag-composite_key_radio_button_tag`（ラジオボタン）
- :ref:`tag-composite_key_checkbox_tag`（チェックボックス）

フォームのプロパティは **クラス**: `nablarch.common.web.compositekey.CompositeKey` で定義する。複数データの場合は配列として定義する。

**アノテーション**: `@CompositeKeyType(keySize = N)` セッターメソッドに付与して複合キーのサイズを指定する。

`<n:compositeKeyCheckbox>` の属性:
- `name`: フォームのプロパティ名
- `valueObject`: 複合キーの値を持つオブジェクト
- `keyNames`: valueObjectから複合キーの値を取得するプロパティ名（カンマ区切り、指定順でCompositeKeyに設定）
- `namePrefix`: リクエストパラメータ展開時のプレフィクス。`name` 属性と異なる値を指定する必要がある

```java
public class OrderItemsForm {
    public CompositeKey[] orderItems;

    @CompositeKeyType(keySize = 2)
    public void setOrderItems(CompositeKey[] orderItems) {
        this.orderItems = orderItems;
    }
}
```

```jsp
<n:compositeKeyCheckbox
  name="form.orderItems"
  label=""
  valueObject="${orderItem}"
  keyNames="orderId,productId"
  namePrefix="orderItems" />
```

## 複数のボタン/リンクからフォームをサブミットする

フォームのサブミット用カスタムタグ:

| 種別 | タグ |
|---|---|
| サブミット（inputボタン） | :ref:`tag-submit_tag` |
| サブミット（buttonタグ） | :ref:`tag-button_tag` |
| サブミット（リンク） | :ref:`tag-submit_link_tag` |
| ポップアップ（inputボタン） | :ref:`tag-popup_submit_tag` |
| ポップアップ（buttonタグ） | :ref:`tag-popup_button_tag` |
| ポップアップ（リンク） | :ref:`tag-popup_link_tag` |
| ダウンロード（inputボタン） | :ref:`tag-download_submit_tag` |
| ダウンロード（buttonタグ） | :ref:`tag-download_button_tag` |
| ダウンロード（リンク） | :ref:`tag-download_link_tag` |

- `popup` 始まりのタグ: 新しいウィンドウをオープンしてサブミット（詳細: :ref:`tag-submit_popup`）
- `download` 始まりのタグ: ダウンロード用サブミット（詳細: :ref:`tag-submit_download`）
- `name` 属性: フォーム内で一意な名前を指定。未指定の場合はカスタムタグが自動で一意な名前を出力する
- `uri` 属性の指定方法: :ref:`tag-specify_uri` を参照

```jsp
<!-- name属性は自動で出力されるので指定しなくてよい。 -->
<n:submit type="submit" uri="login" value="ログイン" />
```

## サブミット前に処理を追加する

フォームのサブミットはJavaScriptでボタン/リンクのURIを組み立てて実現している。カスタムタグは**グローバル領域**にJavaScript関数を出力し、ボタン/リンクの `onclick` 属性にその関数呼び出しを設定した状態でHTMLを出力する。

カスタムタグが出力するJavaScript関数シグネチャ:

```javascript
/**
 * @param event イベントオブジェクト
 * @param element イベント元の要素（ボタン又はリンク）。未指定の場合はeventからcurrentTarget/targetプロパティの優先順位で取得
 * @return 常にfalse
 */
function nablarch_submit(event, element)
```

`onclick` 属性にアプリケーション側のJavaScript関数を指定した場合、カスタムタグはサブミット用のJavaScript関数を呼び出さない。この場合、アプリケーション側のJavaScriptで `nablarch_submit(event, element)` を明示的に呼び出す必要がある。

> **重要**: Content Security Policy（CSP）対応時は、`onclick` 属性にインラインJavaScriptを記述すると `unsafe-inline` または `unsafe-hashes` が必要になりセキュリティレベルが低下する。:ref:`tag-content_security_policy` の手順に従い外部スクリプトまたは `nonce` 属性を指定したscript要素に処理を実装することを推奨する。

サブミット前に確認ダイアログを表示する実装例:

```javascript
function popUpConfirmation(event, element) {
  if (window.confirm("登録します。よろしいですか？")) {
    return nablarch_submit(event, element);
  } else {
    return false;
  }
}
```

```jsp
<n:submit type="submit" uri="register" value="登録"
          onclick="return popUpConfirmation(event, this);" />
```

## プルダウン変更などの画面操作でサブミットする

サブミット制御のJavaScript関数はボタン/リンクの `onclick` 属性に設定されることを前提に動作する（詳細: :ref:`tag-onclick_override`）。プルダウン変更などの画面操作でサブミットを行いたい場合は、サブミットさせたいボタンのクリックイベントを発生させる。

> **重要**: CSP対応時は、`onchange` 属性等にインラインJavaScriptを記述すると `unsafe-inline` または `unsafe-hashes` が必要になる。:ref:`tag-content_security_policy` の手順に従い外部スクリプトまたは `nonce` 属性を指定したscript要素に処理を実装することを推奨する。

```jsp
<!-- onchange属性にて、サブミットしたいボタン要素のclick関数を呼ぶ。 -->
<n:select name="form.plan"
          listName="plans"
          elementLabelProperty="planName"
          elementValueProperty="planId"
          onchange="window.document.getElementById('register').click(); return false;" />

<n:submit id="register" type="submit" uri="register" value="登録" />
```

> **重要**: 上記の実装例では `onchange` イベントハンドラに直接JavaScriptを記載しているが、実際のプロジェクトでは、オープンソースのJavaScriptライブラリを使うなどして、処理を動的にバインドすることを推奨する。

## ボタン/リンク毎にパラメータを追加する

:ref:`tag-param_tag` を使用して、フォームのボタン/リンク毎にサブミット時のパラメータを追加できる。

> **重要**: パラメータを追加する場合はその数に応じてリクエストのデータ量が増大する。一覧画面で詳細画面へのリンク毎にパラメータを追加する場合は、プライマリキーだけにするなど必要最小限のパラメータのみ追加すること。

```jsp
<n:form>
  <table>
    <c:forEach var="person" items="${persons}">
      <tr>
        <td>
          <n:submitLink uri="/action/person/show">
            <n:write name="person.personName" />
            <!-- パラメータ名に"personId"を指定している。 -->
            <n:param paramName="personId" name="person.personId" />
          </n:submitLink>
        </td>
      </tr>
    </c:forEach>
  </table>
</n:form>
```

## 認可チェック/サービス提供可否に応じてボタン/リンクの表示/非表示を切り替える

:ref:`permission_check` と :ref:`service_availability` の結果に応じて、フォームのサブミット用ボタン/リンク（:ref:`tag_reference_submit`）の表示を切り替える機能。指定されたリクエストIDに対して `権限なし` または `サービス提供不可` の場合に表示切り替えを行う。

切り替えパターン（3種類）:
- **非表示（NODISPLAY）**: タグを出力しない
- **非活性（DISABLED）**: ボタンは `disabled` 属性を有効化。リンクはラベルのみ表示、またはJSPインクルード（`submitLinkDisabledJspプロパティ` で設定）
- **通常表示（NORMAL）**: 通常どおりタグを出力

デフォルトは `通常表示`。:ref:`tag-setting` の `displayMethodプロパティ` でデフォルトを変更可能。個別に変更する場合はタグの `displayMethod` 属性に指定する。

```jsp
<!--
  NODISPLAY（非表示）、DISABLED（非活性）、NORMAL（通常表示）のいずれかを指定する。
  このタグは常に表示する。
-->
<n:submit type="button" uri="login" value="ログイン" displayMethod="NORMAL" />
```

表示制御の判定処理を変更したい場合は :ref:`tag-submit_display_control_change` を参照。

## 別ウィンドウ/タブを開くボタン/リンクを作る(ポップアップ)

> **重要**: これらのタグ(:ref:`tag-popup_submit_tag`、:ref:`tag-popup_button_tag`、:ref:`tag-popup_link_tag`)は非推奨。以下の問題があるため使用しないこと:
> 1. 外部サイトへのリンク/ボタンで一部ブラウザ(例: IEの保護モード有効時)が新しいウィンドウで開けない。回避策として :ref:`tag-a_tag` やHTMLタグを使用する。
> 2. サブウィンドウを用いた画面遷移は時代遅れ。ページ内ポップアップをオープンソースライブラリで実装する方式が一般的。

通常サブミットタグとの違い:
- 新しいウィンドウをオープンし、そのウィンドウに対してサブミットを行う
- 入力項目のパラメータ名を変更できる

利用可能なカスタムタグ:
- :ref:`tag-popup_submit_tag` (inputタグのボタン)
- :ref:`tag-popup_button_tag` (buttonタグのボタン)
- :ref:`tag-popup_link_tag` (リンク)

ポップアップは `window.open` 関数で実現する。

**実装例** (スタイル指定でウィンドウを開く検索ボタン):
```jsp
<n:popupButton uri="/action/person/list"
               popupWindowName="postalCodeSupport"
               popupOption="width=400, height=300, menubar=no, toolbar=no, scrollbars=yes">
  検索
</n:popupButton>
```

`popupWindowName` 属性が未指定の場合、:ref:`tag-setting` の `popupWindowNameプロパティ` のデフォルト値を使用する。デフォルト値も未設定の場合はJavaScriptのDate関数から取得した現在時刻(ミリ秒)をウィンドウ名に使用する。

デフォルト値の指定有無によるウィンドウ動作:
- **デフォルト値あり**: 常に同じウィンドウ名 → ウィンドウは1つ
- **デフォルト値なし**: 常に異なるウィンドウ名 → 常に新しいウィンドウをオープン

**パラメータ名変更** (:ref:`tag-submit_change_param_name`):

ポップアップタグは元画面フォームの全input要素を動的に追加してサブミットする。元画面とポップアップウィンドウでパラメータ名が一致するとは限らないため、:ref:`tag-change_param_name_tag` でパラメータ名を変更する。

**実装例** (郵便番号検索):
```jsp
<n:form>
  <div>
    <label>郵便番号</label>
    <n:text name="form.postalCode" />
    <n:popupButton uri="/action/postalCode/show">
      検索
      <n:changeParamName inputName="form.postalCode" paramName="condition.postalCode" />
      <n:param paramName="condition.max" value="10" />
    </n:popupButton>
  </div>
</n:form>
```

**オープンしたウィンドウへのアクセス** (:ref:`tag-submit_access_open_window`):

カスタムタグはオープンしたウィンドウへの参照をJavaScriptのグローバル変数 `nablarch_opened_windows` に保持する。

```javascript
// keyはウィンドウ名
var nablarch_opened_windows = {};
```

元画面遷移時に不要なウィンドウを全て閉じる実装例:
```javascript
onunload = function() {
  for (var key in nablarch_opened_windows) {
    var openedWindow = nablarch_opened_windows[key];
    if (openedWindow && !openedWindow.closed) {
      openedWindow.close();
    }
  }
  return true;
};
```

## ファイルをダウンロードするボタン/リンクを作る

> **重要**: カスタムタグはフォームのサブミット制御にJavaScriptを使用するため、通常のサブミットタグ(:ref:`tag-submit_tag` など)でダウンロードすると同じフォーム内の他のサブミットが機能しなくなる。ダウンロードボタン/リンクには必ずダウンロードタグを使用すること。

ダウンロードタグと通常サブミットタグの違い:
- 新しいフォームを作成し、そのフォームに対してサブミットを行う
- 入力項目のパラメータ名を変更できる

利用可能なカスタムタグ:
- :ref:`tag-download_submit_tag` (inputタグのボタン)
- :ref:`tag-download_button_tag` (buttonタグのボタン)
- :ref:`tag-download_link_tag` (リンク)

ダウンロードユーティリティ:
- **クラス**: `nablarch.common.web.download.StreamResponse` — ストリームからHTTPレスポンスを生成。`java.io.File` または `java.sql.Blob` のダウンロードをサポート。
- **クラス**: `nablarch.common.web.download.DataRecordResponse` — データレコードからHTTPレスポンスを生成。:ref:`data_format` でフォーマット。`Map<String, ?>` 型データ(`nablarch.core.db.statement.SqlRow` など)をサポート。

パラメータ名変更には :ref:`tag-change_param_name_tag` を使用する(使い方は :ref:`ポップアップ時のパラメータ名変更 <tag-submit_change_param_name>` と同じ)。

**ファイル(File)のダウンロード実装例**:

JSP:
```jsp
<n:downloadButton uri="/action/download/tempFile">ダウンロード</n:downloadButton>
```

アクション:
```java
// コンストラクタ引数にダウンロード対象のファイルと
// リクエスト処理の終了時にファイルを削除する場合はtrue、削除しない場合はfalseを指定する。
// ファイルの削除はフレームワークが行う。
// 通常ダウンロード用のファイルはダウンロード後に不要となるためtrueを指定する。
StreamResponse response = new StreamResponse(file, true);
response.setContentType("application/pdf");
response.setContentDisposition(file.getName());
return response;
```

**BLOB型カラムのダウンロード実装例**:

テーブルの行データ毎にリンクを表示し、選択されたリンクに対応するデータをダウンロードする。

JSP:
```jsp
<!--
  recordsという名前で行データのリストが
  リクエストスコープに設定されているものとする。
-->
<c:forEach var="record" items="${records}" varStatus="status">
  <n:set var="fileId" name="record.fileId" />
  <div>
    <!-- downloadLinkタグを使用してリンクを作成する。 -->
    <n:downloadLink uri="/action/download/tempFile">
      <n:write name="record.fileName" />(<n:write name="fileId" />)
      <!-- 選択されたリンクを判別するためにfileIdパラメータをparamタグで設定する。 -->
      <n:param paramName="fileId" name="fileId" />
    </n:downloadLink>
  </div>
</c:forEach>
```

アクション:
```java
StreamResponse response = new StreamResponse((Blob) record.get("FILE_DATA"));
response.setContentType("image/jpeg");
response.setContentDisposition(record.getString("FILE_NAME"));
return response;
```

**データレコードのダウンロード実装例** (CSVフォーマット):

フォーマット定義 (`N11AA001.fmt`):
```
file-type:        "Variable"
text-encoding:    "Shift_JIS" # 文字列型フィールドの文字エンコーディング
record-separator: "\n"        # レコード区切り文字
field-separator:  ","         # フィールド区切り文字

[header]
1   messageId    N "メッセージID"
2   lang         N "言語"
3   message      N "メッセージ"

[data]
1   messageId    X # メッセージID
2   lang         X # 言語
3   message      N # メッセージ
```

JSP:
```jsp
<n:downloadSubmit type="button" uri="/action/download/tempFile" value="ダウンロード" />
```

アクション:
```java
SqlResultSet records = getRecords(request);
DataRecordResponse response = new DataRecordResponse("format", "N11AA001"); // (ベースパス論理名, フォーマット定義ファイル名)
response.write("header", Collections.<String, Object>emptyMap()); // デフォルトヘッダ情報を使用
for (SqlRow record : records) {
    response.write("data", record);
}
response.setContentType("text/csv; charset=Shift_JIS");
response.setContentDisposition("メッセージ一覧.csv");
return response;
```

## 二重サブミットを防ぐ

二重サブミット防止は、DBコミットを伴う処理画面で使用する。クライアント側とサーバ側の2つを**併用する**必要がある。

> **重要**: どちらか一方のみ使用した場合の懸念: クライアント側のみの場合はリクエストを重複処理する恐れがある。サーバ側のみの場合はダブルクリックで2回リクエストが送信されると処理順によっては二重サブミットエラーが返されユーザに処理結果が返されない恐れがある。

## クライアント側の二重サブミット防止

JavaScriptを使用。1回目のサブミット時にonclick属性を書き換え、2回目以降のリクエストをサーバ側に送信しない。ボタンの場合はdisabled属性も設定。

対応カスタムタグ:
- フォームのサブミット: :ref:`tag-submit_tag`、:ref:`tag-button_tag`、:ref:`tag-submit_link_tag`
- ダウンロード用: :ref:`tag-download_submit_tag`、:ref:`tag-download_button_tag`、:ref:`tag-download_link_tag`

`allowDoubleSubmission="false"` を指定することで特定のボタン/リンクのみ防止できる。デフォルトは `true`。

```jsp
<n:submit type="button" name="back" value="戻る" uri="./back" />
<n:submit type="button" name="register" value="登録" uri="./register"
          allowDoubleSubmission="false" />
```

> **補足**: サブミット後にサーバからレスポンスが返ってこない間にブラウザの中止ボタンを押した場合、ボタンはdisabledのままになる。その場合、サブミットに使用したボタン以外のボタンまたはリンクで処理を継続できる。

> **補足**: 二重サブミット発生時の振る舞いを追加したい場合は :ref:`tag-double_submission_client_side_change` を参照。

## サーバ側の二重サブミット防止

サーバ側で発行した一意なトークンをサーバ側(セッション)とクライアント側(hiddenタグ)に保持し突合することで実現。トークンは**1回のチェックに限り有効**。

**JSPでトークンの設定** (:ref:`tag-form_tag` の `useToken` 属性):
- デフォルトは `false`
- 入力画面と確認画面を共通化した場合、確認画面ではデフォルトが `true`（共通化時は指定不要）

```jsp
<n:form useToken="true">
```

**アクションでトークンの設定**: JSP以外のテンプレートエンジン採用時は :ref:`use_token_interceptor` を使用。

**トークンのチェック**: :ref:`on_double_submission_interceptor` を使用。

**セッションスコープのキー変更** (デフォルト: `/nablarch_session_token`):
```xml
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <property name="doubleSubmissionTokenSessionAttributeName" value="sessionToken" />
</component>
```

**リクエストスコープのキー変更** (デフォルト: `nablarch_request_token`):
```xml
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <property name="doubleSubmissionTokenRequestAttributeName" value="requestToken" />
</component>
```

**hiddenのname属性変更** (デフォルト: `nablarch_token`):
```xml
<component name="webConfig" class="nablarch.common.web.WebConfig">
  <property name="doubleSubmissionTokenParameterName" value="hiddenToken" />
</component>
```

> **重要**: サーバ側の二重サブミット防止では、トークンをセッションに格納するため、同一ユーザの複数リクエストに対して別々にトークンをチェックできない。サーバ側の二重サブミットを防止する画面遷移（登録確認→登録完了、更新確認→更新完了など）を複数ウィンドウや複数タブで並行して行うことができない。後に確認画面に遷移した画面のみ処理を継続でき、先に遷移した画面はトークンが古いため二重サブミットエラーとなる。

> **補足**: トークン発行は `UUIDV4TokenGenerator` が行い、36文字のランダム文字列を生成する。変更する場合は :ref:`tag-double_submission_server_side_change` を参照。

## サーバ側のトークンをデータベースに保存する

デフォルト実装ではサーバ側のトークンはHTTPセッションに保存される。アプリケーションサーバをスケールアウトする際には、スティッキーセッションやセッションレプリケーション等を使用する必要がある。

サーバ側のトークンをデータベースに保管する実装を使用することで、アプリケーションサーバの設定なしに複数のアプリケーションサーバ間でトークンを共有できる。詳細は :ref:`db_double_submit` を参照。

![サーバ側トークンをデータベースに保存する構成図](../../knowledge/component/libraries/assets/libraries-tag/db-double-submit.png)

## 入力画面と確認画面を共通化する

入力項目のカスタムタグは、入力画面と全く同じJSP記述のまま確認画面用を出力できる。

使用カスタムタグ:
- :ref:`tag-confirmation_page_tag`: 確認画面のJSPで入力画面のJSPへのパスを指定して共通化を行う
- :ref:`tag-for_input_page_tag`: 入力画面でのみ表示したい部分を指定
- :ref:`tag-for_confirmation_page_tag`: 確認画面でのみ表示したい部分を指定
- :ref:`tag-ignore_confirmation_tag`: 確認画面で確認画面向けの表示を無効化したい部分に指定（例: チェックボックスをチェック欄のまま表示したい場合）

> **補足**: 以下のタグは入力・確認画面の表示制御対象外で、両画面ともに出力される:
> - :ref:`tag-plain_hidden_tag`: 画面遷移の状態などを画面間で受け渡す目的で使用
> - :ref:`tag-hidden_store_tag`: :ref:`session_store` に保存したデータを画面間で受け渡すために使用

**入力画面のJSP例:**
```jsp
<n:form>
  <div>
    <label>名前</label>
    <n:text name="form.name" />
  </div>
  <div>
    <label>メール</label>
    <n:checkbox name="form.useMail" label="使用する" offLabel="使用しない" />
  </div>
  <div>
    <label>プラン</label>
    <n:select name="form.plan"
              listName="plans"
              elementLabelProperty="planName"
              elementValueProperty="planId" />
  </div>
  <div style="padding: 8px 0;">
    <n:forInputPage>
      <n:submit type="submit" uri="/action/sample/confirm" value="確認" />
    </n:forInputPage>
    <n:forConfirmationPage>
      <n:submit type="submit" uri="/action/sample/showNew" value="戻る" />
      <n:submit type="submit" uri="/action/sample/register" value="登録" />
    </n:forConfirmationPage>
  </div>
</n:form>
```

**確認画面のJSP例:**
```jsp
<n:confirmationPage path="./input.jsp" />
```

![入力・確認画面の表示例](../../knowledge/component/libraries/assets/libraries-tag/make_common_input_confirm.png)

## 変数に値を設定する

:ref:`tag-set_tag` を使用してJSP上の変数に値を設定できる。画面タイトルなどページ内の複数箇所に同じ内容を出力する場合に使用する。

```jsp
<n:set var="title" value="ユーザ情報登録" />
<head>
  <title><n:write name="title" /></title>
</head>
<body>
  <h1><n:write name="title" /></h1>
</body>
```

> **重要**: :ref:`tag-set_tag` ではHTMLエスケープ処理を実施しないため、変数を出力する際は必ず :ref:`tag-write_tag` を使用すること。

**スコープ指定** (`scope`属性):
- `request`: リクエストスコープ（デフォルト、scope属性指定なしの場合）
- `page`: ページスコープ（アプリケーション全体で使用されるUI部品を作成する場合に他JSPの変数とのバッティングを防ぎたい場合に使用）

**配列・コレクションの設定**: `name`属性が指定された場合、デフォルト（`bySingleValue=true`）では配列/コレクションの先頭要素を返す。配列やコレクションをそのまま取得したい場合は `bySingleValue="false"` を指定する。

## GETリクエストを使用する

検索エンジン等のクローラ対策、および利用者がブックマーク可能なURLとするために、GETリクエストの使用が必要となる場合がある。

カスタムタグは :ref:`hidden暗号化<tag-hidden_encryption>` や :ref:`パラメータ追加<tag-submit_change_parameter>` といった機能を実現するためにhiddenパラメータを出力して使用している。そのため、:ref:`tag-form_tag` を使用してGETリクエストを行おうとすると、業務機能として必要なパラメータに加えて、このhiddenパラメータがURLに付与されてしまう。その結果、不要なパラメータが付くことに加えて、URLの長さ制限により正しくリクエストできない可能性がある。

:ref:`tag-form_tag` でGETが指定された場合、hiddenパラメータを出力しない。これにより以下の制約が発生する。

## 使用制限のあるカスタムタグ

以下のタグは :ref:`hidden暗号化<tag-hidden_encryption>` を使用しているため、GETリクエストではチェックなし判定機能が使用できない。

- :ref:`tag-checkbox_tag`
- :ref:`tag-code_checkbox_tag`

対応方法: :ref:`バリデーション <validation>` 後に該当項目をnull判定し、アクション側でチェックなしの値を設定する。

## 使用不可となるカスタムタグと代替手段

**hiddenタグ** → :ref:`tag-plain_hidden_tag` を使用する。

```jsp
<%-- GETの場合 --%>
<n:plainHidden name="test" />
```

**submitタグ** → HTMLのinput(type="submit")を使用。サブミット先URIは :ref:`tag-form_tag` のaction属性に指定する。

```jsp
<%-- GETの場合 --%>
<n:form method="GET" action="search">
  <input type="submit" value="検索" />
</n:form>
```

**buttonタグ** → HTMLのbutton(type="submit")を使用。サブミット先URIは :ref:`tag-form_tag` のaction属性に指定する。

```jsp
<%-- GETの場合 --%>
<n:form method="GET" action="search">
  <button type="submit" value="検索" />
</n:form>
```

**submitLinkタグ** → :ref:`tag-a_tag` を使用し、onclick属性に画面遷移JavaScript関数を指定。関数は :ref:`tag-script_tag` 内に記述する。

```jsp
<%-- GETの場合 --%>
<input type="text" name="test" id="test" />
<n:a href="javascript:void(0);" onclick="searchTest();">検索</n:a>
<n:script type="text/javascript">
  var searchTest = function() {
    var test = document.getElementById('test').value;
    location.href = 'search?test=' + test;
  }
</n:script>
```

**popupSubmitタグ** → HTMLのinput(type="button")を使用し、onclick属性にwindow.open()を指定する。

```jsp
<%-- GETの場合 --%>
<n:form method="GET">
  <input type="button" value="検索"
    onclick="window.open('search', 'popupWindow', 'width=700,height=500')" />
</n:form>
```

**popupButtonタグ** → HTMLのbutton(type="button")を使用し、onclick属性にwindow.open()を指定する。

```jsp
<%-- GETの場合 --%>
<n:form method="GET">
  <button type="button" value="検索"
    onclick="window.open('search', 'popupWindow', 'width=700,height=500')" />
</n:form>
```

**popupLinkタグ** → :ref:`tag-a_tag` を使用し、onclick属性にポップアップ表示JavaScript関数を指定。関数は :ref:`tag-script_tag` 内に記述する。

```jsp
<%-- GETの場合 --%>
<input type="text" name="test" id="test" />
<n:a href="javascript:void(0);" onclick="openTest();" >検索</n:a>
<n:script type="text/javascript">
  var openTest = function() {
    var test = document.getElementById('test').value;
    window.open('search?test=' + test, 'popupWindow', 'width=700,height=500')
  }
</n:script>
```

**paramタグ** → ボタン/リンクごとに :ref:`tag-form_tag` を個別に記述し、各form内にパラメータを設定する。

```jsp
<%-- GETの場合 --%>
<n:form method="GET" action="search">
  <n:set var="test" value="テスト１" />
  <input type="hidden" name="changeParam" value="<n:write name='test' />" />
  <input type="submit" value="検索" />
</n:form>

<n:form method="GET" action="search">
  <n:set var="test" value="テスト２" />
  <input type="hidden" name="changeParam" value="<n:write name='test' />" />
  <input type="submit" value="検索" />
</n:form>
```

**changeParamNameタグ** → 基本的な対応方法は :ref:`popupLinkタグ <tag-using_get_popup_link_tag>` と同じ。window.open()の第一引数でクエリ文字列のキーを変更したいパラメータ名を指定する。

```jsp
<%-- GETの場合 --%>
<input type="text" name="test" id="test" />
<input type="button" value="検索" onclick="openTest();" />
<n:script type="text/javascript">
  var openTest = function() {
    var test = document.getElementById('test').value;
    window.open('search?changeParam=' + test, 'popupWindow', 'width=700,height=500');
  }
</n:script>
```

## 値を出力する

値の出力には :ref:`tag-write_tag` を使用する。アクション側でリクエストスコープに設定したオブジェクトに、name属性を指定してアクセスする。name属性の指定方法は :ref:`tag-access_rule` を参照。

```java
// リクエストスコープに"person"という名前でオブジェクトを設定する。
Person person = new Person();
person.setPersonName("名前");
context.setRequestScopedVar("person", person);
```

```jsp
<!-- name属性を指定してオブジェクトのpersonNameプロパティにアクセスする。 -->
<n:write name="person.personName" />
```

## HTMLエスケープせずに値を出力する

:ref:`tag-write_tag` でHTMLエスケープせずに変数内のHTMLタグを直接出力したい場合は以下のタグを使用する。これらのタグは、システム管理者がメンテナンス情報を設定できるようなシステムで、特定の画面や表示領域のみで使用することを想定している。

- :ref:`tag-pretty_print_tag` (prettyPrintタグ): 装飾系HTMLタグをエスケープせずに出力。使用可能タグ/属性は :ref:`tag-setting` の `safeTagsプロパティ` / `safeAttributesプロパティ` で設定可能。
- :ref:`tag-raw_write_tag` (rawWriteタグ): 変数の内容をエスケープせずそのまま出力。

> **重要**: :ref:`tag-pretty_print_tag` は非推奨。理由: (1) 使用可能タグだけでなく属性も全て `CustomTagConfig` に設定する必要がある（例: `a`タグを使用可能にするには `CustomTagConfig#safeTags` に `a` を追加するだけでなく `CustomTagConfig#safeAttributes` にも `href` 等の属性を全定義する必要がある）。(2) 入力文字列がHTMLとして正しいかをチェックしない。代替手段: OSSのHTMLパーサで入力値をバリデーション後、:ref:`rawWriteタグ <tag-html_unescape_raw_write_tag>` で出力する。または利用者にMarkdown入力させてJavaScriptライブラリでHTML変換する方法もある。

> **重要**: :ref:`tag-pretty_print_tag` で不特定ユーザが任意に設定できる変数を出力する場合、XSS脆弱性の要因となる。`<script>`タグやonclick属性を使用可能にしないこと。

> **重要**: :ref:`tag-raw_write_tag` で不特定ユーザが任意に設定できる変数を出力する場合、XSS脆弱性の直接の要因となる。使用には十分な考慮が必要。

## フォーマットして値を出力する

カスタムタグで値をフォーマットして出力する方法は2種類ある。

**推奨: :ref:`format` を使用する方法**。理由:
- :ref:`format` はファイル出力・メッセージングなど他の出力機能と共通部品を使用するため設定が1箇所に集約でき、使用できるタグに制限がない
- valueFormat属性はカスタムタグ独自実装でタグが :ref:`tag-write_tag` と :ref:`tag-text_tag` に限定され、他の出力機能でフォーマットしたい場合は別途設定が必要となり管理が煩雑になる

## :ref:`format` を使用する方法

EL式内で `n:formatByDefault`（デフォルトパターン）または `n:format`（指定パターン）を使用して :ref:`format` の `FormatterUtil` を呼び出す。

```html
<!-- デフォルトパターンでフォーマット: 第一引数にフォーマッタ名、第二引数に値 -->
<n:write value="${n:formatByDefault('dateTime', project.StartDate)}" />

<!-- 指定パターンでフォーマット: 第三引数にパターン -->
<n:text name="project.StartDate" value="${n:format('dateTime', project.StartDate, 'yyyy年MM月dd日')}" />
```

> **重要**: EL式ではリクエストパラメータを参照できない。:ref:`bean_validation` でウェブアプリケーションのユーザ入力値チェックを行う場合は :ref:`bean_validation_onerror` の設定を行うこと。設定が使用できない場合は `n:set` でリクエストパラメータから取り出しページスコープにセットしてから出力すること。

```jsp
<n:set var="projectEndDate" name="form.projectEndDate" scope="page" />
<n:text name="form.projectEndDate" nameAlias="form.date"
  value="${n:formatByDefault('dateTime', projectEndDate)}"
  cssClass="form-control datepicker" errorCss="input-error" />
```

## valueFormat属性を使用する方法

`データタイプ{パターン}` 形式で指定する。使用できるタグは :ref:`tag-write_tag` と :ref:`tag-text_tag` のみ。

### yyyymmdd（年月日）

値はyyyyMMdd形式またはパターン形式の文字列。`SimpleDateFormat` 構文を使用（y/M/dのみ指定可能）。省略時は :ref:`tag-setting` の `yyyymmddPattern` プロパティのデフォルトパターンを使用。`|` 区切りでロケール指定可能。ロケール未指定時は `ThreadContext` の言語を使用（ThreadContext未設定時はシステムデフォルトロケール）。

```properties
valueFormat="yyyymmdd"                      # デフォルトパターン＋ThreadContextロケール
valueFormat="yyyymmdd{yyyy/MM/dd}"          # 明示パターン＋ThreadContextロケール
valueFormat="yyyymmdd{|ja}"                 # デフォルトパターン＋明示ロケール
valueFormat="yyyymmdd{yyyy年MM月dd日|ja}"  # 明示パターン＋明示ロケール
```

> **重要**: :ref:`tag-text_tag` のvalueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。入力された年月日をアクションで取得する場合は :ref:`ウィンドウスコープ <tag-window_scope>` および `YYYYMMDDConvertor` を使用すること。:ref:`bean_validation` は :ref:`tag-text_tag` のvalueFormat属性に対応していない。

> **重要**: :ref:`ウィンドウスコープ <tag-window_scope>` を使用しない場合、valueFormat属性の値がサーバサイドに送信されずバリデーションエラーが発生する。その場合は `YYYYMMDD` アノテーションの `allowFormat` 属性で入力値チェックを行うこと。

### yyyymm（年月）

値はyyyyMM形式またはパターン形式の文字列。使用方法は :ref:`yyyymmdd (年月日)<tag-format_yyyymmdd>` と同じ。

### dateTime（日時）

値は `Date` 型。`SimpleDateFormat` 構文を使用。デフォルトでは `ThreadContext` の言語とタイムゾーンに応じた日時が出力される。`|` 区切りでロケールおよびタイムゾーンを明示指定可能。:ref:`tag-setting` の `dateTimePattern`・`patternSeparator` プロパティでデフォルトパターンと区切り文字を変更できる。

```properties
valueFormat="dateTime"                                              # デフォルト設定使用
valueFormat="dateTime{|ja|Asia/Tokyo}"                             # ロケール＋タイムゾーン指定
valueFormat="dateTime{||Asia/Tokyo}"                               # タイムゾーンのみ指定
valueFormat="dateTime{yyyy年MMM月d日(E) a hh:mm|ja|America/New_York}}" # 全指定
valueFormat="dateTime{yy/MM/dd HH:mm:ss||Asia/Tokyo}"              # パターン＋タイムゾーン指定
```

### decimal（10進数）

値は `Number` 型または数字の文字列（文字列の場合、3桁区切り文字を除去してフォーマット）。`DecimalFormat` 構文を使用。デフォルトでは `ThreadContext` の言語に応じた形式で出力。`|` 区切りで言語指定可能。:ref:`tag-setting` の `patternSeparator` プロパティで区切り文字を変更できる。

```properties
valueFormat="decimal{###,###,###.000}"       # パターンのみ（ThreadContext言語使用）
valueFormat="decimal{###,###,###.000|ja}"    # パターン＋言語指定
```

> **重要**: 値のフォーマットのみを行い、丸め動作の設定は行わない（`DecimalFormat` のデフォルトが使用される）。丸め処理が必要な場合はアプリケーション側で処理してから本機能でフォーマットすること。

> **重要**: :ref:`tag-text_tag` のvalueFormat属性を指定した場合、入力画面にもフォーマットした値が出力される。入力された数値をアクションで取得する場合は数値コンバータ（`BigDecimalConvertor`、`IntegerConvertor`、`LongConvertor`）を使用すること。:ref:`bean_validation` は :ref:`tag-text_tag` のvalueFormat属性に対応していない。

> **補足**: パターンに桁区切りと小数点を指定する場合、言語に関係なく常に桁区切りにカンマ・小数点にドットを使用すること（例: `decimal{###,###,###.000|es}`）。`decimal{###.###.###,000|es}` のような指定は不正で実行時例外がスローされる。

## エラー表示を行う

エラー表示では以下の機能を提供する:
- :ref:`エラーメッセージの一覧表示 <tag-write_error_errors_tag>`
- :ref:`エラーメッセージの個別表示 <tag-write_error_error_tag>`
- :ref:`入力項目のハイライト表示 <tag-write_error_css>`

> **補足**: エラー表示カスタムタグは `ApplicationException` をリクエストスコープから取得してエラーメッセージを出力する。`ApplicationException` は :ref:`on_error_interceptor` を使用してリクエストスコープに設定する。

## エラーメッセージの一覧表示

:ref:`tag-errors_tag` を使用する。`filter` 属性で表示対象を指定する。

すべてのエラーメッセージを表示する場合（`filter="all"`）:

```jsp
<n:errors filter="all" errorCss="alert alert-danger" />
```

入力項目に対応しないエラーメッセージのみを表示する場合（`filter="global"`）:

```java
// アクション: ApplicationExceptionをスロー
throw new ApplicationException(
  MessageUtil.createMessage(MessageLevel.ERROR, "errors.duplicateName"));
```

```jsp
<n:errors filter="global" errorCss="alert alert-danger" />
```

## エラーメッセージの個別表示

入力項目ごとにエラーメッセージを表示する場合は :ref:`tag-error_tag` を使用する。`name` 属性に入力項目と同じ名前を指定する。

```jsp
<n:text name="form.userName" />
<n:error name="form.userName" messageFormat="span" errorCss="alert alert-danger" />
```

:ref:`bean_validation-correlation_validation` のエラーメッセージを特定の項目の近くに表示する場合も :ref:`tag-error_tag` を使用する。相関バリデーションで設定されるプロパティ名を `name` 属性に指定する。

```java
@AssertTrue(message = "パスワードが一致しません。")
public boolean isComparePassword() {
    return Objects.equals(password, confirmPassword);
}
```

```jsp
<n:password name="form.password" nameAlias="form.comparePassword" />
<n:error name="form.password" messageFormat="span" errorCss="alert alert-danger" />
<!-- 相関バリデーションで指定されるプロパティ名をname属性に指定 -->
<n:error name="form.comparePassword" messageFormat="span" errorCss="alert alert-danger" />
```

## 入力項目のハイライト表示

入力項目のカスタムタグは、エラーの原因となった入力項目のclass属性に、元の値に対してCSSクラス名（デフォルトは `nablarch_error`）を追記する。このクラス名にCSSでスタイルを指定することでエラーがあった入力項目をハイライト表示できる。

`nameAlias` 属性を指定することで複数の入力項目を紐付け、:ref:`bean_validation-correlation_validation` でエラーとなった場合に複数の入力項目をハイライト表示できる。

```css
input.nablarch_error, select.nablarch_error {
  background-color: #FFFFB3;
}
```

```jsp
<!-- nameAlias属性に相関バリデーションのプロパティ名を指定 -->
<n:password name="form.password" nameAlias="form.comparePassword" />
<n:error name="form.password" messageFormat="span" errorCss="alert alert-danger" />
<n:error name="form.comparePassword" messageFormat="span" errorCss="alert alert-danger" />

<n:password name="form.confirmPassword" nameAlias="form.comparePassword" />
<n:error name="form.confirmPassword" messageFormat="span" errorCss="alert alert-danger" />
```

## コード値を表示する

コード値専用カスタムタグ一覧:
- :ref:`tag-code_tag` (コード値表示)
- :ref:`tag-code_select_tag` (コード値のプルダウン)
- :ref:`tag-code_checkbox_tag` (コード値のチェックボックス)
- :ref:`tag-code_radio_buttons_tag` (コード値の複数のラジオボタン)
- :ref:`tag-code_checkboxes_tag` (コード値の複数のチェックボックス)

**属性**（`n:code`、`n:codeSelect` 共通）:
| 属性名 | 説明 |
|---|---|
| codeId | コードID |
| pattern | 使用するパターンのカラム名（デフォルト: 指定なし） |
| optionColumnName | 取得するオプション名称のカラム名 |
| labelPattern | ラベル整形パターン。プレースホルダ: `$NAME$`（コード名称）、`$SHORTNAME$`（略称）、`$OPTIONALNAME$`（オプション名称、optionColumnName指定必須）、`$VALUE$`（コード値）。デフォルト: `$NAME$` |
| listFormat | 出力フォーマット（例: `div`） |

```jsp
<n:code name="user.gender"
        codeId="GENDER" pattern="PATTERN1"
        labelPattern="$VALUE$:$NAME$($SHORTNAME$)"
        listFormat="div" />
<!-- user.gender="FEMALE" の場合: <div>FEMALE:女性(女)</div> -->
```

```jsp
<n:codeSelect name="form.gender"
              codeId="GENDER" pattern="PATTERN2"
              labelPattern="$VALUE$-$SHORTNAME$"
              listFormat="div" />
<!-- 入力画面: <select>要素で出力、確認画面: <div>要素で出力 -->
```

> **重要**: カスタムタグでは言語指定によるコード値の取得はできない。カスタムタグは `CodeUtil` のロケールを指定しないAPIを使用している。言語指定でコード値を取得したい場合は、アクションで `CodeUtil` を使用すること。

## メッセージを出力する

:ref:`tag-message_tag` を使用して :ref:`message` から取得したメッセージを出力する。国際化アプリケーションで1つのJSPファイルで多言語対応する場合に使用できる。

**属性**:
| 属性名 | 説明 |
|---|---|
| messageId | メッセージID |
| var | 埋め込み用文言の変数名 |
| option0, option1, ... | 埋め込み用文言（`var`で取得した値を指定） |
| language | 言語を指定（画面内で一部のメッセージのみ言語を切り替えたい場合） |
| htmlEscape | HTMLエスケープ有無。`false`でエスケープ無効 |

```jsp
<n:message messageId="page.not.found" />

<!-- 埋め込み使用例 -->
<n:message var="title" messageId="title.user.register" />
<n:message var="appName" messageId="title.app" />
<n:message messageId="title.template" option0="${title}" option1="${appName}" />

<!-- 言語指定 -->
<n:message messageId="page.not.found" language="ja" />

<!-- HTMLエスケープ無効 -->
<n:message messageId="page.not.found" htmlEscape="false" />
```

## 言語毎にリソースパスを切り替える

以下のカスタムタグは言語設定をもとにリソースパスを動的に切り替える機能を持つ:
- :ref:`tag-a_tag`
- :ref:`tag-img_tag`
- :ref:`tag-link_tag`
- :ref:`tag-script_tag`
- :ref:`tag-confirmation_page_tag` (入力画面と確認画面を共通化)
- :ref:`tag-include_tag` (インクルード)

**クラス**: `ResourcePathRule` のサブクラスを使用して言語毎のリソースパスを取得する。デフォルト提供のサブクラスは :ref:`http_response_handler-change_content_path` を参照。

> **補足**: :ref:`tag-include_tag` は動的JSPインクルードを言語毎のリソースパス切り替えに対応させるために提供している。:ref:`tag-include_param_tag` を使用してインクルード時に追加するパラメータを指定できる。

```jsp
<!-- path属性にインクルードするリソースのパスを指定 -->
<n:include path="/app_header.jsp">
    <!-- paramName: パラメータ名、value: 値（またはname: スコープ上の値） -->
    <n:includeParam paramName="title" value="ユーザ情報詳細" />
</n:include>
```

## ブラウザのキャッシュを防止する

:ref:`tag-no_cache_tag` をキャッシュを防止したい画面のJSPの`<head>`タグ内に指定する。複数ユーザで同じ端末を使用する環境で、ブラウザの戻るボタン操作による個人情報・機密情報の漏洩を防ぐ。

```jsp
<head>
  <n:noCache/>
</head>
```

`n:noCache`指定時に出力されるレスポンスヘッダ:
```
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Pragma: no-cache
```

`n:noCache`指定時に`<head>`内へ出力されるHTML:
```html
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
```

> **重要**:
> - :ref:`tag-no_cache_tag` は :ref:`tag-include_tag`（`<jsp:include>`）でincludeされるJSPでは使用不可。必ずforwardされるJSPで指定すること。
> - システム全体でブラウザキャッシュ防止を使用する場合は、各JSPで実装漏れが発生しないようにプロジェクトで :ref:`ハンドラ <nablarch_architecture-handler_queue>` を作成して一律設定すること。ハンドラでは上記レスポンスヘッダの内容を設定する。

> **補足**: HTTPの仕様上はレスポンスヘッダのみで十分だが、この仕様に準拠していない古いブラウザのためにmetaタグも出力している。

> **補足**: IE6、IE7、IE8ではHTTP/1.0かつSSL(https)が適用されない通信においてキャッシュ防止が有効にならない。ブラウザのキャッシュ防止を使用する画面は必ずSSL通信を適用するように設計すること。

## 静的コンテンツの変更時にクライアント側のキャッシュを参照しないようにする

以下のカスタムタグの`href`属性および`src`属性で指定した静的コンテンツのURIに、パラメータでバージョンを付加する機能:
- :ref:`tag-link_tag`
- :ref:`tag-img_tag`
- :ref:`tag-script_tag`
- :ref:`tag-submit_tag`
- :ref:`tag-popup_submit_tag`
- :ref:`tag-download_submit_tag`

バージョンは :ref:`設定ファイル(propertiesファイル)<repository-environment_configuration>` の `static_content_version` キーで指定。未設定の場合は機能無効。

```properties
# 静的コンテンツのバージョン
static_content_version=1.0
```

> **重要**: この機能は非推奨。`static_content_version`はアプリケーション内で1つしか定義できないため、値を変更すると変更していない静的コンテンツを含む全ての静的コンテンツのキャッシュが無効化される。静的コンテンツの変更時にキャッシュを参照しないようにするには、静的コンテンツのファイル名を変更する等で対応すること。

## 論理属性を指定する

カスタムタグで定義されている論理属性は、値に `true`/`false` を指定して出力有無を制御できる。

```jsp
<!-- 論理属性にtrueを指定 -->
<n:text name="form.userId" disabled="true" />
<!-- 出力: <input type="text" name="form.userId" disabled="disabled" /> -->

<!-- 論理属性にfalseを指定 -->
<n:text name="form.userId" disabled="false" />
<!-- 出力: <input type="text" name="form.userId" /> -->
```

## 任意の属性を指定する

**クラス**: `jakarta.servlet.jsp.tagext.DynamicAttributes` インタフェースを使用して動的属性を扱っている。HTMLを出力するタグについては動的属性が使用可能で、HTML5で追加された属性を含む任意の属性をカスタムタグで出力できる。

## 論理属性の扱い（動的属性）

論理属性として扱う動的属性は、カスタムタグで定義されている論理属性と同様に `true`/`false` で出力有無を制御できる。

デフォルトで論理属性として扱う動的属性:
`async`, `autofocus`, `checked`, `disabled`, `formnovalidate`, `hidden`, `ismap`, `itemscope`, `multiple`, `nomodule`, `novalidate`, `readonly`, `required`, `reversed`, `selected`

論理属性リストを変更する場合は `CustomTagConfig` の `dynamicBooleanAttributesプロパティ` に設定する。

## Content Security Policy(CSP)に対応する

:ref:`セキュアハンドラでnonceを生成する設定<content_security_policy>` を行うと、以下の動作変化が生じる:
- :ref:`tag-form_tag` が生成するJavaScript（onclick属性の関数呼び出し含む）をscript要素にまとめ、nonce属性にセキュアハンドラが生成したnonceを設定する
- :ref:`tag-script_tag` が生成するscript要素のnonce属性にセキュアハンドラが生成したnonceを設定する
- セキュアハンドラが生成したnonceを :ref:`tag-csp_nonce_tag` で出力可能になる

> **重要**: NablarchのCSP対応はnonceを利用する。nonceはHTML内に埋め込まれるため、JSPから生成されるHTMLがリクエストの都度変化する。

## セキュアハンドラが生成したnonceを任意の要素に埋め込む

既存コンテンツにインラインで記述されているものがあり外部ファイルへの移行が困難な場合、:ref:`tag-csp_nonce_tag` を使用して対象要素にnonce属性を設定できる。:ref:`tag-csp_nonce_tag` は :ref:`セキュアハンドラ<content_security_policy>` で生成したnonceを出力するカスタムタグ。

```jsp
<%-- style要素でのnonce設定例 --%>
<style nonce="<n:cspNonce />">
  <!-- 省略 -->
</style>
<!-- 出力: <style nonce="DhcnhD3khTMePgXwdayK9BsMqXjhguVV"> -->
```

> **補足**: :ref:`tag-script_tag` で作成したscript要素については、nonceの生成が有効な場合はnonce属性が自動で付与される。script要素にnonce属性を付与したい場合は :ref:`tag-csp_nonce_tag` ではなく :ref:`tag-script_tag` を使用することを推奨。

> **補足**: Content-Security-Policyをレスポンスヘッダで設定できない場合はmeta要素で設定する。この場合、:ref:`tag-csp_nonce_tag` の `sourceFormat` 属性を `true` に設定するとnonceが `nonce-[セキュアハンドラが生成したnonce]` フォーマットで出力される。

## カスタムタグが生成する要素に対してJavaScriptで処理を追加する

Content-Security-Policyのポリシーをセキュアに保つため、onclick属性などのインラインスクリプトをカスタムタグが生成する要素に直接指定してはならない。

JavaScript処理を追加する手順:
1. id属性やname属性などを使用し、カスタムタグが生成する要素を特定できるように設定する
2. 生成された要素をセレクタで特定し、追加の処理を実装するスクリプトを外部ファイルまたはnonce付きのscript要素として作成する
3. カスタムタグが :ref:`JavaScriptを生成する<tag-onclick_override>` ものの場合は、`suppressDefaultSubmit="true"` を設定してカスタムタグによるJavaScriptの生成を抑制する

JSP例:
```jsp
<n:form>
  <n:submit id="register_button" type="submit" uri="register" suppressDefaultSubmit="true" value="登録" />
</n:form>
```

JavaScript例:
```javascript
function popUpConfirmation(event) {
  event.preventDefault();
  if (window.confirm('登録します。よろしいですか？')) {
    // カスタムタグが出力するJavaScript関数を明示的に呼び出す。
    // 第2引数のelementはnablarch_submit関数内でeventから導出する
    nablarch_submit(event);
  }
}
document.querySelector('#register_button').addEventListener('click', popUpConfirmation);
```

## 拡張例

### フォーマッタを追加する

**valueFormat属性使用時**: `ValueFormatter` インタフェースを実装したクラスがフォーマットを行う。実装したクラスをコンポーネント定義に追加することでフォーマットを変更できる。

コンポーネント定義には `valueFormatters` という名前でMap型（データタイプ名をキー、ValueFormatterを実装したクラスを値）として追加する。

```xml
<map name="valueFormatters">
  <entry key="yyyymmdd">
    <value-component class="nablarch.common.web.tag.YYYYMMDDFormatter" />
  </entry>
  <entry key="yyyymm">
    <value-component class="nablarch.common.web.tag.YYYYMMFormatter" />
  </entry>
  <entry key="dateTime">
    <value-component class="nablarch.common.web.tag.DateTimeFormatter" />
  </entry>
  <entry key="decimal">
    <value-component class="nablarch.common.web.tag.DecimalFormatter" />
  </entry>
</map>
```

### ボタン/リンクの表示制御に使う判定処理を変更する

`DisplayControlChecker` インタフェースを実装し、:ref:`tag-setting` の `displayControlCheckersプロパティ` に指定する。

```xml
<list name="displayControlCheckers">
  <!-- サービス提供可否についてはデフォルトのDisplayControlCheckerを指定する -->
  <component class="nablarch.common.web.tag.ServiceAvailabilityDisplayControlChecker" />
  <!-- 認可チェックについてはプロジェクトでカスタマイズしたDisplayControlCheckerを指定する -->
  <component class="com.sample.app.CustomPermissionDisplayControlChecker" />
</list>

<component name="customTagConfig" class="nablarch.common.web.tag.CustomTagConfig">
  <property name="displayControlCheckers" ref="displayControlCheckers" />
</component>
```

### クライアント側の二重サブミット防止で、二重サブミット発生時の振る舞いを追加する

2回目以降のサブミット要求発生時に呼び出されるコールバック関数 `nablarch_handleDoubleSubmission(element)` をJavaScriptで実装する。

```js
/**
 * @param element 二重サブミットが行われた対象要素(ボタン又はリンク)
 */
function nablarch_handleDoubleSubmission(element) {
  // ここに処理を記述する。
}
```

### サーバ側の二重サブミット防止で、トークンの発行処理を変更する

`TokenGenerator` インタフェースを実装し、コンポーネント定義に `tokenGenerator` という名前で追加する。

## カスタムタグのルール

### 命名ルール

CSSクラス名やJavaScript関数名などカスタムタグが規定する名前にはプレフィックス `nablarch_` を使用する。個別アプリケーションでは `nablarch_` から始まる名前を使用してはならない。

対象範囲:
- HTMLの属性値
- CSSのクラス名
- JavaScriptの関数名とグローバル変数名
- ページスコープ、リクエストスコープ、セッションスコープの変数名

### 入力/出力データへのアクセスルール

name属性の値に基づき出力対象データにアクセスする。

- オブジェクト/Mapのプロパティ: ドット区切り（例: `form.personName`）
- List/配列の要素: 角括弧+インデックス（例: `form.persons[0].personName`）

検索順序（最初に見つかった値を使用。値が取得できない場合は空文字列を出力）:
1. Pageスコープ
2. リクエストスコープ
3. リクエストパラメータ
4. セッションスコープ

> **補足**: リクエストパラメータが検索対象に含まれるのは、入力フォーム再表示時に入力値を復元するため。JSTLはリクエストパラメータにアクセスできないため、JSTLを使用する場合はアクション側でリクエストスコープに値を設定すること。

> **補足**: リクエストスコープがリクエストパラメータより先に検索されるのは、入力フォーム再表示時に入力値を変更できるようにするため（例: ラジオボタンを未選択に戻す場合は、アクション側でリクエストスコープに空文字を設定する）。

**オブジェクトの実装例**:

アクション:
```java
// オブジェクトをリクエストスコープに設定する。
PersonForm form = new PersonForm();
form.setPersonName("名前");
context.setRequestScopedVar("form", form);
return new HttpResponse("/WEB-INF/view/sample/accessRuleObject.jsp");
```

JSP:
```jsp
<!-- ドット区切りを使う。 -->
<n:text name="form.personName" />
```

**Listの実装例**:

アクション:
```java
// Listを持つオブジェクトをリクエストスコープに設定する。
PersonsForm form = new PersonsForm();
List<Person> persons = UniversalDao.findAll(Person.class);
form.setPersons(persons);
context.setRequestScopedVar("form", form);
```

JSP:
```jsp
<!-- インデックスを取得するためループをまわす。 -->
<c:forEach items="${form.persons}" varStatus="status">
  <!--
    角括弧を使って要素にアクセスする。
    要素の値はドットを使ってアクセスする。
  -->
  <n:text name="form.persons[${status.index}].personName" />
</c:forEach>
```

### URIの指定方法

| URIの種類 | 形式 | カスタムタグの動作 |
|---|---|---|
| 絶対URL | http/httpsから始まるパス | そのまま使用 |
| コンテキストからの相対パス | /から始まるパス | コンテキストパスを先頭に付加 |
| 現在のパスからの相対パス | /から始まらないパス（絶対URL除く） | そのまま使用 |

**secure属性**: コンテキストからの相対パス指定時に使用。`true`でhttps、`false`でhttpに切り替え。使用する場合は :ref:`tag-setting` で `portプロパティ` / `securePortプロパティ` / `hostプロパティ` を指定すること。

> **補足**: secure属性は遷移先のプロトコルを切り替えるボタンやリンクのみで使用する。遷移先のプロトコルが同じ場合は指定しない。

secure属性の実装例（設定値: http用ポート=8080、https用ポート=443、ホスト=sample.co.jp）:

**http→httpsに切り替える場合**:
```jsp
<!-- secure属性にtrueを指定する。 -->
<n:submit type="button" name="login" value="ログイン" uri="/action/login" secure="true" />
```
組み立てられるURI: `https://sample.co.jp:443/<コンテキストパス>/action/login`

**https→httpに切り替える場合**:
```jsp
<!-- secure属性にfalseを指定する。 -->
<n:submitLink name="logout" uri="/action/logout" secure="false">ログアウト</n:submitLink>
```
組み立てられるURI: `https://sample.co.jp:8080/<コンテキストパス>/action/logout`

> **注意**: カスタムタグの設定でhttp用のポート番号を指定しなかった場合、ポート番号が出力されない（例: `https://sample.co.jp/<コンテキストパス>/action/logout`）。

### HTMLエスケープと改行、半角スペース変換

カスタムタグは出力時に全HTML属性をHTMLエスケープする。

| 変換前 | 変換後 |
|---|---|
| `&` | `&amp;` |
| `<` | `&lt;` |
| `>` | `&gt;` |
| `"` | `&#034;` |
| `'` | `&#039;` |

> **重要**: EL式はHTMLエスケープを行わないため、EL式を使って値を出力してはならない。値の出力には :ref:`tag-write_tag` などのカスタムタグを使用すること。ただし、JSTLのforEachタグやカスタムタグの属性にオブジェクトを設定するなど直接出力しない箇所ではEL式を使用可能。

確認画面などに入力データを出力する際は、HTMLエスケープに加えて改行と半角スペースも変換する。

| 変換前 | 変換後 |
|---|---|
| 改行コード（`\n`、`\r`、`\r\n`） | `<br />` |
| 半角スペース | `&nbsp;` |

## タグリファレンス

各カスタムタグの詳細な仕様（属性一覧、出力HTML、使用例など）については、タグリファレンスを参照。

:ref:`tag_reference` を参照。
