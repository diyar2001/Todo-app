import 'package:flutter/material.dart';
import 'package:sql_todo_app/databses/helper.dart';
import 'package:sql_todo_app/pages/tasks.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  List<String> urls = [
        'https://imgs.search.brave.com/84GMpuYfI1pAtF9kEg4lrQ1XpBxRyc4Mri7lV0EqW9c/rs:fit:626:626:1/g:ce/aHR0cHM6Ly9pbWFn/ZS5mcmVlcGlrLmNv/bS9mcmVlLWljb24v/aG9tZXdvcmtfMzE4/LTIzNDMyLmpwZw',
        'https://imgs.search.brave.com/K9aNL4HjIMsKC19uiF30InaIdL-f1ux-MbGObZPqpw8/rs:fit:474:225:1/g:ce/aHR0cHM6Ly90c2Ux/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5P/VUlDMC1OMXB3Qjky/bVBPbWNENnFnSGFI/YSZwaWQ9QXBp',
        'https://imgs.search.brave.com/XsRu0lgTLnuHHss62teDUC69S4C1cnVJtqgm_hrMFCg/rs:fit:476:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5D/TWZLQlBCWUhDTURs/ZG8xUGk5SWdBSGFI/WSZwaWQ9QXBp',
        'https://imgs.search.brave.com/I-O57DLLUv5pIje8-u333-WisU-7JXDpuJlPmvgktqU/rs:fit:401:225:1/g:ce/aHR0cHM6Ly90c2U0/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5a/QVRPUjc2cmh2Rlcy/a19oOXMxSl9nQUFB/QSZwaWQ9QXBp',
  ];
  void initanimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_animationController!);
    _animationController!.forward();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Sqlhelper.getdb();
    initanimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: IconButton(
              onPressed: (()=>null),
              icon: Icon(Icons.menu, color: Colors.black, size: 40),
            ),
            backgroundColor: Color.fromARGB(255, 255, 243, 134),
            elevation: 0),
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 243, 134),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(120),
                    bottomRight: Radius.circular(120))),
          ),
          Column(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    StreamBuilder(
                        stream: Sqlhelper.getcategory().asStream(),
                        builder: ((context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                                '${snapshot.data[0]['category'].toString()} you have ${snapshot.data[0]['count(task)'].toString()} tasks',
                                style: TextStyle(fontSize: 18));
                          } else
                            return Text('');
                        }))
                  ],
                ),
                trailing: SizedBox(
                  height: 100,
                  child: SizedBox(
                      width: 70,
                      child: Image.network(
                          'https://imgs.search.brave.com/yP_lAhpF8280R52U0Y9NwCN5xsxX3z5cd1Kcx1Q6TLI/rs:fit:461:225:1/g:ce/aHR0cHM6Ly90c2Ux/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5j/eGNxYTlSdmhHblJk/OHgzTjJvQmRnSGFI/biZwaWQ9QXBp')),
                ),
              ),
            ),
            Expanded(
                child: StreamBuilder(
              stream: Sqlhelper.getcategory().asStream(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return AnimatedList(
                      initialItemCount: snapshot.data.length,
                      itemBuilder: ((context, index, animation) =>
                          SlideTransition(
                            position: _animation!,
                            child: _itemcontainer(
                                 urls[index],
                                '${snapshot.data[index]['category']}',
                                '${(snapshot.data[index]['count(task)']-1)}',
                                context,
                                index),
                          )));
                } else {
                  return Text('');
                }
              },
            ))
          ]),
        ]));
  }

  Widget _itemcontainer(String url, String title, String subtitle,
      BuildContext context, int currentindex) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                blurRadius: 12,
                color: Color.fromARGB(255, 187, 186, 186),
                offset: Offset(0, 2),
                spreadRadius: 1)
          ]),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 30),
      child: ListTile(
        trailing: Column(
          children: [popupbutton()],
        ),
        minLeadingWidth: 12,
        title: Text(
          title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 20),
        ),
        leading: SizedBox(
          width: 60,
          child: Image.network(url, fit: BoxFit.fill),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => Todo(title.toString(), currentindex)))),
      ),
    );
  }

  Widget popupbutton() {
    final lis = <PopupMenuItem<String>>[
      PopupMenuItem(
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: null,
          ),
          value: 'two'),
      PopupMenuItem(
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: null,
          ),
          value: 'three'),
    ];
    return PopupMenuButton(
      constraints: BoxConstraints(maxWidth: 70),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      itemBuilder: (context) => lis,
      child: Icon(Icons.more_vert),
    );
  }
}
