Pod::Spec.new do |s|
  s.name         = "Typographizer"
  s.version      = "0.1.0"
  s.summary      = "Smart Quotes for Swift Apps."
  s.description  = <<-DESC
                     Typographizer turns those pesky dumb quotes (""/'') and apostrophes (') into their beautiful,
                     curly, localized counterparts. Because good typography uses smart quotes, not dumb quotes
                     and we should not let the internet kill smart quotes. Speaking of smartness: Typographizer is smart
                     enough to skip HTML tags and everything between certain tags (like <code> and <pre>).
                   DESC
  s.homepage     = "https://github.com/frankrausch/Typographizer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = { 'Frank Rausch' => 'git@frankrausch.com' }

  s.source       = { :git => "https://github.com/frankrausch/Typographizer.git", :tag => "#{s.version}" }
  s.source_files = "Typographizer/*.{swift}"

  s.ios.deployment_target     = "8.0"
  s.osx.deployment_target     = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target    = "9.0"

  spec.cocoapods_version = '>= 1.2.0'
end
