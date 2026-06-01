
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unnati_app/features/Volunteer_attendance.dart/attendance_api_provider.dart';
import 'package:unnati_app/features/volunteer_home/components_volunteer_home/volunteer_card_util.dart';

class SelfAttendancePage extends ConsumerWidget {
  const SelfAttendancePage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedYear = ref.watch(selectedYearProvider);

    final overallAsync = ref.watch(
      userAttendanceProvider(
        (
          userId: userId,
          month: null,
          year: null,
        ),
      ),
    );

    final yearlyAsync = ref.watch(
      yearlyAttendanceProvider(
        (
          userId: userId,
          year: selectedYear,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 221, 221),

      appBar: AppBar(
        elevation: 2,
        foregroundColor: Colors.white,
        title: Text(
          'My Attendance',
          style: GoogleFonts.oswald(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 9, 12, 19),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              children: [
                Container(
                  height: 22.h,
                  width: 5.h,
                  color: const Color.fromARGB(255, 11, 2, 57),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Attendance Summary",
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            overallAsync.when(
              data: (data) {
                return 
                    Row(
                      children: [
                        Expanded(
                          child: VolunteerCardUtil(
                            title: "Total Workshops Taken",
                            subtitle:
                                "${data["presentCount"] ?? 0}",
                            curvedColor: Colors.lightBlueAccent,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: VolunteerCardUtil(
                            title: "Total Workshops Missed",
                            subtitle:
                                "${data["absentCount"] ?? 0}",
                            curvedColor: Colors.black,
                          ),
                        ),
                      ],
                    );
                  
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, s) => Text(e.toString()),
            ),

             SizedBox(height: 38.h),

            /// ================= YEAR DROPDOWN =================
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              children: [
                Container(
                  height: 22.h,
                  width: 5.h,
                  color: const Color.fromARGB(255, 11, 2, 57),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Monthwise Stats",
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(
                    5,
                    (index) {
                      final year =
                          DateTime.now().year - index;

                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    },
                  ),
                  onChanged: (value) {
                    ref
                        .read(
                          selectedYearProvider.notifier,
                        )
                        .state = value!;
                  },
                ),
              ],
            ),

             SizedBox(height: 20.h),

            /// ================= BAR CHART =================

            yearlyAsync.when(
              data: (data) {
                return Container(
                  padding: const EdgeInsets.only( right: 17, top: 20, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 300.h,
                    child: BarChart(
                      BarChartData(
                        borderData:
                            FlBorderData(
                              show: true,
                              border:  Border(
                                left: BorderSide(
                                  color: Colors.grey.withOpacity(.5),
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Colors.grey.withOpacity(.5),
                                  width: 1,
                                ),
                              ),
                            ),
                    
                        gridData:
                            FlGridData(
                              show: false,
                              drawVerticalLine: false,
                            ),
                    
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: false),
                          ),
                    
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                    
                              getTitlesWidget:
                                  (value, meta) {
                                const months = [
                                  "J",
                                  "F",
                                  "M",
                                  "A",
                                  "M",
                                  "J",
                                  "J",
                                  "A",
                                  "S",
                                  "O",
                                  "N",
                                  "D",
                                ];
                    
                                if (value < 1 ||
                                    value > 12) {
                                  return const SizedBox();
                                }
                    
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(
                                    top: 8,
                                  ),
                                  child: Text(
                                    months[
                                        value.toInt() - 1],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    
                        barGroups:
                            data.map<BarChartGroupData>(
                          (monthData) {
                            return BarChartGroupData(
                              x: monthData["month"],
                    
                              barRods: [
                                BarChartRodData(
                                  toY:
                                      (monthData["present"]
                                              as num)
                                          .toDouble(),
                                  width: 18,
                                  color: Colors.lightBlueAccent,
                                  borderRadius:
                                      const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, s) => Text(e.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

// /// ================= STAT CARD =================

// class _StatCard extends StatelessWidget {
//   const _StatCard({
//     required this.title,
//     required this.value,
//     required this.color,
//     required this.icon,
//   });

//   final String title;
//   final String value;
//   final Color color;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding:
//             const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 18,
//         ),
//         child: Column(
//           children: [

//             Icon(
//               icon,
//               color: color,
//               size: 28,
//             ),

//             const SizedBox(height: 10),

//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 5),

//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }
// }