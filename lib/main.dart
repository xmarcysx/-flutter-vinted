import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  TextEditingController titleController = TextEditingController();
  TextEditingController sortByController = TextEditingController();
  TextEditingController priceFromController = TextEditingController();
  TextEditingController priceToController = TextEditingController();

  String title = '';
  String sortBy = '';
  String priceFrom = '';
  String priceTo = '';
  String page = '';

  List<dynamic> items = [];

  bool isFormExpanded = true;
  bool isLoading = false;

  void clear(BuildContext context) {
    setState(() {
      titleController.clear();
      title = '';
      sortBy = '';
      priceFromController.clear();
      priceFrom = '';
      priceToController.clear();
      priceTo = '';
      page = '';
    });
  }

  void setIsLoading(state) {
    setState(() {
      isLoading = state;
    });
  }

  void setItems(data) {
    setState(() {
      items = data;
    });
  }

  Future<void> handleSearch() async {
    isFormExpanded = false;
    setState(() {
      setIsLoading(true);
    });

    Map<String, String> queryParams = {
      'title': title,
      'sortBy': sortBy,
      'priceFrom': priceFrom,
      'priceTo': priceTo,
      'page': page.toString(),
    };

    Uri url;
    url = Uri.http('10.0.2.2:3001', '/api', queryParams);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          setItems(data['items']);
          setIsLoading(false);
        });
      } else {
        throw Exception('Network response was not ok.');
      }
    } catch (error) {
      print('Błąd: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://wmh.agency/wp-content/uploads/2023/02/Vinted-logo.png',
                  height: 50,
                  fit: BoxFit.contain,
                )
              ],
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExpansionPanelList(
                elevation: 1,
                expandedHeaderPadding: EdgeInsets.all(0),
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    isFormExpanded = !isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(isFormExpanded
                            ? 'Zwiń Formularz'
                            : 'Rozwiń Formularz'),
                      );
                    },
                    body: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(labelText: 'Tytuł'),
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                          ),
                          SizedBox(height: 16.0),
                          DropdownButtonFormField<String>(
                            value: sortBy,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  sortBy = newValue;
                                });
                              }
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: '',
                                child: Text('Wybierz sortowanie'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'relevant',
                                child: Text('trafność'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'price_high_to_low',
                                child: Text('cena: od najwyższej'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'price_low_to_high',
                                child: Text('cena: od najniższej'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'newest_first',
                                child: Text('od najnowszych'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'likes_high_to_low',
                                child: Text('ulubione: od najwyższej'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'likes_low_to_high',
                                child: Text('ulubione: od najniższej'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: priceFromController,
                                      decoration:
                                          InputDecoration(labelText: 'cena od'),
                                      onChanged: (value) {
                                        setState(() {
                                          priceFrom = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: priceToController,
                                      decoration:
                                          InputDecoration(labelText: 'cena do'),
                                      onChanged: (value) {
                                        setState(() {
                                          priceTo = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    handleSearch();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 13, 148, 136)),
                                  ),
                                  child: Text('Szukaj'),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    clear(context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 37, 99, 235)),
                                  ),
                                  child: Text('Wyczyść'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    isExpanded: isFormExpanded,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              isLoading
                  ? Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                items[index]['photo']['full_size_url'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text('${items[index]['title']}'),
                              onTap: () {
                                // Przygotuj obiekt z informacjami
                                ItemDetails itemDetails = ItemDetails(
                                  title: items[index]['title'],
                                  photoUrl: items[index]['photo']
                                      ['full_size_url'],
                                  brand: items[index]['brand_title'],
                                  favourites: items[index]['favourite_count'],
                                  price: items[index]['price'],
                                  username: items[index]['user']['login'],
                                );

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${itemDetails.title}'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              itemDetails.photoUrl,
                                              width: 250,
                                              height: 250,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(height: 16.0),
                                            Text(
                                                'Nazwa użytkownika: ${itemDetails.username}'),
                                            SizedBox(height: 16.0),
                                            Text('Marka: ${itemDetails.brand}'),
                                            SizedBox(height: 16.0),
                                            Text(
                                                'Cena: ${double.parse(itemDetails.price).toStringAsFixed(0)}zł'),
                                            SizedBox(height: 16.0),
                                            Text(
                                                '❤️ ${itemDetails.favourites}'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Zamknij'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemDetails {
  final String title;
  final String photoUrl;
  final String price;
  final int favourites;
  final String brand;
  final String username;

  ItemDetails(
      {required this.title,
      required this.photoUrl,
      required this.price,
      required this.favourites,
      required this.brand,
      required this.username});
}
