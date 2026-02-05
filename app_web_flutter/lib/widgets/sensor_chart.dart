import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../models/data_point.dart';

class SensorChart extends StatefulWidget {
  final String title;
  final List<DataPoint> slave1Data;
  final List<DataPoint> slave2Data;
  final Color slave1Color;
  final Color slave2Color;

  const SensorChart({
    Key? key,
    required this.title,
    required this.slave1Data,
    required this.slave2Data,
    required this.slave1Color,
    required this.slave2Color,
  }) : super(key: key);

  @override
  State<SensorChart> createState() => _SensorChartState();
}

class _SensorChartState extends State<SensorChart> {
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      shouldAlwaysShow: true,
    );

    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      enableDoubleTapZooming: true,
      enableMouseWheelZooming: true,
      zoomMode: ZoomMode.x,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        title: ChartTitle(text: widget.title),
        legend: const Legend(isVisible: true),
        tooltipBehavior: _tooltipBehavior,
        zoomPanBehavior: _zoomPanBehavior,
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat.Hms(),
          intervalType: DateTimeIntervalType.minutes,
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: <CartesianSeries<DataPoint, DateTime>>[
          LineSeries<DataPoint, DateTime>(
            name: 'Slave 1',
            dataSource: widget.slave1Data,
            xValueMapper: (DataPoint point, _) => point.time,
            yValueMapper: (DataPoint point, _) => point.value,
            color: widget.slave1Color,
            markerSettings: const MarkerSettings(isVisible: true),
            enableTooltip: true,
          ),
          LineSeries<DataPoint, DateTime>(
            name: 'Slave 2',
            dataSource: widget.slave2Data,
            xValueMapper: (DataPoint point, _) => point.time,
            yValueMapper: (DataPoint point, _) => point.value,
            color: widget.slave2Color,
            markerSettings: const MarkerSettings(isVisible: true),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }
}
