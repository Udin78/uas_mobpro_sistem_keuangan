import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcampus/controllers/budget_planning_controller.dart';
import 'package:smartcampus/models/budget_planning_model.dart';

class BudgetPlanningView extends StatefulWidget {
  @override
  _BudgetPlanningViewState createState() => _BudgetPlanningViewState();
}

class _BudgetPlanningViewState extends State<BudgetPlanningView> {
  final _budgetController = TextEditingController();
  final _semesterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final BudgetPlanningController _controller = Get.put(BudgetPlanningController());

  @override
  void initState() {
    super.initState();
    _controller.getBudgetPlanningList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Planning'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Anggaran (Rp)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Anggaran tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Masukkan angka yang valid';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _semesterController,
                    decoration: InputDecoration(
                      labelText: 'Semester',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Semester tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final budget = BudgetPlanningModel(
                          budget: double.parse(_budgetController.text),
                          semester: _semesterController.text,
                        );
                        _controller.saveBudget(budget);
                      }
                    },
                    child: Text('Simpan Anggaran'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Obx(() {
              return _controller.budgetPlanningList.isEmpty
                  ? Center(child: Text('Tidak ada data anggaran'))
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: _controller.budgetPlanningList.length,
                itemBuilder: (context, index) {
                  final budget = _controller.budgetPlanningList[index];
                  return Card(
                    child: ListTile(
                      title: Text('Anggaran: Rp ${budget.budget}'),
                      subtitle: Text('Semester: ${budget.semester}'),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

