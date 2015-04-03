package com.pier.model;

import java.util.Map;

/**
 * 
 * @ClassName: SDKResult
 * @Description: SDK执行结果
 * @author Caliph.Chen clp_job@163.com
 * @date 2015年1月21日 下午6:07:32
 */
public class SDKResult {
	private boolean status;
	private String message;
	private String code;
	private Map<String, String> result;

	public Map<String, String> getResult() {
		return result;
	}

	public void setResult(Map<String, String> result) {
		this.result = result;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
