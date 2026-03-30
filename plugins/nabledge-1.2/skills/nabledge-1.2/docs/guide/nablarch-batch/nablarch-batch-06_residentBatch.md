# 常駐バッチ

## 常駐バッチ

常駐バッチの実装方法は都度実行バッチと同じ。実行タイミングのみ異なる。

| 形態 | 実行タイミング例 | 説明 |
|---|---|---|
| 都度起動バッチ | 月次 | 毎月月末にジョブスケジューラから起動される |
| 常駐バッチ | １時間毎 | 起動後は自律的に一定間隔毎に処理を実行する |

**クラス**: `nablarch.fw.handler.ProcessResidentHandler` をハンドラキューに追加することで常駐化できる。

```xml
<component class="nablarch.fw.handler.ProcessResidentHandler">
  <!-- データ監視間隔(ms) -->
  <property name="dataWatchInterval" value="3600000" />
</component>
```

<details>
<summary>keywords</summary>

ProcessResidentHandler, dataWatchInterval, 常駐バッチ, プロセス常駐化ハンドラ, ハンドラキュー設定, 都度起動バッチ

</details>
