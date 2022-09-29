import 'package:get_it/get_it.dart';

import 'core/network/network_info.dart';

import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_remote_storage.dart';
import 'features/chat/data/datasources/maps_servcice.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/get_chat_with_one_time_read.dart';
import 'features/chat/domain/usecases/get_chat_with_real_time_changes.dart';
import 'features/chat/domain/usecases/send_file_message.dart';
import 'features/chat/domain/usecases/send_location_message.dart';
import 'features/chat/domain/usecases/send_text_message.dart';
import 'features/chat/presentation/providers/chat.dart';

final sl = GetIt.instance;

Future<void> init() async {
/////////////////////////////////////////////// !!!! Features - chat !!!! /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Provider

  sl.registerFactory(() => Chat(
        getChatStream: sl(),
        getChatOnce: sl(),
        sendUserTextMessage: sl(),
        sendUserFileMessage: sl(),
        sendUserLocationMessage: sl(),
      ));

// Usecases

  sl.registerLazySingleton(() => GetChatWithRealTimeChangesUsecase(sl()));
  sl.registerLazySingleton(() => GetChatWithOneTimeReadUsecase(sl()));
  sl.registerLazySingleton(() => SendTextMessageUsecase(sl()));
  sl.registerLazySingleton(() => SendFileMessageUsecase(sl()));
  sl.registerLazySingleton(() => SendLocationMessageUsecase(sl()));

// Repository

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        remoteDataSource: sl(),
        remoteStorage: sl(),
        mapsService: sl(),
        networkInfo: sl(),
      ));

// Datasources

  sl.registerLazySingleton<ChatRemoteDataSource>(() => ChatFirestoreImpl());
  sl.registerLazySingleton<ChatRemoteStorage>(() => ChatFirebaseStorageImpl());
  sl.registerLazySingleton<ChatMapsService>(() => ChatGoogleMapsImpl());

//////////////////////////////////////////////////// !!!! core !!!! ///////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}
