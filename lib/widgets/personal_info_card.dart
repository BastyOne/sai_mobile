import 'package:flutter/material.dart';
import '../models/personal.dart';

class PersonalInfoCard extends StatelessWidget {
  final PersonalInfo personal;

  const PersonalInfoCard({super.key, required this.personal});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        color: Colors.blue[900],
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: personal.fotoUrl != null
                  ? NetworkImage(personal.fotoUrl!)
                  : const AssetImage('assets/images/defauluser.jpg')
                      as ImageProvider<Object>?,
              radius: 50.0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personal.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    personal.rut,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    personal.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    personal.tipopersona,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    personal.carreraNombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
