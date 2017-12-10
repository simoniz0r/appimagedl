# appimagedl
WIP! Easily download AppImages and keep them up to date.  Uses https://appimage.github.io/feed.json to get information about available AppImages.

#### TODO:

- [x] ~~Finish 'update' argument to add support for AppImages that can be updated using 'appimageupdatetool'.  Currently these AppImages are not updated at all.  Plan on finishing this before anything else.~~

- [x] ~~Test updates with appimageupdatetool to make sure everything works as intended.~~

- [x] ~~Add 'get' argument to download AppImages to a configurable GET_DIR.  AppImages downloaded this way will not be managed by appimagedl.  'get' argument will also be able to download previous versions instead of just the latest release like the 'download' argument.~~

- [x] ~~Add 'revert' argument to revert updated AppImages in case of problems with the current version if the previous version is still stored.  Plan on storing 5 AppImages in CONFIG_DIR/downgrades for use with this argument.~~

- [ ] Add a tab completion file for zsh (and possibly bash also).

- [x] ~~Add a man page.~~

- [x] ~~Build an AppImage of appimagedl.~~

![appimagedl-screenshot](/Screenshot.png)

## About

appimagedl is a command line AppImage manager that integrates with [AppImageHub](https://appimage.github.io).
appimagedl uses https://appimage.github.io/feed.json to get information about
approved AppImages from AppImageHub.  If possible, 'appimageupdatetool' is used
to keep AppImages up to date.  Otherwise, 'jq' and 'wget' are used to get the latest
release information using Github's API.

appimagedl is not responsible for bugs within AppImages that have been
downloaded using appimagedl.  Please report any bugs that are specific to
downloaded AppImages to their maintainers.

## Arguments
    
    list|l      - list all available AppImages
    
    info|i      - output json file containing information for an AppImage
    
    download|dl - download an AppImage to $TARGET_DIR
    
    get         - download an AppImage to $GET_DIR without managing it
    
    remove|rm   - remove a downloaded AppImage
    
    update|up   - update list of AppImages and check downloaded AppImages for updates
    
    revert|rev  - revert an updated AppImage to its previous version if available
    
    freeze|fr   - mark or unmark an AppImage as FROZEN to preven update checks
    
    config|cf   - open appimagedl's config file with $EDITOR
    
    man|m       - show appimagedl man page
    
## Additional Aguments

    [list|info] --downloaded|-d   - show list or info for downloaded AppImages

    --verbose [option] [AppImage] - add bash option 'set -v' for verbose output

    --debug [option] [AppImage]   - add bash option 'set -x' for debugging

## Github Rate Limit

By default, Github's rate limit for API checks is 60 per hour.  When authenticated, the rate limit is increased to 5000 per hour.  To take advantage of the increased rate limit, it is suggested that you add your token to `appimagedl.conf`.

It is recommended that you do not give this token access to ***any*** scopes as it will be stored in plain text in your config file.  It may even be a good idea to create a throwaway account for use with this.

To use authenticated Github API checks with appimagedl, edit the following line in `~/.config/appimagedl/appimagedl.conf` to contain your token:
```
GITHUB_TOKEN="YOURTOKEN"
```

## What is an [AppImage](http://appimage.org)?

An AppImage is a downloadable file for Linux that contains an application and everything the application needs to run (e.g., libraries, icons, fonts, translations, etc.) that cannot be reasonably expected to be part of each target system.

