import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoneyChart extends StatefulWidget {
  const MoneyChart({super.key});

  @override
  State<MoneyChart> createState() => _MoneyChartState();
}

class _MoneyChartState extends State<MoneyChart> {
  LineChartData data = LineChartData();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setChartData();
  }

  void setChartData() {
    print("get");
    data = LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: const Color.fromARGB(255, 209, 209, 209),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: const Color.fromARGB(255, 209, 209, 209),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: bottomTitleWidgets),
          ),
          topTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
            showTitles: false,
          )),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black, width: 1),
        ),
        minX: 6,
        maxX: 12,
        minY: 0,
        maxY: 10000,
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: FlSpots,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.clamp,
              ),
            ),
          ),
        ]);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toDouble()) {
      case 0:
        text = Text('00.00', style: style);
        break;
      case 1:
        text = Text('01.00', style: style);
        break;
      case 2:
        text = Text('02.00', style: style);
        break;
      case 3:
        text = Text('03.00', style: style);
        break;
      case 4:
        text = Text('04.00', style: style);
        break;
      case 5:
        text = Text('05.00', style: style);
        break;
      case 6:
        text = Text('06.00', style: style);
        break;
      case 7:
        text = Text('07.00', style: style);
        break;
      case 8:
        text = Text('08.00', style: style);
        break;
      case 9:
        text = Text('09.00', style: style);
        break;
      case 10:
        text = Text('10.00', style: style);
        break;
      case 11:
        text = Text('11.00', style: style);
        break;
      case 12:
        text = Text('12.00', style: style);
        break;

      default:
        text = Text("", style: style);
        break;
    }
    return SideTitleWidget(meta: meta, child: text);
  }

  List<FlSpot> FlSpots = [
    FlSpot(6.00, 10000),
    FlSpot(07.00, 5000),
    FlSpot(08.00, 7000),
    FlSpot(09.00, 9000),
    FlSpot(10.00, 6000),
    FlSpot(11.00, 4000),
    FlSpot(12.00, 2000),
  ];

  List<Color> gradientColors = [
    const Color.fromARGB(255, 0, 127, 150),
    Colors.white
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 250,
      padding: EdgeInsets.only(
        top: 10,
        right: 10,
      ),
      child: LineChart(data),
    );
  }
}
