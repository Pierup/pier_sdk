package com.pier.httpclient.util;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.IllegalCharsetNameException;
import java.nio.charset.UnsupportedCharsetException;
import java.util.Locale;
import java.util.Scanner;


import org.apache.http.Header;
import org.apache.http.HeaderElement;
import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;

/**
 * 
 * 描述：
 * 爬虫返回实体转换工具
 * @author caliph
 * @date 2014年5月22日
 *
 */
public class EntityUtils {
	/**
	 * 
	 * 描述： 
	 * 将HttpEntity转换为字符串
	 * @param entity
	 * @param charset
	 * @return
	 * @throws IOException
	 */
	public static String toString(final HttpEntity entity, final Charset charset)throws Exception
	{
		Scanner scanner=null;
		StringBuilder sb=new StringBuilder();
		if (entity!=null) {
			try {
				scanner=new Scanner(entity.getContent(), charset.displayName(Locale.CHINESE));
				while (scanner.hasNextLine()) {
					sb.append(scanner.nextLine()).append("\n");
				}
			}finally{
				if (scanner!=null) {
					scanner.close();
				}
			}
		}
		return sb.toString();
	}
	/**
	 * 
	 * 描述： 
	 * 获取实体的编码
	 * @param entity
	 * @return
	 * @throws Exception
	 */
	public static Charset getCharset(final HttpEntity entity)throws Exception
	{
		if (entity==null) {
			return Charset.defaultCharset();
		}
		Header contentType=entity.getContentType();
		if (contentType==null) {
			return Charset.defaultCharset();
		}
		HeaderElement[] elements=contentType.getElements();
		for(HeaderElement element:elements)
		{
			for(NameValuePair nameValue:element.getParameters())
			{
				if ("charset".equalsIgnoreCase(nameValue.getName())) {
					try {
						return Charset.forName(nameValue.getValue());
					} catch (UnsupportedCharsetException e) {
						// TODO: handle exception
						return Charset.defaultCharset();
					}catch (IllegalCharsetNameException e) {
						// TODO: handle exception
						return Charset.defaultCharset();
					}
				}
			}
		}
		return Charset.defaultCharset();
	}
}
