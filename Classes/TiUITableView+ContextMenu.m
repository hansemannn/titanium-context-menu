//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiUITableView+ContextMenu.h"
#import "TiContextmenuModule.h"
#import "TiUITableViewProxy.h"

@implementation TiUITableView (ContextMenu)

#pragma mark UITableViewDelegate (extension)

- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView
contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
                                    point:(CGPoint)point
API_AVAILABLE(ios(13.0))
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  TiUITableViewRowProxy *row = [self performSelector:@selector(rowForIndexPath:) withObject:indexPath];
#pragma clang diagnostic pop
  NSArray<NSDictionary<NSString *, id> *> *menu = [row valueForKey:@"menu"];

  if (!menu) {
    return nil;
  }

  return [UIContextMenuConfiguration configurationWithIdentifier:@"TiContentMenuConfiguration"
                                                 previewProvider:nil
                                                  actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
    if (@available(iOS 14.0, *)) {
      UIMenu *nativeMenu = [TiContextmenuModule menuFromJavaScriptArray:menu andProxy:self.proxy title:nil handler:^(__kindof UIAction *action, NSUInteger index) {
        [self.proxy fireEvent:@"menuclick" withObject:@{ @"itemIndex": @(indexPath.row), @"sectionIndex": @(indexPath.section), @"actionIndex": @(index) }];
      }];
      
      if (@available(iOS 16.0, *)) {
        UIMenuElementSize elementSize = [TiUtils intValue:@"preferredElementSize" properties:row.allProperties def:UIMenuElementSizeLarge];
        nativeMenu.preferredElementSize = elementSize;
      }
      
      return nativeMenu;
    } else {
      return nil;
    }
  }];
}

@end
