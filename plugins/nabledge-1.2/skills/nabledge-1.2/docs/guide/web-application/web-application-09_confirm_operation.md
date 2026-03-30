# 動作確認をする為のサンプルアプリケーションの修正と動作確認の実施

## 動作確認をする為のサンプルアプリケーションの修正

## 動作確認をする為のサンプルアプリケーションの修正

**修正ファイル**: `W11AC0101.jsp`

`n:submitLink` タグの以下を変更する:

- `uri` 属性: `/action/ss11AC/W11AC03Action/RW11AC0301` → `/action/ss11AC/W11ACXXAction/RW11ACXX01`
- `n:param` の `paramName` 属性: `W11AC03.systemAccount.userId` → `W11ACXX.operationTargetUserId`

修正後:

```jsp
<%-- 【説明】更新リンクの遷移先を変更 --%>
<td><n:submitLink uri="/action/ss11AC/W11ACXXAction/RW11ACXX01" name="showUpdate_${count}">
                更新
                <%-- ～中略～ --%>
                <%-- 【説明】パラメータ名の変更 --%>
                <n:param paramName="W11ACXX.operationTargetUserId" name="row.userId" />
            </n:submitLink></td>
```

<details>
<summary>keywords</summary>

n:submitLink, n:param, W11AC0101.jsp, JSP修正, サンプルアプリケーション修正, 更新リンク, paramName変更, uri属性変更, W11AC03Action, W11ACXXAction

</details>

## 動作確認の実施

## 動作確認の実施

1. ユーザ情報照会画面で一覧検索し、検索結果の **更新** リンクをクリック
2. ユーザ情報更新画面で入力フォームの値を変更して **確認** ボタンを押下
3. ユーザ情報更新確認画面で更新する値が表示されていることを確認し、**確定** ボタンを押下
4. ユーザ情報更新完了画面で更新した値が表示されていることを確認
5. 再度一覧検索を行い、ユーザ情報が更新されていることを確認

> **注意**: ユーザ情報更新確認画面の **戻る** ボタンは実装されていないため動作しない。

> **注意**: ユーザ情報更新完了画面からは、ヘッダまたはフッタのリンクをクリックして別の画面へ移動できる。

<details>
<summary>keywords</summary>

動作確認, ユーザ情報更新, 更新確認画面, 更新完了画面, 戻るボタン, ヘッダ, フッタ

</details>
