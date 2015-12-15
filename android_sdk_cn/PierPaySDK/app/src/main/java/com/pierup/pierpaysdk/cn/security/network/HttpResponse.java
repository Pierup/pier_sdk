package com.pierup.pierpaysdk.cn.security.network;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * Created by wangbei on 12/9/15.
 */
public class HttpResponse implements Serializable {

	private static final long serialVersionUID = 5847719786957029870L;

	/**
	 * The id of the request
	 */
	public int requestId;

	/**
	 * @see java.net.HttpURLConnection#getContentEncoding()
	 */
	public String contentEncoding;

	/**
	 * @see java.net.HttpURLConnection#getContentLength()
	 */
	public int contentLength;

	/**
	 * @see java.net.HttpURLConnection#getContentType()
	 */
	public String contentType;

	/**
	 * @see java.net.HttpURLConnection#getDate()
	 */
	public long date;

	/**
	 * @see java.net.HttpURLConnection#getExpiration()
	 */
	public long expiration;

	/**
	 * @see java.net.HttpURLConnection#getHeaderFields()
	 */
	public Map<String, List<String>> headerFields;

	/**
	 * @see java.net.HttpURLConnection#getIfModifiedSince()
	 */
	public long ifModifiedSince;

	/**
	 * @see java.net.HttpURLConnection#getLastModified()
	 */
	public long lastModified;

	/**
	 * @see java.net.HttpURLConnection#getResponseMessage()
	 */
	public String responseMessage;

	/**
	 * @see java.net.HttpURLConnection#getRequestMethod()
	 */
	public String requestMethod;

	/**
	 * @see java.net.HttpURLConnection#getRequestProperties()
	 */
	public Map<String, List<String>> requestProperties;

	/**
	 * The body of the response from either
	 * {@link java.net.HttpURLConnection#getInputStream()} or
	 * {@link java.net.HttpURLConnection#getErrorStream()}
	 */
	public String responseBody;

	/**
	 * @see java.net.HttpURLConnection#getResponseCode()
	 */
	public int responseCode;

	/**
	 * An exception that was thrown during the request or a generated one when
	 */
	public Throwable throwable;

	/**
	 * The url as a String. Derived from
	 * {@link java.net.HttpURLConnection#getURL()}.
	 */
	public String url;

	/**
	 * Creates a new empty HttpResponse object
	 */
	protected HttpResponse() {}

	/**
	 * Creates a new HttpResponse object
	 * 
	 * @param method
	 * @param url
	 */
	protected HttpResponse(final int requestId, final HttpMethod method, final String url) {
		this.requestId = requestId;
		this.requestMethod = method.toString();
		this.url = url;
	}

}