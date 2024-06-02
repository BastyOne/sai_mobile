import 'package:flutter/material.dart';
import '../models/foro.dart';
import '../services/foro_service.dart';

class ForoController extends ChangeNotifier {
  final ForoService _foroService = ForoService();

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  List<Reply> _replies = [];
  List<Reply> get replies => _replies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();
    // Depuración

    try {
      _posts = await _foroService.obtenerPosts();
      // Depuración
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchReplies(int postId) async {
    _isLoading = true;
    notifyListeners();
    // Depuración

    try {
      _replies = await _foroService.obtenerReplies(postId);
      // Depuración
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(int autorId, String pregunta, String contenido,
      [String? archivoPath]) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _foroService.crearPost(autorId, pregunta, contenido, archivoPath);
      await fetchPosts(); // Refrescar la lista de posts después de crear uno nuevo
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createReply(int postForoId, int autorId, String contenido,
      [String? archivoPath]) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _foroService.crearReply(
          postForoId, autorId, contenido, archivoPath);
      await fetchReplies(
          postForoId); // Refrescar la lista de respuestas después de crear una nueva
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
