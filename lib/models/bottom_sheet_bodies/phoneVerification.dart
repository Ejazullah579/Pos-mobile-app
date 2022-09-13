import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro1/ui/components/TextField2.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

class PhoneVerification extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  PhoneVerification({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  bool isBusy = false;
  bool success = false;
  AuthCredential _credential;
  final TextEditingController _textEditingController = TextEditingController();

  setIsBusy(bool value) {
    setState(() {
      isBusy = value;
    });
  }

  setSuccess(bool value) async {
    setState(() {
      success = value;
    });
    await Future.delayed(Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = getThemeManager(context);
    var maxWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          color: themeManager.isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Verify Phone Number",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: !themeManager.isDarkMode ? Colors.black : Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextField2(
                    hinttext: "Verification Code",
                    con: _textEditingController,
                    textFieldIcon: Icon(Icons.code),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                      height: 47,
                      width: 70,
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: isBusy
                          ? success
                              ? Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                          : TextButton(
                              child: Text("Verify",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                setIsBusy(true);
                                var updateResult;
                                Function authFunction =
                                    widget.request.customData[1];
                                Function updateFunction =
                                    widget.request.customData[2];
                                _credential = PhoneAuthProvider.credential(
                                    verificationId:
                                        widget.request.customData[0],
                                    smsCode:
                                        _textEditingController.text.trim());
                                try {
                                  var result = await authFunction(_credential);
                                  if (result is UserCredential) {
                                    updateResult = await updateFunction();
                                  }
                                  await setSuccess(true);
                                  await setIsBusy(false);
                                  if (updateResult != null) {
                                    if (updateResult is String) {
                                      Navigator.pop(
                                        context,
                                        SheetResponse(confirmed: false),
                                      );
                                    } else if (updateResult is bool) {
                                      Navigator.pop(
                                        context,
                                        SheetResponse(confirmed: true),
                                      );
                                    }
                                  } else {
                                    Navigator.pop(
                                      context,
                                      SheetResponse(confirmed: false),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  Navigator.pop(
                                    context,
                                    SheetResponse(
                                        confirmed: null,
                                        responseData:
                                            "The entered verification code was invalid. Please provide a valid verification code sent to your number and try again."),
                                  );
                                } catch (e) {
                                  print(e);
                                  Navigator.pop(
                                    context,
                                    SheetResponse(
                                        confirmed: null,
                                        responseData: e.message),
                                  );
                                }
                              },
                            )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
