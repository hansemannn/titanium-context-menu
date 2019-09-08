//
//  TiViewProxy+ContextMenu.h
//  titanium-context-menu
//
//  Created by Hans Knoechel on 07.09.19.
//

#import <UIKit/UIKit.h>
#import <TitaniumKit/TiViewProxy.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
@interface TiViewProxy (ContextMenu) <UIContextMenuInteractionDelegate>
#else
@interface TiViewProxy (ContextMenu)
#endif

@property(nonatomic, retain) NSArray<NSDictionary<NSString *, id> *> * _Nonnull actions;

@property(nonatomic, copy) NSString * _Nullable title;

@property(nonatomic, copy) NSString * _Nullable identifier;

- (void)addInteraction:(_Nonnull id)args;

@end
