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

// NOTE: We need to prefix the properties to not clash with existing proxy properties like window- / button-title

@property(nonatomic, retain) NSArray<NSDictionary<NSString *, id> *> * _Nonnull __actions;

@property(nonatomic, copy) NSString * _Nullable __title;

@property(nonatomic, copy) NSString * _Nullable __identifier;

- (void)addInteraction:(_Nonnull id)args;

@end
