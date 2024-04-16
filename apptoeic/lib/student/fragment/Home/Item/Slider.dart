import 'dart:async';
import 'dart:ffi';

import 'package:apptoeic/utils/constColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/config.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({super.key, required this.orientation});

  final orientation;

  @override
  State<SliderImage> createState() => _SliderState();
}

class _SliderState extends State<SliderImage> {
  //Slideshow
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _sliderImages = [
    Config.slider1,
    Config.slider2,
    Config.slider3,
    Config.slider4,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Bắt đầu slideshow sau 3 giây và chuyển trang sau 3 giây
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _sliderImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(_currentPage,
          duration: const Duration(microseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _slider = _sliderImages.map((image) {
      return Image.asset(
        image,
        fit: BoxFit.cover, // Căn chỉnh và cắt hình ảnh để vừa với kích thước
      );
    }).toList();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            
            width: widget.orientation == 1
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height,
            height: widget.orientation == 1
                ? MediaQuery.of(context).size.height * (1 / 4)
                : MediaQuery.of(context).size.width * (1 / 4), //0.5 ngang
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _slider,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          AnimatedSmoothIndicator(
            activeIndex: _currentPage,
            count: _slider.length,
            effect: const WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              spacing: 5,
              dotColor: Color.fromRGBO(217, 217, 217, 1),
              activeDotColor: darkblue,
              paintStyle: PaintingStyle.fill,
            ),
          )
        ],
      ),
    );
  }
}
