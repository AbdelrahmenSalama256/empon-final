import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/data/model/product_variation.dart';
import 'package:embone/features/client/product_Details/data/model/releated_model.dart';
import 'package:embone/features/client/product_Details/data/repo/comment_repo.dart';
import 'package:embone/features/client/search/data/model/search_history_model.dart';
import 'package:embone/features/client/search/data/model/search_model.dart';
import 'package:embone/features/client/search/data/model/search_recent_view.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../product_Details/data/model/product_model.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;
  ProductModel? productModel;
  List<ProductVariation>? variations;
  ServiceModel? serviceModel;
  CommentResponseModel? commentResponse;
  TextEditingController commentController = TextEditingController();
  List<CommentModel> comments = [];
  int productsCurrentPage = 1;
  int productsLimit = 10;
  bool productsHasMore = true;
  bool productsIsLoadingMore = false;
  RelatedProductsModel? homeModel;
  int? currentParentId;
  int? servicecurrentParentId;
  int? replyParentId; // Tracks which comment/reply is being replied to

  SearchCubit(this.searchRepo) : super(SearchInitial());

  SearchModel? searchModel;

  void setReplyParentId(int? parentId) {
    replyParentId = parentId;
    emit(CommentsLoaded(comments)); // Trigger rebuild
  }

  void init() {
    fetchSearchHistory();
    getRecentView();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      if (!isClosed) emit(SearchInitial());
      return;
    }
    if (!isClosed) emit(SearchLoading());
    final response = await searchRepo.searchProducts(query);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(SearchError(message: l));
      },
      (r) {
        searchModel = r;
        PrintUtil.success('Search results fetched successfully');
        if (!isClosed) emit(SearchSuccess());
      },
    );
  }

  void clearSearch() {
    searchModel = null;
    if (!isClosed) emit(SearchInitial());
  }

  SearchHistoryModel? searchHistoryModel;

  Future<void> fetchSearchHistory() async {
    if (!isClosed) emit(SearchHistoryLoading());
    final response = await searchRepo.getSearchHistory();
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(SearchHistoryError(message: l));
      },
      (r) {
        searchHistoryModel = r;
        PrintUtil.success('Search history fetched successfully');
        if (!isClosed) emit(SearchHistorySuccess());
      },
    );
  }

  Future<void> deleteSearchHistory({required int id}) async {
    if (!isClosed) emit(DeleteSearchHistoryLoading());
    final response = await searchRepo.deleteSearchHistory(id: id);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(DeleteSearchHistoryError(message: l));
      },
      (r) {
        PrintUtil.success('Search history deleted successfully');
        if (!isClosed) emit(DeleteSearchHistorySuccess());
        fetchSearchHistory();
      },
    );
  }

  Future<void> goToProduct({required int id}) async {
    if (!isClosed) emit(GoToProductLoading());
    final response = await searchRepo.goToProduct(id: id);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(GoToProductError(message: l));
      },
      (r) async {
        productModel = r;
        PrintUtil.success('You are going to product ========> successfully');
        getRecentView();
        await fetchParentComments(productId: id);
        if (!isClosed) emit(GoToProductSuccess());
      },
    );
  }

  Future<void> goToService({required int id}) async {
    if (!isClosed) emit(GoToProductLoading());
    final response = await searchRepo.goToService(id: id);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(GoToProductError(message: l));
      },
      (r) async {
        PrintUtil.debug('Raw response for service $id: $r');
        serviceModel = r;
        PrintUtil.success('You are going to service ========> successfully');
        getRecentView();
        await servicefetchParentComments(ser: id);
        if (!isClosed) emit(GoToProductSuccess());
      },
    );
  }

  RecentViewModel? recentViewModel;

  Future<void> getRecentView() async {
    if (!isClosed) emit(RecentViewLoading());
    final response = await searchRepo.getRecentView();
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(RecentViewError(message: l));
      },
      (r) {
        recentViewModel = r;
        PrintUtil.success('Recent views fetched successfully');
        if (!isClosed) emit(RecentViewSuccess());
      },
    );
  }

  Future<void> clearHistory() async {
    if (!isClosed) emit(ClearHistoryLoading());
    final response = await searchRepo.clearHistory();
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(ClearHistoryError(message: l));
      },
      (r) {
        PrintUtil.success('Search history deleted successfully');
        if (!isClosed) emit(ClearHistorySuccess());
        init();
      },
    );
  }

  Future<void> fetchParentComments({required int productId}) async {
    if (!isClosed) emit(CommentLoading());
    final response =
        await sl<CommentRepo>().fetchParentComments(productId: productId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = r.data.comments;
        PrintUtil.success('Parent comments fetched successfully');
        if (kDebugMode) {
          print('Set comments: $comments');
        }
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> fetchChildComments({required int parentId}) async {
    currentParentId = parentId;
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response =
        await sl<CommentRepo>().fetchChildComments(parentId: parentId);
    response.fold(
      (l) {
        currentParentId = null;
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        currentParentId = null;
        comments = comments.map((comment) {
          if (comment.commentId == parentId) {
            return comment.copyWith(replies: r.data.comments);
          }
          return comment;
        }).toList();
        PrintUtil.success('Child comments fetched successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> addComment({required int productId, int? parentId}) async {
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response = await sl<CommentRepo>().addComment(
      productId: productId,
      comment: commentController.text,
      parentId: parentId,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = [...comments, ...r.data.comments];
        PrintUtil.success('Comment added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
        commentController.clear();
        replyParentId = null; // Clear reply state
      },
    );
  }

  Future<void> addReply({
    required int productId,
    required int parentId,
    required String comment,
  }) async {
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response = await sl<CommentRepo>().addComment(
      productId: productId,
      comment: comment,
      parentId: parentId,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.map((c) {
          if (c.commentId == parentId) {
            final updatedReplies = <CommentModel>[
              ...(c.replies ?? []),
              ...r.data.comments,
            ];
            return c.copyWith(replies: updatedReplies);
          }
          return c;
        }).toList();
        PrintUtil.success('Reply added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
        commentController.clear();
        replyParentId = null; // Clear reply state
      },
    );
  }

  Future<void> updateComment({
    required int commentId,
    required String comment,
  }) async {
    if (!isClosed) emit(CommentLoading());
    final response = await sl<CommentRepo>().updateComment(
      commentId: commentId,
      comment: comment,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        final updated = r.data.comments.first;
        comments = comments.map((c) {
          if (c.commentId == commentId) {
            return updated;
          }
          final updatedReplies = c.replies?.map((r) {
            if (r.commentId == commentId) {
              return updated;
            }
            return r;
          }).toList();
          return c.copyWith(replies: updatedReplies);
        }).toList();
        PrintUtil.success('Comment updated successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> deleteComment({required int commentId}) async {
    if (!isClosed) emit(CommentLoading());
    final response =
        await sl<CommentRepo>().deleteComment(commentId: commentId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.where((c) => c.commentId != commentId).map((c) {
          final newReplies =
              c.replies?.where((r) => r.commentId != commentId).toList();
          return c.copyWith(replies: newReplies);
        }).toList();
        PrintUtil.success('Comment deleted successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> toggleLike({required int commentId}) async {
    if (!isClosed) emit(CommentLoading());

    bool found = false;
    comments = comments.map((comment) {
      if (comment.commentId == commentId) {
        found = true;
        return comment.copyWith(
          isLiked: !comment.isLiked,
          likesCount: !comment.isLiked
              ? comment.likesCount + 1
              : comment.likesCount - 1,
        );
      }
      if (comment.replies != null && comment.replies!.isNotEmpty) {
        final updatedReplies = comment.replies!.map((reply) {
          if (reply.commentId == commentId) {
            found = true;
            return reply.copyWith(
              isLiked: !reply.isLiked,
              likesCount:
                  !reply.isLiked ? reply.likesCount + 1 : reply.likesCount - 1,
            );
          }
          return reply;
        }).toList();
        return comment.copyWith(replies: updatedReplies);
      }
      return comment;
    }).toList();

    if (!found) {
      PrintUtil.error('Comment with ID $commentId not found');
      if (!isClosed) emit(CommentError(message: 'Comment not found'));
      return;
    }

    final response = await sl<CommentRepo>().toggleLike(commentId: commentId);
    response.fold(
      (l) {
        comments = comments.map((comment) {
          if (comment.commentId == commentId) {
            return comment.copyWith(
              isLiked: !comment.isLiked,
              likesCount: !comment.isLiked
                  ? comment.likesCount + 1
                  : comment.likesCount - 1,
            );
          }
          if (comment.replies != null && comment.replies!.isNotEmpty) {
            final updatedReplies = comment.replies!.map((reply) {
              if (reply.commentId == commentId) {
                return reply.copyWith(
                  isLiked: !reply.isLiked,
                  likesCount: !reply.isLiked
                      ? reply.likesCount + 1
                      : reply.likesCount - 1,
                );
              }
              return reply;
            }).toList();
            return comment.copyWith(replies: updatedReplies);
          }
          return comment;
        }).toList();
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (success) {
        PrintUtil.success(
            'Like toggled successfully for commentId: $commentId');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> servicefetchParentComments({required int ser}) async {
    if (!isClosed) emit(CommentLoading());
    final response =
        await sl<CommentRepo>().serviceFetchParentComments(serviceId: ser);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = r.data.comments;
        PrintUtil.success('Parent comments fetched successfully');
        if (kDebugMode) {
          print('Set comments: $comments');
        }
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> servicefetchChildComments({required int parentId}) async {
    servicecurrentParentId = parentId;
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response =
        await sl<CommentRepo>().serviceFetchChildComments(parentId: parentId);
    response.fold(
      (l) {
        servicecurrentParentId = null;
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        servicecurrentParentId = null;
        comments = comments.map((comment) {
          if (comment.commentId == parentId) {
            return comment.copyWith(replies: r.data.comments);
          }
          return comment;
        }).toList();
        PrintUtil.success('Child comments fetched successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> serviceAddComment(
      {required int serviceId, int? parentId}) async {
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response = await sl<CommentRepo>().serviceAddComment(
      serviceId: serviceId,
      comment: commentController.text,
      parentId: parentId,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = [...comments, ...r.data.comments];
        PrintUtil.success('Comment added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
        commentController.clear();
        replyParentId = null; // Clear reply state
      },
    );
  }

  Future<void> serviceaddReply({
    required int serviceId,
    required int parentId,
    required String comment,
  }) async {
    if (!isClosed) emit(CommentLoading(parentId: parentId));
    final response = await sl<CommentRepo>().serviceAddComment(
      serviceId: serviceId,
      comment: comment,
      parentId: parentId,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.map((c) {
          if (c.commentId == parentId) {
            final updatedReplies = <CommentModel>[
              ...(c.replies ?? []),
              ...r.data.comments,
            ];
            return c.copyWith(replies: updatedReplies);
          }
          return c;
        }).toList();
        PrintUtil.success('Reply added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
        commentController.clear();
        replyParentId = null; // Clear reply state
      },
    );
  }

  Future<void> serviceupdateComment({
    required int commentId,
    required String comment,
  }) async {
    if (!isClosed) emit(CommentLoading());
    final response = await sl<CommentRepo>().serviceUpdateComment(
      commentId: commentId,
      comment: comment,
    );
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        final updated = r.data.comments.first;
        comments = comments.map((c) {
          if (c.commentId == commentId) {
            return updated;
          }
          final updatedReplies = c.replies?.map((r) {
            if (r.commentId == commentId) {
              return updated;
            }
            return r;
          }).toList();
          return c.copyWith(replies: updatedReplies);
        }).toList();
        PrintUtil.success('Comment updated successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> servicedeleteComment({required int commentId}) async {
    if (!isClosed) emit(CommentLoading());
    final response =
        await sl<CommentRepo>().serviceDeleteComment(commentId: commentId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.where((c) => c.commentId != commentId).map((c) {
          final newReplies =
              c.replies?.where((r) => r.commentId != commentId).toList();
          return c.copyWith(replies: newReplies);
        }).toList();
        PrintUtil.success('Comment deleted successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> servicetoggleLike({required int commentId}) async {
    if (!isClosed) emit(CommentLoading());

    bool found = false;
    comments = comments.map((comment) {
      if (comment.commentId == commentId) {
        found = true;
        return comment.copyWith(
          isLiked: !comment.isLiked,
          likesCount: !comment.isLiked
              ? comment.likesCount + 1
              : comment.likesCount - 1,
        );
      }
      if (comment.replies != null && comment.replies!.isNotEmpty) {
        final updatedReplies = comment.replies!.map((reply) {
          if (reply.commentId == commentId) {
            found = true;
            return reply.copyWith(
              isLiked: !reply.isLiked,
              likesCount:
                  !reply.isLiked ? reply.likesCount + 1 : reply.likesCount - 1,
            );
          }
          return reply;
        }).toList();
        return comment.copyWith(replies: updatedReplies);
      }
      return comment;
    }).toList();

    if (!found) {
      PrintUtil.error('Comment with ID $commentId not found');
      if (!isClosed) emit(CommentError(message: 'Comment not found'));
      return;
    }

    final response =
        await sl<CommentRepo>().serviceToggleLike(commentId: commentId);
    response.fold(
      (l) {
        comments = comments.map((comment) {
          if (comment.commentId == commentId) {
            return comment.copyWith(
              isLiked: !comment.isLiked,
              likesCount: !comment.isLiked
                  ? comment.likesCount + 1
                  : comment.likesCount - 1,
            );
          }
          if (comment.replies != null && comment.replies!.isNotEmpty) {
            final updatedReplies = comment.replies!.map((reply) {
              if (reply.commentId == commentId) {
                return reply.copyWith(
                  isLiked: !reply.isLiked,
                  likesCount: !reply.isLiked
                      ? reply.likesCount + 1
                      : reply.likesCount - 1,
                );
              }
              return reply;
            }).toList();
            return comment.copyWith(replies: updatedReplies);
          }
          return comment;
        }).toList();
        PrintUtil.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (success) {
        PrintUtil.success(
            'Like toggled successfully for commentId: $commentId');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> toggleServiceLike({required int serviceId}) async {
    if (!isClosed) emit(LikeServiceLoading());

    if (serviceModel?.data?.id == null || serviceModel?.data?.id != serviceId) {
      if (!isClosed) emit(LikeServiceError(message: 'Service not found'));
      return;
    }

    final service = serviceModel!.data!;
    serviceModel = ServiceModel(
      success: serviceModel!.success,
      message: serviceModel!.message,
      data: service.copyWith(
        likes: (service.likes ?? 0) + (service.isLiked ?? false ? -1 : 1),
        isLiked: !(service.isLiked ?? false),
      ),
    );

    if (!isClosed) emit(LikeServiceLoaded(serviceModel!));

    final response = await searchRepo.toggleServiceLike(serviceId: serviceId);
    response.fold(
      (l) {
        serviceModel = ServiceModel(
          success: serviceModel!.success,
          message: serviceModel!.message,
          data: service.copyWith(
            likes: (service.likes ?? 0),
            isLiked: service.isLiked,
          ),
        );
        if (!isClosed) emit(LikeServiceError(message: l));
      },
      (_) {
        if (!isClosed) emit(LikeServiceLoaded(serviceModel!));
      },
    );
  }

  Future<void> fetchReleatedProducts(
      {bool loadMore = false, required final int id}) async {
    emit(RelatedProductsLoading());
    final response = await searchRepo.getReleatedProducts(id: id);
    response.fold(
      (l) => emit(RelatedProductsError(message: l)),
      (r) {
        homeModel = r;
        PrintUtil.debug("this is related ============= $homeModel");
        emit(RelatedProductsLoaded());
      },
    );
  }

  Future<void> updateProductStatus(int productId) async {
    emit(StatusLoading());
    final result = await searchRepo.activeProduct(productId);
    result.fold(
      (failure) => emit(StatusError(failure)),
      (response) async {
        emit(StatusSuccess(response.message));
      },
    );
  }

  Future<void> updateServiceStatus(int serviceId) async {
    emit(StatusLoading());
    final result = await searchRepo.activeServise(serviceId);
    result.fold(
      (failure) => emit(StatusError(failure)),
      (response) async {
        emit(StatusSuccess(response.message));
      },
    );
  }

  Future<void> deleteService(int id) async {
    emit(DeletedLoading());
    final response = await searchRepo.deleteServise(id);
    response.fold(
      (error) => emit(DeletedError(error)),
      (r) {
        emit(Deleted());
      },
    );
  }

  Future<void> toggleProductLike({required int productId}) async {
    if (!isClosed) emit(LikeProductLoading());

    if (productModel?.data?.id != productId) {
      if (!isClosed) emit(LikeProductError(message: 'Product not found'));
      return;
    }

    final product = productModel!.data!;
    productModel = ProductModel(
      success: productModel!.success,
      message: productModel!.message,
      data: product.copyWith(
        likes: (product.likes ?? 0) + (product.isLiked ? -1 : 1),
        isLiked: !product.isLiked,
      ),
    );

    if (!isClosed) emit(LikeProductLoaded(productModel!));

    final response = await searchRepo.toggleProductLike(productId: productId);
    response.fold(
      (l) {
        productModel = ProductModel(
          success: productModel!.success,
          message: productModel!.message,
          data: product.copyWith(
            likes: (product.likes ?? 0),
            isLiked: product.isLiked,
          ),
        );
        if (!isClosed) emit(LikeProductError(message: l));
      },
      (_) {
        if (!isClosed) emit(LikeProductLoaded(productModel!));
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    emit(DeletedLoading());
    final response = await searchRepo.deleteProduct(id);
    response.fold(
      (error) => emit(DeletedError(error)),
      (r) {
        emit(Deleted());
      },
    );
  }

  Future<void> fetchVariations(
      {required int productId, required int colorId}) async {
    if (!isClosed) emit(VariationsLoading());
    final response = await searchRepo.fetchVariations(
        productId: productId, colorId: colorId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        if (!isClosed) emit(VariationsError(message: l));
      },
      (r) {
        variations = r;
        PrintUtil.success(
            'Variations fetched successfully for color ID: $colorId');
        if (!isClosed) emit(VariationsSuccess());
      },
    );
  }

  @override
  Future<void> close() {
    commentController.dispose();
    return super.close();
  }
}
