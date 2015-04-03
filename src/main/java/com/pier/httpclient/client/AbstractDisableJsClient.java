package com.pier.httpclient.client;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.net.ssl.SSLContext;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.auth.AuthSchemeProvider;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.config.AuthSchemes;
import org.apache.http.client.config.CookieSpecs;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.EntityBuilder;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.auth.BasicSchemeFactory;
import org.apache.http.impl.auth.DigestSchemeFactory;
import org.apache.http.impl.auth.KerberosSchemeFactory;
import org.apache.http.impl.auth.NTLMSchemeFactory;
import org.apache.http.impl.auth.SPNegoSchemeFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.LaxRedirectStrategy;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HttpContext;
import org.apache.http.ssl.SSLContexts;
import org.apache.log4j.Logger;

import com.pier.httpclient.config.ClientConfig;
import com.pier.httpclient.handler.ClientRequestRetryHandler;
import com.pier.httpclient.interceptor.ClientRequestInterceptor;
import com.pier.httpclient.interceptor.ClientResponseInterceptor;
import com.pier.httpclient.strategy.ClientConnectionKeepAliveStrategy;
import com.pier.httpclient.util.EntityUtils;

/**
 * 
 * 描述： 不可执行js的客户端的实现骨架
 * 
 * @author Caliph CHEN
 * @date 2014年9月15日
 *
 */
public abstract class AbstractDisableJsClient implements DisableJsClient {
	protected final static Logger logger = Logger
			.getLogger(AbstractDisableJsClient.class);
	protected final CloseableHttpClient httpClient;
	private final PoolingHttpClientConnectionManager pccm;
	private final HttpConnMonitorThread connMonitor;

