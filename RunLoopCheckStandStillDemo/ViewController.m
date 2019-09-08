//
//  ViewController.m
//  RunLoopCheckStandStillDemo
//
//  Created by junshao on 2019/9/8.
//  Copyright © 2019 junshao. All rights reserved.
//

#import "ViewController.h"
#import "IGRunloopManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [IGRunloopManager sharedInstance].limitMillisecond = 400;
    [IGRunloopManager sharedInstance].standstillCount = 1;
    [[IGRunloopManager sharedInstance] registerObserver];
    
    //    [IGWeexRouter gotoWeexPage:@"/kpl/kpl-home"];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cellIdentity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    if(indexPath.row %10 == 0){
        usleep(1*1000*1000);
        cell.textLabel.text = @"卡鲁";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
