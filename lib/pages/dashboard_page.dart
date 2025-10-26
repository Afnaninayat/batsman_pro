import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import '../widgets/bottom_nav_bar.dart';
import '../pages/login_page.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _uploadedVideoUrl;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _loadLatestVideo();
  }

  Future<void> _loadLatestVideo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .where('userId', isEqualTo: user.uid)
          .orderBy('uploadedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final videoUrl = snapshot.docs.first.data()['path'] ?? '';
        if (videoUrl.isNotEmpty) {
          _initializeVideo(videoUrl);
        }
      }
    } catch (e) {
      debugPrint("Error loading video: $e");
    }
  }

  void _initializeVideo(String url) {
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {
          _uploadedVideoUrl = url;
          _isInitialized = true;
        });
        _controller!.play();
        _controller!.setLooping(true);
      });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _showUploadOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.blue),
              title: const Text("Upload from Device"),
              onTap: () async {
                Navigator.pop(context);
                await _uploadFromDevice();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.videocam, color: Colors.orange),
              title: const Text("Record Now (Coming Soon)"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadFromDevice() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null || result.files.isEmpty) return;

    final fileName = result.files.first.name;
    final bytes = result.files.first.bytes;
    if (bytes == null) return;

    final blob = html.Blob([bytes]);
    final htmlFile = html.File([blob], fileName);

    await _uploadVideoWeb(htmlFile, fileName);
  }

  Future<void> _uploadVideoWeb(html.File file, String fileName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('videos').doc();
    await docRef.set({
      'userId': user.uid,
      'fileName': fileName,
      'status': 'uploading',
      'uploadedAt': FieldValue.serverTimestamp(),
    });

    final uri = Uri.parse('http://localhost:5000/upload');
    final request = html.HttpRequest();
    request.open('POST', uri.toString());

    final formData = html.FormData();
    formData.appendBlob('video', file, fileName);
    request.send(formData);

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    request.upload.onProgress.listen((event) {
      if (event.lengthComputable) {
        setState(() {
          _uploadProgress = ((event.loaded! / event.total!) * 100).toDouble();
        });
      }
    });

    request.onLoadEnd.listen((_) async {
      if (request.status == 200) {
        String uploadedUrl = "http://localhost:5000/uploads/$fileName";
        try {
          final resp = jsonDecode(request.responseText ?? '{}');
          if (resp['path'] != null) uploadedUrl = resp['path'];
        } catch (_) {}

        await docRef.update({
          'path': uploadedUrl,
          'status': 'upload_finished',
        });

        setState(() {
          _isUploading = false;
          _uploadProgress = 100;
        });

        if (mounted) {
          _showSuccessDialog();
          _initializeVideo(uploadedUrl);
        }
      } else {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed.")),
        );
      }
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("✅ Upload Successful"),
        content: const Text("Your video has been uploaded successfully."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showModelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Model Not Running"),
        content: const Text("The analysis model is currently offline."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _togglePlayPause() { }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Dashboard",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: _logout,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "👋 Welcome",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Text(
              "Upload or Record Your Batting Session",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Once uploaded, our AI will analyze your performance.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Upload Button
            GestureDetector(
              onTap: _isUploading ? null : _showUploadOptions,
              child: ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                    parent: _pulseController, curve: Curves.easeInOut)),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent,
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isUploading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/animations/uploading.json',
                                  width: 100, height: 100),
                              const SizedBox(height: 10),
                              Text(
                                "${_uploadProgress.toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Lottie.asset('assets/animations/upload_button.json',
                            width: 100, height: 100),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (_isInitialized && _uploadedVideoUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Recent Upload",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_controller!),
                          VideoProgressIndicator(
                            _controller!,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _showModelDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text(
                      "Show Detail Analytics",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
