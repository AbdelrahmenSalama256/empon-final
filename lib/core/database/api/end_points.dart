// ignore_for_file: constant_identifier_names

class EndPoints {
  static const String baseUrl = "https://maxliss.evyx.lol/api/v2/";
  static const String baseUrlWithoutApi = "https://maxliss.evyx.lol/";
  //! Login
  static const String userLogin = "${baseUrl}auth/login";
  //! Register
  static const String userRegister = "${baseUrl}auth/signup";
  //! Verification
  static const String userVerification = "${baseUrl}auth/send-verification";
  static const String userConfirmCode = "${baseUrl}auth/confirm-code-register";
  static const String userResendCode = "${baseUrl}auth/password/resend_code";
  //! Logout
  static const String userLogout = "${baseUrl}auth/logout";
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
  //! Add To Cart
  static const String addToCart = "${baseUrl}carts/add";
  static const String removeFromCart = "${baseUrl}carts";
  static const String removeExpertFromCart = "${baseUrl}delete-expert";
  static const String expertReview = "${baseUrl}expert/expert-review";
  static const String checkQr = "${baseUrl}check-qr";
//! Feedback
  static const String expertSessionFeedback =
      "${baseUrl}expert/expert-user-review";
  static const String changeStatus = "${baseUrl}add-booking-status";
//! Get Reviews
  static const String getReviews = "${baseUrl}get-review";
  static const String bookingActivities = "${baseUrl}add-booking-activities";
  //! Get Cart
  static String getCart(int id) {
    return "${baseUrl}carts/get-list/$id";
  }

  //! Change Cart Product Quantity
  static const String changeCartProductQuantity = "${baseUrl}change-quantity";

  //! Home
  static const String bestSeller = "${baseUrl}products/best-selling";
  static const String featuredProduct = "${baseUrl}products/featured";
  static const String afterCareProduct =
      "${baseUrl}products/category/after-care";
  static const String sliders = "${baseUrl}sliders";
  static const String productDetails = "${baseUrl}products";
  static const String afterCare = "${baseUrl}products/category/after-care";
  static const String proteinCat = "${baseUrl}products/category/protein";

  //! bot Ask
  static const String questions = "${baseUrl}answers-questions";
  static const String history = "${baseUrl}messages-user";
  static const String sendAnswer = "${baseUrl}products-by-attribute";
  static const String expertbyCity = "${baseUrl}experts-city-expert";
  static const String salonbyCity = "${baseUrl}experts-city-salon";
  static const String bookSalon = "${baseUrl}expert/booking-salon";

  //! all Checkout
  static const String states = "${baseUrl}states";
  static const String checkAdress = "${baseUrl}check-user-address";
  static const String createOrder = "${baseUrl}order/store";
  static const String couponApply = "${baseUrl}coupon-apply";
  static const String payment = "${baseUrl}payment-types";
//! Session Last Step
  static const String sessionLastStep = "${baseUrl}last-step";
//! profile
  static const String purchaseHistory = "${baseUrl}purchase-history";
  static const String notifications = "${baseUrl}all-notification";
  static const String customerPhone = "${baseUrl}customer-service";
  static const String policy = "${baseUrl}privacy_policy";
  static const String washing = "${baseUrl}washing-instructions";
  static const String community = "${baseUrl}community/get";
  static const String expertProfile = "${baseUrl}expert/show";
  static const String purchaseHistoryDetails =
      "${baseUrl}purchase-history-details";
  static const String bookingHistoryDetails =
      "${baseUrl}expert/booking-expert/details";
  static const String purchaseHistoryitems = "${baseUrl}purchase-history-items";

  static const String cancelOrder = "${baseUrl}order/cancel";
  static const String cancelBooking =
      "${baseUrl}expert/booking-expert/change-status";
  static const String updateProfile = "${baseUrl}profile/update";
  static const String userAdresses = "${baseUrl}user/shipping/address";
  static const String userAdressesNew = "${baseUrl}user/shipping/create";
  static const String userAdressesupdate = "${baseUrl}user/shipping/update";
  static const String userAdressesDelete = "${baseUrl}user/shipping/delete";
  static const String slots = "${baseUrl}slots";
  static const String likeButton = "${baseUrl}expert/community/likes/user";
  static const String bookingHistory = "${baseUrl}expert/booking-expert";
  static const String chatBotHistory = "${baseUrl}messages-boot";
  static const String verifyEmailOrPhone =
      "${baseUrl}profile/update_email_or_phone";
  static const String verifyOTP =
      "${baseUrl}profile/update_email_or_phone/verify_otp";
  static const String updateProfilePic = "${baseUrl}profile/update-image";
  static const String expertToCart = "${baseUrl}cart-info";
  static const String getUserByAccessToken =
      "${baseUrl}get-user-by-access_token";

  //! Get Wichlist
  static const String getWichlist = "${baseUrl}wishlists";

  //! Add Wichlist
  static String addWishlist(String slug) {
    return "${baseUrl}wishlists-add-product/$slug";
  }

  static String removeFromWishlist(String slug) {
    return "${baseUrl}wishlists-remove-product/$slug";
  }
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
