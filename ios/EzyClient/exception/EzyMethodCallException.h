//
//  EzyMethodCallException.h
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/27/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSExceptionName MethodCallException;

@interface EzyMethodCallException : NSException
@property (strong, nonatomic) NSString* code;
-(void)setCode:(NSString*)code;
@end

NS_ASSUME_NONNULL_END
