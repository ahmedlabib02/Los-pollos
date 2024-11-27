// lib/screens/wrapper.dart

import 'package:flutter/material.dart';
// import 'package:los_pollos_hermanos/models/client_model.dart';
import 'package:los_pollos_hermanos/models/customUser.dart';
import 'package:los_pollos_hermanos/screens/authenticate/authenticate.dart';
import './Client/home.dart';
import './Manager/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      if (user.role == 'client') {
        return const ClientHome();
      } else {
        return const ManagerHome();
      }
    }
  }
}
