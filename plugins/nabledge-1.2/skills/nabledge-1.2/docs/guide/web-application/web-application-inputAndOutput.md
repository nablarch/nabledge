# フォーム内の入力要素を出力するカスタムタグ

本フレームワークでは、Form内の各入力要素(<input>, <textarea>, <select>) に対応する、下記のタグを提供している。
以下では、これらのタグについて具体例を交えながら、その使用方法について解説する。

| カスタムタグ | 出力するHTMLタグ |
|---|---|
| textタグ | inputタグ(type=text) |
| textareaタグ | textareaタグ |
| passwordタグ | inputタグ(type=password) |
| hiddenタグ | inputタグ(type=hidden) |
| radioButtonタグ | inputタグ(type=radio) |
| checkboxタグ | inputタグ(type=checkbox) |
| compositeKeyRadioButtonタグ | inputタグ(type=radio) ※ 複合キーを使用する場合 |
| compositeKeyCheckboxタグ | inputタグ(type=checkbox) ※ 複合キーを使用する場合 |
| selectタグ | selectタグ ※ List型変数の各要素ごとにoptionタグを出力する。 |
| radioButtonsタグ | 複数のinputタグ(type=radio) ※ List型変数の各要素ごとにラジオボタンを出力する。 |
| checkboxesタグ | 複数のinputタグ(type=checkbox) ※ List型変数の各要素ごとにチェックボックスを出力する。 |

