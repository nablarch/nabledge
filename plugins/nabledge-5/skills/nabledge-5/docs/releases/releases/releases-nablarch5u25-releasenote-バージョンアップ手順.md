# ■バージョンアップ手順

本リリースの適用手順は、次の通りです。  
No  適用手順  
1  pom.xmlの<dependencyManagement>セクションに指定されているnablarch-bomのバージョンを5u25に書き換える  
2  Micrometerアダプタを利用しており、pom.xmlの<dependencies>に以下が指定されている場合、バージョンを1.13.0に書き換える  
・micrometer-registry-datadog  
・micrometer-registry-cloudwatch2  
・micrometer-registry-statsd  
3  mavenのビルドを再実行する
