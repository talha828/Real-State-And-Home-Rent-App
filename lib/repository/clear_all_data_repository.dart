import 'dart:async';

import 'package:flutteradhouse/api/common/ps_resource.dart';
import 'package:flutteradhouse/api/common/ps_status.dart';
import 'package:flutteradhouse/db/about_us_dao.dart';
import 'package:flutteradhouse/db/blog_dao.dart';
import 'package:flutteradhouse/db/category_map_dao.dart';
import 'package:flutteradhouse/db/chat_history_dao.dart';
import 'package:flutteradhouse/db/chat_history_map_dao.dart';
import 'package:flutteradhouse/db/post_type_dao.dart';
import 'package:flutteradhouse/db/product_dao.dart';
import 'package:flutteradhouse/db/product_map_dao.dart';
import 'package:flutteradhouse/db/property_type_dao.dart';
import 'package:flutteradhouse/db/rating_dao.dart';
import 'package:flutteradhouse/db/related_product_dao.dart';
import 'package:flutteradhouse/db/user_unread_message_dao.dart';
import 'package:flutteradhouse/repository/Common/ps_repository.dart';
import 'package:flutteradhouse/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final PropertyTypeDao _propertyByDao = PropertyTypeDao();
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final PostTypeDao _subCategoryDao = PostTypeDao();
    final BlogDao _blogDao = BlogDao.instance;
    final ChatHistoryDao _chatHistoryDao = ChatHistoryDao.instance;
    final ChatHistoryMapDao _chatHistoryMapDao = ChatHistoryMapDao.instance;
    final UserUnreadMessageDao _userUnreadMessageDao =
        UserUnreadMessageDao.instance;
    final RelatedProductDao _relatedProductDao = RelatedProductDao.instance;
    final AboutUsDao _aboutUsDao = AboutUsDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _propertyByDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();
    await _chatHistoryDao.deleteAll();
    await _chatHistoryMapDao.deleteAll();
    await _userUnreadMessageDao.deleteAll();
    await _relatedProductDao.deleteAll();
    await _aboutUsDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
