//
//  EzyEncryptionProxy.h
//  ezyfox-ssl
//
//  Created by Dzung on 31/05/2021.
//

#import <Foundation/Foundation.h>
#import "../util/NSByteArray.h"

NS_ASSUME_NONNULL_BEGIN

@interface EzyKeyPairProxy : NSObject
 
@property NSString *publicKey;
@property NSString *privateKey;

+(id)keyPairWith: (NSString*)publicKey privateKey:(NSString*)privateKey;
@end

@interface EzyRSAProxy : NSObject
+(instancetype)getInstance;
-(EzyKeyPairProxy*)generateKeyPair;
-(NSData*)decrypt: (NSData*)message privateKey:(NSData*)privateKey;
@end

NS_ASSUME_NONNULL_END
