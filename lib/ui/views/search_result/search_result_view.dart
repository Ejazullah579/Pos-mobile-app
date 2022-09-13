import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro1/models/self_product.dart';
import 'package:pro1/ui/components/headings.dart';
import 'package:pro1/ui/components/search_field.dart';
import 'package:pro1/ui/views/search_result/search_result_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';

class SearchResultView extends StatelessWidget {
  SearchResultView({Key key}) : super(key: key);
  FocusNode _focusNode = FocusNode();

  // final SearchService searchService = locator<SearchService>();
  // final GlobalService globalService = locator<GlobalService>();
  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    final maxheight = MediaQuery.of(context).size.height;
    final maxwidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SearchResultViewModel(),
      onModelReady: (model) {
        // model.drawData();
      },
      builder: (context, SearchResultViewModel model, child) => Scaffold(
        // floatingActionButton: Container(
        //   height: 50,
        //   child: FloatingActionButton.extended(
        //       icon: Icon(Icons.clear),
        //       heroTag: "btn1",
        //       backgroundColor:
        //           themeManager.isDarkMode ? Colors.white10 : Colors.blue,
        //       label: Text("Clear All"),
        //       onPressed: () async {
        //         // function() {
        //         //   return model.searchService.deleteAllData();
        //         // }
        //         if (model.products.length > 0) {
        //           return model.searchService.deleteAllData();
        //         }
        //       }),
        // ),
        body: GestureDetector(
          onTap: () {
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            _focusNode.unfocus();
          },
          child: Container(
            color: themeManager.isDarkMode ? Colors.black : Colors.white,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        model.products.length > 0 && model.products != null
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.only(left: 16, right: 16),
                                padding: const EdgeInsets.only(top: 15.0),
                                child: ListView.builder(
                                  padding: EdgeInsets.only(bottom: 80),
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: model.products.length,
                                  itemBuilder: (context, index) {
                                    return SerachListTile(
                                      maxwidth: maxwidth,
                                      product: model.products[index],
                                      themeManager: themeManager,
                                    );
                                  },
                                ),
                              )
                            : Container(
                                height: maxheight - 300,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      _focusNode.requestFocus();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        model.searchService.searchValue ==
                                                    null ||
                                                model.searchService.searchValue
                                                        .length ==
                                                    0 ||
                                                model.searchService
                                                        .searchValue ==
                                                    ""
                                            ? "Tap to Search local products"
                                            : "Product not Found",
                                        style: GoogleFonts.inter(
                                            fontSize: 20,
                                            color: themeManager.isDarkMode
                                                ? Colors.white
                                                : Colors.black54,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                ///// Real Search Field
                /// From Global Components folder
                Positioned(
                  bottom: 0,
                  child: Container(
                      height: 85,
                      width: maxwidth,
                      child: SearchField(
                        focusNode: _focusNode,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SerachListTile extends StatelessWidget {
  const SerachListTile({
    Key key,
    this.product,
    @required this.maxwidth,
    this.themeManager,
  }) : super(key: key);
  final SelfProduct product;
  final double maxwidth;
  final ThemeManager themeManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      width: maxwidth,
      margin: EdgeInsets.only(
        bottom: 13,
      ),
      padding: EdgeInsets.only(left: 24, right: 22, top: 12, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: themeManager.isDarkMode ? Colors.white24 : Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(8.0, 8.0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 57,
                width: 57,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("assets/images/fire.png"))),
              ),
              SizedBox(
                width: 13,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headings(text: product.salePrice.toString() + "\$"),
                  Container(
                    width: maxwidth * 0.55,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        product.productName,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: themeManager.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
