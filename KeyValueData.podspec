Pod::Spec.new do |s|
  s.name             = 'KeyValueData'
  s.version          = '1.0.2'
  s.summary          = 'Key-Value data store protocol.'

  s.description      = <<-DESC
This is designed to code with same protocol but store data to many places.
Include .plist, KeyChain, UserDefault as well as Sqlite.
                       DESC

  s.homepage         = 'https://github.com/1fr3dg/KeyValueData'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alfred Gao' => 'alfredg@alfredg.cn' }
  s.source           = { :git => 'https://github.com/1fr3dg/KeyValueData.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'KeyValueData/Classes/**/*'
  
  s.dependency 'KeychainAccess', '~> 3.0'
  s.dependency 'SQLite.swift', '~> 0.11'
end
