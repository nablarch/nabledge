# JSP/HTML作成ガイド

## 業務画面JSP作成フロー

業務画面JSPはブラウザで開くことで画面遷移を含む動作確認が可能。画面に表示された項目からシステム機能設計書の項目定義を生成できる。なお、PG/UT工程でサーバサイド処理に必要な情報が追加され、本番環境で動作する業務画面JSPとなる。

![業務画面JSP作成フロー](../../../knowledge/component/ui-framework/assets/ui-framework-guide/create_jsp.png)

<details>
<summary>keywords</summary>

業務画面JSP, UI開発基盤, 動作確認, 画面遷移, 項目定義生成

</details>

## 業務画面JSP作成に利用する開発環境

ブラウザでの動作確認には、指定されたディレクトリ構造でファイルを配置する必要がある（[widget_usage/project_structure](ui-framework-project_structure.md)）。

業務画面JSPの作成にはIDE（統合開発環境）の利用を推奨（[widget_usage/develop_environment](ui-framework-develop_environment.md)）。

Eclipseのテンプレートを導入することで、より効率的な開発が可能（:doc:`widget_usage/template_list.rst`）。

<details>
<summary>keywords</summary>

ディレクトリ構造, IDE, Eclipse, 統合開発環境, テンプレート, project_structure, develop_environment, template_list

</details>

## 業務画面JSPの作成方法

業務画面テンプレートとUI部品（JavaScript、ウィジェット）を利用して業務画面JSPを作成する（[widget_usage/create_with_widget](ui-framework-create_with_widget.md)）。

<details>
<summary>keywords</summary>

業務画面テンプレート, UI部品, ウィジェット, JavaScript, create_with_widget

</details>

## 画面項目定義一覧の作成方法

作成した業務画面JSPから、システム機能設計書に貼り付ける画面項目定義を作成できる（[widget_usage/create_screen_item_list](ui-framework-create_screen_item_list.md)）。

<details>
<summary>keywords</summary>

画面項目定義, システム機能設計書, create_screen_item_list

</details>

## フォームクラスの自動生成方法

作成した業務画面JSPから、サーバサイド実装時に使用するフォームクラスのJavaソースコードを自動生成できる（[widget_usage/generating_form_class](ui-framework-generating_form_class-widget_usage.md)）。

<details>
<summary>keywords</summary>

フォームクラス, 自動生成, Javaソースコード, generating_form_class

</details>
