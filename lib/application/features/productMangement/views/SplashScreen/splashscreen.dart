import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machinetest/application/features/productMangement/auth_bloc/auth_bloc.dart';

class SplashPageWrapper extends StatelessWidget {
  const SplashPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context)=>AuthBloc()..add(CheckLoginStatusEvent()),
      child: SplashPage(),);
  }
}



class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(listener: (context,state){


      if(state is Authenticated){


        Navigator.pushReplacementNamed(context, '/mpin');
      }else if(state is UnAuthenticated){

        Navigator.pushReplacementNamed(context, '/login');

      }
    },

      child:  Scaffold(
        backgroundColor: Colors.black54,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/e-commerce.webp',
                  height: 350,
                  width: 350,
                ),
              ),
              Text(
                "Product Management App",
                style: Theme.of(context).textTheme.displayLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
