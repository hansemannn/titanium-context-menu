//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiUIButtonProxy+ContextMenu.h"
#import "TiContextmenuModule.h"
#import "ImageLoader.h"
#import "TiBlob.h"
#import "TiButtonUtil.h"
#import <objc/runtime.h>

@implementation TiUINavBarButton (ContextMenu)

#pragma mark Public API's

// This is important: We have to override the init here, since there is no place
// we could access the proxy except here. If you read this and know of a better place,
// please go for it!
//
// Because of that, we basically copied parts of the TiUINavBarButton constructor, but only the image / title
// handling. If you need more, please extend this code!
- (id)initWithProxy:(TiUIButtonProxy *)proxy_
{
  self = [super init];

  id image = [proxy_ valueForKey:@"image"];
  id systemButton = [proxy_ valueForKey:@"systemButton"];
  SEL selector = [proxy_ _hasListeners:@"click"] ? @selector(clicked:) : nil; // This is not missing, it's just not found by the static analyzer

  if (systemButton != nil) {
    UIBarButtonSystemItem type = [TiUtils intValue:systemButton];
    UIView *button = [TiButtonUtil systemButtonWithType:(int)type];
    if (button != nil) {
      if ([button isKindOfClass:[UIActivityIndicatorView class]]) {
        // we need to wrap our activity indicator view into a UIView that will delegate
        // to our proxy
        activityDelegate = [[TiUIView alloc] initWithFrame:button.frame];
        [activityDelegate addSubview:button];
        activityDelegate.proxy = (TiViewProxy *)proxy_;
        button = activityDelegate;
      }
      self = [super initWithCustomView:button];
      self.target = self;
      self.action = selector;
      if ([button isKindOfClass:[UIControl class]]) {
        [(UIControl *)button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
      }
    } else {
      self = [super initWithBarButtonSystemItem:type target:self action:selector];
    }
  } else if (image != nil) {
    UIImage *nativeImage;
    // The image can be a raw image (e.g. for blobs / system icons)
    if ([image isKindOfClass:[TiBlob class]]) {
      nativeImage = [(TiBlob *)image image];
    } else {
      NSURL *url = [TiUtils toURL:image proxy:proxy_];
      nativeImage = [[ImageLoader sharedLoader] loadImmediateStretchableImage:url];
    }
    self = [super initWithImage:nativeImage style:(UIBarButtonItemStyle)[self style:proxy_] target:self action:selector];
  } else {
    self = [super initWithTitle:[self title:proxy_] style:(UIBarButtonItemStyle)[self style:proxy_] target:self action:selector];
    self.tintColor = [proxy_ valueForKey:@"color"] ? [TiUtils colorValue:[proxy_ valueForKey:@"color"]].color : [TiUtils colorValue:[proxy_ valueForKey:@"tintColor"]].color;
  }
  
  proxy = proxy_; // Don't retain

  self.accessibilityLabel = [proxy_ valueForUndefinedKey:@"accessibilityLabel"];
  self.accessibilityValue = [proxy_ valueForUndefinedKey:@"accessibilityValue"];
  self.accessibilityHint = [proxy_ valueForUndefinedKey:@"accessibilityHint"];
  self.accessibilityIdentifier = [TiUtils composeAccessibilityIdentifier:self];

  self.width = [TiUtils floatValue:[proxy_ valueForKey:@"width"] def:0.0];
  //A width of 0 is treated as Auto by the iPhone OS, so this is safe.
  // we need to listen manually to proxy change events if we want to be
  // able to change them dynamically
  proxy.modelDelegate = self;

  // Inject our menu
  [TiContextmenuModule injectMenuForButton:self andProxy:proxy];

  return self;
}

@end
