import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../DTPaymentScreen.dart';
import 'order_edit.dart';

class Orders extends StatelessWidget {
  final DeviceScreenType deviceScreenType;

  const Orders({Key? key, required this.deviceScreenType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff131e29),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              // const DTDashboardScreen().launch;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 640,
              width: 1180,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: FutureBuilder(
                future: getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List Orders = snapshot.data as List;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Orders",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {}),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SingleChildScrollView(
                                    child: Column(
                                      children: List.generate(
                                        Orders.length,
                                        (index) => Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 20),
                                          child: ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Text(
                                                Orders[index]['services'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            leading: Orders[index]['image'] ==
                                                    'null'
                                                ? const CircleAvatar(
                                                    child: Icon(Icons.person),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            Orders[index]
                                                                ['image']),
                                                      ),
                                                    ),
                                                  ),
                                            trailing: Orders[index]
                                                        ['isAccept'] ==
                                                    0
                                                ? Column(
                                                    children: [
                                                      const Text(
                                                        'Waiting',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              OrdersEdit(
                                                                data: Orders[
                                                                    index],
                                                              ).launch(context);
                                                            },
                                                            child: const Text(
                                                                'Info')),
                                                      )
                                                    ],
                                                  )
                                                : Orders[index]['isAccept'] == 1
                                                    ? Column(
                                                        children: [
                                                          const Text(
                                                            'Accepted',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      OrdersEdit(
                                                                        data: Orders[
                                                                            index],
                                                                      ).launch(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Info')),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      const DTPaymentScreen()
                                                                          .launch(
                                                                              context);
                                                                    },
                                                                    child: const Text(
                                                                        'pay')),
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          const Text(
                                                            'Rejected',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      OrdersEdit(
                                                                        data: Orders[
                                                                            index],
                                                                      ).launch(
                                                                          context);
                                                                    },
                                                                    child: const Text(
                                                                        'Info')),
                                                          )
                                                        ],
                                                      ),
                                            subtitle:
                                                Text(Orders[index]['craftman']),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.feedback),
                              const SizedBox(width: 10),
                              Text(
                                "Herafy For All Services",
                                style: TextStyle(
                                    color: Theme.of(context).iconTheme.color),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }

  Future getOrders() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('request')
        .get();
    return qn.docs;
  }
}
