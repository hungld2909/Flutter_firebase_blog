import 'package:flutter/material.dart';
import 'authentication.dart';
import 'dialogBox.dart';

class LoginRegisterPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  const LoginRegisterPage({this.auth, this.onSignedIn});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  DialogBox dialogBox = DialogBox();

  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  //methods
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          String userId = await widget.auth.signIn(_email, _password);
          // dialogBox.information(
          //     context, "Congratulations", "you are logged in successfully.");

          print('Login userId = ' + userId);
        } else {
          String userId = await widget.auth.signUp(_email, _password);
          // dialogBox.information(context, "Congratulations",
          //     "your account has been created successfully.");
          print('Register userId = ' + userId);
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, "Error = ", e.toString());
        print("Error = " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState
        .reset(); //todo: dùng để xóa những keyword khi điền ở form. đăng nhập.
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState
        .reset(); //todo: dùng để xóa những keyword khi điền ở form. đăng nhập.
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Blog App'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 10,
      ),
      logo(),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) {
          return value.isEmpty ? 'Email is requied.' : null;
        },
        onSaved: (value) {
          return _email = value;
        },
      ),
      SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
        ),
        obscureText: true,
        validator: (value) {
          return value.isEmpty ? 'Pass is requied.' : null;
        },
        onSaved: (value) {
          return _password = value;
        },
      ),
      SizedBox(
        height: 20,
      ),
    ];
  }

  Widget logo() {
    return Hero(
        tag: 'Hero',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 110,
          child: Image.asset('images/hihi.jpg'),
        ));
  }

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text(
            "Login",
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.white,
          color: Colors.pink,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Not have an Account? Create Account?",
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.red,
          color: Colors.white,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text(
            "Register",
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.white,
          color: Colors.pink,
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            "Already have an Account? Login",
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.red,
          color: Colors.white,
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
