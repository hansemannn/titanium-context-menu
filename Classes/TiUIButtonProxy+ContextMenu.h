//
//  TiViewProxy+ContextMenu.h
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#define USE_TI_UIBUTTON

#import <UIKit/UIKit.h>
#import "TiUIButtonProxy.h"

@interface TiUIButtonProxy (ContextMenu)

- (void)setMenu:(_Nonnull id)args;

@end
