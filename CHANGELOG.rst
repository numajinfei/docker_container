^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for docker-container project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
2.1.2 (2024-06-21)
------------------
* new images: ros::noetic + cartographer environment.

2.1.1 (2023-08-28)
------------------
* update AI's dependence lib for PersonDetector and Measuring point planning.
* by: jadehu

2.1.0 (2023-08-25)
------------------
* platform: linux/amd64
* from ros:neotic(ubuntu20.04).
* recreate the ros1 build environment for NAV, AI, Chassis.
* container list:
    ros1-neotic:feature_build, is the common build environment;
    ros1-neotic:feature_test, based on ros1-neotic:feature_build, and compiled the chassis-project completely,
    it can run the chassis device derectly, and have the source code;
* Contributors: jadehu

