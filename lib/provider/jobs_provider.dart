import 'package:flutter/material.dart';
import 'package:hire_q/models/company_job_model.dart';

class JobsProvider extends ChangeNotifier {
  // jobs that current company posted (according to the company id)
  List<CompanyJobModel> _currentCompanyJobs;

  // job list in total (same as contents in job search)
  List<CompanyJobModel> _jobList;
  JobsProvider() {
    _currentCompanyJobs = [];
    _jobList = [];
  }

  // get
  get currentCompanyJobs => _currentCompanyJobs;

  get jobList => _jobList;
  // set
  set currentCompanyJobs(List<CompanyJobModel> value) {
    _currentCompanyJobs = value;
    notifyListeners();
  }

  set jobList(List<CompanyJobModel> value) {
    _jobList = value;
    notifyListeners();
  }

  // adding current company job
  void addCurrentCompanyJob(CompanyJobModel item) {
    _currentCompanyJobs.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // adding job to total job list
  void addToJobList(CompanyJobModel item) {
    _jobList.add(item);
    notifyListeners();
  }

  // remove all items from current company job
  void removeAllCurrentJobs() {
    _currentCompanyJobs.clear();
    notifyListeners();
  }

  /// Removes all items from all job list.
  void removeAllJobList() {
    _jobList.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // ========== UPDATE JOB ITEM ==============
  void updateCuurentCompanyJob(CompanyJobModel item) {
    final index = currentCompanyJobs.indexWhere((element) => element.id == item.id);
    currentCompanyJobs[index] = item;
    notifyListeners();
  }
}
