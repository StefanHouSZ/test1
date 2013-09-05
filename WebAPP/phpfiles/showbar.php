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
                type: 'bar'
            },
            title: {
                text: 'SmartJetsen自动化测试结果统计'
            },
            subtitle: {
                text: 'We make test more smart!'
            },
            xAxis: {
                categories: ['总测试点数目', '通过的测试点数目', '失败的测试点数目','手工确认的测试点数', '完成的测试点数目', '异常的测试点数目'],
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: '测试点个数(单位：个)',
                    align: 'high'
                },
                labels: {
                    overflow: 'justify'
                }
            },
            tooltip: {
                valueSuffix: ' 个'
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: false
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -30,
                y: 1,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: [{
                name: '总测试点数目',
                data: [<?=$Start?>,0,0,0,0,0]
            }, {
                name: '通过的测试点数目',
                data: [0,<?=$Pass?>,0,0,0,0]
            }, {
                name: '失败的测试点数目',
                data: [0,0,<?=$Fail?>,0,0,0]
            },{
                name: '手工确认的测试点数',
                data: [0,0,0,<?=$Manual?>,0,0]
            },{
                name: '完成的测试点数目',
                data: [0,0,0,0,<?=$Finish?>,0]
            },{
                name: '异常的测试点数目',
                data: [0,0,0,0,0,<?=$Error?>]
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
