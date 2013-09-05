#encoding: utf-8
require 'win32ole'

class DebugLog
  def initialize
     @time = Time.now.to_s 
     @CASENUMBER = ''
     @BLANK = '======================================================================'
  end
  def writedebug(casenumber)
    @CASENUMBER = casenumber
  f=File.new(File.join("F:/Jetsen_AutoTest_project/SmartJetsen/WebAPP/Debug/","DebugLog.log"), "a+")   # 文件名和格式任意
  f.puts("ErrorTestSuite Is:" + @CASENUMBER)
  f.puts("Time Is:" + @time)
  f.puts("Error Reason:#{$!}")
  f.puts("Error Occured In:#{$@}")
  f.puts(@BLANK)
  end
end