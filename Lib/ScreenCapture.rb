#########################Jetsen自动化测试自定义类，version 1.0.1########################################
###########屏幕抓图公共方法############

#coding: UTF-8
require 'win32ole'

class ScreenCapture
  def initialize()
    @at = at = WIN32OLE.new('AutoItX3.Control')   
  end
  def screencapture_run
    #启动红蜻蜓抓图工具
   @at.Run('RdfSnap.exe')
#等待红蜻蜓软件启动
   sleep 2
#初始化红蜻蜓抓图软件配置，设置为对“整个窗口”抓图
   @at.WinWait("红蜻蜓抓图精灵2013")
   @at.MouseClick("left",545,362)
#最小化红蜻蜓抓图软件
   @at.MouseClick("left",860,304)    
  end #end def
  def screencapture_down
   mgmt = WIN32OLE.connect('winmgmts:\\\\.') 
   processes=mgmt.instancesof("win32_process")
   processes.each do |process|
   #puts process
     if process.name =="RdfSnap.exe"
       then process.terminate()
     end #end if
   end #end each
  end #end def
  def ScreenGot(picname,x1=128,y1=796,x2=128,y2=796)
    @PICNAME = picname
    @X1 = x1 
    @X2 = x2 
    @Y1 = y1 
    @Y2 = y2 
#使用设置好的快捷键ctrl+alt+c开启抓图功能
    @at.Send("^!c")
    sleep 2
#点击矩形工具，高亮需要  
    @at.MouseClick('left',26,325)
#选择矩形区域   
    @at.MouseClickDrag("left",@X1,@Y1,@X2,@Y2)
#   @at.MouseMove(21,755)
#上一步的原因是如果不把鼠标重新定位一下的话，autoIT无法捕捉到红蜻蜓APP的窗口，进而无法完成ENTER键的模拟   
    @at.Send('{ENTER}')
#保存图像重命名
    @at.WinWaitActive("保存图像")
#清空原有保存默认名
    @at.Send('{BS}')
    @at.Send(@PICNAME)
    @at.Send('{ENTER}')
  end
end