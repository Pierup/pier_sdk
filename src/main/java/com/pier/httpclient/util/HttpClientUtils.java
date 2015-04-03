package com.pier.httpclient.util;

import java.io.InputStream;
import java.util.Map;

import org.apache.http.client.ResponseHandler;
import org.apache.http.protocol.HttpContext;

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
				// TODO Auto-generated method stub
				disableJsClient.destroy();
			}
		});
	}

	/**
	 * 
	 * 描述： 进行head请求，返回状态码
	 * 
	 * @param uri
	 * @param config
	 * @param enableJs
	 * @return
	 */
	public static int head(String uri, RequestConfig config, boolean enableJs) {
		return disableJsClient.head(uri, config);
	}

	/**
	 * 
	 * 描述： 发送put请求，以json方式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @return
	 */
	public static String putJsonStr(String uri, RequestConfig config,	String jsonStr) {
		return disableJsClient.putJsonStr(uri, config, jsonStr);
	}

	
	/**
	 * 
	 * 描述： 发送get请求，返回字符串
	 * 
	 * @param uri
	 * @param config
	 * @param enableJs
	 * @return
	 */
	public static String getStr(String uri, RequestConfig config,
			boolean enableJs) {
			return disableJsClient.getStr(uri, config);
	}

	/**
	 * 
	 * 描述： 发送get请求，返回字节数组
	 * 
	 * @param uri
	 * @param config
	 * @param enableJs
	 * @return
	 */
	public static byte[] getBytes(String uri, RequestConfig config,
			boolean enableJs) {
			return disableJsClient.getBytes(uri, config);
	}

	/**
	 * 
	 * 描述： 发送get请求，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T getT(String uri, RequestConfig config,
			ResponseHandler<T> handler, HttpContext context) {
		return disableJsClient.getT(uri, config, handler, context);
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

	/**
	 * 
	 * 描述： 发送post请求，以json方式提交数据，返回字节数组
	 * 
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @return
	 */
	public static byte[] postJsonBytes(String uri, RequestConfig config,
			String jsonStr) {
		return disableJsClient.postJsonBytes(uri, config, jsonStr);
	}

	/**
	 * 
	 * 描述： 发送post请求，以json方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T postJsonT(String uri, RequestConfig config,
			String jsonStr, ResponseHandler<T> handler, HttpContext context) {
		return disableJsClient
				.postJsonT(uri, config, jsonStr, handler, context);
	}

	/**
	 * 
	 * 描述： 发送post请求，以form方式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param config
	 * @param params
	 * @return
	 */
	public static String postFormStr(String uri, RequestConfig config,
			Map<String, String> params) {
		return disableJsClient.postFormStr(uri, config, params);
	}

	/**
	 * 
	 * 描述： 发送post请求，以form方式提交数据，返回字节数组
	 * 
	 * @param uri
	 * @param config
	 * @param params
	 * @return
	 */
	public static byte[] postFormBytes(String uri, RequestConfig config,
			Map<String, String> params) {
		return disableJsClient.postFormBytes(uri, config, params);
	}

	/**
	 * 
	 * 描述： 发送post请求，以form方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param config
	 * @param params
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T postFormT(String uri, RequestConfig config,
			Map<String, String> params, ResponseHandler<T> handler,
			HttpContext context) {
		return disableJsClient.postFormT(uri, config, params, handler, context);
	}

	/**
	 * 
	 * 描述： 发送post请求，以流式的方式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param stream
	 * @param config
	 * @return
	 */
	public static String postStreamStr(String uri, InputStream stream,
			RequestConfig config) {
		return disableJsClient.postStreamStr(uri, stream, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以流式方式提交数据，返回字节数组
	 * 
	 * @param uri
	 * @param stream
	 * @param config
	 * @return
	 */
	public static byte[] postStreamBytes(String uri, InputStream stream,
			RequestConfig config) {
		return disableJsClient.postStreamBytes(uri, stream, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以流式方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param stream
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T postStreamT(String uri, InputStream stream,
			RequestConfig config, ResponseHandler<T> handler,
			HttpContext context) {
		return disableJsClient.postStreamT(uri, stream, config, handler,
				context);
	}

	/**
	 * 
	 * 描述： 发送post请求，以字节数组形式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param binarys
	 * @param config
	 * @return
	 */
	public static String postBinarysStr(String uri, byte[] binarys,
			RequestConfig config) {
		return disableJsClient.postBinarysStr(uri, binarys, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以字节数据形式提交数据，返回字节数组
	 * 
	 * @param uri
	 * @param binarys
	 * @param config
	 * @return
	 */
	public static byte[] postBinarysBytes(String uri, byte[] binarys,
			RequestConfig config) {
		return disableJsClient.postBinarysBytes(uri, binarys, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以字节数组形式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param binarys
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T postBinarysT(String uri, byte[] binarys,
			RequestConfig config, ResponseHandler<T> handler,
			HttpContext context) {
		return disableJsClient.postBinarysT(uri, binarys, config, handler,
				context);
	}

	/**
	 * 
	 * 描述： 发送post请求，以multipart形式提交数据，返回字符串
	 * 
	 * @param uri
	 * @param params
	 * @param config
	 * @return
	 */
	public static String postMultipartStr(String uri,
			Map<String, Object> params, RequestConfig config) {
		return disableJsClient.postMultipartStr(uri, params, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以multipart形式提交数据，返回字节数组
	 * 
	 * @param uri
	 * @param params
	 * @param config
	 * @return
	 */
	public static byte[] postMultipartBytes(String uri,
			Map<String, Object> params, RequestConfig config) {
		return disableJsClient.postMultipartBytes(uri, params, config);
	}

	/**
	 * 
	 * 描述： 发送post请求，以multipart形式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * 
	 * @param uri
	 * @param params
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public static <T> T postMultipartT(String uri, Map<String, Object> params,
			RequestConfig config, ResponseHandler<T> handler,
			HttpContext context) {
		return disableJsClient.postMultipartT(uri, params, config, handler,
				context);
	}
}
