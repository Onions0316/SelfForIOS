//
//  SearchViewController.m
//  self
//
//  Created by roy on 16/3/7.
//  Copyright © 2016年 onions. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailService.h"
#import "AccountInfoManager.h"

#define Tag_Top_Begin_Time 4001
#define Tag_Top_End_Time 4002
#define Tag_Top_Type 4003

#define Tag_Top_Toggle_Button 4101

#define Search_Select_All @"设置全选"
#define Search_Not_Select_All @"取消全选"

@interface SearchViewController()<UITableViewDataSource, UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

CREATE_TYPE_PROPERTY_TO_VIEW(UITableView, table)
CREATE_TYPE_PROPERTY_TO_VIEW(NSMutableArray<Detail*>, data)

CREATE_TYPE_PROPERTY_TO_VIEW(UIView, topView)
CREATE_TYPE_PROPERTY_TO_VIEW(UIView, coverView)
CREATE_TYPE_PROPERTY_TO_VIEW(UIView, mainView)

CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, start)
CREATE_TYPE_PROPERTY_TO_VIEW(UIDatePicker, startPciker)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, end)
CREATE_TYPE_PROPERTY_TO_VIEW(UIDatePicker, endPicker)
CREATE_TYPE_PROPERTY_TO_VIEW(UITextField, type)
CREATE_TYPE_PROPERTY_TO_VIEW(UIPickerView, typePicker)
CREATE_TYPE_PROPERTY_TO_VIEW(NSDictionary, typeData)
CREATE_TYPE_PROPERTY_TO_VIEW(NSArray, typeDataArray)

@property (nonatomic,assign) BOOL isShowTop;
@property (nonatomic,assign) BOOL isShowTool;

@property (nonatomic,assign) CGFloat top;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int size;
@property (nonatomic,assign) int totalCount;

CREATE_TYPE_PROPERTY_TO_VIEW(DetailService, detailService)
CREATE_TYPE_PROPERTY_TO_VIEW(NSNumber, userId)

@end

@implementation SearchViewController

- (id) init{
    if(self=[super init]){
        super.navTitle = Search;
        super.showBack = YES;
        super.showLogout = NO;
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.isShowTop = NO;
    self.isShowTool = NO;
    self.detailService = [[DetailService alloc] init];
    self.userId = [AccountInfoManager sharedInstance].user.user_id;
    self.page = 0;
    self.size = 10;
    //默认显示搜索条件
    [self topToggle];
}

- (void) drawContent{
    self.top = super.topSize;
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0,self.top , Main_Screen_Width, Main_Screen_Height-self.top)];
    self.coverView.backgroundColor = [UIColor grayColor];
    self.coverView.alpha = 0.5;
    self.coverView.hidden = YES;
    //给view添加点击事件
    [self.coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topToggle)]];
    [self drawTop];
    [self drawMain];
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.topView];
}

