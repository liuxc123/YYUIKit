//
//  YYUISearchBarExecutor.m
//  YYUIKit
//
//  Created by liuxc on 2021/11/30.
//

#import "YYUISearchBarExecutor.h"

@interface YYUISearchBarExecutor ()

@property (nonatomic, weak) UISearchBar *searchBar;

@end

@implementation YYUISearchBarExecutor

- (instancetype)initWithSearchBar:(UISearchBar *)searchBar delegate:(id)delegate;
{
    self = [super init];
    if (self) {
        self.searchBar = searchBar;
        self.textInputDelegate = delegate;
        [self commonInit];
    }
    return self;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        return [self.textInputDelegate searchBarShouldBeginEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarTextDidBeginEditing:searchBar];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        return [self.textInputDelegate searchBarShouldEndEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarTextDidEndEditing:searchBar];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarSearchButtonClicked:searchBar];
    }
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarBookmarkButtonClicked:searchBar];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarCancelButtonClicked:searchBar];
    }
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar API_AVAILABLE(ios(3.2)) {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBarResultsListButtonClicked:searchBar];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope API_AVAILABLE(ios(3.0)) {
    if (self.textInputDelegate) {
        [self.textInputDelegate searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text API_AVAILABLE(ios(3.0)) {
    if ([self.textInputDelegate respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [self.textInputDelegate searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
    }
    return [self shouldChange:[self searchTextField] range:range string:text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText  {
    YYUITextInputIR *ir = [self textDidChange:[self searchTextField] text:searchBar.text];
    if (!ir) {
        if (self.textDidChangeEvent) { self.textDidChangeEvent(ir.text); }
        return;
    }
    
    [searchBar setText:ir.text];
    [self setSelectedTextRange:[self searchTextField] range:ir.range];
    if (self.textDidChangeEvent) {  self.textDidChangeEvent(ir.text); }
}

- (UITextField *)searchTextField {
    if (@available(iOS 13.0, *)) {
        return self.searchBar.searchTextField;
    }
    return nil;
}

@end
