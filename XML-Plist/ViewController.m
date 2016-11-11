//
//  ViewController.m
//  XML-Plist
//
//  Created by 李青楠 on 2016/11/10.
//  Copyright © 2016年 Raymond. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *citysArr;
@property (nonatomic, strong) NSMutableArray *areasArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self provinceParsing];
}

- (void)provinceParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"t_province" ofType:@"xml"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *recores = [rootElement elementsForName:@"RECORD"];
    
    //初始化可变数组
    self.provinceArr = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *RECORD in recores) {
        
        GDataXMLElement *idElement = [[RECORD elementsForName:@"provinceID"] objectAtIndex:0];
        NSString *ID = [idElement stringValue];
        
        GDataXMLElement *nameElement = [[RECORD elementsForName:@"province"] objectAtIndex:0];
        NSString *name = [nameElement stringValue];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:ID,@"id",name,@"state",nil];
        
        [self.provinceArr addObject:dic];
    }

//    for (NSDictionary *dic in self.provinceArr) {
//        NSLog(@"******* = %@",dic);
//    }
    
    [self cityParsing];
}

- (void)cityParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"t_city" ofType:@"xml"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *recores = [rootElement elementsForName:@"RECORD"];
    
    //初始化可变数组
    self.citysArr = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *RECORD in recores) {
        
        GDataXMLElement *fIDElement = [[RECORD elementsForName:@"fatherID"] objectAtIndex:0];
        NSString *fID = [fIDElement stringValue];
        
        GDataXMLElement *idElement = [[RECORD elementsForName:@"cityID"] objectAtIndex:0];
        NSString *ID = [idElement stringValue];
 
        GDataXMLElement *nameElement = [[RECORD elementsForName:@"city"] objectAtIndex:0];
        NSString *name = [nameElement stringValue];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:fID,@"fid",ID,@"id",name,@"name",nil];
        
        [self.citysArr addObject:dic];
    }
    
//    for (NSDictionary *dic in self.citysArr) {
//        NSLog(@"******* = %@",dic);
//    }
    
    [self areaParsing];
}

- (void)areaParsing
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"t_areas" ofType:@"xml"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:data error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *recores = [rootElement elementsForName:@"RECORD"];
    
    //初始化可变数组
    self.areasArr = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *RECORD in recores) {
        GDataXMLElement *idElement = [[RECORD elementsForName:@"areaid"] objectAtIndex:0];
        NSString *ID = [idElement stringValue];
        
        GDataXMLElement *cIDElement = [[RECORD elementsForName:@"cityid"] objectAtIndex:0];
        NSString *cID = [cIDElement stringValue];
        
        GDataXMLElement *nameElement = [[RECORD elementsForName:@"area"] objectAtIndex:0];
        NSString *name = [nameElement stringValue];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cID,@"cid",ID,@"id",name,@"name",nil];
        
        [self.areasArr addObject:dic];
    }
    
//    for (NSDictionary *dic in self.areasArr) {
//        NSLog(@"******* = %@",dic);
//    }
    
    [self wirteXML];
}

