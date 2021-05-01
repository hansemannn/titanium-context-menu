/**
 * titanium-context-menu
 *
 * Created by Your Name
 * Copyright (c) 2019 Your Company. All rights reserved.
 */

#import "TiModule.h"

API_AVAILABLE(ios(13.0))
typedef void (^TiActionHandler)(__kindof UIAction *action, NSUInteger index);

@interface TiContextmenuModule : TiModule

+ (void)injectMenuForButton:(id)button andProxy:(TiProxy *)proxy;

+ (UIMenu *)menuFromJavaScriptArray:(NSArray<NSDictionary<NSString *, id> *> *)actions andProxy:(TiProxy *)proxy handler:(TiActionHandler)handler API_AVAILABLE(ios(14.0));

@end
