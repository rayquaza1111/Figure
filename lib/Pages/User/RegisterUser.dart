import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  TextEditingController _nameEditTingController = TextEditingController();
  TextEditingController _confirmPasswordEditTingController = TextEditingController();

  bool hidePass = true;
  bool isLoading = false;
  bool haveError = false;

  String errorMessage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: Center(
          child: CircularProgressIndicator(),
        ),) : Stack(
        children: <Widget>[
          Container(
            color: Colors.white10.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset("images/products/logo_background.png",
                width: 170, height: 170,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context,constraints){
              if(constraints.maxWidth < 350){
                return Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Name
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _nameEditTingController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      icon: Icon(Icons.person),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The name field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(2.0),
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
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  title: TextFormField(
                                    obscureText: hidePass,
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Confirm password
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _confirmPasswordEditTingController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        icon: Icon(Icons.lock),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "The confirm password field cannot be empty";
                                      } else if (value.length < 6) {
                                        return "The password has to be at least 6 characters long";
                                      } else
                                      if (_passwordEditingController.text != value)
                                        return "The confirm password is not like password";
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Register
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 5.0, 30.0, 5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  validationForm();
                                },
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text("Register", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Login!!!
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 8.0, 0.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "I already have an account", style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),)
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 351 && constraints.maxWidth < 410){
                return Padding(
                  padding: const EdgeInsets.only(top: 120.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Name
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _nameEditTingController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      icon: Icon(Icons.person),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The name field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          //Email
                          Padding(
                            padding: const EdgeInsets.all(2.0),
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
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  title: TextFormField(
                                    obscureText: hidePass,
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Confirm password
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListTile(
                                  title: TextFormField(
                                    controller: _confirmPasswordEditTingController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        icon: Icon(Icons.lock),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "The confirm password field cannot be empty";
                                      } else if (value.length < 6) {
                                        return "The password has to be at least 6 characters long";
                                      } else
                                      if (_passwordEditingController.text != value)
                                        return "The confirm password is not like password";
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Register
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 5.0, 30.0, 5.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async{
                                  validationForm();
                                },
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text("Register", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Login!!!
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 8.0, 0.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "I already have an account", style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),)
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 411 && constraints.maxWidth < 500){
                return Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _nameEditTingController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      icon: Icon(Icons.person),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The name field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
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
                                    obscureText: hidePass,
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Confirm password
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
                                    controller: _confirmPasswordEditTingController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        icon: Icon(Icons.lock),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "The confirm password field cannot be empty";
                                      } else if (value.length < 6) {
                                        return "The password has to be at least 6 characters long";
                                      } else
                                      if (_passwordEditingController.text != value)
                                        return "The confirm password is not like password";
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Register
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 30.0, 30.0, 10.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  validationForm();
                                },
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text("Register", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Login!!!
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "I already have an account", style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),)
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              }else if(constraints.maxWidth > 501){
                return Padding(
                  padding: const EdgeInsets.only(top: 130.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          //Name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey.withOpacity(0.3),
                              elevation: 0.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: TextFormField(
                                  controller: _nameEditTingController,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      icon: Icon(Icons.person),
                                      border: InputBorder.none
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The name field cannot be empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
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
                                    obscureText: hidePass,
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
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Confirm password
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
                                    controller: _confirmPasswordEditTingController,
                                    obscureText: hidePass,
                                    decoration: InputDecoration(
                                        hintText: "Confirm Password",
                                        icon: Icon(Icons.lock),
                                        border: InputBorder.none
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "The confirm password field cannot be empty";
                                      } else if (value.length < 6) {
                                        return "The password has to be at least 6 characters long";
                                      } else
                                      if (_passwordEditingController.text != value)
                                        return "The confirm password is not like password";
                                      return null;
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.remove_red_eye), onPressed: () {
                                    setState(() {
                                      hidePass = !hidePass;
                                    });
                                  },),
                                ),
                              ),
                            ),
                          ),
                          //Register
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                30.0, 30.0, 30.0, 10.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red,
                              elevation: 0.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  validationForm();
                                },
                                minWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: Text("Register", textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                          //Login!!!
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 8.0, 8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "I already have an account", style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0),)
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              }else return null;
            },
          ),
          haveError ? _showError(errorMessage) : Text("")
        ],
      ),
    );
  }

  validationForm() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      try {
        setState(() {
          isLoading = true;
          haveError = false;
        });

        AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
            email: _emailEditingController.text,
            password: _passwordEditingController.text);

        final FirebaseUser user = result.user;

        user.sendEmailVerification();

        Firestore.instance.collection("users").document(user.uid).setData({
          "username" : _nameEditTingController.text,
          "email" : _emailEditingController.text,
          "userId" : user.uid,
          "role" : "client",
          "image" : user.photoUrl,
          "isLoggedIn" : false
        });

        Fluttertoast.showToast(
            msg: "Please verified your email before login",
            fontSize: 18,
            textColor: Colors.white,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1
        );

        Navigator.pop(context);

        assert(user != null);
        assert(await user.getIdToken() != null);

        return user;

      } on PlatformException catch (e) {
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


