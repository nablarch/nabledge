package nablarch.sample.ss11.entity;

import java.sql.Timestamp;
import java.util.Map;

import nablarch.common.validation.MailAddress;
import nablarch.core.db.statement.autoproperty.CurrentDateTime;
import nablarch.core.db.statement.autoproperty.UserId;
import nablarch.core.util.StringUtil;
import nablarch.core.validation.PropertyName;
import nablarch.core.validation.ValidateFor;
import nablarch.core.validation.ValidationContext;
import nablarch.core.validation.ValidationUtil;
import nablarch.core.validation.validator.Length;
import nablarch.core.validation.validator.NumberChar;
import nablarch.core.validation.validator.Required;
import nablarch.core.validation.validator.japanese.ZenkakuChar;
import nablarch.core.validation.validator.japanese.ZenkakuKatakanaChar;

/**
 * ユーザテーブルの情報を保持するクラス。
 *
 * @author Miki Habu
 * @since 1.0
 */
public class UsersEntity {

    /** ユーザID。 */
    private String userId;

    /** 漢字氏名。 */
    private String kanjiName;

    /** カナ氏名。 */
    private String kanaName;

    /** メールアドレス。 */
    private String mailAddress;

    /** 内線番号(ビル番号)。 */
    private String extensionNumberBuilding;

    /** 内線番号(個人番号)。 */
    private String extensionNumberPersonal;

    /** 携帯電話番号(市外)。 */
    private String mobilePhoneNumberAreaCode;

    /** 携帯電話番号(市内)。 */
    private String mobilePhoneNumberCityCode;

    /** 携帯電話番号(加入)。 */
    private String mobilePhoneNumberSbscrCode;

    /** 登録者ID。 */
    @UserId
    private String insertUserId;

    /** 登録日時。 */
    @CurrentDateTime
    private Timestamp insertDate;

    /** 更新者ID。 */
    @UserId
    private String updatedUserId;

    /** 更新日時。 */
    @CurrentDateTime
    private Timestamp updatedDate;

    /**
     * Mapを引数にとるコンストラクタ。
     *
     * @param params 項目名をキーとし、項目値を値とするMap。
     */
    public UsersEntity(Map<String, Object> params) {
        userId = (String) params.get("userId");
        kanjiName = (String) params.get("kanjiName");
        kanaName = (String) params.get("kanaName");
        mailAddress = (String) params.get("mailAddress");
        extensionNumberBuilding = (String) params.get("extensionNumberBuilding");
        extensionNumberPersonal = (String) params.get("extensionNumberPersonal");
        mobilePhoneNumberAreaCode = (String) params.get("mobilePhoneNumberAreaCode");
        mobilePhoneNumberCityCode = (String) params.get("mobilePhoneNumberCityCode");
        mobilePhoneNumberSbscrCode = (String) params.get("mobilePhoneNumberSbscrCode");
    }

    /** ユーザ登録時にバリデーションを省略するプロパティ。 */
    private static final String[] REGISTER_USER_SKIP_PROPS = {
        "userId", "insertUserId", "insertDate",
        "updatedUserId", "updatedDate"};

    /**
     * ユーザ登録時に実施するバリデーション。
     *
     * @param context バリデーションの実行に必要なコンテキスト
     */
    @ValidateFor({"registerUser", "sendUser"})
    public static void validateForRegisterUser(
            ValidationContext<UsersEntity> context) {
        // userIdを無視してバリデーションを実行
        ValidationUtil.validateWithout(context, REGISTER_USER_SKIP_PROPS);

        // 単項目精査でエラーの場合はここで戻る
        if (!context.isValid()) {
            return;
        }

        UsersEntity usersEntity = context.createObject();
        if (!usersEntity.isValidateMobilePhoneNumbers()) {
            context.addResultMessage("mobilePhoneNumber", "MSG00004");
        }
    }

    /** ユーザ更新時にバリデーションを省略するプロパティ */
    private static final String[] UPDATE_USER_SKIP_PROPS = {
        "userId", "insertUserId", "insertDate",
        "updatedUserId", "updatedDate"};

