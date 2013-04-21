    //
//  DropDownView.m
//  CustomTableView
//
//  Created by Ameya on 19/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DropDownView.h"

#import <QuartzCore/QuartzCore.h>


@implementation DropDownView

@synthesize uiTableView;

@synthesize arrayData,heightOfCell,refView, imageArray;

@synthesize paddingLeft,paddingRight,paddingTop;

@synthesize open,close;

@synthesize heightTableView;

@synthesize delegate;

@synthesize tag;

@synthesize selectedStates;


// Check if the "thing" pass'd is empty - addition
static inline BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


- (id)initWithArrayData:(NSArray*)data imageData:(NSArray*)iData checkMarkData:(int)cData cellHeight:(CGFloat)cHeight heightTableView:(CGFloat)tHeightTableView paddingTop:(CGFloat)tPaddingTop
			paddingLeft:(CGFloat)tPaddingLeft paddingRight:(CGFloat)tPaddingRight refView:(UIView*)rView animation:(AnimationType)tAnimation 
  openAnimationDuration:(CGFloat)openDuration closeAnimationDuration:(CGFloat)closeDuration _tag: (NSInteger)thetag {

	if ((self = [super init])) {
		

		if(!isEmpty(iData)){// is the NSArray for the image data empty?
			
			areThereImages=YES;
			self.imageArray=iData;
			
		}
		else {
			areThereImages=NO;
			self.imageArray=nil;
		}
		

		
		self.tag=thetag; //addition - each dropdown view has its own tag for multiple dropdown views on one view
		
		self.arrayData = data;
		
		self.heightOfCell = cHeight;
		
		self.refView = rView;
		
		self.paddingTop = tPaddingTop;
		
		self.paddingLeft = tPaddingLeft;
		
		self.paddingRight = tPaddingRight;
		
		self.heightTableView = tHeightTableView;
		
		self.open = openDuration;
		
		self.close = closeDuration;
		
		CGRect refFrame = refView.frame;
		
		self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop,
									 refFrame.size.width+paddingRight, heightTableView+50);//+50 to stop overlap with main view
		
		self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
		
		self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
		
		self.view.layer.shadowOpacity =1.0f;
		
		self.view.layer.shadowRadius = 5.0f;
		
		animationType = tAnimation;
		
		//enables checkmark selection in table
        if(cData!=-1){// cData=-1 means no checkmarks
            int j=[arrayData count];
            selectedStates = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i =0 ; i < j; i++) {
                if(i!=cData)
                    [selectedStates addObject:[NSNumber numberWithBool:NO]];
                else {
                    [selectedStates addObject:[NSNumber numberWithBool:YES]];
                }
			
            }
        }
		
		
	}
	
	return self;
	
}	

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	CGRect refFrame = refView.frame;
		
	uiTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,refFrame.size.width+paddingRight, (animationType == BOTH || animationType == BLENDIN)?heightTableView:1) style:UITableViewStylePlain];
    
    [uiTableView.layer setCornerRadius:7.0];// addition - rounded instead of rectangle
	
	uiTableView.dataSource = self;
	
	uiTableView.delegate = self;
	
	self.uiTableView.separatorStyle=UITableViewCellSeparatorStyleNone;//no cell lines

	
	//[self.uiTableView setAlwaysBounceVertical:YES]; ? vertical scrolling (downwards) not working properly with long lists
	
	[self.view addSubview:uiTableView];
	
	self.view.hidden = YES;
	
	if(animationType == BOTH || animationType == BLENDIN)
		[self.view setAlpha:1];
	
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}


#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return heightOfCell;
	
	
}	

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	
	return [arrayData count];
	
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    
	cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
	
	if(areThereImages && !isEmpty([imageArray objectAtIndex:indexPath.row]))
		cell.imageView.image=[self imageWithImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]
									 scaledToSize:CGSizeMake(20, 20)];// keep images to 20x20	
	
	//checkmarks
    {
        if ([[selectedStates objectAtIndex:indexPath.row] boolValue] == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else { 
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
	

		
	return cell;
	
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	NSNumber *newState;
	newState = [NSNumber numberWithBool:YES]; 
	[selectedStates replaceObjectAtIndex:indexPath.row withObject:newState];

	//uncheck previous selection
    {
        for(int i=0;i<[arrayData count];i++){
	
            if(i!=indexPath.row){
                [selectedStates replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
			
            }
        }
	}
	
	[tableView reloadData];
	[delegate dropDownCellSelected:indexPath.row: self.tag];
	[self closeAnimation];
	
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

	return 0;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

	return 0;
	
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{

	return @"";
	
}
 
*/

#pragma mark -
#pragma mark DropDownViewDelegate

-(void)dropDownCellSelected:(NSInteger)returnIndex: (NSNumber *)_tag{
	
}	

#pragma mark -
#pragma mark Class Methods


-(void)openAnimation{
	
	self.view.hidden = NO;
	

	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:open];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, heightTableView);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 1;
	
	[UIView commitAnimations];
    
    [self.uiTableView flashScrollIndicators];
		
}

-(void)closeAnimation{
	
	NSValue *contextPoint = [NSValue valueWithCGPoint:self.view.center];
	
	[UIView beginAnimations:nil context:(__bridge void *)(contextPoint)];
	
	[UIView setAnimationDuration:close];
	
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDelay:0];
	
	if(animationType == BOTH || animationType == GROW)
		self.uiTableView.frame = CGRectMake(uiTableView.frame.origin.x,uiTableView.frame.origin.y,uiTableView.frame.size.width, 1);
	
	if(animationType == BOTH || animationType == BLENDIN)
		self.view.alpha = 0;
	
	[UIView commitAnimations];
	
	[self performSelector:@selector(hideView) withObject:nil afterDelay:close];
	
	
		
}

-(void)adjustFrameToView {// use if the frame of the reference view changes
    
    CGRect refFrame = refView.frame;
    
    self.view.frame = CGRectMake(refFrame.origin.x-paddingLeft,refFrame.origin.y+refFrame.size.height+paddingTop,
                                 refFrame.size.width+paddingRight, heightTableView+50);//+50 to stop overlap with main view
    
}

-(void)adjustFrameToPoint: (CGPoint) p{ // use to move the view to any point
    
    CGRect frame=self.view.frame;
    frame.origin=p;
    self.view.frame=frame;
    
}
	 
-(void)hideView{
	
	self.view.hidden = YES;

}	 

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}


@end
