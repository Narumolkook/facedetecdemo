# **Face_and_ID_Card_Matching Project**

\[ TH \] : แอปพลิเคชั่นยืนยันตัวตนผ่านใบหน้าด้วยเทคโนโลยีปัญญาประดิษฐ์

\[ ENG \] : Face verification through Artificial Intelligence Application.

This project is to develop an identity verification application in terms of face guideline that can automatically take a photo when the face matches the specified guideline to be compared with the image on the ID card through the VAMStack api that offers a comparison service. face Then pull the results out and show them on the screen.

โครงการนี้เป็นการพัฒนาแอปพลิเคชันการยืนยันตัวตนในส่วนของการไกด์ไลน์ใบหน้าที่สามารถถ่ายภาพโดยอัตโนมัติเมื่อใบหน้าตรงกับไกด์ไลน์ที่กำหนดเพื่อนำมาเปรียบเทียบกับภาพบนบัตรประชาชนผ่าน VAMStack API ที่มีการให้บริการเปรียบเทียบใบหน้า จากนั้นดึงผลลัพธ์ออกมาแสดงบนหน้าจอ

# Document

It is a document for various operations.

  * [document1](https://www.dropbox.com/scl/fi/34ghgfcg1c5zgfs0oiaoy/.paper?rlkey=0aazup670fa85y12yhn52u5aj&dl=0)
  * [document2](https://www.dropbox.com/scl/fi/71uqkcr9mdogvmtz4v02m/kook.paper?rlkey=12ckk0g4lsnk4f15k7uhq5ycb&dl=0)

# Skills

The essential skills required for this project.

  * Dart
  * Flutter

# Component

 * **Hardware** **:**

   * Smartphone Android version 13 

 * **Software** **:**
   
   * Ubuntu 20.04.5 LTS
   * Flutter 3.3.0 Request Plugin
      * [tflite_flutter](https://pub.dev/packages/tflite_flutter) : ^0.9.0()
      * [camera](https://pub.dev/packages/camera) : ^0.10.0
      * [google_ml_kit](https://pub.dev/packages/google_ml_kit) : ^0.5.0
      * [image](https://pub.dev/packages/image) : ^3.0.2
      * [get_it](https://pub.dev/packages/get_it): ^7.2.0
      * [http](https://pub.dev/packages/http) : ^0.13.4
   * Dart version 2.18.0
   * Android Studio
     
     [how to install Flutter Dart and Android Studio](https://www.dropbox.com/scl/fi/lw551vjm25fpakkktqrko/Dart-Flutter-and-Android-Studio.paper?rlkey=w2yr47pb7iwd9ozwggrjaafhc&dl=0)

 * **Dev Tool**
   * VScode or Visual Studio Code version 1.67.0
  
# basic flutter commands

Command | Description
..... | .....
flutter build \<DIRECTORY\> | Flutter build commands.
flutter clean | Delete the build/ and .dart_tool/ directories.
flutter create \<DIRECTORY\> | Creates a new project.
flutter devices -d \<DEVICE_ID\> | List all connected devices.
flutter custom-devices list | Add, delete, list, and reset custom devices.
flutter doctor | Show information about the installed tooling.
flutter emulators | List, launch and create emulators.
flutter install -d \<DEVICE_ID\> | Install a Flutter app on an attached device.
flutter pub \<PUB_COMMAND\> | Works with packages. Use instead of dart pub.
flutter run | Runs a Flutter program.
flutter upgrade | Upgrade your copy of Flutter.

# Installation

Install the `Face_and_ID_Card_Matching Project` with the following command.

### Step : 1

Plaese clone the repository. 

```
git@github.com:Narumolkook/facedetecdemo.git
```

### Step : 2

After completing the repository clone, use the following command to navigate into the Folder Project.

```
cd project folder path
```

### Step : 3

After that, use the command `code ..` to open VScode.

```
code ..
```

### Step : 4

Once VScode is opened, execute the following command in the terminal. to install the plugin

```
flutter pub get
```

# Running Tests

After the device is connected, execute the following command to run tests.

```
flutter run
```
If the `flutter run` command is successful, you will see the following message below.

![Screenshot from 2023-07-02 02-43-45](https://github.com/Narumolkook/facedetecdemo/assets/105279093/32dc14bf-aba1-4aff-9107-21e9cda6451e)

# Support & Feedback

If there is a problem and need help or If you have any feedback, you can contact us at

**san.narumol@gmail.com**

# By

62050211 Narumol Sansao (Student), Faculty of Engineering, Burapha University, Department of Embedded Systems.





