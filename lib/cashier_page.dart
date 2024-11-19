import 'package:flutter/material.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

List<Map<String, dynamic>> products = [
  {
    "image": "images/kopi.jpeg",
    "name": "Kopi",
    "price": 12000,
    "stock": 20,
    "quantity": 0,
  },
  {
    "image": "images/kentang.jpeg",
    "name": "Kentang Goreng",
    "price": 15000,
    "stock": 15,
    "quantity": 0,
  },
  {
    "image": "images/susu.jpeg",
    "name": "Susu",
    "price": 10000,
    "stock": 30,
    "quantity": 0,
  },
];

class _CashierPageState extends State<CashierPage> {
  int _totalItem = 0;
  int _totalHarga = 0;
  List<Map<String, dynamic>> cart = [];

  Future<void> _TambahItemBeli(int index) async {
    setState(() {
      // Check if the product is in stock
      if (products[index]['stock'] > 0) {
        bool isProductInCart = false;
        for (var item in cart) {
          if (item['name'] == products[index]['name']) {
            isProductInCart = true;
            item['quantity']++; // Increment quantity
            break;
          }
        }

        if (!isProductInCart) {
          cart.add({
            'name': products[index]['name'],
            'price': products[index]['price'],
            'quantity': 1,
            'image': products[index]['image'],
          });
        }

        // Decrease stock and increment total items
        products[index]['stock']--;
        _totalItem++;

        // Recalculate total price
        _totalHarga += products[index]['price'] as int;
      } else {
        // Show notification when stock is 0
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Stok habis untuk produk ini'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  Future<void> _KurangiItemBeli(int index) async {
    setState(() {
      var cartItem = cart.firstWhere(
        (item) => item['name'] == products[index]['name'],
        orElse: () => {},
      );

      if (cartItem.isNotEmpty && cartItem['quantity'] > 0) {
        cartItem['quantity']--;
        products[index]['stock']++;
        _totalItem--;
        _totalHarga -= products[index]['price'] as int;

        if (cartItem['quantity'] == 0) {
          cart.remove(cartItem);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tidak ada produk yang dapat dikurangi'),
          backgroundColor: Colors.red,
        ));
      }
    });
  }

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              left: 50,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cashier App",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const Text(
                  "i finally held your hand",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final item = products[index];
                        final cartItem = cart.firstWhere(
                          (cartItem) => cartItem['name'] == item['name'],
                          orElse: () => {'quantity': 0},
                        );
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                      color: Colors.grey[400],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                      child: Image.asset(
                                        item['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          "Stok: ${item['stock']}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          "Rp. ${item['price']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible: cartItem['quantity'] > 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          _KurangiItemBeli(index);
                                        },
                                        child: Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: Colors.red[400],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: Text(
                                          cartItem['quantity'] > 0
                                              ? "${cartItem['quantity']}"
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _TambahItemBeli(index);
                                      },
                                      child: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 55,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total ($_totalItem Item) = Rp. $_totalHarga",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
