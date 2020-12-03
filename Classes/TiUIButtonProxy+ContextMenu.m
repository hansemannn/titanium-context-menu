//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiUIButtonProxy+ContextMenu.h"
#import "TiUIButton.h"

@implementation TiUIButtonProxy (ContextMenu)

#pragma mark Public API's

- (void)setMenu:(NSArray *)actions
{
  if (@available(iOS 14.0, *)) {
    NSMutableArray<UIAction *> *children = [NSMutableArray arrayWithCapacity:actions.count];

    [actions enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSString *title = obj[@"title"];
      UIImage *image = [TiUtils toImage:obj[@"image"] proxy:self];
      NSString *identifier = obj[@"identifier"];
      BOOL destructive = [TiUtils boolValue:obj[@"destructive"] def:NO];

      UIAction *action = [UIAction actionWithTitle:title image:image identifier:identifier  handler:^(__kindof UIAction * _Nonnull action) {
        [self fireEvent:@"menuclick" withObject:@{ @"index": @(idx) }];
      }];
      
      if (destructive) {
        action.attributes = UIAlertActionStyleDestructive;
      }
      
      [children addObject:action];
    }];

    UIButton *button = [(TiUIButton *)[self view] button];
    UIMenu *menu = [UIMenu menuWithChildren:children];

    button.menu = menu;
    button.showsMenuAsPrimaryAction = YES;
  }
}

@end
