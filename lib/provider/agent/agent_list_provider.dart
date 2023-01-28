import 'dart:async';
import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/provider/common/ps_provider.dart';
import 'package:flutteradhouse/repository/user_repository.dart';
import 'package:flutteradhouse/utils/utils.dart';
import 'package:flutteradhouse/viewobject/user.dart';

class AgentListProvider extends PsProvider {
  AgentListProvider({required UserRepository? repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('AgentProvider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    agentListStream = StreamController<PsResource<List<User>>>.broadcast();
    subscription = agentListStream.stream.listen((dynamic resource) {
      updateOffset(resource.data.length);

      _agentList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<User>>> agentListStream;
  UserRepository? _repo;

  PsResource<List<User>> _agentList =
      PsResource<List<User>>(PsStatus.NOACTION, '', <User>[]);

  PsResource<List<User>> get agentList => _agentList;
 late StreamSubscription<PsResource<List<User>>> subscription;

  @override
  void dispose() {
    subscription.cancel();
    agentListStream.close();
    isDispose = true;
    print('SubCategory Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadAgentList() async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAgentList(
      agentListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );
  }

  Future<dynamic> nextAgentList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getNextPageAgentList(
        agentListStream,
        isConnectedToInternet,
        limit,
        offset!,
        PsStatus.PROGRESS_LOADING,
      );
    }
  }

  Future<void> resetAgentList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    isLoading = true;

    updateOffset(0);

    await _repo!.getAgentList(
      agentListStream,
      isConnectedToInternet,
      limit,
      offset!,
      PsStatus.PROGRESS_LOADING,
    );

    isLoading = false;
  }
}
