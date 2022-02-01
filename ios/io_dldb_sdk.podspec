#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint io_dldb_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'io_dldb_sdk'
  s.version          = '0.9.7'
  s.summary          = 'flutter plugin for DLDB SDK'
  s.description      = <<-DESC
  DLDB provides behavioural analytics for mobile applications with privacy by design.
  DLDB architecture relies on an SDK to be integrated into a mobile application, and a dashboard https://dashboard.dldb.io/ to build, query and analyze the behaviour of the application users.
  For the application, DLDB deploys a distributed database, where each database instance is inside the mobile application scope. All the analytics queries are run by the devices and no raw data ever leaves the devices. Only the statistical KPI-s are sent to the DLDB dashboard.
  From the DLDB dashboard, developers, analysts and app owners can build their own queries and analyze the results. No need to have any additional storage or analytics platform: DLDB provides an end-to-end solution.
  DLDB SDK is written in C and has bindings to most common languages - works natively on iOS, and android, available as flutter plugin.
                       DESC
  s.homepage         = 'https://dldb.io'
  s.license = { :type => 'MIT', :text => <<-LICENSE
  The MIT License (MIT)
  Copyright © 2022 DLDB Oü  
  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
LICENSE
                  }
  s.author           = { 'Christophe, DLDB Oü' => 'support@dldb.io' }
  s.source       = { :git => "https://github.com/dldbdev/dldb_sdk_flutter.git", :tag => "v#{s.version}" }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.ios.dependency 'DLDB', '0.9.7'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
