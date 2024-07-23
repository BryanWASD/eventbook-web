import 'package:eventsapp/data/dtos/response/event_response_dto.dart';
import 'package:eventsapp/presentation/pages/event_details/event_details.dart';
import 'package:eventsapp/presentation/pages/map/cubit/events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    context.read<EventsCubit>().getAllEvents();
  }

  int? userId;
  String? selectedStatus;

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Eventos'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: DropdownButton<String>(
              value: selectedStatus,
              hint: const Text('Filtrar por estado'),
              items: <String>['completed', 'inactive', 'canceled', 'active']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventsError) {
            return const Center(child: Text('Error al cargar eventos'));
          }
          if (state is EventsEmpty) {
            return const Center(child: Text('No hay eventos disponibles'));
          }
          if (state is EventsSuccess) {
            List<EventResponseDto> events = state.events!;

            if (selectedStatus != null) {
              events = events.where((event) {
                return event.status == selectedStatus;
              }).toList();
            }

            final List<EventResponseDto> createdByMeEvents =
                events.where((event) {
              return event.createdBy == userId;
            }).toList();

            final List<EventResponseDto> registeredEvents =
                events.where((event) {
              return event.users != null &&
                  event.users!.any((user) => user.id == userId);
            }).toList();

            return ListView(
              children: [
                if (createdByMeEvents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No has creado ningún evento.'),
                  )
                else
                  ...createdByMeEvents.map((event) {
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.date),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetails(
                              title: event.name,
                              description: event.description,
                              date: event.date,
                              time: event.time,
                              locationName: event.locationName,
                              cost: event.cost,
                              status: event.status,
                              id: event.id,
                              specialGuests: event.specialGuests,
                              latitude: event.latitude,
                              longitude: event.longitude,
                              createdBy: event.createdBy,
                              users: event.users,
                              userId: userId!,
                            ),
                          ),
                        );
                      },
                    );
                  }),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Eventos registrados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (registeredEvents.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No estás registrado en ningún evento.'),
                  )
                else
                  ...registeredEvents.map((event) {
                    return ListTile(
                      title: Text(event.name),
                      subtitle: Text(event.date),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetails(
                              title: event.name,
                              description: event.description,
                              date: event.date,
                              time: event.time,
                              locationName: event.locationName,
                              cost: event.cost,
                              status: event.status,
                              id: event.id,
                              specialGuests: event.specialGuests,
                              latitude: event.latitude,
                              longitude: event.longitude,
                              createdBy: event.createdBy,
                              users: event.users,
                              userId: userId,
                            ),
                          ),
                        );
                      },
                    );
                  }),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
