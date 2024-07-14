/**
 * titanium-context-menu
 *
 * Created by Your Name
 * Copyright (c) 2019 Your Company. All rights reserved.
 */

#import "TiContextmenuModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiContextmenuModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"09c37883-d40d-4c84-90e6-ca64399f5c8a";
}

- (NSString *)moduleId
{
  return @"ti.contextmenu";
}

- (NSNumber *)MENU_ELEMENT_SIZE_AUTOMATIC
{
  if (@available(iOS 17.0, *)) {
    return @(UIMenuElementSizeAutomatic);
  } else {
    return @(-1);
  }
}

- (NSNumber *)MENU_ELEMENT_SIZE_SMALL
{
  if (@available(iOS 16.0, *)) {
    return @(UIMenuElementSizeSmall);
  } else {
    return @(-1);
  }
}

- (NSNumber *)MENU_ELEMENT_SIZE_MEDIUM
{
  if (@available(iOS 16.0, *)) {
    return @(UIMenuElementSizeMedium);
  } else {
    return @(-1);
  }
}

- (NSNumber *)MENU_ELEMENT_SIZE_LARGE
{
  if (@available(iOS 16.0, *)) {
    return @(UIMenuElementSizeLarge);
  } else {
    return @(-1);
  }
}

+ (void)injectMenuForButton:(id)button andProxy:(TiProxy *)proxy
{
  NSArray *actions = proxy.allProperties[@"menu"];

  if (@available(iOS 14.0, *)) {
    UIMenu *menu = [TiContextmenuModule menuFromJavaScriptArray:actions andProxy:proxy title:nil handler:^(__kindof UIAction * _Nonnull action, NSUInteger index) {
      [proxy fireEvent:@"menuclick" withObject:@{ @"index": @(index), @"identifier": action.identifier ?: NSNull.null }];
    }];
    
    if (@available(iOS 16.0, *)) {
      UIMenuElementSize elementSize = [TiUtils intValue:@"preferredElementSize" properties:proxy.allProperties def:UIMenuElementSizeLarge];
      menu.preferredElementSize = elementSize;
    }

    if ([button isKindOfClass:[UIButton class]]) {
      [(UIButton *)button setMenu:menu];
      [(UIButton *)button setShowsMenuAsPrimaryAction:YES];
    } else if ([button isKindOfClass:[UIBarButtonItem class]]) {
      [(UIBarButtonItem *)button setMenu:menu];
    }
  }
}

+ (UIMenu *)menuFromJavaScriptArray:(NSArray<NSDictionary<NSString *, id> *> *)actions andProxy:(TiProxy *)proxy title:(NSString *)title handler:(TiActionHandler)handler
{
  NSMutableArray<id> *nativeChildren = [NSMutableArray arrayWithCapacity:actions.count];

  [actions enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
    NSString *title = obj[@"title"];
    NSString *subtitle = obj[@"subtitle"];
    UIImage *image = [TiUtils toImage:obj[@"image"] proxy:proxy];
    NSString *identifier = obj[@"identifier"];
    BOOL destructive = [TiUtils boolValue:obj[@"destructive"] def:NO];
    BOOL enabled = [TiUtils boolValue:obj[@"enabled"] def:YES];
    NSArray<NSDictionary<NSString *,id> *> *menu = obj[@"menu"];
      
    if (menu != nil) {
      UIMenu *nativeMenu = [TiContextmenuModule menuFromJavaScriptArray:menu andProxy:proxy title:title handler:handler];

      if (@available(iOS 16.0, *)) {
        UIMenuElementSize elementSize = [TiUtils intValue:@"preferredElementSize" properties:obj def:UIMenuElementSizeLarge];
        nativeMenu.preferredElementSize = elementSize;
      }
      
      [nativeChildren addObject:nativeMenu];
      return;
    }
    
    UIAction *action = [UIAction actionWithTitle:title image:image identifier:identifier handler:^(__kindof UIAction * _Nonnull action) {
      handler(action, index);
    }];
    
    if (@available(iOS 15.0, *)) {
      if (subtitle != nil) {
        action.subtitle = subtitle;
      }
    }
    
    if (destructive) {
      action.attributes = UIMenuElementAttributesDestructive;
    }
      
    if (!enabled) {
        action.attributes = UIMenuElementAttributesDisabled;
    }
    
    [nativeChildren addObject:action];
  }];

  if (title != nil) {
    return [UIMenu menuWithTitle:title children:nativeChildren];
  }
  
  return [UIMenu menuWithChildren:nativeChildren];
}

@end
