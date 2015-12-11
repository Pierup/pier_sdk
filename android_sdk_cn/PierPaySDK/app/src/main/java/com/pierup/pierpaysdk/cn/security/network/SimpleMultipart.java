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
 This code adapted from Rafael Sanches' blog.
 http://blog.rafaelsanches.com/2011/01/29/upload-using-multipart-post-using-httpclient-in-android/
 */

package com.pierup.pierpaysdk.cn.security.network;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Random;

public class SimpleMultipart {
	private final static char[] MULTIPART_CHARS = "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();

	private String boundary = null;

	protected ByteArrayOutputStream out = new ByteArrayOutputStream();

	private boolean isSetLast = false;
	private boolean isSetFirst = false;

	protected SimpleMultipart() {
		final StringBuffer buf = new StringBuffer();
		final Random rand = new Random();
		for (int i = 0; i < 30; i++) {
			buf.append(MULTIPART_CHARS[rand.nextInt(MULTIPART_CHARS.length)]);
		}
		this.boundary = buf.toString();
	}

	protected void writeFirstBoundaryIfNeeds() throws IOException {
		if (!isSetFirst) {
			out.write(("--" + boundary + "\r\n").getBytes());
		}

		isSetFirst = true;
	}

	protected void writeLastBoundaryIfNeeds() throws IOException {
		if (isSetLast) {
			return;
		}
		out.write(("\r\n--" + boundary + "--\r\n").getBytes());

		isSetLast = true;
	}

	protected void addPart(final String key, final String value) throws IOException {
		writeFirstBoundaryIfNeeds();
		out.write(("Content-Disposition: form-data; name=\"" + key + "\"\r\n\r\n").getBytes());
		out.write(value.getBytes());
		out.write(("\r\n--" + boundary + "\r\n").getBytes());
	}

	protected void addPart(final String key, final String fileName, final InputStream fin, final boolean isLast) throws IOException {
		addPart(key, fileName, fin, "application/octet-stream", isLast);
	}

	protected void addPart(final String key, final String fileName, final InputStream fin, String type, final boolean isLast) throws IOException {
		writeFirstBoundaryIfNeeds();
		try {
			type = "Content-Type: " + type + "\r\n";
			out.write(("Content-Disposition: form-data; name=\"" + key + "\"; filename=\"" + fileName + "\"\r\n").getBytes());
			out.write(type.getBytes());
			out.write("Content-Transfer-Encoding: binary\r\n\r\n".getBytes());

			final byte[] tmp = new byte[4096];
			int l = 0;
			while ((l = fin.read(tmp)) != -1) {
				out.write(tmp, 0, l);
			}
			if (!isLast) {
				out.write(("\r\n--" + boundary + "\r\n").getBytes());
			}
			out.flush();
		} catch (final IOException e) {
			throw e;
		} finally {
			fin.close();
		}
	}

	protected void addPart(final String key, final File value, final boolean isLast) throws IOException {
		addPart(key, value.getName(), new FileInputStream(value), isLast);
	}

	protected long getContentLength() throws IOException {
		writeLastBoundaryIfNeeds();
		return out.toByteArray().length;
	}

	protected String getContentType() {
		return "multipart/form-data; boundary=" + boundary;
	}

	protected InputStream getContent() throws IOException {
		return new ByteArrayInputStream(out.toByteArray());
	}
}