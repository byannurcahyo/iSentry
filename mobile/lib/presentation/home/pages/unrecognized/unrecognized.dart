import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/faces/face_bloc.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/faces/face_state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'bottom_sheets/add_data.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';

class UnrecognizedPage extends StatefulWidget {
  const UnrecognizedPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UnrecognizedPageState createState() => _UnrecognizedPageState();
}

class _UnrecognizedPageState extends State<UnrecognizedPage> {
  List<bool> _isSelected = [];
  final List<FaceModel> _selectedFaces = [];
  bool _multiSelectMode = false;

  Future<void> _openAddDataUnreg() async {
    bool? reload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDataUnreg(selectedFaces: _selectedFaces),
      ),
    );

    if (reload == true) {
      setState(() {
        _selectedFaces.clear();
        _isSelected = List.filled(_isSelected.length, false);
        _multiSelectMode = false;
      });
    }
  }

  void _loadUnrecognizedFaces() {
    context.read<FaceBloc>().add(LoadUnrecognizedFaces());
  }

  void _showAddDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddDataUnreg(selectedFaces: List.from(_selectedFaces)),
    );
  }

  void _onFabPressed() {
    _showAddDataBottomSheet(context);
  }

  void _unselectAll() {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      _selectedFaces.clear();
      _multiSelectMode = false;
    });
  }

  void _deleteSelectedFaces() {
    for (var face in _selectedFaces) {
      context.read<FaceBloc>().add(DeleteFace(face.id));
    }

    setState(() {
      _selectedFaces.clear();
      _isSelected = List.filled(_isSelected.length, false);
      _multiSelectMode = false;
    });
    _loadUnrecognizedFaces();
  }

  @override
  void initState() {
    super.initState();
    _loadUnrecognizedFaces();
  }

  void _toggleSelectMode(int index, FaceModel face) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
      if (_isSelected[index]) {
        _selectedFaces.add(face);
      } else {
        _selectedFaces.remove(face);
      }

      // Automatically exit select mode if no faces are selected
      if (_selectedFaces.isEmpty) {
        _multiSelectMode = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f9),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: MySort(
            texts: const ['Today', 'Week', 'Month', 'Year'],
            leftPadding: 25,
            rightPadding: 25,
            onItemSelected: (int) {
              0;
            },
          ),
        ),
      ),
      body: BlocBuilder<FaceBloc, FaceState>(
        builder: (context, state) {
          if (state is FaceLoading || state is FaceReloading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FaceLoaded) {
            if (_isSelected.length != state.faces.length) {
              _isSelected = List.filled(state.faces.length, false);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.7,
                ),
                itemCount: state.faces.length,
                itemBuilder: (context, index) {
                  final face = state.faces[index];
                  final formattedDate =
                      DateFormat("d MMMM yyyy, HH:mm").format(face.createdAt);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        // Allow full image view when not in select mode
                        onTap: () {
                          if (!_multiSelectMode) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                        "http://$ipAddress${face.pictureSinglePath}",
                                        fit: BoxFit.cover),
                                  ),
                                );
                              },
                            );
                          } else {
                            // In select mode, toggle selection
                            _toggleSelectMode(index, face);
                          }
                        },
                        child: Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "http://$ipAddress${face.pictureSinglePath}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    if (_multiSelectMode)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Icon(
                                          _isSelected[index]
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color: _isSelected[index]
                                              ? Colors.black
                                              : Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Face#${face.id}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(
                                LucideIcons.moreVertical,
                              ),
                              onSelected: (value) {
                                if (value == 'select') {
                                  setState(() {
                                    _multiSelectMode = !_multiSelectMode;
                                    if (!_multiSelectMode) {
                                      _selectedFaces.clear();
                                      _isSelected = List.filled(
                                          _isSelected.length, false);
                                    }
                                  });
                                } else if (value == 'delete') {
                                  _deleteSelectedFaces();
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'select',
                                    child: Row(
                                      children: [
                                        Icon(LucideIcons.checkCircle, size: 18),
                                        SizedBox(width: 10),
                                        Text('Select'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(height: 1),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(LucideIcons.trash2,
                                            size: 18, color: Colors.red),
                                        SizedBox(width: 10),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              LucideIcons.calendarDays,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else if (state is FaceError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
      floatingActionButton: _multiSelectMode
          ? FloatingActionButton(
              onPressed: _onFabPressed,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(LucideIcons.plus, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
