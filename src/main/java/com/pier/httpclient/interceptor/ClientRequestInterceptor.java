package com.pier.httpclient.interceptor;

import java.io.IOException;

import org.apache.http.HttpException;
import org.apache.http.HttpRequest;
import org.apache.http.HttpRequestInterceptor;
import org.apache.http.protocol.HttpContext;

/**
 * 
 * 描述：
 * 客户端Http请求拦截器
 * @author Caliph CHEN
 * @date 2014年7月15日
 *
 */
public class ClientRequestInterceptor implements HttpRequestInterceptor{
	@Override
	public void process(HttpRequest request, HttpContext context)
			throws HttpException, IOException {
		// TODO Auto-generated method stub
		if (!request.containsHeader("Accept-Encoding")) {
			request.addHeader("Accept-Encoding", "gzip");
		}
	}
}
