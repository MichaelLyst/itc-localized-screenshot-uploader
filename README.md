iTC Localized Screenshot Uploader
=================================

This script helps prepare localized screenshots for delivery to iTunes Connect via the Transporter. Screenshot generation, formatting, and uploading for all languages can be fully automated with these instructions.

***

#### Step 1
Open your app in iTunes Connect and create a new version. Ensure your app is listed in the "Prepare for Submission" status. Download your app's metadata package from Apple using the download script. 

 > `download-metadata.sh`

This will save the .itmsp archive to the directory you specify, defaulting to `./itms/<bundleid?>itmsp`. You'll also find a new screenshots directory under there too.

#### Step 2
Take screenshots and save them to this new directory `./itms/screenshots-raw` with the format like

 > `en-GB___iOS-4-in___screen1.png`

This is comprised of case sensitive sections delimited by three underscores `___`:

 - Device: Correct names are (currently) `Mac`, `iOS-3.5-in`, `iOS-4-in`, `iOS-4.7-in`, `iOS-5.5-in` or `iOS-iPad`
 - Locale: like `es-ES`, `fr-FR`, `ja-JP`, `en-US`, `en-CA`, `en-GB`, `en-AU`, `cmn-Hans`, `cmn-Hant` **HELP: NEED HELP FULLY DOCUMENTING LOCALE NAMES IN ITMS**
 - Orientation: optional (`portrait`)
 - Screen: screenN where N is the ordering for it when uploaded `(1,2,3,4,5)`
 - Extension: always use .png 

Optional: write a UI script and automate generation of screenshots for all devices and localizations using https://github.com/jonathanpenn/ui-screen-shooter Note: if your screenshots are in the format `Locale/Devicename___other.png`, fix this with: `for a in */*; do d=$(dirname $a); f=$(basename $a); mv $a ${d}___${f}; done; rmdir */`

If you are unsure of any country codes, check the `metadata.xml` file that is downloaded in step 1

The files can be in subdirectories as they will be flatted in the next step

#### Step 3
Prepare the screenshots you have generated by running the verify script.

> `prepare-screenshots.sh`

This will make two copies of your screenshots, both flattened from the `screenshots-raw` version. One in the .itmsp package and one in screenshots. The ones in the package will be uploaded, the ones in screenshots are for the php script to act on. This should be improved to just one dir.

#### Step 4
Run `php screenshots.php` – this will add the XML chunks you need and write an updated copy of your `metadata.xml` in the `$ITMSFOLDERNAME` folder. A copy of what was actually generated will also be written to `xml_chunks_DEBUG.txt`. This can be discarded if not needed.

#### Step 5
Verify the content you have generated can be uploaded by running the verify script.

> `verify-metadata.sh`
    
Error "software_screenshots cannot be edited in the current state" happens if your app is currently being reviewed.

#### Step 6
All being well, you can perform the actual upload

> `upload-metadata.sh`

-----------------

## Pro Tips
You can modify Xcode schemes to automatically launch your app in a particular localization. I created a scheme for each language I have setup in iTunes Connect. To do this, duplicate your Debug scheme, edit it, and in the "Run" section under "Arguments", add your localization to "Arguments Passed on Launch" in this format: "-AppleLanguages (it)", where "it" is Italian, or whatever localization you want.

On top of that, I wanted localized users for my screenshots, so I pass an Environment Variable of "USER_ID", then grab that in my code & setup the user programmatically. You can get Environment Variables via:
[[NSProcessInfo processInfo] environment]

## Heads Up

There's a bug in the Transporter that removes newlines from any textual metadata, so I don't recommend using it for that purpose at this time.

For more info, check out the App Metadata Specs and the Transporter User Guide from https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/resources/download/TransporterQuickStartUserGuide/pdf

------------------

## License
Released under the MIT license, see the LICENSE file.
