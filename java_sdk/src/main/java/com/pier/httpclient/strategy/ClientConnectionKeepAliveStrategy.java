package com.pier.httpclient.strategy;

import org.apache.http.HttpResponse;
import org.apache.http.impl.client.DefaultConnectionKeepAliveStrategy;
import org.apache.http.protocol.HttpContext;
/**
 * 
 * 描述：
 * HttpClient interface 与服务器连接保持连接的时间
 * @author caliph
 * @date 2014年3月11日
 *
 */
public class ClientConnectionKeepAliveStrategy extends DefaultConnectionKeepAliveStrategy{
	@Override
	public long getKeepAliveDuration(HttpResponse response, HttpContext context) {
		// TODO Auto-generated method stub
		long keepAlive=super.getKeepAliveDuration(response, context);
		if (keepAlive==-1) {
			keepAlive=60*1000;
		}
		return keepAlive;
	}
}
