# 入力フォームのname属性

**公式ドキュメント**: [入力フォームのname属性]()

## 入力フォームのname属性

name属性の指定規則:
- Map型またはオブジェクトのプロパティにアクセスする場合: ドット区切り（例: `user.name`）
- List型または配列の要素にアクセスする場合: 角括弧+インデックス（例: `user[0].name`）

```java
public class UserEntity {
    private String name;
    private String remarks;
    // アクセッサは省略。
}
```

暗号化は`Encryptor`インタフェースを実装したクラスが行う。デフォルトの暗号化アルゴリズムはAES(128bit)。アルゴリズムを変更する場合は、Encryptorを実装したクラスをリポジトリに`hiddenEncryptor`という名前で登録する。

暗号化はformタグ毎に行い、以下のデータをまとめて1つのhiddenタグで出力する（hiddenのパラメータ名も含めて暗号化するため、改竄自体を困難にする）:

- カスタムタグのhiddenタグで明示的に指定したhiddenパラメータ
- ウィンドウスコープの値
- サブミットタグ(submit、submitLink、button)で指定したリクエストID
- サブミットタグで指定した :ref:`変更パラメータ<WebView_ChangeableParams>`

改竄検知のためハッシュ値を含める。リクエストIDは異なる画面間での値置き換えによる改竄検知、ハッシュ値は値の書き換えによる改竄検知に使用する。暗号化結果はBASE64でエンコードしてhiddenタグに出力する。

> **注意**: カスタムタグのhiddenタグで明示的に指定したhiddenパラメータは暗号化に含まれるため、クライアント側JavaScriptで値を操作できない。JavaScriptでhiddenパラメータを操作する必要がある場合は :ref:`WebView_PlainHiddenTag` を使用すること。:ref:`WebView_PlainHiddenTag` に指定された値はhidden暗号化対象とならず、常にHTMLの`input type="hidden"`として出力される。

```html
<%-- JSPの実装例 --%>
<n:plainHidden name="user.id" />

<%-- HTMLの出力例 --%>
<input type="hidden" name="user.id" value="U0000000001" />
```

暗号化に使用する鍵はセッション毎に生成する（鍵の有効期間を短くするため）。同じユーザでもログインをやり直すと、ログイン前の画面から処理を継続できない。

> **注意**: 本フレームワークが出力したHTML以外からのリクエスト（業務アプリのログイン画面、ショッピングサイトの商品ページ等）は暗号化できない。暗号化できないリクエストが多数を占めるアプリケーションでは、別途パラメータの改竄と情報漏洩への対策が必要。

<details>
<summary>keywords</summary>

name属性, ドット区切り, 角括弧, インデックス, エンティティアクセス, 配列アクセス, UserEntity, Encryptor, hiddenEncryptor, AES暗号化, hidden暗号化, 改竄検知, plainHidden, WebView_PlainHiddenTag, セッション鍵生成

</details>

## エンティティのプロパティにアクセスする場合の実装例

JSP実装例:
```jsp
<n:text name="user.name" />
<n:text name="user.remarks" />
```

アクション実装例（`"user"`プレフィックスでバリデーション）:
```java
ValidationContext<UserEntity> userCtx =
    ValidationUtil.validateAndConvertRequest("user", UserEntity.class, req, "insert");
if (!userCtx.isValid()) {
    throw new ApplicationException(userCtx.getMessages());
}
UserEntity user = userCtx.createObject();
```

hiddenの復号処理は`NablarchTagHandler`が行う。設定方法については :ref:`WebView_NablarchTagHandler` 参照。

設定では、改竄を検知した場合に遷移する画面のリソースパスとレスポンスステータスを指定する。以下の場合に改竄と判定する:

- 暗号化したhiddenパラメータ(nablarch_hidden)が存在しない
- BASE64のデコードに失敗する
- 復号に失敗する
- 暗号化時のハッシュ値と復号後のハッシュ値が一致しない
- 暗号化時のリクエストIDと受け付けたリクエストIDが一致しない

## 入力データの復元

入力画面では、入力エラー時と確認画面から戻る場合に入力データを復元した状態で再表示する。カスタムタグがリクエストパラメータから入力データを復元するため、アプリケーションプログラマは入力データの取得先を意識した実装が不要。

カスタムタグはname属性に対応する値を以下の順に検索し、最初に見つかった値を出力する（writeタグはリクエストパラメータを検索対象に含めない）:

1. Servlet APIのページスコープ
2. Servlet APIのリクエストスコープ
3. Servlet APIのリクエストパラメータ
4. Servlet APIのセッションスコープ

<details>
<summary>keywords</summary>

