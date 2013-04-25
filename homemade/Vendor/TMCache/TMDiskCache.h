/**
 `TMDiskCache` is a thread safe key/value store backed by the file system. It accepts any object conforming
 to the `NSCoding` protocol, which includes the basic Foundation data types and collection classes and also
 many UIKit classes, notably `UIImage`. All work is performed on a serial queue shared by all instances in
 the app, and archiving is handled by `NSKeyedArchiver`. This is a particular advantage for `UIImage` because
 it skips `UIImagePNGRepresentation()` and retains information like scale and orientation.
 
 The designated initializer for `TMDiskCache` is <initWithName:>. The <name> string is used to create a directory
 under Library/Caches that scopes disk access for any instance sharing this name. Multiple instances with the
 same name are allowed because all disk access is serialized on the <sharedQueue>. The <name> also appears in
 stack traces and return value for `description:`.
 
 Unless otherwise noted, all properties and methods are safe to access from any thread at any time. All blocks
 will cause the queue to wait, making it safe to access and manipulate the actual cache files on disk for the
 duration of the block. In addition, the <sharedQueue> can be set to target an existing serial I/O queue, should
 your app already have one.
 
 Because this cache is bound by disk I/O it can be much slower than <TMMemoryCache>, although values stored in
 `TMDiskCache` persist after application relaunch. Using <TMCache> is recommended over using `TMDiskCache`
 by itself, as it adds a fast layer of additional memory caching while still writing to disk.

 All access to the cache is dated so the that the least-used objects can be trimmed first. Setting an optional
 <ageLimit> will trigger a GCD timer to periodically to trim the cache to that age.
 */

@class TMDiskCache;

typedef void (^TMDiskCacheBlock)(TMDiskCache *cache);
typedef void (^TMDiskCacheObjectBlock)(TMDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL);

@interface TMDiskCache : NSObject

#pragma mark -
/// @name Core

/**
 The name of this cache, used to create a directory under Library/Caches and also appearing in stack traces.
 */
@property (readonly) NSString *name;

/**
 The URL of the directory used by this cache, usually `Library/Caches/com.tumblr.TMDiskCache/name` on iOS.
 
 @warning Do not interact with files under this URL except on the <sharedQueue>.
 */
@property (readonly) NSURL *cacheURL;

/**
 The total number of bytes used on disk, as reported by `NSURLTotalFileAllocatedSizeKey`.
 */
@property (readonly) NSUInteger byteCount;

/**
 The maximum number of bytes allowed on disk. This value is checked every time an object is set, if the written
 size exceeds the limit a trim call is queued. Defaults to `0.0`, meaning no practical limit.
 */
@property (assign) NSUInteger byteLimit;

/**
 The maximum number of seconds an object is allowed to exist in the cache. Setting this to a value
 greater than `0.0` will start a recurring GCD timer with the same period that calls <trimToDate:>.
 Setting it back to `0.0` will stop the timer. Defaults to `0.0`.
 */
@property (assign) NSTimeInterval ageLimit;

/**
 A block to be executed just before an object is added to the cache. The queue waits during execution.
 */
@property (copy) TMDiskCacheObjectBlock willAddObjectBlock;

/**
 A block to be executed just before an object is removed from the cache. The queue waits during execution.
 */
@property (copy) TMDiskCacheObjectBlock willRemoveObjectBlock;

/**
 A block to be executed just after an object is added to the cache. The queue waits during execution.
 */
@property (copy) TMDiskCacheObjectBlock didAddObjectBlock;

/**
 A block to be executed just after an object is removed from the cache. The queue waits during execution.
 */
@property (copy) TMDiskCacheObjectBlock didRemoveObjectBlock;

#pragma mark -
/// @name Initialization

/**
 A shared cache.
 
 @result The shared singleton cache instance.
 */
+ (instancetype)sharedCache;

/**
 A shared serial queue, used by all instances of this class. Use `dispatch_set_target_queue` to integrate
 this queue with an exisiting serial I/O queue.
 
 @result The shared singleton queue instance.
 */
+ (dispatch_queue_t)sharedQueue;

/**
 The designated initializer. Multiple instances with the same name are allowed and can safely access
 the same data on disk thanks to the magic of seriality.
 
 @see name
 @param name The name of the cache.
 @result A new cache with the specified name.
 */
- (instancetype)initWithName:(NSString *)name;

#pragma mark -
/// @name Asynchronous Methods

