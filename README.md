# Help Stack
HelpStack provides you with a simple way of adding a great in-App support for your iOS App users. You can integrate any of your favorite HelpDesk solution at ease. It currently comes with three plugged in Help desk solutions - *Desk.com*, *Zendesk* and *HappyFox* along with customizable and simple UI to interact with the user. 

## How to use Help Stack
Integrating HelpStack into your app is an easy three-step process:

1.	Install HelpStack and its dependencies 
2.	Configure your desired Help desk solution
3.	Customize the HelpStack UI with a simple plist file

### Getting started with Help Stack

Use Cocoa Pods to install HelpStack and its dependencies. HelpStack dependencies include AFNetworking 2.0.

	Pod “HelpStack”

HelpStack requires Xcode 5.0 targeting iOS 7 and above.


### Configuring Help Stack gears

#### 1. HappyFox Gear

To integrate your existing HappyFox account into HelpStack, you just have to include the following lines of code in your AppDelegate:

	HSHelpStack *helpStack =[[HSHelpStack alloc] init];
	HSHappyFoxGear *happyfox = [[HSHappyFoxGear alloc] initWithInstanceUrl: @”https:example.happyfox.com” apiKey: @”<Your API-Key> authcode: @”<Your Auth Code>”];
	happyfox.hfPriorityID = @”<Priority ID>”;
	happyfox.hfCategoryID = @”<Category ID>”;
	happyfox.sectionID = @”<Section ID>”;
	helpStack.gear = happyfox;

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

You must note that since the FAQs/KB articles are being fetched from the server, it requires a network connection, in the absence of which your app may not be able to display the FAQs. With HelpStack, you can either configure your gear to fetch KB articles from server or you may provide them locally with a pList file. You will have to specify the pList file name when you configure the help desk solution as shown below:

	yourGear.localArticlePath = @"<FAQs file name>";

#### 2. ZenDesk gear

To set up your existing ZenDesk account with HelpStack, just integrate the below lines of code in your AppDelegate.

	HSZenDeskGear* zendDesk = [[HSZenDeskGear alloc] initWithInstanceUrl:@"https://example.zendesk.com/"];
	zendDesk.staffEmailAddress = @"saff@example.com";
	zendDesk.apiToken = @"<API-KEY-HERE>";
	zendDesk.localArticlePath = @"<PATH-TO-ARTICLES>";
	helpStack.gear = zendDesk;

where, **staff email address** is the email address of staff on behalf of whom ticket will be created.

* Getting the API Token

	The token can be found in your Zendesk account under *Settings* > *Channels* > *API*.

*	Providing FAQs

	Currently Zendesk does not provide an api to access FAQ/KB articles. It is soon to be [expected](https://support.zendesk.com/requests/531406). You can however provide your FAQ articles using a pList locally and you need to specify the path to the article when you configure Zendesk.
	

#### 3. Desk gear

To set up your Desk account with HelpStack, you need to integrate the following lines of code in your App delegate.

	HSDeskGear* deskGear = [[HSDeskGear alloc] initWithInstanceBaseUrl:@"https://example.desk.com/" toHelpEmail:@"<Your email address>" staffLoginEmail:@"<Your Login Email>" AndStaffLoginPassword:@"<Your password>"];
    helpStack.gear = deskGear;
    
If you wish to provide your FAQs locally, you can provide it in the form of a pList file and specify the pList filename in the Desk Gear when you configure the same.
    
#### 4. Email gear

If you do not use any of the help desk solutions, you can still use HelpStack to provide efficient customer support by configuring with just your email. You can configure email support in Helpstack by including the below lines of code in your App delegate.

	HAGearEmail* emailGear = [[HAGearEmail alloc] initWithSupportEmailAddress:@"support@example.com" articlePath:@"<pList file name>"];
    helpStack.gear = emailGear;
    
You can provide your FAQs as a local pList file and provide the pList file name in place of *pList file name*.

###Customizing Help Stack UI

HelpStack comes with built in screens to interact with the customers. You can customize the skin of HelpStack screens as per your App themes by providing a simple pList file. If not, it takes up the default HelpStack theme.

Certain pList properties must be provided in a pre-defined format as listed below:

* Colors
	
	Specify colors by providing its R,G,B,alpha value separated by commas. e.g: **255,255,255,1.0** is white.
	
* Fonts
	
	The font name and font size are to be provided as two separate properties in the pList file. Fonts are to be specified by its font family name and font style. e.g: **Helvetica-Bold** 
	
* Images

	Images which are included in your project must be specified with their filenames. e.g: **example.png**
	
You can download the **HSDefaultTheme.pList** file, include it in your project and edit the same to apply your custom skin settings.

* Navigation Bar

	You can customize the following navigationBar properties

	**BackgroundColor** Navigation bar background color
	
	**BackgroundImage** Navigation bar background image, you either give an image or specify a color
	 
	 **TitleFont** Navigation bar title Font
	 
	 **TitleSize** Navigation bar title font size
	 
	 **TitleColor** Navigation bar title font color
	 
	 **ButtonTintColor** Navigation bar button tint color. For iOS6, this property would be considered as the navigation bar button background color.
	 
![Navigation Bar customization](https://dl.dropboxusercontent.com/u/55774910/HelpStack/11962138646_1ee89f5fb3_o.png)


* TableView and Background Customization
	
	You can customize the background skin, which applies to all the screens and the table view properties
	
	**BackgroundImageName** Specify the name of the image included in your project, which has to be applied as the background 
	
	**BackgroundColor** Background color. You can either specify a color or include an image.
	
	TableView:
	
	**TableBackgroundColor** Background color of the Table View
	
	**SepertorColor** TableView separator Color
	
	**CellBackgroundColor** Background color of the cells
	
	**HeadingFont** Header Title font
	
	**HeadingSize** Header Title size
	
	**HeadingColor** Header Title color
	
	**HeadingBackgroundColor** Header background color
	
	The cell title is a label and it can be customized using the Label properties as below:
	
* LabelAttributes:
	
	**BackgroundColor** Background color of the label. Ideally it would be better to give it as transparent.
	
	**LabelSize** Size of the label text
	 
	**LabelFont** Font of the label text
		
	**LabelColor** Color of the label text
	
	![TableView and background customization](https://dl.dropboxusercontent.com/u/55774910/HelpStack/11961600503_28d7f2cc96_o.png)
	
* Chat screen customization

HelpStack comes with an intuitive Chat/Conversation screen and it allows you to completely customize it. If these properties are left unspecified, it takes up the properties of the default help stack theme.

![Chat screen customization](https://dl.dropboxusercontent.com/u/55774910/HelpStack/11962401933_e1a4225581_o.png)
   
  * ChatBubbleAttributes:
  
  	**TextSize** Size of the chat bubble text, this applies to both the left and the right chat bubbles
  	
  	**TextFont** Font of the chat bubble text, this applies to both the left and the right chat bubbles
  	
  	**MessageInfoLabelFont**, **MessageInfoLabelSize**, **MessageInfoLabelColor** font, size and color of the message information displayed above and below the chat bubbles such as timestamp and sender name
  	
  	* LeftChatBubbleAttributes and RightChatBubbleAttributes
  		
  		**BackgroundColor** Background color of the respective chat bubble
  		
  		**TextColor** Message text color of the respective chat bubble
  	
  	
  




	
	







