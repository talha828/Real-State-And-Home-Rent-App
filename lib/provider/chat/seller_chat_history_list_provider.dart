import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/chat_history_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/chat_history.dart';
import 'package:flutteradhouse/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutteradhouse/viewobject/holder/get_chat_history_parameter_holder.dart';

class SellerChatHistoryListProvider extends PsProvider {
  SellerChatHistoryListProvider({required ChatHistoryRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ChatHistoryListProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    chatHistoryListStream =
        StreamController<PsResource<List<ChatHistory>>>.broadcast();

    subscription = chatHistoryListStream.stream
        .listen((PsResource<List<ChatHistory>> resource) {
      updateOffset(resource.data!.length);

      _chatHistoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  // PsResource<ChatHistory> _chatHistory =
  //     PsResource<ChatHistory>(PsStatus.NOACTION, '', null);
  // PsResource<ChatHistory> get chatHistory => _chatHistory;

  final ChatHistoryParameterHolder chatFromSellerParameterHolder =
      ChatHistoryParameterHolder().getSellerHistoryList();
  bool showProgress = true;    

  ChatHistoryRepository? _repo;
  PsResource<List<ChatHistory>> _chatHistoryList =
      PsResource<List<ChatHistory>>(PsStatus.NOACTION, '', <ChatHistory>[]);

  PsResource<List<ChatHistory>> get chatHistoryList => _chatHistoryList;
 late StreamSubscription<PsResource<List<ChatHistory>>> subscription;
 late StreamController<PsResource<List<ChatHistory>>> chatHistoryListStream;
  dynamic daoSubscription;
  StreamController<PsResource<ChatHistory>>? chatHistoryStream;
  @override
  void dispose() {
        chatHistoryListStream.close();
    chatHistoryStream?.close();
    subscription.cancel();
    if (daoSubscription != null) {
      daoSubscription.cancel();
    }
    isDispose = true;
    print('ChatSellerList Provider Dispose: $hashCode');
    super.dispose();
  }

  void resetShowProgress(bool show) {
    showProgress = show;
  }

  Future<dynamic> loadChatHistoryList(ChatHistoryParameterHolder holder) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    // daoSubscription =
    await _repo!.getChatHistoryList(chatHistoryListStream, isConnectedToInternet,
        limit, offset!, PsStatus.PROGRESS_LOADING, holder);
  }

  Future<dynamic> loadChatHistoryListFromDB(
      ChatHistoryParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getChatHistoryListFromDB(
        chatHistoryListStream,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
        holder);
  }

  Future<dynamic> nextChatHistoryList(ChatHistoryParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageChatHistoryList(
          chatHistoryListStream,
          isConnectedToInternet,
          limit,
          offset!,
          PsStatus.PROGRESS_LOADING,
          holder);
    }
  }

  Future<void> resetChatHistoryList(ChatHistoryParameterHolder holder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getChatHistoryList(chatHistoryListStream, isConnectedToInternet,
        limit, offset!, PsStatus.PROGRESS_LOADING, holder);

    isLoading = false;
  }

  Future<dynamic> resetUnreadMessageCount(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    await _repo!.resetUnreadCount(chatHistoryListStream, jsonMap,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getChatHistory(
    GetChatHistoryParameterHolder holder,
  ) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;
    daoSubscription = await _repo!.getChatHistory(chatHistoryListStream, holder,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);
  }

  // Future<dynamic> postChatHistory(
  //   Map<dynamic, dynamic> jsonMap,
  // ) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   daoSubscription = await _repo.postChatHistory(
  //       jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

  //   return daoSubscription;
  // }

  // Future<dynamic> postAcceptedOffer(
  //     Map<dynamic, dynamic> jsonMap, String loginUserId) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   daoSubscription = await _repo.postAcceptedOffer(
  //       jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

  //   return daoSubscription;
  // }

  // Future<dynamic> postRejectedOffer(
  //     Map<dynamic, dynamic> jsonMap, String loginUserId) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   daoSubscription = await _repo.postRejectedOffer(
  //       jsonMap, loginUserId, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

  //   return daoSubscription;
  // }

  // Future<dynamic> makeMarkAsSoldItem(
  //     String loginUserId, MakeMarkAsSoldParameterHolder holder) async {
  //   isLoading = true;

  //   isConnectedToInternet = await Utils.checkInternetConnectivity();

  //   daoSubscription =await _repo.makeMarkAsSold(
  //     chatHistoryStream,
  //     loginUserId,
  //     holder.toMap(),
  //     isConnectedToInternet,
  //     PsStatus.PROGRESS_LOADING,
  //   );
  // }
}
