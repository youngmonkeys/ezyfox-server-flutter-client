//
//  EzyClientProxy.h
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/26/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@class EzyMethodProxy;

NS_ASSUME_NONNULL_BEGIN

@interface EzyClientProxy : NSObject
+(instancetype)getInstance;
-(void)registration:(NSObject<FlutterBinaryMessenger>*)messager;
@end

NS_ASSUME_NONNULL_END
