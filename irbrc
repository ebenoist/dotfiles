require "irb/completion"
require "pp"
require "irb/ext/save-history"

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV["HOME"]}/.irb-save-history"
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT] = true

def method_source(klass, method, limit = 20)
  method = klass.method(method)
  path = method.source_location[0]
  line = method.source_location[1]
  print File.read(path).lines.drop(line - 1).take(limit).join
end
