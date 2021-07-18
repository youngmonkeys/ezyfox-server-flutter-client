//
//  NSByteArray.h
//  ezyfox-ssl
//
//  Created by Dzung on 01/06/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSByteArray : NSObject
 
@property const NSData* data;
@property int size;

+(id)byteArrayWithData: (NSData*)data;

+(id)byteArrayWithCharArray: (const char*)data size: (int)size;
@end

NS_ASSUME_NONNULL_END
