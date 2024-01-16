// import 'package:bloc_auth_flow/controllers/home/home_bloc.dart';
// import 'package:bloc_auth_flow/controllers/home/home_event.dart';
// import 'package:bloc_auth_flow/controllers/home/home_state.dart';
// import 'package:bloc_auth_flow/injection.dart';
// import 'package:bloc_auth_flow/routes/router.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:starlight_utils/starlight_utils.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeBloc homeBloc = context.read<HomeBloc>();

//     return BlocListener<HomeBloc, HomeBaseState>(
//       listener: (_, state) {
//         if (state is HomeUserSignOutState) {
//           StarlightUtils.pushReplacementNamed(RouteNames.login);
//         }
//       },
//       child: Scaffold(
//         key: homeBloc.drawerKey,
//         appBar: AppBar(
//           title: const Text("Auth Flow"),
//           leading: IconButton(
//               onPressed: () {
//                 homeBloc.drawerKey.currentState?.openDrawer();
//               },
//               icon: const Icon(Icons.menu)),
//         ),
//         drawer: Drawer(
//           child: Column(children: [
//             UserAccountsDrawerHeader(
//                 currentAccountPicture: InkWell(
//                   onTap: () {
//                     homeBloc.add(const UploadProfileEvent());
//                   },
//                   child:
//                       BlocBuilder<HomeBloc, HomeBaseState>(builder: (_, state) {
//                     final isNotUploaded = state.user?.photoURL == null;

//                     if (isNotUploaded) {
//                       return CircleAvatar(
//                           child: Text(
//                         (state.user?.displayName ??
//                                 state.user?.email ??
//                                 "NA")[0]
//                             .toUpperCase(),
//                         style:
//                             const TextStyle(color: Colors.black, fontSize: 18),
//                       ));
//                     }
//                     return FutureBuilder(
//                         future: Injection<FirebaseStorage>()
//                             .ref(state.user?.photoURL)
//                             .getDownloadURL(),
//                         builder: (_, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const CircleAvatar(
//                                 child: CupertinoActivityIndicator());
//                           }

//                           final url = snapshot.data;
//                           if (url == null) {
//                             return CircleAvatar(
//                                 child: Text(
//                               (state.user?.displayName ??
//                                       state.user?.email ??
//                                       "NA")[0]
//                                   .toUpperCase(),
//                               style: const TextStyle(
//                                   color: Colors.black, fontSize: 18),
//                             ));
//                           }
//                           return ClipOval(
//                             child: Image.network(
//                               url,
//                               fit: BoxFit.cover,
//                               loadingBuilder:
//                                   (context, child, loadingProgress) {
//                                 if (loadingProgress == null) return child;
//                                 return const CupertinoActivityIndicator();
//                               },
//                             ),
//                           );
//                         });
//                   }),
//                 ),
//                 accountName: BlocBuilder<HomeBloc, HomeBaseState>(
//                     buildWhen: (previous, current) =>
//                         previous.user?.displayName != current.user?.displayName,
//                     builder: (_, state) {
//                       return Text(state.user?.displayName ?? "NA");
//                     }),
//                 accountEmail: BlocBuilder<HomeBloc, HomeBaseState>(
//                     buildWhen: (previous, current) =>
//                         previous.user?.email != current.user?.email,
//                     builder: (_, state) {
//                       print("email rebuild");
//                       return Text(state.user?.email ?? "NA");
//                     })),
//             Expanded(
//                 child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       homeBloc.add(const HomeDisplayNameChangeEvent());
//                     },
//                     title: const Text("Change Name"),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       homeBloc.add(const HomeMailChangeEvent());
//                     },
//                     title: const Text("Change Mail"),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       homeBloc.add(const HomePasswordUpdate());
//                     },
//                     title: const Text("Change Password"),
//                   )
//                 ],
//               ),
//             )),
//             ListTile(
//               title: const Text("Sign Out"),
//               leading: const Icon(Icons.logout),
//               onTap: () {
//                 homeBloc.add(const HomeSignOutEvent());
//               },
//             ),
//             const ListTile(
//               title: Text("Version 1.0.0"),
//             )
//           ]),
//         ),
//       ),
//     );
//   }
// }

import 'package:bloc_auth_flow/controllers/home/home_bloc.dart';
import 'package:bloc_auth_flow/controllers/home/home_state.dart';
import 'package:bloc_auth_flow/injection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../../controllers/home/home_event.dart';
import '../../routes/router.dart';

///Top Level Function
void goToUpdateUsernameScreen() {
  StarlightUtils.pop();
  Future.delayed(const Duration(milliseconds: 200), () {
    StarlightUtils.pushNamed(RouteNames.updateUsername);
  });
}

