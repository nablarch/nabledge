# ■Domaのロガーを5u12までと同じ動作にする方法

5u13からDomaのロガーとしてNablarchJdbcLoggerを提供するようになりました。
デフォルトではこのNablarchJdbcLoggerが使われます。
5u12まではjava.util.loggingパッケージを使ったロギングを行うorg.seasar.doma.jdbc.UtilLoggingJdbcLoggerが使われていました(ログレベルはFINE)。
5u12までと同じ設定にしたい場合、次の手順に従って、コンポーネント定義を追加してください。
1. UtilLoggingJdbcLoggerのインスタンスを生成するComponentFactoryを実装する
2. コンポーネント定義に1を設定する
1のコード例です:
package com.example;
import java.util.logging.Level;
import org.seasar.doma.jdbc.JdbcLogger;
import org.seasar.doma.jdbc.UtilLoggingJdbcLogger;
import nablarch.core.repository.di.ComponentFactory;
public class JdbcLoggerFactory implements ComponentFactory<JdbcLogger> {
@Override
public JdbcLogger createObject() {
return new UtilLoggingJdbcLogger(Level.FINE);
}
}
2の設定例です:
<component class="com.example.JdbcLoggerFactory" name="domaJdbcLogger" />
