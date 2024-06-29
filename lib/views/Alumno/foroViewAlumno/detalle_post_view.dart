import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/foro_controller.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';
import 'package:intl/intl.dart';
import 'agregar_respuesta_view.dart';

class DetallePostScreen extends StatefulWidget {
  final int postId;

  const DetallePostScreen({required this.postId, super.key});

  @override
  DetallePostScreenState createState() => DetallePostScreenState();
}

class DetallePostScreenState extends State<DetallePostScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final foroController =
          Provider.of<ForoController>(context, listen: false);
      foroController.fetchReplies(widget.postId);
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final foroController = Provider.of<ForoController>(context);
    final post =
        foroController.posts.firstWhere((post) => post.id == widget.postId);

    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: foroController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: post.autorFoto != null
                                      ? NetworkImage(post.autorFoto!)
                                      : const AssetImage(
                                              'assets/images/defauluser.jpg')
                                          as ImageProvider,
                                  radius: 20,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${post.autorNombre ?? 'Desconocido'} ${post.autorApellido ?? ''}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd HH:mm')
                                          .format(post.fechaCreacion),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.pregunta,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF021B79)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.contenido,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            // Mostrar la imagen si existe
                            if (post.archivoUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.network(post.archivoUrl!),
                              ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...foroController.replies.map((reply) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: reply.autorFoto !=
                                                    null
                                                ? NetworkImage(reply.autorFoto!)
                                                : const AssetImage(
                                                        'assets/default_avatar.png')
                                                    as ImageProvider,
                                            radius: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${reply.autorNombre ?? 'Desconocido'} ${reply.autorApellido ?? ''}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .format(
                                                        reply.fechaCreacion),
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        reply.contenido,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                if (reply.archivoUrl != null)
                                  GestureDetector(
                                    onTap: () =>
                                        _showImageDialog(reply.archivoUrl!),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Image.network(
                                        reply.archivoUrl!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AgregarRespuestaScreen(postId: widget.postId),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    color: const Color(0xFF00A2E1),
                    child: const Center(
                      child: Text(
                        'Agregar respuesta',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
