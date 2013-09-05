#########################Jetsen自动化测试自定义类，version 1.0.1########################################
###########屏幕视频录像公共方法（试用于播放器基本功能测试的部分）############

#coding: UTF-8
require 'watir'
require 'win32ole'

#关闭CamRecorder的进程
def closeRecorder
 mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
 processes=mgmt.instancesof("win32_process")
 processes.each do |process|
   #puts process
   if process.name =="Recorder.exe"
     then process.terminate()
   end
 end
end

class ScreenRecord
  def initialize
    @at = at = WIN32OLE.new('AutoItX3.Control')
  end
  def screenrecord_ini  #初始化
#初始化的作用是重新配置一次 CamStudio
  @at.WinWait("CamStudio")
  @at.MouseClick('left',349,441)
  @at.Send("!r") #设置录制区域
  @at.Send("{UP}")
  @at.Send("{ENTER}")
  
  @at.Send("!o") #设置option
  @at.Send("{ENTER}")#设置视频质量
  @at.MouseClickDrag("left",336,275,388,275) 
  @at.MouseClick('left',307,577)#设置视频质量为最佳
  
  @at.Send("!r") #设置用户自定义相关
  @at.Send("{UP}")
  @at.Send("{UP}")
  @at.Send("{UP}")
#############未完成#################    
  end
  def screenrecord_down
    closeRecorder
    sleep 3
  end
  def screenrecord_run   #启动CamStudio工具
  @at.Run('Recorder.exe')
#等待CamStudio启动
   sleep 6
  end
  def screenrecord_start
#默认配置为全屏录像    
   @at.WinWait("CamStudio")
#使用设置好的快捷键F8开启录像功能
   @at.Send("{F8}")
   end
  def screenrecord_stop(aviname)
#包含保存的相关操作 
   @AVINAME = aviname
   @AVIPATH = 'F:\\Jetsen_AutoTest_project\\SmartJetsen\\WebAPP\\TestVideo\\'
   @AVI = @AVIPATH + @AVINAME   
#使用设置好的快捷键F9关闭录像功能
   @at.Send("{F9}")
   @at.WinWaitActive("CamStudio")
   @at.WinWait("Save AVI File")
#设置AVI的保存路径和保存名   
   @at.Send('{BS}')
   @at.Send(@AVI)
   @at.Send("{ENTER}")
   @at.MouseClick('left',1377,802)  #隐藏Recorder程序
   sleep 10 #给工具10秒钟时间来做处理         
  end      
end