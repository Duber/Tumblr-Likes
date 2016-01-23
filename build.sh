coffeescript-concat -o likes.coffee scripts/UQC.coffee scripts/ContentHelper.coffee scripts/Likes.coffee
coffee -o . likes.coffee
mv likes.js assets/js/likes.js
rm likes.coffee
