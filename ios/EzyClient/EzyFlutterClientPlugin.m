#import "EzyFlutterClientPlugin.h"
#import "EzyClientProxy.h"

@implementation EzyFlutterClientPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [[EzyClientProxy getInstance] registration: [registrar messenger]];
}
@end
