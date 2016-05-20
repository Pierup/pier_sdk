package com.pier.httpclient.util;

import com.pier.httpclient.client.DisableJsClient;
import com.pier.httpclient.config.ClientConfig;
import com.pier.httpclient.config.RequestConfig;

/**
 * 
 * 描述： http客户端工具类
 * 
 * @author Caliph CHEN
 * @date 2014年9月18日
 * 
 */
public class HttpClientUtils {
	private final static DisableJsClient disableJsClient;
	static {
		ClientConfig config = ClientConfig.custom().build();
		disableJsClient = HttpClientFactory.getDisableJsClient(config, null);
		Runtime.getRuntime().addShutdownHook(new Thread() {
			@Override
			public void run() {
				disableJsClient.destroy();
			}
		});
	}

	/**
	 * 
	 * 描述： 发送post请求，以json方式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @return
	 */
	public static String postJsonStr(String uri, RequestConfig config,
			String jsonStr) {
		return disableJsClient.postJsonStr(uri, config, jsonStr);
	}
}
