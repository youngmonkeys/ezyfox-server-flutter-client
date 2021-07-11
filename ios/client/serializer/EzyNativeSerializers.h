//
//  EzyNativeSerializers.h
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EzyNativeSerializers : NSObject
+(NSDictionary*)serializeEvent:(void*)event;
+(NSDictionary*)serializeClientConfig:(void*)clientConfig;
+(NSArray*)toWritableArray:(void*)arrayValue;
+(void*)fromReadableArray:(NSArray*)value;
@end

NS_ASSUME_NONNULL_END
