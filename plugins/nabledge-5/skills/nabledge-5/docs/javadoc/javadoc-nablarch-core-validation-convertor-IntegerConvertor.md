# class IntegerConvertor

**パッケージ:** nablarch.core.validation.convertor

**継承階層:**
```
java.lang.Object
  └─ NumberConvertorSupport
      └─ nablarch.core.validation.convertor.IntegerConvertor
```

---

```java
public class IntegerConvertor
extends NumberConvertorSupport
```

値をIntegerに変換するクラス。</br>

本クラスで変換するプロパティには、必ずDigitsアノテーションを付与しておく必要がある。
本クラスでは、Digitsアノテーションの属性を下記の通り使用する。</br>
<table border=1>
    <tr bgcolor="#cccccc">
        <td>Digitsアノテーションの属性名</td><td>説明</td>
    </tr>
    <tr>
        <td>integer</td><td>整数部桁数上限値。10以上の数値を指定できない。</td>
    </tr>
    <tr>
        <td>fraction</td><td>小数部桁数上限値。0のみ指定可能。</td>
    </tr>
    <tr>
        <td>commaSeparated</td><td>trueの場合、入力値が3桁区切り文字で編集されていてもよい。（区切り文字は省略可。）
        　　　　　　　　　　　　　</br>falseの場合、入力値が3桁区切り文字で編集されていてはいけない。</td>
    </tr>
    <tr>
        <td>messageId</td><td>変換失敗時のメッセージID。</td>
    </tr>
</table>

<p>
<b>バリデーション仕様</b>
<p>
Digitsアノテーションの設定によって行われるバリデーション仕様の例を以下に示す。</br>
<p>
桁数指定の設定とバリデーション内容：</br>
integer=4の場合、「1234」、「-1234」等は有効であるが、「12345」等は無効であり、バリデーションエラーとなる。<br/>
<p>
カンマ編集可否の設定とバリデーション内容：</br>
commaSeparatedがtrueの場合、「1,234」、「1234,567」等は有効である。<br/>
「12,34」のようにカンマを3桁の区切り文字として使用していない場合は無効でありバリデーションエラーとなる。</br>
commaSeparatedがfalseの場合、「1,234」等は無効であり、バリデーションエラーとなる。
</br>
<p>
上記例のように、本クラスのバリデーションでは {@link NumberConvertorSupport} が行う共通バリデーションに加えて、下記仕様のバリデーションを行う。
<ul>
    <li>先頭が数字、マイナス記号( - )のいずれかで始まっていること。</li>
    <li>整数部の桁数が、Digitsアノテーションにて指定されたinteger値以下であること。</li>
    <li>DigitsアノテーションのcommaSeparatedがfalseの場合、カンマが使用されていないこと。</li>
    <li>DigitsアノテーションのcommaSeparatedがtrueの場合、カンマが3桁区切りに付与されている、またはカンマを設定していないこと。</li>
    <li>小数部がないこと。（つまり、ピリオド( . )が末尾も含めて使用されていないこと。）</li>
</ul>

<p>
<b>国際化</b>
<p>
数値の記述は、フランス語圏等、言語によっては数値を記載する際にカンマとピリオドの解釈を置き換えて使用する言語がある。</br>
Nablarchのカスタムタグで国際化機能を使用した場合、本クラスもカンマとピリオドの解釈を入れ替えて入力値を取り扱う。
以下に @Digits(integer=6, commaSeparated=true) を設定していた場合の例を示す。</br>
1) 言語に "ja" (日本語) が設定された場合。</br>
　123,456 ⇒ 123456 として解釈する</br>
　123.456 ⇒ バリデーションエラーとなる</br>
2) 言語に "fr" (フランス語) が設定された場合。</br>
　123,456 ⇒ バリデーションエラーとなる</br>
　123.456 ⇒ 123456 として解釈する</br>
</p>

**作成者:** Koichi Asano  
**関連項目:** Digits  
**関連項目:** NumberConvertorSupport  

---

## メソッドの詳細

### getTargetClass

```java
public Class<?> getTargetClass()
```

{@inheritDoc}

---

### convertToPropertyType

```java
protected Number convertToPropertyType(String numberString)
```

{@inheritDoc}

---

### createPattern

```java
protected Pattern createPattern(Digits digits, DecimalFormatSymbols symbols)
```

---

### checkDigit

```java
protected void checkDigit(Digits digit)
                throws IllegalArgumentException
```

Digitsの内容が、コンバータで対応可能な値であることをチェックする。

**パラメータ:**
- `digit` - バリデーション対象の数値フォーマット

**例外:**
- `IllegalArgumentException` - 整数部または、小数部の桁数が不正な場合

---
