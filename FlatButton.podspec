Pod::Spec.new do |s|

s.name              = 'FlatButton'
s.version           = '1.4'
s.summary           = 'Layer based NSButton with Interface Builder styling options'
s.homepage          = 'https://github.com/OskarGroth/FlatButton'
s.license           = {
:type => 'MIT',
:file => 'LICENSE'
}
s.author            = {
'Oskar Groth' => 'oskar@cindori.org'
}
s.source            = {
:git => 'https://github.com/OskarGroth/FlatButton.git',
:tag => s.version.to_s
}
s.platform     = :osx, '10.9'
s.source_files = 'FlatButton/FlatButton.{swift}'
s.requires_arc = true
s.screenshot   = "https://raw.githubusercontent.com/OskarGroth/FlatButton/master/screenshot.png"
s.social_media_url = "https://twitter.com/cindoriapps"

end
