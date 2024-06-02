import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/foro_controller.dart';
import '../../../widgets/post_card.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';
import 'crear_post_view.dart';
import 'detalle_post_view.dart';

class ForoEstudiantilScreen extends StatefulWidget {
  const ForoEstudiantilScreen({super.key});

  @override
  ForoEstudiantilScreenState createState() => ForoEstudiantilScreenState();
}

class ForoEstudiantilScreenState extends State<ForoEstudiantilScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final foroController =
          Provider.of<ForoController>(context, listen: false);
      foroController
          .fetchPosts(); // Llama a fetchPosts cuando la pantalla se carga
      // Depuración
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    final foroController = Provider.of<ForoController>(context);

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
          : foroController.posts.isEmpty
              ? const Center(child: Text("No hay posts disponibles"))
              : ListView.builder(
                  itemCount: foroController.posts.length,
                  itemBuilder: (context, index) {
                    final post = foroController.posts[index];
                    return PostCard(
                      post: post,
                      onTap: () {
                        // Navegar a la pantalla de detalles del post para ver las respuestas
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetallePostScreen(postId: post.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de creación de un nuevo post
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarPostScreen()),
          );
        },
        backgroundColor: const Color(0xFF00A2E1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
