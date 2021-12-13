//
//  YYUISearchBarHandler.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUISearchBarHandler : YYUITextInputHandler <UISearchBarDelegate>

@property (nonatomic, weak, readonly) UISearchBar *searchBar;

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar delegate:(nullable id)delegate;

@end

NS_ASSUME_NONNULL_END
