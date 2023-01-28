import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/api/ps_api_service.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/db/chat_history_dao.dart';
import 'package:flutteradhouse/db/chat_history_map_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/chat_history.dart';
import 'package:flutteradhouse/viewobject/chat_history_map.dart';
import 'package:flutteradhouse/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/get_chat_history_parameter_holder.dart';
import 'package:sembast/sembast.dart';

class ChatHistoryRepository extends PsRepository {
  ChatHistoryRepository(
      {required PsApiService psApiService,
      required ChatHistoryDao chatHistoryDao}) {
    _psApiService = psApiService;
    _chatHistoryDao = chatHistoryDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
 late PsApiService _psApiService;
 late ChatHistoryDao _chatHistoryDao;

  void sinkchatHistoryListStream(
      StreamController<PsResource<List<ChatHistory>>>? chatHistoryListStream,
      PsResource<List<ChatHistory>>? dataList) {
    if (dataList != null && chatHistoryListStream != null) {
      chatHistoryListStream.sink.add(dataList);
    }
  }

  void sinkChatHistoryStream(
      StreamController<PsResource<ChatHistory>> chatHistoryStream,
      PsResource<ChatHistory>? data) {
    if (data != null) {
      chatHistoryStream.sink.add(data);
    }
  }

  void sinkResetUnreadCountStream(
      StreamController<PsResource<List<ChatHistory>>> chatHistoryStream,
      PsResource<List<ChatHistory>>? data) {
    if (data != null) {
      chatHistoryStream.sink.add(data);
    }
  }

  Future<dynamic> insert(ChatHistory chatHistory) async {
    return _chatHistoryDao.insert(primaryKey, chatHistory);
  }

  Future<dynamic> update(ChatHistory chatHistory) async {
    return _chatHistoryDao.update(chatHistory);
  }

  Future<dynamic> delete(ChatHistory chatHistory) async {
    return _chatHistoryDao.delete(chatHistory);
  }

//   Future<dynamic> getChatHistoryList(StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream,
//       bool isConnectedToInternet,
//       int limit,
//       int offset,
//       PsStatus status,
//       ChatHistoryParameterHolder holder,
//       {bool isLoadFromServer = true}) async {
//     // Prepare Holder and Map Dao
//     final String paramKey = holder.getParamKey();
//     final ChatHistoryMapDao chatHistoryMapDao = ChatHistoryMapDao.instance;

//     // Load from Db and Send to UI
//     // sinkchatHistoryListStream(
//     //     chatHistoryListStream,
//     //     await _chatHistoryDao.getAllByMap(
//     //         primaryKey, mapKey, paramKey, chatHistoryMapDao, ChatHistoryMap(),
//     //         status: status));

//     //Server call
//     if (isConnectedToInternet) {
//       final PsResource<List<ChatHistory>> _resource =
//           await _psApiService.getChatHistoryList(holder.toMap());

//       //   print('Param Key $paramKey');
//       if (_resource.status == PsStatus.SUCCESS) {
//         // Create Map List
//         final List<ChatHistoryMap> chatHistoryMapList = <ChatHistoryMap>[];
//         int i = 0;
//         for (ChatHistory data in _resource.data) {
//           chatHistoryMapList.add(ChatHistoryMap(
//               id: data.id + paramKey,
//               mapKey: paramKey,
//               chatHistoryId: data.id,
//               sorting: i++,
//               addedDate: '2020'));
//         }

//         // Delete and Insert Map Dao
//         print('Delete Key $paramKey');
//         await chatHistoryMapDao
//             .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
//         print('Insert All Key $paramKey');
//         await chatHistoryMapDao.insertAll(primaryKey, chatHistoryMapList);

//         // Insert ChatHistory
//         await _chatHistoryDao.insertAll(primaryKey, _resource.data);
//         } else if (_resource.status == PsStatus.ERROR &&
//           _resource.message == 'No more records') {
//         // Delete and Insert Map Dao
//         await chatHistoryMapDao
//             .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
//         }

//         // Load updated Data from Db and Send to UI
//         sinkchatHistoryListStream(
//           chatHistoryListStream,
//           await _chatHistoryDao.getAllByMap(primaryKey, mapKey, paramKey,
//               chatHistoryMapDao, ChatHistoryMap()));

//         final dynamic subscription = await _chatHistoryDao.getAllWithSubscriptionWithHolder(
//         primaryKey:  primaryKey,mapKey: mapKey,paramKey: paramKey,
//         mapDao:  chatHistoryMapDao, mapObj:ChatHistoryMap(),
//         status: PsStatus.SUCCESS,
//         onDataUpdated: (List<ChatHistory> productList) async{
//           if (status != null && status != PsStatus.NOACTION) {
//             print(status);
//             chatHistoryListStream.sink.add(PsResource<List<ChatHistory>>(status, '', productList));

//           } else {
//             print('No Action');
//           }
//         });

//     return subscription;
//   }

// }

  Future<dynamic> getChatHistoryListFromDB(
      StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ChatHistoryParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ChatHistoryMapDao chatHistoryMapDao = ChatHistoryMapDao.instance;

    // Load from Db and Send to UI
    // sinkchatHistoryListStream(
    //     chatHistoryListStream,
    //     await _chatHistoryDao.getAllByMap(
    //         primaryKey, mapKey, paramKey, chatHistoryMapDao, ChatHistoryMap()));

    final dynamic subscription =
        await _chatHistoryDao.getAllWithSubscriptionByMap(
            primaryKey: primaryKey,
            mapKey: mapKey,
            paramKey: paramKey,
            mapDao: chatHistoryMapDao,
            mapObj: ChatHistoryMap(),
            status: PsStatus.SUCCESS,
            onDataUpdated: (PsResource<List<ChatHistory>> resultList) {
              print('***<< Data Updated >>***');
              if ( status != PsStatus.NOACTION) {
                print(status);
                chatHistoryListStream.sink.add(resultList);
              } else {
                print('No Action');
              }
            });

    return subscription;
  }

  Future<dynamic> getChatHistoryList(
      StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ChatHistoryParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ChatHistoryMapDao chatHistoryMapDao = ChatHistoryMapDao.instance;

    // Load from Db and Send to UI
    sinkchatHistoryListStream(
        chatHistoryListStream,
        await _chatHistoryDao.getAllByMap(
            primaryKey, mapKey, paramKey, chatHistoryMapDao, ChatHistoryMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<ChatHistory>> _resource =
          await _psApiService.getChatHistoryList(holder.toMap());

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ChatHistoryMap> chatHistoryMapList = <ChatHistoryMap>[];
        int i = 0;
        for (ChatHistory data in _resource.data!) {
          chatHistoryMapList.add(ChatHistoryMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              chatHistoryId: data.id,
              sorting: i++,
              addedDate: '2020'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await chatHistoryMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await chatHistoryMapDao.insertAll(primaryKey, chatHistoryMapList);

        // Insert ChatHistory
        await _chatHistoryDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          // Delete and Insert Map Dao
          await chatHistoryMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }
      // Load updated Data from Db and Send to UI
      sinkchatHistoryListStream(
          chatHistoryListStream,
          await _chatHistoryDao.getAllByMap(primaryKey, mapKey, paramKey,
              chatHistoryMapDao, ChatHistoryMap()));
    }
  }

  Future<dynamic> getNextPageChatHistoryList(
      StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ChatHistoryParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ChatHistoryMapDao chatHistoryMapDao = ChatHistoryMapDao.instance;
    // Load from Db and Send to UI
    sinkchatHistoryListStream(
        chatHistoryListStream,
        await _chatHistoryDao.getAllByMap(
            primaryKey, mapKey, paramKey, chatHistoryMapDao, ChatHistoryMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ChatHistory>> _resource =
          await _psApiService.getChatHistoryList(holder.toMap());

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ChatHistoryMap> chatHistoryMapList = <ChatHistoryMap>[];
        final PsResource<List<ChatHistoryMap>>? existingMapList =
            await chatHistoryMapDao.getAll(
                finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (ChatHistory data in _resource.data!) {
          chatHistoryMapList.add(ChatHistoryMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              chatHistoryId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await chatHistoryMapDao.insertAll(primaryKey, chatHistoryMapList);

        // Insert ChatHistory
        await _chatHistoryDao.insertAll(primaryKey, _resource.data!);
      }
      sinkchatHistoryListStream(
          chatHistoryListStream,
          await _chatHistoryDao.getAllByMap(primaryKey, mapKey, paramKey,
              chatHistoryMapDao, ChatHistoryMap()));
    }
  }

  Future<PsResource<ChatHistory>> postChatHistory(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ChatHistory> _resource =
        await _psApiService.syncChatHistory(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  // Future<PsResource<ChatHistory>> getChatHistory(Map<dynamic, dynamic> jsonMap,
  //     bool isConnectedToInternet, PsStatus status,
  //     {bool isLoadFromServer = true}) async {
  //   final PsResource<ChatHistory> _resource =
  //       await _psApiService.getChatHistory(jsonMap);
  //   if (_resource.status == PsStatus.SUCCESS) {
  //     return _resource;
  //   } else {
  //     final Completer<PsResource<ChatHistory>> completer =
  //         Completer<PsResource<ChatHistory>>();
  //     completer.complete(_resource);
  //     return completer.future;
  //   }
  // }

  Future<dynamic> getChatHistory(
      StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream,
      GetChatHistoryParameterHolder holder,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    sinkchatHistoryListStream(
        chatHistoryListStream, await _chatHistoryDao.getAll(status: status));
    final PsResource<ChatHistory> _resource =
        await _psApiService.getChatHistory(holder.toMap());
    if (_resource.status == PsStatus.SUCCESS) {
      // await _chatHistoryDao.deleteAll();
      final Finder resetUnreadFinder =
          Finder(filter: Filter.equals('id', _resource.data!.id));
      await _chatHistoryDao.update(_resource.data!, finder: resetUnreadFinder);

      // sinkchatHistoryListStream(chatHistoryListStream, await _chatHistoryDao.getAll());

      // return _resource;
    } else {
      if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
        // Delete and Insert Map Dao
        await _chatHistoryDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
      }
    }

    final dynamic subscription = await _chatHistoryDao.getAllWithSubscription(
        status: PsStatus.SUCCESS,
        onDataUpdated: (List<ChatHistory> message) {
          if ( status != PsStatus.NOACTION) {
            print(status);
            chatHistoryListStream.sink
                .add(PsResource<List<ChatHistory>>(status, '', message));
          } else {
            print('No Action');
          }
        });

    return subscription;
  }

  Future<dynamic> getChatHistoryForOne(
      StreamController<PsResource<ChatHistory>> chatHistoryStream,
      GetChatHistoryParameterHolder holder,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ChatHistory> _resource =
        await _psApiService.getChatHistory(holder.toMap());

    if (_resource.status == PsStatus.SUCCESS) {
      sinkChatHistoryStream(chatHistoryStream, _resource);
      return _resource;
    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> resetUnreadCount(
      StreamController<PsResource<List<ChatHistory>>> resetUnreadCountStream,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkResetUnreadCountStream(
        resetUnreadCountStream,
        await _chatHistoryDao.getAll(
          status: status,
        ));
    final PsResource<ChatHistory> _resource =
        await _psApiService.resetUnreadMessageCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      final Finder resetUnreadFinder =
          Finder(filter: Filter.equals('id', _resource.data!.id));
      //require to know message count once
      await _chatHistoryDao.update(_resource.data!, finder: resetUnreadFinder);
      // return _chatHistoryDao.getAll();

    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ChatHistory>> postAcceptedOffer(
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ChatHistory> _resource =
        await _psApiService.acceptedOffer(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ChatHistory>> postRejectedOffer(
      Map<dynamic, dynamic> jsonMap,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ChatHistory> _resource =
        await _psApiService.rejectedOffer(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> makeMarkAsSold(
      StreamController<PsResource<ChatHistory>> chatHistoryStream,
      String loginUserId,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkChatHistoryStream(
        chatHistoryStream,
        await _chatHistoryDao.getOne(
          status: status,
        ));
    final PsResource<ChatHistory> _resource =
        await _psApiService.makeMarkAsSold(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      // await _chatHistoryDao.deleteAll();
      await _chatHistoryDao.insert(primaryKey, _resource.data!);
      sinkChatHistoryStream(chatHistoryStream, await _chatHistoryDao.getOne());

      // return _resource;
    } else {
      final Completer<PsResource<ChatHistory>> completer =
          Completer<PsResource<ChatHistory>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

      Future<PsResource<ApiStatus>> makeUserBoughtItem(
      String loginUserId,
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.makeUserBoughtItem(jsonMap, loginUserId);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }
}
