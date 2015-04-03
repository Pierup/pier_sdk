package com.pier.httpclient.config;

import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

/**
 * 
 * 描述： 请求配置类
 * 
 * @author Caliph CHEN
 * @date 2014年9月12日
 *
 */
public class RequestConfig {
	/**
	 * 向链接管理器请求链接超时时间的毫秒数 默认为2*60*1000 Returns the timeout in milliseconds used
	 * when requesting a connection from the connection manager
	 */
	private final int connectionRequestTimeout;
	/**
	 * 与目标建立连接超时时间毫秒数 默认为2*60*1000 Determines the timeout in milliseconds until
	 * a connection is established.
	 */
	private final int connectTimeout;
	/**
	 * 最大跳转次数 默认为10
	 */
	private final int maxRedirects;
	/**
	 * 是否运行进行跳转 默认为true
	 */
	private final boolean redirectsEnabled;
	/**
	 * 是否允许进行相对路径跳转 默认为true
	 */
	private final boolean relativeRedirectsAllowed;
	/**
	 * 与目标进行socket通信超时时间 默认为2*60*1000
	 */
	private final int socketTimeout;
	/**
	 * 请求的头信息集合
	 */
	private final Map<String, String> headers;
	/**
	 * 重试次数，默认为3
	 */
	private final int retryCount;
	/**
	 * 内容编码和解码方式，默认为null，如果为null，则编码默认为"UTF-8",解码默认为返回contentType中的编码方式或者Charset
	 * .defaultCharset()
	 */
	private final Charset charset;
	/**
	 * 请求的cookie信息
	 */
	private final Map<String, String> cookies;

	private RequestConfig(final RequestConfigBuilder requestConfigBuilder) {
		super();
		this.charset = requestConfigBuilder.charset;
		this.connectionRequestTimeout = requestConfigBuilder.connectionRequestTimeout;
		this.connectTimeout = requestConfigBuilder.connectTimeout;
		this.cookies = requestConfigBuilder.cookies;
		this.headers = requestConfigBuilder.headers;
		this.maxRedirects = requestConfigBuilder.maxRedirects;
		this.redirectsEnabled = requestConfigBuilder.redirectsEnabled;
		this.relativeRedirectsAllowed = requestConfigBuilder.relativeRedirectsAllowed;
		this.retryCount = requestConfigBuilder.retryCount;
		this.socketTimeout = requestConfigBuilder.socketTimeout;
	}

	public Charset getCharset() {
		return charset;
	}

	public int getConnectionRequestTimeout() {
		return connectionRequestTimeout;
	}

	public int getConnectTimeout() {
		return connectTimeout;
	}

	public Map<String, String> getCookies() {
		return cookies;
	}

	public Map<String, String> getHeaders() {
		return headers;
	}

	public int getMaxRedirects() {
		return maxRedirects;
	}

	public int getRetryCount() {
		return retryCount;
	}

	public int getSocketTimeout() {
		return socketTimeout;
	}

	public boolean isRedirectsEnabled() {
		return redirectsEnabled;
	}

	public boolean isRelativeRedirectsAllowed() {
		return relativeRedirectsAllowed;
	}

	public static RequestConfigBuilder custom() {
		return new RequestConfigBuilder();
	}

	public static class RequestConfigBuilder {
		/**
		 * 向链接管理器请求链接超时时间的毫秒数 默认为2*60*1000 Returns the timeout in milliseconds
		 * used when requesting a connection from the connection manager
		 */
		private int connectionRequestTimeout;
		/**
		 * 与目标建立连接超时时间毫秒数 默认为2*60*1000 Determines the timeout in milliseconds
		 * until a connection is established.
		 */
		private int connectTimeout;
		/**
		 * 最大跳转次数 默认为10
		 */
		private int maxRedirects;
		/**
		 * 是否运行进行跳转 默认为true
		 */
		private boolean redirectsEnabled;
		/**
		 * 是否允许进行相对路径跳转 默认为true
		 */
		private boolean relativeRedirectsAllowed;
		/**
		 * 与目标进行socket通信超时时间 默认为2*60*1000
		 */
		private int socketTimeout;
		/**
		 * 请求的头信息集合
		 */
		private Map<String, String> headers;
		/**
		 * 重试次数，默认为3
		 */
		private int retryCount;
		/**
		 * 内容编码和解码方式，默认为null，如果为null，则编码默认为"UTF-8",
		 * 解码默认为返回contentType中的编码方式或者Charset.defaultCharset()
		 */
		private Charset charset;
		/**
		 * 请求的cookie信息
		 */
		private Map<String, String> cookies;

		public RequestConfigBuilder() {
			super();
			connectionRequestTimeout = 2 * 60 * 1000;
			connectTimeout = 2 * 60 * 1000;
			maxRedirects = 10;
			redirectsEnabled = true;
			relativeRedirectsAllowed = true;
			socketTimeout = 2 * 60 * 1000;
			headers = new HashMap<String, String>();
			retryCount = 3;
			charset = null;
			cookies = new HashMap<String, String>();
		}

		public RequestConfigBuilder setCharset(Charset charset) {
			this.charset = charset;
			return this;
		}

		public RequestConfigBuilder setConnectionRequestTimeout(
				int connectionRequestTimeout) {
			this.connectionRequestTimeout = connectionRequestTimeout;
			return this;
		}

		public RequestConfigBuilder setConnectTimeout(int connectTimeout) {
			this.connectTimeout = connectTimeout;
			return this;
		}

		public RequestConfigBuilder setCookies(Map<String, String> cookies) {
			this.cookies = cookies;
			return this;
		}

		public RequestConfigBuilder addCookies(String name, String value) {
			this.cookies.put(name, value);
			return this;
		}

		public RequestConfigBuilder setHeaders(Map<String, String> headers) {
			this.headers = headers;
			return this;
		}

		public RequestConfigBuilder addHeaders(String name, String value) {
			this.headers.put(name, value);
			return this;
		}

		public RequestConfigBuilder setMaxRedirects(int maxRedirects) {
			this.maxRedirects = maxRedirects;
			return this;
		}

		public RequestConfigBuilder setRedirectsEnabled(boolean redirectsEnabled) {
			this.redirectsEnabled = redirectsEnabled;
			return this;
		}

		public RequestConfigBuilder setRelativeRedirectsAllowed(
				boolean relativeRedirectsAllowed) {
			this.relativeRedirectsAllowed = relativeRedirectsAllowed;
			return this;
		}

		public RequestConfigBuilder setRetryCount(int retryCount) {
			this.retryCount = retryCount;
			return this;
		}

		public RequestConfigBuilder setSocketTimeout(int socketTimeout) {
			this.socketTimeout = socketTimeout;
			return this;
		}

		public RequestConfig build() {
			return new RequestConfig(this);
		}
	}
}
