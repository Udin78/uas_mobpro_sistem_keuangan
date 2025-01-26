import 'package:get/get.dart';
import 'package:smartcampus/views/register_view.dart';
import 'package:smartcampus/views/tagihan_view.dart';
import 'package:smartcampus/views/bayar_view.dart';
import 'package:smartcampus/views/add_bill_view.dart';
import 'package:smartcampus/views/laporan_pengeluaran_view.dart';
import '../views/login_view.dart';
import '../views/profile_view.dart';
import '../views/edit_profile_view.dart';
import '../views/schedule_view.dart';
import '../views/notification_view.dart';
import '../views/home_view.dart';


class AppRoutes {
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const NOTIFICATIONS = '/notifications';
  static const HOME = '/home';
  static const SCHEDULE = '/schedule';
  static const TAGIHAN = '/tagihan';
  static const BAYAR = '/bayar';
  static const TAMBAH_TAGIHAN = '/add-bill';
  static const LAPORAN_PENGELUARAN = '/laporan-pengeluaran';

  static final pages = [
    GetPage(
      name: REGISTER,
      page: () => RegisterView(),
    ),
    GetPage(
      name: LOGIN,
      page: () => LoginView(),
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileView(),
    ),
    GetPage(
      name: EDIT_PROFILE,
      page: () => EditProfileView(),
    ),
    GetPage(
      name: NOTIFICATIONS,
      page: () => NotificationView(),
    ),
    GetPage(
      name: HOME,
      page: () => HomeView(),
    ),
    GetPage(
      name: SCHEDULE,
      page: () => ScheduleView(),
    ),
    GetPage(
        name: TAGIHAN,
        page: () => TagihanView(),
    ),
    GetPage(
        name: BAYAR,
      page: () => BayarView(),
    ),
    GetPage(
      name: TAMBAH_TAGIHAN,
      page: () => AddBillView(),
    ),
    GetPage(
      name: LAPORAN_PENGELUARAN,
      page: () => LaporanPengeluaranView(),
    ),
  ];
}
