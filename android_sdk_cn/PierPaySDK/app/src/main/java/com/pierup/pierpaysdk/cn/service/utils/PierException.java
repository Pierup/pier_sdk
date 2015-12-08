package com.pierup.pierpaysdk.cn.service.utils;

public class PierException extends Throwable {
    private int code;
    private String codeMessage;

    public String getCodeMessage() {
        return codeMessage;
    }

    public void setCodeMessage(String codeMessage) {
        this.codeMessage = codeMessage;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }
}