    /**
     * ユーザ更新時に実施するバリデーション。
     *
     * @param context バリデーションの実行に必要なコンテキスト
     */
    @ValidateFor("updateUser")
    public static void validateForUpdateUser(
            ValidationContext<UsersEntity> context) {
        // 更新画面で入力されないプロパティは無視
        ValidationUtil.validateWithout(context, UPDATE_USER_SKIP_PROPS);

        // 単項目精査でエラーの場合はここで戻る
        if (!context.isValid()) {
            return;
        }

        UsersEntity usersEntity = context.createObject();
        if (!usersEntity.isValidateMobilePhoneNumbers()) {
            context.addResultMessage("mobilePhoneNumber", "MSG00004");
        }
    }

    /**
     * 携帯電話番号の項目間精査を行う。<br/>
     * 一部のみ入力されている場合、精査エラー
     *
     * @return 精査OKの場合は、true
     */
    private boolean isValidateMobilePhoneNumbers() {
        return isMobilePhoneNumberEmpty() || isMobilePhoneNumberComplete();
    }

    /**
     * 携帯電話番号が全て未入力であるか判定する。
     * @return 全ての未入力の場合はtrue
     */
    private boolean isMobilePhoneNumberEmpty() {
        return StringUtil.isNullOrEmpty(mobilePhoneNumberAreaCode,
                mobilePhoneNumberCityCode,
                mobilePhoneNumberSbscrCode);
    }

    /**
     * 携帯電話番号が全て入力されているか判定する。
     * @return 全て入力されている場合はtrue
     */
    private boolean isMobilePhoneNumberComplete() {
        return StringUtil.hasValue(mobilePhoneNumberAreaCode)
                && StringUtil.hasValue(mobilePhoneNumberCityCode)
                && StringUtil.hasValue(mobilePhoneNumberSbscrCode);
    }

    /**
     * ユーザIDを取得する。
     *
     * @return ユーザID。
     */
    public String getUserId() {
        return userId;
    }

    /**
     * ユーザIDを設定する。
     *
     * @param userId 設定するユーザID。
     */
    @PropertyName("ユーザID")
    @Required
    @Length(min = 10, max = 10)
    @NumberChar
    public void setUserId(String userId) {
        this.userId = userId;
    }

    /**
     * 漢字氏名を取得する。
     *
     * @return 漢字氏名。
     */
    public String getKanjiName() {
        return kanjiName;
    }

    /**
     * 漢字氏名を設定する。
     *
     * @param kanjiName 設定する漢字氏名。
     */
    @PropertyName("漢字氏名")
    @Required
    @Length(max = 50)
    @ZenkakuChar
    public void setKanjiName(String kanjiName) {
        this.kanjiName = kanjiName;
    }

    /**
     * カナ氏名を取得する。
     *
     * @return カナ氏名。
     */
    public String getKanaName() {
        return kanaName;
    }

    /**
     * カナ氏名を設定する。
     *
     * @param kanaName 設定するカナ氏名。
     */
    @PropertyName("カナ氏名")
    @Required
    @Length(max = 50)
    @ZenkakuKatakanaChar
    public void setKanaName(String kanaName) {
        this.kanaName = kanaName;
    }

    /**
     * メールアドレスを取得する。
     *
     * @return メールアドレス。
     */
    public String getMailAddress() {
        return mailAddress;
    }

    /**
     * メールアドレスを設定する。
     *
     * @param mailAddress 設定するメールアドレス。
     */
    @PropertyName("メールアドレス")
    @Required
    @Length(max = 100)
    @MailAddress
    public void setMailAddress(String mailAddress) {
        this.mailAddress = mailAddress;
    }

    /**
     * 内線番号(ビル番号)を取得する。
     *
     * @return 内線番号(ビル番号)。
     */
    public String getExtensionNumberBuilding() {
        return extensionNumberBuilding;
    }

    /**
     * 内線番号(ビル番号)を設定する。
     *
     * @param extensionNumberBuilding 設定する内線番号(ビル番号)。
     */
    @PropertyName("内線番号(ビル番号)")
    @Required
    @Length(max = 2)
    @NumberChar
    public void setExtensionNumberBuilding(String extensionNumberBuilding) {
        this.extensionNumberBuilding = extensionNumberBuilding;
    }

    /**
     * 内線番号(個人番号)を取得する。
     *
     * @return 内線番号(個人番号)。
     */
    public String getExtensionNumberPersonal() {
        return extensionNumberPersonal;
    }