- (void) drawTop{
    NSArray * fileds = @[Search_Begin_Time,Search_End_Time,Detail_Type];
    CGFloat maxLabelWidth = [UIUtil textMaxWidth:fileds font:Default_Font];
    
    CGFloat viewHeight = 5*Default_View_Space + 4*Default_Label_Height +Default_View_Space;
    CGFloat viewTop = self.top-viewHeight+Default_View_Space;
    CGFloat viewWidth = maxLabelWidth+Default_View_Space+Default_TextFiled_Width+2*Default_View_Space;
    CGFloat viewLeft = (Main_Screen_Width-viewWidth)/2;
    CGRect rect = CGRectMake(viewLeft, viewTop, viewWidth, viewHeight);
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(viewLeft, viewTop, viewWidth, viewHeight)];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    rect.origin.x= 0;
    rect.origin.y = viewHeight-Default_View_Space;
    rect.size.height = Default_View_Space;
    [UIUtil addButtonInView:self.topView image:[UIImage imageNamed:@"down"] rect:rect sel:@selector(topToggle) controller:self tag:[NSNumber numberWithInt:Tag_Top_Toggle_Button]];
    
    CGFloat tagIndex = Tag_Top_Begin_Time;
    rect = CGRectMake(Default_View_Space, Default_View_Space, maxLabelWidth, Default_Label_Height);
    for(NSString * str in fileds){
        [UIUtil addLabelTextFiledInView:self.topView text:str rect:rect tag:[NSNumber numberWithInt:tagIndex]];
        tagIndex++;
        rect.origin.y+=Default_Label_Height+Default_View_Space;
    }
    //开始时间
    self.start = [self.topView viewWithTag:Tag_Top_Begin_Time];
    self.start.clearButtonMode = UITextFieldViewModeAlways;
    //开始时间选择器
    NSDate * now = [Util nowDate];
    self.startPciker = [[UIDatePicker alloc] init];
    self.startPciker.frame = CGRectMake(0, 0, 0, 100);
    self.startPciker.maximumDate = now;
    self.startPciker.datePickerMode = UIDatePickerModeDateAndTime;
    [UIUtil addTextFildInputView:self.start inputView:self.startPciker controller:self done:@selector(startDoneTouch:) cancel:nil];

    //结束时间
    self.end = [self.topView viewWithTag:Tag_Top_End_Time];
    self.end.clearButtonMode = UITextFieldViewModeAlways;
    //结束时间选择器
    self.endPicker = [[UIDatePicker alloc] init];
    self.endPicker.frame = CGRectMake(0, 0, 0, 100);
    self.endPicker.date = now;
    self.endPicker.maximumDate = now;
    self.endPicker.datePickerMode = UIDatePickerModeDateAndTime;
    [UIUtil addTextFildInputView:self.end inputView:self.endPicker controller:self done:@selector(endDoneTouch:) cancel:nil];
    //收支类型
    self.type = [self.topView viewWithTag:Tag_Top_Type];
    self.type.text = Search_Type_All;
    self.type.clearButtonMode = UITextFieldViewModeNever;
    self.typeData = @{Search_Type_All:@0,Detail_Type_In:[NSNumber numberWithInt:In],Detail_Type_Out:[NSNumber numberWithInt:Out]};
    self.typeDataArray = self.typeData.allKeys;
    //收支类型选择器
    self.typePicker = [[UIPickerView alloc] init];
    self.typePicker.showsSelectionIndicator = YES;
    self.typePicker.delegate = self;
    self.typePicker.dataSource = self;
    self.typePicker.frame = CGRectMake(0, 0, 0, 100);
    //self.sex.userInteractionEnabled = NO;
    [UIUtil addTextFildInputView:self.type inputView:self.typePicker controller:self done:@selector(typeDoneTouch:) cancel:nil];
    //滑动按钮
    [UIUtil addButtonInView:self.topView title:Search rect:rect sel:@selector(search) controller:self tag:nil];
    //添加编辑按钮
    [super addTitleButton:@"bi" sel:@selector(toggleTool)];
    //self.top+=Default_View_Space;
}

