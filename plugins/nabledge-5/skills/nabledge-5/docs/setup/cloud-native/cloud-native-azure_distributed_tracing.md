# Azureにおける分散トレーシング

**公式ドキュメント**: [Azureにおける分散トレーシング](https://nablarch.github.io/docs/LATEST/doc/application_framework/application_framework/cloud_native/distributed_tracing/azure_distributed_tracing.html)

## Azureで分散トレーシングを行う方法

AzureではAzure Application Insightsを使用して分散トレーシングを行う。Javaアプリケーションでは**Java 3.0 エージェント**を使用して有効化する（コード不要）。

> **重要**: Java 3.0 エージェントは初期化処理中に大量のjarファイルをロードするため、GCが頻発し起動後しばらくは性能が一時的に劣化する可能性がある。高負荷時はエージェントの処理によるオーバーヘッドが性能に影響する可能性もある。**性能試験では本番同様にJava 3.0 エージェントを導入し、想定内の性能になることを確認すること。**

1. [Azureの公式サイト](https://learn.microsoft.com/ja-jp/azure/azure-monitor/app/opentelemetry-enable?tabs=java#install-the-client-library)からエージェントをダウンロードし、`src/main/jib` 以下の任意のディレクトリに格納する。
2. エージェントを格納したディレクトリに `applicationinsights.json` を配置する。`connectionString` にはAzure Application Insightsの**リソースを作成したあとに発行される**インストルメンテーションキーを含む接続文字列を指定する。

   ```json
   {
     "connectionString": "InstrumentationKey=XXXXX"
   }
   ```

3. `pom.xml` の `jib-maven-plugin` に環境変数 `CATALINA_OPTS` を追加し、エージェントのパスを指定する。

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

<details>
<summary>keywords</summary>

Azure Application Insights, Java 3.0 エージェント, 分散トレーシング, applicationinsights.json, connectionString, jib-maven-plugin, CATALINA_OPTS, src/main/jib, GC性能劣化, コンテナ

</details>
