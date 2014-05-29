<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/Helpstack%20by%20Happyfox%20logos.png" alt="HelpStack" title="Logo">
</p>


**HelpStack** provides you with a simple way of adding a great in-App support for your iOS App users. You can integrate any of your favorite HelpDesk solution at ease. It currently comes with three plugged in Help desk solutions - *Desk.com*, *Zendesk* and *HappyFox* along with customizable and simple UI to interact with the user. 

<p align="left" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/Screen%20Shot%202014-05-14%20at%202.46.10%20pm.png" alt="HelpStackthemes" title="screenshots">
</p>

## How to use Help Stack
Integrating HelpStack into your app is an easy three-step process:

1.	Install HelpStack and its dependencies 
2.	Configure your desired Help desk solution
3.	Customize the HelpStack UI with a simple plist file



### Getting started with Help Stack

Use Cocoa Pods to install HelpStack and its dependencies. HelpStack dependencies include AFNetworking 2.0.

	pod 'HelpStack'

HelpStack requires Xcode 5.0 targeting iOS 7 and above.

### Configuring Help Stack gears

#### 1. HappyFox Gear

To integrate your existing HappyFox account into HelpStack, you just have to include the following lines of code in your AppDelegate:

	
	HSHappyFoxGear *happyFoxGear = [[HSHappyFoxGear alloc] 
			initWithInstanceUrl  : @"https://example.happyfox.com" 
			apiKey               : @"<YOUR_API_KEY>" 
			authoCode            : @"<YOUR_AUTH_CODE>" 
			priorityID           : @"<PRIORITY_ID>" 
			categoryID           : @"<CATEGORY_ID>"];
    happyFoxGear.hfSectionID     = @"<SECTION_ID>";    // Optional
    
    HSHelpStack *helpStack = [HSHelpStack instance];
	helpStack.gear = happyFoxGear;

* Getting the API Key and Auth code

	Configuring HappyFox in HelpStack primarily requires the base URL, API Key and Auth code for authenticating the registered HappyFox user. 

	You will find the API key and Auth code in the ‘*Integrations*’ page of your HappyFox account under ‘*Manage*’. You can generate an API key and Auth code by clicking on the API configure link.

* Getting the Priority ID and Category ID

	HappyFox requires that the Priority ID and Category ID cannot be nil. This is the ID of the priority and the category with which tickets will be created when a customer reports an issue. 

		For Priorities and its IDs:
		<base_uri> / <response_format> /priorities/
	
		For categories and its IDs:
		<base_uri> / <response_format> /categories/

	Use API Key and Auth code for authentication.

	*Example:*
	
		https://example.happyfox.com/api/1.1/json/priorities/ 
		https://example.happyfox.com/api/1.1/json/categories/

* Getting the section ID (Optional)
	Section ID is to filter and show the Knowledge Based articles. If section ID is not provided, then all the KB articles in all the sections are fetched and showed. If you want HelpStack to fetch KB articles of a specific section, provide the appropriate section ID. The following URL command gives all the sections with their IDs.	

		For sections and its IDs:
		<base_uri> / <response_format> /kb/sections
		
	*Example:*
	
		https://example.happyfox.com/api/1.1/json/kb/sections/
	
	Use API key and Auth code for authentication.

#### 2. ZenDesk gear

To set up your existing ZenDesk account with HelpStack, just integrate the below lines of code in your AppDelegate.

	HSZenDeskGear *zenDeskGear  = [[HSZenDeskGear alloc] 
			initWithInstanceUrl : @"https://example.zendesk.com" 
			staffEmailAddress   : @"saff@example.com" 
			apiToken            : @"<API-KEY-HERE>" 
			localArticlePath    : @"<PATH-TO-ARTICLES>"];
	
	HSHelpStack *helpStack = [HSHelpStack instance];
	helpStack.gear = zenDeskGear;

where, **staff email address** is the email address of staff on behalf of whom ticket will be created.

* Getting the API Token

	The token can be found in your Zendesk account under *Settings* > *Channels* > *API*.

