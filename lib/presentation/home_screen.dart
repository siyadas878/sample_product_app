import 'package:fake_store_api/presentation/product_details.dart';
import 'package:flutter/material.dart';
import '../domain/fake/fake.dart';
import '../infrastructure/api_function.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              // postApi(newdata: PostModel(
              //   title: 'crocs',
              //   category: 'foot wear',
              //   description: 'good product',
              //   image: 'https://www.bfgcdn.com/1500_1500_90/702-2085-1011/crocs-kids-classic-clog-sandals.jpg',
              //   price: 200));
            },
            icon: const Icon(Icons.trolley),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child:
                IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          )
        ],
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else {
              final List<dynamic> data = snapshot.data as List<dynamic>;
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.6),
                shrinkWrap: true, // Set shrinkWrap to true
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                  title: snapshot.data![index].title!,
                                  imageUrl: snapshot.data![index].image!,
                                  description:
                                      snapshot.data![index].description!,
                                  price: snapshot.data![index].price!),
                            ));
                      },
                      child: productDetail(size, snapshot, index));
                },
              );
            }
          },
        ),
      ),
    );
  }

  Container productDetail(
      Size size, AsyncSnapshot<List<Fake>> snapshot, int index) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              height: size.height * 0.17,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  image: DecorationImage(
                      image: NetworkImage(snapshot.data![index].image!),
                      fit: BoxFit.contain)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              snapshot.data![index].title!,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              snapshot.data![index].description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  '\$ ${snapshot.data![index].price!.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.trolley),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
