## 動作確認をする為のサンプルアプリケーションの修正

本開発手順で作成したユーザ情報更新機能は、サンプルアプリケーションのユーザ一覧照会の検索結果のログインIDのリンクから遷移することを想定している。

その為、提供しているサンプルアプリケーションの修正が必要である。

修正点は、以下の通り。

* 一覧照会のJSP修正

**修正ファイル**

W11AC0101.jsp

**修正内容**

* **更新** リンクを構成する n:submitLink タグのuri属性を、本書で作成した更新画面初期表示リクエストのパスに変更。
* 送信するパラメータの名前(n:paramタグのparamName属性の値)を、 *W11AC03.systemAccount.userId* から *W11ACXX.operationTargetUserId* に変更。

＜リンクの修正前＞

```text
<td><n:submitLink uri="/action/ss11AC/W11AC03Action/RW11AC0301" name="showUpdate_${count}">
                更新
                <%-- ～中略～ --%>
                <n:param paramName="W11AC03.systemAccount.userId" name="row.userId" />
            </n:submitLink></td>
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

＜リンクの修正後＞

```none
<%-- 【説明】更新リンクの遷移先を変更 --%>
<td><n:submitLink uri="/action/ss11AC/W11ACXXAction/RW11ACXX01" name="showUpdate_${count}">
                更新
                <%-- ～中略～ --%>
                <%-- 【説明】パラメータ名の変更 --%>
                <n:param paramName="W11ACXX.operationTargetUserId" name="row.userId" />
            </n:submitLink></td>
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

＜修正後JSP＞

```./_download/W11AC0101.jsp

```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## 動作確認の実施

本開発手順で作成したユーザ情報更新機能の動作確認を行う。
以下の手順で、差し替えた更新処理が行えることを確認する。

ユーザ情報照会画面で一覧検索を行い、検索結果の一覧の **更新** リンクをクリックする。

今回作成したユーザ情報更新画面に遷移するので、入力フォームの値を変更して **確認** ボタンを押下する。

今回作成したユーザ情報更新確認画面に遷移するので、更新する値が表示されていることを確認し、 **確定** ボタンを押下する。

今回作成したユーザ情報更新完了画面に遷移するので、更新した値が表示されていることを確認する。

**a)** と同様に一覧検索を行い、ユーザの情報が更新されていることを確認する。

> **Note:**
> ユーザ情報更新確認画面に表示される **戻る** ボタンは、今回は実装していないため動作しない。

> **Note:**
> ユーザ情報更新完了画面からは、ヘッダまたはフッタのリンクをクリックして別の画面へ移動できる。
