import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:embone/features/business_account/product/view/widgets/service_submit_buttons.dart';
import 'package:embone/features/business_account/product/view/widgets/image_upload_section.dart';
import 'package:embone/features/business_account/product/view/widgets/service_basic_info_section.dart';
import 'package:embone/features/business_account/product/view/widgets/service_details_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddServiceForm extends StatefulWidget {
  const AddServiceForm({
    super.key,
  });

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ServiceCubit(sl<ServiceRepo>())..getServiceCategories(),
      child: BlocListener<ServiceCubit, ServiceState>(
        listener: (context, state) {
          if (state is ServiceSuccess){
             showToast(context,
                message: state.model.message!, state: ToastStates.success);
            Navigator.pop(context);
          }
          if (state is ServiceLoading){
            const Center(child: CircularProgressIndicator());
          }
        },
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Service information
              const ServiceBasicInfoSection(),

              // Image upload sections
              const ImageUploadSection(cubit: false),

              // Service details
              const ServiceDetailsSection(),

              // Submit buttons
              ServiceSubmitButtons(formKey: formKey),
            ],
          ),
        ),
      ),
    );
  }
}
