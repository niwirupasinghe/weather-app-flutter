import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weather_provider.dart';
import '../../../core/constants/api_constants.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-Day Forecast'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.forecast == null) {
            return const Center(child: Text('No forecast data available'));
          }

          final forecast = provider.forecast!;
          
          // Group by day
          final Map<String, List<dynamic>> groupedByDay = {};
          for (var item in forecast.list) {
            final day = DateFormat('yyyy-MM-dd').format(item.dateTime);
            if (!groupedByDay.containsKey(day)) {
              groupedByDay[day] = [];
            }
            groupedByDay[day]!.add(item);
          }

          final days = groupedByDay.keys.take(5).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                // Temperature Chart
                _buildTemperatureChart(context, forecast),
                const SizedBox(height: 16),

                // Daily Forecast Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    final dayItems = groupedByDay[day]!;
                    final avgTemp = dayItems.fold<double>(
                          0,
                          (sum, item) => sum + item.temperature,
                        ) /
                        dayItems.length;
                    final mainIcon = dayItems[dayItems.length ~/ 2].icon;
                    final description = dayItems[dayItems.length ~/ 2].description;

                    return _buildDayCard(
                      context,
                      DateTime.parse(day),
                      avgTemp,
                      mainIcon,
                      description,
                      dayItems,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTemperatureChart(BuildContext context, forecast) {
    final spots = <FlSpot>[];
    for (int i = 0; i < forecast.list.take(8).length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        forecast.list[i].temperature,
      ));
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Temperature Trend (24h)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}°C');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final time = forecast.list[value.toInt()].dateTime;
                          return Text(DateFormat('HH:mm').format(time));
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(
    BuildContext context,
    DateTime date,
    double avgTemp,
    String icon,
    String description,
    List<dynamic> hourlyData,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: CachedNetworkImage(
          imageUrl: ApiConstants.iconUrl(icon),
          width: 50,
          height: 50,
        ),
        title: Text(
          DateFormat('EEEE, MMM d').format(date),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Text(
          '${avgTemp.round()}°C',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        children: [
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyData.length,
              itemBuilder: (context, index) {
                final item = hourlyData[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('HH:mm').format(item.dateTime),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      CachedNetworkImage(
                        imageUrl: ApiConstants.iconUrl(item.icon),
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        '${item.temperature.round()}°C',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}