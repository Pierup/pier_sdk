package com.pierup.pierpaysdk.cn.security.network;

import android.os.Handler;
import android.os.Message;

/**
 * Used to handle the responses made using {@link HttpClient}. The methods
 * {@link #onSuccess(HttpResponse)}, {@link #onError(HttpResponse)},and
 * {@link #onCancel(HttpResponse)}, {@link #onRetry(HttpResponse)} are designed
 * to be anonymously overridden with your own response handling code.
 */

/**
 * Created by wangbei on 12/9/15.
 */
public abstract class HttpHandler extends Handler {

	protected HttpClient client;

	/* Message Constants */
	public static final int MESSAGE_SUCCESS = 1;
	public static final int MESSAGE_ERROR = 2;
	public static final int MESSAGE_CANCEL = 3;
	public static final int MESSAGE_RETRY = 4;
	public static final int MESSAGE_START = 5;

	/**
	 * Called when the response completed successfully
	 *
	 * @param response
	 *            response string
	 */
	public abstract void onSuccess(HttpResponse response);

	/**
	 * Called when an error occurred while making the request
	 *
	 * @param response
	 *            error string, may be null
	 */
	public abstract void onError(HttpResponse response);

	/**
	 * Called when the request was canceled
	 */
	public abstract void onCancel(HttpResponse response);

	/**
	 * Called when the request was retried
	 */
	public abstract void onRetry(HttpResponse response);

	/**
	 * Called when the request begins
	 */
	public abstract void onStart(HttpResponse response);

	@Override public void handleMessage(final Message msg) {
		final int requestId = msg.arg1;
		switch (msg.what) {
		case MESSAGE_SUCCESS:
			if (client.requests.containsKey(requestId)) {
				client.requests.remove(requestId);
			}
			onSuccess((HttpResponse) msg.obj);
			break;
		case MESSAGE_ERROR:
			if (client.requests.containsKey(requestId)) {
				client.requests.remove(requestId);
			}
			onError((HttpResponse) msg.obj);
			break;
		case MESSAGE_CANCEL:
			if (client.requests.containsKey(requestId)) {
				client.requests.remove(requestId);
			}
			onCancel((HttpResponse) msg.obj);
			break;
		case MESSAGE_RETRY:
			onRetry((HttpResponse) msg.obj);
			break;
		case MESSAGE_START:
			onStart((HttpResponse) msg.obj);
		}
	}
}