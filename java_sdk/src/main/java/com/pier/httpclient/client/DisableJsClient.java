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
	 * 发送head请求，返回状态码
	 * @param uri
	 * @param config
	 * @return
	 */
	public int head(String uri,RequestConfig config);
	/**
	 * 
	*@Title: putJsonStr
	* @Description: 发送put请求，以json方式提交数据，返回字符串
	* @param uri
	* @param config
	* @param jsonStr
	* @return
	* @return String 
	* @throws
	 */
	public String putJsonStr(String uri,RequestConfig config,String jsonStr);
	/**
	 * 
	 * 描述： 
	 * 发送get请求，返回字符串
	 * @param uri
	 * @param config
	 * @return
	 */
	public String getStr(String uri,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 * 发送get请求，返回字节数组
	 * @param uri
	 * @param config
	 * @return
	 */
	public byte[]  getBytes(String uri,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 * 发送get请求，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T getT(String uri,RequestConfig config,ResponseHandler<T> handler,HttpContext context);
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
	/**
	 * 
	 * 描述： 
	 * 发送post请求，以json方式提交数据，返回字节数组
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @return
	 */
	public byte[] postJsonBytes(String uri,RequestConfig config,String jsonStr);
	/**
	 * 
	 * 描述： 
	 * 发送post请求，以json方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param config
	 * @param jsonStr
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T postJsonT(String uri,RequestConfig config,String jsonStr,ResponseHandler<T> handler,HttpContext context);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以form方式提交数据，返回字符串
	 * @param uri
	 * @param config
	 * @param params
	 * @return
	 */
	public String postFormStr(String uri,RequestConfig config,Map<String, String> params);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以form方式提交数据，返回字节数组
	 * @param uri
	 * @param config
	 * @param params
	 * @return
	 */
	public byte[] postFormBytes(String uri,RequestConfig config,Map<String, String> params);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以form方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param config
	 * @param params
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T postFormT(String uri,RequestConfig config,Map<String, String> params,ResponseHandler<T> handler,HttpContext context);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以流式的方式提交数据，返回字符串
	 * @param uri
	 * @param stream
	 * @param config
	 * @return
	 */
	public String postStreamStr(String uri,InputStream stream,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以流式方式提交数据，返回字节数组
	 * @param uri
	 * @param stream
	 * @param config
	 * @return
	 */
	public byte[] postStreamBytes(String uri,InputStream stream,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 * 发送post请求，以流式方式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param stream
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T postStreamT(String uri,InputStream stream,RequestConfig config,ResponseHandler<T> handler,HttpContext context);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以字节数组形式提交数据，返回字符串
	 * @param uri
	 * @param binarys
	 * @param config
	 * @return
	 */
	public String postBinarysStr(String uri,byte[] binarys,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以字节数据形式提交数据，返回字节数组
	 * @param uri
	 * @param binarys
	 * @param config
	 * @return
	 */
	public byte[] postBinarysBytes(String uri,byte[] binarys,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以字节数组形式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param binarys
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T postBinarysT(String uri,byte[] binarys,RequestConfig config,ResponseHandler<T> handler,HttpContext context);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以multipart形式提交数据，返回字符串
	 * @param uri
	 * @param params
	 * @param config
	 * @return
	 */
	public String postMultipartStr(String uri,Map<String, Object> params,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以multipart形式提交数据，返回字节数组
	 * @param uri
	 * @param params
	 * @param config
	 * @return
	 */
	public byte[] postMultipartBytes(String uri,Map<String, Object> params,RequestConfig config);
	/**
	 * 
	 * 描述： 
	 *发送post请求，以multipart形式提交数据，并且用户可以自定义处理器，处理数据，返回自定义结果数据
	 * @param uri
	 * @param params
	 * @param config
	 * @param handler
	 * @param context
	 * @return
	 */
	public <T> T postMultipartT(String uri,Map<String, Object> params,RequestConfig config,ResponseHandler<T> handler,HttpContext context);
}
