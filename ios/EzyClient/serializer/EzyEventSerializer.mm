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

static std::map<int, std::string> sNativeConnectionFailedReasonNames = {
    {NetworkUnreachable, "NETWORK_UNREACHABLE"},
    {UnknownHost, "UNKNOWN_HOST"},
    {ConnectionRefused, "CONNECTION_REFUSED"},
    {UnknownFailure, "UNKNOWN"}
};

static std::map<int, std::string> sNativeDisconnectReasonNames = {
    {UnknownDisconnection, "UNKNOWN"},
    {Idle, "IDLE"},
    {NotLoggedIn, "NOT_LOGGED_IN"},
    {AnotherSessionLogin, "ANOTHER_SESSION_LOGIN"},
    {AdminBan, "ADMIN_BAN"},
    {AdminKick, "ADMIN_KICK"},
    {MaxRequestPerSecond, "MAX_REQUEST_PER_SECOND"},
    {MaxRequestSize, "MAX_REQUEST_SIZE"},
    {ServerError, "SERVER_ERROR"},
    {ServerNotResponding, "SERVER_NOT_RESPONDING"}
};

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
    int reason = mevent->getReason();
    std::string reasonName = std::to_string(reason);
    std::map<int, std::string>::iterator it = sNativeConnectionFailedReasonNames.find(reason);
    if(it != sNativeConnectionFailedReasonNames.end())
        reasonName = it->second;
    NSString* tmp = [NSString stringWithCString:reasonName.c_str() encoding:[NSString defaultCStringEncoding]];
    [dict setValue:tmp forKey:@"reason"];
    return dict;
}

-(NSDictionary*)serializeDisconnectionEvent: (EzyEvent*)event {
    EzyDisconnectionEvent* mevent = (EzyDisconnectionEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    int reason = mevent->getReason();
    std::string reasonName = std::to_string(reason);
    std::map<int, std::string>::iterator it = sNativeDisconnectReasonNames.find(reason);
    if(it != sNativeDisconnectReasonNames.end())
        reasonName = it->second;
    NSString* tmp = [NSString stringWithCString:reasonName.c_str() encoding:[NSString defaultCStringEncoding]];
    [dict setValue:tmp forKey:@"reason"];
    return dict;
}

-(NSDictionary*)serializeLostPingEvent: (EzyEvent*)event {
    EzyLostPingEvent* mevent = (EzyLostPingEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    int count = mevent->getCount();
    [dict setValue:[NSNumber numberWithInt:count] forKey:@"reason"];
    return dict;
}

-(NSDictionary*)serializeTryConnectEvent: (EzyEvent*)event {
    EzyTryConnectEvent* mevent = (EzyTryConnectEvent*)event;
    NSDictionary* dict = [NSMutableDictionary dictionary];
    int count = mevent->getCount();
    [dict setValue:[NSNumber numberWithInt:count] forKey:@"reason"];
    return dict;
}

@end
