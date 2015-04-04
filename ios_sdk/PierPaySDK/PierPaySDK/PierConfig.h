//
//  PierConfig.h
//  PierPaySDK
//
//  Created by zyma on 1/13/15.
//  Copyright (c) 2015 Pier.Inc. All rights reserved.
//

#ifndef PierPaySDK_PIRConfig_h
#define PierPaySDK_PIRConfig_h

/** --- */
#define DEBUG_ENV

/** --- */
#ifdef DEBUG_ENV
#define DLog(format, ...) NSLog((@"%s@%d: " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(format, ...)
#endif
/** --- */

#endif
