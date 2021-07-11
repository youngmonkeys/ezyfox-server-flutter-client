//
//  EzyNativeDataSerializer.h
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EzyNativeDataSerializer : NSObject
-(NSArray*)toWritableArray:(void*)arrayValue;
-(NSDictionary*)toWritableMap:(void*)objectValue;
-(void)serialize:(NSMutableArray*)output value:(void*)value;
-(void)serialize:(NSDictionary*)output key:(const void*)key value:(void*)value;
@end

NS_ASSUME_NONNULL_END
