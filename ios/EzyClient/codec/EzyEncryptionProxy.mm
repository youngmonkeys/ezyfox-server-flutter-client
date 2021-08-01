//
//  EzyEncryptionProxy.mm
//  ezyfox-ssl
//
//  Created by Dzung on 31/05/2021.
//

#include "EzyHeaders.h"
#import "EzyEncryptionProxy.h"

EZY_USING_NAMESPACE;
EZY_USING_NAMESPACE::codec;

@implementation EzyKeyPairProxy {
}
+(id)keyPairWith:(NSString *)publicKey privateKey:(NSString *)privateKey {
    EzyKeyPairProxy* pRet = [[EzyKeyPairProxy alloc] init];
    pRet.publicKey = publicKey;
    pRet.privateKey = privateKey;
    return pRet;
}
@end

@implementation EzyRSAProxy {
}

+ (instancetype)getInstance {
    static EzyRSAProxy *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[EzyRSAProxy alloc] init];
    });
    return sInstance;
}

-(EzyKeyPairProxy*)generateKeyPair {
    EzyKeyPair* keyPair = EzyRSA::getInstance()->generateKeyPair();
    return [EzyKeyPairProxy
            keyPairWith:[NSString stringWithCString:keyPair->getPublicKey().c_str()
                                           encoding: [NSString defaultCStringEncoding]]
            privateKey:[NSString stringWithCString:keyPair->getPrivateKey().c_str()
                                          encoding: [NSString defaultCStringEncoding]]];
}

-(NSData*)decrypt:(NSData *)message privateKey:(NSData *)privateKey {
    int decryptedSize = 0;
    char* decryption = EzyRSA::getInstance()->decrypt((char*)[message bytes],
                                                      (int)message.length,
                                                      (char*)[privateKey bytes],
                                                      decryptedSize);
    NSData* answer = [NSData dataWithBytes:decryption length:decryptedSize];
    EZY_SAFE_FREE(decryption);
    return answer;
}
@end
