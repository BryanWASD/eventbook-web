import 'dart:math';

import 'package:eventsapp/presentation/pages/map/cubit/events_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Position? _myPosition;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  Future<void> getCurrentPosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _myPosition = position;
      });
      // print('Current Position: $_myPosition');
    } catch (e) {
      // print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final random = Random();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventsCubit()..getAllEvents(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: BlocBuilder<EventsCubit, EventsState>(
                builder: (context, state) {
                  if (state is EventsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is EventsSuccess) {
                    final events = state.events;
                    // print('Events loaded: ${events?.length}');
                    if (_myPosition == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            _myPosition!.latitude,
                            _myPosition!.longitude,
                          ),
                          initialZoom: 13,
                          maxZoom: 18,
                          minZoom: 5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            tileProvider: CancellableNetworkTileProvider(),
                          ),
                          MarkerLayer(
                            markers: events!.reversed.map((event) {
                              // print(
                              //     'Event: ${event.name}, Lat: ${event.latitude}, Lng: ${event.longitude}');
                              return Marker(
                                width: width * 0.10,
                                height: height * 0.09,
                                point: LatLng(
                                    event.latitude +
                                        random.nextDouble() * 0.0001,
                                    event.longitude +
                                        random.nextDouble() * 0.0001),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        event.name,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  }
                  if (state is EventsEmpty) {
                    return Center(
                      child: Text(
                        'No hay eventos en el área',
                        style: theme.textTheme.titleMedium,
                      ),
                    );
                  }
                  if (state is EventsError) {
                    return Center(
                      child: Text(
                        'Error al cargar los datos',
                        style: theme.textTheme.titleMedium,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
