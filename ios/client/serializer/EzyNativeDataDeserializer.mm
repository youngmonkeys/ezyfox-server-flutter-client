//
//  EzyNativeDataDeserializer.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Flutter/Flutter.h>
#import "EzyNativeDataDeserializer.h"
#import "../math/EzyNSNumber.h"
#import "../util/NSByteArray.h"
#include "EzyHeaders.h"

EZY_USING_NAMESPACE::entity;

@implementation EzyNativeDataDeserializer
- (void *)fromReadableArray:(NSArray *)value {
    EzyArray* array = new EzyArray();
    if(value) {
        for(id item in value)
            [self deserializeToArray:array value:item];
    }
    return array;
}

- (void *) fromReadableMap: (NSDictionary*)value {
    EzyObject* object = new EzyObject();
    if(value) {
        for(id key in value) {
            NSObject* val = [value valueForKey:key];
            [self deserializeToObject:object key:key value:val];
        }
    }
    return object;
}

- (void)deserializeToArray:(EzyArray*)output value:(NSObject*)value {
    if([value isKindOfClass:[NSNumber class]]) {
        EzyPrimitive* item = [self deserializeToPrimitive:value];
        output->addItem(item);
    }
    else if([value isKindOfClass:[EzyNSNumber class]]) {
        EzyNSNumber* number = (EzyNSNumber*)value;
        EzyPrimitive* item = [self deserializeToNumber:number];
        output->addItem(item);
    }
    else if([value isKindOfClass:[NSString class]]) {
        NSString* string = (NSString*)value;
        output->addString([string UTF8String]);
    }
    else if([value isKindOfClass:[NSByteArray class]]) {
        NSByteArray* byteArray = (NSByteArray*)value;
        output->addByteArray(std::string((char*)byteArray.data.bytes, byteArray.size));
    }
    else if([value isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*)value;
        EzyArray* farray = (EzyArray*)[self fromReadableArray:array];
        output->addArray(farray);
    }
    else if([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*)value;
        EzyObject* fobject = (EzyObject*)[self fromReadableMap:dict];
        output->addObject(fobject);
    }
    else if([value isKindOfClass:[NSNull class]]) {
        output->addNull();
    }
    else if([value isKindOfClass:[FlutterStandardTypedData class]]) {
        FlutterStandardTypedData* data = (FlutterStandardTypedData*)value;
        FlutterStandardDataType dataType = [data type];
        if(dataType == FlutterStandardDataTypeUInt8) {
            NSData* realData = [data data];
            output->addByteArray(std::string((char*)[realData bytes], [realData length]));
        }
    }
    else {
        @throw [NSException exceptionWithName:@"NSInvalidArgumentException"
                                       reason: [NSString stringWithFormat:@"has no deserializer for value: %@", value]
                                     userInfo:nil];
    }
}

- (void)deserializeToObject:(EzyObject*)output key:(NSString*)key value:(NSObject*)value {
    std::string k = [key UTF8String];
    if([value isKindOfClass:[NSNumber class]]) {
        EzyPrimitive* item = [self deserializeToPrimitive:value];
        output->addItem(k, item);
    }
    else if([value isKindOfClass:[EzyNSNumber class]]) {
        EzyNSNumber* number = (EzyNSNumber*)value;
        EzyPrimitive* item = [self deserializeToNumber:number];
        output->addItem(k, item);
    }
    else if([value isKindOfClass:[NSString class]]) {
        NSString* string = (NSString*)value;
        output->setString(k, [string UTF8String]);
    }
    else if([value isKindOfClass:[NSArray class]]) {
        NSArray* array = (NSArray*)value;
        EzyArray* farray = (EzyArray*)[self fromReadableArray:array];
        output->setArray(k, farray);
    }
    else if([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*)value;
        EzyObject* fobject = (EzyObject*)[self fromReadableMap:dict];
        output->setObject(k, fobject);
    }
    else {
        @throw [NSException exceptionWithName:@"NSInvalidArgumentException"
                                       reason: [NSString stringWithFormat:@"has no deserializer for key: %@, value: %@", key, value]
                                     userInfo:nil];
    }
}

-(EzyPrimitive*)deserializeToNumber:(EzyNSNumber*)value {
    EzyPrimitive* item = new EzyPrimitive();
    switch ([value getType]) {
        case NUMBER_TYPE_BOOL:
            item->setBool([value boolValue]);
            break;
        case NUMBER_TYPE_DOUBLE:
            item->setDouble([value doubleValue]);
            break;
        case NUMBER_TYPE_FLOAT:
            item->setFloat([value floatValue]);
            break;
        case NUMBER_TYPE_INT:
            item->setInt([value intValue]);
            break;
        case NUMBER_TYPE_UINT:
            item->setInt([value uintValue]);
            break;
        default:
            break;
    }
    return item;
};

-(EzyPrimitive*)deserializeToPrimitive:(NSObject*)value {
    NSNumber* number = (NSNumber*)value;
    EzyPrimitive* item = new EzyPrimitive();
    NSString* className = NSStringFromClass([number class]);
    if([@"__NSCFBoolean" isEqualToString:className]) {
        item->setBool([number boolValue]);
    }
    else {
        int64_t int64Value = [number longLongValue];
        double doubleValue = [number doubleValue];
        if(int64Value != doubleValue) {
            float floatValue = [number floatValue];
            if(floatValue == doubleValue)
                item->setFloat(floatValue);
            else
                item->setDouble(doubleValue);
        }
        else {
            uint64_t uint64Value = [number unsignedLongLongValue];
            if(uint64Value != int64Value)
                item->setInt(int64Value);
            else
                item->setUInt(uint64Value);
            
        }
    }
    return item;
};
@end
