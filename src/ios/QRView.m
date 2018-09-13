//
//  QRView.m
//  TrustNote
//
//  Created by 曾海龙 on 2018/3/9.
//

#import "QRView.h"

@implementation QRView
{
    UIImageView *qrLine;
    CGFloat qrLineY;
    CGFloat qrLineH;
    CGRect screenDrawRect;
    CGSize transparentArea;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        screenDrawRect = self.bounds;
        transparentArea = CGSizeMake(250, 250);
        qrLineH = 5;
    }
    return self;
}

- (void)initQRLine {
    
    qrLine  = [[UIImageView alloc] initWithFrame:CGRectMake(screenDrawRect.size.width / 2 - transparentArea.width / 2, screenDrawRect.size.height / 2 - transparentArea.height / 2 , transparentArea.width, qrLineH)];
    qrLine.image = [UIImage imageNamed:@"QRCodeScanLine"];
    qrLine.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:qrLine];
    qrLineY = qrLine.frame.origin.y;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (!qrLine) {
        
        [self initQRLine];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.6 target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)show {
    
    [UIView animateWithDuration:1.5 animations:^{
        
        CGRect rect = qrLine.frame;
        rect.origin.y = screenDrawRect.size.height / 2 + transparentArea.height / 2 - qrLineH;
        qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
         qrLine.frame = rect;
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //中间清空的矩形框
    CGRect clearDrawRect = CGRectMake(screenDrawRect.size.width / 2 - transparentArea.width / 2,
                                      screenDrawRect.size.height / 2 - transparentArea.height / 2,
                                      transparentArea.width, transparentArea.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self addScreenFillRect:ctx rect:screenDrawRect];
    
    [self addCenterClearRect:ctx rect:clearDrawRect];
    
    [self addWhiteRect:ctx rect:clearDrawRect];
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(ctx, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
}

- (void)addCenterClearRect :(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextClearRect(ctx, rect);  //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}
@end
