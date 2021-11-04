import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignupState();
  }
}

class _SignupState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("認証")
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("認証")
          ],
        ),
      ),
    );
  }

}