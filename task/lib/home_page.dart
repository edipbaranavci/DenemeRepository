import 'package:flutter/material.dart';
import 'package:task/widgets/bottom_bar.dart';
import 'package:task/widgets/product_list.dart';
import 'package:task/services/json_service.dart';
import 'models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Product> allProducts = [];
  List<Product> productsWithFilter = [];
  List<String> categoryFilter = ["Shoes", "Bag", "Computer", "Mouse"];
  List<String> category = ["Shoes", "Bag", "Computer", "Mouse"];

  String? selectedValueCategory, selectedValueState, selectedValueCity;
  String defaultState = "states";
  String defaultCity = "cities";

  @override
  void setState(VoidCallback fn) async {
    productsWithFilter.clear();
    allProducts = await getAllProductList();
    productsWithFilter = allProducts;
    super.setState(fn);
  }

  resetFilter() {
    setState(() {
      categoryFilter = category;
      defaultState = "states";
      defaultCity = "cities";
      productsWithFilter.clear();
      productsWithFilter.addAll(allProducts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(),
      endDrawer: buildEndDrawer(),
      bottomNavigationBar: buildBottomNavigatorBar(context, 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              buildCatalog(context),
            ],
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Product List"),
      actions: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  buildCatalog(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: categoryFilter.length,
        itemBuilder: (context, index) {
          // kategoriye göre burada listeleme olacak bag, computer ve shoes kategorileri
          return buildFiltermCatalog(
              cCategory: categoryFilter[index].toString(), context: context);
          // seçim varsa zaten orda bu filte ayarlanmış oluyor
        },
      ),
    );
  }

  buildFiltermCatalog(
      {required String cCategory, required BuildContext context}) {
    return Column(
      children: [
        ListTile(
          title: Text(cCategory),
          tileColor: Colors.brown[100],
        ),
        SizedBox(
          height: 120,
          child: getProductListByCategories(
              allProduct:
                  productsWithFilter, // default olarak tüm ürünleri başlangıçta verdik
              category: selectedValueCategory ?? cCategory,
              state: selectedValueState,
              city: selectedValueCity,
              context: context),
        ),
      ],
    );
  }

  buildEndDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildCategoryFilter(),
              buildStateList(),
              buildCityList(state: selectedValueState),
              ElevatedButton(
                  onPressed: () async {
                    resetFilter();
                  },
                  child: const Text("clear filter")),
            ],
          ),
        ),
      ),
    );
  }

  buildCategoryFilter() {
    return DropdownButton(
      items: category
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        setState(() {
          for (var element in category) {
            if (element.contains(selected.toString())) {
              categoryFilter.clear();
              categoryFilter.add(element);
              selectedValueCategory = selected.toString();
            }
          }
        });
      },
      hint: Text(selectedValueCategory ?? "category"),
    );
  }

  builddropDownState(List<String> states) {
    return DropdownButton(
      items: states
          .map((e) => DropdownMenuItem(
                child: Text(e.toString()),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        setState(() {
          for (var element in category) {
            if (element.contains(selected.toString())) {
              categoryFilter.clear();
              selectedValueCategory = selected.toString();
              categoryFilter.add(element);
            }
          }

          selectedValueState = selected.toString();
          selectedValueCity = selected.toString() + " cities";
        });

        //empty
      },
      hint: Text(selectedValueState ?? defaultState),
    );
  }

  buildDropDownCity(List<String> list) {
    return DropdownButton(
      items: list
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        setState(() {
          selectedValueCity = selected.toString();
          for (var element in category) {
            if (element.contains(selected.toString())) {
              categoryFilter.add(element);
            }
          }
        });
      },
      hint: Text(selectedValueCity ?? defaultCity),
    );
  }

  FutureBuilder<List> buildStateList({String? state}) {
    return FutureBuilder<List>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> states = [];

          for (int i = 0; i < snapshot.data.length; ++i) {
            states.add(snapshot.data[i].name);
          }
          return builddropDownState(states);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: getAllStateList(),
    );
  }

  FutureBuilder<List> buildCityList({String? state}) {
    return FutureBuilder<List>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> cities = [];
          if (state != null || state?.isEmpty == true) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data[i].name.contains(state)) {
                cities.addAll(snapshot.data[i].cities);
              }
            }
          } else {
            for (int i = 0; i < snapshot.data!.length; i++) {
              cities.addAll(snapshot.data[i].cities);
            }
          }
          return buildDropDownCity(cities);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: getAllStateList(),
    );
  }
}
