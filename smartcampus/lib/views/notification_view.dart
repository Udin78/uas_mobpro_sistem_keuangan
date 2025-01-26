import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import '../controllers/notification_controller.dart';

class NotificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.to;

    Future<void> sendPushNotification(String title, String body) async {
      const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/smartcampus-5a/messages:send';

      // Masukkan konten file Service Account JSON Anda di sini
      final serviceAccount = ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "smartcampus-5a",
        "private_key_id": "48ba961b13761167ac71caf05662ea20dc23aad6",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCXOTmD3A14qh/n\nV2lU111PmfDHXVqn5afcBaNpViKkT/Ma7T9o9jd1msa97ta4yU+d8/Lp+ZS74JpP\nKZr7oF6kX/ODXQz9cM7ZuTPV5Xj3/hwmSevpPHXQeKElvtA5udHGEQZQ+4SE0fU4\nkHsqIa/huhcNftNyVTPzk0T3ZzejAD7cAfOJiNSqvFB8RrQrm0CO7IljqjxpeQPa\nsmKBD8xXayrZfLnURvUXd70R3FHWbPUlSQkiCurPIDzA5EfI4HPqZimBmsvOn7KZ\nZD2xc4JuE46Uz9mzEzHwjX5VQbIskc54jRwfQJxm136Apvk2xYwi69iGLoh7Xp0T\nIGijRhohAgMBAAECggEABgrZZwVN/8RgFQ9SE3utrCrYlrpbvchp1LhUl03mmKJY\nFWP84dFp1bOaVMrdqhRXr5vuZGSVw9I5MmUbGQpBeu8CMUNCGm9xwYe2GMoh3BSv\n281A4/u2McfQJO+AFecfTsD/NeLMt+xzYdXanUZxT6kGIvcXKXGJMT3ldO2bKN42\n6SH8k+9zmpyGsEh6TIoOX3JnSvz+EjDstmvYAzXbcRpYJfgTE3hSrxK99jnv011+\n6iwsJKyfZKyUPKok/FDfdlzbNQCHHrnWYNNbb7IhSu+KbpBF2xsDsW2CLD3AOQ/b\nyjcJxkMPdvK4Q78Rg1Ehsqby2yAmIeBOp2DaOsyPLQKBgQDLokUHgbeZdFyuLuzE\ndbN7s+1ssjPJFXQSQspx6PyakWGUCUEkC0/i13fbiuxa0kPtw2jE0lIyDB9+ozhr\nf/kHEWNx3ktT7kJ5IMVUbAYyGJW2QJLVISE9dQ6OVJZtHgpNx7iXwlPm6GlJAeQH\n1o6w2fbaW7ougeL11UuzCdKP+wKBgQC+HKady0GM2GvucOAj/j/J+EaJ2EgI9JQa\nA8eQtAMCT2dF0a1o6bPgdbw32l0onRkMdnfoTET+NIGC3ecjQjCrceUn2HuQcWIV\npw5r+ymMhYInrs++EwCIPFltcf/Afl5cIUEM40FX3WaCbolD61zW84orq7GdBvCf\nBBNr14O3kwKBgQCD1wC4VnzHZrYmtAzpOYdGHP0oNcwfcbtfo0ytKXp6nIu/q6o4\nKvbC2FwqkSxrtNz0EGNBoyZCbuTpOcXqm8VglRp8e77rjUQOZnA8M2BjiNVNVUt7\nn+KEhsgw0IVACoYDS76wyslFo82ezhGUHY7u43/WajMFr2SBY2KKfV6NhwKBgGAw\nUOEPwSfJLLrk45NyhcXj15TRGIlnbjPHa8a8PbWChWcfEtU9QaS1DTlZQ79T1SOo\nIT0osdPIryqOqe7+A3ALXX2Om95Wb+EyuCpMVxZhSpxXZ4btSFyl5D1q65LynT2S\nGb6ykRIq1D30PYFe6Ydci7FS2rfvlflu74Cl91//AoGADCJutCIg3RbF8Fd1JJUj\nTm5lmGsZv1S63XaddDnYZ7YwYIULZDjiiPfFZhbHgBjjtPLRoU4pGg764KdkF8KO\nwJc7dwfRrIgt2f9jEuEXXYCYpRgSy9l+Ca3WjsRFypPfGBbODrYUjG06msb2X1YT\nAihuZk+Tp35ew1WlazxLIfE=\n-----END PRIVATE KEY-----\n",
        "client_email": "smartcampus-5a@appspot.gserviceaccount.com",
        "client_id": "100497285065050586047",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/smartcampus-5a%40appspot.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      });

      try {
        final authClient = await clientViaServiceAccount(
          serviceAccount,
          ['https://www.googleapis.com/auth/firebase.messaging'],
        );

        final response = await authClient.post(
          Uri.parse(fcmUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "message": {
              "topic": "general", // Target spesifik topik
              "notification": {
                "title": title,
                "body": body,
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "status": "done"
              }
            }
          }),
        );

        if (response.statusCode == 200) {
          print('Push notification sent successfully');
          Get.snackbar('Push Notification', 'Notification sent successfully.');
        } else {
          print('Failed to send push notification: ${response.body}');
          Get.snackbar('Error', 'Failed to send push notification.');
        }

        authClient.close();
      } catch (e) {
        print('Error sending push notification: $e');
        Get.snackbar('Error', 'An error occurred while sending notification.');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {
              controller.addNotification(
                title: 'Tes Notifikasi',
                body: 'in-app tes notifikasi.',
              );
              Get.snackbar('Tes Notifikasi', 'ini tes in-app notifikasi.');
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              sendPushNotification('Push Tes', 'ini tes push notifikasi.');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(child: Text('Tidak ada notifikasi.'));
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              title: Text(notification['title'] ?? 'No Title'),
              subtitle: Text(notification['body'] ?? 'No Body'),
              leading: Icon(Icons.notifications),
            );
          },
        );
      }),
    );
  }
}
