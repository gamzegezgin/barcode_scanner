import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:path_provider/path_provider.dart';

class Book {
  final String title;
  final String authors;

  Book({required this.title, required this.authors});
}

class BookListProvider extends ChangeNotifier {
  List<Book> books = [];

  void addBook(Book book) {
    books.add(book);
    notifyListeners();
  }

  void removeBook(Book book) {
    books.remove(book);
    notifyListeners();
  }

  Future<void> fetchBookInfo(String isbn) async {
    final response = await http.get(Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'] != null) {
        final volumeInfo = data['items'][0]['volumeInfo'];
        final title = volumeInfo['title'];
        final authors = (volumeInfo['authors'] as List).join(', ');
        addBook(Book(title: title, authors: authors));
      }
    }
  }

  Future<void> exportToExcel() async {
    try {
      print("Starting export to Excel");

      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];

      sheet.getRangeByName('A1').setText('Kitap Adı');
      sheet.getRangeByName('B1').setText('Yazar');

      for (int i = 0; i < books.length; i++) {
        sheet.getRangeByName('A${i + 2}').setText(books[i].title);
        sheet.getRangeByName('B${i + 2}').setText(books[i].authors);
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final String path = directory.path;
        final String fileName = "$path/kitap_listesi.xlsx";
        final File file = File(fileName);
        await file.writeAsBytes(bytes, flush: true);

        print('Dosya kaydedildi: $fileName');

        // Dosya mevcut mu kontrol etme
        if (await file.exists()) {
          print("Dosya başarıyla oluşturuldu ve mevcut.");
        } else {
          print("Dosya oluşturulamadı.");
        }
      } else {
        print('External storage directory is null');
      }
    } catch (e) {
      print("Error during export: $e");
    }
  }
}
