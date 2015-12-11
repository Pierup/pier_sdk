/*
	Android Asynchronous HttpURLConnection
	Copyright 2011 Chris Roemmich <chris@cr-wd.com>
	https://cr-wd.com

	Licensed under the Apache License, Version 2.0 (the "License");
 	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package com.pierup.pierpaysdk.cn.security.network;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.http.util.ByteArrayBuffer;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

public class HttpClient {

	private static final String TAG = HttpClient.class.getSimpleName();

	private static final int DEFAULT_READ_TIMEOUT = 10000;
	private static final int DEFAULT_CONNECT_TIMEOUT = 15000;
	private static final int DEFAULT_MAX_RETRIES = 5;
	private static final String DEFAULT_ENCODING = "UTF-8";

	private final RequestOptions requestOptions = new RequestOptions();

	private class RequestOptions {
		public int readTimeout = DEFAULT_READ_TIMEOUT;
		public int connectTimeout = DEFAULT_CONNECT_TIMEOUT;
		public int maxRetries = DEFAULT_MAX_RETRIES;
		public String encoding = DEFAULT_ENCODING;
	}

	private int requestId = 0;

	/* Stores currently running requests */
	/* Allows communication with the running request thread */
	protected ConcurrentHashMap<Integer, WeakReference<Handler>> requests = new ConcurrentHashMap<Integer, WeakReference<Handler>>();

	/**
	 * Supported HTTP request methods
	 */
	public static enum Method {
		GET, POST
	}

	/**
	 * Create a new HttpClient
	 */
	public HttpClient() {}

	/**
	 * Perform a HTTP GET request, without any parameters.
	 * 
	 * @param url
	 *            the URL
	 * @param responseHandler
	 *            the response handler
	 */
	public int get(final String url, final HttpHandler handler) {
		return doRequest(Method.GET, url, null, null, handler);
	}

	/**
	 * Perform a HTTP GET request with additional headers
	 * 
	 * @param url
	 *            the URL
	 * @param headers
	 *            additional headers for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int get(final String url, final HttpHeaders headers, final HttpHandler handler) {
		return doRequest(Method.GET, url, headers, null, handler);
	}

	/**
	 * Perform a HTTP GET request with parameters
	 * 
	 * @param url
	 *            the URL
	 * @param params
	 *            additional parameters for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int get(final String url, final HttpParams params, final HttpHandler handler) {
		return doRequest(Method.GET, url, null, params, handler);
	}

	/**
	 * Perform a HTTP GET request with additional headers and parameters
	 * 
	 * @param url
	 *            the URL
	 * @param headers
	 *            additional headers for the request
	 * @param params
	 *            additional parameters for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int get(final String url, final HttpHeaders headers, final HttpParams params, final HttpHandler handler) {
		return doRequest(Method.GET, url, headers, params, handler);
	}

	/**
	 * Perform a HTTP GET request, without any parameters.
	 * 
	 * @param url
	 *            the URL
	 * @param responseHandler
	 *            the response handler
	 */
	public int post(final String url, final HttpHandler handler) {
		return doRequest(Method.POST, url, null, null, handler);
	}

	/**
	 * Perform a HTTP POST request with additional headers
	 * 
	 * @param url
	 *            the URL
	 * @param headers
	 *            additional headers for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int post(final String url, final HttpHeaders headers, final HttpHandler handler) {
		return doRequest(Method.POST, url, headers, null, handler);
	}

	/**
	 * Perform a HTTP POST request with parameters
	 * 
	 * @param url
	 *            the URL
	 * @param params
	 *            additional parameters for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int post(final String url, final HttpParams params, final HttpHandler handler) {
		return doRequest(Method.POST, url, null, params, handler);
	}

	/**
	 * Perform a HTTP POST request with additional headers and parameters
	 * 
	 * @param url
	 *            the URL
	 * @param headers
	 *            additional headers for the request
	 * @param params
	 *            additional parameters for the request
	 * @param responseHandler
	 *            the response handler
	 */
	public int post(final String url, final HttpHeaders headers, final HttpParams params, final HttpHandler handler) {
		return doRequest(Method.POST, url, headers, params, handler);
	}

	/**
	 * Performs a HTTP GET/POST Request
	 * 
	 * @return id of the request
	 */
	protected int doRequest(final Method method, final String url, HttpHeaders headers, HttpParams params, final HttpHandler handler) {
		if (headers == null) {
			headers = new HttpHeaders();
		}
		if (params == null) {
			params = new HttpParams();
		}

		handler.client = this;

		final int requestId = incrementRequestId();

		class HandlerRunnable extends Handler implements Runnable {

			private final Method method;
			private String url;
			private final HttpHeaders headers;
			private final HttpParams params;
			private final HttpHandler handler;
			private HttpResponse response;

			private boolean canceled = false;
			private int retries = 0;

			protected HandlerRunnable(final Method method, final String url, final HttpHeaders headers, final HttpParams params, final HttpHandler handler) {
				this.method = method;
				this.url = url;
				this.headers = headers;
				this.params = params;
				this.handler = handler;
			}

			@Override public void run() {
				execute();
			}

			private void execute() {
				response = new HttpResponse(requestId, method, url);

				HttpURLConnection conn = null;
				try {
					/* append query string for GET requests */
					if (method == Method.GET) {
						if (!params.urlParams.isEmpty()) {
							url += ('?' + params.getParamString());
						}
					}

					/* setup headers for POST requests */
					if (method == Method.POST) {
						headers.addHeader("Accept-Charset", requestOptions.encoding);
						if (params.hasMultipartParams()) {
							final SimpleMultipart multipart = params.getMultipart();
							headers.addHeader("Content-Type", multipart.getContentType());
						} else {
//							headers.addHeader("Content-Type", "application/x-www-form-urlencoded;charset=" + requestOptions.encoding);
							headers.addHeader("Content-Type", "application/json");
						}
					}

					if (canceled) {
						postCancel();
						return;
					}

					/* open and configure the connection */
					conn = (HttpURLConnection) new URL(url).openConnection();

					postStart();

					if (method == Method.GET) {
						conn = (HttpURLConnection) new URL(url).openConnection();
						conn.setRequestMethod("GET");
					} else if (method == Method.POST) {
						conn.setRequestMethod("POST");
						conn.setDoOutput(true);
						conn.setDoInput(true);
						conn.setUseCaches(false);
					}
					conn.setAllowUserInteraction(false);
					conn.setReadTimeout(requestOptions.readTimeout);
					conn.setConnectTimeout(requestOptions.connectTimeout);

					/* add headers to the connection */
					for (final Map.Entry<String, List<String>> entry : headers.getHeaders().entrySet()) {
						for (final String value : entry.getValue()) {
							conn.addRequestProperty(entry.getKey(), value);
						}
					}

					if (canceled) {
						try {
							conn.disconnect();
						} catch (final Exception e) {}
						postCancel();
						return;
					}

					response.requestProperties = conn.getRequestProperties();

					/* do post */
					if (method == Method.POST) {
						InputStream is;

						if (params.hasMultipartParams()) {
							is = params.getMultipart().getContent();
						} else {
							is = new ByteArrayInputStream(params.getParamString().getBytes());
						}

						final OutputStream os = conn.getOutputStream();

						writeStream(os, is);
					} else {
						conn.connect();
					}

					if (canceled) {
						try {
							conn.disconnect();
						} catch (final Exception e) {}
						postCancel();
						return;
					}

					response.contentEncoding = conn.getContentEncoding();
					response.contentLength = conn.getContentLength();
					response.contentType = conn.getContentType();
					response.date = conn.getDate();
					response.expiration = conn.getExpiration();
					response.headerFields = conn.getHeaderFields();
					response.ifModifiedSince = conn.getIfModifiedSince();
					response.lastModified = conn.getLastModified();
					response.responseCode = conn.getResponseCode();
					response.responseMessage = conn.getResponseMessage();

					/* do get */
					if (conn.getResponseCode() < 400) {
						response.responseBody = readStream(conn.getInputStream());
						postSuccess();
					} else {
						response.responseBody = readStream(conn.getErrorStream());
						response.throwable = new Exception(response.responseMessage);
						postError();
					}

				} catch (final Exception e) {
					if (retries < requestOptions.maxRetries) {
						retries++;
						postRetry();
						execute();
					} else {
						response.responseBody = e.getMessage();
						response.throwable = e;
						postError();
					}
				} finally {
					if (conn != null) {
						conn.disconnect();
					}
				}
			}

			private String readStream(final InputStream is) throws IOException {
				final BufferedInputStream bis = new BufferedInputStream(is);
				final ByteArrayBuffer baf = new ByteArrayBuffer(50);
				int read = 0;
				final byte[] buffer = new byte[8192];
				while (true) {
					if (canceled) {
						break;
					}

					read = bis.read(buffer);
					if (read == -1) {
						break;
					}
					baf.append(buffer, 0, read);
				}

				try {
					bis.close();
				} catch (final IOException e) {}

				try {
					is.close();
				} catch (final IOException e) {}

				return new String(baf.toByteArray());
			}

			private void writeStream(final OutputStream os, final InputStream is) throws IOException {
				final BufferedInputStream bis = new BufferedInputStream(is);
				int read = 0;
				final byte[] buffer = new byte[8192];
				while (true) {
					if (canceled) {
						break;
					}

					read = bis.read(buffer);
					if (read == -1) {
						break;
					}
					os.write(buffer, 0, read);
				}

				if (!canceled) {
					os.flush();
				}

				try {
					os.close();
				} catch (final IOException e) {}

				try {
					bis.close();
				} catch (final IOException e) {}

				try {
					is.close();
				} catch (final IOException e) {}
			}

			@Override public void handleMessage(final Message msg) {
				if (msg.what == HttpHandler.MESSAGE_CANCEL) {
					canceled = true;
				}
			}

			private void postSuccess() {
				postMessage(HttpHandler.MESSAGE_SUCCESS);
			}

			private void postError() {
				postMessage(HttpHandler.MESSAGE_ERROR);
			}

			private void postCancel() {
				postMessage(HttpHandler.MESSAGE_CANCEL);
			}

			private void postStart() {
				postMessage(HttpHandler.MESSAGE_START);
			}

			private void postRetry() {
				postMessage(HttpHandler.MESSAGE_RETRY);
			}

			private void postMessage(final int what) {
				final Message msg = handler.obtainMessage();
				msg.what = what;
				msg.arg1 = requestId;
				msg.obj = response;
				handler.sendMessage(msg);
			}
		}
		;
		/* Create a new HandlerRunnable and start it */
		final HandlerRunnable hr = new HandlerRunnable(method, url, headers, params, handler);
		requests.put(requestId, new WeakReference<Handler>(hr));
		new Thread(hr).start();

		/* Return with the request id */
		return requestId;
	}

	/**
	 * Cancels a request by Id
	 * 
	 * @param requestId
	 *            the request id
	 * @return True if the cancel message was sent. Does not indicate that
	 *         message was actually processed before the request finished, thus
	 *         not all requests will actually be canceled.
	 */
	public boolean cancel(final int requestId) {
		try {
			if (requests.containsKey(requestId)) {
				final WeakReference<Handler> wr = requests.get(requestId);
				final Handler h = wr.get();
				if (h != null) {
					h.sendEmptyMessage(HttpHandler.MESSAGE_CANCEL);
					return true;
				}
			}
		} catch (final Exception e) {
			Log.w(TAG, e.getMessage());
		}
		return false;
	}

	/**
	 * Gets the HttpURLConnection readTimeout
	 * 
	 * @return readTimeout in milliseconds
	 */
	public int getReadTimeout() {
		return requestOptions.readTimeout;
	}

	/**
	 * Set the HttpURLConnection readTimeout
	 * 
	 * @param readTimeout
	 *            in milliseconds
	 */
	public void setReadTimeout(final int readTimeout) {
		requestOptions.readTimeout = readTimeout;
	}

	/**
	 * Gets the HttpURLConnection connectTimeout
	 * 
	 * @return connectTimeout in milliseconds
	 */
	public int getConnectTimeout() {
		return requestOptions.connectTimeout;
	}

	/**
	 * Set the HttpURLConnection connectTimeout
	 * 
	 * @param connectTimeout
	 *            in milliseconds
	 */
	public void setConnectTimeout(final int connectTimeout) {
		requestOptions.connectTimeout = connectTimeout;
	}

	/**
	 * Get the max number of retries
	 * 
	 * @return number of retries
	 */
	public int getMaxRetries() {
		return requestOptions.maxRetries;
	}

	/**
	 * Sets the max number of retries
	 * 
	 * @param maxRetries
	 */
	public void setMaxRetries(final int maxRetries) {
		requestOptions.maxRetries = maxRetries;
	}

	private synchronized int incrementRequestId() {
		return requestId++;
	}

}