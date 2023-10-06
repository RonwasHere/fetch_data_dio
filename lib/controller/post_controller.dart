import 'package:fetch_data_dio/model/post_model.dart';
import 'package:fetch_data_dio/service/dio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class PostController extends GetxController {
  RxList<PostModel> posts = RxList();
  RxBool isLoading = true.obs;
  RxBool isInternetConnect = true.obs;
  RxBool isListViewScrollToDown = false.obs;

  var url = "https://jsonplaceholder.typicode.com/posts";
  var itemScrollController = ItemScrollController();

  getPosts() async {
    isInternetConnectFunc();
    isLoading = true.obs;
    var response = await DioService().getMethod(url);

    if (response.statusCode == 200) {
      response.data.forEach((element) {
        posts.add(PostModel.fromJson(element));
      });

      isLoading = false.obs;
    }
  }

  isInternetConnectFunc() async {
    isInternetConnect.value = await InternetConnectionChecker().hasConnection;
  }

  
  scrollListViewDownWard() {
    itemScrollController.scrollTo(
      index: posts.length,
      duration: Duration(milliseconds: 2000),
      curve: Curves.fastOutSlowIn,
    );
    isListViewScrollToDown.value = true;
  }

  scrollListViewUpWard() {
    itemScrollController.scrollTo(
      index: 0,
      duration: Duration(milliseconds: 2000),
      curve: Curves.fastOutSlowIn,
    );
    isListViewScrollToDown.value = false;
  }

  @override
  void onInit() {
    isInternetConnectFunc();
    getPosts();
    super.onInit();
  }
}
