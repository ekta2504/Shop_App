import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context, builder: (ctx) =>
                    AlertDialog(title: Text('Are you sure you want to delete?'),
                      actions: <Widget>[TextButton(
                        child: Text('No'), onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },),
                        TextButton(child: Text('Yes'), onPressed: () {
                          Navigator.of(ctx).pop(true);
                          Provider.of<Products>(context, listen: false).deleteProduct(id);
                        },),
                      ],),);
               // Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme
                  .of(context)
                  .errorColor,
            )
          ],
        ),
      ),
    );
  }
}