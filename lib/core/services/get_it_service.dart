import 'package:sala_thimar/_features/client/addresses/data/repos/addresses_repo.dart';
import 'package:sala_thimar/_features/client/addresses/logic/addresses_cubit.dart';
import 'package:sala_thimar/_features/client/wallet/data/repos/wallet_repo.dart';
import 'package:sala_thimar/_features/client/wallet/logic/wallet_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sala_thimar/_features/client/account/data/repos/account_repo.dart';
import 'package:sala_thimar/_features/client/account/logic/account_cubit.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/data/repos/client_forget_password_repo.dart';
import 'package:sala_thimar/_features/client/auth/forget_password/logic/client_forget_password_cubit.dart';
import 'package:sala_thimar/_features/client/auth/login/data/repos/client_login_repo.dart';
import 'package:sala_thimar/_features/client/auth/login/logic/client_login_cubit.dart';
import 'package:sala_thimar/_features/client/auth/register/data/repos/client_register_repo.dart';
import 'package:sala_thimar/_features/client/auth/register/logic/client_register_cubit.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/data/repos/client_reset_password_repo.dart';
import 'package:sala_thimar/_features/client/auth/reset_password/logic/client_reset_password_cubit.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/data/repos/client_verify_otp_repo.dart';
import 'package:sala_thimar/_features/client/auth/verify_otp/logic/client_verify_otp_cubit.dart';
import 'package:sala_thimar/_features/client/cart/data/repos/cart_repo.dart';
import 'package:sala_thimar/_features/client/cart/logic/cart_cubit.dart';
import 'package:sala_thimar/_features/client/category_products/data/repos/category_products_repo.dart';
import 'package:sala_thimar/_features/client/category_products/logic/category_products_cubit.dart';
import 'package:sala_thimar/_features/client/favorites/data/repos/favorites_repo.dart';
import 'package:sala_thimar/_features/client/favorites/logic/favorites_cubit.dart';
import 'package:sala_thimar/_features/client/home/data/repos/home_repo.dart';
import 'package:sala_thimar/_features/client/home/logic/home_cubit.dart';
import 'package:sala_thimar/_features/client/product_details/data/repos/product_details_repo.dart';
import 'package:sala_thimar/_features/client/product_details/logic/product_details_cubit.dart';
import 'package:sala_thimar/core/caching/secure_storage_service.dart';
import 'package:sala_thimar/core/services/api_service.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(
      dio: getIt<Dio>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<ClientLoginRepo>(
    () => ClientLoginRepo(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerFactory<ClientLoginCubit>(
    () => ClientLoginCubit(getIt<ClientLoginRepo>()),
  );
  getIt.registerLazySingleton<ClientRegisterRepo>(
    () => ClientRegisterRepo(
      apiService: getIt<ApiService>(),
    ),
  );
  getIt.registerFactory<ClientRegisterCubit>(
    () => ClientRegisterCubit(getIt<ClientRegisterRepo>()),
  );
  getIt.registerLazySingleton<ClientVerifyOtpRepo>(
    () => ClientVerifyOtpRepo(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerFactoryParam<ClientVerifyOtpCubit, String, bool?>(
    (phone, isForgetPassword) => ClientVerifyOtpCubit(
      verifyOtpRepo: getIt<ClientVerifyOtpRepo>(),
      phone: phone,
      isForgetPassword: isForgetPassword ?? false,
    ),
  );
  getIt.registerLazySingleton<ClientForgetPasswordRepo>(
    () => ClientForgetPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ClientForgetPasswordCubit>(
    () => ClientForgetPasswordCubit(getIt<ClientForgetPasswordRepo>()),
  );
  getIt.registerLazySingleton<ClientResetPasswordRepo>(
    () => ClientResetPasswordRepo(getIt<ApiService>()),
  );
  getIt.registerFactoryParam<ClientResetPasswordCubit, String, String>(
    (phone, code) => ClientResetPasswordCubit(
      resetPasswordRepo: getIt<ClientResetPasswordRepo>(),
      phone: phone,
      code: code,
    ),
  );
  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<HomeRepo>()),
  );
  getIt.registerLazySingleton<ProductDetailsRepo>(
    () => ProductDetailsRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getIt<ProductDetailsRepo>()),
  );
  getIt.registerLazySingleton<CategoryProductsRepo>(
    () => CategoryProductsRepo(getIt<ApiService>()),
  );
  getIt.registerFactory<CategoryProductsCubit>(
    () => CategoryProductsCubit(getIt<CategoryProductsRepo>()),
  );
  getIt.registerLazySingleton<CartRepo>(
    () => CartRepo(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(getIt<CartRepo>()),
  );
  getIt.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepo(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AccountRepo>(
    () => AccountRepo(
      apiService: getIt<ApiService>(),
      secureStorageService: getIt<SecureStorageService>(),
    ),
  );
  getIt.registerLazySingleton<AccountCubit>(
    () => AccountCubit(getIt<AccountRepo>()),
  );
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepo>()),
  );
  getIt.registerLazySingleton<WalletRepo>(
    () => WalletRepo(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<WalletCubit>(
    () => WalletCubit(getIt<WalletRepo>()),
  );
  getIt.registerLazySingleton<AddressesRepo>(
    () => AddressesRepo(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AddressesCubit>(
    () => AddressesCubit(getIt<AddressesRepo>()),
  );
}
