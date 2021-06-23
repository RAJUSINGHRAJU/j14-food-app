import 'package:flutter/material.dart';
import 'package:food_app/models/place.dart';
import 'package:food_app/services/location_api.dart';
import 'package:provider/provider.dart';

class AddressSearch extends StatefulWidget {
  @override
  _AddressSearchState createState() => _AddressSearchState();
}

class _AddressSearchState extends State<AddressSearch> {
  @override
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchInjector(
        child: SafeArea(
          child: Consumer<LocationApi>(
            builder: (_, api, child) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      child: TextField(
                        controller: api.addressController,
                        style:
                            TextStyle(fontSize: 16, color: Color(0xfffe9721)),
                        keyboardType: TextInputType.text,
                        decoration: buildInputDecoration(
                            Icons.location_city, "Search Address"),
                        onChanged: api.handleSearch,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: StreamBuilder<List<Place>>(
                          stream: api.controllerOut,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Center(
                                  child: Text('No data address found'));
                            }
                            final data = snapshot.data;
                            return Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                child: Container(
                                  child: Builder(builder: (context) {
                                    return Column(
                                        children:
                                            List.generate(data.length, (index) {
                                      final place = data[index];
                                      return ListTile(
                                        onTap: () {
                                          api.addressController.text =
                                              '${place.name}, ${place.street}, ${place.country}';
                                          Navigator.pop(context,
                                              api.addressController.text);
                                        },
                                        title: Text(
                                            '${place.name}, ${place.street}'),
                                        subtitle: Text('${place.country}'),
                                      );
                                    }));
                                  }),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    filled: true,
    fillColor: Colors.white.withOpacity(0.11),
    hintStyle: TextStyle(color: Color(0xfffe9721)),
    prefixIcon: Icon(icons, color: Color(0xfffe9721)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Color(0xfffe9721), width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xfffe9721),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: Color(0xfffe9721),
        width: 1.5,
      ),
    ),
  );
}

class SearchInjector extends StatelessWidget {
  final Widget child;
  const SearchInjector({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationApi(),
      child: child,
    );
  }
}
