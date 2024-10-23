import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HiveDatabaseFlutter extends StatefulWidget {
  const HiveDatabaseFlutter({super.key});

  @override
  State<HiveDatabaseFlutter> createState() => _HiveDatabaseFlutterState();
}

class _HiveDatabaseFlutterState extends State<HiveDatabaseFlutter> {
  late Box _peopleBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _peopleBox = await Hive.openBox("Box");
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _domainController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;  // Set the selected image path
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  void addOrUpdate({String? key}) {
    if (key != null) {
      final person = _peopleBox.get(key);
      if (person != null) {
        _nameController.text = person['name'] ?? "";
        _ageController.text = person['age']?.toString() ?? '';
        _domainController.text = person['domain'] ?? "";
        _monthController.text = person['month'] ?? "";
        _imagePath = person['imagePath']; // Load image path
      }
    } else {
      _nameController.clear();
      _ageController.clear();
      _domainController.clear();
      _monthController.clear();
      _imagePath = null; // Reset image path for new entry
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
            right: 15,
            top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, "Enter name"),
              _buildTextField(_ageController, "Enter age", keyboardType: TextInputType.number),
              _buildTextField(_domainController, "Enter domain"),
              _buildTextField(_monthController, "Enter month"),
              const SizedBox(height: 15),
              if (_imagePath != null)
                Image.file(File(_imagePath!), height: 100, width: 100)
              else
                const Text("No image selected."),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pick "),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _onSubmit(key),
                child: Text(key == null ? "Add" : "Update"),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }

  Future<void> _onSubmit(String? key) async {
    final name = _nameController.text;
    final age = int.tryParse(_ageController.text);
    final domain = _domainController.text;
    final month = _monthController.text;

    if (name.isEmpty || domain.isEmpty || age == null || age <= 0 || month.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid name, positive age, domain, and month.")),
      );
      return;
    }

    final data = {
      "name": name,
      "age": age,
      "domain": domain,
      "month": month,
      "imagePath": _imagePath,
    };

    if (key == null) {
      final newKey = DateTime.now().microsecondsSinceEpoch.toString();
      _peopleBox.put(newKey, data);
    } else {
      _peopleBox.put(key, data);
    }

    Navigator.pop(context);
    setState(() {}); // Refresh the UI
  }

  void deleteOperation(String key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                _peopleBox.delete(key);
                Navigator.of(context).pop();
                setState(() {}); // Refresh the UI
              },
              child: const Text("Delete"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Hive Database'),
        backgroundColor: Colors.blue[100],
      ),
      body: ValueListenableBuilder(
        valueListenable: _peopleBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.isEmpty) {
            return const Center(child: Text("No items added yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final key = box.keyAt(index).toString();
              final item = box.get(key);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text(item['name'] ?? "Unknown"),
                    subtitle: Text(
                      'Age: ${item['age'] ?? "Unknown"}\n'
                      'Domain: ${item['domain'] ?? "Unknown"}\n'
                      'Month: ${item['month'] ?? "Unknown"}',
                    ),
                    leading: item['imagePath'] != null
                        ? Image.file(File(item['imagePath']), width: 50, height: 50)
                        : const SizedBox(width: 50, height: 50), // Placeholder for no image
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => addOrUpdate(key: key),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteOperation(key),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => addOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
