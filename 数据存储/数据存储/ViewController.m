//
//  ViewController.m
//  数据存储
//
//  Created by Mac_UI on 2018/6/14.
//  Copyright © 2018年 Mac_UI. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
@interface ViewController (){
    FMDatabase *_db;
}

//输入框
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
//显示的文字
@property (weak, nonatomic) IBOutlet UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark —————————— plist 存取 ————————————
//plist存
- (IBAction)plistSaveAction {
    //获取plist 文件的全路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
    
    //把值存入到plis中
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.textFiled.text forKey:@"shop"];
    [dict writeToFile:path atomically:YES];
}

//plist取
- (IBAction)plistFetch:(id)sender {
     NSString *path = [[NSBundle mainBundle] pathForResource:@"shops" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.showLabel.text = [dict objectForKey:@"shop"];
}


#pragma mark ————————(UserDefaults) 偏好设置存取 ——————————

//偏好设置存
- (IBAction)userDefaultsSave {
    [[NSUserDefaults standardUserDefaults] setValue:self.textFiled.text forKey:@"shop1"];
    
}

//偏好设置取
- (IBAction)userDefaultFetch {
    NSString * text = [[NSUserDefaults standardUserDefaults] valueForKey:@"shop1"];
    self.showLabel.text = text;
}


#pragma mark —————————————— NSKeyedArchiver(数据归档) ——————————————————


// 归档(存)
- (IBAction)nsKeyedArchiverSaveAction {
     NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //1 使用archiveRootObjct: toFile: 方法归档
    //2 修改当前目录为documentPath
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    [sharedFM changeCurrentDirectoryPath:documentsPath];
    
    //3 归档
    if ([NSKeyedArchiver archiveRootObject:self.textFiled.text toFile:@"shop2"]) {
        NSLog(@"归档成功");
    }
    
    
}

// 解档（取）
- (IBAction)nsKeyedArchiverFetchAction {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //读取归档
     NSString *shop2 = [documentsPath stringByAppendingPathComponent:@"shop2"];
    self.showLabel.text =  [NSKeyedUnarchiver unarchiveObjectWithFile:shop2];
    
}








#pragma mark —————————————— fmdb存取（sqlite） ————————————————————
// fmdb存
- (IBAction)FMDBSaveAction {
    //1获得Documnets目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 根据文件路径创建db文件
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"test.db"];
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:dbPath];
    
    // 在数据库中进行增删改查操作，需要判断数据库是是否open, 如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [_db open];
    if (![_db open]) {
        NSLog(@"db open fail");
        return;
    }
    
    //数据库中创建表
    NSString *sql = @"create table if not exists t_student ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL)";
    BOOL result = [_db executeUpdate:sql];
    if (result) {
        NSLog(@"create table success");
        
    }
    
    //加入数据
    BOOL result1 = [_db executeUpdate:@"insert into 't_student'(ID,name) values(?,?)" withArgumentsInArray:@[@113,self.textFiled.text]];
    if (result1) {
        NSLog(@"insert into 't_studet' success");
    }
    
    [_db close];
                    
    
    
    
    
    
    
    
}

//fmdb取
- (IBAction)fmdbFetchAction:(id)sender {
    
    //1获得Documnets目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 根据文件路径创建db文件
    NSString *dbPath = [documentsPath stringByAppendingPathComponent:@"test.db"];
    
    // 实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:dbPath];
    
    [_db open];
    if (![_db open]) {
        NSLog(@"db open fail");
        return;
    }
    
    FMResultSet *result = [_db executeQuery:@"select * from 't_student' where ID = ?" withArgumentsInArray:@[@113]];
    NSString *text = NULL;
    while ([result next]) {
        text = [result stringForColumn:@"name"];
    }
    
    self.showLabel.text =  text;
    [_db close];
    
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
