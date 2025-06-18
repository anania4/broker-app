import '../models/connectionhistoryModel.dart';
import 'package:delalochu/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserprofileItemWidget extends StatelessWidget {
  UserprofileItemWidget(
    // this.userprofileItemModelObj,
    this.connections, {
    Key? key,
  }) : super(
          key: key,
        );

  // UserprofileItemModel userprofileItemModelObj;
  Connection connections;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 19.h,
        vertical: 21.v,
      ),
      decoration: AppDecoration.outlineBlack900,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imageNotFound,
            height: 60.adaptSize,
            width: 60.adaptSize,
            radius: BorderRadius.circular(
              30.h,
            ),
            margin: EdgeInsets.only(
              top: 2.v,
              bottom: 7.v,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 19.h,
              top: 2.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connections.user != null
                      ? connections.user!.fullName != null
                          ? connections.user!.fullName!
                          : ''
                      : '',
                  style: TextStyle(
                    color: appTheme.blueGray400,
                    fontSize: 20.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.v),
                Text(
                  connections.user != null
                      ? connections.user!.phone != null
                          ? connections.user!.phone!
                          : ''
                      : '',
                  style: TextStyle(
                    color: appTheme.blueGray400,
                    fontSize: 20.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status:",
                      style: TextStyle(
                        color: appTheme.blueGray400,
                        fontSize: 20.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        connections.status != null ? connections.status! : '',
                        style: TextStyle(
                          color: appTheme.blueGray400,
                          fontSize: 20.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Created Date:",
                      style: TextStyle(
                        color: appTheme.blueGray400,
                        fontSize: 20.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        connections.createdAt != null
                            ? '${connections.user!.createdAt!.year.toString()}-${connections.user!.createdAt!.month.toString()}-${connections.user!.createdAt!.day.toString()}'
                            : '',
                        style: TextStyle(
                          color: appTheme.blueGray400,
                          fontSize: 20.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