/**
 Retrieves the object for the specified key. This method returns immediately and executes the passed
 block as soon as the object is available on the serial <sharedQueue>.
 
 @warning The fileURL is only valid for the duration of this block, do not use it after the block ends.
 
 @param key The key associated with the requested object.
 @param block A block to be executed serially when the object is available.
 */
- (void)objectForKey:(NSString *)key block:(TMDiskCacheObjectBlock)block;

/**
 Retrieves the fileURL for the specified key without actually reading the data from disk. This method
 returns immediately and executes the passed block as soon as the object is available on the serial
 <sharedQueue>.
 
 @warning Access is protected for the duration of the block, but to maintain safe disk access do not
 access this fileURL after the block has ended. Do all work on the <sharedQueue>.
 
 @param key The key associated with the requested object.
 @param block A block to be executed serially when the file URL is available.
 */
- (void)fileURLForKey:(NSString *)key block:(TMDiskCacheObjectBlock)block;

/**
 Stores an object in the cache for the specified key. This method returns immediately and executes the
 passed block as soon as the object has been stored.
 
 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param block A block to be executed serially after the object has been stored, or nil.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(TMDiskCacheObjectBlock)block;

/**
 Removes the object for the specified key. This method returns immediately and executes the passed block
 as soon as the object has been removed.
 
 @param key The key associated with the object to be removed.
 @param block A block to be executed serially after the object has been removed, or nil.
 */
- (void)removeObjectForKey:(NSString *)key block:(TMDiskCacheObjectBlock)block;

/**
 Removes objects from the cache, ordered by size, until the cache is equal to or smaller than the
 specified byteCount. This method returns immediately and executes the passed block as soon as the cache
 has been trimmed.
 
 @param byteCount The cache will be trimmed equal to or smaller than this size.
 @param block A block to be executed serially after the cache has been trimmed, or nil.
 */
- (void)trimToSize:(NSUInteger)byteCount block:(TMDiskCacheBlock)block;

/**
 Removes all objects from the cache older than the specified date, as ordered by access time. This method
 returns immediately and executes the passed block as soon as the cache has been trimmed.
 
 @param date Objects that haven't been accessed since this date are removed from the cache.
 @param block A block to be executed serially after the cache has been trimmed, or nil.
 */
- (void)trimToDate:(NSDate *)date block:(TMDiskCacheBlock)block;

/**
 Removes all objects from the cache without calling the associated event blocks.  This method returns
 immediately and executes the passed block as soon as the cache has been cleared.
 
 @param block A block to be executed serially after the cache has been cleared, or nil.
 */
- (void)removeAllObjects:(TMDiskCacheBlock)block;

#pragma mark -
/// @name Synchronous Methods

/**
 Retrieves the object for the specified key. This method blocks the calling thread until the
 object is available.
 
 @see objectForKey:block:
 @param key The key associated with the object.
 @result The object for the specified key.
 */
- (id <NSCoding>)objectForKey:(NSString *)key;

/**
 Retrieves the file URL for the specified key. This method blocks the calling thread until the
 url is available. Do not use this URL anywhere but on the <sharedQueue>. This method probably
 shouldn't even exist, just use the asynchronous one.
 
 @see fileURLForKey:block:
 @param key The key associated with the object.
 @result The file URL for the specified key.
 */
- (NSURL *)fileURLForKey:(NSString *)key;

/**
 Stores an object in the cache for the specified key. This method blocks the calling thread until
 the object has been stored.
 
 @see setObject:forKey:block:
 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

/**
 Removes the object for the specified key. This method blocks the calling thread until the object
 has been removed.
 
 @param key The key associated with the object to be removed.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes objects from the cache, ordered by access time, until the cache is equal to or smaller than the
 specified byteCount. This method blocks the calling thread until the cache has been trimmed.
 
 @param byteCount The cache will be trimmed equal to or smaller than this size.
 */
- (void)trimToSize:(NSUInteger)byteCount;

/**
 Removes all objects from the cache older than the specified date, as ordered by access time. This
 method blocks the calling thread until the cache has been trimmed.
 
 @param date Objects that haven't been accessed since this date are removed from the cache.
 */
- (void)trimToDate:(NSDate *)date;

/**
 Removes all objects from the cache without calling the associated event blocks. This method blocks
 the calling thread until the cache has been cleared.
 */
- (void)removeAllObjects;

@end
