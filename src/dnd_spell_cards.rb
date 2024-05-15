#!/usr/bin/env ruby
require 'optparse'

require_relative 'spell_fetcher'
require_relative 'render'

@options = {
  :verbose => 0,
  :out => "cards.pdf",
  :color => "red",
}

OptionParser.new do |opts|
  opts.on("-v", "--verbose", "Increase log verbosity") do
    @options[:verbose] += 1
  end

  opts.on("-oFILE", "--out FILE", "Save the PDF to this file in the 'out' dir") do |file|
    @options[:out] = file
  end

  opts.on("--spells SPELLS", Array, "The spells to turn into cards") do |spells|
    @options[:spells_by_index] = spells
  end

  opts.on("-cCOLOR", "--color COLOR", "The color of the cards") do |color|
    @options[:color] = color
  end
end.parse!

fetcher = SpellFetcher.new

if @options.key? :spells_by_index
  spells = fetcher.fetch_by_index(@options[:spells_by_index])
else
  puts "No spells specified!"
  exit
end

render_cards spells, "out", @options[:out], @options[:color]