- (void) drawMain{
    
    CGFloat viewTop = self.top;
    CGFloat viewHeight = Main_Screen_Height-viewTop;
    CGFloat viewLeft = 0;
    CGFloat viewWidth = Main_Screen_Width;
    CGRect rect = CGRectMake(viewLeft, viewTop, viewWidth, viewHeight);
    self.mainView = [[UIView alloc] initWithFrame:rect];
    
    self.data =[[NSMutableArray<Detail *> alloc] init];
    rect.origin.x=0;
    rect.origin.y = -1*Default_Label_Height;
    rect.size.height+=Default_Label_Height;
    self.table = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    //设置多选按钮
    [self.table setAllowsMultipleSelectionDuringEditing:YES];
    
    self.table.delegate = self;
    self.table.dataSource = self;
    //设置表格脚
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Default_Label_Height)];
    CGFloat moreLeft = 3*Default_View_Space;
    [UIUtil addButtonInView:self.table.tableFooterView title:@"加载更多" rect:CGRectMake(moreLeft, 0, viewWidth-2*moreLeft, Default_Label_Height) sel:@selector(loadMore) controller:self tag:nil];
    //设置表格头
    self.table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Default_Label_Height)];
    CGFloat headerButtonLeft = 2*Default_View_Space;
    CGFloat headerButtonWidth = (viewWidth-4*headerButtonLeft)/3;
    rect = CGRectMake(headerButtonLeft, 0, headerButtonWidth, Default_Label_Height);
    [UIUtil addButtonInView:self.table.tableHeaderView title:Search_Select_All rect:rect sel:@selector(toggleSelectAll:) controller:self tag:nil];
    rect.origin.x += headerButtonLeft+headerButtonWidth;
    [UIUtil addButtonInView:self.table.tableHeaderView title:@"合并数据" rect:rect sel:@selector(mergeSelected) controller:self tag:nil];
    rect.origin.x += headerButtonLeft+headerButtonWidth;
    [UIUtil addButtonInView:self.table.tableHeaderView title:@"删除数据" rect:rect sel:@selector(removeSelected) controller:self tag:nil];
    self.table.tableFooterView.hidden = YES;
    self.table.tableHeaderView.hidden = YES;
    [UIUtil addViewInView:self.mainView subview:self.table tag:nil];
    [self.view addSubview:self.mainView];
}

#pragma mark operation
- (void) toggleTool{
    if(self.data.count==0 && !self.isShowTool){
        [super showAlert:Alert_Warning message:@"无数据,无法编辑" controller:nil];
    }else{
        self.table.tableHeaderView.hidden = self.isShowTool;
        CGRect rect = self.table.frame;
        self.isShowTool = !self.isShowTool;
        if(self.isShowTool){
            rect.origin.y+=Default_Label_Height;
            rect.size.height-=Default_Label_Height;
        }else{
            rect.origin.y-=Default_Label_Height;
            rect.size.height+=Default_Label_Height;
        }
        self.table.frame = rect;
        [self.table setEditing:self.isShowTool];
    }
}

