#encoding: utf-8
require 'win32ole'
class Extra
  def initialize
  @at = WIN32OLE.new('AutoItX3.Control')
  #下拉菜单的选择，例：文件格式想选择成AVI+立体声WAV时，可修改@option1的值，   @option1 = 'AVI+立体声WAV'，当某个下拉菜单需要
  #从TXT文件中读取数据时，可修改为，如@option3 = @data
  @option1 = ''
  @option2 = '自动匹配压缩格式'
  @option3 = 'Apple YUV 8bit Encoder'
  @option4 = 'Apple YUV 8bit'
  @option5 = 'WindowsPCMEncoder'
  @option6 = 'WindowsPCM16bit' 
  end
#标清  
  def addarrg   #确定增加参数
    @at.WinWaitActive('参数设置')
    @at.MouseClick('left',639,596)
#   点击确定
    @at.MouseClick('left',642,773) 
  end
  def save(modelname)
    @modelname = modelname    
    @at.WinWait('保存模板')        
#命名模板文件保存名
    @at.Send('^a')
    @at.Send('{BS}')
    @at.Send(@modelname)
    @at.Send('{ENTER}')
    @at.Send('{ESC}')
  end
  def selectSD
    @at.WinWaitActive('手动转码工具')
    #点击“新建模板”  
    @at.MouseClick('left',982,318)
    #选择标清  
    @at.Send('{TAB}')
    @at.Send('{ENTER}')
  end
  def selectHD
    @at.WinWaitActive('手动转码工具')
    #点击“新建模板”  
    @at.MouseClick('left',982,318)
    #选择高清
    @at.MouseClick('left',720,400)
    @at.Send('{DOWN}')
    @at.Send('{ENTER}')
    @at.Send('{TAB}')
    @at.Send('{ENTER}')
  end
#定义  文件参数-->文件格式下拉菜单的选项  
  def section1(arrgument1)
    @argg1 = arrgument1
    @at.WinWait('参数设置')
    @at.MouseClick('left',577,167)
    @at.Send(@argg1)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end
#定义  文件参数-->预置下拉菜单的选项
  def section2(arrgument2)
    @argg2 = arrgument2
    @at.WinWait('参数设置')
    @at.MouseClick('left',806,200)
    @at.Send(@argg2)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end
#定义  视频参数-->视频格式下拉菜单的选项
  def section3(arrgument3)
    @argg3 = arrgument3
    @at.WinWait('参数设置')
    @at.MouseClick('left',577,257)
    @at.Send(@argg3)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end 
#定义  视频参数-->预置下拉菜单的选项
  def section4(arrgument4)
    @argg4 = arrgument4
    @at.WinWait('参数设置')
    @at.MouseClick('left',806,290)
    @at.Send(@argg4)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end
#定义  音频参数-->音频格式 下拉菜单的选项
  def section5(arrgument5)
    @argg5 = arrgument5
    @at.WinWait('参数设置')
    @at.MouseClick('left',577,476)
    @at.Send(@argg5)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end
#定义  音频参数--> 预置下拉菜单的选项
  def section6(arrgument6)
    @argg6 = arrgument6
    @at.WinWait('参数设置')
    @at.MouseClick('left',806,509)
    @at.Send(@argg6)
    sleep 2  
    @at.Send('{ENTER}')
    sleep 2
  end      
end  #end class