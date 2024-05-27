import 'package:flutter/material.dart';
import 'appColors.dart';
import 'appTextStyles.dart';
import 'gaps.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAdEnabled = true;
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wh,
      appBar: AppBar(
        title: Text('환경설정',
            style: AppTextStyles.body1S16.copyWith(color: AppColors.bk)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.bk),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SwitchListTile(
                  title: Text(
                    '광고 수신여부',
                    style: AppTextStyles.body2M16.copyWith(color: AppColors.bk),
                  ),
                  value: _isAdEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isAdEnabled = value;
                    });
                  },
                  activeColor: AppColors.wh, // Custom active color
                  activeTrackColor:
                      AppColors.deepTeal, // Custom active track color
                  inactiveThumbColor:
                      AppColors.wh, // Custom inactive thumb color
                  inactiveTrackColor:
                      AppColors.gr400, // Custom inactive track color
                ),
                SwitchListTile(
                  title: Text(
                    '알림 활성화',
                    style: AppTextStyles.body2M16.copyWith(color: AppColors.bk),
                  ),
                  value: _isNotificationEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _isNotificationEnabled = value;
                    });
                  },
                  activeColor: AppColors.wh, // Custom active color
                  activeTrackColor:
                      AppColors.deepTeal, // Custom active track color
                  inactiveThumbColor:
                      AppColors.wh, // Custom inactive thumb color
                  inactiveTrackColor:
                      AppColors.gr400, // Custom inactive track color
                ),
                ListTile(
                  title: Text(
                    '이용약관',
                    style: AppTextStyles.body2M16.copyWith(color: AppColors.bk),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to terms and conditions page
                  },
                ),
                const Divider(),
              ],
            ),
            ListTile(
              title: Text(
                '회원 탈퇴',
                style: AppTextStyles.body2M16.copyWith(color: AppColors.red),
              ),
              onTap: () {
                // Handle account deletion
              },
            ),
          ],
        ),
      ),
    );
  }
}
