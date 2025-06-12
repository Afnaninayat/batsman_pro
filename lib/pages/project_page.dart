import 'dart:html' as html; // Only used for Flutter Web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/bottom_nav_bar.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int _currentTabIndex = 0;
  final List<Map<String, String>> _videos = [];

  Future<void> _showUploadOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("Upload from Device"),
            onTap: () async {
              Navigator.pop(context);
              await _uploadFromDevice();
            },
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text("Record Now"),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Coming Soon"),
                  content: const Text("This feature is coming soon."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> uploadVideoWeb(html.File file, String fileName) async {
    final uri = Uri.parse('http://localhost:5000/upload');
    final request = html.HttpRequest();

    request.open('POST', uri.toString());
    final formData = html.FormData();
    formData.appendBlob('video', file, fileName);
    request.send(formData);

    setState(() {
      _videos.add({'name': fileName, 'status': 'uploading'});
    });

    request.onLoadEnd.listen((e) async {
      final index = _videos.indexWhere((v) => v['name'] == fileName);
      if (request.status == 200) {
        if (index != -1) {
          setState(() {
            _videos[index]['status'] = 'uploaded';
          });
        }

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final videoUrl = "http://localhost:5000/uploads/$fileName";

            await FirebaseFirestore.instance.collection('videos').add({
            'userId': user.uid,
            'path': videoUrl,
            'status': 'upload_finished',
            'uploadedAt': FieldValue.serverTimestamp(), // ← You must include this manually
          });

        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Upload Successful"),
            content: const Text("Your video has been uploaded successfully."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              )
            ],
          ),
        );
      } else {
        setState(() {
          _videos.removeWhere((v) => v['name'] == fileName);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed")),
        );
      }
    });
  }

  Future<void> _uploadFromDevice() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null && result.files.isNotEmpty) {
      final fileName = result.files.first.name;

      if (kIsWeb) {
        final fileBytes = result.files.first.bytes;
        if (fileBytes != null) {
          final blob = html.Blob([fileBytes]);
          final htmlFile = html.File([blob], fileName);
          await uploadVideoWeb(htmlFile, fileName);
        }
      } else {
        final filePath = result.files.first.path;
        if (filePath != null) {
          // Add mobile upload logic here if needed
        }
      }
    }
  }

Future<List<Map<String, String>>> _fetchUserVideos() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final snapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('userId', isEqualTo: user.uid)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    final path = data['path']?.toString() ?? '';
    final name = path.split('/').last;
    final status = data['status']?.toString() ?? 'unknown';

    return {
      'name': name,
      'status': status,
      'url': path,
    };
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    final tabs = ["To do", "In progress", "Finished"];

    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      appBar: AppBar(title: const Text("Projects"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(tabs.length, (index) {
                return TextButton(
                  onPressed: () => setState(() => _currentTabIndex = index),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: _currentTabIndex == index ? Colors.blue : Colors.black,
                      fontWeight: _currentTabIndex == index ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _fetchUserVideos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _buildEmpty("Error loading videos.");
                }

                final videos = snapshot.data ?? [];
                final inProgress = videos.where((v) => v['status'] == 'uploading').toList();
                final uploaded = videos.where((v) => v['status'] == 'upload_finished').toList();

                if (_currentTabIndex == 0) return _buildEmpty("Nothing here. For now.");
                if (_currentTabIndex == 1) {
                  return inProgress.isEmpty
                      ? _buildEmpty("No ongoing uploads.")
                      : _buildVideoList(inProgress, showProgress: true);
                } else {
                  return uploaded.isEmpty
                      ? _buildEmpty("No videos uploaded yet.")
                      : _buildVideoList(uploaded);
                }
              },
            ),
          ),
          if (_currentTabIndex == 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _showUploadOptions,
                child: const Text("Upload a Video", style: TextStyle(color: Colors.white)),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_drive_file, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildVideoList(List<Map<String, String>> videos, {bool showProgress = false}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (_, index) {
        final video = videos[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.videocam),
            title: Text(video['name']!),
            subtitle: Text(video['status']!),
            trailing: showProgress
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _videos.remove(video);
                      });
                    },
                  ),
          ),
        );
      },
    );
  }
}


// import 'dart:html' as html; // Only for Flutter Web
// import 'dart:io' as io; // Only for Flutter Mobile
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';

// import '../firebase_options.dart'; // Make sure this is generated
// import '../widgets/bottom_nav_bar.dart';

// class ProjectPage extends StatefulWidget {
//   const ProjectPage({super.key});

//   @override
//   State<ProjectPage> createState() => _ProjectPageState();
// }

// class _ProjectPageState extends State<ProjectPage> {
//   int _currentTabIndex = 0;
//   final List<Map<String, String>> _videos = [];

