//
//  EzyEventSerializer.m
//  ezyfox-server-react-native-client
//
//  Created by Dung Ta Van on 10/26/18.
//  Copyright © 2018 Young Monkeys. All rights reserved.
//

#import "EzyEventSerializer.h"
#include "EzyHeaders.h"

EZY_USING_NAMESPACE::event;
EZY_USING_NAMESPACE::constant;

@implementation EzyEventSerializer

-(NSDictionary *)serialize:(void *)value {
    EzyEvent* event = (EzyEvent*)value;
    switch (event->getType()) {
        case ConnectionSuccess:
            return [NSMutableDictionary dictionary];
        case ConnectionFailure:
            return [self serializeConnectionFailureEvent:event];
        case Disconnection:
            return [self serializeConnectionFailureEvent:event];
        case LostPing:
            return [self serializeLostPingEvent:event];
        case TryConnect:
            return [self serializeTryConnectEvent:event];
        default:
            break;
    }
    @throw [NSException exceptionWithName:@"NSInvalidArgumentException" reason:@"has no serializer with event" userInfo:nil];
}

-(NSDictionary*)serializeConnectionFailureEvent: (EzyEvent*)event {
    EzyConnectionFailureEvent* mevent = (EzyConnectionFailureEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    NSNumber* reason = [NSNumber numberWithInt: mevent->getReason()];
    [dict setValue:reason forKey:@"reason"];
    return dict;
}

-(NSDictionary*)serializeDisconnectionEvent: (EzyEvent*)event {
    EzyDisconnectionEvent* mevent = (EzyDisconnectionEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    NSNumber* reason = [NSNumber numberWithInt: mevent->getReason()];
    [dict setValue:reason forKey:@"reason"];
    return dict;
}

-(NSDictionary*)serializeLostPingEvent: (EzyEvent*)event {
    EzyLostPingEvent* mevent = (EzyLostPingEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    int count = mevent->getCount();
    [dict setValue:[NSNumber numberWithInt:count] forKey:@"count"];
    return dict;
}

-(NSDictionary*)serializeTryConnectEvent: (EzyEvent*)event {
    EzyTryConnectEvent* mevent = (EzyTryConnectEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    int count = mevent->getCount();
    [dict setValue:[NSNumber numberWithInt:count] forKey:@"count"];
    return dict;
}

@end
