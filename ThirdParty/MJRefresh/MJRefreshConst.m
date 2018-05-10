
#import <UIKit/UIKit.h>

const CGFloat MJRefreshLabelLeftInset = 25;
const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

//NSString *const MJRefreshHeaderIdleText = @"MJRefreshHeaderIdleText";
//NSString *const MJRefreshHeaderPullingText = @"MJRefreshHeaderPullingText";
//NSString *const MJRefreshHeaderRefreshingText = @"MJRefreshHeaderRefreshingText";
//
//NSString *const MJRefreshAutoFooterIdleText = @"MJRefreshAutoFooterIdleText";
//NSString *const MJRefreshAutoFooterRefreshingText = @"MJRefreshAutoFooterRefreshingText";
//NSString *const MJRefreshAutoFooterNoMoreDataText = @"MJRefreshAutoFooterNoMoreDataText";
//
//NSString *const MJRefreshBackFooterIdleText = @"MJRefreshBackFooterIdleText";
//NSString *const MJRefreshBackFooterPullingText = @"MJRefreshBackFooterPullingText";
//NSString *const MJRefreshBackFooterRefreshingText = @"MJRefreshBackFooterRefreshingText";
//NSString *const MJRefreshBackFooterNoMoreDataText = @"MJRefreshBackFooterNoMoreDataText";
//
//NSString *const MJRefreshHeaderLastTimeText = @"MJRefreshHeaderLastTimeText";
//NSString *const MJRefreshHeaderDateTodayText = @"MJRefreshHeaderDateTodayText";
//NSString *const MJRefreshHeaderNoneLastDateText = @"MJRefreshHeaderNoneLastDateText";

NSString *const MJRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const MJRefreshHeaderPullingText = @"松开立即刷新";
NSString *const MJRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const MJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const MJRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const MJRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const MJRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const MJRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const MJRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const MJRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const MJRefreshHeaderLastTimeText = @"最后更新：";
NSString *const MJRefreshHeaderDateTodayText = @"今天";
NSString *const MJRefreshHeaderNoneLastDateText = @"无记录";