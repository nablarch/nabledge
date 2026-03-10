# バリデーションエラーのメッセージを画面表示する

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/error_message.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/message/ErrorMessages.html)

## バリデーションエラーのメッセージを画面表示する

サーバサイドバリデーションのエラーメッセージは :ref:`http_error_handler` によってリクエストスコープに格納される。テンプレートエンジンからリクエストスコープの `ErrorMessages` にアクセスしてエラーメッセージを表示する。リクエストスコープの変数名は :ref:`http_error_handler-error_messages` 参照。

> **補足**: JSPのカスタムタグ（:ref:`tag-write_error`）はDOM構造の制約でCSSフレームワークと相性が悪い。リクエストスコープ上のオブジェクトを直接使用することでDOM構造の制約がなくなるため、JSPでもリクエストスコープ上のオブジェクトに直接アクセスしてエラーメッセージを表示できる。

**クラス**: `nablarch.fw.web.message.ErrorMessages`

**特定プロパティのエラーメッセージを表示する場合**:
- `ErrorMessages#hasError` でプロパティ（入力項目のname属性値）に対応するエラー有無を確認
- `ErrorMessages#getMessage` でプロパティに対応するメッセージを取得

```html
<input type='text' name='form.txt' />
<span class="error" th:if="${errors.hasError('form.userName')}"
    th:text="${errors.getMessage('form.userName')}">入力してください。</span>
```

**グローバルメッセージ（プロパティに紐付かないメッセージ）を表示する場合**:
`ErrorMessages#getGlobalMessages()` を使用。

```html
<ul>
  <li th:each="message : ${errors.globalMessages}" th:text="${message}"></li>
</ul>
```

**全メッセージを表示する場合**:
`ErrorMessages#getAllMessages()` を使用。

```html
<ul>
  <li th:each="message : ${errors.allMessages}" th:text="${message}">エラーメッセージ</li>
</ul>
```

<details>
<summary>keywords</summary>

ErrorMessages, nablarch.fw.web.message.ErrorMessages, hasError, getMessage, getGlobalMessages, getAllMessages, バリデーションエラーメッセージ表示, Thymeleaf, リクエストスコープ, グローバルメッセージ, プロパティエラーメッセージ

</details>
