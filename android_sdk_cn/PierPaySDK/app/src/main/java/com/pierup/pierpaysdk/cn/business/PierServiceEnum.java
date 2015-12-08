package com.pierup.pierpaysdk.cn.business;

public interface PierServiceEnum {
    public PierServiceConfig.HTTPMethodEnum getMethod();
    public String getUrl();
    public String getInput();
    public String getOutput();
    public String getHandler();
}