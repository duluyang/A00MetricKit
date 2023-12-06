# 当前时间
cdate=$(date "+%Y%m%d%H%M%S")

# 测试手机的 udid
# udid="00008101-001645DA2690001E"
# udid="00008110-001A31C6362A801E"
udid="00008020-000A2C1A0282002E"

# 京喜特价的包名
bundleid="com.jd.jdmobilelite.dev"
# 京东的包名
# bundleid="com.360buy.jdmobile"

# xctrace 的 templates
# template="Time Profiler"
template="App Launch"
template_name=$(echo "$template" | tr -d ' ')

# 当前生成的数据目录
cpath="xctrace/${bundleid}/${cdate}"
# 通过 xctrace 跑出来的性能数据
trace_output="${cpath}/${template_name}.trace"
# xctrace 数据导出为 xml 格式（全数据）
xml_files="${cpath}/${template_name}.xml"
# xctrace 数据导出为 xml 格式（某一个指标的数据）
xml_file="${cpath}/life-cycle-period.xml"
# xml 文件生成最终的启动性能数据
json_file="${cpath}/life-cycle-period.json"

xctraceTest() {
	mkdir -p $cpath

	xcrun xctrace record \
	--template "${template}" \
	--device ${udid} \
	--output ${trace_output}\
	--launch ${bundleid}
}

analysisXctrace() {
	schema=''
	if [[ $template == "App Launch" ]]; then
		schema='life-cycle-period'
	elif [[ $template == "Time Profiler" ]]; then
		schema="core-animation-fps-estimate"
	fi
	echo $schema

	xcrun xctrace export \
	--input ${trace_output} \
	--toc \
	--output ${xml_files}

	xcrun xctrace export \
	--input ${trace_output} \
	--xpath "/trace-toc/run[@number='1']/data/table[@schema='${schema}']" \
	>> ${xml_file}
}

analysisXmlData() {
	# 开始 JSON 数组
	echo "[" > $json_file

	# 获取 row 的数量
	row_count=$(xmllint --xpath "count(//node/row)" $xml_file)

	# 迭代每个 row
	for i in $(seq 1 $row_count)
	do
		# 提取每个 <row> 中的 start-time 的 fmt 数据
	    start_time_fmt=$(xmllint --xpath "string(//node/row[$i]/start-time/@fmt)" $xml_file)
	    # 提取每个 <row> 中的 app-period 的 fmt 数据
	    app_period_fmt=$(xmllint --xpath "string(//node/row[$i]/app-period/@fmt)" $xml_file)
	    # 提取每个 <row> 中的 duration 的 fmt 数据
	    duration_fmt=$(xmllint --xpath "string(//node/row[$i]/duration/@fmt)" $xml_file)
	    
	    # 打印结果
	    echo "start-time fmt: $start_time_fmt"
	    echo "app-period fmt: $app_period_fmt"
	    echo "duration fmt: $duration_fmt"
	    echo ""

	    # 构建 JSON 对象
	    json_object="\t{\"start-time\": \"$start_time_fmt\", \"app-period\": \"$app_period_fmt\", \"duration\": \"$duration_fmt\"}"
	    
	    # 如果不是最后一个元素，添加逗号
   		if [ $i -lt $row_count ]; then
   		    json_object="$json_object,"
   		fi
   		
   		# 将 JSON 对象追加到文件
    	echo $json_object >> $json_file
	done

	# 结束 JSON 数组
	echo "]" >> $json_file
}

xctraceTest
if [ $? -eq 0 ]; then
	analysisXctrace
	if [ $? -eq 0 ]; then
		analysisXmlData
	fi
else
	echo "xcrun xctrace 失败"
fi






#  ✗ xctrace list templates
# == Standard Templates ==
# Activity Monitor
# Allocations
# Animation Hitches
# App Launch
# CPU Counters
# CPU Profiler
# Core Data
# Core ML
# File Activity
# Game Memory
# Game Performance
# Leaks
# Logging
# Metal System Trace
# Network
# SceneKit
# Swift Concurrency
# SwiftUI
# System Trace
# Tailspin
# Time Profiler
# Zombies



# 当你在 shell 脚本中使用包含空格的变量时，你需要用双引号将变量引用起来。
# 这样做可以确保变量的整个值被当作一个单一的参数传递给命令，而不是被拆分成多个参数。
# template="App Launch"
# xctrace record --template "$template"


