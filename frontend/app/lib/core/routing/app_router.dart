// T028: go_router navigation shell. Deep-linkable routes (R18 — Flutter web serves
// crawlable/shareable URLs for public content). Feature routes are added here as
// each story lands (discover T041/T042, identity T055, etc.); this establishes the
// router provider and the one route that already exists.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
});
