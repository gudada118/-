//
//  ViewController.m
//  图片轮播器测试
//
//  Created by Mr.Gu on 16/10/31.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "ViewController.h"
#import "GGLoopView.h"

#define GXCSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define GXCSCREENHEIGHT [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSURL *> *urls;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CESHICELL" forIndexPath:indexPath];
    cell.textLabel.text = @"测试数据";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        GGLoopView *loopView = [[GGLoopView alloc] initWithSelectedIndex:^(NSInteger index) {
            NSLog(@"选中的索引%ld",(long)index);
        }];
        loopView.frame = CGRectMake(0, 0, GXCSCREENWIDTH, GXCSCREENWIDTH);
        loopView.urls = self.urls;
        loopView.hasTimer = YES;
        
        return loopView;
    }else{
        return nil;
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GXCSCREENWIDTH;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if ( _tableView == nil) {
        _tableView = [[UITableView alloc ] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CESHICELL"];
    }
    return _tableView;
}

- (NSArray<NSURL *> *)urls
{
    if (_urls == nil) {
        NSArray *urlStringArray = @[@"http://pic50.nipic.com/file/20141010/9885883_092142007001_2.jpg", @"http://image.it168.com/n/640x480/8/8134/8134259.jpg"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString *urlString in urlStringArray) {
            NSURL *url = [NSURL URLWithString:urlString];
            [tempArray addObject:url];
        }
        _urls = tempArray.copy;
    }
    return _urls;
}


@end
