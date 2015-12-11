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

/*
 Adapted from https://github.com/loopj/android-async-http/blob/master/src/com/loopj/android/http/RequestParams.java
 */

package com.pierup.pierpaysdk.cn.security.network;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;

public class HttpParams implements Serializable {

	private static final long serialVersionUID = -6376078803512393464L;

	protected String encoding = "UTF-8";

	protected ConcurrentMap<String, String> urlParams = new ConcurrentHashMap<String, String>();
	protected ConcurrentMap<String, FileWrapper> fileParams = new ConcurrentHashMap<String, FileWrapper>();

	/**
	 * Creates a new HttpParams object
	 */
	public HttpParams() {}

	/**
	 * Constructs a new RequestParams instance containing the key/value string
	 * params from the specified map.
	 * 
	 * @param source
	 *            the source key/value string map to add.
	 */
	public HttpParams(final Map<String, String> source) {
		for (final Map.Entry<String, String> entry : source.entrySet()) {
			put(entry.getKey(), entry.getValue());
		}
	}

	/**
	 * Constructs a new RequestParams instance and populate it with a single
	 * initial key/value string param.
	 * 
	 * @param key
	 *            the key name for the intial param.
	 * @param value
	 *            the value string for the initial param.
	 */
	public HttpParams(final String key, final String value) {
		put(key, value);
	}

	/**
	 * Adds a key/value string pair to the request.
	 * 
	 * @param key
	 *            the key name for the new param.
	 * @param value
	 *            the value string for the new param.
	 */
	public void put(final String key, final String value) {
		if (key != null && value != null) {
			urlParams.put(key, value);
		}
	}

	/**
	 * Adds a key/value pair to the request. Calls Object.toString() to
	 * determine value.
	 * 
	 * @param key
	 * @param value
	 */
	public void put(final String key, final Object value) {
		put(key, value.toString());
	}

	/**
	 * Adds a file to the request.
	 * 
	 * @param key
	 *            the key name for the new param.
	 * @param file
	 *            the file to add.
	 */
	public void put(final String key, final File file) throws FileNotFoundException {
		put(key, new FileInputStream(file), file.getName());
	}

	/**
	 * Adds an input stream to the request.
	 * 
	 * @param key
	 *            the key name for the new param.
	 * @param stream
	 *            the input stream to add.
	 */
	public void put(final String key, final InputStream stream) {
		put(key, stream, null);
	}

	/**
	 * Adds an input stream to the request.
	 * 
	 * @param key
	 *            the key name for the new param.
	 * @param stream
	 *            the input stream to add.
	 * @param fileName
	 *            the name of the file.
	 */
	public void put(final String key, final InputStream stream, final String fileName) {
		put(key, stream, fileName, null);
	}

	/**
	 * Adds an input stream to the request.
	 * 
	 * @param key
	 *            the key name for the new param.
	 * @param stream
	 *            the input stream to add.
	 * @param fileName
	 *            the name of the file.
	 * @param contentType
	 *            the content type of the file, eg. application/json
	 */
	public void put(final String key, final InputStream stream, final String fileName, final String contentType) {
		if (key != null && stream != null) {
			fileParams.put(key, new FileWrapper(stream, fileName, contentType));
		}
	}

	/**
	 * Removes a parameter from the request.
	 * 
	 * @param key
	 *            the key name for the parameter to remove.
	 */
	public void remove(final String key) {
		urlParams.remove(key);
		fileParams.remove(key);
	}

	@Override public String toString() {
		final StringBuilder result = new StringBuilder();
		for (final ConcurrentHashMap.Entry<String, String> entry : urlParams.entrySet()) {
			if (result.length() > 0) {
				result.append("&");
			}

			result.append(entry.getKey());
			result.append("=");
			result.append(entry.getValue());
		}

		for (final ConcurrentHashMap.Entry<String, FileWrapper> entry : fileParams.entrySet()) {
			if (result.length() > 0) {
				result.append("&");
			}

			result.append(entry.getKey());
			result.append("=");
			result.append("FILE");
		}

		return result.toString();
	}

	protected List<BasicNameValuePair> getParamsList() {
		final List<BasicNameValuePair> lparams = new LinkedList<BasicNameValuePair>();

		for (final ConcurrentHashMap.Entry<String, String> entry : urlParams.entrySet()) {
			lparams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
		}

		return lparams;
	}

	public String getParamString() {
		return URLEncodedUtils.format(getParamsList(), encoding);
	}

	protected boolean hasMultipartParams() {
		return !fileParams.isEmpty();
	}

	protected SimpleMultipart getMultipart() throws IOException {
		if (fileParams.isEmpty()) {
			return null;
		}

		final SimpleMultipart multipart = new SimpleMultipart();

		// Add string params
		for (final ConcurrentHashMap.Entry<String, String> entry : urlParams.entrySet()) {
			multipart.addPart(entry.getKey(), entry.getValue());
		}

		// Add file params
		int currentIndex = 0;
		final int lastIndex = fileParams.entrySet().size() - 1;
		for (final ConcurrentHashMap.Entry<String, FileWrapper> entry : fileParams.entrySet()) {
			final FileWrapper file = entry.getValue();
			if (file.inputStream != null) {
				final boolean isLast = currentIndex == lastIndex;
				if (file.contentType != null) {
					multipart.addPart(entry.getKey(), file.getFileName(), file.inputStream, file.contentType, isLast);
				} else {
					multipart.addPart(entry.getKey(), file.getFileName(), file.inputStream, isLast);
				}
			}
			currentIndex++;
		}

		return multipart;
	}

	private static class FileWrapper {
		public InputStream inputStream;
		public String fileName;
		public String contentType;

		public FileWrapper(final InputStream inputStream, final String fileName, final String contentType) {
			this.inputStream = inputStream;
			this.fileName = fileName;
			this.contentType = contentType;
		}

		public String getFileName() {
			if (fileName != null) {
				return fileName;
			} else {
				return "nofilename";
			}
		}
	}
}