ValidationUtil, validateAndConvertRequest, ValidationContext, エンティティバリデーション, n:text, UserEntity, ApplicationException, NablarchTagHandler, hiddenの復号, 改竄検知条件, 入力データの復元, リクエストパラメータ復元, ページスコープ, セッションスコープ

</details>

## name属性の値取得優先順位

`n:text`等のname属性を使うカスタムタグが画面出力値を取得する優先順位:

1. Pageスコープから`name`属性に対応するオブジェクトが取得できた場合
2. リクエストスコープから取得できた場合
3. リクエストパラメータから取得できた場合（入力エラー時の同一画面再表示や [windowscope](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) の値表示に使用）
4. セッションスコープから取得できた場合

上記で値が取得できない場合は空文字を出力する。

> **注意**: Page/リクエストスコープでオブジェクトが取得できてもプロパティが`null`の場合、リクエストパラメータに値があっても空文字を出力する。これは前画面入力値を`null`で上書きするための仕様。 :ref:`WebView_CustomTagConfig` の`useValueAsNullIfObjectExists`設定で変更可能。

Pageスコープのオブジェクト設定には :ref:`WebView_SetTag` を使用する。

入力項目のカスタムタグは、入力画面と全く同じ記述のまま確認画面用の出力ができる。確認画面のJSPに :ref:`WebView_ConfirmationPageTag` を追加する:

```java
<n:confirmationPage />
```

:ref:`WebView_TextTag` は確認画面でそのまま出力する。

```jsp
<n:text name="systemAccount.loginId" size="22" maxlength="20" />
```

```html
<%-- 入力画面 --%>
<input type="text" name="systemAccount.loginId" value="nablarch2" size="22" maxlength="20" />

<%-- 確認画面 --%>
nablarch2
```

<details>
<summary>keywords</summary>

Pageスコープ, リクエストスコープ, セッションスコープ, 値取得優先順位, useValueAsNullIfObjectExists, WebView_SetTag, windowscope, WebView_CustomTagConfig, confirmationPage, WebView_ConfirmationPageTag, 確認画面出力, textタグ, n:text, 入力項目確認画面

</details>

## Listのプロパティにアクセスする場合の実装例

JSP実装例（JSTLのforEachタグを使用、アクション側でリクエストスコープに`userSize`を設定）:
```jsp
<c:forEach begin="0" end="${userSize}" var="userIndex">
  <n:text name="user[${userIndex}].name" />
  <n:text name="user[${userIndex}].remarks" />
</c:forEach>
```

アクション実装例（`"user[n]"`プレフィックスでバリデーション）:
```java
int userSize = 3;
List<UserEntity> users = new ArrayList<UserEntity>(userSize);
List<Message> errors = new ArrayList<Message>();
boolean isValid = true;
for (int i = 0; i < userSize; i++) {
    ValidationContext<UserEntity> userCtx =
        ValidationUtil.validateAndConvertRequest("user[" + i + "]", UserEntity.class, req, "insert");
    if (userCtx.isValid()) {
        users.add(userCtx.createObject());
    } else {
        errors.addAll(userCtx.getMessages());
        isValid = false;
    }
}
if (!isValid) {
    throw new ApplicationException(errors);
}
```

:ref:`WebView_PasswordTag` は確認画面では文字を置き換えて出力する。置換文字はpasswordタグの属性で変更可能。

```jsp
<n:password name="systemAccount.newPassword" size="22" maxlength="20" />
```

```html
<%-- 入力画面 --%>
<input type="password" name="systemAccount.newPassword" value="password" size="22" maxlength="20" />

<%-- 確認画面 --%>
<%-- '*'に置換。置換文字は変更可能。 --%>
********
```

<details>
<summary>keywords</summary>

forEach, List型アクセス, 配列バリデーション, ValidationUtil, n:text, ループバリデーション, 角括弧インデックス, WebView_PasswordTag, passwordタグ, 確認画面マスク, n:password, 文字置換

</details>

## 入力データの保持

入力データはクライアント側のhiddenタグとして保持する（ウィンドウスコープ）。サーバ側（セッション）保持と比較して複数ウィンドウやブラウザ戻るボタン使用時の制限が少ない。

保持するデータ例: 更新対象の主キー、楽観ロック用バージョン番号（または更新日時）。

> **注意**: DBデータのhidden保持は主キー・楽観ロック用データなど必要最低限に留めること。確認画面等で表示するだけのデータはhiddenで引き回さず、必要なたびにDBから取得すること。

ログイン情報など全業務で必要な情報はサーバ側（セッション）に保持する（クライアント側保持と混同しないこと）。

変数スコープ詳細: [scope](../../about/about-nablarch/about-nablarch-concept-architectural_pattern.md) および [web_scope](../handlers/handlers-HttpMethodBinding.md)。

