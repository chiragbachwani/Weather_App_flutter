import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'const/icons.dart';
import 'const/strings.dart';
import 'controllers/main_controller.dart';
import 'models/current_weather_model.dart';
import 'models/hourly_weather_model.dart';
import 'our_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Weather App',
      theme: CustomThemes.lighttheme,
      darkTheme: CustomThemes.darktheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(MainController());
    var theme = Theme.of(context);
    var date = DateFormat("yMMMMd").format(DateTime.now());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: date.text.color(theme.primaryColor).make(),
        actions: [
          Obx(
            () => IconButton(
                onPressed: () {
                  controller.changeTheme();
                },
                icon: Icon(
                  controller.isDark.value ? Icons.light_mode : Icons.dark_mode,
                  color: theme.iconTheme.color,
                )),
          ),
          IconButton(
            onPressed: () {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset topLeftPosition =
                  button.localToGlobal(Offset.zero, ancestor: overlay);

              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(
                  overlay.size.width, // left
                  -topLeftPosition.dy, // top
                  0, // right
                  0, // bottom
                ),
                items: [
                  const PopupMenuItem(
                    child: Text('Developed by Chirag'),
                  ),
                ],
                elevation: 8.0,
              );
            },
            icon: Icon(
              Icons.info,
              color: theme.iconTheme.color,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isloaded.value == true
            ? Container(
                padding: const EdgeInsets.all(12),
                child: FutureBuilder(
                  future: controller.currentWeatherData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      CurrentWeatherData dt = snapshot.data;
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dt.name!.text.uppercase
                                .fontWeight(FontWeight.bold)
                                .letterSpacing(3)
                                .color(theme.primaryColor)
                                .size(32)
                                .make(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  "assets/${dt.weather![0].icon}.png",
                                  width: 90,
                                ),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: "${dt.main!.temp}$degree",
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 50,
                                      )),
                                  TextSpan(
                                      text: " ${dt.weather![0].main}",
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        letterSpacing: 3,
                                        fontSize: 14,
                                      )),
                                ]))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: null,
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    Icons.expand_less_rounded,
                                    color: theme.iconTheme.color,
                                  ),
                                  label: "${dt.main!.tempMax}$degree"
                                      .text
                                      .color(theme.iconTheme.color)
                                      .make(),
                                ),
                                TextButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.expand_more_rounded,
                                    color: theme.iconTheme.color,
                                  ),
                                  label: "${dt.main!.tempMin}$degree"
                                      .text
                                      .color(theme.iconTheme.color)
                                      .make(),
                                ),
                              ],
                            ),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(3, (index) {
                                var iconList = [clouds, humidity, windspeed];
                                var values = [
                                  "${dt.clouds!.all}%",
                                  "${dt.main!.humidity}%",
                                  "${dt.wind!.speed} km/h"
                                ];
                                return Column(
                                  children: [
                                    Image.asset(
                                      iconList[index],
                                      width: 60,
                                    )
                                        .box
                                        .padding(const EdgeInsets.all(8))
                                        .roundedSM
                                        .color(theme.cardColor)
                                        .make(),
                                    10.heightBox,
                                    values[index].text.gray400.make()
                                  ],
                                );
                              }),
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            FutureBuilder(
                              future: controller.hourlyWeatherData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  HourlyWeatherData hourlyData = snapshot.data;
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: hourlyData.list!.length > 6
                                          ? 6
                                          : hourlyData.list!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var time = DateFormat.jm().format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                hourlyData.list![index].dt!
                                                        .toInt() *
                                                    1000));
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              time.text
                                                  .color(theme.primaryColor)
                                                  .make(),
                                              Image.asset(
                                                "assets/${hourlyData.list![index].weather![0].icon}.png",
                                                width: 80,
                                              ),
                                              "${hourlyData.list![index].main!.temp}$degree"
                                                  .text
                                                  .color(theme.primaryColor)
                                                  .make(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Next 5 Days"
                                    .text
                                    .semiBold
                                    .color(theme.primaryColor)
                                    .size(16)
                                    .make(),
                              ],
                            ),
                            FutureBuilder(
                              future: controller.hourlyWeatherData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  HourlyWeatherData hourdata = snapshot.data;
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        var day = DateFormat("EEEE").format(
                                            DateTime.now().add(
                                                Duration(days: index + 1)));

                                        return Card(
                                          color: theme.cardColor,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: day.text.semiBold
                                                        .color(
                                                            theme.primaryColor)
                                                        .make()),
                                                Expanded(
                                                  child: TextButton.icon(
                                                    onPressed: null,
                                                    icon: Image.asset(
                                                      "assets/${hourdata.list![index + 12].weather![0].icon}.png",
                                                      width: 40,
                                                    ),
                                                    label:
                                                        "${hourdata.list![index + 8].main!.temp}$degree"
                                                            .text
                                                            .color(theme
                                                                .primaryColor)
                                                            .make(),
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          "${hourdata.list![index + 4].main!.tempMax}$degree /",
                                                      style: TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          " ${hourdata.list![index].main!.tempMin}$degree",
                                                      style: TextStyle(
                                                        color: theme
                                                            .iconTheme.color,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
