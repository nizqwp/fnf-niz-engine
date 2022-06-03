var parser = require('osu-parser');

parser.parseFile('map.osu', function (err, beatmap) {
  console.log(beatmap);
 });