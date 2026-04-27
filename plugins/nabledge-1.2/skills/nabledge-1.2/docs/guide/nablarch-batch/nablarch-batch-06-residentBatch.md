# 常駐バッチ

常駐バッチの場合でも、アプリケーション実装方法は都度実行バッチと全く同じである。
実行タイミングが異なるだけで、本質的な処理は全く同じである。

ユーザ情報削除バッチを例に説明すると、このバッチは都度起動バッチとしても常駐バッチとしても使用できる。

| 形態 | 実行タイミング例 | 説明 |
|---|---|---|
| 都度起動バッチ | 月次 | 毎月月末にジョブスケジューラから起動される |
| 常駐バッチ | １時間毎 | 起動後は自律的に一定間隔毎に処理を実行する |

どちらにせよ、 **「有効期限切れユーザを削除する」** という処理の本質には全く変わりはない。

コンポーネント設定ファイルにて、ハンドラキューにプロセス常駐化ハンドラを追加することにより、
バッチを常駐化させることができる。

```xml
<!-- ハンドラキュー構成 -->
<list name="handlerQueue">
  <!-- 中略 -->
  <component class="nablarch.fw.handler.ProcessResidentHandler">
  <!-- データ監視間隔(ms) -->
    <property name="dataWatchInterval" value="3600000" />
  </component>
  <!-- 中略 -->
</list>
```

> **Note:**
> 都度実行バッチと常駐バッチの違いについては、
> [バッチ処理におけるリクエスト単体テスト](../../development-tools/testing-framework/testing-framework-01-UnitTestOutline.md#batch-request-unit-test-outline) も参照されたい。
