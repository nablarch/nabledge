# 使用不許可APIチェックツールの設定方法

使用不許可APIチェックツールの設定方法
SpotBugs 4.Xを利用する場合  SpotBugs 3.Xを利用する場合
<plugin>  <plugin>
<groupId>com.github.spotbugs</groupId>  <groupId>com.github.spotbugs</groupId>
<artifactId>spotbugs-maven-plugin</artifactId>  <artifactId>spotbugs-maven-plugin</artifactId>
<version>4.5.0.0</version>  <version>3.1.3</version>
<dependencies>  <dependencies>
<dependency>  <dependency>
<groupId>com.github.spotbugs</groupId>  <groupId>com.github.spotbugs</groupId>
<artifactId>spotbugs</artifactId>  <artifactId>spotbugs</artifactId>
<version>4.5.0</version>  <version>3.1.3</version>
</dependency>  </dependency>
</dependencies>  </dependencies>
<configuration>  <configuration>
<xmlOutput>true</xmlOutput>  <xmlOutput>true</xmlOutput>
<!-- チェックを除外するフィルターファイル -->  <!-- チェックを除外するフィルターファイル -->
<excludeFilterFile>spotbugs/spotbugs_exclude_for_production.xml</excludeFilterFile>  <excludeFilterFile>spotbugs/spotbugs_exclude_for_production.xml</excludeFilterFile>
<!-- 使用不許可APIチェックツールの設定ファイル -->  <!-- 使用不許可APIチェックツールの設定ファイル -->
<jvmArgs>-Dnablarch-findbugs-config=spotbugs/published-config/production</jvmArgs>  <jvmArgs>-Dnablarch-findbugs-config=spotbugs/published-config/production</jvmArgs>
<!-- ヒープサイズが足りない場合は増やすことも可能 -->  <!-- ヒープサイズが足りない場合は増やすことも可能 -->
<maxHeap>1024</maxHeap>  <maxHeap>1024</maxHeap>
<plugins>  <plugins>
<plugin>  <plugin>
<groupId>com.nablarch.framework</groupId>  <groupId>com.nablarch.framework</groupId>
<artifactId>nablarch-unpublished-api-checker</artifactId>  <artifactId>nablarch-unpublished-api-checker-findbugs</artifactId>
<version>1.0.0</version>  <version>1.0.0</version>
</plugin>  </plugin>
</plugins>  </plugins>
</configuration>  </configuration>
</plugin>  </plugin>
解説は以下参照。
https://github.com/nablarch-development-standards/nablarch-style-guide/blob/3.1/java/staticanalysis/spotbugs/docs/Maven-settings.md#spotbugs-maven-plugin%E3%82%92%E7%B5%84%E3%81%BF%E8%BE%BC%E3%82%80