:ref:`WebView_SelectTag` は確認画面では指定されたフォーマットで出力する。デフォルトはbrタグ区切り。確認画面では選択されたオプションのみが出力される（divタグ、ulタグ、olタグ、スペース区切りに変更可能）。

```jsp
<n:select name="systemAccount.useCase" multiple="true" size="5"
          listName="allUseCase" elementLabelProperty="useCaseName" elementValueProperty="useCaseId"
          elementLabelPattern="${VALUE}:${LABEL}" />
```

```html
<%-- 入力画面 --%>
<select name="systemAccount.useCase" size="5" multiple="multiple">
  <option value="UC00000000" selected="selected">UC00000000:ログイン</option>
  <option value="UC00000001">UC00000001:ユーザ一覧照会</option>
  <option value="UC00000002" selected="selected">UC00000002:ユーザ情報登録</option>
</select>

<%-- 確認画面 --%>
<%-- brタグ区切りに出力。divタグ、ulタグ、olタグ、スペース区切りに変更可能。 --%>
UC00000000:ログイン<br />UC00000002:ユーザ情報登録<br />
```

<details>
<summary>keywords</summary>

hiddenタグ, ウィンドウスコープ, windowscope, クライアント保持, 楽観ロック, 主キー, scope, web_scope, WebView_SelectTag, selectタグ, 確認画面選択肢, n:select, brタグ区切り

</details>

## windowScopePrefixes属性の使用方法

:ref:`WebView_FormTag` の`windowScopePrefixes`属性でウィンドウスコープにデータを設定する。

JSP実装例（ユーザ登録確認画面）:
```jsp
<n:form windowScopePrefixes="systemAccount,users,ugroupSystemAccount">
    <n:submit type="button" name="back" value="戻る" uri="./USERS00301" />
    <n:submit type="button" name="register" value="登録" uri="./USERS00302" allowDoubleSubmission="false" />
</n:form>
```

| 属性 | 説明 |
|---|---|
| `windowScopePrefixes` | ウィンドウスコープ変数のプレフィックス（複数指定はカンマ区切り）。指定したプレフィックスにマッチするリクエストパラメータをhiddenタグとして出力する。 |

`windowScopePrefixes`未指定の場合、ウィンドウスコープのデータはサーバへ送信されない。

<details>
<summary>keywords</summary>

windowScopePrefixes, n:form, WebView_FormTag, ウィンドウスコープ設定, allowDoubleSubmission

</details>

## formタグの除外動作

formタグは全リクエストパラメータを一律hiddenタグに出力するのではなく、既に入力項目として出力済みのリクエストパラメータはhiddenタグの出力から除外する。

この動作により、ウィザード形式の画面のように、現在画面の入力項目と他画面で入力されたデータ（hiddenタグ）を同時に出力することに対応している。

<details>
<summary>keywords</summary>

formタグ除外動作, hiddenタグ除外, ウィザード形式, リクエストパラメータ除外

</details>

## 複数画面に跨る画面遷移時のwindowScopePrefixes属性の指定方法

更新機能における複数画面遷移での指定例（検索条件プレフィックス: `searchCondition.*`、更新対象: `user.*`）:

```jsp
<%-- 検索画面: ウィンドウスコープのデータを送信しない --%>
<n:form>

<%-- 更新画面: 検索条件を送信 --%>
<n:form windowScopePrefixes="searchCondition">

<%-- 更新確認画面: 更新対象と検索条件を送信 --%>
<n:form windowScopePrefixes="user,searchCondition">

<%-- 更新完了画面: 検索条件を送信 --%>
<n:form windowScopePrefixes="searchCondition">
```

<details>
<summary>keywords</summary>

windowScopePrefixes, 複数画面遷移, 検索条件引き回し, 更新確認画面, searchCondition

</details>

## パスワードのhiddenタグ出力に関する注意

> **警告**: パスワード入力もhiddenタグに出力されるため、パスワードがブラウザのキャッシュに残る。インターネット越しに利用するアプリケーション等でキャッシュに問題がある場合は、確認画面を出さない設計にするか、パスワード変更画面のみサーバ側（セッション）を利用するなど、hiddenにパスワードが出力されないよう考慮すること。

<details>
<summary>keywords</summary>

パスワード, hiddenタグ, ブラウザキャッシュ, セキュリティ, セッション

</details>

## アクションの実装方法

サーバ方式（セッション保持）とクライアント方式（hiddenタグ保持）のアクション実装の違い:

**a) 入力データの設定**
- サーバ方式: アクションでセッションに対して入力データを明示的に設定する必要がある
- クライアント方式: formタグの指定に従いフレームワークが入力データを維持するため、実装不要

**b) バリデーション**
- クライアント方式: 入力データを書き換えられる可能性があるため、入力データ使用時は毎回バリデーションが必要

