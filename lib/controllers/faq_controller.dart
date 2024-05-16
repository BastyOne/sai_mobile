import 'package:flutter/material.dart';
import '../models/faq.dart';
import '../services/api_service.dart';

class PreguntasFrecuentesController {
  final ApiService _apiService = ApiService();
  late TabController tabController;
  late Future<List<FAQ>> faqsBeneficios;
  late Future<List<FAQ>> faqsActividades;

  PreguntasFrecuentesController(TickerProvider vsync,
      {required int beneficiosId, required int actividadesId}) {
    tabController = TabController(vsync: vsync, length: 2);
    faqsBeneficios = _apiService.fetchFAQs(beneficiosId);
    faqsActividades = _apiService.fetchFAQs(actividadesId);
  }
}
