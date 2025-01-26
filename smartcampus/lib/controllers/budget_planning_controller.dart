import 'package:smartcampus/models/budget_planning_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetPlanningController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _budgetPlanningList = <BudgetPlanningModel>[].obs;

  List<BudgetPlanningModel> get budgetPlanningList => _budgetPlanningList.value;

  Future<void> saveBudget(BudgetPlanningModel budget) async {
    try {
      await _firestore.collection('budget_planning').add(budget.toMap());
      Get.snackbar('Success', 'Anggaran disimpan dengan sukses');
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat menyimpan anggaran');
    }
  }

  Future<void> getBudgetPlanningList() async {
    try {
      final querySnapshot = await _firestore.collection('budget_planning').get();
      _budgetPlanningList.assignAll(querySnapshot.docs.map((doc) => BudgetPlanningModel.fromMap(doc.data())).toList());
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil data anggaran');
    }
  }
}

