./node_modules/coffeescript-concat/coffeescript-concat -o likes.coffee scripts/ContentContext.coffee scripts/ContentHelper.coffee scripts/Header.coffee scripts/Like.coffee scripts/Unlike.coffee scripts/Program.coffee
coffee -o assets/js/ scripts/Login.coffee
coffee -o assets/js/ likes.coffee
rm likes.coffee
