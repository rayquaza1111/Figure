import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app_upd/Pages/HomePage.dart';
import 'package:shop_app_upd/Pages/User/RegisterUser.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();

  bool togglePass = true;
  bool isLoggedIn = false;
  bool isLoading = false;
  bool haveError = false;

  String errorMessage;

  Future<FirebaseUser> signInWithGoogle() async {
    // Attempt to get the currently authenticated user
    try{

      if (this.mounted){
        setState((){
          isLoading = true;
        });
      }

      GoogleSignInAccount currentUser = googleSignIn.currentUser;

      if (currentUser == null) {
        // Attempt to sign in without user interaction
        currentUser = await googleSignIn.signInSilently();
      }

      if (currentUser == null) {
        // Force the user to interactively sign in
        currentUser = await googleSignIn.signIn();
      }

      final GoogleSignInAuthentication googleAuth =
      await currentUser.authentication;

      // Authenticate with firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await firebaseAuth.signInWithCredential(credential)).user;

      assert(user != null);
      assert(!user.isAnonymous);

      Fluttertoast.showToast(
          msg: "Logged in succesfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user,)));

      return user;
    }on PlatformException catch (e){
      setState(() {
        isLoading = false;
        errorMessage = e.message;
        haveError = true;
      });
      _showError(errorMessage);
    }
  }

  Future<FirebaseUser> initiateFacebookLogin() async {

    if (this.mounted){
      setState((){
        isLoading = true;
      });
    }

    final facebookLogin = FacebookLogin();
    final facebookLoginResult = await facebookLogin.logIn(["email"]);
    switch (facebookLoginResult.status) {

      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:

        print("LoggedIn");
        final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: facebookLoginResult.accessToken.token);
        final FirebaseUser user = (await firebaseAuth.signInWithCredential(credential)).user;
        onLoginStatusChanged(true);
        Fluttertoast.showToast(
            msg: "Logged in succesfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        setState(() {
          isLoading = false;
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(user: user,)));

        return user;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white10.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset("images/logos/logo.png",
                width: 200, height: 200,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context,constraints){
              if(constraints.maxWidth < 350){
                return Padding(
                  padding: const EdgeInsets.only(top: 160.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _emailEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      icon: Icon(Icons.email),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid)
                                        return "Please make sure your email address is correct!";
                                      else
                                        return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Password
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                    title: TextFormField(
                                      obscureText: togglePass,
                                      controller: _passwordEditingController,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          icon: Icon(Icons.lock),
                                          border: InputBorder.none
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "The password field cannot be empty";
                                        } else if (value.length < 6) {
                                          return "The password has to be at least 6 characters long";
                                        }
                                        return null;
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                      setState(() {
                                        togglePass = !togglePass;
                                      });
                                    },)
                                ),
                              ),
                            ),
                          ),
                          //Login
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30.0,15.0,30.0,0.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  loginToHomePage();
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text("Login",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Forgot Password
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
//                                      onPressed: () {
//                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
//                                      },
                                      child: Text("Forgot password", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                                  ),
                                ),
                              ),
                              //Sign Up!!!
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Create an account", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0,5.0,0.0,20.0),
                            child: Text("Or", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18.0, letterSpacing: 2.0),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              //Log in with Facebook
                              Padding(
                                padding: const EdgeInsets.only(left: 60.0),
                                child: InkWell(
                                    onTap: (){
                                      initiateFacebookLogin().then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_facebook.png", width: 45, height: 50 ,)),
                              ),
                              //Log in with Google
                              Padding(
                                padding: const EdgeInsets.only(left: 110.0),
                                child:InkWell(
                                    onTap: (){
                                      signInWithGoogle()
                                          .then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_google.png", width: 45, height: 50 ,)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 351 && constraints.maxWidth < 410){
                return Padding(
                  padding: const EdgeInsets.only(top: 195.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _emailEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      icon: Icon(Icons.email),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid)
                                        return "Please make sure your email address is correct!";
                                      else
                                        return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Password
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                    title: TextFormField(
                                      obscureText: togglePass,
                                      controller: _passwordEditingController,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          icon: Icon(Icons.lock),
                                          border: InputBorder.none
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "The password field cannot be empty";
                                        } else if (value.length < 6) {
                                          return "The password has to be at least 6 characters long";
                                        }
                                        return null;
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                      setState(() {
                                        togglePass = !togglePass;
                                      });
                                    },)
                                ),
                              ),
                            ),
                          ),
                          //Login
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30.0,15.0,30.0,0.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  loginToHomePage();
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text("Login",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Forgot Password
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(19.0,10.0,0.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
//                                      onPressed: () {
//                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
//                                      },
                                      child: Text("Forgot password", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                                  ),
                                ),
                              ),
                              //Sign Up!!!
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Create an account", style: TextStyle(color: Colors.black, fontSize: 16.0),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0,5.0,0.0,20.0),
                            child: Text("Or", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18.0, letterSpacing: 2.0),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              //Log in with Facebook
                              Padding(
                                padding: const EdgeInsets.only(left: 70.0),
                                child: InkWell(
                                    onTap: (){
                                      initiateFacebookLogin().then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_facebook.png", width: 45, height: 50 ,)),
                              ),
                              //Log in with Google
                              Padding(
                                padding: const EdgeInsets.only(left: 120.0),
                                child:InkWell(
                                    onTap: (){
                                      signInWithGoogle()
                                          .then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_google.png", width: 45, height: 50 ,)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 411 && constraints.maxWidth < 500){
                return Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _emailEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      icon: Icon(Icons.email),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid)
                                        return "Please make sure your email address is correct!";
                                      else
                                        return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Password
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                    title: TextFormField(
                                      obscureText: togglePass,
                                      controller: _passwordEditingController,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          icon: Icon(Icons.lock),
                                          border: InputBorder.none
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "The password field cannot be empty";
                                        } else if (value.length < 6) {
                                          return "The password has to be at least 6 characters long";
                                        }
                                        return null;
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                      setState(() {
                                        togglePass = !togglePass;
                                      });
                                    },)
                                ),
                              ),
                            ),
                          ),
                          //Login
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30.0,30.0,30.0,0.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  loginToHomePage();
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text("Login",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Forgot Password
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Forgot password", style: TextStyle(color: Colors.black, fontSize: 18.0),)
                                  ),
                                ),
                              ),
                              //Sign Up!!!
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13.0,10.0,8.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Create an account", style: TextStyle(color: Colors.black, fontSize: 18.0),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0,20.0,0.0,30.0),
                            child: Text("Or", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18.0, letterSpacing: 2.0),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              //Log in with Facebook
                              Padding(
                                padding: const EdgeInsets.only(left: 110.0),
                                child: InkWell(
                                    onTap: (){
                                      initiateFacebookLogin().then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_facebook.png", width: 45, height: 50 ,)),
                              ),
                              //Log in with Google
                              Padding(
                                padding: const EdgeInsets.only(left: 100.0),
                                child:InkWell(
                                    onTap: (){
                                      signInWithGoogle()
                                          .then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_google.png", width: 45, height: 50 ,)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 501){
                return Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _emailEditingController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      icon: Icon(Icons.email),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!emailValid)
                                        return "Please make sure your email address is correct!";
                                      else
                                        return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Password
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                    title: TextFormField(
                                      obscureText: togglePass,
                                      controller: _passwordEditingController,
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          icon: Icon(Icons.lock),
                                          border: InputBorder.none
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "The password field cannot be empty";
                                        } else if (value.length < 6) {
                                          return "The password has to be at least 6 characters long";
                                        }
                                        return null;
                                      },
                                    ),
                                    trailing: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: (){
                                      setState(() {
                                        togglePass = !togglePass;
                                      });
                                    },)
                                ),
                              ),
                            ),
                          ),
                          //Login
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30.0,30.0,30.0,0.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  loginToHomePage();
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text("Login",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Forgot Password
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Forgot password", style: TextStyle(color: Colors.black, fontSize: 18.0),)
                                  ),
                                ),
                              ),
                              //Sign Up!!!
                              Padding(
                                padding: const EdgeInsets.fromLTRB(13.0,10.0,8.0,0.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white70.withOpacity(0.9),
                                  elevation: 0.0,
                                  child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                                      },
                                      child: Text("Create an account", style: TextStyle(color: Colors.black, fontSize: 18.0),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0,20.0,0.0,30.0),
                            child: Text("Or", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 18.0, letterSpacing: 2.0),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              //Log in with Facebook
                              Padding(
                                padding: const EdgeInsets.only(left: 110.0),
                                child: InkWell(
                                    onTap: (){
                                      initiateFacebookLogin().then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_facebook.png", width: 45, height: 50 ,)),
                              ),
                              //Log in with Google
                              Padding(
                                padding: const EdgeInsets.only(left: 100.0),
                                child:InkWell(
                                    onTap: (){
                                      signInWithGoogle()
                                          .then((FirebaseUser user) => Firestore.instance.collection("users").document(user.uid).setData({
                                        "username" : user.displayName,
                                        "email" : user.email,
                                        "userId" : user.uid,
                                        "role" : "client",
                                        "image" : user.photoUrl
                                      })).catchError((e) => print(e));
                                    },
                                    child: Image.asset("images/products/icon_google.png", width: 45, height: 50 ,)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }else return null;
            },
          ),
          haveError ? _showError(errorMessage) : Text(""),
          isLoading ? Container(alignment: Alignment.center,child: Center(child: CircularProgressIndicator(),),) : Text("")
        ],
      ),
    );
  }

  Future loginToHomePage() async{
    FormState formState = _formKey.currentState;

    if (formState.validate()) {

      try{

        if (this.mounted){
          setState((){
            isLoading = true;
          });
        }

        AuthResult result = await firebaseAuth.signInWithEmailAndPassword(
            email: _emailEditingController.text,
            password: _passwordEditingController.text
        );
        FirebaseUser user = result.user;

        final FirebaseUser currentUser = await firebaseAuth.currentUser();

        DocumentReference docRef = Firestore.instance.collection("users").document(user.uid);

        // ignore: missing_return
        docRef.get().then((documentSnapshot) async {
          if(documentSnapshot["isLoggedIn"] == true){
            Firestore.instance.collection("users").document(user.uid).updateData({
              "isLoggedIn" : true
            });

            assert(user != null);
            assert(await user.getIdToken() != null);

            assert(user.uid == currentUser.uid);

            Fluttertoast.showToast(
                msg: "Logged in successfully!!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0
            );

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: user,)));
          }else if(documentSnapshot["isLoggedIn"] == false ){
            Firestore.instance.collection("users").document(user.uid).updateData({
              "isLoggedIn" : true
            });

            assert(user != null);
            assert(await user.getIdToken() != null);

            assert(user.uid == currentUser.uid);

            Fluttertoast.showToast(
                msg: "Logged in successfully!!",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0
            );

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: user,)));
          }else{
            Fluttertoast.showToast(
                msg: "Maybe have some errors",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        });

        formState.reset();

        return user;

      }on PlatformException catch(e){
        setState(() {
          isLoading = false;
          errorMessage = e.message;
          haveError = true;
        });
        _showError(errorMessage);
      }
    }
  }

  _showError(String errorMessage){
    return Dialog(child: Text(errorMessage,style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),textAlign: TextAlign.center,), insetAnimationDuration: Duration(milliseconds: 1000),);
  }
}
