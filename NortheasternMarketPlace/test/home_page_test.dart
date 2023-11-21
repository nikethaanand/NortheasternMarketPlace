import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/login.dart';
import 'package:mockito/mockito.dart';
import 'package:gtk_flutter/home_page.dart';
import 'package:provider/provider.dart';

class MockUser extends Mock implements User {}

class MockUserProvider extends Mock implements UserProvider {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('MyHomePage', () {
    late MockFirebaseFirestore mockFirestore;
    late MyHomePage myHomePage;
    late MockUserProvider mockUserProvider;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      myHomePage = MyHomePage(firebaseFirestore: mockFirestore);
      mockUserProvider = MockUserProvider();
    });

    testWidgets('MyHomePage should build', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: myHomePage,
        ),
      );
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(3));
      expect(find.byType(Padding), findsNWidgets(3));
      expect(find.text('Welcome Husky. Start your navigation here :-)'),
          findsOneWidget);
      expect(find.text('Picks for you'), findsOneWidget);
    });

    testWidgets('Popup menu button should display',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: myHomePage,
        ),
      );
      expect(find.byType(PopupMenuButton), findsOneWidget);
    });

    test('ProductProvider should notify listeners', () {
      final productProvider = ProductProvider();
      final mockUser = MockUser();

      expect(productProvider.user, null);

      productProvider.setProduct(mockUser);

      expect(productProvider.user, isA<User>());
    });

    testWidgets('Popup menu button displays options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<UserProvider>(
            create: (_) => mockUserProvider,
            child: myHomePage,
          ),
        ),
      );

      final popupButtonFinder = find.byType(PopupMenuButton);
      expect(popupButtonFinder, findsOneWidget);
    });
  });
}
