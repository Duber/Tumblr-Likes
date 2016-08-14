./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee src/contentContext.coffee src/contentHelper.coffee src/header.coffee src/like.coffee src/unlike.coffee src/program.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ src/login.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ likes.coffee
rm likes.coffee