void goToUpdateEmailScreen() {
  StarlightUtils.pop();
  Future.delayed(const Duration(milliseconds: 200), () {
    StarlightUtils.pushNamed(RouteNames.updateEmail);
  });
}

void goToUpdatePasswordScreen() {
  StarlightUtils.pop();
  Future.delayed(const Duration(milliseconds: 200), () {
    StarlightUtils.pushNamed(RouteNames.updatePassword);
  });
}

void goToNoteCreateScreen() {
  StarlightUtils.pushNamed(RouteNames.createNote);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = context.read<HomeBloc>();
    // Future.delayed(Duration(seconds: 3), () {
    //   Injection<AuthService>().signOut();
    // });
    return BlocListener<HomeBloc, HomeBaseState>(
      listener: (_, state) {
        if (state is HomeUserSignOutState) {
          StarlightUtils.pushReplacementNamed(RouteNames.login);
        }
      },
      child: Scaffold(
        key: homeBloc.drawerKey,
        drawer: Drawer(
          child: Column(
            children: [
              // BlocBuilder<HomeBloc, HomeBaseState>(
              //   builder: (_, state) {
              //     Future(() {
              //       Injection<AuthService>()
              //           .currentUser
              //           ?.updateDisplayName("Hello");
              //     });
              //     return UserAccountsDrawerHeader(
              //       currentAccountPicture: CircleAvatar(
              //         backgroundImage: NetworkImage(state.user?.photoURL ?? ""),
              //       ),
              //       accountName: Text(state.user?.displayName ?? "NA"),
              //       accountEmail: Text(state.user?.email ?? "NA"),
              //     );
              //   },
              // )
              UserAccountsDrawerHeader(
                currentAccountPicture: InkWell(
                  onTap: () {
                    homeBloc.add(const UploadProfileEvent());
                  },
                  child: BlocBuilder<HomeBloc, HomeBaseState>(
                    builder: (_, state) {
                      final isNotUploaded = state.user?.photoURL == null;
                      final value =
                          (state.user?.displayName ?? state.user?.email ?? "");
                      if (isNotUploaded) {
                        return CircleAvatar(
                          child: Text(
                            value.isNotEmpty ? value[0] : "NA".toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      return FutureBuilder(
                          future: Injection<FirebaseStorage>()
                              .ref(state.user?.photoURL)
                              .getDownloadURL(),
                          builder: (_, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircleAvatar(
                                child: CupertinoActivityIndicator(),
                              );
                            }
                            final url = snapshot.data;
                            if (url == null) {
                              return CircleAvatar(
                                child: Text(
                                  (state.user?.displayName ??
                                          state.user?.email ??
                                          "NA")[0]
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            return ClipOval(
                              child: Image.network(
                                url,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, c) {
                                  if (c == null) return child;
                                  return const CupertinoActivityIndicator();
                                },
                              ),
                            );
                          });
                    },
                  ),
                ),
                accountName: BlocBuilder<HomeBloc, HomeBaseState>(
                  buildWhen: (pre, cur) =>
                      pre.user?.displayName != cur.user?.displayName,
                  builder: (_, state) {
                    // Future(() {
                    //   Injection<AuthService>().currentUser?.updateDisplayName(
                    //       Random.secure().nextInt(100).toString());
                    // });
                    print("Account Name Rebuild");
                    return Text(state.user?.displayName ?? "NA");
                  },
                ),
                accountEmail: BlocBuilder<HomeBloc, HomeBaseState>(
                  buildWhen: (pre, cur) => pre.user?.email != cur.user?.email,
                  builder: (_, state) {
                    print("Email Rebuild");
                    return Text(state.user?.email ?? "NA");
                  },
                ),
              ),

              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      ///Normal Function
                      ListTile(
                        onTap: goToUpdateUsernameScreen,
                        title: Text("Change Username"),
                      ),
                      ListTile(
                        onTap: goToUpdateEmailScreen,
                        title: Text("Change Email"),
                      ),
                      ListTile(
                        onTap: goToUpdatePasswordScreen,
                        title: Text("Change Password"),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  homeBloc.add(const HomeSignOutEvent());
                },
                leading: const Icon(Icons.logout),
                title: const Text("Sign Out"),
              ),
              const ListTile(
                title: Text("Version 1.0.0"),
              )
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => homeBloc.drawerKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu),
          ),
          title: const Text("Auth Flow"),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: goToNoteCreateScreen,
          child: Icon(Icons.edit),
        ),
      ),
    );
  }
}
