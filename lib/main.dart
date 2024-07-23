import 'package:dio/dio.dart';
import 'package:eventsapp/data/source/api_data.dart';
import 'package:eventsapp/presentation/pages/add_events/cubit/add_event_cubit.dart';
import 'package:eventsapp/presentation/pages/event_details/cubit/event_details_cubit.dart';
import 'package:eventsapp/presentation/pages/home/home.dart';
import 'package:eventsapp/presentation/pages/login/cubit/login_cubit.dart';
import 'package:eventsapp/presentation/pages/login/login_page.dart';
import 'package:eventsapp/presentation/pages/map/cubit/events_cubit.dart';
import 'package:eventsapp/presentation/theme/theme.dart';
import 'package:eventsapp/presentation/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId');
  final token = prefs.getString('token');
  runApp(MyApp(isLoggedIn: userId != null && token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'LexendDeca');
    MaterialTheme theme = MaterialTheme(textTheme);
    final apiClient =
        ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(apiClient),
          ),
          BlocProvider<AddEventCubit>(
            create: (context) => AddEventCubit(apiClient),
          ),
          BlocProvider<EventDetailsCubit>(
            create: (context) => EventDetailsCubit(apiClient),
          ),
          BlocProvider<EventsCubit>(
            create: (context) => EventsCubit(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: ThemeMode.system,
          theme: theme.light(),
          darkTheme: theme.dark(),
          home: isLoggedIn ? const Home() : const Login(),
        ));
  }
}
