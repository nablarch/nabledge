# class BinaryUtil

**パッケージ:** nablarch.core.util

---

```java
public final class BinaryUtil
```

バイナリ操作用ユーティリティクラス

**作成者:** T.Kawasaki  

---

## コンストラクタの詳細

### BinaryUtil

```java
private BinaryUtil()
```

コンストラクタ。<br/>
本クラスはインスタンス化できない。

---

## メソッドの詳細

### convertToBytes

```java
public static byte[] convertToBytes(String original, int length, Charset encoding)
```

引数で与えられた文字列をバイト列に変換し、引数のバイト長に満たない場合、右側0x00埋めを行う。
<p/>
引数が16進数文字列である場合は、16進数をビット列と見なしバイト列に変換して返却する。
<p/>
変換処理の仕様は{@link #convertToBytes(String, Charset)}を参照すること。
<p/>

**パラメータ:**
- `original` - 文字列
- `length` - バイト長
- `encoding` - 文字エンコーディング(引数が16進数文字列である場合は使用されない)

**戻り値:**
バイト列

**例外:**
- `NumberFormatException` - 引数が"0x"から開始しており、かつ16進数文字列として成立していない場合

---

### convertToHexString

```java
public static String convertToHexString(byte[] bytes)
```

バイト配列を16進数文字列に変換する。
<p/>
引数がnullや空文字である場合の挙動は以下となる。
<ul>
    <li>引数で与えられたバイト列がnullである場合は、"null"という文字列を返却する</li>
    <li>引数で与えられたバイト列の長さが0である場合は、空文字を返却する</li>
</ul>

**パラメータ:**
- `bytes` - バイト配列

**戻り値:**
16進数文字列

---

### convertToHexStringWithPrefix

```java
public static String convertToHexStringWithPrefix(byte[] bytes)
```

バイト配列を16進数文字列に変換する。
<p/>
変換後の文字列には"0x"が先頭に付加される。
<p/>
引数で与えられたバイト列がnullであるか長さが0である場合、空文字を返却する。

**パラメータ:**
- `bytes` - バイト配列

**戻り値:**
16進数文字列

---

### convertToBytes

```java
public static byte[] convertToBytes(String original, Charset encoding)
                      throws NumberFormatException
```

引数で与えられた文字列をバイト列に変換する。
<p/>
引数で与えられた文字列がnullか空の場合は、長さ0のバイト列を返却する。
<p/>
引数が16進数として解釈可能な場合((0x[0-9A-F]+)に適合する場合)は以下の処理を行う。
<ul>
    <li>16進数をビット列と見なし、バイト列に変換して返却する。</li>
    <li>
        16進数文字列として成立していない場合(original.matches("0x[0-9A-F].")が成立しない場合)
        NumberFormatExceptionを送出する。具体例を以下に示す。
        <ul>
            <li>"0x"のみの文字列</li>
            <li>"0xあああ"</li>
        </ul>
   </li>
</ul>
引数が16進数として解釈できない場合は以下の処理を行う。
<ul>
    <li>文字列全体を引数で指定した文字セットでエンコーディングし、バイト列に変換して返却する</li>
</ul>
</p>

**パラメータ:**
- `original` - 16進数文字列（0x[0-9A-F]+）
- `encoding` - 文字エンコーディング(引数が16進数文字列である場合は使用されない)

**戻り値:**
バイト列

**例外:**
- `NumberFormatException` - 引数が"0x"から開始しておりかつ16進数文字列として成立していない場合

---

### convertHexToBytes

```java
public static byte[] convertHexToBytes(String hexString)
```

16進数文字列をバイト列に変換する。
<p/>
引数の文字列が以下の条件に当てはまる場合{@link NumberFormatException}を送出する。
<ul>
    <li>文字列がnullや空文字である場合</li>
    <li>（[0-9A-F]+）に当てはまらない場合</li>
    <li>16進数文字列であるが、先頭が"0x"で開始している場合。
        "0x"で開始する16進数文字列を変換する場合は{@link #convertToBytes(String, Charset)}を利用すること。</li>
</ul>
<p/>

**パラメータ:**
- `hexString` - 16進数文字列（[0-9A-F]+）

**戻り値:**
バイト配列

**例外:**
- `NumberFormatException` - 16進数文字列として成立していない場合、
                               文字列がnullか空文字である場合

---

### fillZerosRight

```java
public static byte[] fillZerosRight(byte[] orig, int length)
```

右側0詰めを行う。<br/>
ただし、以下の場合は0詰めを行わない。
<ul>
<li>元データ(orig)が0バイトの場合は、0バイトのバイト配列が返却される。</li>
<li>元データ(orig)の要素数が、バイト長(length)以上の場合、元データがそのまま返却される。</li>
</ul>

**パラメータ:**
- `orig` - 元データ
- `length` - バイト長

**戻り値:**
0詰め後のバイト列

---

### toByteArray

```java
public static byte[] toByteArray(InputStream inputStream)
```

入力ストリームをバイト配列に変換する。<br/>
引数であたえられた入力ストリームはクローズされる。

**パラメータ:**
- `inputStream` - 入力ストリーム

**戻り値:**
バイト配列

---
