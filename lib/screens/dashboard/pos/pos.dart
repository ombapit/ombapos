import 'package:flutter/material.dart';
import 'package:ombapos/screens/dashboard/pos/library_tab.dart';
import 'package:ombapos/widgets/main_drawer.dart';
import 'package:ombapos/widgets/simple_calc.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  final GlobalKey<LibraryTabState> _libraryKey = GlobalKey<LibraryTabState>();

  void callResetLibrary() {
    _libraryKey.currentState?.resetView(); // 👈 Panggil fungsi child
  }

  String _appBarTitle = "Point of Sale";
  String _appBarSubTitle = "";
  bool _showBackButton = false;
  int cartCount =
      0; // Contoh jumlah item, bisa disesuaikan dengan state aslinya

  void _exitSubPage() {
    setState(() {
      _appBarTitle = "Point of Sale";
      _appBarSubTitle = "";
      _showBackButton = false;
    });
    // reset pos library
    if (_appBarTitle == "Point of Sale") {
      callResetLibrary();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supaya leading bisa di-custom
        titleSpacing: 0, // Supaya title rata kiri
        title: Row(
          children: [
            Builder(
              builder: (context) => _showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _exitSubPage, // ❗ tombol back
                    )
                  : IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appBarTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (_appBarSubTitle.isNotEmpty)
                  Text(
                    '$_appBarSubTitle item(s)',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // TODO: Aksi saat klik keranjang
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Charge Rp 0"),
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: const [
                        Tab(text: 'LIBRARY'),
                        Tab(text: 'CUSTOM'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Konten untuk tab “Library”
                        LibraryTab(
                          key: _libraryKey,
                          onTitleChanged: (newTitle) {
                            setState(() {
                              _appBarTitle = newTitle;
                              _showBackButton = true;
                            });
                          },
                          onSubTitleChanged: (newTitle) {
                            setState(() {
                              _appBarSubTitle = newTitle;
                            });
                          },
                        ),
                        // Konten untuk tab “Custom”
                        SimpleCalc(
                          onPlus: () {
                            setState(() {
                              cartCount++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
