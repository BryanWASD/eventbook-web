import 'package:eventsapp/data/dtos/response/user_response_dto.dart';
import 'package:eventsapp/presentation/pages/add_events/add_events.dart';
import 'package:eventsapp/presentation/pages/event_details/cubit/event_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';

class EventDetails extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String time;
  final String description;
  final String? specialGuests;
  final String? cost;
  final double latitude;
  final double longitude;
  final String? locationName;
  final String status;
  final int createdBy;
  final int? userId;
  final List<UserResponseDto>? users;
  const EventDetails({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.locationName,
    required this.cost,
    required this.status,
    required this.id,
    required this.time,
    this.specialGuests,
    required this.createdBy,
    required this.latitude,
    required this.longitude,
    this.userId,
    this.users,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool get isUserRegistered {
    if (widget.userId != null && widget.users != null) {
      return widget.users!.any((user) => user.id == widget.userId);
    }
    return false;
  }

  bool get isEventActive {
    return widget.status == "active";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final cubit = context.read<EventDetailsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.userId == widget.createdBy
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEvents(
                          name: widget.title,
                          description: widget.description,
                          date: widget.date,
                          time: widget.time,
                          locationName: widget.locationName,
                          cost: widget.cost,
                          status: widget.status,
                          id: widget.id,
                          specialGuests: widget.specialGuests,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          isEditing: true,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    print(
                      '${widget.userId} ${widget.createdBy} ${widget.id}',
                    );
                    cubit.deleteEventById(widget.id, context);
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 5.0,
                ),
                child: Text(
                  widget.description,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Text(
                  '${widget.date} a las ${widget.time}',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              widget.locationName != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Text(
                        widget.locationName ?? 'No se pudo obtener el lugar',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Text(
                        'No se pudo obtener el lugar',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
              widget.locationName != null
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 10.0,
                      ),
                      child: Row(
                        children: [
                          const Text('Invitado especial: '),
                          Text(
                            widget.specialGuests ??
                                'No hay invitados especiales',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        'No hay invitados especiales para este evento',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
              widget.users != null && widget.users!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: widget.users!
                            .take(3)
                            .map((user) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        theme.colorScheme.inverseSurface,
                                    child: Text(
                                      user.username[0].toUpperCase(),
                                      style:
                                          theme.textTheme.bodyMedium!.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 10.0,
                      ),
                      child: Text(
                        'No hay usuarios registrados',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
              SizedBox(
                height: height * .40,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      widget.latitude,
                      widget.longitude,
                    ),
                    initialZoom: 16,
                    maxZoom: 16,
                    minZoom: 16,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider: CancellableNetworkTileProvider(),
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          width: 100,
                          height: 100,
                          point: LatLng(
                            widget.latitude,
                            widget.longitude,
                          ),
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: isUserRegistered || !isEventActive
                        ? null
                        : () {
                            cubit.join(widget.id, widget.userId!, context);
                          },
                    child: Text((widget.cost == '0' || widget.cost == '0.00')
                        ? 'Gratis'
                        : widget.cost ?? 'Gratis'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
