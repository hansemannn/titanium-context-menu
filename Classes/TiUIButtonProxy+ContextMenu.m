//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiUIButtonProxy+ContextMenu.h"
#import "TiUIButton.h"
#import "TiContextmenuModule.h"

@implementation TiUIButtonProxy (ContextMenu)

#pragma mark Public API's

- (void)setMenu:(NSArray *)actions
{
  [self replaceValue:actions forKey:@"menu" notification:NO];
  UIButton *button = [(TiUIButton *)[self view] button];
  [TiContextmenuModule injectMenuForButton:button andProxy:self];
}

@end
