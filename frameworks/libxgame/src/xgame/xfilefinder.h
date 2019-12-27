#ifndef __XFILEFINDER_H__
#define __XFILEFINDER_H__

#include "xgame/xdef.h"
#include "xgame/AssetsBundle.h"

#include <unordered_map>

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "platform/apple/CCFileUtils-apple.h"
#define SuperFileUtils cocos2d::FileUtilsApple
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "platform/android/CCFileUtils-android.h"
#define SuperFileUtils cocos2d::FileUtilsAndroid
#elif CC_TARGET_PLATFORM == CC_PLATFORM_WIN32
#include "platform/win32/CCFileUtils-win32.h"
#define SuperFileUtils cocos2d::FileUtilsWin32
#endif

NS_XGAME_BEGIN

class FileFinder : public SuperFileUtils {
public:
    static FileFinder *create();
public:
    virtual ~FileFinder();
    virtual cocos2d::FileUtils::Status getContents(const std::string& filename, cocos2d::ResizableBuffer* buffer) const override;
    
    virtual void addCacheFileType(const std::string &type);
protected:
    FileFinder();
    virtual bool init() override;
    virtual std::string getFullPathForFilenameWithinDirectory(const std::string& directory, const std::string& filename) const override;
private:
    AssetsBundle _builtinAssets;
    std::unordered_map<std::string, bool> _cacheFileTypes;
};

NS_XGAME_END

#endif
