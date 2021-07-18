//
//  EzyNSNumber.h
//  freechat-swift
//
//  Created by Dung Ta Van on 1/18/20.
//  Copyright © 2020 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, NumberType) {
    NUMBER_TYPE_BOOL = 1,
    NUMBER_TYPE_DOUBLE = 2,
    NUMBER_TYPE_FLOAT = 3,
    NUMBER_TYPE_INT = 4,
    NUMBER_TYPE_UINT = 5
};

@interface EzyNSNumber : NSObject

@property (assign) int mType;
@property (nonatomic, strong) NSNumber* mNumber;

-(id) initWithBool:(bool)value;
-(id) initWithDouble:(double)value;
-(id) initWithFloat:(float)value;
-(id) initWithInt:(int64_t)value;
-(id) initWithUInt:(uint64_t)value;

-(int) getType;
-(bool) boolValue;
-(double) doubleValue;
-(float) floatValue;
-(int64_t) intValue;
-(uint64_t) uintValue;

+(instancetype) numberWithBool:(bool)value;
+(instancetype) numberWithDouble:(double)value;
+(instancetype) numberWithFloat:(float)value;
+(instancetype) numberWithInt:(int64_t)value;
+(instancetype) numberWithUInt:(uint64_t)value;

@end

NS_ASSUME_NONNULL_END
