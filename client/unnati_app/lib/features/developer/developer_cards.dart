import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperCards extends StatelessWidget {
  final String name;
  final String devRole;
  final String desc;
  final String linkedInurl;
  final Color color;
  const DeveloperCards({
    Key? key,
    required this.name,
    required this.devRole,
    required this.desc,
    required this.linkedInurl,
    required this.color,
  }) : super(key: key);


Future<void> openLinkedIn()async{
  final Uri url = Uri.parse(linkedInurl);
   if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {

    throw Exception(
      "Could not launch URL",
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: (){
          openLinkedIn();
        },
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF111212), Color(0xFF2B3D54)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(20),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.person),
                ),
                title: Text(name,style: TextStyle(color: color,fontWeight: FontWeight.bold),),
                subtitle: Text(devRole,style: TextStyle(color: Colors.grey),),
              ),
              SizedBox(height: 10),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, Color(0xFF2B3D54)],
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(desc,style: TextStyle(color: Colors.white,),),
              SizedBox(height: 10,),
        
              //icon box
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link,color: color,size: 15,),
                    SizedBox(width: 10,),
                    Text(
                  "LinkedIn",
                  style: TextStyle(color: color),
                ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
