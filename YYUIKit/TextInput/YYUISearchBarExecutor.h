//
//  YYUISearchBarExecutor.h
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUITextInputExecutor.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYUISearchBarExecutor : YYUITextInputExecutor <UISearchBarDelegate>

@property (nonatomic, weak, readonly) UISearchBar *searchBar;

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar delegate:(id)delegate;

@end

NS_ASSUME_NONNULL_END
