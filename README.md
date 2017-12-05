# appimagedl
WIP! Easily download AppImages and keep them up to date.  Uses https://appimage.github.io/feed.json to get information about available AppImages.

#### TODO:

- [x] ~~Finish 'update' argument to add support for AppImages that can be updated using 'appimageupdatetool'.  Currently these AppImages are not updated at all.  Plan on finishing this before anything else.~~

- [ ] Test updates with appimageupdatetool to make sure everything works as intended.

- [ ] Add 'get' argument to download AppImages to a configurable GET_DIR.  AppImages downloaded this way will not be managed by appimagedl.  'get' argument will also be able to download previous versions instead of just the latest release like the 'download' argument.

- [x] ~~Add 'revert' argument to revert updated AppImages in case of problems with the current version if the previous version is still stored.  Plan on storing 5 AppImages in CONFIG_DIR/downgrades for use with this argument.~~

- [ ] Add a man page.

- [ ] Build an AppImage of appimagedl.

![appimagedl-screenshot](/Screenshot.png)
