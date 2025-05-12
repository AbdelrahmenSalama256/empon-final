class CommentModel {
  final int commentId;
  final int userId;
  final String? userImage;
  final String userName;
  final String time;
  final String comment;
  final bool isLiked;
  final int likesCount;
  final List<CommentModel>? replies;

  CommentModel({
    required this.commentId,
    required this.userId,
    this.userImage,
    required this.userName,
    required this.time,
    required this.comment,
    required this.isLiked,
    required this.likesCount,
    this.replies,
  });

  CommentModel copyWith({
    int? commentId,
    int? userId,
    String? userImage,
    String? userName,
    String? time,
    String? comment,
    bool? isLiked,
    int? likesCount,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      time: time ?? this.time,
      comment: comment ?? this.comment,
      isLiked: isLiked ?? this.isLiked,
      likesCount: likesCount ?? this.likesCount,
      replies: replies ?? this.replies,
    );
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_id'] as int,
      userId: json['user_id'] as int,
      userImage: json['user_image'] as String?,
      userName: json['user_name'] as String,
      time: json['time'] as String,
      comment: json['comment'] as String,
      isLiked: json['is_liked'] as bool,
      likesCount: json['likes_count'] as int,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((reply) => CommentModel.fromJson(reply as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'user_id': userId,
      'user_image': userImage,
      'user_name': userName,
      'time': time,
      'comment': comment,
      'is_liked': isLiked,
      'likes_count': likesCount,
      'replies': replies?.map((reply) => reply.toJson()).toList(),
    };
  }
}

class CommentResponseModel {
  final bool success;
  final String message;
  final CommentData data;
  final int currentPage;
  final int lastPage;
  final int total;

  const CommentResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) {
    return CommentResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: CommentData.fromJson(json['data'] as Map<String, dynamic>),
      currentPage: (json['current_page'] as int?) ?? 1,
      lastPage: (json['last_page'] as int?) ?? 1,
      total: (json['total'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'current_page': currentPage,
      'last_page': lastPage,
      'total': total,
    };
  }
}

class CommentData {
  final List<CommentModel> comments;

  const CommentData({required this.comments});

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      comments: (json['comments'] as List<dynamic>?)
              ?.map(
                  (item) => CommentModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
