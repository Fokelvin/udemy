import 'package:flutter/painting.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends Model{

  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;

  Map<String, dynamic> userData = {};

  void signUp({

    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,

    }) {
      
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
      email: userData["email"], 
      password: pass,
      ).then((userCredential)async {
        firebaseUser = userCredential.user;

        await _saveUserData(userData);

        onSuccess();
        isLoading = false;
        notifyListeners();
      }).catchError((onError){
        onFail();
        isLoading = false;
        notifyListeners();
      });
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass(){
    
  }

  bool? isLogged(){

  }

  Future<void> _saveUserData (Map<String, dynamic> userData)async {
    this.userData = userData;
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser?.uid).set(userData);
  }
}

