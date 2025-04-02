import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityTaskSummary extends StatefulWidget {
  final int highValue;
  final int mediumValue;
  final int lowValue;

  const PriorityTaskSummary({
    Key? key,
    required this.highValue,
    required this.mediumValue,
    required this.lowValue,
  }) : super(key: key);

  @override
  _PriorityTaskSummaryState createState() => _PriorityTaskSummaryState();
}

class _PriorityTaskSummaryState extends State<PriorityTaskSummary> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    List<_ChartData> data = [
      _ChartData('High', widget.highValue, Colors.red),
      _ChartData('Medium', widget.mediumValue, Colors.orange),
      _ChartData('Low', widget.lowValue, Colors.green),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority Task Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            height: 230.h,
            child: SfCircularChart(
              tooltipBehavior: _tooltip,
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              borderWidth: 20.w,
              series: <CircularSeries<_ChartData, String>>[
                DoughnutSeries<_ChartData, String>(
                  dataSource: data,
                  xValueMapper: (_ChartData data, _) => data.x,
                  yValueMapper: (_ChartData data, _) => data.y,
                  pointColorMapper: (_ChartData data, _) => data.color,
                  dataLabelSettings: DataLabelSettings(
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    connectorLineSettings: ConnectorLineSettings(
                      type: ConnectorType.curve,
                    ),
                  ),
                  name: 'Task Priority',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}
