import 'package:flutter/material.dart';
import 'package:meuprofissadevflu/styles/colors.dart';
import 'package:meuprofissadevflu/styles/font_sizes.dart';

class UserTerms extends StatefulWidget {
  const UserTerms({super.key});

  @override
  _UserTermsState createState() => _UserTermsState();
}

class _UserTermsState extends State<UserTerms> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromRGBO(5, 0, 66, 1),
                    Color.fromRGBO(2, 0, 29, 1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      height: screenHeight *
                          0.03), // Espaço entre a logo e o título
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppColors.whiteColor),
                      iconSize: screenWidth * 0.1,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Termos de Uso',
                    style: TextStyle(
                      fontSize: CustomFontSize.titleFontSize,
                      fontFamily: 'GeneralSans',
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.05), // Espaço entre o título e o boxDecoration
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.elliptical(
                                screenWidth * 0.2, screenWidth * 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.02),
                          const Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque mattis sed augue et sollicitudin. Suspendisse a placerat ex. Integer a tortor nec risus fringilla iaculis. Integer quis nunc dui. Curabitur ac nisl sem. Maecenas viverra varius nulla eu gravida. Aenean tristique felis vel dictum mollis. Donec sed dictum dolor, in tempus purus. Mauris rhoncus, diam ornare blandit tincidunt, ligula metus rutrum nisi, et venenatis lacus orci vel orci. Proin varius consequat facilisis. Nulla facilisi.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: CustomFontSize.termsFontSize,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: AppColors.secondaryColor),
                              iconSize: screenWidth * 0.1,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