- (void)wirteXML
{
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"array"];
    
    for (NSDictionary *dic1 in self.provinceArr) {
        
        GDataXMLElement *dict1Element = [GDataXMLNode elementWithName:@"dict" stringValue:nil];
        
        GDataXMLElement *key1Element = [GDataXMLNode elementWithName:@"key" stringValue:@"id"];
        [dict1Element addChild:key1Element];
        GDataXMLElement *str1Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic1 objectForKey:@"id"]];
        [dict1Element addChild:str1Element];
        GDataXMLElement *key2Element = [GDataXMLNode elementWithName:@"key" stringValue:@"state"];
        [dict1Element addChild:key2Element];
        GDataXMLElement *str2Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic1 objectForKey:@"state"]];
        [dict1Element addChild:str2Element];
        
        GDataXMLElement *arr1keyElement = [GDataXMLNode elementWithName:@"key" stringValue:@"cities"];
        [dict1Element addChild:arr1keyElement];
        
        GDataXMLElement *arr1Element = [GDataXMLNode elementWithName:@"array" stringValue:nil];
        
        for (NSDictionary *dic2 in self.citysArr) {
            
            if ([[dic2 objectForKey:@"fid"] isEqualToString:[dic1 objectForKey:@"id"]]) {
                
                GDataXMLElement *dict2Element = [GDataXMLNode elementWithName:@"dict" stringValue:nil];
                
                GDataXMLElement *key1Element = [GDataXMLNode elementWithName:@"key" stringValue:@"id"];
                [dict2Element addChild:key1Element];
                GDataXMLElement *str1Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic2 objectForKey:@"id"]];
                [dict2Element addChild:str1Element];
                GDataXMLElement *key2Element = [GDataXMLNode elementWithName:@"key" stringValue:@"name"];
                [dict2Element addChild:key2Element];
                GDataXMLElement *str2Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic2 objectForKey:@"name"]];
                [dict2Element addChild:str2Element];
                
                GDataXMLElement *arr2keyElement = [GDataXMLNode elementWithName:@"key" stringValue:@"areas"];
                [dict2Element addChild:arr2keyElement];
                
                GDataXMLElement *arr2Element = [GDataXMLNode elementWithName:@"array" stringValue:nil];
                
                for (NSDictionary *dic3 in self.areasArr) {
                    
                    if ([[dic3 objectForKey:@"cid"] isEqualToString:[dic2 objectForKey:@"id"]]) {
                        
                        GDataXMLElement *dict3Element = [GDataXMLNode elementWithName:@"dict" stringValue:nil];
                        
                        GDataXMLElement *key1Element = [GDataXMLNode elementWithName:@"key" stringValue:@"id"];
                        [dict3Element addChild:key1Element];
                        GDataXMLElement *str1Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic3 objectForKey:@"id"]];
                        [dict3Element addChild:str1Element];
                        GDataXMLElement *key2Element = [GDataXMLNode elementWithName:@"key" stringValue:@"name"];
                        [dict3Element addChild:key2Element];
                        GDataXMLElement *str2Element = [GDataXMLNode elementWithName:@"string" stringValue:[dic3 objectForKey:@"name"]];
                        [dict3Element addChild:str2Element];
                        
                        [arr2Element addChild:dict3Element];
                    }
                }
                
                [dict2Element addChild:arr2Element];
                
                [arr1Element addChild:dict2Element];
            }
        }
        
        [dict1Element addChild:arr1Element];
        
        [rootElement addChild:dict1Element];
    }
  

    // 生成xml文件内容
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    NSData *data1 = [xmlDoc XMLData];
    NSString *xmlString = [[NSString alloc] initWithData:data1 encoding:NSWindowsCP1253StringEncoding];
    NSLog(@"xmlString  %@", xmlString);
}

- (void)testWirteXML
{
    GDataXMLElement *rootElement = [GDataXMLNode elementWithName:@"array"];
    
    GDataXMLElement *dictElement = [GDataXMLNode elementWithName:@"dict" stringValue:nil];
    
    // 创建一个标签元素
    GDataXMLElement *key1Element = [GDataXMLNode elementWithName:@"key" stringValue:@"id"];
    [dictElement addChild:key1Element];
    GDataXMLElement *str1Element = [GDataXMLNode elementWithName:@"string" stringValue:@"110000"];
    [dictElement addChild:str1Element];
    GDataXMLElement *key2Element = [GDataXMLNode elementWithName:@"key" stringValue:@"state"];
    [dictElement addChild:key2Element];
    GDataXMLElement *str2Element = [GDataXMLNode elementWithName:@"string" stringValue:@"北京"];
    [dictElement addChild:str2Element];
    
    GDataXMLElement *arrElement = [GDataXMLNode elementWithName:@"array" stringValue:@"123123"];
    [dictElement addChild:arrElement];
    
    [rootElement addChild:dictElement];
    
    // 生成xml文件内容
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithRootElement:rootElement];
    NSData *data1 = [xmlDoc XMLData];
    NSString *xmlString = [[NSString alloc] initWithData:data1 encoding:NSWindowsCP1253StringEncoding];
    NSLog(@"xmlString  %@", xmlString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
