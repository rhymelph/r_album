#import "RAlbumPlugin.h"
#if __has_include(<r_album/r_album-Swift.h>)
#import <r_album/r_album-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "r_album-Swift.h"
#endif

@implementation RAlbumPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRAlbumPlugin registerWithRegistrar:registrar];
}
@end
