#encoding: utf-8
require 'watir'
require 'win32ole'
require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/MainExtra.rb'
$extra = MainExtra.new
class Ini
  def initialize()
#调用关闭所有IE窗口的方法
    $extra.close_all_IE(1,6)#此处以最多已经打开了5个IE为例
    $ie = Watir::IE.new
    $ie.maximize
    $at = WIN32OLE.new('AutoItX3.Control') 
  end #end def
end #end class