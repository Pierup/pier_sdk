package com.pier.httpclient.client;

import java.io.InputStream;
import java.util.Map;

import org.apache.http.client.ResponseHandler;
import org.apache.http.protocol.HttpContext;

import com.pier.httpclient.config.RequestConfig;


/**
 * 
 * 描述：
 * 不能执行js的客户端
 * @author Caliph CHEN
 * @date 2014年9月15日
 *
 */
public interface DisableJsClient extends IClient {
	/**
	 * 
	 * 描述： 
	 * 释放资源
	 */
	public void destroy();
	/**
	 * 
	 * 描述： 
	 * 发送post请求，以json方式提交数据，返回字符串
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @return
	 */
	public String postJsonStr(String uri,RequestConfig config,String jsonStr);
}
