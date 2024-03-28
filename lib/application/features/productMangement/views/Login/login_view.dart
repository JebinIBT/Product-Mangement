
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/application/features/productMangement/auth_bloc/auth_bloc.dart';
import 'package:machinetest/application/features/productMangement/views/Common%20Widget/commonbutton.dart';


class LoginViewWrapper extends StatelessWidget {
  const LoginViewWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: LoginPage(),
    );
  }
}
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    emailcontroller.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Widget build(BuildContext context) {
    final authblocc = BlocProvider.of<AuthBloc>(context);
    return
      BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        );
      }
      if (state is Authenticated) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }
      return
        Scaffold(
// backgroundColor:Colors.deepPurple.shade400,
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sign In",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                SizedBox(
                  height: 30,
                ),
                Text("Enter your user information below or continue with ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                Text(" one of your social accounts",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    prefixIconColor: Colors.grey,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    enabled: true,
                    contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: Icon(CupertinoIcons.eye_slash_fill),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    enabled: true,
                    contentPadding:
                    EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey),
                      borderRadius: new BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password ?",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey))),
                SizedBox(
                  height: 20,
                ),
                CommonButton(
                  title: 'Sign In',
                  onClick: () {
                    authblocc.add(LoginEvent(
                        password: passwordController.text.trim(),
                        email: emailcontroller.text.trim()));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text('Does not have an account ?'),
                    TextButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.red[400]),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        );
    });
  }
}




