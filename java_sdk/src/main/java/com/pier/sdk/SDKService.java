package com.pier.sdk;

import com.pier.model.SDKResult;
import com.pier.model.TransactionConfig;

/**
 * 
 * @ClassName: SDKService
* @Description: 声明sdk服务类型
* @author Caliph.Chen clp_job@163.com
* @date 2015年1月21日 下午6:00:42
 */
public interface SDKService {
	public SDKResult transaction(TransactionConfig config);
}
