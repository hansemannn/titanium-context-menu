//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiUIListView+ContextMenu.h"
#import "TiContextmenuModule.h"
#import "TiUIListViewProxy.h"
#import "TiUIListSectionProxy.h"
#import "TiUIListItemProxy.h"

@implementation TiUIListView (ContextMenu)

#pragma mark UITableViewDelegate (extension)

- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView
contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
                                    point:(CGPoint)point
API_AVAILABLE(ios(13.0))
{
  TiUIListSectionProxy *section = [[(TiUIListViewProxy *)self.proxy sections] objectAtIndex:indexPath.section];
  NSDictionary<NSString *, id> *item = [section itemAtIndex:indexPath.row];
  NSDictionary<NSString *, id> *itemProperties = item[@"properties"];
  NSArray<NSDictionary<NSString *, id> *> *menu = itemProperties[@"menu"];

  if (!itemProperties || !menu) {
    return nil;
  }

  return [UIContextMenuConfiguration configurationWithIdentifier:@"TiContentMenuConfiguration"
                                                 previewProvider:nil
                                                  actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
    if (@available(iOS 14.0, *)) {
      return [TiContextmenuModule menuFromJavaScriptArray:menu andProxy:self.proxy handler:^(__kindof UIAction *action, NSUInteger index) {
        [self.proxy fireEvent:@"menuclick" withObject:@{ @"itemIndex": @(indexPath.row), @"sectionIndex": @(indexPath.section), @"actionIndex": @(index) }];
      }];
    } else {
      return nil;
    }
  }];
}

@end
