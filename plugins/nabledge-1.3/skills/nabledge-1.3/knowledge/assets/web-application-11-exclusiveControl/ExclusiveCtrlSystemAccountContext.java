package nablarch.sample.exclusive;

import nablarch.common.exclusivecontrol.ExclusiveControlContext;

/**
 * システムアカウント排他制御の制御クラス。
 * @author Kiyohito Itoh
 * @since 1.1
 */
public class ExclusiveCtrlSystemAccountContext extends ExclusiveControlContext {

    /**
     * 主キー定義。
     * @author Kiyohito Itoh
     * @since 1.1
     */
    private enum PK {
        USER_ID
    }
    
    /**
     * コンストラクタ。
     * @param userId ユーザID
     */
    public ExclusiveCtrlSystemAccountContext(String userId) {
        setTableName("SYSTEM_ACCOUNT");
        setVersionColumnName("VERSION");
        setPrimaryKeyColumnNames(PK.values());
        appendCondition(PK.USER_ID, userId);
    }
}
