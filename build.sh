./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee src/ContentContext.coffee src/ContentHelper.coffee src/Header.coffee src/Like.coffee src/Unlike.coffee src/Program.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ src/Login.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ likes.coffee
rm likes.coffee
