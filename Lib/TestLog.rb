#encoding: utf-8
require 'win32ole'

class Log
    def initialize
     @descriptions=descriptions=''     
     @SPACE="      "       
    end

  def logfile_start
    @time1 = Time.now.to_s
    @LOGPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestLog\\'   #日志保存路径  
    @LOGFILENAME = 'TestResult.log' #log文件名
    f=File.new(File.join(@LOGPATH,@LOGFILENAME), "a+")   
    f.puts("时间：" + @time1 + @SPACE + "测试项：" + @descriptions + @SPACE + "开始！$") #符号“$”为一个统计标识，用于后续的统计计算测试结果
  end
  
  def logfile_pass
    @time2 = Time.now.to_s
    @LOGPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestLog\\'   #日志保存路径  
    @LOGFILENAME = 'TestResult.log' #log文件名
    f=File.new(File.join(@LOGPATH,@LOGFILENAME), "a+")
    f.puts("时间：" + @time2 + @SPACE + "测试项：" + @descriptions + @SPACE + "通过！#") #符号“#”为一个统计标识，用于后续的统计计算测试结果
  end

  def logfile_fail
    @time3 = Time.now.to_s
    @LOGPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestLog\\'   #日志保存路径  
    @LOGFILENAME = 'TestResult.log' #log文件名
    f=File.new(File.join(@LOGPATH,@LOGFILENAME), "a+")
    f.puts("时间：" + @time3 + @SPACE + "测试项：" + @descriptions + @SPACE + "失败！*") #符号“*”为一个统计标识，用于后续的统计计算测试结果
  end
  def logfile_manual
    @time4 = Time.now.to_s
    @LOGPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestLog\\'   #日志保存路径  
    @LOGFILENAME = 'TestResult.log' #log文件名
    f=File.new(File.join(@LOGPATH,@LOGFILENAME), "a+")
    f.puts("时间：" + @time4 + @SPACE + "测试项：" + @descriptions + @SPACE + "需要人工再次确认！%") #符号“%”为一个统计标识，用于后续的统计计算测试结果
  end
  def logfile_finish
    @time5 = Time.now.to_s
    @LOGPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestLog\\'   #日志保存路径  
    @LOGFILENAME = 'TestResult.log' #log文件名
    f=File.new(File.join(@LOGPATH,@LOGFILENAME), "a+")
    f.puts("时间：" + @time5 + @SPACE + "测试项：" + @descriptions + @SPACE + "完成！&") #符号“&”为一个统计标识，用于后续的统计计算测试结果
  end
      
#利用attr_writer来允许用户在使用此类时对变量:descriptions做修改  
  attr_writer :descriptions
end