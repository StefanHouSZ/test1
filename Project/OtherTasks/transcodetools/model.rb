#encoding: utf-8

########################################################################################################
#################1：模板说明：复制model.rb，修改rb文件名称，要求修改的名称代表此模板生成的格式##############                       
#################2：按注释要求修改参数值#################################################################
#######################################################################################################

require 'win32ole'
require 'F:\Jetsen_AutoTest_project\SmartJetsen\Project\OtherTasks\transcodetools\extraclass.rb'

class CreateModel
  def initialize
  @at = WIN32OLE.new('AutoItX3.Control')
  @extra = Extra.new  
  end
########################################需要修改：参数的定义##############################################

#循环读取的下拉菜单的配置文件的路径，例：想读取文件格式.txt时，可修改@TxtFilePath的值，  @TxtFilePath = 'F:/Jetsen_AutoTest_project/SmartJetsen/Project/OtherTasks/transcodetools/文件格式.txt'
@TxtFilePath = ''
@data = IO.readlines(@TxtFilePath)

#下拉菜单的选择，例：文件格式想选择成AVI+立体声WAV时，可修改@option1的值，   @option1 = 'AVI+立体声WAV'，当某个下拉菜单需要
#从TXT文件中读取数据时，可修改为，如@option3 = @data
@option1 = ''
@option2 = ''
@option3 = ''
@option4 = ''
@option5 = ''
@option6 = ''

#保存模板的文件夹名（仅支持英文） ，例：想保存模板到 ChangeDocumentForm文件夹下时，可修改@FolderName的值， @FolderName= 'ChangeDocumentForm'
@FolderName = '' 
#模板的文件名（格式为:文件名前缀+序号），例：如想保存文件名为ChangeDocumentForm1.vxfmt时，只修改@FileNamePre的值， @FileNamePre = 'ChangeDocumentForm' 
@NUM = '1'
@FileNamePre = ''
@FileName = @FileNamePre + @NUM.to_s

  def createmodel
    @lines = 0
    #开始循环
####################需要修改循环次数，根据txt文件中的内容的行数而定################################    
    while @lines < 10
     puts @data[@lines]
     #选择标/高清
     @extra.selectSD
     #配置  文件参数-->文件格式
     @extra.section1(@option1)
     #配置  文件参数-->预置
     @extra.section2(@option2)
     #配置  视频参数-->视频格式
     @extra.section3(@option3)
     #配置  视频参数-->预置
     @extra.section4(@option4)
     #配置  音频参数-->音频格式
     @extra.section6(@option6)
     #点击确定增加参数
     @extra.addarrg
     #保存模板
     @extra.save(@FileName)   
    end  #end loop
  end #end func
end  #end class

run = CreateModel.new
run.createmodel