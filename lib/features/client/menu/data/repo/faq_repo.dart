import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/faq_model.dart';

class FaqRepo {
  final ApiConsumer api;

  FaqRepo(this.api);

  Future<Either<String, FaqResponseModel>> fetchFaqs() async {
    try {
      final response = await api.get(EndPoints.faqs);
      final faqData = FaqResponseModel.fromJson(response.data);
      return Right(faqData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch FAQs: $e');
    }
  }
}
