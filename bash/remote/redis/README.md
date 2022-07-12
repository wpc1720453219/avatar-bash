# Redis安装

## 需要运行时添加的配置

第92行：port 6379（端口号）

第158行：pidfile /var/run/redis_6379.pid（后边的数字改成跟端口号一致）

第171行：logfile ""（日志路径，指定为${redis.home}/single/redis.log，必须为绝对路径，${redis.home}表示redis的安装目录，必须配置）

第263行：dir ./（表示RDB文件的保存目录，需要修改为single的绝对路径，否则会保存在src中，必须配置）

第500行：requirepass foobared（设置redis的密码，注释掉表示不需要）

### 可能需要修改的地方
第218行：RDB持久化配置，全部注释掉并加上save ""表示关闭RDB持久化
save 900 1（每900秒内有1个key修改则进行持久化）
save 300 10（每300秒内有10个key修改则进行持久化）
save 60 10000（每60秒内有10000个key修改则进行持久化）

第559行：maxmemory <bytes>（redis最大占用内存，根据实际情况配置，单位是字节，如果注释掉则不限制内存，但是还是受系统可用内存限制）

第590行：maxmemory-policy noeviction（缓存清除策略，当内存占用满的时候，会触发这个策略，清空一部分key，默认不清除，而是对写请求报错）
主要是两个策略：
volatile-lru：使用LRU算法清除带有过期时间的缓存，LRU即清除长时间未使用的缓存
volatile-lfu：使用LFU算法清除带有过期时间的缓存，LFU即清除很少使用的缓存

第672行：appendonly no（是否开启AOF持久化）

