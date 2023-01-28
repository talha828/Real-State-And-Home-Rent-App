import 'package:flutter/material.dart';
import 'package:flutteradhouse/config/ps_colors.dart';
import 'package:flutteradhouse/constant/ps_constants.dart';
import 'package:flutteradhouse/provider/chat/buyer_chat_history_list_provider.dart';
import 'package:flutteradhouse/provider/chat/seller_chat_history_list_provider.dart';
import 'package:flutteradhouse/provider/chat/user_unread_message_provider.dart';
import 'package:flutteradhouse/ui/chat/list/chat_buyer_list_view.dart';
import 'package:flutteradhouse/ui/chat/list/chat_list_view_app_bar.dart';
import 'package:flutteradhouse/ui/chat/list/chat_seller_list_view.dart';
import 'package:flutteradhouse/utils/utils.dart';

int _selectedIndex = 0;

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    required this.animationController,
    required this.sellerChatHistoryListProvider,
    required this.buyerChatHistoryListProvider,
    @required this.unreadMessageProvider
  }) : super(key: key);

  final AnimationController animationController;
  final SellerChatHistoryListProvider sellerChatHistoryListProvider;
  final BuyerChatHistoryListProvider buyerChatHistoryListProvider;
  final UserUnreadMessageProvider? unreadMessageProvider;
  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final PageController _pageController =
      PageController(initialPage: _selectedIndex);

  ChatBuyerListView? chatBuyerListView;
  ChatSellerListView? chatSellerListView;    
  @override
  Widget build(BuildContext context) {
    final ChatListViewAppBar pageviewAppBar = ChatListViewAppBar(
      selectedIndex: _selectedIndex,
      onItemSelected: (int index) => setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(index,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }),
      items: <ChatListViewAppBarItem>[
        ChatListViewAppBarItem(
          title: Utils.getString(context, 'chat_history__from_seller'),
          unreadMessageProvider: widget.unreadMessageProvider,
          flag: PsConst.CHAT_FROM_SELLER,
        ),
        ChatListViewAppBarItem(
          title: Utils.getString(context, 'chat_history__from__buyer'),
          unreadMessageProvider: widget.unreadMessageProvider,
          flag: PsConst.CHAT_FROM_BUYER,
        ),
      ],
    );
    chatBuyerListView = ChatBuyerListView(
                      animationController: widget.animationController, provider: widget.buyerChatHistoryListProvider);
    chatSellerListView = ChatSellerListView(
                      animationController: widget.animationController, provider: widget.sellerChatHistoryListProvider);
    
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: PsColors.backgroundColor,
        body: Column(children: <Widget>[
          pageviewAppBar,
          Expanded(
              child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    chatSellerListView!,
                    chatBuyerListView!,
                  ],
                  onPageChanged: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  })),
        ]),
      ),
    );
  }
}