//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebase();
//   }

//   Future<void> _initializeFirebase() async {
//     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   }

//   Future<void> _showUploadOptions() async {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Wrap(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.upload_file),
//             title: const Text("Upload from Device"),
//             onTap: () async {
//               Navigator.pop(context);
//               await _uploadFromDevice();
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.videocam),
//             title: const Text("Record Now"),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (_) => AlertDialog(
//                   title: const Text("Coming Soon"),
//                   content: const Text("This feature is coming soon."),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("OK"),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _uploadFromDevice() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.video);
//     if (result != null && result.files.isNotEmpty) {
//       final file = result.files.first;
//       final fileName = file.name;
//       final fileSize = file.size;

//       setState(() {
//         _videos.add({'name': fileName, 'status': 'uploading'});
//       });

//       try {
//         String downloadUrl;
//         final user = FirebaseAuth.instance.currentUser;
//         if (user == null) {
//           throw Exception('User not authenticated');
//         }

//         if (kIsWeb && file.bytes != null) {
//           // Web upload
//           final storageRef = FirebaseStorage.instance.ref('videos/$fileName');
//           final uploadTask = await storageRef.putData(file.bytes!);
//           downloadUrl = await uploadTask.ref.getDownloadURL();
//         } else {
//           // Mobile upload
//           final filePath = file.path;
//           if (filePath == null) throw Exception('File path is null');
//           final io.File localFile = io.File(filePath);
//           final uploadTask = await FirebaseStorage.instance.ref('videos/$fileName').putFile(localFile);
//           downloadUrl = await uploadTask.ref.getDownloadURL();
//         }

//         // Save metadata to Firestore
//         final docRef = FirebaseFirestore.instance.collection('videos').doc();
//         await docRef.set({
//           'id': user.uid,
//           'name': fileName,
//           'url': downloadUrl,
//           'size': '${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB',
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         final index = _videos.indexWhere((v) => v['name'] == fileName);
//         if (index != -1) {
//           setState(() => _videos[index]['status'] = 'uploaded');
//         }

//         showDialog(
//           context: context,
//           builder: (_) => AlertDialog(
//             title: const Text("Upload Successful"),
//             content: const Text("Your video has been uploaded successfully."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text("OK"),
//               )
//             ],
//           ),
//         );
//       } catch (e) {
//         setState(() {
//           _videos.removeWhere((v) => v['name'] == fileName);
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Upload failed: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tabs = ["To do", "In progress", "Finished"];
//     final inProgress = _videos.where((v) => v['status'] == 'uploading').toList();
//     final uploaded = _videos.where((v) => v['status'] == 'uploaded').toList();

//     return Scaffold(
//       bottomNavigationBar: const BottomNavBar(currentIndex: 1),
//       appBar: AppBar(title: const Text("Projects"), centerTitle: true),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(tabs.length, (index) {
//                 return TextButton(
//                   onPressed: () => setState(() => _currentTabIndex = index),
//                   child: Text(
//                     tabs[index],
//                     style: TextStyle(
//                       color: _currentTabIndex == index ? Colors.blue : Colors.black,
//                       fontWeight: _currentTabIndex == index ? FontWeight.bold : FontWeight.normal,
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           Expanded(
//             child: Builder(
//               builder: (_) {
//                 if (_currentTabIndex == 0) return _buildEmpty("Nothing here. For now.");
//                 if (_currentTabIndex == 1) {
//                   return inProgress.isEmpty
//                       ? _buildEmpty("No ongoing uploads.")
//                       : _buildVideoList(inProgress, showProgress: true);
//                 } else {
//                   return uploaded.isEmpty
//                       ? _buildEmpty("No videos uploaded yet.")
//                       : _buildVideoList(uploaded);
//                 }
//               },
//             ),
//           ),
//           if (_currentTabIndex == 0)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 32),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                 onPressed: _showUploadOptions,
//                 child: const Text("Upload a Video", style: TextStyle(color: Colors.white)),
//               ),
//             )
//         ],
//       ),
//     );
//   }

//   Widget _buildEmpty(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.insert_drive_file, size: 100, color: Colors.grey[300]),
//           const SizedBox(height: 16),
//           Text(message, style: const TextStyle(fontSize: 18)),
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoList(List<Map<String, String>> videos, {bool showProgress = false}) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: videos.length,
//       itemBuilder: (_, index) {
//         final video = videos[index];
//         return Card(
//           child: ListTile(
//             leading: const Icon(Icons.videocam),
//             title: Text(video['name']!),
//             subtitle: Text(video['status']!),
//             trailing: showProgress
//                 ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       setState(() {
//                         _videos.remove(video);
//                       });
//                     },
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
