# メッセージ分割

## ★nablarch.core.validation.ee.Length

### ①min属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Length.min.message

#### 例: {min}文字以上で入力してください。

### ②max属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Length.max.message

#### 例: {max}文字以内で入力してください。

### ③min属性とmax属性に同じ値を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Length.fixed.message

#### 例: {max}文字で入力してください。

#### ※{max}の箇所は、{min}でも同じメッセージとなる。

### ④min属性とmax属性に異なる値を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Length.min.max.message

#### 例: {min}文字以上、{max}文字以内で入力してください。

## ★nablarch.core.validation.ee.Digits

### ①integer属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Digits.integer.message

#### 例:整数部は{integer}桁以内で入力してください。

### ②fraction属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Digits.fraction.message

#### 例:小数部は{fraction}桁以内で入力してください。

### ③integer、fraction属性の両方を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Digits.message

#### 例:整数部は{integer}桁以内、小数部は{fraction}桁以内で入力してください。

## ★nablarch.core.validation.ee.NumberRange

### ①min属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.NumberRange.min.message

#### 例:{min}以上で入力してください。

### ②max属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.NumberRange.max.message

#### 例:{max}以下で入力してください。

### ③min,max属性の両方を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.NumberRange.min.max.message

#### 例:{min}以上{max}以下で入力してください。

## ★nablarch.core.validation.ee.DecimalRange

### ①min属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.DecimalRange.min.message

#### 例:{min}以上で入力してください。

### ②max属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.DecimalRange.max.message

#### 例:{max}以下で入力してください。

### ③min,max属性の両方を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.DecimalRange.min.max.message

#### 例:{min}以上{max}以下で入力してください。

## ★nablarch.core.validation.ee.Size

### ①min属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Size.min.message

#### 例:{min}以上で入力してください。

### ②max属性のみを指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Size.max.message

#### 例:{max}以下で入力してください。

### ③min,max属性の両方を指定した場合のメッセージ

#### メッセージ識別子(メッセージID):nablarch.core.validation.ee.Size.min.max.message

#### 例:{min}以上{max}以下で入力してください。
