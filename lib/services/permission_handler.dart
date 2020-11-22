// TODO Consider use another package for permission handling, since the one provided with file_picker package is somehow limited.
// Future checkPermissions() async {
//   final PermissionStatus mobilePermissions = await Permission.storage.status ?? PermissionStatus.undetermined;
//   if (mobilePermissions.isUndetermined) {
//     await Permission.storage.request().then<void>((PermissionStatus status) async {
//       if (status == PermissionStatus.granted) {
//         return;
//       } else {
//         await Permission.storage.shouldShowRequestRationale;
//       }
//     });
//   } else if (mobilePermissions.isGranted) {
//     return;
//   } else if (mobilePermissions.isDenied) {
//     await Permission.storage.shouldShowRequestRationale;
//   } else {
//     await openAppSettings();
// }
// }