*	Providing FAQs

	Currently Zendesk does not provide an api to access FAQ/KB articles. It is soon to be [expected](https://support.zendesk.com/requests/531406). You can however provide your FAQ articles using a pList locally and you need to specify the path to the article when you configure Zendesk.
	

#### 3. Desk gear

To set up your Desk account with HelpStack, you need to integrate the following lines of code in your App delegate.

	HSDeskGear* deskGear = [[HSDeskGear alloc] 
			initWithInstanceBaseUrl : @"https://example.desk.com/" 
			toHelpEmail             : @"<Your email address>" 
			staffLoginEmail         : @"<Your Login Email>" 
			AndStaffLoginPassword   : @"<Your password>"];
	
	HSHelpStack *helpStack = [HSHelpStack instance];
    helpStack.gear = deskGear;
    
If you wish to provide your FAQs locally, you can provide it in the form of a pList file and specify the pList filename in the Desk Gear when you configure the same.
    
#### 4. Email gear

If you do not use any of the help desk solutions, you can still use HelpStack to provide efficient customer support by configuring with just your email. You can configure email support in Helpstack by including the below lines of code in your App delegate.

	HSGearEmail* emailGear = [[HSGearEmail alloc] 
			initWithSupportEmailAddress : @"support@example.com" 
			articlePath                 : @"<pList file name>"];
			
	HSHelpStack *helpStack = [HSHelpStack instance];
    helpStack.gear = emailGear;
    
You can provide your FAQs as a local pList file and provide the pList file name in place of *pList file name*.

<<<<<<< HEAD
* Adding an Articles pList file :

=======
>>>>>>> bc4fa6212da0fe2a44adb5ed3fe0db52f44b406f
### Shipping with Local Articles

You must note that since the FAQs/KB articles are being fetched from the server, it requires a network connection, in the absence of which your app may not be able to display the FAQs. With HelpStack, you can either configure your gear to fetch KB articles from server or you may provide them locally with a pList file. You will have to specify the pList file name when you configure the help desk solution as shown below:

	yourGear.localArticlePath = @"<FAQs file name>";
	
<<<<<<< HEAD
####[Download Sample FAQ pList](./Article/)
=======
Download a sample pList from here

####[Download Sample Article](./Article/)

>>>>>>> bc4fa6212da0fe2a44adb5ed3fe0db52f44b406f

### Showing your HelpStack

Once you have integrated your helpStack, use the **'showHelp'** API call to open up HelpStack to show up the FAQs or to report an Issue.

	@implementation MyViewController
	
		- (IBAction) onHelpPressed: (id)sender {
			[[HSHelpStack instance] showHelp:self];
		}


###Customizing Help Stack UI

HelpStack comes with built in screens with a default theme. It also comes with a set of pre configured themes, which you can download from the link below:

####[Download Themes](./Themes/)

You can start with one of these themes as your base. Download any of these pList files, include it in your project and rename it as required. In order to apply the themes for the HelpStack screens, include the following line of code when you configure HelpStack.

	[[HSHelpStack instance] setThemeFrompList:@"MyCustomThemeForHelpStack"];

#### How to Customize your theme plist

##### Basics

Certain pList properties must be provided in a pre-defined format as listed below:

* Color
	
	Specify colors by providing its R,G,B,alpha value separated by commas. e.g: **255,255,255,1.0** is white.
	
* Font
	
	The font name and font size are to be provided as two separate properties in the pList file. Fonts are to be specified by its font family name and font style. e.g: **Helvetica-Bold** The specified font size will be taken as 'pts' by default. 
Refer to [iosfonts.com](http://iosfonts.com) for the fonts supported by iOS.
	
* Image

	Images which are included in your project must be specified with their filenames. e.g: **example.png**
	
	
##### Customizing the Navigation Bar
	
	
These properties control the look of the NavigationBar across all the helpStack screens.

* NavigationBarAttributes
	
	**BackgroundColor** Navigation bar background color
	
	**BackgroundImage** Navigation bar background image, you either give an image or specify a color
	 
	**TitleFont** Navigation bar title Font
	 
	**TitleSize** Navigation bar title font size
	 
	**TitleColor** Navigation bar title font color
	 
	**ButtonTintColor** Navigation bar button tint color.

<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/11962138646_1ee89f5fb3_o.png" alt="HelpStacktheme" title="NavigationBar">
</p>

##### Customizing the Background

You can specify a background color or an image which is included in your resources directory to be set as the Background of all the helpStack screens.

**BackgroundImageName** Specify the name of the image included in your project, which has to be applied as the background 
	
**BackgroundColor** Background color. You can either specify a color or include an image.


##### Customizing the TableView

These tableView properties are applied to the main list view which shows up the FAQs and Issues.

* TableViewAttributes 

	**TableBackgroundColor** Background color of the Table View
	
	**SepertorColor** TableView separator Color
	
	**CellBackgroundColor** Background color of the cells
	
	**HeadingFont** Header Title font
		
	**HeadingSize** Header Title size
	
	**HeadingColor** Header Title color
	
	**HeadingBackgroundColor** Header background color

The cell title is a label which can be customized by providing LabelAttributes :

* LabelAttributes

	**BackgroundColor** Background color of the label. Ideally it would be better to give it as transparent.
	
	**LabelSize** Size of the label text
	 
	**LabelFont** Font of the label text
		
	**LabelColor** Color of the label text
	
<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/tableView%20copy.png" alt="HelpStackthemeCustomize" title="TableView">
</p>

##### Customizing the chat screen

These chat screen properties allows customization of the Issue conversation view. 

* ChatBubbleAttributes :

	**TextSize** Size of the text that appears within the left and the right chat bubbles.

	**TextFont** Font of the text that appears within the left and the right chat bubbles.

	**MessageInfoLabelFont**, **MesssageInfoLabelSize**, **MessageInfoLabelColor** Font, Size and Color of the message information shown above and below the chat bubbles which includes the sender name and timestamp.

The following attributes can be independantly customized for the right and the left chat bubbles :

   * LeftChatBubbleAttributes :
  
  	**BackgroundColor** Background Color of the left chat bubble.
  
  	**TextColor** Message Text color that appears within the left chat bubble.
  
   * RightChatBubbleAttributes :
  
  	**BackgroundColor** Background Color of the right chat bubble.
  
  	**TextColor** Message Text color that appears within the right chat bubble.
 

<p align="center" >
  <img src="https://dl.dropboxusercontent.com/u/55774910/HelpStack/chatScreen%20copy.png" alt="HelpStacktheme" title="ChatScreen">
</p>



## Contact

Follow HelpStack on Twitter ([@HelpStackSDK](https://twitter.com/HelpStackSDK/))


## License

HelpStack is available under the MIT license. See the LICENSE file for more info.
