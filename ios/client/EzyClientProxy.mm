//
//  EzyClientProxy.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/26/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#include "EzyHeaders.h"
#import "EzyClientProxy.h"
#import "proxy/EzyMethodProxy.h"
#import "exception/EzyMethodCallException.h"

EZY_USING_NAMESPACE;

std::vector<EzyClient*> clientVector;

@implementation EzyClientProxy {
    BOOL _registed;
    FlutterMethodChannel* _methodChannel;
    NSDictionary<NSString*, EzyMethodProxy*>* _methods;
}

+ (instancetype)getInstance {
    static EzyClientProxy *sInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[EzyClientProxy alloc] init];
    });
    return sInstance;
}

-(instancetype)init {
    self = [super init];
    if(self) {
        _registed = false;
        _methods = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)registration:(NSObject<FlutterBinaryMessenger>*)messager {
    if (_registed) {
        return;
    }
    _registed = true;
    _methodChannel = [FlutterMethodChannel
                      methodChannelWithName:@"com.tvd12.ezyfoxserver.client"
                      binaryMessenger:messager];
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        [EzyClientProxy.getInstance run:call.method params:call.arguments callback:result];
    }];
    [self addDefaultMethods];
    
    NSThread* thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(loopProcessEvents)
                                                 object:nil];
    [thread start];
}

-(void)run:(NSString*)method params:(NSDictionary*)params callback:(FlutterResult)callback {
    EzyMethodProxy* func = [_methods valueForKey:method];
    if(!func) {
        NSString* exceptionReason = [NSString stringWithFormat:@"has no method: %@", method];
        @throw [NSException exceptionWithName:@"NSInvalidArgumentException" reason:exceptionReason userInfo:nil];
    }
    @try {
        [func validate:params];
        NSObject* result = [func invoke:params];
        NSMutableArray* array = [[NSMutableArray alloc]init];
        [array addObject:result];
        if(callback) {
            callback(array);
        }
    }
    @catch (EzyMethodCallException* e) {
        NSLog(@"call method: %@ with params %@ error: %@", method, params, [e reason]);
        if(callback) {
            callback([FlutterError errorWithCode: [e code]
                                         message: [e reason]
                                         details: [e description]]);
        }
    }
    @catch (NSException* e) {
        NSLog(@"call method: %@ with params %@ fatal error: %@", method, params, [e reason]);
    }
}

- (void) loopProcessEvents {
    EzyClients* clients = EzyClients::getInstance();
    while (true) {
        [[NSThread currentThread] setName:@"ezyfox-process-event"];
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            clients->getClients(clientVector);
            for(int i = 0 ; i < clientVector.size() ; ++i) {
                EzyClient* client = clientVector[i];
                client->processEvents();
            }
        });
        [NSThread sleepForTimeInterval:0.003];
    }
}

-(void)addDefaultMethods {
    [self addMethod:[[EzyCreateClientMethod alloc]initWithComponents:_methodChannel]];
    [self addMethod:[[EzyConnectMethod alloc]init]];
    [self addMethod:[[EzyReconnectMethod alloc]init]];
    [self addMethod:[[EzyDisconnectMethod alloc]init]];
    [self addMethod:[[EzySendMethod alloc]init]];
    [self addMethod:[[EzySetStatusMethod alloc]init]];
    [self addMethod:[[EzyStartPingScheduleMethod alloc]init]];
}

-(void)addMethod:(EzyMethodProxy*)method {
    [_methods setValue:method forKey:[method getName]];
}

@end
