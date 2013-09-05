<!DOCTYPE HTML>
<html>
	<head>
	<link href="CSS/basestyle.css" rel="stylesheet" type="text/css" media="screen" />
<?php         
//利用PHP读取统计结果的XML文件              
			  $doc = new DOMDocument();
              $doc->load( 'F:/Jetsen_AutoTest_project/SmartJetsen/Statistics/Statistics.xml' );
              $Statistics = $doc->getElementsByTagName( "Statistics" );
            foreach( $Statistics as $Statistics )
              {
              $Start = $Statistics->getElementsByTagName( "Start" );
              $Start = $Start->item(0)->nodeValue;
 
              $Pass = $Statistics->getElementsByTagName( "Pass" );
              $Pass = $Pass->item(0)->nodeValue;
 
              $Fail = $Statistics->getElementsByTagName( "Fail" );
              $Fail = $Fail->item(0)->nodeValue;
 
              $Finish = $Statistics->getElementsByTagName( "Finish" );
              $Finish = $Finish->item(0)->nodeValue;
 
              $Error = $Statistics->getElementsByTagName( "Error" );
              $Error = $Error->item(0)->nodeValue;
			  
			  $Manual = $Statistics->getElementsByTagName( "Manual" );
              $Manual = $Manual->item(0)->nodeValue; 
              } 
?>	
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>自动化测试结果统计</title>
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
		<script type="text/javascript">
$(function () {
        $('#container').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'SmartJetsen自动化测试结果统计'
            },
			subtitle: {
                text: 'We make test more smart!'
            },
            tooltip: {
        	    pointFormat: '{series.name}: <b>{point.percentage}%</b>',
            	percentageDecimals: 1
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'SmartJetsen自动化测试结果统计饼图',
<!--注意PHP的变量可以用这种方式传给JS-->                
				data: [
                    ['总测试点数目：',<?=$Start?>],
                    ['通过的测试点数目：',<?=$Pass?>],
                    ['失败的测试点数目：',<?=$Fail?>],
					['手工确认的测试点数',<?=$Manual?>],
                    ['完成的测试点数目：',<?=$Finish?>],
                    ['异常的测试点数目：',<?=$Error?>],
                ]
            }]
        });
    });
		</script>
	</head>
	<body>
    <script src="./Jsfiles/highcharts.js"></script>
    <script src="./Jsfiles/exporting.js"></script>

    <div id="container" style="min-width: 600px; height: 600px; margin: 0 auto"></div>

	</body>
</html>
