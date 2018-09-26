Pod::Spec.new do |s|
  s.name         = "PromptRating"
  s.version      = "1.0.0"
  s.summary      = "The most baroque prompt rating."

  s.description  = <<-DESC
                   Provides a set of tools to specify rules and events that trigger a prompt rating, and how they should evolve for different user answers.
                   DESC

  s.homepage     = "https://github.schibsted.io/gil-serra/ios-ij-PromptRating"
  s.license      = { "type" => "Proprietary", "text" => "Copyright Schibsted All rights reserved.\n\n" }
  s.author       = "Schibsted"

  s.platform     = :ios, "8.0"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

  s.source       = { :git => "https://github.schibsted.io/gil-serra/ios-ij-PromptRating"}
  s.source_files  = "PromptRating/**/*.swift"
  s.resources = "PromptRating/Resources/**/*{.xcassets,.xib}"
  s.requires_arc = true

end
