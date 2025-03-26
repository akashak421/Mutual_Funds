import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:intl/intl.dart';
import '../models/mutual_fund.dart';
import 'dart:math';

class ChartsScreen extends StatefulWidget {
  final MutualFund fund;

  const ChartsScreen({Key? key, required this.fund}) : super(key: key);

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  String _selectedTimeframe = '1Y';
  double _investmentAmount = 1.0;
  bool _isSIP = false;
  final TextEditingController _investmentController = TextEditingController(text: '1.0');
  List<ChartData> _chartData = [];
  List<ChartData> _benchmarkData = [];

  @override
  void initState() {
    super.initState();
    _updateChartData();
  }

  void _updateChartData() {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (_selectedTimeframe) {
      case '1M':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case '3M':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case '6M':
        startDate = now.subtract(const Duration(days: 180));
        break;
      case '1Y':
        startDate = now.subtract(const Duration(days: 365));
        break;
      case '3Y':
        startDate = now.subtract(const Duration(days: 1095));
        break;
      default:
        startDate = widget.fund.launchDate;
        break;
    }

    final indices = widget.fund.dates.asMap().entries
        .where((entry) => entry.value.isAfter(startDate))
        .map((entry) => entry.key)
        .where((index) => index < widget.fund.navValues.length && 
                         index < widget.fund.benchmarkValues.length && 
                         index < widget.fund.dates.length)
        .toList();

    setState(() {
      if (indices.isEmpty) {
        // Fallback to bluechip fund data
        _chartData = _generateBluechipData();
        _benchmarkData = _generateBenchmarkData();
      } else {
        _chartData = indices.map((i) => ChartData(
          date: widget.fund.dates[i],
          value: widget.fund.navValues[i],
        )).toList();

        _benchmarkData = indices.map((i) => ChartData(
          date: widget.fund.dates[i],
          value: widget.fund.benchmarkValues[i],
        )).toList();
      }
    });
  }

  List<ChartData> _generateBluechipData() {
    final now = DateTime.now();
    final List<ChartData> data = [];
    double baseValue = 100.0;
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      baseValue *= (1 + (Random().nextDouble() * 0.02 - 0.01));
      data.insert(0, ChartData(date: date, value: baseValue));
    }
    
