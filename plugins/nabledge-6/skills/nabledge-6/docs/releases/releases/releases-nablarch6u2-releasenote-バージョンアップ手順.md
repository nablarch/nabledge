# ■バージョンアップ手順

本リリースの適用手順は、次の通りです。  
・5系からバージョンアップする場合  
解説書の「Nablarch 5から6への移行ガイド」をご参照ください。  
https://nablarch.github.io/docs/6u2/doc/migration/index.html  
・6u1からバージョンアップする場合  
No  適用手順  
1  pom.xmlの<dependencyManagement>セクションに指定されているnablarch-bomのバージョンを6u2に書き換える  
2  Micrometerアダプタを利用しており、pom.xmlの<dependencies>に以下が指定されている場合、バージョンを1.13.0に書き換える  
・micrometer-registry-datadog  
・micrometer-registry-cloudwatch2  
・micrometer-registry-statsd  
3  mavenのビルドを再実行する
