# バリデーションエラーのメッセージを画面表示する

**公式ドキュメント**: [1](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/web/feature_details/error_message.html) [2](https://nablarch.github.io/docs/LATEST/javadoc/nablarch/fw/web/message/ErrorMessages.html)

## バリデーションエラーのメッセージを画面表示する

[http_error_handler](../../component/handlers/handlers-HttpErrorHandler.md) はバリデーションエラーメッセージをリクエストスコープの `ErrorMessages` に格納する。テンプレートエンジンからこのオブジェクトにアクセスしてエラーメッセージを表示する。リクエストスコープの変数名は :ref:`エラーメッセージのリクエストスコープへの設定 <http_error_handler-error_messages>` を参照。

> **補足**: JSPの :ref:`カスタムタグを使用したエラー表示 <tag-write_error>` はDOM構造の制約でCSSフレームワークと相性が悪い。JSPでもリクエストスコープ上の `ErrorMessages` オブジェクトに直接アクセスすることでDOM構造の制約なくエラーメッセージを表示できる。

**クラス**: `nablarch.fw.web.message.ErrorMessages`

[Thymeleaf](../../component/adapters/adapters-web_thymeleaf_adaptor.md) を使った実装例:

**特定プロパティのエラーメッセージ表示**

`ErrorMessages#hasError` でエラー有無を確認し、`ErrorMessages#getMessage` でメッセージを取得する。

```html
<input type='text' name='form.txt' />
<span class="error" th:if="${errors.hasError('form.userName')}"
    th:text="${errors.getMessage('form.userName')}">入力してください。</span>
```

**グローバルメッセージ（プロパティに紐付かないメッセージ）の表示**

`ErrorMessages#getGlobalMessages()` を使用する。

```html
<ul>
  <li th:each="message : ${errors.globalMessages}" th:text="${message}"></li>
</ul>
```

**全メッセージの表示**

`ErrorMessages#getAllMessages()` を使用する。

```html
<ul>
  <li th:each="message : ${errors.allMessages}" th:text="${message}">エラーメッセージ</li>
</ul>
```

<details>
<summary>keywords</summary>

ErrorMessages, nablarch.fw.web.message.ErrorMessages, hasError, getMessage, getGlobalMessages, getAllMessages, バリデーションエラーメッセージ表示, Thymeleafエラー表示, プロパティエラーメッセージ, グローバルメッセージ

</details>
