//
//  EzyNativeSerializers.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import "EzyNativeSerializers.h"
#import "EzyEventSerializer.h"
#import "EzyClientConfigSerializer.h"
#import "EzyNativeDataSerializer.h"
#import "EzyNativeDataDeserializer.h"

static EzyEventSerializer* sEventSerializer = [[EzyEventSerializer alloc] init];
static EzyClientConfigSerializer* sClientConfigSerializer = [[EzyClientConfigSerializer alloc] init];
static EzyNativeDataSerializer* sNativeDataSerializer = [[EzyNativeDataSerializer alloc] init];
static EzyNativeDataDeserializer* sNativeDataDeserializer = [[EzyNativeDataDeserializer alloc] init];

@implementation EzyNativeSerializers
+(NSDictionary *)serializeEvent:(void *)event {
    NSDictionary* answer = [sEventSerializer serialize:event];
    return answer;
}

+ (NSDictionary *)serializeClientConfig:(void *)clientConfig {
    NSDictionary* answer = [sClientConfigSerializer serialize:clientConfig];
    return answer;
}

+(NSArray *)toWritableArray:(void *)arrayValue {
    NSArray* answer = [sNativeDataSerializer toWritableArray:arrayValue];
    return answer;
}

+ (void *)fromReadableArray:(NSArray *)value {
    void* answer = [sNativeDataDeserializer fromReadableArray:value];
    return answer;
}
@end
