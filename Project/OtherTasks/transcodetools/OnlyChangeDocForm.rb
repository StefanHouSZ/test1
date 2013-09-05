#encoding: utf-8

########################################################################################################
#################1：模板说明：复制model.rb，修改rb文件名称，要求修改的名称代表此模板生成的格式##############                       
#################2：按注释要求修改参数值#################################################################
#######################################################################################################

require 'win32ole'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\OtherTasks\transcodetools\extraclass.rb'


  @at = WIN32OLE.new('AutoItX3.Control')
  @extra = Extra.new  

  def createmodel
########################################需要修改：参数的定义##############################################

#循环读取的下拉菜单的配置文件的路径，例：想读取文件格式.txt时，可修改@TxtFilePath的值，  @TxtFilePath = 'F:/Jetsen_AutoTest_project/SmartJetsen/Project/OtherTasks/transcodetools/文件格式.txt'
  @TxtFilePath = 'F:/Jetsen_AutoTest_project/SmartJetsen/Project/OtherTasks/transcodetools/文件格式.txt'
  @data = IO.readlines(@TxtFilePath)
  @linenums = @data.size
  puts "文件共有#{@linenums}行"
#下拉菜单的选择，例：文件格式想选择成AVI+立体声WAV时，可修改@option1的值，   @option1 = 'AVI+立体声WAV'，当某个下拉菜单需要
#从TXT文件中读取数据时，可修改为，如@option3 = @data
  @option1 = ""
  @option2 = "自动匹配压缩格式"
  @option3 = "Apple YUV 8bit Encoder"
  @option4 = "Apple YUV 8bit"
  @option5 = "WindowsPCMEncoder"
  @option6 = "WindowsPCM16bit"

#模板的文件名（格式为:文件名前缀+序号），建议前缀的命名规则为这种形式
#DocPara(Pre:Auto)VideoPara(VideoForm:Apple_YUV_8bit_Encoder;Pre:Apple_YUV_8bit)VoicePara(VoiceForm:Windows PCM Encoder;Pre:Windows PCM 16 bit)
  @NUM = 1
  @FileNamePre = 'VideoForm_1VideoPre_1VoiceForm_1VoicePre_1'
  @FileName = @FileNamePre + @NUM.to_s
  @lines = 0
  
    #开始循环
####################需要修改循环次数，根据txt文件中的内容的行数而定################################    
    while @lines < @linenums
     puts @data[@lines]
     @configdata = @data[@lines]
     #选择标/高清
     @extra.selectSD
     #配置  文件参数-->文件格式
     @extra.section1(@configdata)
     #配置  文件参数-->预置
     @extra.section2(@option2)
     #配置  视频参数-->视频格式
     @extra.section3(@option3)
     #配置  视频参数-->预置
     @extra.section4(@option4)
     #配置  音频参数-->音频格式
     @extra.section5(@option5)
     #配置  音频参数-->预置
     @extra.section6(@option6)
     #点击确定增加参数
     @extra.addarrg
     #保存模板
     @extra.save(@FileName)   
    @lines+=1 
    @NUM+=1
    end  #end loop
  end #end func  
#########################################开始创建模板########################################
createmodel