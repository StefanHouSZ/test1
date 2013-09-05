require 'F:/Jetsen_AutoTest_project/SmartJetsen/Project/A-8_PictureFolder/PictureFolder-Web.rb';require 'F:/Jetsen_AutoTest_project/SmartJetsen/Lib/DebugLog.rb';$debug = DebugLog.new;begin;test = AutoTest.new;test.prepare;test.pt1;
test.pt2;
test.pt3;
test.pt4;
test.pt5;
					test.finish;rescue;$debug.writedebug('A-8');ensure;$ie.close;$extra.closeRecorder;end