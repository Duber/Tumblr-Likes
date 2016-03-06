./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee scripts/ContentContext.coffee scripts/ContentHelper.coffee scripts/Likes.coffee
coffee -o assets/js/ likes.coffee
coffee -o assets/js/ scripts/LikesLogin.coffee
rm likes.coffee
