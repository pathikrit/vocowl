fs = require 'fs'
assert = require 'assert'

readLines = (fileName) -> fs.readFileSync(fileName, 'utf-8').split '\n'

dics = ['gre', 'gre_hf', 'sat1', 'sat2', 'toefl', 'toefl_hf', 'trial']
types = ['noun', 'verb', 'adjective', 'adverb']

lines = readLines 'words.csv'

dict = {}
desc = [] # desc[i] is info about dict[i] - last 2 bits of desc[i] denote type and the bits to its left denote dics

lines.forEach (line) ->
  tokens = line.split ','
  if tokens.length != 10
    console.log "Bad line: #{line}"
    return

  word = tokens[0]

  dict[desc.length] =
    word: word
    def: tokens[9]

  #console.log "Word with space: #{word}" if word.indexOf(' ') >= 0

  hash = types.indexOf tokens[8]
  hash |= 1<<(i + 3) for i in [1 .. dics.length] when tokens[i]

  desc.push hash

# Sanity check that we can parse
inferDic = (idx) -> if (hash>>(idx+4))&1 then '1' else ''
for hash, i in desc
  type = types[hash & 3]
  line = [dict[i].word, inferDic(0), inferDic(1), inferDic(2), inferDic(3), inferDic(4), inferDic(5), inferDic(6), type, dict[i].def]
  assert.equal lines[i], line.join ','

fs.writeFileSync 'desc.json', JSON.stringify desc
fs.writeFileSync 'dict.json', JSON.stringify dict
