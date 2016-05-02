<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/Helpstack%20by%20Happyfox%20logos.png" alt="HelpStack" title="Logo">
</p>


**HelpStack** provides you with a simple way of adding a great in-App support for your iOS App users. You can integrate any of your favorite HelpDesk solution at ease.

HelpStack currently supports the following helpdesk solutions: 
- [HappyFox](https://www.happyfox.com/)
- [Zendesk](https://www.zendesk.com/)
- [Desk.com](http://www.desk.com/)
- Email - If you don't have a helpdesk solution, you can still configure HelpStack for users to raise requests via email.

The UI is also customizable so that it can go along with your app's theme.

<p align="left" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/Screen%20Shot%202014-05-14%20at%202.46.10%20pm.png" alt="HelpStackthemes" title="screenshots">
</p>

## How to progress with HelpStack
Checkout this wiki page if you want a clear idea on how you can progress with HelpStack: [Wiki - How to progress with HelpStack](https://github.com/happyfoxinc/helpstack/wiki/How-to-Progress-with-HelpStack)

## App Showcase
Have you made something awesome with HelpStack? Add yourself here: [App Showcase](https://github.com/happyfoxinc/helpstack/wiki/App-Showcase)

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/happyfoxinc/helpstack?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

## How to use HelpStack
Integrating HelpStack into your app is an easy 3-step process:

1.	Install HelpStack and its dependencies 
2.	Configure your desired Help desk solution
3.	Customize the UI of HelpStack with a simple plist file



### Installation

Use CocoaPods to install HelpStack and its dependencies. HelpStack dependencies include AFNetworking 2.0.

	pod 'HelpStack'

HelpStack requires Xcode 5.0 targeting iOS 7 and above.

### Configuring HelpStack gears

The general structure of a gear is as follows:

        <GearType> *<gearObject> = [[<GearType> alloc] 
                parameter1  : value1
                parameter2  : value2
                
                parameterN  : valueN ];
        
        HSHelpStack *helpStack = [HSHelpStack instance];
        helpStack.gear = <gearObject>;
        
HelpStack currently provides 4 different Gears. Follow the instructions below to configure the gear of your choice:

  - [HappyFox gear](https://github.com/happyfoxinc/helpstack/wiki/Configuring-gears-for-HelpStack#1-happyfox-gear)
  - [Zendesk gear](https://github.com/happyfoxinc/helpstack/wiki/Configuring-gears-for-HelpStack#2-zendesk-gear)
  - [Desk gear](https://github.com/happyfoxinc/helpstack/wiki/Configuring-gears-for-HelpStack#3-desk-gear)
  - [Email gear](https://github.com/happyfoxinc/helpstack/wiki/Configuring-gears-for-HelpStack#4-email-gear)
                


### Shipping with Local Articles

You must note that since the FAQs/KB articles are being fetched from the server, it requires a network connection, in the absence of which your app may not be able to display the FAQs. With HelpStack, you can either configure your gear to fetch KB articles from server or you may provide them locally with a pList file. You will have to specify the pList file name when you configure the help desk solution as shown below:

	yourGear.localArticlePath = @"<FAQs file name>";
	
####[Download Sample Article](./Article/)

### Showing your HelpStack

Once you have integrated your helpStack, use the **'showHelp'** API call to open up HelpStack to show up the FAQs or to report an Issue.

	@implementation MyViewController
	
		- (IBAction) onHelpPressed: (id)sender {
			[[HSHelpStack instance] showHelp:self];
		}

Using Swift, show HelpStack using the following invocation:

	let helpStack = HSHelpStack.instance() as HSHelpStack
        helpStack.showHelp(self)

###Customizing HelpStack UI

HelpStack comes with built in screens with a default theme. It also comes with a set of pre configured themes, which you can download from the link below:

####[Download Themes](./Themes/)

You can start with one of these themes as your base. Download any of these pList files, include it in your project and rename it as required. In order to apply the themes for the HelpStack screens, include the following line of code when you configure HelpStack.

	[[HSHelpStack instance] setThemeFrompList:@"MyCustomThemeForHelpStack"];

#### How to Customize your theme plist

##### Basics

Certain pList properties must be provided in a pre-defined format as listed below:

- **Color** - Specify colors by providing its R,G,B,alpha value separated by commas. e.g: **255,255,255,1.0** is white.
	
- **Font** - The font name and font size are to be provided as two separate properties in the pList file. Fonts are to be specified by its font family name and font style. e.g: **Helvetica-Bold** The specified font size will be taken as 'pts' by default. 
Refer to [iosfonts.com](http://iosfonts.com) for the fonts supported by iOS.
	
- **Image** - Images which are included in your project must be specified with their filenames. e.g: **example.png**
	
#### Customization

The following is a list of UI items you can customize, along with the instructions in the wiki:
  - [Navigation Bar](https://github.com/happyfoxinc/helpstack/wiki/Customization-Instructions#i-customizing-the-navigation-bar)
  - [Background](https://github.com/happyfoxinc/helpstack/wiki/Customization-Instructions#ii-customizing-the-background)
  - [TableView](https://github.com/happyfoxinc/helpstack/wiki/Customization-Instructions#iii-customizing-the-tableview)
  - [Chat screen](https://github.com/happyfoxinc/helpstack/wiki/Customization-Instructions#iv-customizing-the-chat-screen)
	
**Navigation Bar:**

<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/11962138646_1ee89f5fb3_o.png" alt="HelpStacktheme" title="NavigationBar">
</p>

**Table View:**
<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/tableView%20copy.png" alt="HelpStackthemeCustomize" title="TableView">
</p>

**Chat Screen:**
<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/chatScreen%20copy.png" alt="HelpStacktheme" title="ChatScreen">
</p>

## About
For more information about HelpStack, visit [helpstack.io](http://www.helpstack.io).

HelpStack is maintained by the folks at [HappyFox](http://www.happyfox.com/). Being an open source project, it also contains work from the HelpStack community.

<div align="center">
  <a href="http://www.happyfox.com" target="_blank"><img src="http://www.helpstack.io/startup/common-files/img/logos/happyfox.png" alt="HappyFox" width="160" ></a>
</div>

## Video

[![HelpStack for iOS](http://img.youtube.com/vi/0UvNO-Qm0AU/0.jpg)](https://www.youtube.com/watch?v=0UvNO-Qm0AUÂ)

## Contact

Reach out to us on Twitter at [@HelpStackSDK](https://twitter.com/HelpStackSDK).


## License

HelpStack is available under the MIT license. See the LICENSE file for more info.