    /**
     * 内線番号(個人番号)を設定する。
     *
     * @param extensionNumberPersonal 設定する内線番号(個人番号)。
     */
    @PropertyName("内線番号(個人番号)")
    @Required
    @Length(max = 4)
    @NumberChar
    public void setExtensionNumberPersonal(String extensionNumberPersonal) {
        this.extensionNumberPersonal = extensionNumberPersonal;
    }

    /**
     * 携帯電話番号(市外)を取得する。
     *
     * @return 携帯電話番号(市外)。
     */
    public String getMobilePhoneNumberAreaCode() {
        return mobilePhoneNumberAreaCode;
    }

    /**
     * 携帯電話番号(市外)を設定する。
     *
     * @param mobilePhoneNumberAreaCode 設定する携帯電話番号(市外)。
     */
    @PropertyName("携帯電話番号(市外)")
    @Length(max = 3)
    @NumberChar
    public void setMobilePhoneNumberAreaCode(String mobilePhoneNumberAreaCode) {
        this.mobilePhoneNumberAreaCode = mobilePhoneNumberAreaCode;
    }

    /**
     * 携帯電話番号(市内)を取得する。
     *
     * @return 携帯電話番号(市内)。
     */
    public String getMobilePhoneNumberCityCode() {
        return mobilePhoneNumberCityCode;
    }

    /**
     * 携帯電話番号(市内)を設定する。
     *
     * @param mobilePhoneNumberCityCode 設定する携帯電話番号(市内)。
     */
    @PropertyName("携帯電話番号(市内)")
    @Length(max = 4)
    @NumberChar
    public void setMobilePhoneNumberCityCode(String mobilePhoneNumberCityCode) {
        this.mobilePhoneNumberCityCode = mobilePhoneNumberCityCode;
    }

    /**
     * 携帯電話番号(加入)を取得する。
     *
     * @return 携帯電話番号(加入)。
     */
    public String getMobilePhoneNumberSbscrCode() {
        return mobilePhoneNumberSbscrCode;
    }

    /**
     * 携帯電話番号(加入)を設定する。
     *
     * @param mobilePhoneNumberSbscrCode 設定する携帯電話番号(加入)。
     */
    @PropertyName("携帯電話番号(加入)")
    @Length(max = 4)
    @NumberChar
    public void setMobilePhoneNumberSbscrCode(
            String mobilePhoneNumberSbscrCode) {
        this.mobilePhoneNumberSbscrCode = mobilePhoneNumberSbscrCode;
    }


    /**
     * 登録者IDを取得する。
     *
     * @return 登録者ID。
     */
    public String getInsertUserId() {
        return insertUserId;
    }

    /**
     * 登録者IDを設定する。
     *
     * @param insertUserId 設定する登録者ID。
     */
    @PropertyName("登録者ID")
    @Required
    @Length(min = 10, max = 10)
    @NumberChar
    public void setInsertUserId(String insertUserId) {
        this.insertUserId = insertUserId;
    }

    /**
     * 登録日時を取得する。
     *
     * @return 登録日時。
     */
    public Timestamp getInsertDate() {
        return insertDate;
    }

    /**
     * 登録日時を設定する。
     *
     * @param insertDate 設定する登録日時。
     */
    @PropertyName("登録日時")
    @Required
    public void setInsertDate(Timestamp insertDate) {
        this.insertDate = insertDate;
    }

    /**
     * 更新者IDを取得する。
     *
     * @return 更新者ID。
     */
    public String getUpdatedUserId() {
        return updatedUserId;
    }

    /**
     * 更新者IDを設定する。
     *
     * @param updatedUserId 設定する更新者ID。
     */
    @PropertyName("更新者ID")
    @Required
    @Length(min = 10, max = 10)
    @NumberChar
    public void setUpdatedUserId(String updatedUserId) {
        this.updatedUserId = updatedUserId;
    }

    /**
     * 更新日時を取得する。
     *
     * @return 更新日時。
     */
    public Timestamp getUpdatedDate() {
        return updatedDate;
    }

    /**
     * 更新日時を設定する。
     *
     * @param updatedDate 設定する更新日時。
     */
    @PropertyName("更新日時")
    @Required
    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }
}
