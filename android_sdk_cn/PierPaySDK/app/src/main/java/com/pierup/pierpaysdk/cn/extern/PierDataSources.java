package com.pierup.pierpaysdk.cn.extern;

public class PierDataSources {
    public static final PierDataSources instance = new PierDataSources();

    private String device_token = null;
    private String session_token = "";
    private String user_id = "";
    private String country_code = "CN";
    private String phone = "";

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

}
