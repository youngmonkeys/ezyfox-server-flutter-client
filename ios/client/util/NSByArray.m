//
//  NSByArray.m
//  ezyfox-ssl
//
//  Created by Dzung on 01/06/2021.
//

#import <Foundation/Foundation.h>
#import "NSByteArray.h"

@implementation NSByteArray {
}

+(id)byteArrayWithData: (NSData*)data {
    NSByteArray* pRet = [[NSByteArray alloc] init];
    pRet.data = data;
    pRet.size = (int)[data length];
    return pRet;
}

+(id)byteArrayWithCharArray:(const char *)data size:(int)size {
    NSByteArray* pRet = [[NSByteArray alloc] init];
    pRet.data = [NSData dataWithBytes:data length:size];
    pRet.size = size;
    return pRet;
}
@end
