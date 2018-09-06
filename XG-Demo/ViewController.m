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
static NSString *const inputAccountTitle = @"请填写账号";
static NSString *const inputTagTitle = @"请填写标签";
static NSString *const inputBadgeTitle = @"请填写角标数";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, XGPushTokenManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *APITableView;
@property (nonatomic, strong) UIAlertController *alertCtr;
@property (strong, nonatomic) NSArray *apiLists;
@property (strong, nonatomic) NSArray *apiKindLists;
@property IDOperationType operationType;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.alertCtr) {
        self.alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [self.alertCtr addAction:action];
    }
    self.apiKindLists = @[@"账号", @"标签", @"设备"];
    self.apiLists = @[@[@"绑定账号", @"解绑账号", @"更新账号", @"清除全部账号"], @[@"绑定标签", @"解绑标签", @"更新标签",@"清除全部标签"], @[@"注册设备", @"注销设备", @"设备Token", @"设置角标"]];
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
                UIAlertView *inputAccountView = [[UIAlertView alloc] initWithTitle:inputAccountTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                UIAlertView *inputTagView = [[UIAlertView alloc] initWithTitle:inputTagTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                UIAlertView *inputBadgeView = [[UIAlertView alloc] initWithTitle:inputBadgeTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
                [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[identifier] bindType:XGPushTokenBindTypeAccount];
            }
            
        } else if ([alertView.title isEqualToString:inputTagTitle]) {
            if (self.operationType == Add) {
//                [[XGPushTokenManager defaultTokenManager] bindWithIdentifiers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] type:XGPushTokenBindTypeTag];
                [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:identifier type:XGPushTokenBindTypeTag];
            } else if (self.operationType == Delete) {
//                [[XGPushTokenManager defaultTokenManager] unbindWithIdentifers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] type:XGPushTokenBindTypeTag];
                [[XGPushTokenManager defaultTokenManager] unbindWithIdentifer:identifier type:XGPushTokenBindTypeTag];
            } else if (self.operationType == Update) {
                [[XGPushTokenManager defaultTokenManager] updateBindedIdentifiers:@[identifier, [NSString stringWithFormat:@"%@%@", identifier, @"_test"]] bindType:XGPushTokenBindTypeTag];
            }
        } else if ([alertView.title isEqualToString:inputBadgeTitle]) {
            [[XGPush defaultManager] setBadge:[identifier integerValue]];
        }

    }
}

- (void)onGetDeviceToken:(id)sender {
    NSString *token = [[XGPushTokenManager defaultTokenManager] deviceTokenString];
    if (!token || token.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法获取token" message:token delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = token;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前的deviceToken(已复制到剪切板)" message:token delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)unRegister:(id)sender {
    [[XGPush defaultManager] stopXGNotification];
}

- (void) updateNotification:(NSString *)str {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - XGPushTokenManagerDelegate
- (void)xgPushDidBindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"绑定%@%@%@", ((type == XGPushTokenBindTypeAccount)?@"账号":@"标签"), ((error == nil)?@"成功":@"失败"), identifier]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifier, error);
}

- (void)xgPushDidUnbindWithIdentifier:(NSString *)identifier type:(XGPushTokenBindType)type error:(NSError *)error {
    [self.alertCtr setMessage:[NSString stringWithFormat:@"解绑%@%@%@", ((type == XGPushTokenBindTypeAccount)?@"账号":@"标签"), ((error == nil)?@"成功":@"失败"), identifier]];
    [self presentViewController:self.alertCtr animated:YES completion:nil];
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifier, error);
}

- (void)xgPushDidBindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUnbindWithIdentifiers:(NSArray<NSString *> *)identifiers type:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidUpdatedBindedIdentifiers:(NSArray<NSString *> *)identifiers bindType:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, id is %@, error %@", __FUNCTION__, identifiers, error);
}

- (void)xgPushDidClearAllIdentifiers:(XGPushTokenBindType)type error:(NSError *)error {
    NSLog(@"%s, type is %lu, error %@", __FUNCTION__, (unsigned long)type, error);
}

@end
