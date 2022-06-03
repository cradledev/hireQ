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
