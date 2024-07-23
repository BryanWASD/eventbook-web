import 'package:eventsapp/presentation/pages/add_events/add_events.dart';
import 'package:eventsapp/presentation/pages/events/events_page.dart';
import 'package:eventsapp/presentation/pages/login/cubit/login_cubit.dart';
import 'package:eventsapp/presentation/pages/map/map_page.dart';
import 'package:eventsapp/presentation/pages/my_events/my_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Events(),
    const AddEvents(
      isEditing: false,
    ),
    const Maps(),
    const MyEvents(),
  ];

  int? userId;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            groupAlignment: 0.0,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon: Icon(Icons.event),
                label: Text('Eventos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.add_circle_outline),
                selectedIcon: Icon(Icons.add_circle),
                label: Text('Agregar Evento'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: Text('Mapa'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.date_range_outlined),
                selectedIcon: Icon(Icons.date_range),
                label: Text('Mis Eventos'),
              ),
            ],
            trailing: userId != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            BlocProvider.of<LoginCubit>(context)
                                .logout(context);
                            setState(
                              () {
                                userId = null;
                              },
                            );
                          },
                        ),
                        const Text('Cerrar sesión')
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
