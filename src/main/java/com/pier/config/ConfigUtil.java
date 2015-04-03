package com.pier.config;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.configuration.SystemConfiguration;
import org.apache.log4j.Logger;

/**
 * 
 * @ClassName: ConfigUtil
* @Description: 全局上下文注册配置应用
* @author Caliph.Chen clp_job@163.com
* @date 2014年11月3日 下午3:05:17
 */
public class ConfigUtil {
	
	private static Logger LOG = Logger.getLogger(ConfigUtil.class);
	
	private static final CompositeConfiguration config = new CompositeConfiguration();
	
	static{
		try {
			LOG.info("properties value list delimiter is '|'");
			CompositeConfiguration.setDefaultListDelimiter('|');
			config.addConfiguration(new SystemConfiguration());
			config.addConfiguration(new PropertiesConfiguration("config.properties"));
		} catch (ConfigurationException e) {
			LOG.error("加载配置文件时出现错误", e);
		}
	}
	
	private ConfigUtil(){
		
	}
	
	/**
	 * 
	*@Title: addConfiguration
	* @Description: 添加配置
	* @param @param configuration 
	*  PropertiesConfiguration: Loads configuration values from a properties file.
		XMLConfiguration: Takes values from an XML document.
		INIConfiguration: Loads the values from a .ini file as used by Windows.
		PropertyListConfiguration: Loads values from an OpenStep .plist file. XMLPropertyListConfiguration is also available to read the XML variant used by Mac OS X.
		JNDIConfiguration: Using a key in the JNDI tree, can retrieve values as configuration properties.
		BaseConfiguration: An in-memory method of populating a Configuration object.
		HierarchicalConfiguration: An in-memory Configuration object that is able to deal with complex structured data.
		SystemConfiguration: A configuration using the system properties 
	* @return void 
	* @throws
	 */
	public static void addConfiguration(Configuration configuration)
	{
		config.addConfiguration(configuration);
	}
	
	/**
	 * 
	*@Title: getConfig
	* @Description: 获取配置
	* @param @param configName
	* @param @param defalutValue
	* @param @return 
	* @return String 
	* @throws
	 */
	public static String getString(String configName,String defaultValue){
		String value = config.getString(configName, defaultValue);
		LOG.info("get config value, ["+configName+"]="+value);
		return value;
	}
	
	/**
	 * 返回Configuration,可以自己调用Configuration里的接口；
	 * @return
	 */
	public static Configuration getConfig(){
		return config;
	}
}
