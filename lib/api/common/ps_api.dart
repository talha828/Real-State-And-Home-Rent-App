import 'dart:convert';
import 'dart:io';

import 'package:flutteradhouse/api/common/ps_api_reponse.dart';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/config/ps_config.dart';
import 'package:flutteradhouse/viewobject/common/ps_object.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

abstract class PsApi {
  PsResource<T> psObjectConvert<T>(dynamic dataList, T data) {
    return PsResource<T>(dataList.status, dataList.message, data);
  }

  // Future<List<dynamic>> getList(String url) async {
  //   final Client client = http.Client();
  //   try {
  //     final Response response = await client.get('${PsConfig.ps_app_url}$url');

  //     if (response.statusCode == 200 &&
  //         response.body != null &&
  //         response.body != '') {
  //       // parse into List
  //       final List<dynamic> parsed = json.decode(response.body);

  //       //posts.addAll(SubCategory().fromJsonList(parsed));

  //       return parsed;
  //     } else {
  //       throw Exception('Error in loading...');
  //     }
  //   } finally {
  //     client.close();
  //   }
  // }

  Future<PsResource<R>> getServerCall<T extends PsObject<dynamic>, R>(
      T obj, String url) async {
    final Client client = http.Client();
    try {
      final Response response = await client.get(Uri.parse('${PsConfig.ps_app_url}$url'));      print('${PsConfig.ps_app_url}$url');
      final PsApiResponse psApiResponse = PsApiResponse(response);

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data as dynamic));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } catch (e) {
      print(e.toString());
      return PsResource<R>(PsStatus.ERROR, e.toString(), null); //e.message ??
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postData<T extends PsObject<dynamic>, R>(
      T obj, String url, Map<dynamic, dynamic> jsonMap) async {
    final Client client = http.Client();
    try {
      final Response response = await client
          .post(Uri.parse('${PsConfig.ps_app_url}$url'),
              headers: <String, String>{'content-type': 'application/json'},
              body: const JsonEncoder().convert(jsonMap))
          .catchError((dynamic e) {
        print('** Error Post Data');
        print(e.error);
      });

      final PsApiResponse psApiResponse = PsApiResponse(response);

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } catch (e) {
      print(e.toString());

      return PsResource<R>(PsStatus.ERROR, e.toString(), null); //e.message ??
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postListData<T extends PsObject<dynamic>, R>(
      T obj, String url, List<Map<dynamic, dynamic>> jsonMap) async {
    final Client client = http.Client();
    try {
      final Response response = await client
          .post(Uri.parse('${PsConfig.ps_app_url}$url'),
              headers: <String, String>{'content-type': 'application/json'},
              body: const JsonEncoder().convert(jsonMap))
          .catchError((dynamic e) {
        print('** Error Post Data');
        print(e.error);
      });

      final PsApiResponse psApiResponse = PsApiResponse(response);

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(response.body);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } catch (e) {
      print(e.toString());

      return PsResource<R>(PsStatus.ERROR, e.toString(), null); //e.message ??
    } finally {
      client.close();
    }
  }

  Future<PsResource<R>> postUploadImage<T extends PsObject<dynamic>, R>(
      T obj,
      String url,
      String userIdText,
      String userId,
      String platformNameText,
      String platformName,
      File imageFile) async {
    final Client client = http.Client();
    try {
      final ByteStream stream =
          http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse('${PsConfig.ps_app_url}$url');

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      request.fields[userIdText] = userId;
      request.fields[platformNameText] = platformName;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();
      // response.stream.listen((List<int> value ) {
      //   print(value);
      // });

      final PsApiResponse psApiResponse =
          PsApiResponse(await http.Response.fromStream(response));

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(psApiResponse.body!);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }


    Future<PsResource<R>> postUploadItemImage<T extends PsObject<dynamic>, R>(
      T obj,
      String url,
      String itemIdText,
      String itemId,
      String imageIdText,
      String imageId,
      String orderingText,
      String orderingDesc,
      File imageFile) async {
    final Client client = http.Client();
    StreamedResponse response;
    ByteStream stream;
    try {
      if (imageFile.path != '') {
        stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
        final int length = await imageFile.length();

        final Uri uri = Uri.parse('${PsConfig.ps_app_url}$url');

        final MultipartRequest request = http.MultipartRequest('POST', uri);
        final MultipartFile multipartFile = http.MultipartFile(
            'file', stream, length,
            filename: basename(imageFile.path));

        request.fields[itemIdText] = itemId;
        request.fields[imageIdText] = imageId;
        request.fields[orderingText] = orderingDesc;
        request.files.add(multipartFile);
        response = await request.send();
      } else {
        stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
        final Uri uri = Uri.parse('${PsConfig.ps_app_url}$url');
        final MultipartRequest request = http.MultipartRequest('POST', uri);
        request.fields[itemIdText] = itemId;
        request.fields[imageIdText] = imageId;
        request.fields[orderingText] = orderingDesc;
        response = await request.send();
      }

      final PsApiResponse psApiResponse =
          PsApiResponse(await http.Response.fromStream(response));

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(psApiResponse.body!);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }


  Future<PsResource<R>> postUploadChatImage<T extends PsObject<dynamic>, R>(
      T obj,
      String url,
      String senderIdText,
      String senderId,
      String sellerUserIdText,
      String sellerUserId,
      String buyerUserIdText,
      String buyerUserId,
      String itemIdText,
      String itemId,
      String typeText,
      String type,
      String isUserOnlineText,
      String isUserOnline,
      File imageFile) async {
    final Client client = http.Client();
    try {
      final ByteStream stream =
          http.ByteStream(Stream.castFrom(imageFile.openRead()));
      final int length = await imageFile.length();

      final Uri uri = Uri.parse('${PsConfig.ps_app_url}$url');

      final MultipartRequest request = http.MultipartRequest('POST', uri);
      final MultipartFile multipartFile = http.MultipartFile(
          'file', stream, length,
          filename: basename(imageFile.path));

      request.fields[senderIdText] = senderId;
      request.fields[sellerUserIdText] = sellerUserId;
      request.fields[buyerUserIdText] = buyerUserId;
      request.fields[itemIdText] = itemId;
      request.fields[typeText] = type;
      request.fields[isUserOnlineText] = isUserOnline;
      request.files.add(multipartFile);
      final StreamedResponse response = await request.send();

      final PsApiResponse psApiResponse =
          PsApiResponse(await http.Response.fromStream(response));

      if (psApiResponse.isSuccessful()) {
        final dynamic hashMap = json.decode(psApiResponse.body!);

        if (!(hashMap is Map)) {
          final List<T> tList = <T>[];
          hashMap.forEach((dynamic data) {
            tList.add(obj.fromMap(data));
          });
          return PsResource<R>(PsStatus.SUCCESS, '', tList as R? ?? R as R?);
        } else {
          return PsResource<R>(PsStatus.SUCCESS, '', obj.fromMap(hashMap));
        }
      } else {
        return PsResource<R>(PsStatus.ERROR, psApiResponse.errorMessage, null);
      }
    } finally {
      client.close();
    }
  }
}
