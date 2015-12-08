package com.pierup.pierpaysdk.cn.extern;

public class PierDataSources {
    public static final PierDataSources instance = new PierDataSources();
    //user info
    private String device_token = null;//初始空
//    private String push_id = null;
    private String session_token = "";
    private String user_id = "";
    private String country_code = "CN";
    private String phone = "";
//    private String name = "";
    private String user_agent = "";
//
//    //首次注册，在申请信用成功的时候需要保存密码，此时从这里取出。
//    private String sigin_password;
//
//    //user status
//    private int infoStatusBit;
//
//    private Boolean idVerified = false;
//
//    public boolean isAppActive = false;              // App当前状态
//    public boolean isGesturePasswordOnTop = false;   // 手势密码是否出现
//    public int getSessionRepeatCount = 0;
//    public long showKeyboardDelayTime = 200;
//    public boolean isShowBalanceTip = false;
//
//    private PierUserStatusEnum userStatus = PierUserStatusEnum.eUserStatus_new_user;
//    private int userStatusBit;
//
//    public PierIDImageStatusEnum idImageStatus;
//

//
//    public void obtainUserInfoFromLocal() {
//        UserEntity userEntity = DataManagerUtil.getInstance().getUser();
//        //init Device Token
//        if (userEntity != null) {
//            String local_phone = userEntity.getPhone();
//            if (local_phone != null) {
//                setPhone(local_phone);
//            }
//            String local_device_token = userEntity.getDeviceToken();
//            if (local_device_token != null) {
//                setDevice_token(local_device_token);
//            }
//
//            UserConfigEntity userModel = UserDBUtil.getUserConfigEntityByPhone(userEntity.getPhone());
//            if (userModel != null) {
//                String tempCountryCode = userModel.getCountry_code();
//                setCountry_code(tempCountryCode);
//            }
//        }
//        user_agent = PierDeviceUtil.getCurrentUserAgent();
//
//    }
//
    public String getDevice_token() {
        return device_token;
    }

    public void setDevice_token(String device_token) {
        this.device_token = device_token;
    }

    public String getSession_token() {
        return session_token;
    }

    public void setSession_token(String session_token) {
        if (session_token != null && session_token.length() > 0) {
            this.session_token = session_token;
        }
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        if (user_id != null && user_id.length() > 0) {
            this.user_id = user_id;
        }
    }

    public String getCountry_code() {
        return country_code;
    }

