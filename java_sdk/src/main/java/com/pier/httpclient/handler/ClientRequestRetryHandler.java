package com.pier.httpclient.handler;

import java.io.IOException;
import java.io.InterruptedIOException;
import java.net.UnknownHostException;

import javax.net.ssl.SSLException;

import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpRequest;
import org.apache.http.client.HttpRequestRetryHandler;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.conn.ConnectTimeoutException;
import org.apache.http.protocol.HttpContext;


/**
 * 
 * 描述：
 * Request retry handler 请求重试处理器
 * @author caliph
 * @date 2014年3月11日
 *
 */
public class ClientRequestRetryHandler implements HttpRequestRetryHandler{
	@Override
	public boolean retryRequest(IOException exception, int executionCount, HttpContext context) {
		// TODO Auto-generated method stub
		if (executionCount>=3) {
			return false;
		}
		if (exception instanceof InterruptedIOException) {
			return false;
		}
		if (exception instanceof UnknownHostException) {
			return false;
		}
		if (exception instanceof ConnectTimeoutException) {
			return false;
		}
		if (exception instanceof SSLException) {
			return false;
		}
		HttpClientContext clientContext=HttpClientContext.adapt(context);
		HttpRequest request=clientContext.getRequest();
		boolean idempotent=!(request instanceof HttpEntityEnclosingRequest);
		if (idempotent) {
			return true;
		}
		return false;
	}
}
