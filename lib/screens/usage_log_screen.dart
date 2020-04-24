import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/screens/usage_log_detail_screen.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:rapidpass_checkpoint/services/usage_log_service.dart';

class UsageLogScreen extends StatefulWidget {
  @override
  _UsageLogScreenState createState() => _UsageLogScreenState();
}

class _UsageLogScreenState extends State<UsageLogScreen> {
  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
          appBar: AppBar(title: Text('Usage Log')),
          body: Padding(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: UsageLogService.getUsageLogByDate(context),
                  builder: (bContext, bSnapshot) {
                    if (bSnapshot.connectionState == ConnectionState.done) {
                      final List<UsageDateLog> logs = bSnapshot.data;
                      return ListView.separated(
                        itemCount: logs.length,
                        separatorBuilder: (context, count) {
                          return const Divider(
                            height: 2,
                            color: Colors.grey,
                          );
                        },
                        itemBuilder: (bContext, index) =>
                            _buildDateLog(logs[logs.length - index - 1]),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))),
    );
  }

  _buildDateLog(UsageDateLog log) {
    return Container(
      height: 50.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        title: Text(
          '${log.count} RapidPass',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${DateFormat('MMM dd, yyyy').format(new DateTime.fromMillisecondsSinceEpoch(log.timestamp))}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        onTap: () => Navigator.pushNamed(context, '/usageLogDetail',
            arguments: UsageLogDetailArgs(log.timestamp)),
      ),
    );
  }
}
