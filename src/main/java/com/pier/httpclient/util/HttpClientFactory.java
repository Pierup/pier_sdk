package com.pier.httpclient.util;

import java.lang.reflect.Constructor;

import org.apache.log4j.Logger;

import com.pier.httpclient.client.DefaultDisableJsClient;
import com.pier.httpclient.client.DisableJsClient;
import com.pier.httpclient.config.ClientConfig;

/**
 * 
 * 描述：
 *http客户端生产工厂
 * @author Caliph CHEN
 * @date 2014年9月18日
 *
 */
public class HttpClientFactory {
	private static final Logger logger=Logger.getLogger(HttpClientFactory.class);
	
	/**
	 * 
	 * 描述： 
	 *工厂构造生成不可执行js的客户端
	 * @param config
	 * @param class1
	 * @return
	 */
	public static<T extends DisableJsClient> DisableJsClient getDisableJsClient(ClientConfig config,Class<T> class1)
	{
		if (class1==null) {
			return new DefaultDisableJsClient(config);
		}else{
			try {
				Constructor< T> constructor= class1.getDeclaredConstructor(ClientConfig.class);
				constructor.setAccessible(true);
				return constructor.newInstance(config);
			} catch (Exception e) {
				// TODO: handle exception
				logger.error("工厂构造DisableJsClient发生异常!", e);
				return new DefaultDisableJsClient(config);
			}
		}
	}
	
}
