import 'package:doogo/screen/info_screen.dart';
import 'package:flutter/material.dart';

class product extends StatelessWidget {
  final String url;
  final String name;
  final String sort;
  final String price;
  final String priceNegotiate;
  final String allmMembers;
  final String monthSales;
  final String domainName;
  final String siteName;
  final String id;
  final bool? admin;
  final VoidCallback reset;

  final String memberopen;
  final String monthopen;

  const product(
      {Key? key,
      required this.url,
      required this.name,
      required this.sort,
      required this.price,
      required this.priceNegotiate,
      required this.allmMembers,
      required this.monthSales,
      required this.domainName,
      required this.siteName,
      required this.id,
      this.admin,
      required this.reset,
      required this.memberopen,
      required this.monthopen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () async {
          final response = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InfoScreen(
                      userId: id,
                      contentName: name,
                      domainName: domainName,
                      siteName: siteName,
                      admin: admin)));

          if (response == "ok") {
            reset!();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Image.network(
                    url,
                    fit: BoxFit.fill,
                    width: 130,
                    height: 110,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 140,
                        height: 110,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "asset/img/$sort.png",
                              width: 15,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "$price",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Image.asset("asset/img/dallar.png", width: 13),
                            SizedBox(
                              width: 8,
                            ),
                            priceNegotiate == "ok"
                                ? Text(
                                    "협상",
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 12),
                                  )
                                : Text("비 협상",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[500])),
                            SizedBox(
                              width: 8,
                            ),
                            Text("on",style: TextStyle(
                              fontSize: 10,color: Colors.green
                            ),)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        memberopen == "ok"
                            ? Text("모든 회원 : $allmMembers",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500]))
                            : Text("모든 회원 : private",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500])),
                        monthopen == "ok"
                            ? Row(
                                children: [
                                  Text("연간 판매 : $monthSales",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500])),
                                  Image.asset(
                                    "asset/img/dallar.png",
                                    width: 10,
                                  )
                                ],
                              )
                            : Text("연간 판매 : private",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[500])),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                height: 1,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}
