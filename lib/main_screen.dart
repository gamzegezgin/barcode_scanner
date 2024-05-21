import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book_list_provider.dart';
import 'barcode_scanner_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('okudumApp')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<BookListProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.books.length,
                  itemBuilder: (context, index) {
                    final book = provider.books[index];
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.authors),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          provider.removeBook(book);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
                    );
                  },
                  child: Text('ISBN Tara'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    print("Export button pressed"); // Fonksiyonun çağrıldığını doğrulamak için
                    await context.read<BookListProvider>().exportToExcel();
                    print("Export completed"); // Fonksiyonun tamamlandığını doğrulamak için
                  },
                  child: Text('Excele Aktar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
