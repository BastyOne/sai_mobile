import 'package:flutter/material.dart';
import '../models/faq.dart';
import '../services/faq_service.dart';

class PreguntasFrecuentesController {
  final FaqService _apiService = FaqService();
  late TabController tabController;
  Map<int, Future<List<FAQ>>> faqsPorCategoria = {};
  late Future<List<FAQ>> todasLasFaqs;

  PreguntasFrecuentesController(TickerProvider vsync, List<int> categoriasId) {
    tabController = TabController(vsync: vsync, length: categoriasId.length);
    for (int id in categoriasId) {
      faqsPorCategoria[id] = _apiService.fetchFAQs(id);
    }
    todasLasFaqs = _fetchTodasLasFaqs();
  }

  Future<List<FAQ>> fetchFAQs(int categoriaId) {
    return _apiService.fetchFAQs(categoriaId);
  }

  Future<List<FAQ>> _fetchTodasLasFaqs() async {
    List<FAQ> faqs = [];
    for (int id in faqsPorCategoria.keys) {
      List<FAQ> categoryFaqs = await _apiService.fetchFAQs(id);
      faqs.addAll(categoryFaqs);
    }
    return faqs;
  }

  Future<void> addFAQ(FAQ faq) async {
    await _apiService.addFAQ(faq);
  }

  Future<void> updateFAQ(int id, FAQ faq) async {
    await _apiService.updateFAQ(id, faq);
  }

  Future<void> deleteFAQ(int id) async {
    await _apiService.deleteFAQ(id);
  }
}
