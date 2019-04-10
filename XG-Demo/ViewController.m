//
//  ViewController.m
//  XG-Demo
//
//  Created by tyzual on 28/10/2016.
//  Copyright © 2016 tyzual. All rights reserved.
//

#import "ViewController.h"
#import "XGPush.h"
#import "AppDelegate.h"


typedef NS_ENUM(NSInteger, IDOperationType) {
    Add = 0,
    Delete = 1,
    Update = 2,
    Clear = 3
};

static NSString *const cellID = @"xgdemoCellID";


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, XGPushTokenManagerDelegate> {
    NSString * inputAccountTitle;
    NSString * inputTagTitle;
    NSString * inputBadgeTitle;
}
@property (weak, nonatomic) IBOutlet UITableView *APITableView;
@property (nonatomic, strong) UIAlertController *alertCtr;
@property (strong, nonatomic) NSArray *apiLists;
@property (strong, nonatomic) NSArray *apiKindLists;
@property IDOperationType operationType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    inputAccountTitle = NSLocalizedString(@"account_title", nil);
    inputTagTitle = NSLocalizedString(@"tag_title", nil);
    inputBadgeTitle = NSLocalizedString(@"badge_title", nil);
    
    
    if (!self.alertCtr) {
        self.alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [self.alertCtr addAction:action];
    }
    self.apiKindLists = @[NSLocalizedString(@"account_section", nil), NSLocalizedString(@"tag_section", nil), NSLocalizedString(@"app_section", nil)];
    self.apiLists = @[@[NSLocalizedString(@"bind_account", nil), NSLocalizedString(@"unbind_account", nil), NSLocalizedString(@"update_account", nil), NSLocalizedString(@"clear_account", nil)], @[NSLocalizedString(@"bind_tag", nil), NSLocalizedString(@"unbind_tag", nil), NSLocalizedString(@"update_tag", nil),NSLocalizedString(@"clear_tag", nil)], @[NSLocalizedString(@"register_app", nil), NSLocalizedString(@"unregister_app", nil), NSLocalizedString(@"device_token", nil), NSLocalizedString(@"set_badge", nil)]];
    [self.APITableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.APITableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    self.APITableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [XGPushTokenManager defaultTokenManager].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.apiLists.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.apiKindLists[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.apiLists[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = ((NSArray *)self.apiLists[indexPath.section])[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            //
            self.operationType = indexPath.row;
            if (self.operationType == Clear) {
                [[XGPushTokenManager defaultTokenManager] clearAllIdentifiers:XGPushTokenBindTypeAccount];
            } else {
                UIAlertView *inputAccountView = [[UIAlertView alloc] initWithTitle:inputAccountTitle message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                inputAccountView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [inputAccountView show];
            }
            
            break;
        }
        case 1:
        {
            //
            self.operationType = indexPath.row;
            if (self.operationType == Clear) {
                [[XGPushTokenManager defaultTokenManager] clearAllIdentifiers:XGPushTokenBindTypeTag];
            } else {
                UIAlertView *inputTagView = [[UIAlertView alloc] initWithTitle:inputTagTitle message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                inputTagView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [inputTagView show];
            }
            
            break;
        }
        case 2:
        {
            //
            if (indexPath.row == 0) {
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [[XGPush defaultManager] startXGWithAppID:2200262432 appKey:@"I89WTUY132GJ" delegate:(id<XGPushDelegate>)appDelegate];
            } else if (indexPath.row == 1) {
                [self unRegister:nil];
            } else if (indexPath.row == 2) {
                [self onGetDeviceToken:nil];
            } else if (indexPath.row == 3) {
                UIAlertView *inputBadgeView = [[UIAlertView alloc] initWithTitle:inputBadgeTitle message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
                inputBadgeView.alertViewStyle = UIAlertViewStylePlainTextInput;
                [inputBadgeView show];
            }
            break;
        }
            
        default:
            NSLog(@"");
            break;
    }
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *identifier = [[alertView textFieldAtIndex:0] text];
    if (buttonIndex == 1) {
        if ([alertView.title isEqualToString:inputAccountTitle]) {
            if (self.operationType == Add) {
                [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:identifier type:XGPushTokenBindTypeAccount];
            } else if (self.operationType == Delete) {
                [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:identifier type:XGPushTokenBindTypeAccount];
            } else if (self.operationType == Update) {
                [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[@{identifier:@(0)}] bindType:XGPushTokenBindTypeAccount];
            }
            
        } else if ([alertView.title isEqualToString:inputTagTitle]) {
            if (self.operationType == Add) {
                //                [[XGPushTokenManager defaultTokenManager] bindWithIdentifiers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] type:XGPushTokenBindTypeTag];
                [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:identifier type:XGPushTokenBindTypeTag];
            } else if (self.operationType == Delete) {
                //                [[XGPushTokenManager defaultTokenManager] unbindWithIdentifers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] type:XGPushTokenBindTypeTag];
                [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:identifier type:XGPushTokenBindTypeTag];
            } else if (self.operationType == Update) {
                //                [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] bindType:XGPushTokenBindTypeTag];
                [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[identifier] bindType:XGPushTokenBindTypeTag];
            }
        } else if ([alertView.title isEqualToString:inputBadgeTitle]) {
            [[XGPush defaultManager] setBadge:[identifier integerValue]];
        }
        
    }
}

- (void)onGetDeviceToken:(id)sender {
    NSString *token = [[XGPushTokenManager defaultTokenManager] deviceTokenString];
    if (!token || token.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"token_error", nil) message:token delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = token;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"token_info", nil) message:token delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
    
    [[XGPushTokenManager defaultTokenManager] unbindWithIdentifers:@[@{@"123":@(0)}] type:XGPushTokenBindTypeAccount];
    
}

- (void)unRegister:(id)sender {
    [[XGPush defaultManager] stopXGNotification];
}

- (void) updateNotification:(NSString *)str {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - XGPushTokenManagerDelegate
- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"bind_account", nil):NSLocalizedString(@"bind_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifier, error);
}

- (void)xgPushDidUnbindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"unbind_account", nil):NSLocalizedString(@"unbind_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifier, error);
}

- (void)xgPushDidBindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"bind_account", nil):NSLocalizedString(@"bind_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUnbindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"unbind_account", nil):NSLocalizedString(@"unbind_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUpdatedBindedIdentifiers:(NSArray<NSString *> *)identifiers bindType:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"update_account", nil):NSLocalizedString(@"update_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidClearAllIdentifiers:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"%@%@", ((type == XGPushTokenBindTypeAccount)?NSLocalizedString(@"clear_account", nil):NSLocalizedString(@"clear_tag", nil)), ((error == nil)?NSLocalizedString(@"success", nil):NSLocalizedString(@"failed", nil))]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, type is %lu, error %@", __FUNCTION__, (unsigned long)type, error);
}

@end
