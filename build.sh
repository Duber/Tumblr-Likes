./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee src/contentContext.coffee
./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee likes.coffee src/contentHelper.coffee
./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee likes.coffee src/header.coffee
./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee likes.coffee src/like.coffee
./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee likes.coffee src/unlike.coffee
./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee likes.coffee src/program.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ src/login.coffee
./node_modules/coffee-script/bin/coffee -o assets/js/ likes.coffee
rm likes.coffee
