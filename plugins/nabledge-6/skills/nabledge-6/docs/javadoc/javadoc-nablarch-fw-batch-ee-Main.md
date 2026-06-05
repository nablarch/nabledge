# class Main

**パッケージ:** nablarch.fw.batch.ee

---

```java
public final class Main
```

バッチアプリケーションのメインクラス
<p/>
実行引数として、対象JOBのXMLファイル名(.xmlを除いたファイル名)を指定する。
実処理は、{@link JobExecutor}に移譲しているため、詳細はそちらを参照。

**作成者:** T.Shimoda  

---

## コンストラクタの詳細

### Main

```java
private Main()
```

プライベートコンストラクタ

---

## メソッドの詳細

### main

```java
public static void main(String args)
```

メインメソッド。<br>
指定されたJOBのXMLファイル名を実行する。

**パラメータ:**
- `args` - 第一引数にJOBのXMLファイル名を指定すること。

**例外:**
- `IllegalArgumentException` - mainメソッドの引数の指定が正しくない場合

---

### toProperties

```java
private static Properties toProperties(String[] args)
```

コマンドライン引数をバッチ起動時に指定するパラメータに変換する。

**パラメータ:**
- `args` - コマンドライン引数

**戻り値:**
バッチ起動時に指定するパラメータ

---