<details>
<summary>keywords</summary>

サーバ方式, クライアント方式, バリデーション, セッション, アクション実装, 毎回バリデーション

</details>

## hiddenタグの暗号化

ウィンドウスコープやhiddenタグの値はクライアント側での改竄・HTMLソース参照が容易なため、hiddenタグの暗号化機能を提供する。

- 目的: hiddenタグの改竄防止とHTMLソース上でのhiddenタグ内容参照防止
- デフォルト: 全formタグで暗号化、全リクエストで復号（改竄チェック）を行う
- アプリケーションプログラマによる実装は不要

<details>
<summary>keywords</summary>

hiddenタグ暗号化, 改竄防止, nablarch_hidden, ウィンドウスコープ暗号化

</details>

## hiddenタグの暗号化機能の処理イメージ

暗号化はformタグが実行し、復号（改竄チェック）はハンドラが行う。

処理フロー:
1. formタグ: 暗号化対象の全値をまとめて暗号化 → BASE64エンコード → `nablarch_hidden`という名前のhiddenタグ1つで出力
2. ハンドラ: `nablarch_hidden`パラメータをBASE64デコード → 復号 → リクエストパラメータに設定
3. ハンドラの復号処理では改竄チェックも実施。改竄を検知した場合は設定で指定された画面に遷移

暗号化処理詳細: :ref:`WebView_HiddenEncryption_Encrypt`  
復号処理詳細: :ref:`WebView_HiddenEncryption_Handler`

<details>
<summary>keywords</summary>

nablarch_hidden, BASE64, formタグ暗号化, ハンドラ復号, 改竄チェック, WebView_HiddenEncryption_Encrypt, WebView_HiddenEncryption_Handler

</details>

## hiddenタグ暗号化のJSP/HTML実装例

JSP実装例（ユーザ情報編集確認画面）:
```jsp
<n:form windowScopePrefixes="user">
    <n:hidden name="user.id" />
    <n:text name="user.name" />
    <n:password name="user.password" />
</n:form>
```

暗号化しない場合のHTML出力（各フィールドが個別のhiddenタグとして出力）:
```html
<form>
    <input type="hidden" name="user.id" value="U0001" />
    <input type="hidden" name="user.name" value="山田太郎" />
    <input type="hidden" name="user.password" value="pass1234" />
</form>
```

暗号化する場合のHTML出力（全値を1つの`nablarch_hidden`に集約）:
```html
<form>
    <input type="hidden" name="nablarch_hidden" value="XXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
</form>
```

ハンドラ復号後（`nablarch_hidden`が個別パラメータに展開）:
```
nablarch_hidden=XXXXXXXXXXXXXXXXXXXXXXXXXXXX
→ user.id=U0001
→ user.name=山田太郎
→ user.password=pass1234
```

<details>
<summary>keywords</summary>

n:hidden, n:text, n:password, n:form, 暗号化HTML出力例, nablarch_hidden, user.id, user.password

</details>

## hiddenタグの暗号化機能の設定

:ref:`WebView_CustomTagConfig` で以下の設定が可能（設定方法は :ref:`WebView_CustomTagConfig` 参照）:

| プロパティ名 | 説明 |
|---|---|
| `useHiddenEncryption` | アプリケーション全体でhiddenタグの暗号化機能を使用するか否か。開発時にHTMLソース上でhiddenタグ内容を確認する場合に指定する。 |
| `noHiddenEncryptionRequestIds` | 暗号化を行わないリクエストIDの一覧。 |

<details>
<summary>keywords</summary>

useHiddenEncryption, noHiddenEncryptionRequestIds, WebView_CustomTagConfig, 暗号化設定

</details>

## noHiddenEncryptionRequestIdsプロパティの動作

`noHiddenEncryptionRequestIds`プロパティはformタグとハンドラの両方が参照し、暗号化・復号するリクエストIDを同期する。

n:formタグに含まれるリクエストIDと`noHiddenEncryptionRequestIds`の関係による動作:

| 状況 | formタグの処理 | ハンドラの処理 |
|---|---|---|
| 全リクエストIDが指定値と一致しない | 暗号化される | 復号される |
| 全リクエストIDが指定値と一致する | 暗号化されない | 復号されない |
| 一部のみ一致する | **暗号化される** | 復号される |

> **重要**: n:formに含まれるリクエストIDが一部だけ一致する場合でも暗号化が行われる。これは誤設定による暗号化漏れを防ぐため。そのため、本来暗号化対象外とすべきリクエストに対しても暗号化が行われる場合がある。

<details>
<summary>keywords</summary>

noHiddenEncryptionRequestIds, リクエストID, 暗号化スキップ, WebView_CustomTagConfig, 部分一致, 誤設定防止

</details>
