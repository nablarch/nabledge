# フォーマッタ機能の拡張

本サンプルで提供するフォーマッタ機能の仕様を解説する。

フォーマッタ機能の概要、基本となる汎用データフォーマット機能に関する詳細は、Nablarch Application Framework解説書の汎用データフォーマット機能に関する解説を参照すること。

## 提供パッケージ

本機能は、下記のパッケージで提供される。

*please.change.me.* **core.dataformat**

*please.change.me.* **core.dataformat.converter**

## KeyValueデータフォーマッタ

KeyValue形式のデータを取り扱うKeyValueデータフォーマッタについて解説する。

KeyValueデータフォーマッタはapplication/x-www-form-urlencodedで使用されるデータを取り扱う。
このデータはname1=value1&name2=value2のように、名前と値の組を等号でつなげたものをアンド記号で結んで表現される。
同一のキーで複数の値を扱うこともできる。

値についてURLエンコードを行う。キーについては汎用データフォーマットのフォーマット定義書式に従いURLエンコードは行わず、使用不可とする。

以下に本機能で使用するクラス一覧を記す。

| パッケージ名 | クラス名 | 概要 |
|---|---|---|
| *please.change.me.* **core.dataformat** | KeyValueDataFormatterFactory | フォーマッタファクトリクラス。 サンプル実装ではcreateFormatter(String fileType, String formatFilePath)メソッドをオーバーライドし、KeyValueDataRecordFormatterのインスタンス生成を可能としている。 |
| *please.change.me.* **core.dataformat** | KeyValueDataRecordFormatter | フォーマッタクラス。 KeyValue形式のデータを解析、構築する。 サンプル実装では読み込み時はパラメータの出現順を意識せず、書き込み時はフォーマット定義順でパラメータを出力する。 |
| *please.change.me.* **core.dataformat.converter** | KeyValueDataConvertorFactory | データコンバータのファクトリクラス。 デフォルトのコンバータ名とコンバータ実装クラスの対応表を保持する。 |
| *please.change.me.* **core.dataformat.converter** | KeyValueDataConvertorSetting | コンバータの設定情報を保持するクラス。 コンバータ名とコンバータ実装クラスの対応表を、DIコンテナから設定する。 |

## 使用方法

### KeyValueデータフォーマッタの使用方法

業務アプリケーションで作成したフォーマッタファクトリクラスを使用する場合、以下の設定を行う必要がある。

```xml
<component name="formatterFactory" class="please.change.me.core.dataformat.KeyValueDataFormatterFactory"/>
```

### フィールドタイプ・フィールドコンバータ定義一覧

KeyValueデータフォーマッタで使用されるフィールドタイプ・フィールドコンバータについて解説する。

**フィールドタイプ**

| タイプ識別子 | Java型 | 内容 |
|---|---|---|
| X、N、XN、X9、SX9 | String | KeyValueデータ形式では、すべてのフィールドを文字列（String）として読み書きする。 よって、どのタイプ識別子を指定しても動作は変わらない。 また、フィールド長の概念が無いので、引数は不要である。 もしNumber型（BigDecimalなど）のデータを読み書きしたい場合は、後述のnumber/signed_numberコンバータを使用すること。 |

いずれのタイプ識別子もフィールド長の概念が無いので、引数は不要である。

**フィールドコンバータ**

| コンバータ名 | Java型(変換前後) | 内容 |
|---|---|---|
| リテラル値 | Object <-> Object | **入力時:** (なにもしない) **出力時:** 出力する値が未設定であった場合に指定されたリテラル値を出力する。 **デフォルト実装クラス:** nablarch.core.dataformat.convertor.value.DefaultValue **引数:** なし |
| number | String <-> BigDecimal | **入力時:** 入力された値が符号なし数値であることを形式チェックした上でBigDecimal型に変換して、返却する。 もし入力された値がnullまたは空文字の場合、nullを返却する。 **出力時:** 出力する値を文字列に変換し、符号なし数値であることを形式チェックした上で出力する。 もし出力する値がnullの場合、空文字を出力する。  **デフォルト実装クラス:** nablarch.core.dataformat.convertor.value.NumberString **引数:** なし |
| signed_number | String <-> BigDecimal | 符号が許可される点以外は **number** コンバータと同じ仕様。 **デフォルト実装クラス:** nablarch.core.dataformat.convertor.value.SignedNumberString **引数:** なし |

### 同一キーで複数の値を取り扱う場合

同一キーで複数の値を取り扱う場合、データはString配列形式で保持される。
また、フォーマット定義ファイルにて多重度を設定する必要がある。
定義方法についてはNablarch Application Framework解説書の汎用データフォーマット機能を参照すること。
