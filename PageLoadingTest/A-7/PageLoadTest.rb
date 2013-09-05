#coding: UTF-8

require 'win32ole'  
require 'watir'
require './location.rb'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Lib\MainExtra.rb'

#实例化httpwatch控制器
@httpwatchcontrol = WIN32OLE.new('HttpWatch.Controller')
#实例化MainExtra下的方法
@extra = MainExtra.new
@tested_url = 'http://192.168.8.27:8081/js46/juum/jnetsystemweb/login.htm' #被测系统url
@DATAPATH = 'F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/PerformanceData/'   #反馈结果文件的存放路径，保存在同此rb文件为同一级目录下
@DATAFILENAME = 'PerformanceData.txt' #数据反馈文件名
@BLANK = '====================================================================='
@BEGIN = '<<<<<<<<<============================================================>>>>>>>>>'
@links = '8'
@PageName = 'A-7媒体内容管理-->音频工作夹'

#关闭所有已经开启的IE
@extra.close_all_IE(1,5)
#登录测试系统
@ie = Watir::IE.new
@ie.maximize
#是否可视化测试过程--->否
#@ie.visible='false'
#将HttpWatch定位到@ie上
@plugin = @httpwatchcontrol.ie.Attach(@ie.ie)
# 开始记录HTTP流量，单位B
@plugin.Clear()
#取消HttpWatch日志过滤
@plugin.Log.EnableFilter(false)
#开始监控HTTP   
@plugin.Record()


#获取IE浏览器信息
@full_ver =@ie.document.invoke('parentWindow').navigator.appVersion
tmp_str =/MSIE\s(.*?);/.match(@full_ver)
@ie_ver = tmp_str[1]

#获取HttpWatch版本信息
@httpWatchVer = @httpwatchcontrol.Version

#控制台显示IE版本号,HttpWatch版本号，及写入测试数据反馈信息
f=File.new(File.join(@DATAPATH,@DATAFILENAME), "a+")
f.puts(@BEGIN)  
f.puts("被测区域为：" + @PageName)
f.puts("被测区域的链接数为：" + @links)   
f.puts("HttpWatch版本号为：" + @httpWatchVer)
f.puts("测试用IE版本为：" + @ie_ver)
f.puts(@BLANK)

#完成登录系统动作
@ie.goto(@tested_url)
@ie.text_field(:id,'txtUserName').clear
@ie.text_field(:id,'txtUserName').set('hjg')
@ie.text_field(:id, 'txtPassword').set('1')
@ie.link(:class,'login-button').click
#########################开始对A-1-1：媒体内容管理-->网管系统所有相关页面进行性能测试，gotoA_1(pagename)说明
#####pagename为在反馈日志中的测试区域信息
gotoA_7

#停止HttpWatch的监测功能
@plugin.Stop()
sleep 2
#监控结果汇总   
@summary = @plugin.Log.Entries.Summary
#页面加载时间，因为包含了程序链接
#统计监控结果
   f.puts("加载测试页面的总时间(secs)：" + @summary.Time.to_s)
   f.puts("接收到的所有HTTP包体数据大小(bytes):" + @summary.BytesReceived.to_s)
   f.puts("HTTP压缩包大小(bytes):" + @summary.CompressionSavedBytes.to_s)
   f.puts("数据交换次数:" + @summary.RoundTrips.to_s)
   f.puts("错误数:" + @summary.Errors.Count.to_s)
#打印错误信息
  
errorUrls = Hash.new
@plugin.Log.Entries.each do |entry|
  if  !entry.Error.empty? && entry.Error != "Aborted" || entry.StatusCode >= 400
    if !errorUrls.has_key?(entry.Result )
      errorUrls[entry.Result] =  Array.new( 1, entry.Url  ) 
    else
      if errorUrls[entry.Result].find{ |aUrl| aUrl == entry.Url } == nil 
        errorUrls[entry.Result].push( entry.Url  )
      end       
    end
  end
end

  @summary.Errors.each do |error|
  numErrors = error.Occurrences
  description = error.Description
  f.puts(@BLANK)
  f.puts "#{numErrors} URL(s) 造成了 #{description}的错误："
  errorUrls[error.Result].each do |aUrl|
  f.puts "ErrorLinks-> #{aUrl}"
  end   
 end
 @ie.close 