	public AbstractDisableJsClient(ClientConfig config) {
		super();
		Registry<AuthSchemeProvider> registry = RegistryBuilder
				.<AuthSchemeProvider> create()
				.register(AuthSchemes.DIGEST, new DigestSchemeFactory())
				.register(AuthSchemes.BASIC, new BasicSchemeFactory())
				.register(AuthSchemes.SPNEGO, new SPNegoSchemeFactory())
				.register(AuthSchemes.KERBEROS, new KerberosSchemeFactory())
				.register(AuthSchemes.NTLM, new NTLMSchemeFactory()).build();
		SSLContext sslContext = null;
		try {
			sslContext = SSLContexts.custom()
					.loadTrustMaterial(null, new TrustStrategy() {

						@Override
						public boolean isTrusted(X509Certificate[] chain,
								String authType) throws CertificateException {
							// TODO Auto-generated method stub
							return true;
						}
					}).build();
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("创建ssl上下文异常!", e);
		}
		SSLConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(
				sslContext,
				SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);
		Registry<ConnectionSocketFactory> registry2 = RegistryBuilder
				.<ConnectionSocketFactory> create()
				.register("http",
						PlainConnectionSocketFactory.getSocketFactory())
				.register("https", sslConnectionSocketFactory).build();
		pccm = new PoolingHttpClientConnectionManager(registry2);
		pccm.setDefaultMaxPerRoute(config.getDefaultMaxPerRoute());
		pccm.setMaxTotal(config.getMaxTotal());
		RequestConfig config2 = RequestConfig
				.custom()
				.setConnectionRequestTimeout(
						config.getConnectionRequestTimeout())
				.setConnectTimeout(config.getConnectTimeout())
				.setCookieSpec(CookieSpecs.BROWSER_COMPATIBILITY)
				.setMaxRedirects(config.getMaxRedirects())
				.setRedirectsEnabled(config.isRedirectsEnabled())
				.setRelativeRedirectsAllowed(
						config.isRelativeRedirectsAllowed())
				.setSocketTimeout(config.getSocketTimeout()).build();
		httpClient = HttpClients.custom().setConnectionManager(pccm)
				.setDefaultRequestConfig(config2)
				.setKeepAliveStrategy(new ClientConnectionKeepAliveStrategy())
				.setRetryHandler(new ClientRequestRetryHandler())
				.setRedirectStrategy(new LaxRedirectStrategy())
				.addInterceptorFirst(new ClientRequestInterceptor())
				.addInterceptorFirst(new ClientResponseInterceptor())
				.setUserAgent(config.getUserAgent())
				.setDefaultAuthSchemeRegistry(registry).build();
		connMonitor = new HttpConnMonitorThread(pccm);
		connMonitor.start();
		logger.info("初始化DisableJsClient完成！");
	}

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		logger.info("开始准备关闭 HttpClient connection 连接池...");
		connMonitor.shutdown();
		pccm.shutdown();
		logger.info("成功准备关闭 HttpClient connection 连接池！");
	}

	@Override
	public int head(String uri, com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		int statusCode = 0;
		HttpHead head = null;
		try {
			URL url = new URL(uri);
			head = new HttpHead(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造head请求发生异常!", e);
			return statusCode;
		}
		head = setConfig(head, config);
		head = setCookies(head, config);
		head = setHeaders(head, config);
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(head);
				statusCode = response.getStatusLine().getStatusCode();
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error(
						"执行head请求发生异常,准备进行第[" + (retryCount + 1) + "]次尝试.", e);
			} finally {
				closeResponse(response);
			}
		}
		return statusCode;
	}
	@Override
	public String putJsonStr(String uri,
			com.pier.httpclient.config.RequestConfig config, String jsonStr) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPut post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPut(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_JSON.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setText(jsonStr);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行put请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}
	@Override
	public String getStr(String uri,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpGet get = null;
		String value = null;
		try {
			URL url = new URL(uri);
			get = new HttpGet(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造get请求发生异常!", e);
			return value;
		}
		get = setConfig(get, config);
		get = setCookies(get, config);
		get = setHeaders(get, config);
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(get);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行get请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] getBytes(String uri,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpGet get = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			get = new HttpGet(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造get请求发生异常!", e);
			return value;
		}
		get = setConfig(get, config);
		get = setCookies(get, config);
		get = setHeaders(get, config);
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(get);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行get请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T getT(String uri,
			com.pier.httpclient.config.RequestConfig config,
			ResponseHandler<T> handler, HttpContext context) {
		// TODO Auto-generated method stub
		HttpGet get = null;
		T value = null;
		try {
			URL url = new URL(uri);
			get = new HttpGet(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造get请求发生异常!", e);
			return value;
		}
		get = setConfig(get, config);
		get = setCookies(get, config);
		get = setHeaders(get, config);
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(get, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行get请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	@Override
	public String postBinarysStr(String uri, byte[] binarys,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.DEFAULT_BINARY.getMimeType(),
				(config.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setBinary(binarys);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] postBinarysBytes(String uri, byte[] binarys,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.DEFAULT_BINARY.getMimeType(),
				(config.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setBinary(binarys);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T postBinarysT(String uri, byte[] binarys,
			com.pier.httpclient.config.RequestConfig config,
			ResponseHandler<T> handler, HttpContext context) {
		// TODO Auto-generated method stub
		HttpPost post = null;
		T value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.DEFAULT_BINARY.getMimeType(),
				(config.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setBinary(binarys);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(post, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	@Override
	public String postFormStr(String uri,
			com.pier.httpclient.config.RequestConfig config,
			Map<String, String> params) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : params.entrySet()) {
				nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry
						.getValue()));
			}
			EntityBuilder entityBuilder = EntityBuilder.create();
			entityBuilder.setContentType(ContentType.create(
					ContentType.APPLICATION_FORM_URLENCODED.getMimeType(),
					(config.getCharset() == null ? Charset.forName("UTF-8")
							: config.getCharset())));
			entityBuilder.setParameters(nameValuePairs);
			post.setEntity(entityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] postFormBytes(String uri,
			com.pier.httpclient.config.RequestConfig config,
			Map<String, String> params) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : params.entrySet()) {
				nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry
						.getValue()));
			}
			EntityBuilder entityBuilder = EntityBuilder.create();
			entityBuilder.setContentType(ContentType.create(
					ContentType.APPLICATION_FORM_URLENCODED.getMimeType(),
					(config.getCharset() == null ? Charset.forName("UTF-8")
							: config.getCharset())));
			entityBuilder.setParameters(nameValuePairs);
			post.setEntity(entityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T postFormT(String uri,
			com.pier.httpclient.config.RequestConfig config,
			Map<String, String> params, ResponseHandler<T> handler,
			HttpContext context) {
		// TODO Auto-generated method stub
		HttpPost post = null;
		T value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			for (Map.Entry<String, String> entry : params.entrySet()) {
				nameValuePairs.add(new BasicNameValuePair(entry.getKey(), entry
						.getValue()));
			}
			EntityBuilder entityBuilder = EntityBuilder.create();
			entityBuilder.setContentType(ContentType.create(
					ContentType.APPLICATION_FORM_URLENCODED.getMimeType(),
					(config.getCharset() == null ? Charset.forName("UTF-8")
							: config.getCharset())));
			entityBuilder.setParameters(nameValuePairs);
			post.setEntity(entityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(post, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	@Override
	public String postJsonStr(String uri,
			com.pier.httpclient.config.RequestConfig config, String jsonStr) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_JSON.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setText(jsonStr);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] postJsonBytes(String uri,
			com.pier.httpclient.config.RequestConfig config, String jsonStr) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_JSON.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setText(jsonStr);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T postJsonT(String uri,
			com.pier.httpclient.config.RequestConfig config, String jsonStr,
			ResponseHandler<T> handler, HttpContext context) {
		// TODO Auto-generated method stub
		HttpPost post = null;
		T value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_JSON.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setText(jsonStr);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(post, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	@Override
	public String postMultipartStr(String uri, Map<String, Object> params,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			MultipartEntityBuilder multipartEntityBuilder = MultipartEntityBuilder
					.create();
			multipartEntityBuilder
					.setCharset(config.getCharset() == null ? Charset
							.forName("UTF-8") : config.getCharset());
			for (Map.Entry<String, Object> entry : params.entrySet()) {
				if (entry.getValue() instanceof String) {
					multipartEntityBuilder.addTextBody(entry.getKey(),
							(String) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA);
				} else if (entry.getValue() instanceof InputStream) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(InputStream) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				} else if (entry.getValue() instanceof File) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(File) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				}
			}
			post.setEntity(multipartEntityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] postMultipartBytes(String uri, Map<String, Object> params,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			MultipartEntityBuilder multipartEntityBuilder = MultipartEntityBuilder
					.create();
			multipartEntityBuilder
					.setCharset(config.getCharset() == null ? Charset
							.forName("UTF-8") : config.getCharset());
			for (Map.Entry<String, Object> entry : params.entrySet()) {
				if (entry.getValue() instanceof String) {
					multipartEntityBuilder.addTextBody(entry.getKey(),
							(String) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA);
				} else if (entry.getValue() instanceof InputStream) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(InputStream) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				} else if (entry.getValue() instanceof File) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(File) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				}
			}
			post.setEntity(multipartEntityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T postMultipartT(String uri, Map<String, Object> params,
			com.pier.httpclient.config.RequestConfig config,
			ResponseHandler<T> handler, HttpContext context) {
		// TODO Auto-generated method stub
		HttpPost post = null;
		T value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		if (params != null) {
			MultipartEntityBuilder multipartEntityBuilder = MultipartEntityBuilder
					.create();
			multipartEntityBuilder
					.setCharset(config.getCharset() == null ? Charset
							.forName("UTF-8") : config.getCharset());
			for (Map.Entry<String, Object> entry : params.entrySet()) {
				if (entry.getValue() instanceof String) {
					multipartEntityBuilder.addTextBody(entry.getKey(),
							(String) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA);
				} else if (entry.getValue() instanceof InputStream) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(InputStream) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				} else if (entry.getValue() instanceof File) {
					multipartEntityBuilder.addBinaryBody(entry.getKey(),
							(File) entry.getValue(),
							ContentType.MULTIPART_FORM_DATA, "");
				}
			}
			post.setEntity(multipartEntityBuilder.build());
		}
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(post, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	@Override
	public String postStreamStr(String uri, InputStream stream,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		String value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_OCTET_STREAM.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setStream(stream);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = EntityUtils.toString(
						response.getEntity(),
						(config.getCharset() == null ? EntityUtils
								.getCharset(response.getEntity()) : config
								.getCharset()));
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public byte[] postStreamBytes(String uri, InputStream stream,
			com.pier.httpclient.config.RequestConfig config) {
		// TODO Auto-generated method stub
		HttpResponse response = null;
		HttpPost post = null;
		byte[] value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_OCTET_STREAM.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setStream(stream);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				response = httpClient.execute(post);
				value = IOUtils.toByteArray(response.getEntity().getContent());
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {
				closeResponse(response);
			}
		}
		return value;
	}

	@Override
	public <T> T postStreamT(String uri, InputStream stream,
			com.pier.httpclient.config.RequestConfig config,
			ResponseHandler<T> handler, HttpContext context) {
		// TODO Auto-generated method stub
		HttpPost post = null;
		T value = null;
		try {
			URL url = new URL(uri);
			post = new HttpPost(new URI(url.getProtocol(), url.getUserInfo(),
					url.getHost(), url.getPort(), url.getPath(),
					url.getQuery(), null));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("构造post请求发生异常!", e);
			return value;
		}
		post = setConfig(post, config);
		post = setCookies(post, config);
		post = setHeaders(post, config);
		EntityBuilder entityBuilder = EntityBuilder.create();
		entityBuilder.setContentType(ContentType.create(
				ContentType.APPLICATION_OCTET_STREAM.getMimeType(), (config
						.getCharset() == null ? Charset.forName("UTF-8")
						: config.getCharset())));
		entityBuilder.setStream(stream);
		post.setEntity(entityBuilder.build());
		int retryCount = 0;
		while (retryCount < config.getRetryCount()) {
			try {
				value = httpClient.execute(post, handler, context);
				break;
			} catch (Exception e) {
				// TODO: handle exception
				retryCount++;
				logger.error("执行post请求发生异常，准备进行第[" + (retryCount + 1) + "]次尝试",
						e);
			} finally {

			}
		}
		return value;
	}

	/**
	 * 
	 * 描述： 添加http连接管理
	 * 
	 * @author Caliph CHEN
	 * @date 2014年8月26日
	 *
	 */
	private static class HttpConnMonitorThread extends Thread {
		private PoolingHttpClientConnectionManager mgr;
		private boolean shutDownFlag;

		public HttpConnMonitorThread(PoolingHttpClientConnectionManager mgr) {
			super();
			this.mgr = mgr;
			this.setDaemon(true);
			this.setName("HttpConnectionMonitorThread");
		}

		@Override
		public void run() {
			try {
				while (!shutDownFlag) {
					Thread.sleep(30000);
					this.mgr.closeExpiredConnections();
					this.mgr.closeIdleConnections(30000, TimeUnit.MILLISECONDS);
				}
			} catch (InterruptedException ex) {
				// do nothing here, exit
			}
		}

		public void shutdown() {
			this.shutDownFlag = true;
		}
	}

	/**
	 * 
	 * 描述： 关闭返回流
	 * 
	 * @param response
	 */
	public void closeResponse(HttpResponse response) {
		if (response != null && response.getEntity() != null) {
			org.apache.http.util.EntityUtils.consumeQuietly(response
					.getEntity());
		}
	}

	/**
	 * 
	 * 描述： 设置请求对象的请求配置
	 * 
	 * @param t
	 * @param config
	 * @return
	 */
	protected <T extends HttpRequestBase> T setConfig(T t,
			com.pier.httpclient.config.RequestConfig config) {
		RequestConfig config2 = RequestConfig
				.custom()
				.setConnectionRequestTimeout(
						config.getConnectionRequestTimeout())
				.setConnectTimeout(config.getConnectTimeout())
				.setMaxRedirects(config.getMaxRedirects())
				.setSocketTimeout(config.getSocketTimeout())
				.setRedirectsEnabled(config.isRedirectsEnabled())
				.setRelativeRedirectsAllowed(
						config.isRelativeRedirectsAllowed()).build();
		t.setConfig(config2);
		return t;
	}

	/**
	 * 
	 * 描述： 设置请求对象的cookies配置
	 * 
	 * @param t
	 * @param config
	 * @return
	 */
	protected <T extends HttpRequestBase> T setCookies(T t,
			com.pier.httpclient.config.RequestConfig config) {
		if (config.getCookies().size() > 0) {
			StringBuilder cookieBuilder = new StringBuilder();
			for (Map.Entry<String, String> entry : config.getCookies()
					.entrySet()) {
				cookieBuilder.append(entry.getKey());
				cookieBuilder.append("=");
				cookieBuilder.append(entry.getValue());
				cookieBuilder.append(";");
			}
			t.addHeader("Cookie",
					cookieBuilder.substring(0, cookieBuilder.length() - 1));
		}
		return t;
	}

	/**
	 * 
	 * 描述： 设置请求对象的headers配置
	 * 
	 * @param t
	 * @param config
	 * @return
	 */
	protected <T extends HttpRequestBase> T setHeaders(T t,
			com.pier.httpclient.config.RequestConfig config) {
		if (config.getHeaders().size() > 0) {
			for (Map.Entry<String, String> entry : config.getHeaders()
					.entrySet()) {
				t.addHeader(entry.getKey(), entry.getValue());
			}
		}
		return t;
	}
}
