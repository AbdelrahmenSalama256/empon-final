// ignore_for_file: constant_identifier_names

class EndPoints {
  static const String baseUrl = "https://empon.evyx.lol/api/";
  static const String baseUrlWithoutApi = "https://empon.evyx.lol/";
  //! Login
  static const String userLogin = "${baseUrl}login";
  static const String userProfile = "${baseUrl}profile";
  static const String updateProfile = "${baseUrl}profile-update";
  static const String updatePassword = "${baseUrl}update-password";
  //! Register
  static const String userRegister = "${baseUrl}register";
  //! Verification
  static const String userVerification = "${baseUrl}verify-phone-otp";
  static const String userSendOtp = "${baseUrl}send-otp";
  static const String userConfirmCode = "${baseUrl}auth/confirm-code-register";
  static const String userResendCode = "${baseUrl}auth/password/resend_code";
  //! Logout
  static const String userLogout = "${baseUrl}logout";
  static const String deleteAccount = "${baseUrl}auth/account-deletion";
  //! Forget Password
  static const String forgetPassword = "${baseUrl}auth/password/forget_request";
  //! Forget Password Resend Code
  static const String forgetPasswordResendCode =
      "${baseUrl}auth/password/resend_code";
  //! Password Confirm Reset
  static const String passwordConfirmReset =
      "${baseUrl}auth/password/confirm_reset";
  //! Reset Password Check Otp
  static const String resetPasswordCheckOtp =
      "${baseUrl}auth/password/validate_otp";
  //! locations
  static const String countries = '${baseUrl}countries';
  static const String states = '${baseUrl}states';
  static const String cities = '${baseUrl}cities';
  static const String address = '${baseUrl}address';
  // ! Reset Password
  static const String forgotPassword = "${baseUrl}forgot-password";
  static const String verifyOtpForgotPassword =
      "${baseUrl}verify-otp-forgot-password";
  static const String resetPassword = "${baseUrl}reset-password";
  static const String home = "${baseUrl}home";
  // ! Search
  static const String search = "${baseUrl}search";
  static const String searchHistory = '${baseUrl}history-search';
  static const String goToProduct = '${baseUrl}go-to-product';
  static const String commentParent = '${baseUrl}comment/parent';
  static const String commentChild = '${baseUrl}comment/child';
  static const String comment = '${baseUrl}comment';
  static const String commentLike = '${baseUrl}comment/ilke';
  static const String recentView = '${baseUrl}recent-view';
  static const String clearHistory = '${baseUrl}history-searches';
  static const String productLike = '${baseUrl}product/ilke';

  // ! Notifications
  static const String notifications = '${baseUrl}notifications';

  // ! shop
  static const String shopNearby = '${baseUrl}homeWithLocation';

  // ! Wishlist
  static const String favorites = '${baseUrl}favourite';
  static const String addProductToWishlist = '${baseUrl}favourite/product';
  static const String addAccountToWishlist = '${baseUrl}favourite/account';

  // ! Cart
  static const String cart = '${baseUrl}carts';
  static const String addProductToCart = '${baseUrl}carts';
  static const String updateCartItemQuantity = '${baseUrl}carts';
  static const String removeCartItem = '${baseUrl}carts';
  static const String cartInfo = '${baseUrl}cart-info';

  //// Buissniss Account Case
  //! Create Account
  static const String createAccount = '${baseUrl}accounts';
  static const String createAccountStepOne = '${baseUrl}accounts/step-one';
  static const String category = '${baseUrl}category';

  // ! Contacts
  static const String checkContacts = '${baseUrl}my-contacts';
  static const String addFriend = '${baseUrl}friend-request';
  static const String friendRequests = '${baseUrl}friend-requests';
  static const String acceptFriendRequest = '${baseUrl}friend-request';
  static const String declineFriendRequest = '${baseUrl}friend-request';
  static const String myFriends = '${baseUrl}friends';
}

class ApiKey {
  static const String status = "status";
  static const String result = "result";
  static const String question = "questions";
  static const String answers = "answers";
  static const String bookingId = "booking_id";
  static const String userType = "user_type";
  static const String review = "review";
  static const String expertId = "expert_id";
  static const String success = "success";
  static const String message = "message";
  static const String totalTax = "total_tax";
  static const String expert = "expert";
  static const String data = "data";

