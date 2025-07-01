import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:embone/features/client/locations/data/repo/locations_repo.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;
  final String id = DateTime.now().toString();

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

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
  bool agreeToTerms = false;
  int currentStep = 0;
  String? gender;
  LocationModel? selectedCountry;
  LocationModel? selectedState;
  LocationModel? selectedCity;
  String? lat;
  String? lng;
  XFile? profileImage;
  bool rememberMe = false;
  int resendSeconds = 60;
  List<ContactModel> contacts = [];
  bool isFetchingContacts = false;
  List<User> registeredUsers = [];
  List<ContactModel> nonRegisteredContacts = [];
  List<LocationModel> allCountries = [];
  List<LocationModel> allStates = [];
  List<LocationModel> allCities = [];
  bool hasFetchedContacts = false;
  Future<void> fetchAllLocations() async {
    emit(LocationsLoading());

    final countriesResponse = await sl<LocationRepo>().getCountries();
    countriesResponse.fold(
      (error) {
        Print.error("Failed to fetch countries: $error");
        emit(LocationsError(error));
      },
      (countries) {
        allCountries = countries;
        Print.info("Fetched ${allCountries.length} countries");
      },
    );

    final statesResponse = await sl<LocationRepo>().getStates();
    statesResponse.fold(
      (error) {
        Print.error("Failed to fetch states: $error");
        emit(LocationsError(error));
      },
      (states) {
        allStates = states;
        Print.info("Fetched ${allStates.length} states");
      },
    );

    final citiesResponse = await sl<LocationRepo>().getCities();
    citiesResponse.fold(
      (error) {
        Print.error("Failed to fetch cities: $error");
        emit(LocationsError(error));
      },
      (cities) {
        allCities = cities;
        Print.info("Fetched ${allCities.length} cities");
        emit(CountriesLoaded(allCountries));
      },
    );
  }

  List<LocationModel> getFilteredStates() {
    if (selectedCountry == null) return [];
    return allStates
        .where((state) => state.countryId == selectedCountry!.id)
        .toList();
  }

  List<LocationModel> getFilteredCities() {
    if (selectedState == null) return [];
    return allCities
        .where((city) => city.stateId == selectedState!.id)
        .toList();
  }

  void setCountry(LocationModel? country) {
    selectedCountry = country;
    selectedState = null;
    selectedCity = null;
    Print.info("Set country: ${country?.name} (ID: ${country?.id})");
    emit(CountriesLoaded(allCountries));
  }

  void setGovernorate(LocationModel? state) {
    selectedState = state;
    selectedCity = null;
    Print.info("Set governorate: ${state?.name} (ID: ${state?.id})");
    emit(StatesLoaded(getFilteredStates()));
  }

  void setCity(LocationModel? city) {
    selectedCity = city;
    Print.info("Set city: ${city?.name} (ID: ${city?.id})");

    emit(CitiesLoaded(getFilteredCities()));
  }

  void verifyOtp({String? phone}) async {
    if (!isClosed) {
      // Use phone parameter if provided, otherwise fall back to phoneController.text
      final effectivePhone = phoneController.text.trim();
      final otp = otpController.text.trim();

      Print.info("Starting OTP verification process...");
      Print.info("Phone: $effectivePhone");
      Print.info("OTP: $otp");

      if (otp.isEmpty || otp.length < 4) {
        Print.error("Invalid OTP: OTP must be at least 4 digits.");
        if (!isClosed) emit(VerifyOtpError("Please enter a valid OTP."));
        return;
      }

      if (effectivePhone.isEmpty) {
        Print.error("Phone number is empty.");
        if (!isClosed) emit(VerifyOtpError("Phone number is required."));
        return;
      }

      if (!isClosed) emit(VerifyOtpLoading());

      final response = await registerRepo.verifyAccount(
        phone: effectivePhone,
        otp: otp,
      );

      if (!isClosed) {
        response.fold(
          (error) {
            Print.error("OTP verification failed: $error");
            emit(VerifyOtpError(error));
          },
          (result) async {
            Print.success("OTP verification successful: $result");
            Print.info("Data: ${result.data}, User: ${result.data?.user}");
            if (result.data?.user?.token != null) {
              sl<CacheHelper>()
                  .setData(ApiKey.token, result.data!.user!.token!);
              sl<CacheHelper>().saveData(
                  key: AppConstants.token, value: result.data!.user!.token!);
              Print.success("Welcome ${result.data?.user?.firstName ?? ""}");
              await sl<GlobalCubit>().getUserProfile();
              otpController.clear();
              emit(VerifyOtpSuccess(result.message ?? ""));
            } else {
              Print.error(
                  "Token is missing in the response. Data: ${result.data}, User: ${result.data?.user}");
              emit(VerifyOtpError("Failed to retrieve authentication token"));
            }
          },
        );
      }
    }
  }

  Future<void> register() async {
    emit(RegisterLoading());

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
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
    Print.info("Country ID: ${selectedCountry?.id}");
    Print.info("State ID: ${selectedState?.id}");
    Print.info("City ID: ${selectedCity?.id}");
    Print.info("City/Area: $cityArea");
    Print.info("Detailed Address: $detailedAddress");
    Print.info("Latitude: $lat");
    Print.info("Longitude: $lng");
    Print.info("Profile Image: ${profileImage?.path}");
    Print.info("Remember Me: $rememberMe");

    // Validation
    String? validationError;
    if (firstName.isEmpty || lastName.isEmpty) {
      validationError = "please_enter_first_last_name";
    } else if (birthDate.isEmpty) {
      validationError = "please_enter_birth_date";
    } else if (gender == null) {
      validationError = "please_select_gender";
    } else if (phone.isEmpty) {
      validationError = "please_enter_phone";
    } else if (email.isEmpty) {
      validationError = "please_enter_email";
    } else if (password.isEmpty || passwordConfirmation.isEmpty) {
      validationError = "please_enter_password";
    } else if (password != passwordConfirmation) {
      validationError = "passwords_do_not_match";
    } else if (selectedCountry == null) {
      validationError = "please_select_country";
    } else if (selectedState == null) {
      validationError = "please_select_governorate";
    } else if (selectedCity == null) {
      validationError = "please_select_city";
    } else if (lat == null || lng == null) {
      validationError = "please_select_location";
    } else if (detailedAddress.isEmpty) {
      validationError = "please_enter_detailed_address";
    }

    if (validationError != null) {
      Print.error("Validation failed: $validationError");
      emit(RegisterError(message: validationError));
      return;
    }

    final response = await registerRepo.registerUser(
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
      gender: gender!,
      phone: phone,
      email: email,
      anotherEmail: anotherEmail.isNotEmpty ? anotherEmail : null,
      password: password,
      passwordConfirmation: passwordConfirmation,
      countryId: selectedCountry!.id.toString(),
      stateId: selectedState!.id.toString(),
      cityId: selectedCity!.id.toString(),
      lat: lat!,
      lng: lng!,
      address: detailedAddress,
      image: profileImage,
    );

    response.fold(
      (error) {
        Print.error("Registration failed: $error");
        emit(RegisterError(message: error));
      },
      (result) async {
        Print.success("Registration successful!");
        emit(RegisterSuccess());
      },
    );
  }

  void setProfileImage(XFile image) {
    final extension = path.extension(image.path).toLowerCase();
    if (['.jpeg', '.jpg', '.png', '.gif', '.svg'].contains(extension)) {
      profileImage = image;
      emit(RegisterDataUpdated(profileImage: profileImage));
    } else {
      Print.info("Invalid image format - ${image.path}");
      emit(RegisterError(
          message: 'Image must be of type jpeg, jpg, png, gif, or svg'));
    }
  }

  void setLocation(String address, String latitude, String longitude) {
    detailedAddressController.text = address;
    lat = latitude;
    lng = longitude;
    Print.info("Set location: Address: $address, Lat: $lat, Lng: $lng");
    emit(RegisterDataUpdated(lat: lat, lng: lng));
  }

  void setGender(String? value) {
    gender = value;
    emit(RegisterDataUpdated(gender: gender));
    Print.info("setGender called - gender: $gender");
  }

  void setRememberMe(bool value) {
    rememberMe = value;
    emit(RegisterDataUpdated(rememberMe: rememberMe));
  }

  void updateResendSeconds(int seconds) {
    resendSeconds = seconds;

    emit(RegisterInitial());
  }

  Future<void> data(BuildContext context) async {
    emit(LoadingContacts());
    await fetchContacts(context);
    if (phoneNumbers.isNotEmpty) {
      await checkContacts(context);
    }
    emit(LoaddedContacts());
  }

  Future<void> fetchContacts(BuildContext context) async {
    if (hasFetchedContacts) return;
    isFetchingContacts = true;

    final permissionStatus = await Permission.contacts.request();
    if (!permissionStatus.isGranted) {
      Print.info("Contacts permission denied");
      if (context.mounted) {
        showToast(context,
            message: 'contacts_permission_denied'.tr(context),
            state: ToastStates.error);
      }
      emit(ContactsError('contacts_permission_denied'.tr(context)));
      isFetchingContacts = false;
      return;
    }

    try {
      final deviceContacts = await FastContacts.getAllContacts();

      // Process contacts
      final processedContacts = deviceContacts
          .asMap()
          .entries
          .map((entry) => _processContact(entry, context))
          .whereType<ContactModel>()
          .toList();

      // Remove duplicates
      final seenPhones = <String>{};
      contacts = processedContacts.where((contact) {
        final isNew = !seenPhones.contains(contact.phone);
        if (isNew) seenPhones.add(contact.phone);
        return isNew;
      }).toList();

      Print.info("Fetched ${contacts.length} cleaned contacts");
      phoneNumbers = contacts
          .map((c) => c.phone)
          .where((p) => p.isNotEmpty && p != 'no_phone'.tr(context))
          .toList();
      hasFetchedContacts = true;
    } catch (e, stackTrace) {
      Print.error("Error fetching contacts: $e\n$stackTrace");
      if (context.mounted) {
        showToast(context,
            message: 'failed_to_load_contacts'.tr(context),
            state: ToastStates.error);
      }
      emit(ContactsError('failed_to_load_contacts'.tr(context)));
    } finally {
      isFetchingContacts = false;
    }
  }

  ContactModel? _processContact(
      MapEntry<int, Contact> entry, BuildContext context) {
    final contact = entry.value;
    String phone = contact.phones.isNotEmpty
        ? contact.phones.first.number.replaceAll(RegExp(r'[^\d+]'), '')
        : 'no_phone'.tr(context);

    // Skip invalid phones
    if (phone.length < 10 || phone.contains(RegExp(r'[a-zA-Z*]'))) {
      return null;
    }

    String cleanedName = contact.displayName.replaceAll(RegExp(r'[^\w\s]'), '');
    if (cleanedName.isEmpty) cleanedName = 'Unknown';

    final nameParts = cleanedName.split(' ');
    String initials =
        nameParts.isNotEmpty && nameParts[0].isNotEmpty ? nameParts[0][0] : '';
    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      initials += nameParts[1][0];
    }

    return ContactModel(
      id: entry.key.toString(),
      name: cleanedName,
      phone: phone,
      isSelected: false,
      initial: initials,
    );
  }

  List<String> phoneNumbers = [];
  Future<void> checkContacts(BuildContext context) async {
    if (phoneNumbers.isEmpty) {
      Print.error("No phone numbers to check");
      emit(CheckingContactsError('no_phone_numbers'.tr(context)));
      return;
    }

    Print.info("Checking ${phoneNumbers.length} contacts with server");
    final response = await registerRepo.checkRegisteredContacts(
      phoneNumbers: phoneNumbers,
    );

    response.fold(
      (error) {
        Print.error("Failed to check contacts: $error");
        emit(CheckingContactsError(error));
      },
      (registeredUsersResponse) {
        registeredUsers = registeredUsersResponse;
        final registeredPhones = registeredUsersResponse
            .map((user) => user.phone ?? '')
            .where((phone) => phone.isNotEmpty)
            .toList();

        nonRegisteredContacts = contacts
            .where((contact) => !registeredPhones.contains(contact.phone))
            .toList();

        Print.info(
            "Found ${registeredUsers.length} registered and ${nonRegisteredContacts.length} unregistered contacts");
        emit(ContactsChecked(registeredUsers, nonRegisteredContacts));
      },
    );
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

  isContactSelected(String id) {
    final index = contacts.indexWhere((contact) => contact.id == id);
    if (index != -1) {
      return contacts[index].isSelected;
    }
    return false;
  }

  bool get hasSelectedContacts => contacts.any((contact) => contact.isSelected);

  void setCurrentStep(int step) {
    currentStep = step;
    emit(CurrentStepUpdated(step));
  }

  void resendOtp({required String phone}) async {
    if (isClosed) return;

    final effectivePhone = phoneController.text.trim();

    emit(ResendOtpLoading());

    final response = await registerRepo.resendOtp(phone: effectivePhone);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(ResendOtpError(error));
      },
      (result) {
        emit(ResendOtpSuccess(result.message ?? ""));
      },
    );
  }

  void verifyPhoneNumber(BuildContext context) async {
    // PrintUtil.error("invalid_phone_format");
    // emit(VerifyPhoneNumberError('invalid_phone_format'));
    // return;

    PrintUtil.success("Phone number verified: ${phoneController.text}");
    emit(VerifyPhoneNumberLoading());
    final response = await registerRepo.verifyPhoneNumber(phoneController.text);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(VerifyPhoneNumberError(error));
      },
      (result) {
        PrintUtil.success(
            "Phone number verification successful: ${result.message}");
        emit(VerifyPhoneNumberSuccess(result.message));
      },
    );
  }

  void verifyEmail(String email) async {
    PrintUtil.success("email verified: $email");
    emit(VerifyEmailLoading());
    final response = await registerRepo.verifyEmail(email);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(VerifyEmailError(error));
      },
      (result) {
        PrintUtil.success("email verification successful: ${result.message}");
        emit(VerifyEmailSuccess(result.message));
      },
    );
  }
}
