import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class APIClient {
  // REST API Endpoint
  static const endpoint = "http://192.168.116.39:5000/api/v1";
  // Request Header
  final header = {"content-type": "application/json", "accept": "*/*"};

  // ================= company model ===================
  // get company model for authenticated company
  Future<http.Response> getCompany({userId, token}) async {
    try {
      header['api-token'] = token;
      var response = await http.get(
          Uri.parse(
              endpoint + "/companies/company_by_user/" + userId.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // create company info 
  Future<http.Response> createCompanyInfo({token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.post(
          Uri.parse(endpoint + "/companies/"),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // update company data for authenticated company
  Future<http.Response> updateCompany({companyId, token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.put(
          Uri.parse(endpoint + "/companies/update/" + companyId.toString()),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // =================== Talent Model ============

  // get talent info by user id
  Future<http.Response> getTalentByUser({userId, token}) async {
    try {
      header['api-token'] = token;
      var response = await http.get(
          Uri.parse(
              endpoint + "/talents/by_user/" + userId.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
  // create talent data
  Future<http.Response> createTalentInfo({token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.post(
          Uri.parse(endpoint + "/talents/"),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
  // update talent data
  Future<http.Response> updateTalentInfo({talentId, token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.put(
          Uri.parse(endpoint + "/talents/update/" + talentId.toString()),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
  // ===================== company profile =================

  // get profile model for authenticated company or talent
  Future<http.Response> getProfile({userId, token}) async {
    try {
      header['api-token'] = token;
      var response = await http.get(
          Uri.parse(endpoint + "/profiles/" + userId.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
  // update profile 
  Future<http.Response> updateProfile({id, token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.put(
          Uri.parse(endpoint + "/profiles/update/" + id.toString()),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // ================= Company job part =========================

  // add company job
  Future<http.Response> addCompanyJob({token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.post(Uri.parse(endpoint + "/jobs/"),
          body: payloads, headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // update company job
  Future<http.Response> updateCompanyJob({id, token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.put(Uri.parse(endpoint + "/jobs/update/" + id.toString()),
          body: payloads, headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
  // get current company jobs with company id
  Future<http.Response> getCurrentCompanyJobs({token, companyId}) async {
    try {
      header['api-token'] = token;
      var response = await http.get(
          Uri.parse(endpoint + "/jobs/all/" + companyId.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // applied job by talent 
  Future<http.Response> applyCompanyJob({token, payloads}) async {
    try {
      header['api-token'] = token;
      var response = await http.post(
          Uri.parse(endpoint + "/appliedjobs/"),
          body: payloads,
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // get applied job in company

  // ================ company job board part ===================

  // get the company jobs including pagination  
  Future<http.Response> getCompanyJobs({pageNum, pageLength}) async {
    try {
      var response = await http.get(
          Uri.parse(endpoint + "/jobs/pages/" + pageNum.toString() + "/" + pageLength.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }

  // get the company jobs excepting applied job by user id
  Future<http.Response> getCompanyJobsByUserId({token, pageNum, pageLength}) async {
    try {
      header['api-token'] = token;
      var response = await http.get(
          Uri.parse(endpoint + "/jobs/pages_by_user/" + pageNum.toString() + "/" + pageLength.toString()),
          headers: header);
      return response;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }



  // ================= file upload function =================

  // file upload with post method including mutipart request
  Future<http.Response> postFileUpload({token, filePath}) async {
    try {
      header['api-token'] = token;
      // var response = await http.post(
      //     Uri.parse(endpoint + "/videos/file"),
      //     body : payloads,
      //     headers: header);
      // return response;
      //for multipartrequest
      var request = http.MultipartRequest('POST', Uri.parse(endpoint + "/videos/file"));

      //for token
      request.headers.addAll({"api-token": token});

      //for image and videos and files

      request.files.add(await http.MultipartFile.fromPath(
          "file", filePath));

      //for completeing the request
      var response = await request.send();

      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
      return responsed;
    } catch (e) {
      throw Exception("Unknow Error.");
    }
  }
}
