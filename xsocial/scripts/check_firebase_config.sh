#!/bin/bash
# Firebase Google Sign-In 配置检查脚本
# 用法: bash scripts/check_firebase_config.sh

echo "========================================="
echo " Firebase/Google Sign-In 配置检查"
echo "========================================="
echo ""

ERRORS=0

# 1. 检查 Android google-services.json
echo "--- [Android] google-services.json ---"
if [ -f android/app/google-services.json ]; then
    echo "  ✅ 文件存在"
    PACKAGE=$(python3 -c "import json; d=json.load(open('android/app/google-services.json')); print(d['client'][0]['client_info']['android_client_info']['package_name'])" 2>/dev/null)
    if [ -n "$PACKAGE" ]; then
        echo "     Package: $PACKAGE"
    fi
else
    echo "  ❌ 缺失! 请从 Firebase Console 下载 google-services.json 放到 android/app/"
    echo "     步骤: Firebase Console → 项目设置 → 添加 Android 应用 → 下载 google-services.json"
    ERRORS=$((ERRORS+1))
fi

echo ""

# 2. 检查 iOS GoogleService-Info.plist
echo "--- [iOS] GoogleService-Info.plist ---"
if [ -f ios/Runner/GoogleService-Info.plist ]; then
    echo "  ✅ 文件存在"
    python3 -c "
import plistlib, sys
p = plistlib.load(open('ios/Runner/GoogleService-Info.plist','rb'))
cid = p.get('CLIENT_ID', '')
rcid = p.get('REVERSED_CLIENT_ID', '')
if cid:
    print('  ✅ CLIENT_ID 存在:', cid[:50]+'...' if len(cid)>50 else cid)
else:
    print('  ❌ 缺少 CLIENT_ID! google_sign_in_ios 无法初始化')
    print('     请从 Firebase Console 重新下载 GoogleService-Info.plist')
    sys.exit(1)
if rcid:
    print('  ✅ REVERSED_CLIENT_ID 存在:', rcid[:50]+'...' if len(rcid)>50 else rcid)
else:
    print('  ❌ 缺少 REVERSED_CLIENT_ID!')
    sys.exit(1)
bid = p.get('BUNDLE_ID', '')
print('     BUNDLE_ID:', bid)
"
    if [ $? -ne 0 ]; then
        ERRORS=$((ERRORS+1))
    fi
else
    echo "  ❌ 缺失! 请从 Firebase Console 下载 GoogleService-Info.plist"
    ERRORS=$((ERRORS+1))
fi

echo ""

# 3. 检查 Android Gradle 插件
echo "--- [Android] Google Services Gradle 插件 ---"
grep -q "google-services" android/app/build.gradle.kts && echo "  ✅ app/build.gradle.kts 已配置 google-services 插件" || { echo "  ❌ 未配置!"; ERRORS=$((ERRORS+1)); }
grep -q "google-services" android/settings.gradle.kts && echo "  ✅ settings.gradle.kts 已声明 google-services 插件" || { echo "  ❌ 未声明!"; ERRORS=$((ERRORS+1)); }

echo ""

# 4. 检查 applicationId/bundle ID 一致性
echo "--- [检查 ID 一致性] ---"
ANDROID_ID=$(grep "applicationId" android/app/build.gradle.kts 2>/dev/null | grep -o '"[^"]*"' | tr -d '"')
IOS_BUNDLE=$(python3 -c "import plistlib; p=plistlib.load(open('ios/Runner/GoogleService-Info.plist','rb')); print(p.get('BUNDLE_ID',''))" 2>/dev/null)
IOS_PROJECT=$(grep "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null | grep -v "RunnerTests" | head -1 | grep -o '= .*;' | tr -d '=; ')
echo "  Android applicationId: $ANDROID_ID"
echo "  iOS   BUNDLE_ID(plist): $IOS_BUNDLE"
echo "  iOS   PRODUCT_BUNDLE_ID: $IOS_PROJECT"

echo ""
echo "========================================="
if [ $ERRORS -gt 0 ]; then
    echo "  ❌ 发现 $ERRORS 个问题需要修复"
else
    echo "  ✅ 所有配置检查通过!"
fi
echo "========================================="
