import 'package:flutter/material.dart';
import 'package:hire_q/models/applied_job_model.dart';

class JobsProvider extends ChangeNotifier {
  // jobs that current company posted (according to the company id)
  List<AppliedJobModel> _currentCompanyJobs;

  // job list in total (same as contents in job search)
  List<AppliedJobModel> _jobList;

  // current selected applied job 
  AppliedJobModel _currentSelectedAppliedJob;

  // job shortlist changed
  JobsProvider() {
    _currentCompanyJobs = [];
    _jobList = [];
  }

  // get
  get currentCompanyJobs => _currentCompanyJobs;

  get jobList => _jobList;

  get currentSelectedAppliedJob => _currentSelectedAppliedJob;

  set currentSelectedAppliedJob(AppliedJobModel value) {
    _currentSelectedAppliedJob = value;
    notifyListeners();
  }
  set currentCompanyJobs(List<AppliedJobModel> value) {
    _currentCompanyJobs = value;
    notifyListeners();
  }

  set jobList(List<AppliedJobModel> value) {
    _jobList = value;
    notifyListeners();
  }

  // reset func
  void removeAll() {
    currentCompanyJobs = [];
    jobList = [];
    currentSelectedAppliedJob = null;
  }
  // adding current company job
  void addCurrentCompanyJob(AppliedJobModel item) {
    _currentCompanyJobs.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // adding job to total job list
  void addToJobList(AppliedJobModel item) {
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
  void updateCuurentCompanyJob(AppliedJobModel item) {
    final index = currentCompanyJobs.indexWhere((element) => element.id == item.id);
    currentCompanyJobs[index] = item;
    notifyListeners();
  }
}
