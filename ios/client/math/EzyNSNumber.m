//
//  EzyNSNumber.m
//  freechat-swift
//
//  Created by Dung Ta Van on 1/18/20.
//  Copyright © 2020 Young Monkeys. All rights reserved.
//

#import "EzyNSNumber.h"

@implementation EzyNSNumber

+ (instancetype)numberWithBool:(bool)value {
    return [[EzyNSNumber alloc] initWithBool:value];
}

+ (instancetype)numberWithDouble:(double)value {
    return [[EzyNSNumber alloc] initWithDouble:value];
}

+ (instancetype)numberWithFloat:(float)value {
    return [[EzyNSNumber alloc] initWithFloat:value];
}

+ (instancetype)numberWithInt:(int64_t)value {
    return [[EzyNSNumber alloc] initWithInt:value];
}

+ (instancetype)numberWithUInt:(uint64_t)value {
    return [[EzyNSNumber alloc] initWithUInt:value];
}

- (id)initWithBool:(bool)value {
    self = [super init];
    if(self) {
        self.mType = NUMBER_TYPE_BOOL;
        self.mNumber = [NSNumber numberWithBool:value];
    }
    return self;
}

- (id)initWithDouble:(double)value {
    self = [super init];
    if(self) {
        self.mType = NUMBER_TYPE_DOUBLE;
        self.mNumber = [NSNumber numberWithDouble:value];
    }
    return self;
}

- (id)initWithFloat:(float)value {
    self = [super init];
    if(self) {
        self.mType = NUMBER_TYPE_FLOAT;
        self.mNumber = [NSNumber numberWithFloat:value];
    }
    return self;
}

- (id)initWithInt:(int64_t)value {
    self = [super init];
    if(self) {
        self.mType = NUMBER_TYPE_INT;
        self.mNumber = [NSNumber numberWithLongLong:value];
    }
    return self;
}

- (id)initWithUInt:(uint64_t)value {
    self = [super init];
    if(self) {
        self.mType = NUMBER_TYPE_UINT;
        self.mNumber = [NSNumber numberWithUnsignedLongLong:value];
    }
    return self;
}

- (int)getType {
    return self.mType;
}

- (bool)boolValue {
    return [[self mNumber] boolValue];
}

- (double)doubleValue {
    return [[self mNumber] doubleValue];
}

- (float)floatValue {
    return [[self mNumber] floatValue];
}

- (int64_t)intValue {
    return [[self mNumber] longLongValue];
}

- (uint64_t)uintValue {
    return [[self mNumber] unsignedLongLongValue];
}

@end
