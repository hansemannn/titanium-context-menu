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
  SEL selector = [proxy_ _hasListeners:@"click"] ? @selector(clicked:) : nil; // This is not missing, it's just not found by the static analyzer

  if (image != nil) {
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
