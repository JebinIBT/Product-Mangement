import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machinetest/application/features/productMangement/models/user_model.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(Duration(seconds: 2), () {
          user = _auth.currentUser;
        });

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });
    on<checkMpinEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Fetch the MPIN stored in Cloud Firestore
          DocumentSnapshot snapshot =
              await _firestore.collection('users').doc(user.uid).get();
          String? storedMpin = snapshot['mPin'];
          print("storedMpin::$storedMpin");
          if (storedMpin != null && storedMpin == event.mPin) {
            print("Sucesfull::::");
            emit(Authenticated(user));
          }
          emit(UnAuthenticated());
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: event.user!.email.toString(),
            password: event.user!.password.toString());

        final user = userCredential.user;

        if (user != null) {
          FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'name': event.user!.name,
            'phone': event.user!.phone,
            'mPin': event.user.mPin,
            'createdAt': DateTime.now()
          });
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        final user = userCredential.user;

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });
  }
}
