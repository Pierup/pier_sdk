package com.pier.httpclient.config;

/**
 * 
 * 描述： 客户端配置类
 * 
 * @author Caliph CHEN
 * @date 2014年9月12日
 *
 */
public class ClientConfig {
	/**
	 * 默认的每个路由的最大链接数 默认为10
	 */
	private final int defaultMaxPerRoute;
	/**
	 * 总的最大链接数 默认为10*50
	 */
	private final int maxTotal;
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
	 * 设置客户端的userAgent，默认为firefox
	 */
	private final String userAgent;

	private ClientConfig(ClientConfigBuilder clientConfigBuilder) {
		super();
		this.connectionRequestTimeout = clientConfigBuilder.connectionRequestTimeout;
		this.connectTimeout = clientConfigBuilder.connectTimeout;
		this.defaultMaxPerRoute = clientConfigBuilder.defaultMaxPerRoute;
		this.maxRedirects = clientConfigBuilder.maxRedirects;
		this.maxTotal = clientConfigBuilder.maxTotal;
		this.redirectsEnabled = clientConfigBuilder.redirectsEnabled;
		this.relativeRedirectsAllowed = clientConfigBuilder.relativeRedirectsAllowed;
		this.socketTimeout = clientConfigBuilder.socketTimeout;
		this.userAgent = clientConfigBuilder.userAgent;
	}

	public int getConnectionRequestTimeout() {
		return connectionRequestTimeout;
	}

	public int getConnectTimeout() {
		return connectTimeout;
	}

	public int getDefaultMaxPerRoute() {
		return defaultMaxPerRoute;
	}

	public int getMaxRedirects() {
		return maxRedirects;
	}

	public int getMaxTotal() {
		return maxTotal;
	}

	public int getSocketTimeout() {
		return socketTimeout;
	}

	public String getUserAgent() {
		return userAgent;
	}

	public boolean isRedirectsEnabled() {
		return redirectsEnabled;
	}

	public boolean isRelativeRedirectsAllowed() {
		return relativeRedirectsAllowed;
	}

	public static ClientConfigBuilder custom() {
		return new ClientConfigBuilder();
	}

	public static class ClientConfigBuilder {
		/**
		 * 默认的每个路由的最大链接数 默认为10
		 */
		private int defaultMaxPerRoute;
		/**
		 * 总的最大链接数 默认为10*50
		 */
		private int maxTotal;
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
		 * 设置客户端的userAgent，默认为firefox
		 */
		private String userAgent;

		public ClientConfigBuilder() {
			super();
			defaultMaxPerRoute = 10;
			maxTotal = 10 * 50;
			connectionRequestTimeout = 2 * 60 * 1000;
			connectTimeout = 2 * 60 * 1000;
			maxRedirects = 10;
			redirectsEnabled = true;
			relativeRedirectsAllowed = true;
			socketTimeout = 2 * 60 * 1000;
			userAgent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0";
		}

		public ClientConfigBuilder setConnectionRequestTimeout(
				int connectionRequestTimeout) {
			this.connectionRequestTimeout = connectionRequestTimeout;
			return this;
		}

		public ClientConfigBuilder setConnectTimeout(int connectTimeout) {
			this.connectTimeout = connectTimeout;
			return this;
		}

		public ClientConfigBuilder setDefaultMaxPerRoute(int defaultMaxPerRoute) {
			this.defaultMaxPerRoute = defaultMaxPerRoute;
			return this;
		}

		public ClientConfigBuilder setMaxRedirects(int maxRedirects) {
			this.maxRedirects = maxRedirects;
			return this;
		}

		public ClientConfigBuilder setMaxTotal(int maxTotal) {
			this.maxTotal = maxTotal;
			return this;
		}

		public ClientConfigBuilder setRedirectsEnabled(boolean redirectsEnabled) {
			this.redirectsEnabled = redirectsEnabled;
			return this;
		}

		public ClientConfigBuilder setRelativeRedirectsAllowed(
				boolean relativeRedirectsAllowed) {
			this.relativeRedirectsAllowed = relativeRedirectsAllowed;
			return this;
		}

		public ClientConfigBuilder setSocketTimeout(int socketTimeout) {
			this.socketTimeout = socketTimeout;
			return this;
		}

		public ClientConfigBuilder setUserAgent(String userAgent) {
			this.userAgent = userAgent;
			return this;
		}

		public ClientConfig build() {
			return new ClientConfig(this);
		}
	}

}