  static const String authorization = "Authorization";
  static const String token = "token";
  static const String webtoken = "wss_token";
  static const String emailOrPhone = "email_or_phone";
  static const String emailOrCode = "email_or_code";
  static const String password = "password";
  static const String id = "id";
  static const String name = "name";
  static const String email = "email";
  static const String phone = "phone";
  static const String type = "type";
  static const String image = "image";
  static const String isActive = "is_active";
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String passwordConfirmation = "password_confirmation";
  static const String address = "address";
  static const String lon = "lon";
  static const String lat = "lat";
  static const String phoneOne = "phone_one";
  static const String phoneTwo = "phone_two";
  static const String facebook = "facebook";
  static const String tiktok = "tiktok";
  static const String twitter = "twitter";
  static const String whatsapp = "whatsapp";
  static const String avaliableTime = "avaliable_time";
  static const String tradeRegisterImage = "trade_register_image";
  static const String taxCardImage = "tax_card_image";
  static const String placeImage = "place_image";
  static const String cardImage = "card_image";
  static const String website = "website";
  static const String day = "day";
  static const String start = "start";
  static const String end = "end";
  static const String weekend = "weekend";
  static const String profilePicture = "profile_picture";
  static const String otp = "otp";
  static const String title = "title";
  static const String description = "description";
  static const String relatedBlogs = "related_blogs";
  static const String blogs = "blogs";
  static const String sliders = "sliders";
  static const String en = "en";
  static const String ar = "ar";
  static const String price = "price";
  static const String products = "products";
  static const String product = "product";
  static const String category = "category";
  static const String car = "car";
  static const String categoryId = "category_id";
  static const String instagram = "instagram";
  static const String parentBranche = "parent_branche";
  static const String isMainBranch = "is_main_branch";
  static const String redeemPoints = "redeem_points";
  static const String socialMedia = "soical_media";
  static const String mainBranch = "main_branch";
  static const String from = "from";
  static const String branchId = "branch_id";
  static const String orderDetails = "order_details";
  static const String productId = "product_id";
  static const String quantity = "quantity";
  static const String carId = "car_id";
  static const String totalPrice = "total_price";
  static const String branch = "branch";
  static const String odrderDetails = "odrder_details";
  static const String order = "order";
  static const String totalPieces = "total_pieces";
  static const String location = "location";
  static const String branchName = "branch_name";
  static const String services = "services";
  static const String winch = "winch";
  static const String winsh = "winsh";
  static const String vendor = "vendor";
  static const String vendors = "vendors";
  static const String branches = "branches";
  static const String service = "service";
  static const String slider = "slider";
  static const String nearbyPlaces = "Nearby_places";
  static const String isFav = "is_favorite";
  static const String points = "points";
  static const String code = "code";
  static const String value = "value";
  static const String userId = "user_id";
  static const String vendorId = "vendor_id";
  static const String vouchers = "vouchers";
  static const String currentPassword = "current_password";
  static const String newPassword = "new_password";
  static const String newPasswordConfirmation = "new_password_confirmation";
  static const String key = "key";
  static const String settings = "settings";
  static const String totalUserPoints = "Total User Points";
  static const String couponPoints = "Coupon Points";
  static const String mostView = "most_view";
  static const String remainingDays = "remaining_days";
  static const String verifedEmail = "verifed_email";
  static const String loginBy = "login_by";
  static const String avatar = "avatar";
  static const String avatarOriginal = "avatar_original";
  static const String emailVerified = "email_verified";
  static const String accessToken = "access_token";
  static const String wss_token = "wss_token";
  static const String tokenType = "token_type";
  static const String expiresAt = "expires_at";
  static const String user = "user";
  static const String verifyBy = "verify_by";
  static const String verificationCode = "verification_code";
  static const String tempUserId = "temp_user_id";
  static const String variant = "variant";
  static const String grandTotal = "grand_total";
  static const String ownerId = "owner_id";
  static const String subTotal = "sub_total";
  static const String cartItems = "cart_items";
  static const String auctionProduct = "auction_product";
  static const String productThumbnailImage = "product_thumbnail_image";
  static const String variation = "variation";
  static const String currencySymbol = "currency_symbol";
  static const String tax = "tax";
  static const String shippingCost = "shipping_cost";
  static const String lowerLimit = "lower_limit";
  static const String upperLimit = "upper_limit";
  static const String productName = "product_name";
  static const String qty = "qty";
  static const String categoryName = "category_name";
  static const String rating = "rating";
  static const String slug = "slug";
  static const String thumbnailImage = "thumbnail_image";
  static const String basePrice = "base_price";
  static const String productSlug = "product_slug";
  static const String wishlistId = "wishlist_id";
  static const String isInWishlist = "is_in_wishlist";
  static const String sendCodeBy = "send_code_by";
  static const String buyProduct = "buy_product";
  static const String salon = "salon";
  static const String sender = "sender";
  static const String receiver = "receiver";
  static const String reply = "reply";
}
