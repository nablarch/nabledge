# メール送信の設定変更内容

### ●送信要求のステータス更新のフローの変更

### 送信ステータスの更新失敗(データベースエラーやネットワーク障害など)の際の二重送信防止のため、処理フローを以下のとおり変更しました。

●変更前  ●変更後

送信ステータスの更新失敗(DB更新失敗)が発生した場合、  送信ステータスの更新失敗(DB更新失敗)が発生した場合、

メールが二重送信されていた。  パッチを適用する必要がある。

### 変更後、送信ステータスの更新失敗(DB更新失敗)が発生した場合は、障害ログに以下のログが出力され、メール送信バッチは異常終了する。

### Failed to update unsent status. Need to apply a patch to change the status to failure. mailRequestId=[<リクエストID>]

### このログを検出した場合は、該当送信要求の送信ステータスを「送信失敗」にする必要がある。

### ●コンポーネント定義ファイルの変更

### 変更後の送信ステータスの更新は別トランザクションで実行されるため、以下の設定が必須となる。

### ステータス更新用のトランザクションの設定

#### "statusUpdateTransaction"という名前のトランザクションを管理するコンポーネントを定義する必要がある。

### 設定例）

#### <!-- ステータス更新用のトランザクション -->

#### <component name="statusUpdateTransaction" class="nablarch.core.db.transaction.SimpleDbTransactionManager">

#### <property name="dbTransactionName" value="statusUpdateTransaction" />

#### <property name="connectionFactory" ref="connectionFactory" />

#### <property name="transactionFactory" ref="jdbcTransactionFactory" />

#### </component>
