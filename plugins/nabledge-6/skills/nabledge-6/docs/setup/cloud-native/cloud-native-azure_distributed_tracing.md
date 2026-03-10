# Azureにおける分散トレーシング

## Azureで分散トレーシングを行う方法

AzureではAzure Application Insightsを使用して分散トレーシングを行う。Javaアプリケーションからの有効化には**Java 3.0 エージェント**（コード不要）を使用する。

> **重要**: Java 3.0 エージェントは初期化処理中に大量のjarファイルをロードするためGCが頻発する。アプリケーション起動後しばらくは性能が一時的に劣化する可能性がある。また、高負荷時はエージェントの処理によるオーバーヘッドが性能に影響する可能性があるため、性能試験では本番同様にJava 3.0 エージェントを導入し、想定内の性能になることを確認すること。

コンテナ用アーキタイプを使用した場合のセットアップ手順:

1. [Azureの公式サイト](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/opentelemetry-enable?tabs=java#install-the-client-library)からエージェントをダウンロードし、`src/main/jib`以下の任意のディレクトリに格納する。
2. エージェントを格納したディレクトリに`applicationinsights.json`を配置する。`connectionString`にはAzure Application Insightsの**リソースを作成したあとに発行される**インストルメンテーションキーを含む接続文字列を指定する。その他の構成オプションは[ガイド](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/java-standalone-config)を参照。
3. `pom.xml`の`jib-maven-plugin`に環境変数`CATALINA_OPTS`としてエージェントのパスを指定する。

`applicationinsights.json`:
```json
{
  "connectionString": "InstrumentationKey=XXXXX"
}
```

`pom.xml`（`jib-maven-plugin`）:
```xml
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <configuration>
        <container>
            <appRoot>/usr/local/tomcat/webapps/ROOT</appRoot>
            <ports>
                <port>8080</port>
            </ports>
            <environment>
                <CATALINA_OPTS>-javaagent:/applicationInsights/applicationinsights-agent-3.0.2.jar</CATALINA_OPTS>
            </environment>
        </container>
    </configuration>
</plugin>
```
