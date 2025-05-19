import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
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
  CommentResponseModel? commentResponse;
  TextEditingController commentController = TextEditingController();
  List<CommentModel> comments = [];

  SearchCubit(this.searchRepo) : super(SearchInitial());

  SearchModel? searchModel;

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
        Print.error(l);
        if (!isClosed) emit(SearchError(message: l));
      },
      (r) {
        searchModel = r;
        Print.success('Search results fetched successfully');
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
        Print.error(l);
        if (!isClosed) emit(SearchHistoryError(message: l));
      },
      (r) {
        searchHistoryModel = r;
        Print.success('Search history fetched successfully');
        if (!isClosed) emit(SearchHistorySuccess());
      },
    );
  }

  Future<void> deleteSearchHistory({required int id}) async {
    if (!isClosed) emit(DeleteSearchHistoryLoading());
    final response = await searchRepo.deleteSearchHistory(id: id);
    response.fold(
      (l) {
        Print.error(l);
        if (!isClosed) emit(DeleteSearchHistoryError(message: l));
      },
      (r) {
        Print.success('Search history deleted successfully');
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
        Print.error(l);
        if (!isClosed) emit(GoToProductError(message: l));
      },
      (r) async {
        productModel = r;
        Print.success('You are going to product ========> successfully');
        getRecentView();
        await fetchParentComments(productId: id);
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
        Print.error(l);
        if (!isClosed) emit(RecentViewError(message: l));
      },
      (r) {
        recentViewModel = r;
        Print.success('Recent views fetched successfully');
        if (!isClosed) emit(RecentViewSuccess());
      },
    );
  }

  Future<void> clearHistory() async {
    if (!isClosed) emit(ClearHistoryLoading());
    final response = await searchRepo.clearHistory();
    response.fold(
      (l) {
        Print.error(l);
        if (!isClosed) emit(ClearHistoryError(message: l));
      },
      (r) {
        Print.success('Search history deleted successfully');
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
        Print.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = r.data.comments;
        Print.success('Parent comments fetched successfully');
        if (kDebugMode) {
          print('Set comments: $comments');
        }
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  int? currentParentId;

  Future<void> fetchChildComments({required int parentId}) async {
    currentParentId = parentId;
    if (!isClosed) emit(CommentLoading());
    final response =
        await sl<CommentRepo>().fetchChildComments(parentId: parentId);
    response.fold(
      (l) {
        currentParentId = null;
        Print.error(l);
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
        Print.success('Child comments fetched successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> addComment({required int productId, int? parentId}) async {
    if (!isClosed) emit(CommentLoading());
    final response = await sl<CommentRepo>().addComment(
      productId: productId,
      comment: commentController.text,
      parentId: parentId,
    );
    response.fold(
      (l) {
        Print.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = [...comments, ...r.data.comments];
        Print.success('Comment added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
        commentController.clear();
      },
    );
  }

  Future<void> addReply({
    required int productId,
    required int parentId,
    required String comment,
  }) async {
    if (!isClosed) emit(CommentLoading());
    final response = await sl<CommentRepo>().addComment(
      productId: productId,
      comment: comment,
      parentId: parentId,
    );
    response.fold(
      (l) {
        Print.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.map((c) {
          if (c.commentId == parentId) {
            // Explicitly type as List<CommentModel>
            final updatedReplies = <CommentModel>[
              ...(c.replies ?? []),
              ...r.data.comments,
            ];
            return c.copyWith(replies: updatedReplies);
          }
          return c;
        }).toList();
        Print.success('Reply added successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
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
        Print.error(l);
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
        Print.success('Comment updated successfully');
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
        Print.error(l);
        if (!isClosed) emit(CommentError(message: l));
      },
      (r) {
        comments = comments.where((c) => c.commentId != commentId).map((c) {
          final newReplies =
              c.replies?.where((r) => r.commentId != commentId).toList();
          return c.copyWith(replies: newReplies);
        }).toList();
        Print.success('Comment deleted successfully');
        if (!isClosed) emit(CommentsLoaded(comments));
      },
    );
  }

  Future<void> toggleLike({required int commentId}) async {
    if (!isClosed) emit(CommentLoading());

    // Optimistically toggle isLiked for immediate UI feedback
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
        // Revert optimistic update on failure
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

  @override
  Future<void> close() {
    commentController.dispose();
    return super.close();
  }
}
