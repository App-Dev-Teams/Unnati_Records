import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unnati_app/components/youtube_data.dart';
import 'package:unnati_app/components/youtube_helper.dart';

class MyCarouselSlider extends StatelessWidget {
  const MyCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: youtubeUrls.length, //no of videos

      itemBuilder: (context, index, realIndex) {
        final url = youtubeUrls[index]; //fetching url
        final videoId = extractYoutubeVideoId(url); //fetching videoId
        if (videoId == null) {
          //if videoId broken
          return const Center(child: Text("Oopes something went wrong"));
        }
        //thumbnail
        final thumbnailUrl =
            "https://img.youtube.com/vi/$videoId/hqdefault.jpg";
        return GestureDetector(
          onTap: () {
            openyoutubeVideo(videoId);
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              //thumbnail card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16/9.r,
                    child: Image.network(
                      thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    
                      //late loading thumbnail
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                    
                        return Container(
                          color: Colors.black12,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      //net off / or any error with thumbnail
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 300.w,
                          color: Colors.black26,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(
                                Icons.wifi_off,
                                color: Color.fromARGB(137, 255, 0, 0),
                                size: 40,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "No Internet",
                                style: TextStyle(
                                  color: Color.fromARGB(137, 255, 0, 0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              //play button
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.play_arrow, color: Colors.white, size: 40.r),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions( //carousel Settings
        height: 220.h,
        enlargeCenterPage: true,
        viewportFraction: 0.75,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
      ),
    );
  }
}
