cdate=$(date "+%Y%m%d%H%M%S")

# 测试手机的 udid
# udid="00008101-001645DA2690001E"
# udid="00008110-001A31C6362A801E"
udid="00008020-000A2C1A0282002E"

# 京喜特价的包名
#bundleid="com.jd.jdmobilelite"
# 京东的包名
bundleid="com.360buy.jdmobile"

# 当前生成的数据目录
cpath="xcresult/${bundleid}/${cdate}"
# xcodebuild test 生成的 xcresult 数据
resultBundlePath="${cpath}/${bundleid}_${cdate}.xcresult"

# 解析 xcresult 二进制文件后的数据
logpath="${cpath}/logs"

xcodebuildTest() {
	xcodebuild clean

	# xcodebuild 执行 xctest，统计启动数据
	xcodebuild test \
	-project A00MetricKit.xcodeproj \
	-scheme A00MetricKitUITests \
	-destination "platform=iOS,id=${udid}" \
	-resultBundlePath ${resultBundlePath} \
	BUNDLE_ID=${bundleid}
}

analysisXcresult() {
	# 从 xcresult 文件获取日志信息
	ruby ruby/unitTestLog.rb \
	--xcresult-path=${resultBundlePath} \
	--output-path=${logpath}
}


xcodebuildTest
if [ $? -eq 0 ]; then
	analysisXcresult
else
	echo "xcodebuild test 失败"
fi