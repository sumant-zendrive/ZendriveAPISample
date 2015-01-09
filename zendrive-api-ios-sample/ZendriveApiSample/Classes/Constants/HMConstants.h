//
//  HMConstants.h
//

// Singleton pattern
#define SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedInstance = nil; \
dispatch_once(&pred, ^{ \
_sharedInstance = block(); \
}); \
return _sharedInstance;

// NS_ENUM for iOS 5
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// Convert degrees to radian
#define degreesToRadian(x)              (M_PI * (x) / 180.0)

// View frames
#define kWidthSelfView                  self.view.frame.size.width
#define kHeightSelfView                 self.view.frame.size.height
#define kWidthSelf                      self.frame.size.width
#define kHeightSelf                     self.frame.size.height
#define kWidthScreen                    [[UIScreen mainScreen] bounds].size.width
#define kHeightScreen                   [[UIScreen mainScreen] bounds].size.height


// General UI components' heights
#define kHeightStatusBar                20.0f
#define kHeightNavigationBar            44.0f

// Shortcuts
#define SharedApplication               [UIApplication sharedApplication]
#define NotificationCenter              [NSNotificationCenter defaultCenter]
#define MainBundlePath                  [[NSBundle mainBundle] bundlePath]
#define MainResourcePath                [[NSBundle mainBundle] resourcePath]
#define CurrentOrientation              [SharedApplication statusBarOrientation]
#define Delegate                        ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                    [NSUserDefaults standardUserDefaults]
#define CurrentDevice                   [UIDevice currentDevice]

#define kAppVersion                     [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

