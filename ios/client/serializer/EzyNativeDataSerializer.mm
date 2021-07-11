//
//  EzyNativeDataSerializer.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import "EzyNativeDataSerializer.h"
#include "EzyHeaders.h"
#import "../util/EzyNativeStrings.h"

EZY_USING_NAMESPACE;
EZY_USING_NAMESPACE::entity;

@implementation EzyNativeDataSerializer

-(NSArray*)toWritableArray:(void*)arrayValue {
    EzyArray* value = (EzyArray*)arrayValue;
    NSMutableArray* answer = [NSMutableArray array];
    if(value) {
        for (int i = 0; i < value->size(); ++i) {
            EzyValue* item = value->getItem(i);
            [self serialize:answer value:item];
        }
    }
    return answer;
}

-(NSDictionary*)toWritableMap:(void*)objectValue {
    EzyObject* value = (EzyObject*)objectValue;
    NSDictionary* answer = [NSMutableDictionary dictionary];
    if(value) {
        std::vector<std::string> keys = value->getKeys();
        for(int i = 0 ; i < keys.size() ; ++i) {
            EzyValue* val = value->getItem(keys[i]);
            [self serialize:answer key:keys[i].c_str() value:val];
        }
    }
    return answer;
}

-(void)serialize:(NSMutableArray*)output value:(void*)value {
    if(value) {
        NSObject* svalue = [self serializeValue:(EzyValue*)value];
        if(svalue)
            [output addObject:svalue];
        else
            [output addObject:[NSNull null]];
    }
    else {
        [output addObject:[NSNull null]];
    }
}

-(void)serialize:(NSDictionary*)output key:(const void*)key value:(void*)value {
    if(value) {
        NSObject* svalue = [self serializeValue:(EzyValue*)value];
        NSString* skey = [EzyNativeStrings newNSString:(const char*)key];
        [output setValue:svalue forKey:skey];
    }
}

-(NSObject*)serializeValue:(EzyValue*)value {
    switch (value->getType()) {
        case TypeBool:
            return [NSNumber numberWithBool:((EzyPrimitive*)value)->getBool()];
        case TypeFloat:
            return [NSNumber numberWithFloat:((EzyPrimitive*)value)->getFloat()];
        case TypeDouble:
            return [NSNumber numberWithDouble:((EzyPrimitive*)value)->getDouble()];
        case TypeInt:
            return [NSNumber numberWithLong:((EzyPrimitive*)value)->getInt()];
        case TypeUInt:
            return [NSNumber numberWithUnsignedLong:((EzyPrimitive*)value)->getUInt()];
        case TypeString:
            return [NSString stringWithUTF8String:((EzyString*)value)->getString().c_str()];
        case TypeDict:
            return [self toWritableMap:value];
        case TypeArray:
            return [self toWritableArray:value];
        default:
            break;
    }
    return nil;
}

@end
