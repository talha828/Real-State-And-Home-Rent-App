import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/chat_history_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/api_status.dart';
import 'package:flutteradhouse/viewobject/chat_history.dart';
import 'package:flutteradhouse/viewobject/holder/get_chat_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/make_mark_as_sold_parameter_holder.dart';

class GetChatHistoryProvider extends PsProvider {
  GetChatHistoryProvider({required ChatHistoryRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('GetChatHistoryProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    chatHistoryStream = StreamController<PsResource<ChatHistory>>.broadcast();

    subscription =
        chatHistoryStream.stream.listen((PsResource<ChatHistory> resource) {
      // updateOffset(resource.data.length);

      _chatHistory = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }
  ChatHistoryRepository? _repo;
  PsResource<ChatHistory> _chatHistory =
      PsResource<ChatHistory>(PsStatus.NOACTION, '', null);

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  PsResource<ChatHistory> get chatHistory => _chatHistory;
  late StreamSubscription<PsResource<ChatHistory>> subscription;
 late  StreamController<PsResource<ChatHistory>> chatHistoryStream;
//  String _currentTimeString;

  dynamic daoSubscription;
  @override
  void dispose() {
    chatHistoryStream.close();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    subscription.cancel();
    isDispose = true;
    print('ChatHistory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> getChatHistory(
    GetChatHistoryParameterHolder holder,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _chatHistory = await _repo!.getChatHistoryForOne(
        chatHistoryStream, holder, isConnectedToInternet, PsStatus.SUCCESS);
    return _chatHistory;
  }

  Future<dynamic> postChatHistory(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    // final String _currentTimeString = Utils.getTimeString();
    // if (!isLoading && _currentTimeString != this._currentTimeString) {
      isLoading = true;
    //  this._currentTimeString = _currentTimeString;
      isConnectedToInternet = await Utils.checkInternetConnectivity();

      _chatHistory = await _repo!.postChatHistory(
          jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    //   isLoading = false;
    // }
    return _chatHistory;
  }

  Future<dynamic> postAcceptedOffer(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _chatHistory = await _repo!.postAcceptedOffer(
        jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _chatHistory;
  }

  Future<dynamic> postRejectedOffer(
      Map<dynamic, dynamic> jsonMap, String loginUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _chatHistory = await _repo!.postRejectedOffer(
        jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _chatHistory;
  }

  Future<dynamic> makeMarkAsSoldItem(
      String loginUserId, MakeMarkAsSoldParameterHolder holder) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.makeMarkAsSold(
      chatHistoryStream,
      loginUserId,
      holder.toMap(),
      isConnectedToInternet,
      PsStatus.PROGRESS_LOADING,
    );
  }

      Future<dynamic> makeUserBoughtItem(
    Map<dynamic, dynamic> jsonMap,
    String loginUserId,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo!.makeUserBoughtItem(
        loginUserId, jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
