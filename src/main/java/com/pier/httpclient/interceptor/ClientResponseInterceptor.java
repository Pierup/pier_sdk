package com.pier.httpclient.interceptor;

import java.io.IOException;

import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.HttpException;
import org.apache.http.HttpResponse;
import org.apache.http.HttpResponseInterceptor;
import org.apache.http.client.entity.GzipDecompressingEntity;
import org.apache.http.protocol.HttpContext;

/**
 * 
 * 描述：
 * 客户端Http响应拦截器
 * @author Caliph CHEN
 * @date 2014年7月15日
 *
 */
public class ClientResponseInterceptor implements HttpResponseInterceptor{
	@Override
	public void process(HttpResponse response, HttpContext context)
			throws HttpException, IOException {
		// TODO Auto-generated method stub
		HttpEntity entity = response.getEntity();
		if (entity == null) {
			return;
		}
		Header ceheader = entity.getContentEncoding();
		if (ceheader == null) {
			return;
		}
		HeaderElement[] codecs = ceheader.getElements();
		for(HeaderElement element:codecs)
		{
			if ("gzip".equalsIgnoreCase(element.getName())) {
				response.setEntity(new GzipDecompressingEntity(entity));
				return;
			}
		}
	}
}
