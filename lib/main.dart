import 'package:flutter/material.dart';

void main() {
  runApp(BatsmanProApp());
}

class BatsmanProApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batsman Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[100],
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> featureTiles = [
    {
      'icon': Icons.sports_cricket,
      'label': 'Shot Analysis',
      'color': Colors.deepOrangeAccent,
    },
    {
      'icon': Icons.directions_run,
      'label': 'Footwork Tracking',
      'color': Colors.purpleAccent,
    },
    {
      'icon': Icons.celebration,
      'label': 'Highlights',
      'color': Colors.green,
    },
    {
      'icon': Icons.show_chart,
      'label': 'Performance',
      'color': Colors.blueAccent,
    },
    {
      'icon': Icons.person_search,
      'label': 'Posture Compare',
      'color': Colors.teal,
    },
    {
      'icon': Icons.cloud_upload,
      'label': 'Cloud Storage',
      'color': Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Batsman Pro Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SummaryCard(),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              itemCount: featureTiles.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final tile = featureTiles[index];
                return FeatureTile(
                  icon: tile['icon'],
                  label: tile['label'],
                  color: tile['color'],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Today's Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SummaryStat(title: 'Shots', value: '24'),
                SummaryStat(title: 'Highlights', value: '6'),
                SummaryStat(title: 'Accuracy', value: '87%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryStat extends StatelessWidget {
  final String title;
  final String value;

  SummaryStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  FeatureTile({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle navigation or actions
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped on $label')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
