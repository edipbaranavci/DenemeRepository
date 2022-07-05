import 'package:flutter/material.dart';
import 'package:task/services/json_service.dart';
import 'package:task/models/product.dart';

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
            showCustomDialog(context, cproducts[index]);
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

void showCustomDialog(BuildContext context, Product selectedProduct) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 240,
          width: 320,
          child: SizedBox.expand(
              child: Column(
            children: [
              Text(
                selectedProduct.name,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          )),
          margin: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: NetworkImage(getImageUrl(selectedProduct.category)),
              fit: BoxFit.fitWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
      );
    },
  );
}