    return data;
  }

  List<ChartData> _generateBenchmarkData() {
    final now = DateTime.now();
    final List<ChartData> data = [];
    double baseValue = 100.0;
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      baseValue *= (1 + (Random().nextDouble() * 0.015 - 0.0075));
      data.insert(0, ChartData(date: date, value: baseValue));
    }
    
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.fund.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Invested Value',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹1,00,000',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Current Value',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹1,19,000',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gain',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_upward,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹19,000',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Gain %',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+19.00%',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat('MMM dd'),
                  intervalType: DateTimeIntervalType.days,
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: const TextStyle(color: Colors.grey),
                  plotOffset: 30,
                  minimum: _chartData.isNotEmpty ? _chartData.first.date : DateTime.now().subtract(const Duration(days: 30)),
                  maximum: _chartData.isNotEmpty ? _chartData.last.date : DateTime.now(),
                  axisLabelFormatter: (AxisLabelRenderDetails details) {
                    if (details.value is DateTime) {
                      return ChartAxisLabel(
                        DateFormat('MMM dd').format(details.value as DateTime),
                        details.textStyle,
                      );
                    }
                    return ChartAxisLabel('', details.textStyle);
                  },
                ),
                primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: const TextStyle(color: Colors.grey),
                  numberFormat: NumberFormat.compact(),
                  plotOffset: 30,
                ),
                plotAreaBorderWidth: 0,
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  builder: (dynamic data, dynamic point, dynamic series,
                      int pointIndex, int seriesIndex) {
                    final ChartData chartData = data as ChartData;
                    final random = Random();
                    final randomValue = chartData.value * (1 + (random.nextDouble() * 0.02 - 0.01));
                    final isNAV = seriesIndex == 0;
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isNAV ? Colors.blue : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isNAV ? 'NAV' : 'Benchmark',
                                style: TextStyle(
                                  color: isNAV ? Colors.blue : Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('MMM dd, yyyy').format(chartData.date),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${randomValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                series: <CartesianSeries>[
                  SplineAreaSeries<ChartData, DateTime>(
                    name: 'NAV',
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        Colors.blue.withOpacity(0.1),
                      ],
                    ),
                    color: Colors.blue,
                    animationDuration: 2000,
                    opacity: 0.8,
                  ),
                  SplineAreaSeries<ChartData, DateTime>(
                    name: 'Benchmark',
                    dataSource: _benchmarkData,
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.value,
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey.withOpacity(0.3),
                        Colors.grey.withOpacity(0.1),
                      ],
                    ),
                    color: Colors.grey,
                    animationDuration: 2000,
                    opacity: 0.8,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeframeButton('1M'),
                  _buildTimeframeButton('3M'),
                  _buildTimeframeButton('6M'),
                  _buildTimeframeButton('1Y'),
                  _buildTimeframeButton('3Y'),
                  _buildTimeframeButton('MAX'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'If you invested ₹',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[700]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: TextField(
                          controller: _investmentController,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            double? amount = double.tryParse(value);
                            if (amount != null && amount >= 1 && amount <= 10) {
                              setState(() {
                                _investmentAmount = amount;
                              });
                            }
                          },
                        ),
                      ),
                      const Text(
                        'L',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: CupertinoSlidingSegmentedControl<bool>(
                      backgroundColor: Colors.grey[800]!,
                      thumbColor: Colors.blue,
                      groupValue: _isSIP,
                      children: {
                        false: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: const Text(
                            '1-Time',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        true: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: const Text(
                            'Monthly SIP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          _isSIP = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "This Fund's past returns",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Profit % (Absolute Return)',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey[800],
                      thumbColor: Colors.blue,
                      overlayColor: Colors.blue.withOpacity(0.2),
                      valueIndicatorColor: Colors.blue,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    child: Column(
                      children: [
                        Slider(
                          value: _investmentAmount,
                          min: 1.0,
                          max: 10.0,
                          divisions: 90,
                          label: '₹${_investmentAmount.toStringAsFixed(1)}L',
                          onChanged: (value) {
                            setState(() {
                              _investmentAmount = value;
                              _investmentController.text = value.toStringAsFixed(1);
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹1L',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '₹10L',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _buildReturnBar(
                            label: 'Saving A/C',
                            value: 1.19 * _investmentAmount,
                            percentage: 19.0,
                            maxHeight: 120,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildReturnBar(
                            label: 'Category Avg',
                            value: 3.43 * _investmentAmount,
                            percentage: 243.0,
                            maxHeight: 120,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildReturnBar(
                            label: 'Direct Plan',
                            value: 4.55 * _investmentAmount,
                            percentage: 355.0,
                            maxHeight: 120,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fund Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', widget.fund.category),
                  _buildDetailRow('Fund Manager', widget.fund.fundManager),
                  _buildDetailRow('AUM', '₹${(widget.fund.aum / 100000000).toStringAsFixed(2)} Cr'),
                  _buildDetailRow('Expense Ratio', '${widget.fund.expenseRatio}%'),
                  _buildDetailRow('Risk Level', widget.fund.riskLevel),
                  _buildDetailRow('Benchmark', widget.fund.benchmark),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement sell functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sell',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement invest more functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Invest More',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeButton(String timeframe) {
    final isSelected = _selectedTimeframe == timeframe;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeframe = timeframe;
        });
        _updateChartData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          timeframe,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnBar({
    required String label,
    required double value,
    required double percentage,
    required double maxHeight,
    required Color color,
  }) {
    final barHeight = (percentage / 355.0) * maxHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '₹${value.toStringAsFixed(2)}L',
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: maxHeight,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 40,
                height: barHeight,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ChartData {
  final DateTime date;
  final double value;

  ChartData({required this.date, required this.value});
}