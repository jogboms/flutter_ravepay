#import "FlutterRavepayPlugin.h"
#import <flutter_ravepay/flutter_ravepay-Swift.h>

@implementation FlutterRavepayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterRavepayPlugin registerWithRegistrar:registrar];
}
@end
