# ZFNetWorkCacheTool
 带缓存的网络请求：
 里面使用YYCache 和YYModel，YYWebImage,AFNetWorking 的使用
 我的缓存策略有两种
 # 第一种方式 （FMDB数据库）

 1.先请求，请求到show并且存一份到Sqlite
 
 2.下次请求前判断网络
 
 3.有网 --》继续1
 
 4.没有网络 -》加载缓存
 
 使用YYCache之后
 
 # 第二种方式 (YYCache)
 /**
 
 *start
 
 * 1.先加载缓存
 
 * 2.判断有没有网络
 
 * 3.如果没有网络则return
 
 * 4.有网，则继续请求，然后刷新内容，刷新缓存
 
