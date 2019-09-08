//
//  TiViewProxy+ContextMenu.m
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import "TiViewProxy+ContextMenu.h"
#import <objc/runtime.h>

static void * kTiContextMenuPropertyKeyActions = &kTiContextMenuPropertyKeyActions;
static void * kTiContextMenuPropertyKeyIdentifier = &kTiContextMenuPropertyKeyIdentifier;
static void * kTiContextMenuPropertyKeyTitle = &kTiContextMenuPropertyKeyTitle;

@implementation TiViewProxy (ContextMenu)

@dynamic __actions, __title, __identifier;

#pragma mark Public API's

- (void)addInteraction:(id)interaction
{
  ENSURE_SINGLE_ARG(interaction, NSDictionary);

  self.__actions = interaction[@"actions"];
  self.__title = interaction[@"title"] ?: @"";
  self.__identifier = interaction[@"identifier"] ?: nil;

  if (@available(iOS 13.0, *)) {
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [self.view addInteraction:interaction];
  } else {
    NSLog(@"[ERROR] Only call this method on iOS 13+");
  }
}

#pragma mark Obj-C runtime hacks for category properties

- (void)set__actions:(NSArray<NSDictionary<NSString *,id> *> *)actions
{
  objc_setAssociatedObject(self, kTiContextMenuPropertyKeyActions, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)set__title:(NSString *)title
{
  objc_setAssociatedObject(self, kTiContextMenuPropertyKeyTitle, title, OBJC_ASSOCIATION_COPY);
}

- (void)set__identifier:(NSString *)identifier
{
  objc_setAssociatedObject(self, kTiContextMenuPropertyKeyIdentifier, identifier, OBJC_ASSOCIATION_COPY);
}

- (NSArray<NSDictionary<NSString *,id> *> *)__actions
{
  return objc_getAssociatedObject(self, kTiContextMenuPropertyKeyActions);
}

- (NSString *)__title
{
  return objc_getAssociatedObject(self, kTiContextMenuPropertyKeyTitle);
}

- (NSString *)__identifier
{
  return objc_getAssociatedObject(self, kTiContextMenuPropertyKeyIdentifier);
}

#pragma mark UIContextMenuInteractionDelegate

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(nonnull UIContextMenuInteraction *)interaction
                                 configurationForMenuAtLocation:(CGPoint)location  API_AVAILABLE(ios(13.0)) {
 return [UIContextMenuConfiguration configurationWithIdentifier:self.__identifier
                                                previewProvider:nil
                                                 actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
   
   NSMutableArray<UIAction *> *children = [NSMutableArray arrayWithCapacity:self.__actions.count];
   
   [self.__actions enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     NSString *title = obj[@"title"];
     UIImage *image = [TiUtils toImage:obj[@"image"] proxy:self];
     NSString *identifier = obj[@"identifier"];
     BOOL destructive = [TiUtils boolValue:obj[@"destructive"] def:NO];

     UIAction *action = [UIAction actionWithTitle:title image:image identifier:identifier  handler:^(__kindof UIAction * _Nonnull action) {
       [self fireEvent:@"interaction" withObject:@{ @"index": @(idx) }];
     }];
     
     if (destructive) {
       action.attributes = UIAlertActionStyleDestructive;
     }
     
     [children addObject:action];
   }];

   return [UIMenu menuWithTitle:self.__title children:children];
 }];
}

@end
