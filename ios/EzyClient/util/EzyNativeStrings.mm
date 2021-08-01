//
//  EzyNativeStrings.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import "EzyNativeStrings.h"

@implementation EzyNativeStrings

+ (NSString *)newNSString:(const char *)str {
    return [NSString stringWithCString:str encoding:[NSString defaultCStringEncoding]];
}

@end