    public void setCountry_code(String country_code) {
        if (country_code != null && country_code.length() > 0) {
            this.country_code = country_code;
        }
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        if (phone != null && phone.length() > 0) {
            this.phone = phone;
        }
    }
//
//    public String getName() {
//        return name;
//    }
//
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public Boolean isIdVerified() {
//        return idVerified;
//    }
//
//    public void setIdVerified(Boolean idVerified) {
//        this.idVerified = idVerified;
//    }
//
    public String getUser_agent() {
        return user_agent;
    }
//
//    public PierUserStatusEnum getUserStatus() {
//        return userStatus;
//    }
//
//    public int getUserStatusBit() {
//        return userStatusBit;
//    }
//
//    public String getPush_id() {
//        return push_id;
//    }
//
//    public void setPush_id(String push_id) {
//        this.push_id = push_id;
//    }
//
//    public String getSigin_password() {
//        return sigin_password;
//    }
//
//    public void setSigin_password(String sigin_password) {
//        this.sigin_password = sigin_password;
//    }
//
//    public boolean checkUserStatus(PierUserStatusEnum userStatus) {
//        boolean result = false;
//        switch (userStatus) {
//            case eUserStatus_new_user:
//                result = (userStatusBit == 0) ? true : false;
//                break;
//            case eUserStatus_reigsterUser:
//                result = ((userStatusBit & (1 << 0)) == (1 << 0)) ? true : false;
//                break;
//            case eUserStatus_invited:
//                result = ((userStatusBit & (1 << 5)) == (1 << 5)) ? true : false;
//                break;
//            case eUserStatus_basicInfo:
//                result = ((userStatusBit & (1 << 1)) == (1 << 1)) ? true : false;
//                break;
//            case eUserStatus_linkAccount:
//                result = ((userStatusBit & (1 << 2)) == (1 << 2)) ? true : false;
//                break;
//            case eUserStatus_payPassword:
//                result = ((userStatusBit & (1 << 4)) == (1 << 4)) ? true : false;
//                break;
//            case eUserStatus_hasApplied:
//                result = ((userStatusBit & (1 << 3)) == (1 << 3)) ? true : false;
//                break;
//            case eUserStatus_hasCredit:
//                result = ((userStatusBit & (1 << 7)) == (1 << 7)) ? true : false;
//                break;
//        }
//        return result;
//    }
//
//    public void setUserStatus(PierUserStatusEnum userStatus) {
//        switch (userStatus) {
//            case eUserStatus_new_user:
//                userStatusBit = userStatusBit | 1 << 0;
//                break;
//            case eUserStatus_reigsterUser:
//                userStatusBit = userStatusBit | 1 << 0;
//                break;
//            case eUserStatus_invited:
//                userStatusBit = userStatusBit | 1 << 5;
//                break;
//            case eUserStatus_basicInfo:
//                userStatusBit = userStatusBit | 1 << 1;
//                break;
//            case eUserStatus_linkAccount:
//                userStatusBit = userStatusBit | 1 << 2;
//                break;
//            case eUserStatus_payPassword:
//                userStatusBit = userStatusBit | 1 << 4;
//                break;
//            case eUserStatus_hasApplied:
//                userStatusBit = userStatusBit | 1 << 3;
//                break;
//            case eUserStatus_hasCredit:
//                userStatusBit = userStatusBit | 1 << 7;
//                break;
//        }
//        this.userStatus = userStatus;
//    }
//
//    public void setUserStatusBit(int userStatusBit) {
//        this.userStatusBit = userStatusBit;
//    }
//
//    public void setInfoStatusBit(int infoStatusBit) {
//        this.infoStatusBit = infoStatusBit;
//    }
//
//    public int getInfoStatusBit() {
//        return infoStatusBit;
//    }
//
//    public boolean checkInfoStatus(PierInfoStatusEnum infoStatus) {
//        boolean result = false;
//        switch (infoStatus) {
//            case eInfoStatus_chsi:
//                result = (infoStatusBit & (1 << 0)) == (1 << 0) ? true : false;
//                break;
//            case eInfoStatus_idIdentification:
//                result = (infoStatusBit & (1 << 1)) == (1 << 1) ? true : false;
//                break;
//            case eInfoStatus_taobao:
//                result = (infoStatusBit & (1 << 2)) == (1 << 2) ? true : false;
//                break;
//            case eInfoStatus_creditCardEmail:
//                result = (infoStatusBit & (1 << 3)) == (1 << 3) ? true : false;
//                break;
//            case eInfoStatus_zhimaCredit:
//                result = (infoStatusBit & (1 << 4)) == (1 << 4) ? true : false;
//                break;
//            case eInfoStatus_sina:
//                result = (infoStatusBit & (1 << 5)) == (1 << 5) ? true : false;
//                break;
//            case eInfoStatus_gjj:
//                result = (infoStatusBit & (1 << 6)) == (1 << 6) ? true : false;
//                break;
//            case eInfoStatus_zxbg:
//                result = (infoStatusBit & (1 << 7)) == (1 << 7) ? true : false;
//                break;
//            default:
//                break;
//        }
//        return result;
//    }
//
//    public void setIDImageStatus(int idImageStatus) {
//        switch (idImageStatus) {
//            case 0:
//                PierDataSources.instance.idImageStatus = PierIDImageStatusEnum.eIDImageStatus_empty;
//                break;
//            case 1:
//                PierDataSources.instance.idImageStatus = PierIDImageStatusEnum.eIDImageStatus_waiting;
//                break;
//            case 2:
//                PierDataSources.instance.idImageStatus = PierIDImageStatusEnum.eIDImageStatus_succeed;
//                break;
//            case 3:
//                PierDataSources.instance.idImageStatus = PierIDImageStatusEnum.eIDImageStatus_failed;
//                break;
//            default:
//                break;
//        }
//    }
}
