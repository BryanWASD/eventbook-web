import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:eventsapp/presentation/pages/add_events/cubit/add_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEvents extends StatefulWidget {
  final int? id;
  final String? name;
  final String? date;
  final String? time;
  final String? description;
  final String? specialGuests;
  final String? cost;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String? status;
  final bool isEditing;

  const AddEvents({
    super.key,
    this.id,
    this.name,
    this.date,
    this.time,
    this.description,
    this.specialGuests,
    this.cost,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.isEditing,
    this.status,
  });

  @override
  State<AddEvents> createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  final logger = Logger();
  final mapController = MapController();

  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("HH:mm a");
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final specialGuestsController = TextEditingController();
  final costController = TextEditingController();

  double lat = 0.0;
  double long = 0.0;
  int userId = 0;
  String? selectedStatus;

  final List<String> statusOptions = [
    'active',
    'inactive',
    'cancelled',
    'completed'
  ];

  @override
  void initState() {
    super.initState();
    _getUserIdFromSharedPreferences();
    if (widget.isEditing) {
      nameController.text = widget.name ?? '';
      locationController.text = widget.locationName ?? '';
      dateController.text = widget.date ?? '';
      timeController.text = widget.time ?? '';
      descriptionController.text = widget.description ?? '';
      specialGuestsController.text = widget.specialGuests ?? '';
      costController.text = widget.cost ?? '';
      lat = widget.latitude ?? 0.0;
      long = widget.longitude ?? 0.0;
      selectedStatus = widget.status ?? 'active';
    } else {
      _determinePosition().then((position) {
        setState(() {
          lat = position.latitude;
          long = position.longitude;
        });
        mapController.move(LatLng(lat, long), 15.0);
      });
    }
  }

  Future<void> _getUserIdFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void updatePoint(LatLng point) {
    setState(() {
      lat = point.latitude;
      long = point.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddEventCubit>();
    // ignore: unused_local_variable
    bool isEnabled = true;

    return Scaffold(
      appBar: widget.isEditing
          ? AppBar(
              title: const Text('Editar evento'),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del evento',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Lugar',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El lugar es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: LatLng(lat, long),
                              initialZoom: 15,
                              minZoom: 3,
                              onTap: (tapPosition, point) {
                                updatePoint(point);
                              },
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
                                    width: 50,
                                    height: 50,
                                    point: LatLng(lat, long),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    DateTimeField(
                      format: format,
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha',
                      ),
                      validator: (value) {
                        if (dateController.text.isEmpty) {
                          return 'La fecha es requerida';
                        }
                        final selectedDate =
                            DateFormat('yyyy-MM-dd').parse(dateController.text);
                        if (selectedDate.isBefore(DateTime.now())) {
                          return 'La fecha no puede ser en el pasado';
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          initialDate: currentValue ?? DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2025),
                          builder: (BuildContext context, Widget? child) {
                            return child!;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    DateTimeField(
                      format: timeFormat,
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Hora',
                      ),
                      validator: (value) {
                        if (timeController.text.isEmpty) {
                          return 'La hora es requerida';
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                          builder: (BuildContext context, Widget? child) {
                            return child!;
                          },
                        );
                        return DateTimeField.convert(time);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La descripción es requerida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: specialGuestsController,
                      decoration: const InputDecoration(
                        labelText: 'Invitado especial',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: costController,
                      decoration: const InputDecoration(
                        labelText: 'Costo',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El costo es requerido';
                        }
                        final cost = double.tryParse(value);
                        if (cost == null || cost < 0) {
                          return 'El costo debe ser un número positivo';
                        }
                        return null;
                      },
                    ),
                    if (widget.isEditing) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                          ),
                          items: statusOptions
                              .map((status) => DropdownMenuItem<String>(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'El estado es requerido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    const SizedBox(height: 16),
                    BlocConsumer<AddEventCubit, AddEventState>(
                      listener: (context, state) {
                        if (state is AddEventError) {
                          setState(() {
                            isEnabled = true;
                          });
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is AddEventLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (widget.isEditing) {
                                      cubit.editEvent(
                                        widget.id!,
                                        nameController.text,
                                        dateController.text,
                                        timeController.text,
                                        descriptionController.text,
                                        specialGuestsController.text,
                                        costController.text,
                                        lat,
                                        long,
                                        locationController.text,
                                        selectedStatus ?? 'active',
                                        context,
                                      );
                                    } else {
                                      cubit.createEvent(
                                        nameController.text,
                                        dateController.text,
                                        timeController.text,
                                        descriptionController.text,
                                        specialGuestsController.text,
                                        costController.text,
                                        lat,
                                        long,
                                        locationController.text,
                                        'active',
                                        userId,
                                        context,
                                      );
                                    }
                                    nameController.clear();
                                    locationController.clear();
                                    dateController.clear();
                                    timeController.clear();
                                    descriptionController.clear();
                                    specialGuestsController.clear();
                                    costController.clear();
                                  }
                                },
                          child: Text(widget.isEditing
                              ? 'Actualizar evento'
                              : 'Agregar evento'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