- (void) toggleSelectAll:(UIButton *) sender{
    NSString * title = @"";
    if([sender.titleLabel.text isEqualToString:Search_Select_All]){
        title = Search_Not_Select_All;
        for(int i=0;i<self.data.count;i++){
            NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
            [self.table selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else{
        title = Search_Select_All;
        NSArray<NSIndexPath*> * list = [self.table indexPathsForSelectedRows];
        for(NSIndexPath * path in list){
            [self.table deselectRowAtIndexPath:path animated:NO];
            //[self.table cellForRowAtIndexPath:path].accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [sender setTitle:title forState:UIControlStateNormal];
}

- (void) removeSelected{
    NSArray * ids = [self selectedData];
    if(ids.count>0){
        self.page = 0;
        [self.detailService removeByIds:ids];
        [self searchData:NO];
        [Single sharedInstance].isTotal = YES;
    }
}

- (void) mergeSelected{
    NSArray * ids = [self selectedData];
    if(ids.count>0){
        self.page = 0;
        [self.detailService mergeByIds:ids];
        [self searchData:NO];
        [Single sharedInstance].isTotal = YES;
    }
}

- (NSArray *) selectedData{
    NSMutableArray * ids = [[NSMutableArray alloc] init];
    if(self.data.count>0){
        NSArray<NSIndexPath*> * list = [self.table indexPathsForSelectedRows];
        for(NSIndexPath * path in list){
            Detail * rowData = [self.data objectAtIndex:path.row];
            if(rowData){
                [ids addObject:rowData.detail_id];
            }
        }
        if(ids.count==0){
            [super showAlert:Alert_Warning message:@"请选择数据" controller:nil];
        }
    }else{
        [super showAlert:Alert_Warning message:@"请先查询数据" controller:nil];
    }
    return ids;
}

/*
 *  加载更多
 */
- (void) loadMore{
    self.page++;
    [self searchData:true];
}


#pragma mark search
- (void) search{
    self.page = 0;
    if([self searchData:false]){
        [self topToggle];
    }
}

- (BOOL) searchData:(BOOL) isAppend{
    NSString * startString = self.start.text;
    NSNumber * startNumber = nil;
    if([startString hasValue]){
        startNumber =[NSNumber numberWithInt:[Util stringToDate:startString format:Default_Date_Time_Format].timeIntervalSince1970];
    }
    NSString * endString = self.end.text;
    NSNumber * endNumber = nil;
    if([endString hasValue]){
        endNumber =[NSNumber numberWithInt:[Util stringToDate:endString format:Default_Date_Time_Format].timeIntervalSince1970];
    }
    if(startNumber && endNumber && startNumber>endNumber){
        [super showAlert:Alert_Error message:@"开始时间不能大于结束时间" controller:nil];
        return NO;
    }else{
        NSString * typeString = [self.type.text stringByCutEmpty];
        NSNumber * typeNumber = nil;
        if([typeString hasValue]){
            typeNumber = [self.typeData objectForKey:typeString];
        }
        
        NSArray * list = [self.detailService search:self.userId start:startNumber end:endNumber type:typeNumber page:self.page size:self.size count:&_totalCount];
        if(isAppend){
            [self.data addObjectsFromArray:list];
        }else{
            [self.data removeAllObjects];
            self.data = [NSMutableArray arrayWithArray:list];
        }
        self.table.tableFooterView.hidden = self.data.count>=self.totalCount;
        [self.table reloadData];
    }
    return YES;
}

- (void) startDoneTouch:(UIBarButtonItem *) sender{
    self.start.text =[Util dateToString:[self.startPciker date] format:Default_Date_Time_Format];
    [self.start resignFirstResponder];
}

- (void) endDoneTouch:(UIBarButtonItem *) sender{
    self.end.text =[Util dateToString:[self.endPicker date] format:Default_Date_Time_Format];
    [self.end resignFirstResponder];
}

- (void) typeDoneTouch:(UIBarButtonItem *) sender{
    self.type.text = [self.typeDataArray objectAtIndex:[self.typePicker selectedRowInComponent:0]];
    [self.type resignFirstResponder];
}


#pragma mark type picker
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.typeDataArray count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.typeDataArray objectAtIndex:row];
}


#pragma mark top toggle
- (void) topToggle{
    // 开始设置动画
    [UIView beginAnimations:nil context:nil];
    // 动画执行时间
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDelegate:self];
    
    UIButton * btn = [self.topView viewWithTag:Tag_Top_Toggle_Button];
    CGRect rect = self.topView.frame;
    NSString * imageName = @"";
    if(self.isShowTop){
        rect.origin.y-=rect.size.height-Default_View_Space;
        imageName = @"down";
        self.coverView.hidden = YES;
    }else{
        rect.origin.y+=rect.size.height-Default_View_Space;
        imageName = @"up";
        self.coverView.hidden = NO;
    }
    self.topView.frame = rect;
    self.isShowTop = !self.isShowTop;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [UIView commitAnimations];
}

#pragma mark 设置每行显示

/*
 *  行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = self.data.count;
    if(count==0){
        count = 1;
    }
    return count;
}

/*
 *  table行
 */
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(self.data.count==0){
        cell.textLabel.text = @"无";
    }else{
        NSUInteger row = [indexPath row];
        Detail * rowData = [self.data objectAtIndex:row];
        if(rowData){
            [super setDetailAmount:cell.textLabel amount:rowData.amount];
            cell.detailTextLabel.text = [Util dateToString:[Util timeToDate:rowData.happen_time] format:Default_Date_Time_Format];
        }
    }
    return cell;
}

@end