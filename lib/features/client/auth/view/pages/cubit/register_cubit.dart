import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  // Controllers for text fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController anotherEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController cityAreaController = TextEditingController();
  final TextEditingController detailedAddressController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Variables for other data
  String? gender;
  String? country;
  String? governorate;
  String? lat;
  String? lng;
  XFile? profileImage;
  bool rememberMe = false;
  int resendSeconds = 60;
  List<ContactModel> contacts = [];
  bool isFetchingContacts = false;

  // Map text values to API IDs (replace with actual API data)
  final Map<String, String> countryIdMap = {
    'مصر': '1',
    'السعودية': '2',
    'الإمارات': '3',
    'الكويت': '4',
    'قطر': '5',
  };

  final Map<String, String> governorateIdMap = {
    'القاهرة': '1',
    'الجيزة': '2',
    'الإسكندرية': '3',
    'أسيوط': '4',
    'المنصورة': '5',
  };

  Future<void> register() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final birthDate = birthDateController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final anotherEmail = anotherEmailController.text.trim();
    final password = passwordController.text.trim();
    final passwordConfirmation = passwordConfirmationController.text.trim();
    final cityArea = cityAreaController.text.trim();
    final detailedAddress = detailedAddressController.text.trim();

    Print.info("Starting registration process...");
    Print.info("Collected data:");
    Print.info("First Name: $firstName");
    Print.info("Last Name: $lastName");
    Print.info("Birth Date: $birthDate");
    Print.info("Gender: $gender");
    Print.info("Phone: $phone");
    Print.info("Email: $email");
    Print.info("Another Email: $anotherEmail");
    Print.info("Password: $password");
    Print.info("Password Confirmation: $passwordConfirmation");
    Print.info("Country: $country");
    Print.info("Governorate: $governorate");
    Print.info("City/Area: $cityArea");
    Print.info("Detailed Address: $detailedAddress");
    Print.info("Latitude: $lat");
    Print.info("Longitude: $lng");
    Print.info("Profile Image: ${profileImage?.path}");
    Print.info("Remember Me: $rememberMe");

    Print.info("Starting validation...");

    emit(RegisterLoading());

    final response = await registerRepo.registerUser(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      gender: gender!,
      phone: phone,
      email: email,
      anotherEmail: anotherEmail,
      password: password,
      passwordConfirmation: passwordConfirmation,
      countryId: countryIdMap[country!]!, // Map to ID
      cityId: cityArea, // Assuming cityArea is a valid ID; adjust if needed
      stateId: governorateIdMap[governorate!]!, // Map to ID
      lat: lat!,
      lng: lng!,
      address: detailedAddress,
      image: profileImage,
    );

    Print.info("API call completed. Processing response...");

    response.fold(
      (l) {
        Print.error("Registration failed: $l");
        emit(RegisterError(message: l));
      },
      (r) async {
        Print.success("Registration successful!");
        // Print.success("User: ${r.data?.user?.firstName ?? ""}");
        // Print.success("Token: ${r.data?.user?.token ?? ""}");
        // await sl<CacheHelper>().saveData(
        //   key: AppConstants.token,
        //   value: r.data?.user?.token,
        // );
        // Print.success("Welcome ${r.data?.user?.firstName ?? ""}");
        emit(RegisterSuccess());
      },
    );

    Print.info("Registration process completed.");
  }

  void setProfileImage(XFile image) {
    final extension = path.extension(image.path).toLowerCase();
    if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(extension)) {
      profileImage = image;
      emit(RegisterDataUpdated(profileImage: profileImage));
    } else {
      Print.info("Invalid image format - ${image.path}");
      emit(const RegisterError(
          message: 'Image must be of type jpeg, jpg, png, gif, or svg'));
    }
  }

  void setLocation(String address, String latitude, String longitude) {
    detailedAddressController.text = address;
    lat = latitude;
    lng = longitude;
    emit(RegisterDataUpdated(lat: lat, lng: lng));
  }

  void setCountry(String? value) {
    country = value;
    emit(RegisterDataUpdated(country: country));
  }

  void setGender(String? value) {
    gender = value;
    emit(RegisterDataUpdated(gender: gender));
    Print.info("setGender called - gender: $gender");
  }

  void setGovernorate(String? value) {
    governorate = value;
    emit(RegisterDataUpdated(governorate: governorate));
  }

  void setRememberMe(bool value) {
    rememberMe = value;
    emit(RegisterDataUpdated(rememberMe: rememberMe));
  }

  void updateResendSeconds(int seconds) {
    resendSeconds = seconds;
    emit(RegisterInitial());
  }

  Future<void> fetchContacts(BuildContext context) async {
    isFetchingContacts = true;
    emit(RegisterInitial());

    final permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      try {
        final deviceContacts = await FastContacts.getAllContacts();
        contacts = deviceContacts.asMap().entries.map((entry) {
          final contact = entry.value;
          final phone = contact.phones.isNotEmpty
              ? contact.phones.first.number
              : 'no_phone'.tr(context);

          final nameParts = contact.displayName.split(' ');
          String initials = '';
          if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
            initials = nameParts[0][0];
            if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
              initials += ' ${nameParts[1][0]}';
            }
          }

          return ContactModel(
            id: entry.key.toString(),
            name: contact.displayName,
            phone: phone,
            isSelected: false,
            initial: initials,
          );
        }).toList();
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_load_contacts'.tr(context))),
        );
      }
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('contacts_permission_denied'.tr(context))),
      );
    }

    isFetchingContacts = false;
    emit(RegisterInitial());
  }

  void toggleContactSelection(String id) {
    final index = contacts.indexWhere((contact) => contact.id == id);
    if (index != -1) {
      contacts[index] = contacts[index].copyWith(
        isSelected: !contacts[index].isSelected,
      );
      emit(RegisterInitial());
    }
  }

  bool get hasSelectedContacts => contacts.any((contact) => contact.isSelected);
}
