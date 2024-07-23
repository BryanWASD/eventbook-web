import 'package:eventsapp/presentation/pages/event_details/event_details.dart';
import 'package:eventsapp/presentation/pages/events/widgets/events_card.dart';
import 'package:eventsapp/presentation/pages/map/cubit/events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  int? userId;
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _clearDateSelection() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventsCubit()..getAllEvents(),
        )
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                if (selectedDate != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearDateSelection,
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    if (state is EventsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is EventsSuccess) {
                      final events = state.events!.where((event) {
                        if (selectedDate == null) {
                          return true;
                        }
                        final eventDate =
                            DateFormat('yyyy-MM-dd').parse(event.date);
                        return eventDate == selectedDate;
                      }).toList();

                      if (events.isEmpty) {
                        return Center(
                          child: Text(
                            'No hay eventos disponibles para la fecha seleccionada',
                            style: theme.textTheme.titleMedium,
                          ),
                        );
                      }

                      return GridView.count(
                        childAspectRatio: width / (height),
                        crossAxisCount: 2,
                        children: List.generate(
                          events.length,
                          (index) {
                            final event = events[index];
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetails(
                                        title: event.name,
                                        description: event.description,
                                        date: event.date,
                                        cost: event.cost,
                                        status: event.status,
                                        id: event.id,
                                        time: event.time,
                                        createdBy: event.createdBy,
                                        latitude: event.latitude,
                                        longitude: event.longitude,
                                        locationName: event.locationName,
                                        specialGuests: event.specialGuests,
                                        userId: userId,
                                        users: event.users,
                                      ),
                                    ),
                                  );
                                },
                                child: EventCard(
                                  height: height,
                                  width: width,
                                  theme: theme,
                                  title: event.name,
                                  description: event.description,
                                  date: event.date,
                                  place: event.locationName ??
                                      'Lugar no disponible',
                                  cost: event.cost == '0.00'
                                      ? 'Gratis'
                                      : event.cost ?? 'Gratis',
                                  available: event.status,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    if (state is EventsEmpty) {
                      return Center(
                        child: Text(
                          'No hay eventos disponibles',
                          style: theme.textTheme.titleMedium,
                        ),
                      );
                    }
                    if (state is EventsError) {
                      return Center(
                        child: Text(
                          'Error al cargar los eventos',
                          style: theme.textTheme.titleMedium,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
