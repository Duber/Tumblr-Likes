./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee scripts/ContentContext.coffee scripts/ContentHelper.coffee scripts/Header.coffee scripts/Likes.coffee
coffee -o assets/js/ scripts/LikesLogin.coffee
coffee -o assets/js/ likes.coffee
rm likes.coffee
