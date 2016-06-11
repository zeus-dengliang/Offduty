//
//  ViewController.m
//  Ｏffduty
//
//  Created by ios-dev on 16/5/30.
//  Copyright © 2016年 com.jl. All rights reserved.
//

#import "ViewController.h"
#import "OffdutyInfo.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "JLHttpClient.h"

@interface ViewController ()
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UITextField *hoursTextFieldView;
@property(nonatomic, strong)UITextField *startDateText;
@property(nonatomic, strong)UITextField *enddateText;
@property(nonatomic, strong)UITextView *memoText;
@property(nonatomic, strong)NSString *selectText;
@property(nonatomic, strong)UIDatePicker *datePicker;
@property(nonatomic,strong)NSDateFormatter *dateFormatter;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    float yPosition = 0;
    float width = [UIScreen mainScreen].bounds.size.width - 10;
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    UILabel *offdutyLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, yPosition+35*1, width, 30)];
    offdutyLabel.font = [UIFont systemFontOfSize:14];
    offdutyLabel.text = @"存班小时数:";
    [self.view addSubview:offdutyLabel];
    
    UITextField  *typeText = [[UITextField alloc]initWithFrame:CGRectMake(5, yPosition+35*2, width, 30)];
    typeText.borderStyle = UITextBorderStyleRoundedRect;
    typeText.font = [UIFont systemFontOfSize:14];
    //typeText.placeholder = @"";
    typeText.returnKeyType = UIReturnKeyDone;
    typeText.enabled = false;
    [self.view addSubview:typeText];
    self.hoursTextFieldView = typeText;
    self.hoursTextFieldView.delegate = self;
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, yPosition+35*3, width, 30)];
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.text = @"请填写调休时间:";
    [self.view addSubview:dateLabel];
    
    
    
    
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-dd 08:00:00"];
    NSString *str = [outputFormatter stringFromDate:now];
    
    UITextField *startDateText = [[UITextField alloc]initWithFrame:CGRectMake(5, yPosition+35*4, width, 30)];
    startDateText.font = [UIFont systemFontOfSize:14];
    startDateText.backgroundColor = [UIColor whiteColor];
    startDateText.placeholder = @"调休开始时间";
    startDateText.clearButtonMode = UITextFieldViewModeAlways;
    startDateText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    startDateText.borderStyle = UITextBorderStyleRoundedRect;
    startDateText.delegate = self;
    startDateText.tag = 1001;
    startDateText.text = str;
    [self.view addSubview:startDateText];
    self.startDateText = startDateText;
    self.startDateText.delegate = self;
    
    UITextField *endDateText = [[UITextField alloc]initWithFrame:CGRectMake(5, yPosition+35*5, width, 30)];
    endDateText.font = [UIFont systemFontOfSize:14];
    endDateText.backgroundColor = [UIColor whiteColor];
    endDateText.placeholder = @"调休结束时间";
    endDateText.clearButtonMode = UITextFieldViewModeAlways;
    endDateText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    endDateText.borderStyle = UITextBorderStyleRoundedRect;
    endDateText.delegate = self;
    endDateText.tag = 1002;
    endDateText.text = str;
    [self.view addSubview:endDateText];
    self.enddateText = endDateText;
    self.enddateText.delegate = self;
    
    UILabel *memoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, yPosition+35*6, width, 30)];
    memoLabel.font = [UIFont systemFontOfSize:14];
    memoLabel.text = @"备注（少于200字）:";
    [self.view addSubview:memoLabel];
    
    UITextView *memoText = [[UITextView alloc]initWithFrame:CGRectMake(5, yPosition+35*7, width, 30*2)];
    memoText.font = [UIFont systemFontOfSize:12];
    memoText.backgroundColor = [UIColor whiteColor];
    memoText.alpha = 1.0;
    memoText.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
    memoText.returnKeyType = UIReturnKeyDefault;
    memoText.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    memoText.layer.borderWidth = 0.6f;
    memoText.layer.cornerRadius = 6.0f;
    [memoText.layer setMasksToBounds:YES];
    [memoText.layer setCornerRadius:10.0];
    [self.view addSubview:memoText];
    self.memoText = memoText;
    self.memoText.delegate = self;
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmButton.frame = CGRectMake(5, yPosition+35*9, width, 35);
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    confirmButton.backgroundColor = [UIColor orangeColor];
    [confirmButton.layer setMasksToBounds:YES];
    [confirmButton.layer setCornerRadius:10.0];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    
    //时间选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 30;
    datePicker.date = [NSDate date];
    [datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventValueChanged];
    [datePicker addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchDown];
    self.datePicker = datePicker;
    
    //时间格式化工具
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:00"];
    self.dateFormatter=formatter;
    
    [self initOffduty];
}
-(void)initOffduty
{
    //初始化存班小时数
    NSString *offduty=[self getOffdutyFromErp:empNo];
    self.hoursTextFieldView.text=offduty;
    
}
-(void)confirm
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message: @""
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil,
                          nil];
    
    if (self.hoursTextFieldView.text.length == 0 || self.startDateText.text.length == 0
        || self.enddateText.text.length == 0) {
        alert.message = @"信息输入不完整！";
        [alert show];
        return;
    }
    if(self.hoursTextFieldView.text.intValue==0){
        alert.message = @"存班小时数为0,不能调休！";
        [alert show];
        return;
    }
    NSLog(@"%ld",(long)[self.startDateText.text compare:self.enddateText.text options:NSCaseInsensitiveSearch]);
    if ([self.enddateText.text compare:self.startDateText.text] <= 0) {
        alert.message = @"请假结束日期必须大于开始日期！";
        [alert show];
        return;
        
    }

}
// 从ＥＲＰ取得存班小时数
-(NSString *)getOffdutyFromErp:(NSString *) empno
{
    NSString *offduty=@"0";
    @try {
        // 创建一个描述订单信息的 dictionary
        NSString *url=URL_ADDRESS_OFFDUTYHOUR;
        NSDictionary *orderInfo = @{@"empno" : empNo};
        NSDictionary *hoursmap=[[NSDictionary alloc] init];
        hoursmap=[JLHttpClient queryErpData:url queryData:orderInfo];
        NSString *hours=hoursmap[@"hours"];
        if (hours!=nil) {
            offduty=hours;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    return offduty;
}

-(void)selectDate:(id)sender
{
   
    NSString *str = [self.dateFormatter  stringFromDate:self.datePicker.date];
    NSString *selectText = self.selectText;
    
    if ([selectText isEqualToString: @"startDateText"]) {
        self.startDateText.text = str;
    } else if ([selectText isEqualToString: @"endDateText"]) {
        self.enddateText.text = str;
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.datePicker.superview) {
        [self.datePicker removeFromSuperview];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSString *selectText=@"";
    if (textField == self.startDateText) {
        self.selectText = @"startDateText";
        self.startDateText.backgroundColor = [UIColor orangeColor];
        self.enddateText.backgroundColor = [UIColor whiteColor];
        selectText=self.startDateText.text;
        //下面为了防止UItextfield弹出键盘
        //        self.startDateText.inputView = self.datePicker;
    } else if (textField == self.enddateText) {
        self.selectText = @"endDateText";
        self.startDateText.backgroundColor = [UIColor whiteColor];
        self.enddateText.backgroundColor = [UIColor orangeColor];
        selectText=self.enddateText.text;
    }
    NSDate *selectDate=[self.dateFormatter dateFromString:selectText];
    [self.datePicker setDate:selectDate];
    //    return YES;
    
    //如果当前要显示的键盘，那么把UIDatePicker（如果在视图中）隐藏
    if (textField.tag != 1001 && textField.tag != 1002) {
        if (self.datePicker.superview) {
            [self.datePicker removeFromSuperview];
        }
        return YES;
    }
    //选择日期结束备注的编辑状态
    [self.memoText resignFirstResponder];
    //UIDatePicker已经在当前视图上就不用再显示了
    if (self.datePicker.superview == nil) {
        //close all keyboard or data picker visible currently
        [self.hoursTextFieldView resignFirstResponder];
        
        //此处将Y坐标设在最底下，为了一会动画的展示
        self.datePicker.frame = CGRectMake(0, 310, [UIScreen mainScreen].bounds.size.width - 10, 162);
        [self.view addSubview:self.datePicker];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        //self.datePicker.hidden = false;
        [UIView commitAnimations];
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell");
    }
    return cell;
}

@end
