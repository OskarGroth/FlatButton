Pod::Spec.new do |s|

s.name              = 'FlatButton'
s.version           = '0.0.6'
s.summary           = 'Layer based NSButton with Interface Builder exposed style options'
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
s.screenshot   = "https://s3.amazonaws.com/cindori/images/flatbutton.png"
s.social_media_url = "https://twitter.com/cindoriapps"

end
