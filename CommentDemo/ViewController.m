//
//  ViewController.m
//  CommentDemo
//
//  Created by 徐佳俊 on 15/4/26.
//  Copyright (c) 2015年 morrison. All rights reserved.
//

#import "ViewController.h"

#import "CommentCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create
    _viewMain = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_viewMain];
    
    
    // Events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _viewMain.tvContent.delegate = self;
    _viewMain.tvContent.dataSource = self;
    
    [_viewMain.btSend addTarget:self action:@selector(sendReply) forControlEvents:UIControlEventTouchUpInside];
    
    // Config & Init
    _comments = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 功能函数

- (void)sendReply {
    NSString *commentMsg = [_viewMain.tvInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([commentMsg length] == 0) {
        [self showAlertWithMsg:@"评论不能为空"];
        return;
    }
    
    [_comments addObject:commentMsg];
    [_viewMain.tvContent reloadData];
    _viewMain.tvInput.text = @"";
}

- (void)showAlertWithMsg:(NSString *)msg {
    [[[UIAlertView alloc]initWithTitle:@"提醒"
                               message:msg
                              delegate:self
                     cancelButtonTitle:@"确认"
                     otherButtonTitles:nil] show];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_viewMain.tvInput resignFirstResponder];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    [cell setMessage:_comments[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
}

#pragma mark - Keyboard Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [self changeContentViewPoint:keyboardRect.size.height withDuration:duration.doubleValue withCurve:curve.intValue];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [self changeContentViewPoint:0 withDuration:duration.doubleValue withCurve:curve.intValue];
}

// 根据键盘状态，调整_mainView的位置
- (void) changeContentViewPoint:(float)keyboardHeight withDuration:(float)duration withCurve:(int)curve
{
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:curve];
        
        CGRect frame = _viewMain.frame;
        frame.origin.y = -keyboardHeight;
        _viewMain.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

@end
