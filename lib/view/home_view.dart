import 'package:fetch_data_dio/controller/post_controller.dart';
import 'package:fetch_data_dio/service/dio_service.dart';
import 'package:fetch_data_dio/utils/colors.dart';
import 'package:fetch_data_dio/utils/constants.dart';
import 'package:fetch_data_dio/view/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    DioService().getMethod("https://jsonplaceholder.typicode.com/posts");

    PostController postController = Get.put(PostController());

    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: _buildAppBar(),
      floatingActionButton: Obx(() => postController.isInternetConnect.value
          ? FloatingActionButton(
              backgroundColor: MyColors.prColor,
              onPressed: () {
                postController.isListViewScrollToDown.value
                    ? postController.scrollListViewUpWard()
                    : postController.scrollListViewDownWard();
              },
              child: FaIcon(
                postController.isListViewScrollToDown.value
                    ? FontAwesomeIcons.arrowUp
                    : FontAwesomeIcons.arrowDown,
              ),
            )
          : Container()),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Obx(
          () => postController.isInternetConnect.value
              ? postController.isLoading.value
                  ? _buildLoading()
                  : _buildBody(postController)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: Lottie.asset('assets/b.json'),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (await InternetConnectionChecker().hasConnection == true) {
                            postController.getPosts();
                          } else {
                            // showTopSnackBar(
                            //   Overlay.of(context), 
                            showCustomSnackBar(context);
                           
                          }
                        },
                        color: MyColors.prColor,
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBody(PostController postController) {
    return RefreshIndicator(
      color: MyColors.prColor,
      onRefresh: () {
        return postController.getPosts();
      },
      child: ScrollablePositionedList.builder(
        itemScrollController: postController.itemScrollController,
        physics: BouncingScrollPhysics(),
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(DetailsView(index: index), transition: Transition.cupertino);
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(postController.posts[index].id.toString()),
                  ),
                ),
                title: Text(postController.posts[index].title.toString()),
                subtitle: Text(
                  postController.posts[index].body,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Center _buildLoading() {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset('assets/a.json'),
      ),
    );
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: MyColors.prColor,
      centerTitle: true,
      title: Text('Restfull Api -- DIO'),
    );
  }
}
