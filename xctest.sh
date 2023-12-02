cdate=$(date "+%Y%m%d%H%M%S")
# 测试手机的 udid
udid="00008101-001645DA2690001E"
#udid="00008110-001A31C6362A801E"
# 京喜特价的包名
#bundleid="com.jd.jdmobilelite"
# 京东的包名
bundleid="com.360buy.jdmobile"

xcodebuild clean

xcodebuild test \
-project A00MetricKit.xcodeproj \
-scheme A00MetricKitUITests \
-destination "platform=iOS,id=${udid}" \
-resultBundlePath xcresult/${bundleid}_${cdate}.xcresult \
BUNDLE_ID=${bundleid} \
