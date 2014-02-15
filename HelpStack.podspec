Pod::Spec.new do |s|
  s.name         = "HelpStack"
  s.version      = "1.0"
  s.summary      = "HelpStack is a free, open source and customisable Support Framework for iOS"

  s.description  = <<-DESC
                   HelpStack can connect with your helpdesk account and provide helpscreens for your app.

                   * Shows Knowledgebase articles
                   * Let users create issues inside your app
                   * Embeds device information and Screenshots in every issue created by user
                   * Works with: HappyFox, ZenDesk and Desk.com account.
                   * Needs: iOS 7 
                   DESC

  s.homepage     = "http://happyfox.com/helpstack"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = { "anand" => "anand@tenmiles.com", "nalin" => "nalin@tenmiles.com", "santhana" => "santhana@tenmiles.com" }
  s.social_media_url = "http://twitter.com/helpstack"
  s.platform     = :ios, '7.0'
  
  s.frameworks = "UIkit", "CoreGraphics", "Foundation", "MessageUI"

  s.source       = { :git => "http://github.com/happyfoxinc/HelpStack.git", :tag => "0.0.1" }
  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.resources = ["Resources/*.png", "Resources/*.storyboard"]

  s.requires_arc = true

  s.dependency 'AFNetworking', '~> 2.0.0'

end