なお、詳細仕様については、 Application Framework解説書の
[入力要素を出力するカスタムタグ](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FormTagList.html#form_input)
についても参照すること。

## コード値の表示方法

本フレームワークでは、コード値を選択/表示するためのタグとして以下を提供する。
このうち、codeタグは表示用のカスタムタグであり、それ以外が選択項目のカスタムタグである。
本タグは、CODE_PATTERNテーブルとCODE_NAMEテーブルを使用する。

* codeSelectタグ
* codeRadioButtonsタグ
* codeCheckboxesタグ
* codeCheckboxタグ
* codeタグ

### codeSelectタグ

codeSelectタグは、HTMLのselectタグに対応している。
選択項目リストを取得するために、CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定する。

また、共通属性以外に以下の属性が使用できる。

| 属性 | 説明 |
|---|---|
| withNoneOption | リスト先頭に選択なしのオプションを追加するかどうか。 trueで追加する。 falseで追加しない。（デフォルト） |
| noneOptionLabel | 選択なしの場合にリスト先頭に追加するラベル。 withNoneOption="true"の場合のみ有効。 デフォルトは"" |

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】codeSelectタグの説明箇所以外は省略。 -->
  <select name="W11AF01.status">
      <option value="01">01:初期状態-初期-0002-01-ja</option>
      <option value="02">02:処理開始待ち-待ち-0002-02-ja</option>
  </select>
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 1 | 0 |
| 0002 | 02 | 0 | 1 | 0 |
| 0002 | 03 | 0 | 0 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 01:男性 |
| 0001 | 02 | 2 | ja | 女性 | 女 | 02:女性 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeSelectタグの説明箇所以外は省略。
        CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から、選択項目リストを作成する。
            1. codeId属性で指定したID
            2. CODE_PATTERNテーブルのうち、pattern属性で指定したカラム名の値が1
        pattern属性には、使用するパターンのカラム名を指定する。
        選択項目リストからラベルを出力するには、labelPattern属性を指定する。
        実装例では、ラベルパターンの指定で、CODE_NAMEテーブルから以下の値を使用している。
            $VALUE$：コード値（VALUE）
            $NAME$：コード名称（NAME）
            $SHORTNAME$：コード略称（SHORT_NAME）
            $OPTIONALNAME$：コードのオプション名称（OPTION01）
        $OPTIONALNAME$を使用するには、optionColumnName属性で、使用するカラム名を指定する必要がある。 --%>
  <n:codeSelect name="W11AF01.status"
                codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
                labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
                listFormat="div" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### codeRadioButtonsタグ

codeRadioButtonsタグは、HTMLの複数のinputタグ(type=radio)に対応している。
選択項目リストを取得するために、CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定する。

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】
        codeRadioButtonsタグの説明以外は省略。
        id属性は、以下の形式で自動で指定される。
        id属性の形式：nablarch_radio<連番> -->
  <input id="nablarch_radio1" type="radio" name="W11AF01.status" value="01" />
      <label for="nablarch_radio1">01:初期状態-初期-0002-01-ja</label><br />
  <input id="nablarch_radio2" type="radio" name="W11AF01.status" value="02" />
      <label for="nablarch_radio2">02:処理開始待ち-待ち-0002-02-ja</label><br />
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 1 | 0 |
| 0002 | 02 | 0 | 1 | 0 |
| 0002 | 03 | 0 | 0 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 01:男性 |
| 0001 | 02 | 2 | ja | 女性 | 女 | 02:女性 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeRadioButtonsタグの説明箇所以外は省略。
        CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から、選択項目リストを作成する。
            1. codeId属性で指定したID
            2. CODE_PATTERNテーブルのうち、pattern属性で指定したカラム名の値が1
        pattern属性には、使用するパターンのカラム名を指定する。
        選択項目リストからラベルを出力するには、labelPattern属性を指定する。
        実装例では、ラベルパターンの指定で、CODE_NAMEテーブルから以下の値を使用している。
            $VALUE$：コード値（VALUE）
            $NAME$：コード名称（NAME）
            $SHORTNAME$：コード略称（SHORT_NAME）
            $OPTIONALNAME$：コードのオプション名称（OPTION01）
        $OPTIONALNAME$を使用するには、optionColumnName属性で、使用するカラム名を指定する必要がある。 --%>
  <n:codeRadioButtons name="W11AF01.status"
                codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
                labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
                listFormat="div" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### codeCheckboxesタグ

codeCheckboxesタグは、HTMLの複数のinputタグ(type=checkbox)に対応している。
選択項目リストを取得するために、CODE_PATTERNテーブルとCODE_NAMEテーブルのIDとPATTERNを指定する。

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】
        codeCheckboxesタグの説明以外は省略。
        id属性は、以下の形式で自動で指定される。
        id属性の形式：nablarch_checkbox<連番> -->
  <input id="nablarch_checkbox1" type="checkbox" name="W11AF01.status" value="01" />
      <label for="nablarch_checkbox1">01:初期状態-初期-0002-01-ja</label><br />
  <input id="nablarch_checkbox2" type="checkbox" name="W11AF01.status" value="02" />
      <label for="nablarch_checkbox2">02:処理開始待ち-待ち-0002-02-ja</label><br />
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 1 | 0 |
| 0002 | 02 | 0 | 1 | 0 |
| 0002 | 03 | 0 | 0 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 01:男性 |
| 0001 | 02 | 2 | ja | 女性 | 女 | 02:女性 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeCheckboxesタグの説明箇所以外は省略。
        CODE_NAMEテーブルの中で、以下の条件を満たすIDを持つ行から、選択項目リストを作成する。
            1. codeId属性で指定したID
            2. CODE_PATTERNテーブルのうち、pattern属性で指定したカラム名の値が1
        pattern属性には、使用するパターンのカラム名を指定する。
        選択項目リストからラベルを出力するには、labelPattern属性を指定する。
        実装例では、ラベルパターンの指定で、CODE_NAMEテーブルから以下の値を使用している。
            $VALUE$：コード値（VALUE）
            $NAME$：コード名称（NAME）
            $SHORTNAME$：コード略称（SHORT_NAME）
            $OPTIONALNAME$：コードのオプション名称（OPTION01）
        $OPTIONALNAME$を使用するには、optionColumnName属性で、使用するカラム名を指定する必要がある。 --%>
  <n:codeCheckboxes name="W11AF01.status"
                codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
                labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
                listFormat="div" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### codeCheckboxタグ

codeCheckboxタグは、HTMLの単一のinputタグ(type=checkbox)に対応している。
codeCheckboxタグでは、使用するコード値のデータ件数に応じて、下記の属性を指定する。
コードIDに対応するコード値が2件の場合と、2件以上ある場合の実装例を下記に示す。

| 属性 | 説明 |
|---|---|
| value | XHTMLのvalue属性。 チェックありの場合に使用するコード値。 デフォルトは"1"。 |
| codeId(必須) | コードID。 |
| optionColumnName | 取得するオプション名称のカラム名。 |
| labelPattern | ラベルを整形するパターン。  プレースホルダを下記に示す。 $NAME$: コード値に対応するコード名称 $SHORTNAME$: コード値に対応するコードの略称 $OPTIONALNAME$: コード値に対応するコードのオプション名称 $OPTIONALNAME$を使用する場合は、optionColumnName属性の指定が必須となる。 $VALUE$: コード値  デフォルトは"$NAME$"。 |
| offCodeValue | チェックなしの場合に使用するコード値。 offCodeValue属性が指定されない場合は、 codeId属性の値からチェックなしの場合に使用するコード値を検索する。 検索結果が2件、かつ1件がvalue属性の値である場合は、 残りの1件をチェックなしのコード値として使用する。 |

#### コードIDに対応するコード値が2件の場合

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】
        codeCheckboxタグの説明以外は省略。
  
        許可、不許可の入力をチェックボックスにより実現する。
        許可と不許可に対応するコード値(2件)がテーブルに存在するものとする。
  
        id属性は、以下の形式で自動で指定される。
        id属性の形式：nablarch_checkbox<連番> -->
  <input id="nablarch_checkbox1" type="checkbox" name="W11AF01.canUpdate" value="1" />
      <label for="nablarch_checkbox1">許可</label>
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE |
|---|---|
| 0001 | 1 |
| 0001 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 1 | 1 | ja | 許可 | OK | 01:許可 |
| 0001 | 0 | 2 | ja | 不許可 | NG | 02:不許可 |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeCheckboxesタグの説明箇所以外は省略。
  
        value属性、labelPattern属性は、
        デフォルトの値(value:1、labelPattern:$NAME$)を使用する。 --%>
  <n:codeCheckbox name="W11AF01.canUpdate" codeId="0001" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

#### コードIDに対応するコード値が2件以上の場合

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】
        codeCheckboxタグの説明以外は省略。
  
        YES、NOの入力をチェックボックスにより実現する。
        YES、NOに加えて未設定に対応するコード値(3件)がテーブルに存在するものとする。 -->
  <input id="nablarch_checkbox1" type="checkbox" name="W11AF01.join" value="Y" />
      <label for="nablarch_checkbox1">YES(イエス)</label>
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE |
|---|---|
| 0002 | Y |
| 0002 | N |
| 0002 | Z |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0002 | Y | 1 | ja | はい | YES | イエス |
| 0002 | N | 2 | ja | いいえ | NO | ノー |
| 0002 | Z | 3 | ja | 未設定 | NOT SET | ノットセット |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeCheckboxタグの説明箇所以外は省略。
  
        コード値が2件以上存在するため、
        codeId属性から検索してもoffCodeValue属性が見つからない。
        このため、明示的にoffCodeValue属性を指定する必要がある。
        デフォルト値と異なるため、value属性も明示的に指定する。
        今回は、説明のためlabelPattern属性も指定する。 --%>
  <n:codeCheckbox name="W11AF01.join" codeId="0002"
                  value="Y" offCodeValue="N"
                  labelPattern="$SHORTNAME$($OPTIONALNAME$)"
                  optionColumnName="OPTION01" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

### codeタグ

codeタグは、指定したフォーマットにあわせてコード値を出力する。
詳細画面や一覧画面でコードの選択項目を表示する場合と、登録画面や更新画面で選択可能なコード値を一覧形式で表示する場合の実装例を下記に示す。

登録画面や更新画面で選択可能なコード値を表示する場合、通常codeSelectタグ、codeRadioButtonsタグ、codeCheckboxesタグ、codeCheckboxタグのいずれかを使用する。
しかし、選択可能なコード値を一覧表示し、テキストボックスに入力する仕様もありうる。
そのような場合の実装方法を [登録画面や更新画面で選択可能なコード値を一覧形式で表示する場合](../../guide/web-application/web-application-inputAndOutput.md#list-of-codes-searched-by-codeid-and-pattern) で説明する。

#### 詳細画面や一覧画面でコードの選択項目を表示する場合

出力するコード値を指定するために、Actionクラスでリクエストスコープにデータを設定する必要がある。

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】codeタグの説明以外は省略。 -->
  <div>02:処理開始待ち-待ち-0002-02-ja</div>
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 1 | 0 |
| 0002 | 02 | 0 | 1 | 0 |
| 0002 | 03 | 0 | 0 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 01:男性 |
| 0001 | 02 | 2 | ja | 女性 | 女 | 02:女性 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |

* Actionクラスの実装例

  ```java
  public class W11AC02Action {
      // 【説明】codeタグの説明箇所以外省略
      public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
  
          /* 【説明】
              codeタグで出力したい値を設定
              定数Batch.WAITINGが"02"を表すとする。 */
          W11AC02Form form = new W11AC02Form();
          form.setBatchStatus(Batch.WAITING);
          context.setRequestScopedVar("W11AC02", form);
  
          return new HttpResponse("/ss11AC/W11AC0201.jsp");
      }
  }
  ```
* JSPの実装例

  ファイル名：W11AC0201.jsp

  ```jsp
  <%-- 【説明】
        codeタグの説明箇所以外は省略。
        CODE_NAMEテーブルの中で、以下の条件を満たす行が、表示項目として選択される。
            1. codeId属性で指定したID
            2. CODE_PATTERNテーブルの中で、pattern属性で指定したカラム名の値が1
            3. VALUEカラムの値=name属性の参照値
        pattern属性には、使用するパターンのカラム名を指定する。
        選択項目リストからラベルを出力するには、labelPattern属性を指定する。
        実装例では、ラベルパターンの指定で、CODE_NAMEテーブルから以下の値を使用している。
            $VALUE$：コード値（VALUE）
            $NAME$：コード名称（NAME）
            $SHORTNAME$：コード略称（SHORT_NAME）
            $OPTIONALNAME$：コードのオプション名称（OPTION01）
        $OPTIONALNAME$を使用するには、optionColumnName属性で、使用するカラム名を指定する必要がある。 --%>
  <n:code name="W11AC02.batchStatus"
                codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
                labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
                listFormat="div" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

#### 登録画面や更新画面で選択可能なコード値を一覧形式で表示する場合

JSPにて指定されたcodeId属性、pattern属性のみの情報を元に表示するコード値を取得する。
そのため、Actionクラスでリクエストスコープにデータを設定する必要はない。

以下のHTMLを出力する実装例を示す。

* 想定するHTMLの出力例

  ```html
  <!-- 【説明】codeタグの説明以外は省略。 -->
  <div>01:初期状態-初期-0002-01-ja</div>
  <div>02:処理開始待ち-待ち-0002-02-ja</div>
  ```

実装例では、以下のテーブルを想定している。

* 想定しているCODE_PATTERNテーブル

| ID | VALUE | PATTERN1 | PATTERN2 | PATTERN3 |
|---|---|---|---|---|
| 0001 | 01 | 1 | 0 | 0 |
| 0001 | 02 | 1 | 0 | 0 |
| 0002 | 01 | 1 | 1 | 0 |
| 0002 | 02 | 0 | 1 | 0 |
| 0002 | 03 | 0 | 0 | 0 |

* 想定しているCODE_NAMEテーブル

| ID | VALUE | SORT_ORDER | LANG | NAME | SHORT_NAME | OPTION01 |
|---|---|---|---|---|---|---|
| 0001 | 01 | 1 | ja | 男性 | 男 | 01:男性 |
| 0001 | 02 | 2 | ja | 女性 | 女 | 02:女性 |
| 0002 | 01 | 1 | ja | 初期状態 | 初期 | 0002-01-ja |
| 0002 | 02 | 2 | ja | 処理開始待ち | 待ち | 0002-02-ja |
| 0002 | 03 | 3 | ja | 処理実行中 | 実行 | 0002-03-ja |

* JSPの実装例

  ```jsp
  <%-- 【説明】
        codeタグの説明箇所以外は省略。
        CODE_NAMEテーブルの中で、以下の条件を満たす行が、表示項目として選択される。
            1. codeId属性で指定したID
            2. CODE_PATTERNテーブルの中で、pattern属性で指定したカラム名の値が1
        name属性を記述しない。
        選択項目リストからラベルを出力するには、labelPattern属性を指定する。
        実装例では、ラベルパターンの指定で、CODE_NAMEテーブルから以下の値を使用している。
            $VALUE$：コード値（VALUE）
            $NAME$：コード名称（NAME）
            $SHORTNAME$：コード略称（SHORT_NAME）
            $OPTIONALNAME$：コードのオプション名称（OPTION01）
        $OPTIONALNAME$を使用するには、optionColumnName属性で、使用するカラム名を指定する必要がある。
  --%>
  <n:code codeId="0002" pattern="PATTERN2" optionColumnName="OPTION01"
          labelPattern="$VALUE$:$NAME$-$SHORTNAME$-$OPTIONALNAME$"
          listFormat="div" />
  ```

## 入力/選択項目での初期値設定

以下のように、入力フォームの入力/選択項目で初期値を設定する方法を示す。

* 入力フォームの初期値設定例

  ```html
  <!-- 【説明】入力/選択項目以外は省略 -->
  
  <!-- 【説明】テキストボックスの入力項目に、"sampleUser"が初期値として設定されている。 -->
  <input type="text" name="W11AC02.name" value="sampleUser" size="22" maxlength="20" />
  
  <!-- 【説明】セレクトボックスの選択項目に、"group2"と"group3"に対応するラベルが初期値として設定されている。 -->
  <select name="W11AC02.user.groupIds">
    <option value="group1">group1 - グループA</option>
    <option value="group2" selected="selected">group2 - グループB</option>
    <option value="group3" selected="selected">group3 - グループC</option>
    <option value="group4">group4 - グループD</option>
    <option value="group5">group5 - グループE</option>
  </select>
  ```

対象タグは以下の通り

* [フォーム内の入力要素を出力するカスタムタグ](../../guide/web-application/web-application-inputAndOutput.md#howto-single-input)
* [コード値の表示方法](../../guide/web-application/web-application-inputAndOutput.md#code-select)

入力/選択項目で初期値を設定する場合、
JSPへ遷移する前にActionクラスでリクエストスコープにデータを設定する必要がある。
その場合、カスタムタグの入力/選択項目のname属性で指定する値と、
アクションでリクエストスコープに初期値を設定する際に使用する名前を合わせる。
また、JSPでは処理を追加する必要は無いので、
初期値設定が無い場合と同じコードを書けばよい。

実装例として、 **登録画面** と **更新画面** での **単一項目** の初期値設定、 **複数選択項目** の初期値設定を以下に示す。

**登録画面の例**

Mapを使用して初期値を設定できる。
この時、Mapのキーにプロパティ名を明示的に指定する必要がある。
Mapを使用して、Actionクラスで単一入力項目の初期値を設定する例を示す。

* Actionクラスの実装例

  ```java
  public class W11AC02Action {
  
      // 【説明】初期値の設定以外の箇所は省略
      public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
  
          /* 【説明】
              入力項目のname属性（"W11AC02.effectiveDateFrom"）に対する初期値の設定
              システム使用開始日付に、現在の日付を設定する。
              Mapを使用して初期値を設定するので、明示的にキーにプロパティ名を指定する。 */
          Map<String, String> map = new HashMap<String, String>();
          map.put("effectiveDateFrom", new Date());
          ctx.setRequestScopedVar("W11AC02", map);
  
          return new HttpResponse("/ss11AC/W11AC0201.jsp");
      }
  }
  ```
* JSPの実装例

  以下は、Actionで設定したデータとname属性の対応を説明するためのものである。
  初期値設定のために特に必要な実装は無い。

  ```jsp
  <%-- 【説明】
        入力項目以外は省略。
        W11AC02.effectiveDateFromの値が初期値（現在日付）として入力フォームに表示される。 --%>
  <n:text name="W11AC02.effectiveDateFrom" size="22" maxlength="20" />
  ```

**更新画面の例**

SqlRowやフォーム/エンティティを使用すると、Mapを使用せずに初期値を設定できる。
Mapを使用せずに、Actionクラスで単一入力項目の初期値を設定する例を示す。

* Actionクラスの実装例

  ```java
  public class W11AC03Action {
  
      // 【説明】初期値の設定以外の箇所は省略
      public HttpResponse doRW11AC0301(HttpRequest req, ExecutionContext ctx) {
  
          /* 【説明】
              リクエストに更新対象のプライマリキー(W11AC03.userId)が格納されているとする。
              フォームのプロパティとして取得したプライマリキーを使用して、更新対象のデータ（userInfo）を取得する。
              SqlResultSetの要素であるSqlRowにはプロパティ名が指定されているので、
              明示的にプロパティ名を指定する必要はない。
              そのため、SqlResultSetからSqlRowを取り出して、そのままリクエストに設定できる。 */
          ValidationContext<W11AC03Form> formCtx =
              ValidationUtil.validateAndConvertRequest("W11AC03", W11AC03Form.class, req, "selectUserInfo");
          W11AC03Form form = formCtx.createObject();
          CM311AC1Component component = new CM311AC1Component();
          SqlResultSet userInfo = component.selectUserInfo(form);
          ctx.setRequestScopedVar("W11AC03", userInfo.get(0));
  
          return new HttpResponse("/ss11AC/W11AC0301.jsp");
      }
  }
  ```
* JSPの実装例

  以下は、Actionで設定したデータとname属性の対応を説明するためのものである。
  初期値設定のために特に必要な実装は無い。

  ```jsp
  <%-- 【説明】
        入力項目以外は省略。
        user.nameの値が初期値として入力フォームに表示される。 --%>
  <n:text name="W11AC03.name" size="22" maxlength="20" />
  ```

**複数選択項目の例**

複数選択項目に初期値を設定する場合、初期値だけでなく、選択候補となる選択項目のリストもリクエストスコープに設定する必要がある。
実装例では、以下のテーブルからidとnameの組み合わせでデータを取得することを想定している。

* 想定しているUSER_GROUPSテーブル

  | id | name |
  |---|---|
  | group1 | グループA |
  | group2 | グループB |
  | group3 | グループC |
  | group4 | グループD |
  | group5 | グループE |
* Actionクラスの実装例

  ```java
  public class W11AC02Action {
  
      // 【説明】初期値の設定以外の箇所は省略
      public HttpResponse doRW11AC0201(HttpRequest req, ExecutionContext ctx) {
  
          /* 【説明】
              selectタグで初期値設定するための前処理
              USER_GROUPSテーブルからidとnameの組でデータを取得し、
              selectタグで使用する選択項目リストとして設定。 */
          CM311AC1Component component = new CM311AC1Component();
          SqlResultSet ugroupList = component.selectUserGroups();
          ctx.setRequestScopedVar("allGroups", ugroupList);
  
          // 【説明】選択項目のname属性（"W11AC02.groupIds"）に対する複数の初期値（"group2"と"group3"）の設定
          Map<String, String> form = new HashMap<String, String>();
          String[] defaultGroups = {"group2", "group3"};
          form.put("groupIds", defaultGroups);
          ctx.setRequestScopedVar("W11AC02", form);
  
          return new HttpResponse("/ss11AC/W11AC0301.jsp");
      }
  }
  ```
* JSPの実装例

  以下は、Actionで設定したデータとname属性の対応を説明するためのものである。
  初期値設定のために特に必要な実装は無い。

  ファイル名：W11AC0301.jsp

  ```jsp
  <%-- 【説明】
        選択項目以外は省略
        ActionでW11AC02.groupIdsに設定された"group2"と"group3"が初期値として選択される。
        選択される要素は、W11AC02.groupIdsに含まれる要素の値 = allGroups.idの値 となるラベル。 --%>
  <n:select name="W11AC02.groupIds" multiple="true"
         listName="allGroups" elementLabelProperty="name" elementValueProperty="id"
         elementLabelPattern="$VALUE$ - $LABEL$" listFormat="ul" />
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## 入力項目の確認画面用の出力

入力項目のカスタムタグを使用して、確認画面用の出力ができる。
確認画面でconfirmationPageタグを使い、入力画面にフォワードする。

入力項目タグは以下を参照。

* [フォーム内の入力要素を出力するカスタムタグ](../../guide/web-application/web-application-inputAndOutput.md#howto-single-input)
* [コード値の表示方法](../../guide/web-application/web-application-inputAndOutput.md#code-select)

詳細については、 Application Framework解説書の [入力項目の確認画面用の出力](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_FormTag.html#output-for-confirmation-page) を参照。

## エラーメッセージの表示、エラー項目のハイライト

本フレームワークでは、単項目精査エラーや業務エラーなどが発生したときの、エラーメッセージ表示のために以下のタグを提供する。

* errorsタグ
* errorタグ

また、エラーの原因となった入力項目をハイライト表示させる機能も提供している。
詳細については、 Application Framework解説書の [エラー表示](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_DisplayTag.html#outpu-for-error) を参照。

## メッセージの表示

国際化を行うアプリケーションにおいて1つのJSPファイルで多言語に対応する場合、
ユーザが選択した言語に応じて画面の文言を切り替える機能が必要となる。
本フレームワークでは、言語に応じた画面の文言切り替えのためにmessageタグを提供する。

messageタグは、メッセージ機能を使用して管理されているメッセージを表示する。
このため、メッセージ機能が管理するテーブルに言語毎の文言を準備することで、画面の文言切り替えが可能となる。

messageタグの実装例を下記に示す。
下記の実装例では、以下のテーブルを想定している。

* 想定しているメッセージテーブル

| メッセージID | 言語 | メッセージ |
|---|---|---|
| M7770001 | en | User Registration |
| M7770001 | ja | ユーザ登録 |
| M7770099 | en | Sample Application |
| M7770099 | ja | サンプルアプリケーション |
| M7770008 | en | {0}-{1} |
| M7770008 | ja | {0}-{1} |

* JSPの実装例

**スレッドコンテキストに設定されている言語に応じたメッセージを表示する場合**

```jsp
<%-- 【説明】
      messageId属性のみ指定する。 --%>
<n:message messageId="M7770001" />
```

```bash
# 【説明】スレッドコンテキストに設定された言語がenの場合。
User Registration

# 【説明】スレッドコンテキストに設定された言語がjaの場合。
ユーザ登録
```

**指定した言語に応じたメッセージを表示する場合**

```jsp
<%-- 【説明】
      language属性に言語を指定する。
      常にlanguage属性に指定された言語に応じたメッセージが出力される。 --%>
<n:message messageId="M7770001" language="ja" />
```

```bash
# 【説明】スレッドコンテキストに設定された言語がenの場合。
ユーザ登録

# 【説明】スレッドコンテキストに設定された言語がjaの場合。
ユーザ登録
```

**埋め込み文字をフォーマットして表示する場合**

```jsp
<%-- 【説明】
      JSP上で埋め込み文字を直接指定する場合はoption0～option9属性に指定すればよいが、
      埋め込み文字もメッセージ機能で管理されたリソースから取得する場合は下記の手順で行う。
      (1)var属性を指定してmessageタグを使用し埋め込み用の文言を取得する。
      (2)取得した埋め込み用の文言をoption0～option9属性に指定する。--%>

<%-- 【説明】メッセージID:M7770008の埋め込み用の文言を取得する。--%>
<n:message var="title" messageId="M7770001" />
<n:message var="appName" messageId="M7770099" />

<%-- 【説明】埋め込み用の文言をoption0属性、option1属性に設定する。--%>
<n:message messageId="M7770008" option0="${title}" option1="${appName}" />
```

```bash
# 【説明】スレッドコンテキストに設定された言語がenの場合。
User Registration-Sample Application

# 【説明】スレッドコンテキストに設定された言語がjaの場合。
ユーザ登録-サンプルアプリケーション
```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)

## 出力フォーマットの変更方法

日付や金額の値などをフォーマットして出力したい場合、writeタグやtextタグのvalueFormat属性を指定する。

詳細については、 Application Framework解説書の [値のフォーマット出力](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_DisplayTag.html#web-view-format) を参照。

## HTMLエスケープせずに値を出力する方法

HTMLエスケープを行わず値をそのまま出力したい場合、prettyPrintタグまたはrawWriteタグを使用する。

詳細については、Application Framework解説書の [HTMLエスケープせずに値を出力する方法](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_BasicRules.html#output-without-html-escape) を参照。

> **Warning:**
> 本機能は、HTMLのソースコードを表示したい場合など、HTMLエスケープをどうしても避けたい場合に使用する。
> それ以外の場合は、HTMLエスケープを行うこと。

## hiddenタグの暗号化機能の解除

hiddenタグの値を改ざん又は参照させないために、hiddenタグの暗号化機能を提供している。
本機能はデフォルトで使用されるため、使用しない場合はカスタムタグのデフォルト値を変更する必要がある。
（ [カスタムタグのデフォルト値の設定](../../../../fw/reference/02_FunctionDemandSpecifications/03_Common/07/07_HowToSettingCustomTag.html#webview-customtagconfig) 参照)

リポジトリへの登録例を以下に示す。

* hiddenタグの暗号化機能を解除する設定例

  ファイル名：tag.xml

  ```xml
  <!-- 【説明】暗号化機能の設定以外は省略 -->
  <component name="customTagConfig"
             class="nablarch.common.web.tag.CustomTagConfig">
      <!-- 【説明】
            hiddenタグの暗号化機能の設定。
             useHiddenEncryption="true"で暗号化を行う。（デフォルト）
             useHiddenEncryption="false"で暗号化を行わない。 -->
      <property name="useHiddenEncryption" value="false" />
  </component>
  ```

( [記載しているサンプルプログラムソースコードの注意事項](../../about/about-nablarch/about-nablarch-aboutThis.md#sourcecode) 参照)
