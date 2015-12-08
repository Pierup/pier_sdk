package com.pierup.pierpaysdk.business;

public interface PierServiceEnum {
    public PierServiceConfig.HTTPMethodEnum getMethod();
    public String getUrl();
    public String getInput();
    public String getOutput();
    public String getHandler();
}