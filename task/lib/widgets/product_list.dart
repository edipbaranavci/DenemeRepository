import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/json_service.dart';

String urlComputerImage =
    "https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvMzg5LWZlbGl4LTA4ODktZXllLWEuanBn.jpg";
String urlBagImage =
    "https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm0zODktcm0zNTUtcGYtczcyLWIxNy1tb2NrdXAta3o5b2R2enoucG5n.png";
String urlShoesImage =
    "https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvNDUyLWZlbGl4LTQ5LW1vY2t1cF8xLnBuZw.png";
String urlMouseImage =
    "https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcGYtczczLXBhaS0zMDAwNDUyLmpwZw.jpg";

FutureBuilder getProductListByCategories(
    {List<Product>? allProduct,
    String? category,
    String? state,
    String? city,
    required BuildContext context}) {
  return FutureBuilder<List<Product>>(
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        List<Product> all = <Product>[];
        all.addAll(snapshot.data);
        // her bir kategoriye ayrı ayrı yapar
        if (category != null) {
          //kategori null olmuyor
          for (int i = 0; i < snapshot.data!.length; i++) {
            if (!snapshot.data[i].category.contains(category)) {
              all.remove(snapshot.data[i]);
            }
          }
        }
        if (state != null) {
          for (int i = 0; i < snapshot.data!.length; i++) {
            if (!snapshot.data[i].state?.contains(state)) {
              all.remove(snapshot.data[i]);
            }
          }
        }
        if (city == state.toString() + " cities") {
          // dont do anything
          // homepage 181 in builddropDownState > setState
        } else if (city != null) {
          for (int i = 0; i < snapshot.data!.length; i++) {
            if (!snapshot.data[i].city?.contains(city)) {
              all.remove(snapshot.data[i]);
            }
          }
        }
        //else {
        //   print("3 " + city.toString());
        //   for (int i = 0; i < snapshot.data!.length; i++) {
        //     all.add(snapshot.data[i]); // açık olduğunda her bir kategori için tüm ürün listesini getirir
        //   }
        // }

        allProduct = all;
        return buildProductList(all, context);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return const Center(child: CircularProgressIndicator());
    },
    future: getAllProductList(),
  );
}

Widget buildProductList(List<Product> cproducts, BuildContext context) {
  final ScrollController scrollController = ScrollController();

  return Scrollbar(
    controller: scrollController,
    hoverThickness: 5,
    isAlwaysShown: true,
    thickness: 8,
    interactive: true,
    showTrackOnHover: true,
    radius: const Radius.circular(10),
    child: ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cproducts.length,
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () {
            showCustomDialog(
                context, cproducts[index], Colors.blue[100 * (index + 1)]);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              color: Colors.blue[100 * (index + 1)],
              // image: DecorationImage(
              //   image: NetworkImage(getImageUrl(cproducts[index].category)),
              //   fit: BoxFit.fitWidth,
              // ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Text("${index + 1}"),
                    ),
                    Text(cproducts[index].name.toString()),
                  ],
                ),
                Text(cproducts[index].company.toString()),
                Text(cproducts[index].state.toString() +
                    " / " +
                    cproducts[index].city.toString()),
              ],
            ),
          ),
        );
      },
    ),
  );
}

getImageUrl(String productCategory) {
  switch (productCategory) {
    case "Computer":
      return urlComputerImage;
    case "Mouse":
      return urlMouseImage;
    case "Shoes":
      return urlShoesImage;
    case "Bag":
      return urlBagImage;
    default:
      return "https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvMzgwLWZlbGl4LTM3LWEtbF8xLmpwZw.jpg";
  }
}

Future<void> showCustomDialog(BuildContext context, Product selectedProduct,
    Color? backgroundColor) async {
  //burası ürünlere tıklanınca açılanyer mi?
  //evetburayı ayırdım
  /*
                nedeni favoriye eklemek için setstate kullanılacak ama dialogta olmaz
                o yüzden dialoğun içini statefull olarak ayırdım 
        * eğer ki dialogtan sadece bir favori butonu olacak ise
        ona göre bir ayarlama yapabilirim?
    */

  //burası ise listeleme yaparken eğer ki daha öncesinden
  //favoriye eklediyse onu belitmek için null olmasının sebebi ise önceden eklemedi ise normal gitmesi için
  bool? favorite = false;
  var dialog = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: _DialogContent(
              city: selectedProduct.city,
              company: selectedProduct.company,
              favorite: favorite,
              name: selectedProduct.name,
              state: selectedProduct.state,
              backgrounColor: backgroundColor,
            ),
          ));
  if (dialog is bool) {
    if (dialog == true) {
      print('evet denmiş => $dialog');
    }
    if (dialog == false) {
      print('hayır denmiş => $dialog');
    }
  }
}

class _DialogContent extends StatefulWidget {
  const _DialogContent({
    Key? key,
    required this.company,
    this.backgrounColor,
    required this.name,
    required this.state,
    required this.city,
    this.favorite = false,
  }) : super(key: key);

  final String company;
  final Color? backgrounColor;
  final String name;
  final String state;
  final String city;
  final bool? favorite;

  @override
  State<_DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<_DialogContent> {
  late bool favorite;

  @override
  void initState() {
    super.initState();
    initFavorite();
  }

  void initFavorite() {
    if (widget.favorite != null) {
      favorite = widget.favorite!;
    } else {
      favorite = false;
    }
  }

  void setFavorite() {
    setState(() {
      favorite = !favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.backgrounColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(widget.name),
            trailing: IconButton(
              onPressed: () => Navigator.of(context).pop<bool>(favorite),
              icon: const Icon(Icons.close),
            ),
          ),
          ListTile(
            title: Text(widget.company),
            subtitle: Text('${widget.state}/${widget.city}'),
            trailing: IconButton(
              onPressed: setFavorite,
              icon: Icon(
                Icons.favorite,
                color: favorite == true ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
