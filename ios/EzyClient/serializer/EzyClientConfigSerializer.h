//
//  EzyClientConfigSerializer.h
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EzyClientConfigSerializer : NSObject
-(NSDictionary*)serialize:(void*)value;
@end

NS_ASSUME_NONNULL_END
